# Adapting This Pack to Your Setup

Written for the assistant (in the intended setup, a Muse) who will run
these playbooks, and the human who owns the machines and accounts.
Work through it before enabling anything.

## 0. The pattern behind all five

Each playbook exists because a *memory-based* rule failed and was
replaced by a *structural* one:

| Failed approach | Structural replacement |
| --- | --- |
| "I checked the agent list, the machine looks free" | A fixed multi-source sweep, run every time |
| "The summary says this item is still open" | A live-source closure check before any item travels |
| "The draft reads fine to me" | Claim-by-claim source checks + counted format gates |
| "We have a naming rule, I remembered it" | A scanner run on every outward text, no length exception |
| "One more small scheduled job can't hurt" | A combination check before any new job is created; merge unless a deliverable changes |

When you adapt a skill, preserve the structural replacement — it is the
point of the playbook. Local names and tools are the replaceable part.

## 1. What you need

- **An assistant that keeps skills/playbooks** and consults them by task
  (for Muse: custom skills under `~/workspace/custom-skills/`; the
  `SKILL.md` format here drops in directly).
- **Parallel work surfaces** — the sweep and closure check pay off when
  you run multiple chats, subagents, or scheduled jobs. With a single
  chat and no background work, adopt skills 3 and 4 first.
- **A shared-resource board** (for skill 1): a single file or page where
  work claims a machine before using it. A plain Markdown file works;
  the claim kit pattern (a registrar plus a queue board) is one proven
  shape, but any one-visible-place board works.
- **A shell** for the scan script (bash + grep; no other dependencies).

## 2. Per-skill setup decisions

### machine-activity-sweep
- Name your machines and accounts where the placeholders sit.
- Map the five sweep sources to your tools: your subagent list, your
  chat list + recent-turn reads, your scheduler's job list and run
  history, your memory/log search, and any "panel" of external AIs you
  consult through a machine.
- Decide your stale-claim threshold (the reference setup uses 2 hours).

### live-thread-closure-check
- No configuration. Decide only where closure evidence gets recorded
  (the tracker or watch that held the item) so the next run doesn't
  revive it.

### verify-claims-before-publishing
- Decide which content classes get **counted** gates in your world
  (anything pasted into a rich-text editor is the classic case) and what
  the counts are (source blocks vs. rendered blocks vs. empty blocks).
- Decide where withdrawn claims are recorded, so the quarantine survives
  across chats.

### outward-text-scan
- Copy `scan-terms.example.conf` to `scan-terms.conf` and define:
  - **FAIL terms** — strings that must never appear in outward text
    (internal codenames for the assistant or the project, private
    nicknames, embargoed names).
  - **WARN terms** — strings a human should eyeball (banned quantities
    or phrasings, house jargon, superseded wordings).
- Terms are grep extended regexes, one per line; `#` starts a comment.
- Keep `scan-terms.conf` **out of version control** if your real terms
  are sensitive — the shipped `.gitignore` already excludes it.
- Wire the trigger into your drafting workflow: the scan runs on the
  fully assembled text (intro + body + footer), and its FAIL/WARN counts
  are reported alongside the draft, every time, at any length.

### scheduled-job-combination-check
- No configuration. Decide where the check lives in your job-creation
  workflow so it runs before the job exists, not after: look for an
  existing job the new work can join without changing either
  deliverable, and combine only with the owner's word when a
  deliverable would change.

## 3. Rollout order that worked

1. `outward-text-scan` first — smallest setup, immediate catches.
2. `live-thread-closure-check` — pure procedure, no tooling.
3. `verify-claims-before-publishing` — adopt the claims pass first;
   add counted gates for your highest-stakes publishing surface.
4. `machine-activity-sweep` last — it needs the board habit in place.
5. `scheduled-job-combination-check` — no rollout of its own; it is a
   creation-time habit that starts the next time a new job is proposed.

## 4. What this pack deliberately does not do

- It grants no access and operates nothing. The sweep *reports*; a
  human or a registrar still starts and stops work.
- It does not replace platform permissions or approvals — it sits on
  top of them, catching the coordination failures they don't cover.
- Example incidents are generalized. If your failure mode differs,
  write your own incident into the skill — a playbook grounded in a
  real local failure gets followed; a generic one gets skipped.
