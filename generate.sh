#!/usr/bin/env bash

if ! command -v identify &> /dev/null; then
    echo "❌ ImageMagick's 'identify' command not found. Please install ImageMagick."
    exit 1
fi

if [ ! -f index.html ]; then
    echo "❌ Missing index.html"
    exit 1
fi

if [ ! -d images ]; then
    echo "❌ Missing images/ directory"
    exit 1
fi

echo "🧹 Cleaning dist/ directory..."
rm -rf dist
mkdir -p dist

echo "📸 Copying images to dist/..."
cp -r images dist/

temp_file=$(mktemp)

while IFS= read -r image; do
    image=$(echo "$image" | sed "s/^'//; s/'$//")
    
    dimensions=$(identify -ping -format "%w %h" "images/$image" 2>/dev/null)
    
    if [ $? -eq 0 ]; then
        width=$(echo "$dimensions" | cut -d' ' -f1)
        height=$(echo "$dimensions" | cut -d' ' -f2)
        
        if [ "$height" -gt "$width" ]; then
            echo "<img src='images/$image' alt='' class='vertical' />" >> "$temp_file"
        else
            echo "<img src='images/$image' alt='' />" >> "$temp_file"
        fi
    else
        echo "⚠️  Could not determine dimensions for $image, adding without class"
        echo "<img src='images/$image' alt='' />" >> "$temp_file"
    fi
    
done < <(ls images/ | sort)

cat "$temp_file" index.html > dist/index.html
rm "$temp_file"

image_count=$(ls images/ | wc -l | tr -d ' ') 
echo "✨ Generated photo gallery with $image_count images in dist/index.html"
