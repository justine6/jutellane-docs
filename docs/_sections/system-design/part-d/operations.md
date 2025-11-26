# Part D — Operations and Daily Runbook

This section turns the architecture into **everyday actions**. The goal is a
platform that is powerful *and* gentle on the operator — less cognitive load,
less waste, more confidence.

## Core principles

1. **Source of truth lives in Git**  
   If it’s not committed, it doesn’t count. This includes docs, runbooks,
   DNS notes, and CI configurations.
2. **Main is sacred**  
   `main` represents production. Work happens on branches, not directly on
   main.
3. **Small, frequent changes**  
   Incremental releases are easier to roll back, easier to reason about, and
   kinder to the platform.

## Common operational flows

### 1. Shipping a new case study

1. Draft the long-form story in the **blog repo** under
   `posts/YYYY/MM/slug/`.
2. Add or update a **project card + project page** in the consulting site
   repo.
3. Capture the “how we ran it” details in the **docs repo** under System
   Design or the Automation Toolkit.
4. Tag the repos with a shared release tag (for example
   `v2.0.0-consulting-era`).
5. Let CI/CD publish the consulting site, docs, and blog.

Result: one story reflected consistently across three surfaces.

### 2. Updating shared tooling

1. Change the script or config in a single place (for example,
   `tools/Tag-Release.ps1` in `jutellane-docs`).
2. Test locally on that repo.
3. Propagate the pattern to other repos with small PRs.
4. Document the change here in Part D and/or the Automation Toolkit.

### 3. Handling an incident

1. Identify the failing surface (consulting, docs, blog, or GitHub Pages).
2. Roll back to the previous good tag or commit on `main`.
3. Open a short incident note in the docs repo:
   - What changed?
   - What failed?
   - What guardrail or script could prevent this next time?
4. Translate lessons into automation (not just memory).

## Operational sustainability

- **Predictable routine** — same steps to ship blog posts, docs updates, or
  new project pages.
- **Low ceremony but not low discipline** — guardrails and scripts keep you
  honest without adding friction.
- **Human-friendly** — the system is designed so one engineer can run it
  without burning out.

If Part C is about *how* the ecosystem behaves, Part D – Operations is about
*how you live with it* every day.
