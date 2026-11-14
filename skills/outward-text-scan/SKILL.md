# Outward Text Scan — A Mechanical Gate for Text Other People Will Read

## The rule

**Any** text a third party will read — email intros, cover notes,
forwarded messages, posts, articles, deliverables, of **any length** —
goes through the scan before it is presented as ready or sent. There is
no short-text exception.

Scan the **fully assembled** text (intro + body + footer together —
banned terms hide in the parts written last and fastest), and report
the FAIL/WARN counts alongside the draft. A FAIL count above zero
blocks presenting the draft as ready.

## Why it is a script and not a resolution

The failure this prevents: a naming rule existed in writing, and a
preflight checklist existed that required sweeping outward text — the
rule was still missed twice, both times in *short* texts (a four-line
email intro; a short social draft) that never triggered the "full
preflight" in the author's mind. The fix is structural: the gate is a
command that runs on every outward text, not a step someone remembers
to include.

## The scanner

`scripts/outward-scan.sh` counts the lines matching each of your terms in a file
(or stdin) and prints a per-term table plus a PASS/BLOCKED result:

- **FAIL terms** — must never appear (internal codenames, private
  nicknames, embargoed names). Any hit exits non-zero.
- **WARN terms** — a human should look (banned quantities or phrasings,
  house jargon, superseded wordings). Counted and reported; they don't
  block by themselves.

Terms live in a config file (`scan-terms.conf`, grep extended regexes,
one per line, `#` comments), so the script ships clean and your real
terms stay local. Start from `scan-terms.example.conf`, which shows the
*shape* of a real config with placeholders: an internal house name as
the FAIL term; WARN patterns for a banned numeric claim, a spelled-out
variant, a style-guide spelling, a piece of internal jargon, an
abbreviation that must never be shortened, and superseded substitute
phrasings.

```sh
cp scan-terms.example.conf scan-terms.conf   # then edit in your terms
./scripts/outward-scan.sh draft.txt          # or:  ... -  for stdin
```

## Wiring the trigger

- Put the rule wherever your drafting workflow lives (your equivalent
  of a deliverable-preflight skill), phrased as a hard gate, not a tip:
  "run the scan on the assembled text and report the counts with the
  draft; a FAIL above zero blocks presenting it as ready."
- Apply it to text you draft **and** text the owner dictates that you
  assemble — assembly is where intros and footers get added.
- When a new banned term is discovered (a leak that got caught, a
  wording the owner retires), add it to the config **in the same turn**
  — the config is the memory.
