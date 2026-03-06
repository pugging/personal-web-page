import { defineConfig } from "vite";
import basicSsl from "@vitejs/plugin-basic-ssl";
import { resolve } from "path";
import { readdirSync } from "fs";

// Collect all HTML files in the ceilor directory for multi-page build
function getHtmlEntries(dir) {
  const entries = {};
  const files = readdirSync(dir, { withFileTypes: true, recursive: true });
  for (const file of files) {
    if (file.isFile() && file.name.endsWith('.html')) {
      const fullPath = resolve(file.parentPath || file.path, file.name);
      const relativePath = fullPath
        .replace(resolve(dir) + '/', '')
        .replace('.html', '');
      entries[relativePath] = fullPath;
    }
  }
  return entries;
}

const htmlFiles = getHtmlEntries('ceilor');

export default defineConfig({
  root: "ceilor",
  plugins: [process.env.VITE_HTTPS === "true" ? basicSsl() : null].filter(
    Boolean,
  ),
  server: {
    port: 3000,
    https: process.env.VITE_HTTPS === "true",
    host: true,
    open: true,
  },
  build: {
    outDir: "../dist",
    emptyOutDir: true,
    rollupOptions: {
      input: htmlFiles,
    },
  },
});
