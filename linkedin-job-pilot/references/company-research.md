# Company and role research

Read this file for every stable unique role during discovery and every manually supplied role. Research is part of discovery, not a later top-ten phase.

Use company-research-template.md for every company Markdown file.

## Research order

~~~mermaid
flowchart TD
    A[Exact official posting on the careers page] --> B[Official company sources]
    B --> C{Enough material evidence?}
    C -- No --> D[Use filings, reporting, LinkedIn, Levels, Reddit, Blind, Glassdoor]
    C -- Yes --> E[Reconcile dates and contradictions]
    D --> E
    E --> F[Complete brief and final fit]
    F --> G[Write and verify Markdown and CSV]
    G --> H{Final Status is Investigate and public question could resolve the gap?}
    H -- Yes --> I[Draft r/cscareerquestionsEU question]
    H -- No --> J[Finish without public post]
    I --> K{User approves exact post?}
    K -- Yes --> L[Post only there]
    K -- No --> J
    L --> J
~~~

Start with the job URL, role, location, posting date, and user constraints, then find the exact official posting.

## Careers page is the source of truth

The employer's official careers page, or the job board it uses (Greenhouse, Ashby, Lever, Workday, and similar), is the source of truth for every role. This includes roles found on LinkedIn and sibling roles found during company expansion. LinkedIn is a bulletin board for finding listings and a fallback for missing details.

~~~mermaid
flowchart LR
    A[LinkedIn card or user input] --> B[Find exact official posting]
    B -- Found --> C[Take role facts from the official posting]
    C --> D{Fact missing there?}
    D -- Yes --> E[Fill from LinkedIn, labeled as LinkedIn-only]
    D -- No --> F[Use official value]
    B -- Not found --> G[Use LinkedIn text, mark the role as not verified on the careers page]
~~~

1. Find the exact posting for the role on the official careers page. A generic careers or search page is not enough. Confirm the board belongs to the same employer.
2. Take requirements, duties, level, location, work mode, compensation, language, authorization, and posting dates from the official posting.
3. Use LinkedIn text only for facts the official posting does not state, such as applicant counts, repost state, or Premium signals, or a detail the employer omitted. Label each such fact `(LinkedIn only)`.
4. When the official posting and LinkedIn disagree, the official posting wins. Note the difference in the role section.
5. If the posting is closed on the careers page but still listed on LinkedIn, treat the role as closed.
6. If no official posting can be found, research from LinkedIn, write `Official posting: Not found on the careers page as of <date>` in the role section, and lower confidence.

The diagram is a priority order, not a requirement to search every site. Stop adding sources when material questions are answered. Respect access controls and report unavailable evidence.

For each company establish its business model, ownership or funding, approximate workforce, AI relevance, and material financial or market signals. For each role establish hard requirements, central duties, work mode, compensation, interview signals, candidate match, largest gaps, and source dates.

Reuse current company facts across roles, but verify role facts separately.

Complete the full material checklist for likely Great Fit and Normal Fit roles. Investigate unresolved gates far enough to determine whether the label should move. For Skip, a verified hard blocker may end research early after recording the blocker, source, posting state, and minimum company facts.

## Research checklist

| Area | Questions |
| --- | --- |
| Business | What does it sell, to whom, and how does it earn money? |
| Stage and ownership | Public, private, acquired, bootstrapped, or venture-backed? |
| Financial health | Revenue, growth, profitability, burn, funding, runway clues, and risks |
| Workforce | Headcount, hiring, offices, layoffs, reorganizations, attrition |
| Role | Team, duties, level, reporting line, work mode, visa support, success measures |
| AI relevance | Products, internal tools, partnerships, technical posts, hiring signals |
| Compensation | Base, bonus, equity, total compensation, location, level, date |
| Interviewing | Stages, coding, design, take-home, behavior, timing, difficulty |
| Culture | Repeated strengths, concerns, workload, management, office expectations |
| Market | Competitors, differentiation, concentration, regulation, current news |
| Candidate fit | Evidence, gaps, transferability, objections, label-changing facts |

## Source discipline

Use this reliability order:

1. Audited filings, the official job posting on the careers page, investor relations, and direct company publications.
2. Reputable reporting and attributed databases.
3. LinkedIn company and workforce signals, and LinkedIn job text as a labeled fallback for facts missing from the official posting.
4. Levels.fyi and recent role- or location-relevant Glassdoor, Blind, and Reddit anecdotes.

Give material facts a link and publication or access date. Label estimates. Separate base pay from total compensation. When sources disagree, show both and explain the likely reason.

For every role not already a verified Skip, run targeted read-only Reddit, Blind, and Glassdoor searches when accessible and material. Prefer recent reports for the same country, office, discipline, and level. Treat anonymous reports as anecdotal and never let one report override stronger official evidence. Record Not accessible or No useful recent reports found rather than silently omitting the check.

## Reddit fallback

Use the posting fallback only after ordinary research is complete, the Markdown file and CSV row are verified, final Status is Investigate, and the remaining gap is decision-critical. Never propose a public post for Great Fit, Normal Fit, or Skip.

Draft a concise r/cscareerquestionsEU post with:

- A neutral title.
- Generalized role, country, and seniority.
- Specific unresolved questions.
- Brief verified context.
- No confidential information, personal identifiers, account email, application ID, or unnecessary resume details.

Before posting, show the active handle, subreddit, flair, exact title, exact body, and whether the employer or role is identifiable. State that the post will be public. Hard stop until the user approves that exact draft and identity. Any edit, reply, message, vote, cross-post, or deletion requires separate approval.

## Research brief

End with:

- Two-sentence company summary.
- Evidence table with confidence and dates.
- Salary range with type, currency, location, source, and confidence.
- Likely interview process and confidence.
- AI relevance.
- Candidate fit, gaps, risks, and an evidence-backed A — Great Fit, B — Normal Fit, Investigate, or Skip label.
- Apply, Investigate further, or Skip as a recommendation, not a decision.

After each brief, follow discovery-tracking.md: create or update the company Markdown, verify it, write its relative path into every matching tracker row, and finalize the fit label. Do not wait for all pages or a separate batch.
