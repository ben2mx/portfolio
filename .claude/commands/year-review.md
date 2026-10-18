---
description: Draft one year-in-review page from its evidence file
---

Draft the year in review for the year in $ARGUMENTS (like 2025).

1. Read `~/projects/work/career/portfolio-evidence/years/<YYYY>.md`. If it is missing or its
   "Gaps for Ben" section blocks the story, stop and list what is missing.
2. Any win the evidence file marks as a security item needs Ben's yes before it appears.
3. `hugo new content years/<YYYY>.md`, then fill it: The headline, Biggest wins (3-6, credit the team),
   By category. `categories` and `tickets_closed` from the evidence
   file. One-sentence `summary`. Keep `draft: true`.
4. Apply every rule in `CLAUDE.md`. List for Ben, in chat only, what was held back and why.
5. Run `scripts/check-public.sh` and `hugo --gc --minify -D`; start `hugo server -D` and give Ben the address.
   Stop until he approves. After approval: branch, `draft: false`, commit, push, pull request. Do not merge.
