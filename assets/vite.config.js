import { defineConfig } from "vite";
import { svelte } from "@sveltejs/vite-plugin-svelte";
import path from "node:path";

export default defineConfig({
  plugins: [svelte()],
  publicDir: path.resolve(__dirname, "static"),
  build: {
    outDir: path.resolve(__dirname, "../priv/static"),
    emptyOutDir: false,
    manifest: true,
    sourcemap: true,
    rollupOptions: {
      input: {
        app: path.resolve(__dirname, "js/app.js"),
      },
      output: {
        entryFileNames: "assets/[name].js",
        chunkFileNames: "assets/[name]-[hash].js",
        assetFileNames: ({ names }) => {
          if (names.includes("app.css")) {
            return "assets/app.css";
          }

          return "assets/[name]-[hash][extname]";
        },
      },
    },
  },
  server: {
    host: "127.0.0.1",
    port: 5173,
    strictPort: true,
    origin: "http://127.0.0.1:5173",
  },
});
