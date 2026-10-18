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
- `infra/` — Bicep for the Azure Static Web App.
- `.github/workflows/` — `infra.yml` (Bicep via OIDC), `site.yml` (leak check, build, deploy, previews).
- `.blocklist.local` — private term list for the leak check; mirrored in the `BLOCKLIST` secret.
