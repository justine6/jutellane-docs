# Part D — Multi-Site Coordination

With four public surfaces, the main risk is drift: different versions of the
truth scattered across multiple sites. This section explains how the platform
stays in sync.

## One story, many entry points

Each site has a clear job:

- **Consulting** — first impression, offers, and portfolio.
- **Docs** — how the ecosystem is built and operated.
- **Blog** — narrative and teaching; deep dives, experiments, and lessons.
- **GitHub Pages** — easily shareable static references, especially for
  engineers.

The coordination rule:

> **Every important change should be represented in at least two places:  
> a narrative surface (blog/consulting) and an operational surface (docs).**

## Linking strategy

To keep navigation intuitive:

- Project cards on the **consulting site** link to:
  - A detailed project page.
  - Related deep dives on the **blog**.
  - Relevant sections in the **docs** (for tooling and system design).
- This **docs site** links out to:
  - Live project pages on the consulting site.
  - Blog posts that tell the human story behind a technical pattern.
- GitHub Pages mirrors include “Back to Docs” or “View on Main Site” links
  so visitors can always find the richer context.

## Release choreography

When a new feature or story ships, the coordination pattern is:

1. Start with the **originating repo** (blog or docs, depending on the
   change).
2. Create small follow-up PRs in other repos that link back to the origin.
3. Use a common tag or milestone name so the releases can be traced across
   repos.
4. Verify navigation end-to-end from each site after deploy.

## Sustainability benefits

- **Less duplication** — content is reused through links, not copy-paste.
- **Clear responsibility** — each repo owns its layer of the story.
- **Traceability** — tags and deep links make it easy to see how a feature or
  case study spreads across the ecosystem.

Multi-site coordination turns four sites into a **single, coherent platform**
instead of a maintenance burden.
