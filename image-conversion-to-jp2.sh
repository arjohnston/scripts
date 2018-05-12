#/bin/sh

# checks if required programs are installed locally
if ! type "convert" > /dev/null; then
    echo "convert does not appear to be installed:"
    echo "brew install ImageMagick"
    exit 1
fi

echo ""
echo "Converting images to .jp2..."

# Checks all subdirectories for any png's or jpg's and converts them
# If a copy of .jp2 already exists, do not convert that file
for j in $(find . \( -name "*.png" -o -name "*.jpg" \))
  do
  # Check if jp2 file already exists
    if [ ! -f "${j%.*}.jp2" ]; then
      echo "Converting $j"
      convert $j -quality 0 "${j%.*}.jp2" &>/dev/null
    fi
done

echo "Done converting to .jp2"
