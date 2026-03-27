# Fizzy Plan Skill — Design Spec

## Purpose

After the `writing-plans` skill produces an implementation plan, this skill parses the plan and creates a Fizzy board with cards representing each task. This replaces the typical "plan to Jira tickets" workflow — we use Fizzy cards instead.

## Trigger

Invoked at the end of `writing-plans`, after the plan doc is saved and before the execution handoff. Can also be invoked manually via `/fizzy-plan`.

## Flow

1. Read the plan doc (path known from the planning session)
2. Parse the plan's tasks into card definitions
3. Create a new Fizzy board named after the feature (from the plan's `# [Feature Name] Implementation Plan` header)
4. Create one card per plan task, all in triage (no columns — user organizes workflow as they go)
5. For tasks with multiple steps, create Fizzy steps (to-do items) on the card
6. Show summary: board name, board URL, list of created cards with numbers
7. Confirm with user, then proceed to execution handoff

## Card Mapping

| Plan element | Fizzy element |
|---|---|
| Plan title / feature name | Board name |
| `### Task N: [Component Name]` | Card title (prefixed with phase if plan has phases) |
| Task description, file list, approach notes | Card description (HTML) |
| `- [ ] **Step N: ...**` checkboxes within a task | Steps (to-do items) on the card |

### Card title format

`Task N: [Component Name]` — preserves the plan's numbering for easy cross-reference.

### Card description format

Includes the task's **Files** section and any prose describing the approach. Code blocks from the plan are included as-is in HTML `<pre>` tags. Kept concise — the full plan doc is the source of truth.

## CLI Commands Used

- `fizzy board create --title "Feature Name"` — create the board
- `fizzy card create --board BOARD_ID --title "Task N: Name" --description "..."` — create each card
- `fizzy step create --card CARD_NUMBER --title "Step description"` — create sub-steps on cards

## Integration with writing-plans

Added as an optional step between plan save and execution handoff. After the plan self-review completes:

1. Ask: "Want me to create a Fizzy board with cards for this plan?"
2. If yes, run the fizzy-plan flow
3. Then proceed to the existing execution handoff ("Subagent-Driven or Inline?")

If the `fizzy` CLI is not configured (no token/account), skip gracefully with a note.

## What This Skill Does NOT Do

- Does not create columns — user organizes workflow manually in Fizzy
- Does not assign cards — user assigns as they pick up work
- Does not sync progress back — cards are a planning snapshot, not live tracking
- Does not modify existing boards — always creates a new board per plan
