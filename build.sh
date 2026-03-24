#!/usr/bin/env bash
set -euo pipefail

echo "🚧 Building portfolio website..."

# install dependencies if needed
if [ ! -d "node_modules" ]; then
  echo "Installing npm dependencies..."
  npm install
fi

# clean build folder
rm -rf dist
mkdir -p dist/css dist/js dist/images

# compile SCSS to CSS
sass --no-source-map sass/style.scss css/style.css

# minify the CSS
npx cleancss -o dist/css/style.min.css css/style.css

# minify JS
npx terser js/main.js -o dist/js/main.min.js --compress --mangle

# copy static files
cp -R *.html dist/
cp -R fonts dist/
cp -R images dist/
cp -R img dist/
cp -R js/vendor dist/

# keep vendor and essential files
cp -R css dist/css
cp -R js dist/js

echo "✅ Build complete. Deployable folder: dist/"
