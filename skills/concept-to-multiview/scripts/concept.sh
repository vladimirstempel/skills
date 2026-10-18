#!/usr/bin/env bash
# Concept variants through Codex (GPT Image, built-in image_gen tool).
# Usage: concept.sh <out_dir> <brief_file> [count]
# Writes <out_dir>/concept-1.png .. concept-<count>.png and concept-prompt.txt.
set -euo pipefail

out=${1:?out_dir}; brief=${2:?brief_file}; count=${3:-3}
mkdir -p "$out"
out=$(cd "$out" && pwd)

cat > "$out/concept-prompt.txt" <<EOF
Use your built-in image generation tool. Make $count images, one image_gen call per image, each a separate design variant of the subject below (vary silhouette and construction, keep the style). Save them as PNG to ./concept-1.png .. ./concept-$count.png in the current directory. Write no other files. Reply with the saved paths only.

$(cat "$brief")

Composition: the whole subject in a 3/4 front view, centred, nothing cropped.
Shape: simple large forms and a silhouette that reads at small size.
Background: one flat solid light grey colour, no ground, no shadows, no text, no logos.
EOF

timeout "${CONCEPT_TIMEOUT:-900}" codex exec --skip-git-repo-check -s workspace-write -C "$out" \
  -o "$out/codex-last.txt" "$(cat "$out/concept-prompt.txt")" < /dev/null > "$out/codex-log.txt" 2>&1

ls "$out"/concept-*.png
