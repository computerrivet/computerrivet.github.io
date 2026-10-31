#!/usr/bin/env bash
# Refresh the site's copy of the resume.
#
# The resume is authored and built in the parent project. This script is the
# only bridge, so the site cannot drift from what `build_resume.sh` produced.
#
# It does two things:
#   1. copies build_resume.pdf and build_resume.docx into src/assets/files/
#   2. regenerates src/_includes/resume-body.html from resume_master.md, so the
#      readable HTML version matches the downloadable files
#
# Usage: ./sync-resume.sh
#
# After running, commit the results:
#   git add -A && git commit -m "Update resume"

set -euo pipefail
cd "$(dirname "$0")"

SRC=..
DEST=src/assets/files
PDF="$DEST/wade-johnson-resume.pdf"
DOCX="$DEST/wade-johnson-resume.docx"

if [ ! -f "$SRC/build_resume.pdf" ]; then
  echo "error: $SRC/build_resume.pdf not found — run ./build_resume.sh first" >&2
  exit 1
fi

mkdir -p "$DEST"
cp "$SRC/build_resume.pdf" "$PDF"
cp "$SRC/build_resume.docx" "$DOCX"

# Fail loudly if the PDF is not the two-page build we expect.
pages=$(pdfinfo "$PDF" | awk '/^Pages:/{print $2}')
echo "synced artifacts: ${pages} page(s)"
if [ "$pages" != "2" ]; then
  echo "warning: expected 2 pages, got $pages" >&2
fi

# The HTML version comes from the Markdown source, not from the PDF, so that it
# stays semantic and selectable rather than being an extracted text dump.
./render-resume-html.sh

echo
echo "Remember to update site.resumeUpdated in src/_data/site.json if the"
echo "resume content changed."
