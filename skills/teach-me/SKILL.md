---
name: teach-me
description: Explains specialist terms and technical choices to a user who lets the agent do work in a field they are still learning, keeping a glossary so each term is explained once. Use when a reply is about to contain terms or technical choices from such a field (3D, gamedev, rendering, audio, ML, networking, finance, biology and the like), when the user asks what a term means, or when the user asks to turn learning mode on or off.
license: MIT
compatibility: Any agent that follows the Agent Skills format and can read and write files. Uses the agent's own memory when it has one, works without it.
metadata:
  author: vladimirstempel
  version: "1.0.0"
---

# Teach me

The user lets the agent do the work but wants to understand it. In workspaces where learning mode is on, every reply that uses a term from the chosen topics, or makes a technical choice there, ends with a short explanation block. A glossary file remembers what was already explained, so each term is explained once.

The workspace is the project root the agent works in. `~` is the user's home directory (`%USERPROFILE%` on Windows). The settings file `~/.config/teach-me/workspaces.md` is shared by every agent the user runs, so a choice made with one agent holds for all of them.

## 1. Find the workspace setting

Look for the setting of the current workspace, in this order:
1. `~/.config/teach-me/workspaces.md`, the line that starts with this workspace's absolute path.
2. The agent's own persistent memory for this workspace, if it has one.

- Setting `off`: stop here. Reply normally, no block.
- Setting `on`: go to step 3.
- No setting: step 2.

## 2. First use in a workspace: ask once

Answer the user's message as usual, and in the same message (or with the agent's question tool, if it has one) ask:

1. **Turn learning mode on here?** Ask only when this skill is installed globally (its `SKILL.md` lives outside the workspace). When it is installed inside the workspace, it is on, skip the question.
2. **Which topics to explain?** Suggest topics inferred from the workspace (README, dependencies, file types), for example "3D modelling, gamedev, rendering". Ordinary programming terms of the user's everyday stack are not explained unless the user lists them.
3. **Where to keep the glossary?** Default `docs/glossary.md`, relative to the workspace root.

Save the answer, including `off`, so the question is not asked again:
1. Append a line to `~/.config/teach-me/workspaces.md` (create the file and folder if missing):
   `- /abs/path/to/workspace | on | 3D modelling, gamedev | docs/glossary.md | 2026-01-31`
2. The agent also has persistent memory for this workspace that it reads at session start: add a short note there too ("teach-me: on, topics ..., glossary ..."), so the setting is in view before any reply.
3. The settings file cannot be written (sandbox, permissions): save the note in the agent's memory only. No memory either: ask the user where to save it. A file inside the repository only with the user's consent.

The user later says "turn learning mode off/on" or changes topics or glossary path: update the line and the memory note.

## 3. Reply shape

1. The normal reply, as the user's other instructions shape it.
2. The explanation block. The user asked for it, so brevity rules from other instructions do not shorten it.

Write the block and the glossary in the language the user writes to you, headings included (**New**, **Seen before**, **Why X** translated too). Example in English:

```markdown
---
**New:**
- **UV map (unwrap)**: the model's surface cut along seams and laid flat, like a sewing pattern, so a 2D texture can be painted onto it. Without it the texture smears. Here: the trike's UVs, so the baked shading lands where it should.
- **Draw call**: one "draw this" command from the CPU to the GPU. Each costs time, so fewer is faster. Here: each unit drawn separately would be 300 draw calls.
- **Why instancing**: all 300 units go to the GPU in one draw call instead of 300, keeping the frame rate up. Alternative: one object per unit, simpler but slow.

**Seen before:** normals, GLB (see docs/glossary.md)
```

Each **New** item:
- **Term** (with the common translation in the user's language if one exists): what it is in plain words, 1 sentence, an everyday analogy when it helps.
- What it is for, or what breaks without it, 1 sentence.
- Where it is in this workspace right now (file, model, module, scene), 1 sentence.

A technical choice gets an item **Why X**: why this way, and the main alternative.

A process (how an animation plays, how an asset gets from the editor into the app, how a frame is drawn) gets a short numbered chain of steps instead of one sentence.

## 4. Glossary

Before replying, read the glossary file (create it with a `# Glossary` heading in the user's language if missing).
- A term already there: list it under **Seen before**, do not explain again.
- A new term: explain it under **New**, and add the same entry to the glossary as a bullet in the same format, in alphabetical order.
- The user asks about a term again: explain again, deeper, with another angle, and update the glossary entry.

## Common mistakes

- Explaining only the first term and leaving the rest bare. Every topic term in the reply goes under **New** or **Seen before**.
- Leaving a term bare because another item mentions it ("draw call" inside "Why instancing"). A term in the reply or in an explanation gets its own item.
- Relaying a subagent's report as is. Its terms are unexplained, add the block.
- Explaining with more jargon. Use words the user already knows.
- Asking the step 2 questions again in a workspace that already has a setting.
