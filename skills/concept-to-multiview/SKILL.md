---
name: concept-to-multiview
description: Makes reference images for a 3D model in two stages - concept variants through Codex (GPT Image), then a consistent multiview turnaround sheet of the chosen concept through Antigravity CLI (Gemini). Use when the user wants concept art for a 3D asset (unit, vehicle, building, prop, character), a multiview or turnaround sheet from a concept, or references for image-to-3D (Tripo and the like).
license: MIT
compatibility: Needs the Codex CLI with the image_generation feature and the Antigravity CLI (agy), both signed in. Bash, jq.
metadata:
  author: vladimirstempel
  version: "1.0.0"
---

# Concept to multiview

GPT Image draws strong concepts but drifts between views. Gemini keeps one design consistent across views but draws weaker concepts. So: Codex makes the concept, the user chooses, agy turns the chosen concept into one multiview sheet. You orchestrate and review.

All files of one asset live in one output folder `<out>` (the project decides where).

## 1. Check the tools

- `codex features list | grep image_generation` shows `true`.
- `agy --help` answers.

If one fails, tell the user and stop.

## 2. Brief

Write `<out>/brief.md`: what the subject is and does, the style, the palette, the marking zones (team colour, decals), and the target (game model, low poly, seen from far). Plain sentences, no camera or background instructions: the script adds those. Done when every point the user gave is in the brief.

## 3. Concepts

```bash
scripts/concept.sh <out> <out>/brief.md 3
```

About 1 minute per image. Output `concept-1.png` .. `concept-N.png`.

## 4. The user chooses

Show every concept and stop. The user picks one or asks for changes. A change to the chosen concept is an edit, not a new design: `codex exec -i <concept> ...` with the exact change and "keep everything else the same".

## 5. Multiview

```bash
scripts/multiview.sh <out>/concept-K.png <out> ["extra notes"]
```

About 2 minutes. Output: one to three sheets `multiview-<run>-<n>.<ext>`, a 3x2 grid (front, right, back / left, top, 3/4).

## 6. Review

Compare every sheet with the concept at full size. A sheet passes when all are true:

- every part of the concept is in every view where it can be seen, nothing added;
- colours and markings match;
- each view is in its cell, front/side/back/top are orthographic, the subject has the same scale in all cells;
- the back and top views agree with the side views (these drift most);
- every barrel, launcher and turret points the same way in every view as in the concept (left and right side views mirror each other, they do not flip a part);
- flat grey background, no lines, no text.

A fault only in a view the next tool does not take is a soft fault (Tripo multiview takes front, left, back and right, not top or 3/4): the sheet can still pass, say so in the notes.

No sheet passes: run step 5 again with notes that name the drift (for example "the back of the rocket pod is closed, as in the side view"). After two failed reruns, show the best sheet to the user with its faults.

## 7. Deliver

Copy the chosen sheet to `<out>/multiview.<ext>` and write `<out>/NOTES.md`: the chosen concept, the chosen sheet, rejected sheets with one-line reasons. Report the files to the user.

## Gotchas

- Run agy in `--mode accept-edits` (the script does). It cannot run shell commands there, so the image stays in `~/.gemini/antigravity-cli/brain/<conversation_id>/`; the script copies it out. Set `AGY_BRAIN_DIR` if agy keeps its data elsewhere.
- Sheet cells are about 420 px. That is enough for image-to-3D services (they reduce the input anyway). Upscale only a cell whose small details are lost.
