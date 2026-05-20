# install.sh
#!/bin/bash
SKILL=$1
mkdir -p ~/.claude/skills/${SKILL}
curl -fsSL https://raw.githubusercontent.com/yourusername/claude-skills/${SKILL}/SKILL.md \
  -o ~/.claude/skills/${SKILL}/SKILL.md
echo "✓ ${SKILL} installed"