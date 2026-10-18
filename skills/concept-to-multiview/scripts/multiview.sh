#!/usr/bin/env bash
# Multiview turnaround sheet through Antigravity CLI (agy, Gemini image tool).
# Usage: multiview.sh <concept_image> <out_dir> [notes]
# Writes <out_dir>/multiview-<run>-<n>.<ext> and multiview-prompt.txt.
set -euo pipefail

src=${1:?concept_image}; out=${2:?out_dir}; notes=${3:-}
brain=${AGY_BRAIN_DIR:-$HOME/.gemini/antigravity-cli/brain}
mkdir -p "$out"
out=$(cd "$out" && pwd)
ref="$out/concept.${src##*.}"
[ "$(realpath "$src")" = "$ref" ] || cp "$src" "$ref"

cat > "$out/multiview-prompt.txt" <<EOF
Call your image generation tool once, with $ref as the reference image. The file exists: pass the path straight to the tool. Run no shell commands and write no files. Reply when the image is generated.

Image: a multiview turnaround sheet of exactly the same subject as in the reference. Keep every part, proportion, colour and marking the same as the reference. Do not add, remove or redesign parts.
Layout: a grid of 3 columns and 2 rows, equal cells, the subject at the same scale in every cell, centred, nothing cropped.
Row 1: front view, right side view, back view.
Row 2: left side view, top view, 3/4 front view.
Front, side, back and top views are orthographic (no perspective), the subject level and square to the view.
Background: one flat solid light grey colour across the whole sheet, no grid lines, no ground, no shadows, no text, no labels.
$notes
EOF

# accept-edits: agy cannot run shell commands, so the image stays in its brain dir and we copy it out.
# An agent that still reaches for a command ends without an image, so try twice.
for attempt in 1 2; do
  run=$(date +%H%M%S)
  (cd "$out" && timeout "${MULTIVIEW_TIMEOUT:-660}" agy -p "$(cat multiview-prompt.txt)" \
    --mode accept-edits --print-timeout 600s --output-format json < /dev/null > "agy-$run.json" 2> "agy-$run.err")
  id=$(jq -r .conversation_id "$out/agy-$run.json")
  n=0
  for f in "$brain/$id"/*.{png,jpg,jpeg,webp}; do
    [ -f "$f" ] || continue
    n=$((n + 1)); cp "$f" "$out/multiview-$run-$n.${f##*.}"
  done
  if [ "$n" -gt 0 ]; then ls "$out"/multiview-"$run"-*; exit 0; fi
  echo "attempt $attempt: no image in $brain/$id; see $out/agy-$run.err" >&2
done
exit 1
