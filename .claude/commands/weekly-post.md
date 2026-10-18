---
description: Draft this week's public post, plus the LinkedIn and Viva Engage drafts, from the evidence library
---

Draft the weekly post for the ISO week containing today (or the week given in $ARGUMENTS, like 2026-W42).

1. Read `~/projects/work/career/portfolio-evidence/weekly/YYYY-wNN.md`. It has the ticket counts and candidate
   wins. If it is missing, stop and tell Ben to run `python3 -I tools/weekly.py --week YYYY-WNN` from
   `~/projects/work/career/portfolio-evidence` in the IT-Automation tab. Do not query Jira from here.
2. Read the wins log at `~/projects/work/career/wins/2026.md` for the same dates (pick entries by the date in
   each `###` heading; month sections are not in order).
3. Write `content/weekly/YYYY-wNN.md` following the newest existing post: same front matter keys (numbers
   copied from the evidence file), the numbers table, "What shipped", "What it means" (company, IT team).
   Plain language a recruiter can follow. `draft: true`. Tags and `categories` from: networking, azure,
   security, identity, backup-dr, monitoring, endpoint, jira-process, ai-automation.
4. Apply every rule in `CLAUDE.md`. Any item under "Security items" in the evidence file stays out unless Ben
   has marked it yes. List for Ben, in chat only, what was held back and why.
5. Every second week (even ISO week numbers), also draft into `~/projects/work/career/portfolio-evidence/posts/`
   - never into this repo:
   - `YYYY-wNN-linkedin.txt`: ONE win told as a short story (problem, what we did, what changed), under 200
     words, plain ASCII only (no em-dashes, smart quotes, emoji or arrows), ending with a link to the post.
   - `YYYY-wNN-viva-engage.txt`: the same fortnight for coworkers. Lead with how it helped the business
     (less downtime, less risk, time saved, people helped), non-technical, credit teammates by name. Plain ASCII.
6. Run `scripts/check-public.sh` and `hugo --gc --minify -D`. Start `hugo server -D` and give Ben the local
   address. Stop here until he approves.
7. After approval: new branch, set `draft: false`, commit, push, open a pull request. Do not merge.
