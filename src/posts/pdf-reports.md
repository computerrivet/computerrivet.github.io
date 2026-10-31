---
title: Generating PDF reports from existing Razor pages
description: How a Playwright-based service turned an existing page into a downloadable, date-filtered report.
date: 2026-10-12
---

Most reporting features start with the wrong question: *how do I generate a PDF?*
The better question is *what do I already render?* If the answer is an HTML page,
you probably don't need a PDF library at all — you need something that can print
that page.

## The problem

We had a crossing-test page that already rendered exactly the report our users
wanted to download. Rebuilding that layout in a PDF library would have meant
maintaining two implementations of the same report, and keeping them visually in
sync forever.

## The approach

Render the HTML, hand it to a headless browser, and stream back the result:

1. A report endpoint accepts a date range and renders the existing page as HTML.
2. A background service loads Playwright and converts that HTML to PDF.
3. The endpoint streams the resulting file to the client.

Two details that mattered more than expected:

- **Start the browser once.** Launching Chromium per request dominates the
  response time. The renderer is a singleton, warm on startup.
- **Set a timeout.** A page that never finishes loading will otherwise hold a
  request open indefinitely.

## What I would change

If I did it again, I would go to a dedicated rendering container
(Gotenberg is the obvious candidate) rather than managing Playwright's browser
lifecycle inside the application. It moves the dependency out of the process,
makes upgrades independent of deployments, and avoids the startup cost entirely.

That said, the direct approach shipped, and shipping beat perfecting.
