#!/usr/bin/env bash
set -euo pipefail

if [[ $# -ne 2 ]]; then
  echo "Usage: normalize-preview.sh <input-image> <output.png>" >&2
  exit 64
fi

input_path=$1
output_path=$2

if [[ ! -f "$input_path" ]]; then
  echo "Input image does not exist: $input_path" >&2
  exit 66
fi

if [[ -e "$output_path" ]]; then
  echo "Refusing to overwrite existing output: $output_path" >&2
  exit 73
fi

if command -v sips >/dev/null 2>&1; then
  tool=sips
  width=$(sips -g pixelWidth "$input_path" | awk '/pixelWidth:/ { print $2 }')
  height=$(sips -g pixelHeight "$input_path" | awk '/pixelHeight:/ { print $2 }')
elif command -v magick >/dev/null 2>&1; then
  # Read only the first frame, flattened onto its full canvas, so animated
  # and optimized GIF/WebP inputs report and keep their real dimensions.
  tool=magick
  read -r width height < <(magick "$input_path[0]" -background none -flatten -format '%w %h\n' info:)
elif command -v convert >/dev/null 2>&1; then
  # ImageMagick 6, still the default on many Linux distributions.
  tool=convert
  read -r width height < <(convert "$input_path[0]" -background none -flatten -format '%w %h\n' info:)
else
  echo "Normalization requires macOS sips or ImageMagick (magick or convert)." >&2
  exit 69
fi

if [[ -z "${width:-}" || -z "${height:-}" || "$height" -eq 0 ]]; then
  echo "Could not determine input dimensions." >&2
  exit 65
fi

if ! awk -v width="$width" -v height="$height" 'BEGIN {
  ratio = width / height
  delta = ratio - 2
  if (delta < 0) delta = -delta
  exit(delta > 0.02)
}'; then
  echo "Input must be approximately 2:1; got ${width}x${height}." >&2
  exit 65
fi

output_dir=$(dirname "$output_path")
mkdir -p "$output_dir"
temporary_dir=$(mktemp -d "${TMPDIR:-/tmp}/social-preview.XXXXXX")
temporary_output="$temporary_dir/preview.png"

cleanup() {
  rm -f "$temporary_output"
  rmdir "$temporary_dir" 2>/dev/null || true
}
trap cleanup EXIT

case "$tool" in
  sips)
    cp "$input_path" "$temporary_output"
    sips -s format png -z 640 1280 "$temporary_output" >/dev/null
    ;;
  magick)
    magick "$input_path[0]" -background none -flatten -resize '1280x640!' "$temporary_output"
    ;;
  convert)
    convert "$input_path[0]" -background none -flatten -resize '1280x640!' "$temporary_output"
    ;;
esac

mv "$temporary_output" "$output_path"
echo "Wrote 1280x640 social preview: $output_path"
