import { HtmlBasePlugin } from "@11ty/eleventy";

export default function (eleventyConfig) {
    // Rewrites absolute URLs in output when the site is served from a subpath,
    // so the same build works at a domain root and under /some-repo/.
    eleventyConfig.addPlugin(HtmlBasePlugin);

    eleventyConfig.addPassthroughCopy("src/assets");

    // Drafts are visible in `npm run serve` but excluded from builds.
    eleventyConfig.addPreprocessor("drafts", "md", (data) => {
        if (data.draft && process.env.ELEVENTY_RUN_MODE === "build") {
            return false;
        }
    });

    eleventyConfig.addFilter("readableDate", (date) => {
        const parsed = new Date(date);
        if (Number.isNaN(parsed.valueOf())) return "";
        return parsed.toLocaleDateString("en-CA", {
            year: "numeric",
            month: "long",
            day: "numeric",
            timeZone: "UTC",
        });
    });

    eleventyConfig.addFilter("isoDate", (date) => {
        const parsed = date === "now" ? new Date() : new Date(date);
        return Number.isNaN(parsed.valueOf())
            ? ""
            : parsed.toISOString().slice(0, 10);
    });

    // Newest first, which is what every post list wants. Guard against an
    // undefined collection, which happens when a template renders before any
    // posts exist.
    eleventyConfig.addFilter("byNewest", (posts) =>
        [...(posts ?? [])].sort((a, b) => new Date(b.date) - new Date(a.date)),
    );

    return {
        dir: {
            input: "src",
            output: "_site",
            includes: "_includes",
            data: "_data",
        },
        templateFormats: ["md", "njk", "html"],
        markdownTemplateEngine: "njk",
        htmlTemplateEngine: "njk",
    };
}
