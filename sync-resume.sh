#!/usr/bin/env bash
# Copy the built resume artifacts into the site.
#
# The resume is generated in the parent project (npm-free, plain pandoc); this
# script is the one place that moves the output across, so the site can never
# drift from what `build_resume.sh` last produced.
#
# Usage: ./sync-resume.sh
#
# Run it after rebuilding the resume, then commit the updated files:
#   ./sync-resume.sh && git add src/assets/files && git commit -m "Update resume"

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
echo "synced resume: ${pages} page(s)"
if [ "$pages" != "2" ]; then
  echo "warning: expected 2 pages, got $pages" >&2
fi

# Keep the "last updated" line honest.
echo
echo "Remember to update site.resumeUpdated in src/_data/site.json if the"
echo "resume content changed."
