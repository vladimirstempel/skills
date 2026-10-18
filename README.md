# skills

[![skills.sh](https://skills.sh/b/vladimirstempel/skills)](https://skills.sh/vladimirstempel/skills)

Agent skills in the open [Agent Skills](https://agentskills.io) format. They work with any agent that supports it: Claude Code, Codex, Cursor, OpenCode, Gemini CLI and others.

## Install

```bash
npx skills add vladimirstempel/skills
```

Or copy a folder from `skills/` into your agent's skills directory (for example `~/.agents/skills/` or `~/.claude/skills/` for all projects, `.agents/skills/` inside one project).

## Skills

### teach-me

For when the agent does the work in a field you don't know yet (3D, gamedev, ML, finance, anything) and you want to learn along the way.

- In a workspace where learning mode is on, every reply that uses a term from your topics ends with a short block: what the term means in plain words, what it is for, and where it is in your project. Technical choices get a "why this way, and the alternative".
- Explained terms go to a glossary file (default `docs/glossary.md`), so each term is explained once. Ask again and you get a deeper explanation.
- Installed globally, it asks once per workspace whether to turn learning mode on, which topics to explain and where to keep the glossary. The answer goes to `~/.config/teach-me/workspaces.md`, shared by all your agents, plus the agent's own memory if it has one. Nothing is written to your repository except the glossary.
- Explanations come in the language you write to the agent.

Turn it off or on later by telling the agent "turn learning mode off/on".

### concept-to-multiview

Reference images for a 3D model in two stages, each on the model that does it best.

- Codex (GPT Image) draws a few concept variants from your brief. You choose one.
- Antigravity CLI (Gemini) turns the chosen concept into one multiview sheet: front, sides, back, top and 3/4 on a flat grey background, ready for image-to-3D services such as Tripo.
- The agent reviews each sheet against the concept and reruns the views that drift.

Needs the Codex CLI with image generation and the Antigravity CLI (`agy`), both signed in, plus `jq`.

## License

MIT
