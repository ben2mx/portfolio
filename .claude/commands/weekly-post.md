---
description: Draft this week's public post from the wins log and ticket counts
---

Draft the weekly post for the ISO week containing today (or the week given in $ARGUMENTS).

1. Read the wins log at `~/projects/work/career/wins/2026.md`. Pick entries by the date in each
   `###` heading; month sections are not in order. If the week has no entries, say so and offer
   to log wins first rather than drafting from memory.
2. Count tickets with the Jira tools, by the date a ticket moved to a done status
   (`statusCategory = Done AND statuscategorychangedate >= ...`), not by resolution date.
   Get: closed total, internal IT work, end-user requests, changes, incidents, distinct
   requesters, and tickets created and assigned to someone else.
3. Write `content/weekly/YYYY-wNN.md` following the newest existing post: same front matter keys,
   the numbers table, "What shipped", "What it means" (company, IT team). Plain language a
   recruiter can follow. Set `draft: true`. Tag with any of: identity, m365-security, endpoint,
   network, backup-dr, ai-governance, automation, operations.
4. Apply every rule in `CLAUDE.md`. Then list for Ben, in chat only, what was held back and why.
5. Run `scripts/check-public.sh` and `hugo --gc --minify -D`. Start `hugo server -D` and give Ben
   the local address. Stop here until he approves.
6. After approval: new branch, set `draft: false`, commit, push, open a pull request. Do not merge.
