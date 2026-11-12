#!/usr/bin/env bash
# Re-downloads the live site into ./site (run from the repo root with Git Bash). Chunk/font names change on
# every deploy of the original, so after re-mirroring, check index.html for new file names and fetch those too.
set -e
B="https://peopleofbengaluru.com"; UA="Mozilla/5.0"; cd "$(dirname "$0")/../site"
curl -s -A "$UA" -o index.html "$B/"
for p in manifest.webmanifest icon.svg robots.txt sitemap.xml; do curl -s -A "$UA" -o "$p" "$B/$p"; done
curl -s -A "$UA" -o opengraph-image.png "$B/opengraph-image"
grep -oE '/_next/static/immutable/[A-Za-z0-9_./-]+' index.html | sort -u | while read u; do
  mkdir -p "$(dirname ".$u")"; curl -s -A "$UA" -o ".$u" "$B$u"; done
# lazy chunks referenced from the already-downloaded ones
grep -ohE 'static/immutable/chunks/[A-Za-z0-9_.-]+' _next/static/immutable/chunks/*.js | sort -u | while read u; do
  [ -f "_next/$u" ] || curl -s -A "$UA" -o "_next/$u" "$B/_next/$u"; done
for m in designer rockstar developer creative founder investor maker adventurer_f pm formal_f hero swat_m moonshot; do
  curl -s -A "$UA" -o "models/characters/$m.glb" "$B/models/characters/$m.glb"; done
curl -s -A "$UA" -o models/robot.glb "$B/models/robot.glb"
for s in concrete grass wood; do for i in 0 1 2 3 4; do
  curl -s -A "$UA" -o "audio/sfx/footstep_${s}_00$i.m4a" "$B/audio/sfx/footstep_${s}_00$i.m4a"; done; done
echo "done: $(find . -type f | wc -l) files"
