---
title: "How this site is built"
hidemeta: true
---

This site is also a working example. Nothing here is clicked together in a portal.

```
write post ──> pull request ──> checks + preview URL ──> merge ──> live
                    │                                      │
              GitHub Actions                        Azure Static Web Apps
```

- **Content** is Markdown, built into static pages by [Hugo](https://gohugo.io/).
- **Hosting** is Azure Static Web Apps, free tier, in my own tenant.
- **Infrastructure is code.** The Azure resources are defined in a Bicep file. A pipeline deploys it, and shows what would change before it changes anything.
- **No stored cloud passwords.** The infrastructure pipeline signs in to Azure with a short-lived token GitHub issues per run (OIDC federation), scoped to one resource group.
- **Nothing reaches the main branch without a pull request.** Each one gets its own preview address and an automated check that blocks a post containing anything that shouldn't be public.

The source is on [GitHub](https://github.com/ben2mx/portfolio).
