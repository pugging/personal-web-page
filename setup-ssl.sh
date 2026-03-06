#!/bin/bash

# Script to help setup a professional local HTTPS development environment for free
# This script uses mkcert to generate a locally trusted certificate, which is standard practice for modern web development.

# Colors for better output
GREEN='\033[0;32m'
BLUE='\033[0;34m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

echo -e "${BLUE}=== Setup Free Professional Local HTTPS Development ===${NC}"

# Check for mkcert
if ! command -v mkcert &> /dev/null
then
    echo -e "${YELLOW}mkcert is not installed.${NC}"
    echo "To get a truly signed (locally trusted) certificate for free, it's recommended to install mkcert."
    echo "On macOS, run: brew install mkcert"
    echo "On Windows, run: choco install mkcert"
    echo "On Linux, run: sudo apt install libnss3-tools && brew install mkcert (or download from GitHub)"
    echo ""
    echo "Would you like to continue with self-signed (untrusted) fallback for now? (y/n)"
    read -r response
    if [[ "$response" =~ ^([yY][eE][sS]|[yY])$ ]]
    then
        echo -e "${GREEN}Continuing with Vite's basic SSL plugin (self-signed).${NC}"
        echo "The browser will show a 'Not Secure' warning, but HTTPS-only features will work."
        echo "To start the development server, run: npm run dev:https"
        exit 0
    else
        echo "Setup aborted. Please install mkcert and run this script again."
        exit 1
    fi
fi

# mkcert is installed, generate the certs
echo -e "${GREEN}mkcert is installed. Generating locally-trusted certificates...${NC}"
mkcert -install
mkdir -p .certs
mkcert -cert-file .certs/localhost.pem -key-file .certs/localhost-key.pem localhost 127.0.0.1 ::1

echo -e "${GREEN}Certificates generated successfully in .certs/ folder!${NC}"
echo "Updating vite.config.js to use these certificates..."

# Create or update vite.config.js to use mkcert
cat <<EOF > vite.config.js
import { defineConfig } from 'vite';
import basicSsl from '@vitejs/plugin-basic-ssl';
import fs from 'fs';
import path from 'path';

const useMkcert = fs.existsSync('.certs/localhost.pem') && fs.existsSync('.certs/localhost-key.pem');

export default defineConfig({
  root: 'ceilor',
  plugins: [
    !useMkcert && process.env.VITE_HTTPS === 'true' ? basicSsl() : null
  ].filter(Boolean),
  server: {
    port: 3000,
    https: process.env.VITE_HTTPS === 'true' || useMkcert ? {
      key: useMkcert ? fs.readFileSync(path.resolve(__dirname, '.certs/localhost-key.pem')) : undefined,
      cert: useMkcert ? fs.readFileSync(path.resolve(__dirname, '.certs/localhost.pem')) : undefined,
    } : false,
    host: true,
    open: true
  },
  build: {
    outDir: '../dist',
    emptyOutDir: true,
  }
});
EOF

echo -e "${GREEN}Configuration updated!${NC}"
echo "To start the development server with your free signed certificate, run: npm run dev:https"
