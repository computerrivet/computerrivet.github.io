# computerrivet.github.io

Personal site for Wade Johnson. Built with [Eleventy](https://www.11ty.dev/) 3,
Nunjucks templates, and hand-written CSS — no theme, no CSS framework.

## Commands

```bash
npm install     # once
npm run serve   # http://localhost:8080, rebuilds on save
npm run build   # static output in _site/
npm run clean   # remove _site/
```

## Structure

```
src/
  _data/site.json       site title, description, contact links, URL
  _includes/base.njk    the single page shell (head, header, footer)
  _includes/post.njk    article wrapper for posts
  index.njk             home page
  about.md              about page
  posts/
    posts.json          front-matter defaults for every post in the folder
    index.njk           the post list
    *.md                one file per post
  resume.njk            resume page with PDF/DOCX downloads
  feed.njk              Atom feed at /feed.xml
  404.md                not-found page
  assets/style.css      all styles
  assets/files/         the published resume PDF and DOCX
```

## Updating the resume

The resume is built in the parent project, not here. To publish a new version:

```bash
cd ..                 # the resume project
./build_resume.sh     # regenerate build_resume.pdf / .docx
cd website
./sync-resume.sh      # copy them into src/assets/files/
npm run build
git add -A && git commit -m "Update resume" && git push
```

`sync-resume.sh` verifies the PDF is two pages and warns if it isn't. It cannot
tell whether the _content_ changed, so update `resumeUpdated` in
`src/_data/site.json` when it has.

## Writing a post

Create `src/posts/your-slug.md`:

```markdown
---
title: Your title
description: One sentence, used for the post list and the feed.
date: 2026-11-01
---

Body text.
```

The URL is derived from the filename: `your-slug.md` becomes
`/posts/your-slug/`. To hide a post while drafting, add `draft: true` — it will
appear in `npm run serve` but be excluded from `npm run build`.

Note that `.njk` templates do **not** process Markdown. Use HTML tags
(`<h1>`, `<p>`) there, not `#` headings.

## Deployment

`.github/workflows/deploy.yml` builds and publishes to GitHub Pages on push to
`main`. In the repository settings, set Pages → Source to **GitHub Actions**.

If the site moves to a subpath rather than a domain root, set `pathPrefix` in
`eleventy.config.js` and the `HtmlBasePlugin` will rewrite URLs in the output.

## Design notes

- One column, ~38rem measure, no sidebar.
- System font stack starting with Source Sans 3, matching the resume PDF.
- Print styles strip navigation and download buttons so any page, including the
  resume page, can be saved as a clean PDF.
- No JavaScript at all.
