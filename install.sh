#!/bin/bash
SKILL=$1
BRANCH="main"  # or whatever your default branch is

mkdir -p ~/.claude/skills/${SKILL}
curl -fsSL "https://raw.githubusercontent.com/SysCall97/custom-claude-skills/${BRANCH}/${SKILL}/SKILL.md" \
  -o ~/.claude/skills/${SKILL}/SKILL.md \
  && echo "✓ ${SKILL} installed" \
  || echo "✗ Failed to download ${SKILL}"