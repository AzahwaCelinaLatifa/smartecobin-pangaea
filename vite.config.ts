import { defineConfig } from "vite";
import react from "@vitejs/plugin-react";
import path from "path";
import { fileURLToPath } from "url";
import runtimeErrorOverlay from "@replit/vite-plugin-runtime-error-modal";

// Derive __dirname in ESM (Node/Vercel compatible)
const __dirname = path.dirname(fileURLToPath(import.meta.url));

// Dev-only plugins (omit top-level await for Vercel build stability)
const devPlugins = [] as any[];
if (process.env.NODE_ENV !== "production" && process.env.REPL_ID) {
  // These dynamic imports are optional; wrap in try so build never fails if missing
  try {
    // cartographer
    // eslint-disable-next-line @typescript-eslint/no-var-requires
    const cartographer = require("@replit/vite-plugin-cartographer");
    devPlugins.push(cartographer.cartographer());
  } catch {}
  try {
    // dev banner
    // eslint-disable-next-line @typescript-eslint/no-var-requires
    const devBanner = require("@replit/vite-plugin-dev-banner");
    devPlugins.push(devBanner.devBanner());
  } catch {}
}

export default defineConfig({
  plugins: [react(), runtimeErrorOverlay(), ...devPlugins],
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "client", "src"),
      "@shared": path.resolve(__dirname, "shared"),
      "@assets": path.resolve(__dirname, "attached_assets"),
    },
  },
  root: path.resolve(__dirname, "client"),
  build: {
    outDir: path.resolve(__dirname, "dist/public"),
    emptyOutDir: true,
  },
  server: {
    fs: {
      strict: true,
      deny: ["**/.*"],
    },
  },
});
