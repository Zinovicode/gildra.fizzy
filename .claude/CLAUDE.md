# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

@../AGENTS.md

## Fizzy Plan Integration

After the `writing-plans` skill saves a plan doc, **before the execution handoff**, offer to create a Fizzy board from the plan:

> "Want me to create a Fizzy board with cards for this plan?"

If yes, invoke the `fizzy-plan` skill. Then proceed to the normal execution handoff.
