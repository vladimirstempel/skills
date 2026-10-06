---
name: teach-me
description: Use when a reply to the user is about to contain specialist terms or technical choices from a field the user may not know (3D, gamedev, rendering, audio, ML, networking, finance, biology and the like), when the user asks what a term means, or when the user asks to turn learning mode on or off.
---

# Teach me

The user lets the agent do the work but wants to understand it. In workspaces where learning mode is on, every reply that uses a term from the chosen topics, or makes a technical choice there, ends with a short explanation block. A glossary file remembers what was already explained, so each term is explained once.

## 1. Find the workspace setting

Look for the setting of the current workspace, in this order:
1. The agent's own persistent memory for this workspace that lives outside the repository (for example Claude Code auto-memory, `~/.claude/projects/<workspace>/memory/`).
2. The user-level file `~/.config/teach-me/workspaces.md`, the line for this workspace's absolute path.

- Setting `off`: stop here. Reply normally, no block.
- Setting `on`: go to step 3.
- No setting: step 2.

## 2. First use in a workspace: ask once

Answer the user's message as usual, and in the same message (or with the agent's question tool, if it has one) ask:

1. **Turn learning mode on here?** Ask only when this skill is installed globally (its `SKILL.md` lives outside the workspace). When it is installed inside the workspace, it is on, skip the question.
2. **Which topics to explain?** Suggest topics inferred from the workspace (README, dependencies, file types), for example "3D modelling, gamedev, rendering". Ordinary programming terms of the user's everyday stack are not explained unless the user lists them.
3. **Where to keep the glossary?** Default `docs/glossary.md`.

Save the answer, including `off`, so the question is not asked again:
- The agent has persistent memory scoped to this workspace outside the repository: save it there, one entry with workspace path, `on`/`off`, topics, glossary path, date. If that memory has an index loaded at session start, add a line to it so future sessions see the setting before any reply.
- Otherwise: append a line to `~/.config/teach-me/workspaces.md` (create it):
  `- /abs/path/to/workspace | on | 3D modelling, gamedev | docs/glossary.md | 2026-01-31`
- Neither is writable: ask the user where to save it. A file inside the repository only with the user's consent.

The user later says "turn learning mode off/on" or changes topics or glossary path: update the same entry.

## 3. Reply shape

1. The normal reply, as the user's other instructions shape it.
2. The explanation block. The user asked for it, so brevity rules from other instructions do not shorten it.

Write the block and the glossary in the language the user writes to you. Example in English:

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
- A new term: explain it under **New**, and append the same entry to the glossary, alphabetically.
- The user asks about a term again: explain again, deeper, with another angle, and update the glossary entry.

## Common mistakes

- Explaining only the first term and leaving the rest bare. Every topic term in the reply goes under **New** or **Seen before**.
- Leaving a term bare because another item mentions it ("draw call" inside "Why instancing"). A term in the reply or in an explanation gets its own item.
- Relaying a subagent's report as is. Its terms are unexplained, add the block.
- Explaining with more jargon. Use words the user already knows.
- Asking the step 2 questions again in a workspace that already has a setting.
