# Portfolio site

Public repo. Everything committed here is readable by anyone, including branches and history.

## Rules for anything public

- Never: coworker or executive names, hostnames, IP addresses, ticket keys, internal site names,
  consultant or service-partner names, dollar figures, OS versions, internal policy names.
- A security item is only mentioned once it is fully fixed. Describe the outcome, not the hole.
  If part of it is still open, hold the whole item for a later week.
- Credit shared work. Nothing that reflects badly on the employer.
- The employer and product names already on the LinkedIn profile are fine.
- No link to, or mention of, any consulting business.
- Source material (wins log, ticket data) is read, never copied in. Only the finished post lives here.

## Flow

New posts start as `draft: true`. Ben reads the page locally (`hugo server -D`) and approves
before anything is pushed. Then: branch, flip the draft flag, `scripts/check-public.sh`, commit,
push, pull request. Never push to `main` directly.

## Layout

- `content/weekly/YYYY-wNN.md` — one post per ISO week. Front matter numbers feed the running tally.
- `content/case-studies/<slug>.md` — one page per flagship project (`/case-study <slug>`).
- `content/years/YYYY.md` — one year-in-review page per year (`/year-review YYYY`).
- Source for all three is the private evidence library at `~/projects/work/career/portfolio-evidence/`
  (read only from here). LinkedIn and Viva Engage drafts go to its `posts/` folder, never into this repo.
- `infra/` — Bicep for the Azure Static Web App.
- `.github/workflows/` — `infra.yml` (Bicep via OIDC), `site.yml` (leak check, build, deploy, previews).
- `.blocklist.local` — private patterns (one regex per line) for the leak check; mirrored in the `BLOCKLIST` secret. The check scans every file git would publish, plus commit messages.
