# claude-skills

Custom skills for [Claude Code](https://claude.ai/code). One skill per git branch.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/SysCall97/claude-skills/main/install.sh | bash -s <skill-name>
```

Drops `SKILL.md` into `~/.claude/skills/<skill-name>/`. Restart Claude Code to pick up.

### Example

```bash
curl -fsSL https://raw.githubusercontent.com/SysCall97/claude-skills/main/install.sh | bash -s json-skill
```

## Available skills

| Skill | Description |
|-------|-------------|
| `json-skill` | Filter, query, search, extract data from JSON files via `jq`. Triggers on tasks like "give me all X where Y is true". |

## License

[MIT](LICENSE)
