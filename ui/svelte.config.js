`use strict`;
/** @type {import('@sveltejs/kit').Config} */
import adapter from '@sveltejs/adapter-static';
import preprocess from 'svelte-preprocess';
import autoprefixer from 'autoprefixer';

export default {
    extensions: [`.svelte`],
    kit: {
        adapter: adapter({
            assets: `src/build`,
            fallback: null,
            pages: `src/build`,
        }),
        files: {
            assets: `static`,
            hooks: `src/hooks`,
            lib: `src/lib`,
            routes: `src/routes`,
            serviceWorker: `static/service-worker`,
            template: `src/app.html`,
        },
        floc: false,
        trailingSlash: `always`,
        prerender: {
            default: true,
        },
    },
    preprocess: [
        preprocess({
            defaults: {
                style: `scss`,
            },
            postcss: {
                plugins: [
                    autoprefixer()
                ],
            },
            scss: {
                prependData: `@charset 'UTF-8';`,
            },
            sourceMap: false,
        })
    ],
    serverSideRendering: false,
};
