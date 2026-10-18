---
description: Draft one case study page from its evidence file
---

Draft the case study named in $ARGUMENTS (a slug like `rubrik` or `ai-claude-code`).

1. Read `~/projects/work/career/portfolio-evidence/case-studies/<slug>.md`. If it is missing or its
   "Gaps for Ben" section blocks the story, stop and list what is missing.
2. If its front matter has `security_item: true` and `ben_approved: false`, stop: Ben must approve first.
3. `hugo new content case-studies/<slug>.md`, then fill it: The problem, What I built (credit the team's
   part), What changed (outcomes and numbers allowed by `CLAUDE.md`), Skills. `categories` from the evidence
   file. One-sentence `summary`. Keep `draft: true`.
4. Apply every rule in `CLAUDE.md`. List for Ben, in chat only, what was held back and why.
5. Run `scripts/check-public.sh` and `hugo --gc --minify -D`; start `hugo server -D` and give Ben the address.
   Stop until he approves. After approval: branch, `draft: false`, commit, push, pull request. Do not merge.
