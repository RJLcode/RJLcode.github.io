#!/bin/zsh
# Make web thumbnails for one project card.
#
#   tools/add-screenshots.sh <name> <mac-screenshot> <iphone-screenshot>
#
# Writes img/<name>-mac.webp (960x600, top of the Mac screenshot)
# and img/<name>-iphone.webp (720x720, top of the iPhone screenshot,
# below the status bar).
# Pass - to skip one of them, e.g. when only the Mac shot is ready.
# Needs: brew install webp

set -e
if [[ $# -ne 3 ]]; then
  echo "usage: $0 <name> <mac-screenshot> <iphone-screenshot>" >&2
  exit 1
fi
name=$1 mac=$2 phone=$3
cd "${0:A:h}/.."
tmp=$(mktemp -d)
trap 'rm -rf "$tmp"' EXIT

# crop_top <src> <out> <ratio-w> <ratio-h> <final-w> <final-h> <skip-top-%>
# Skips the top skip-top-% of the image (e.g. the iPhone status bar), crops
# what is left from the top to the given aspect ratio, then resizes.
crop_top() {
  local w h top ch cw
  w=$(sips -g pixelWidth "$1" | awk '/pixelWidth/ {print $2}')
  h=$(sips -g pixelHeight "$1" | awk '/pixelHeight/ {print $2}')
  top=$(( h * $7 / 100 ))
  ch=$(( w * $4 / $3 )); cw=$w
  if (( ch > h - top )); then ch=$(( h - top )); cw=$(( ch * $3 / $4 )); fi
  sips -s format png "$1" --out "$tmp/src.png" >/dev/null
  sips -c $ch $cw --cropOffset $top $(( (w - cw) / 2 )) "$tmp/src.png" >/dev/null
  sips -z $6 $5 "$tmp/src.png" >/dev/null
  cwebp -quiet -q 78 -m 6 "$tmp/src.png" -o "$2"
}

[[ $mac != - ]]   && crop_top "$mac"   "img/$name-mac.webp"    16 10 960 600 0
[[ $phone != - ]] && crop_top "$phone" "img/$name-iphone.webp"  1  1 720 720 6
ls -la img/$name-*.webp
