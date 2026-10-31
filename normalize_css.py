#!/usr/bin/env python3
"""Normalize style.css after an editor has reindented it.

The editor writes this file with 4-space indentation and explodes long
`font-family` lists one item per line. That produces huge, meaningless diffs.
This script restores 2-space indentation and collapses the font stack, matching
the original hand-written style.
"""

from __future__ import annotations

import sys
from pathlib import Path

FONT_STACK = (
    '  font-family: "Source Sans 3", -apple-system, BlinkMacSystemFont, "Segoe UI",\n'
    "    Roboto, Helvetica, Arial, sans-serif;"
)


def reindent(text: str) -> str:
    out = []
    for line in text.split("\n"):
        if not line.strip():
            out.append("")
            continue
        lead = len(line) - len(line.lstrip(" "))
        # Only touching declarations/at-rule bodies; 4 -> 2, 8 -> 4, etc.
        if lead and lead % 4 == 0:
            out.append(" " * (lead // 2) + line.lstrip(" "))
        else:
            out.append(line)
    return "\n".join(out)


def collapse_font_stack(text: str) -> str:
    marker = "  font-family:\n"
    start = text.find(marker)
    if start == -1:
        return text
    end = text.find(";", start)
    if end == -1:
        return text
    return text[:start] + FONT_STACK + text[end + 1 :]


def main(argv: list[str]) -> int:
    path = Path(argv[1] if len(argv) > 1 else "src/assets/style.css")
    text = path.read_text(encoding="utf-8")
    text = reindent(text)
    text = collapse_font_stack(text)
    path.write_text(text, encoding="utf-8", newline="\n")
    print(f"normalized {path}")
    return 0


if __name__ == "__main__":
    raise SystemExit(main(sys.argv))
