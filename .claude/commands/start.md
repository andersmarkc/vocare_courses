# /start

Run this at the beginning of every session before doing anything else.

## Steps

1. Read @docs/PROJECT.md — current phase, what's completed, what's next
2. Read @docs/BUSINESS.md — business context and course philosophy
3. Read @CLAUDE.md — confirm hard rules and stack
4. Check git status: `git branch --show-current` and `git status --short`
5. Report back:
   - Current phase and what has been completed
   - What the next task is
   - Any blockers
   - Current branch and any uncommitted changes
6. Ask: "Ready to continue with [next task]? Or is there something specific you want to work on?"

Do not write any code until the user confirms what to work on.

---

## Context management during this session

- **At ~50% context used:** run `/compact` before continuing.
- **When switching to a completely different task mid-session:** run `/clear`.
- **After `/compact`:** re-read @docs/PROJECT.md to restore task context.
