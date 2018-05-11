#/bin/sh

# checks if required programs are installed locally
if ! type "cwebp" > /dev/null; then
    echo "cwebp does not appear to be installed:"
    echo "brew install webp"
    exit 1
fi

echo "Converting images to .webp..."

for f in $(find . \( -name "*.png" -o -name "*.jpg" \))
  do
  # Check if webp file already exists
    if [ ! -f "${f%.*}.webp" ]; then
      echo "Converting $f"
      cwebp -q 80 $f -o "${f%.*}.webp" &>/dev/null
    fi
done

echo "Done converting to .webp"
