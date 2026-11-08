# Scheduled Job Combination Check

Every scheduled job looks cheap on its own. The fleet is what costs.
Each run of an agent job pays a fixed overhead before it does any real
work — the agent starts, loads its context, reads its state, and writes
its report — and that overhead is charged on every single fire. Twenty
small jobs therefore cost far more than one job that does twenty
sections of work. The failure this playbook prevents is discovering,
well into a usage cycle, that background jobs rather than interactive
work consumed the budget.

## The Rule

Before creating any new scheduled job, check whether it can be combined
with an existing one to save tokens.

- Combine when it can be done without impacting the deliverable of
  either job.
- If combining would change a deliverable, verify with the owner first,
  and combine only on their word.
- If no existing job is a fit, create the new job. The rule is a check,
  not a ban.

## What Counts as the Deliverable

A merge preserves the deliverable only when every one of these survives
intact.

- The same checks, searches, and actions, at the same depth.
- The same report routing. Findings go where they always went, including
  findings that belong in a different conversation or channel.
- The same silence and alert rules. A section that was silent unless it
  found something stays silent inside the combined run.
- Each section keeps its own state files, seen lists, and stop
  conditions. A combined job is a shared run, not a blended memory.
- The timing still serves the work. A section that must run at a
  specific time, or only after a delay, does not move just to fit the
  host job's schedule.

## Merge Shapes That Work

- **Sections in one run.** Several checks that fire at the same time
  become one job whose body is numbered sections, one per original job.
  Each section reports, or stays silent, exactly as it did alone.
- **A cadence section.** A lower-frequency task rides inside a
  higher-frequency job, gated to its own day or time — for example, a
  weekly pass that runs as a Sundays-only section of a daily job.
- **A folded snapshot.** A tiny periodic recording that reads data an
  existing job already reads becomes a few lines appended inside that
  job, instead of a separate run that pays full overhead to write one
  line to a file.
- **A shared session.** Jobs that each open the same expensive session —
  a device, an account, a signed-in browser — run back to back inside
  one session instead of each paying the setup cost.

## When Not to Merge

- **Escalation ladders.** Steps that exist as separate timed rungs — a
  reminder, then a nudge, then an escalation — must stay separate. The
  separation is the deliverable.
- **Deliberate time gaps.** A scout that sends a request in the morning
  and a verifier that reads the reply hours later cannot share a run.
- **Independent failure domains.** If one job failing must never silence
  another job's alert, keep them apart — or build the combined job to
  report per section, so one section's failure is visible instead of
  hidden.
- **Free riders.** Folding a zero-cost action into an agent run saves
  nothing, because the action was never paying the overhead. Count only
  real merges, and say so when a proposed merge turns out to be free.

## A Worked Example

One production setup audited its scheduled fleet only after a usage
scare, and the audit is where the savings were. Ten morning email
watches — each with its own searches, its own report destination, and
its own stop condition — became a single daily sweep whose body carries
all ten as sections, each section keeping its routing and its rules.
Four pairs of jobs that fired at the same time became four combined
jobs. Two sub-hourly jobs were slowed to hourly. Scheduled fires fell
from roughly 900 a day to roughly 355, a cut of about 60 percent, and no
watch lost coverage.

The audit found the savings once. This check exists so the fleet does
not quietly grow back between audits.

## The Creation-Time Checklist

1. List the existing jobs that run at a compatible time, open the same
   session, or read the same data.
2. Take the best candidate and run the deliverable test above, item by
   item.
3. If every item passes, add the new work as a section of that job. If a
   standalone job already existed, disable it rather than deleting it,
   so the merge stays reversible.
4. If any item fails, ask the owner before merging, naming exactly
   which deliverable would change.
5. If there is no candidate, create the job — and note that the
   combination check was run.
