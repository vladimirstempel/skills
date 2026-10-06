# skills

[![skills.sh](https://skills.sh/b/vladimirstempel/skills)](https://skills.sh/vladimirstempel/skills)

Agent skills for Claude Code, Codex, Cursor and other agents that support the open skills format.

## Install

```bash
npx skills add vladimirstempel/skills
```

## Skills

### teach-me

For when the agent does the work in a field you don't know yet (3D, gamedev, ML, finance, anything) and you want to learn along the way.

- In a workspace where learning mode is on, every reply that uses a term from your topics ends with a short block: what the term means in plain words, what it is for, and where it is in your project. Technical choices get a "why this way, and the alternative".
- Explained terms go to a glossary file (default `docs/glossary.md`), so each term is explained once. Ask again and you get a deeper explanation.
- Installed globally, it asks once per workspace whether to turn learning mode on, which topics to explain and where to keep the glossary. The answer is stored in the agent's own memory for that workspace or in `~/.config/teach-me/workspaces.md`, not in your repository.
- Explanations come in the language you write to the agent.

Turn it off or on later by telling the agent "turn learning mode off/on".

## License

MIT
