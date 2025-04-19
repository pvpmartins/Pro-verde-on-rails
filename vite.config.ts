import { defineConfig } from "vite";
import RubyPlugin from "vite-plugin-ruby";
import VuePlugin from "@vitejs/plugin-vue";
import FullReload from "vite-plugin-full-reload";
import tailwindcss from '@tailwindcss/vite'
import path from "path";

export default defineConfig({
  root: path.resolve(__dirname, "app/javascript"),
  resolve: {
    alias: {
      "@": path.resolve(__dirname, "app/javascript"),
    },
  },
  build: {
    sourcemap: true,
  },
  plugins: [
    RubyPlugin(),
    VuePlugin(),
    tailwindcss(),
    FullReload(["config/routes.rb", "app/views/**/*"], { delay: 200 }),
  ],
  server: {
    hmr: {
      host: "localhost",
      protocol: "ws",
    },
  },
});
