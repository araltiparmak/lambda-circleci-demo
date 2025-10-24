import {build} from "esbuild";

await build({
    entryPoints: ["src/index.ts"],
    outfile: "dist/index.cjs",
    bundle: true,
    platform: "node",
    target: "node22",
    format: "cjs",
    minify: true,
    sourcemap: false,
    external: ["@aws-sdk/*"],
    logLevel: "info",
});