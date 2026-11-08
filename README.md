# Muse Playbook Skills Pack

Five working playbooks, generalized from a production setup where one
assistant runs many parallel chats, scheduled jobs, and subagents against
shared machines and accounts — and kept re-learning the same four lessons
the hard way until each one became a written procedure with a mechanical
check.

These are **skills**: short procedural documents an AI assistant reads and
follows. They are written for Meta's Muse, whose skills live as `SKILL.md`
files, but the procedures themselves are assistant-agnostic — any agent
that can read a checklist and call tools can run them. See `ADAPTING.md`
for how to wire them into your setup.

## The five playbooks

### 1. `machine-activity-sweep` — never miss work running on your machines

When work is spread across parallel chats, background agents, and
scheduled jobs, no single list shows everything that is currently driving
a shared computer. The obvious check — the subagent list — provably misses
the most common case: a chat's own agent holding a control session. This
playbook replaces the guess with a fixed multi-source sweep, an
attribution rule ("not me in this chat" is never an acceptable first
answer), and a stop/resume relay protocol.

*Prevents:* telling the owner a machine is free while another of their
chats is using it; colliding sessions on one machine.

### 2. `live-thread-closure-check` — a cache is not proof an item is open

Summaries, memory notes, and watch state files all go stale the moment
the underlying thread moves. This playbook requires checking the live
source (who spoke last, whether the ask was already fulfilled, whether
the newest message is just a thank-you) before carrying an "open item"
into a new chat, a report, or a drafted reply.

*Prevents:* re-surfacing handled items, drafting replies to closed
threads, and making the owner re-triage finished business.

### 3. `verify-claims-before-publishing` — check claims against a primary source

AI-generated syntheses happily carry invented handles, prices, and terms
forward as facts. This playbook requires extracting the factual claims in
anything about to be stated or published, checking each against a primary
source (a live check, the original message, the governing document),
quarantining withdrawn claims so they never reappear, and — for rendered
or pasted content — replacing visual "looks right" checks with **counted**
checks that produce numbers in the verification report.

*Prevents:* confident wrong answers, stale summaries presented as current,
and paste/format corruption passing an eyeball review.

### 4. `outward-text-scan` — a mechanical gate for text other people will read

Style rules fail exactly where they're needed most: short texts, written
quickly, that "don't need the full preflight." This playbook makes the
gate structural instead of mnemonic — every outward text, any length, is
assembled in full (intro + body + footer) and run through a small script
that counts blocked and flagged terms from a config file you define
(internal codenames, banned phrasings, house jargon). The draft may not
be presented as ready while a FAIL term is present.

*Prevents:* internal names and jargon leaking into client email, and
"we have a rule about that" being the only enforcement.

### 5. `scheduled-job-combination-check` — combine before you create

Every scheduled job looks cheap alone; the fleet is what costs, because
each run pays a fixed agent overhead on every fire. This playbook makes
the check happen at creation time: before adding a job, see whether it
can ride inside an existing one — as a section, a gated cadence section,
a folded snapshot, or a shared session — and combine whenever neither
job's deliverable changes. Deliverable is defined mechanically (same
checks, same routing, same silence and alert rules, separate state, and
timing that still serves the work), and the playbook names the cases
that must stay separate: escalation ladders, deliberate time gaps,
independent failure domains, and zero-cost free riders that would save
nothing.

*Prevents:* a scheduled fleet that quietly grows until background jobs,
not interactive work, consume the usage budget.

## Layout

```
skills/
  machine-activity-sweep/SKILL.md
  live-thread-closure-check/SKILL.md
  verify-claims-before-publishing/SKILL.md
  outward-text-scan/SKILL.md
  outward-text-scan/scripts/outward-scan.sh      (config-driven scanner)
  outward-text-scan/scan-terms.example.conf      (example term config)
  scheduled-job-combination-check/SKILL.md
ADAPTING.md     — prerequisites, Muse wiring, per-skill setup decisions
LICENSE         — MIT
```

## Quick start

1. Copy the `skills/` folders into your assistant's custom-skills
   directory (for Muse: `~/workspace/custom-skills/`).
2. Work through `ADAPTING.md` — each skill names the local decisions it
   needs (your machine names, your board file, your scan terms).
3. For the outward scan, copy `scan-terms.example.conf` to
   `scan-terms.conf`, replace the example terms with your own, and run:
   `./skills/outward-text-scan/scripts/outward-scan.sh your-draft.txt`
4. The skills reference each other: the closure check feeds the claims
   check; the sweep guards any machine work. Adopt one at a time if you
   prefer — each stands alone.

## Honesty notes

- These are procedures, not enforcement. An assistant can still skip a
  step; the designs minimize that by making the check mechanical
  (counts, lists, named sources) rather than judgment-based.
- Every "failure this prevents" in the pack is real, generalized from an
  actual incident in the setup these came from, with all identifying
  details removed.
- The pack contains no credentials, no account details, and no personal
  data. Example names, machines, and terms are placeholders — replace
  them with yours locally, and keep your real config out of any repo.

## License

MIT — see `LICENSE`.
