#!/usr/bin/env bash
set -euo pipefail

echo "🚀 Starting image optimization in dist/ folder..."

# Find all JPEG, JPG, and PNG files in the current folder, excluding .git and dist
find . -type d \( -name ".git" -o -name "dist" \) -prune -o -type f \( -name "*.jpg" -o -name "*.jpeg" -o -name "*.png" \) -print | while read -r img; do
    # Get current size in bytes
    old_size=$(wc -c < "$img")
    
    # Skip if file is already small (< 500KB)
    if [ "$old_size" -lt 512000 ]; then
        continue
    fi

    echo "Optimizing $img ($(du -h "$img" | cut -f1))"
    
    # Resize to max 1920px and compress to 75% quality
    # -Z: resizes image so that neither width nor height exceeds 1920px
    sips -Z 1920 -s formatOptions 75 "$img" &>/dev/null
    
    new_size=$(wc -c < "$img")
    saved=$(( (old_size - new_size) / 1024 ))
    echo "  -> Done. Saved ${saved}KB"
done

echo "✅ Optimization complete."
