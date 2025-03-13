#!/bin/bash

# Exit on error
set -e

# Define the build directory
BUILD_DIR="build"

# Create the build directory if it doesn't exist
mkdir -p "$BUILD_DIR"

# Find all markdown files in the current directory (excluding the build folder)
echo "Copying markdown files into $BUILD_DIR..."
find . -type f -name "*.md" ! -path "./$BUILD_DIR/*" -exec cp {} "$BUILD_DIR" \;

# Check if a Jekyll site is already set up in the build folder; if not, create one.
if [ ! -f "$BUILD_DIR/_config.yml" ]; then
    echo "Initializing new Jekyll site in $BUILD_DIR..."
    cd "$BUILD_DIR"
    jekyll new . --force
    cd ..
fi

# Copy the custom CSS file to the Jekyll assets folder.
# Ensure the assets/css directory exists. Adjust the path if your Jekyll theme uses a different location.
ASSETS_DIR="$BUILD_DIR/assets/css"
mkdir -p "$ASSETS_DIR"
echo "Copying custom CSS (cap10tech.css) into $ASSETS_DIR..."
cp cap10tech.css "$ASSETS_DIR/"

# Reminder: Ensure your Jekyll layout (_layouts/default.html or your chosen layout)
# includes the following line in the <head> to load your custom CSS:
#   <link rel="stylesheet" href="/assets/css/cap10tech.css">
echo "Please ensure your layout includes <link rel='stylesheet' href='/assets/css/cap10tech.css'> in the head section."

# Build the Jekyll site
echo "Building the Jekyll site..."
cd "$BUILD_DIR"
jekyll build
cd ..

echo "Jekyll site built successfully! You can find the generated site in $BUILD_DIR/_site"
j