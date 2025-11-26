# Part D — Architecture of the Four-Site Ecosystem

## Big picture

The JustineLonglaT-Lane platform is built from a **small set of repositories**
and a clear hosting strategy. Each surface has a dedicated repo, but they all
follow the same conventions.

### Repositories

- **`justinelonglaT-lane`**  
  Next.js consulting site: hero, projects grid, videos, and contact funnel.
- **`jutellane-docs`**  
  This documentation site: plain HTML + CSS, powered by simple scripts and
  GitHub Actions / Vercel.
- **`jutellane-blogs`**  
  Static blog engine with posts under `posts/YYYY/MM/slug/` and small node
  scripts to generate indexes and metadata.
- **GitHub Pages export repos**  
  Receivers for pre-built HTML that GitHub Pages can serve directly.

Each repo is independent, but they share:

- A **main branch** that represents production.
- Lightweight **automation helpers** (PowerShell, Node scripts).
- A consistent way of tagging releases.

### Hosting & DNS

Hosting is deliberately boring and repeatable:

- **Vercel** hosts the consulting, docs, and blogs sites.
- **GitHub Pages** serves selected exported content from docs and blogs.
- **IONOS** handles DNS for all domains.

Key DNS entries:

- `justinelonglaT-lane.com` → Vercel (consulting site)
- `docs.justinelonglaT-lane.com` → Vercel (docs)
- `blogs.justinelonglaT-lane.com` → Vercel (blog)
- `*.github.io` + `CNAME` files → GitHub Pages mirrors

Design principle: **no snowflake records**. New surfaces must fit the pattern
or they don’t ship.

### Why this architecture is sustainable

- Clear separation of concerns — marketing, docs, and blog can evolve at
  different speeds.
- Shared conventions — once a pattern works for one site, it can be reused
  everywhere.
- Simple hosting — serverless/static architecture reduces operational load and
  energy overhead, aligning with your sustainability values.

Part D builds on this architecture to explain how operations, content, and
automation keep the four sites synchronized in real life.
