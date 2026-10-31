#!/usr/bin/env bash
# Render the resume Markdown to an HTML fragment for the site.
#
# The fragment is written to src/_includes/resume-body.html and wrapped by
# src/resume.njk, so the HTML version shares the site's layout and styles
# instead of carrying Pandoc's.
#
# Headings are shifted down one level so the page's own <h1> stays unique:
#   # Summary   ->  <h2>Summary</h2>
#   ## Athena   ->  <h3>Athena ...</h3>
#
# Usage: ./sync-resume.sh   (this runs as part of it)

set -euo pipefail
cd "$(dirname "$0")"

SRC=../resume_master.md
OUT=src/_includes/resume-body.html

if [ ! -f "$SRC" ]; then
  echo "error: $SRC not found" >&2
  exit 1
fi

pandoc "$SRC" \
  --from markdown \
  --to html5 \
  --shift-heading-level-by=1 \
  --wrap=none \
  -o "$OUT"

echo "rendered $OUT"
