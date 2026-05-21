# claude-skills

Custom skills for [Claude Code](https://claude.ai/code). One skill per git branch.

## Install

```bash
curl -fsSL https://raw.githubusercontent.com/SysCall97/custom-claude-skills/main/install.sh | bash -s <skill-name>
```

Drops `SKILL.md` into `~/.claude/skills/<skill-name>/`. Restart Claude Code to pick up.

### Example

```bash
curl -fsSL https://raw.githubusercontent.com/SysCall97/custom-claude-skills/main/install.sh | bash -s json-skill
```

## Available skills

| Skill | Description | Install |
|-------|-------------|---------|
| `json-skill` | Filter, query, search, extract data from JSON files via `jq`. Triggers on tasks like "give me all X where Y is true". | `curl -fsSL https://raw.githubusercontent.com/SysCall97/custom-claude-skills/main/install.sh \| bash -s json-skill` |
| `swift-code-organizer` | Analyze and refactor Swift code with idiomatic best practices: `var`→`let`, `private(set)`, `didSet` refactor, `class`→`struct`. Asks before each change. | `curl -fsSL https://raw.githubusercontent.com/SysCall97/custom-claude-skills/main/install.sh \| bash -s swift-code-organizer` |

## License

[MIT](LICENSE)
