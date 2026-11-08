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
that scans it against a configured list of problem terms.

*Prevents:* sending texts that violate the owner's stated style; making the
style rules rely on memory, attention, or mood.

### 5. `scheduled-job-combination-check` — combine before you create

Before creating a scheduled job, check whether it can ride inside an
existing one — a section of a job that already fires, reads the same
data, or opens the same session. Combining is worth it only when the
deliverable survives intact: same checks at the same depth, same report
routing, same silence and alert rules, same state files and stop
conditions, same timing.

*Prevents:* a scheduled fleet that quietly grows back to hundreds of
fires a day, each paying full agent overhead for a small check.

## Quick start

1. Copy the `skills/` directory into your skills directory (for Muse:
   `~/workspace/custom-skills/`).
2. Read `ADAPTING.md` first, then each skill's frontmatter for what it
   needs (your machine names, your board file, your scan terms).
3. The fifth skill is the only one that can change how new jobs get
   created. All five may be new to you, so read each one before use.
4. Set up the outward-text-scan config: copy `scan-terms.example.conf` to
   `scan-terms.conf`, replace the example terms with your own, and run:
   ```bash
   ./scripts/outward-scan.sh --root <path-of-text-to-scan>
   ```
   That is a safety check for the text you are scanning, not a full
   check; the sweep guards any machine work. Adopt one at a time if you
   prefer — each stands alone.

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

## Honesty notes

- These are procedures, not enforcement. An assistant can still skip a
  step; the mechanical checks (counts, a counted gate, a script, and a
  pre-creation check) are what make skipping visible.
- If a skill becomes a script after you run it, say so in the skill's
  frontmatter. The value is the procedure; automation is a bonus.
- Each of these started as a single real failure. If a skill does not
  match your setup, adapt it rather than skipping it.

## License

MIT. See `LICENSE`.
