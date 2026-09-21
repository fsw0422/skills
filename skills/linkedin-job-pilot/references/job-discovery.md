# LinkedIn job discovery

Read this file for discovery, browsing, scanning, or shortlisting when no exact role is already selected. Complete subagent-orchestration.md first.

Discovery is non-engagement work. LinkedIn may record opened cards as viewed and use that activity for recommendations. Discovery authorizes only the bounded local Markdown and CSV writes defined in the main skill. It does not authorize saving, dismissing, applying, signaling interest, contacting anyone, changing alerts, or opening named people profiles.

Maintain a private structured ledger of job IDs, occurrence positions, facts, dispositions, and the resume cursor. For large runs, the main skill explicitly authorizes an owner-only scratch directory under /private/tmp containing job facts only. This is temporary, not durable storage. Keep it until local writes and readbacks are verified, then delete it. If a restart is required, report its exact path as the private resume handle and verify it before resuming.

Discovery includes incremental CSV tracking, company Markdown, and final classification for every stable unique job. Do not cap research or tracking at a top-ten shortlist.

## Search horizon

~~~mermaid
flowchart TD
    A[Open LinkedIn Jobs] --> B[Verify account and search context]
    B --> C[Inspect current page]
    C --> D[Open each card sequentially]
    D --> E[Record stable facts and Premium signals]
    E --> F[Upsert tracker.csv as Researching]
    F --> G{Page complete?}
    G -- No --> D
    G -- Yes --> H[Dispatch company-owner agents]
    H --> I[Merge dossiers and sibling roles]
    I --> J[Track resolved sibling URLs]
    J --> K[Dispatch remaining one-job agents]
    K --> L[Wait and reconcile page wave]
    L --> M[Write and verify company Markdown]
    M --> N[Finalize CSV statuses]
    N --> O{Page 10 or stop condition?}
    O -- No --> P[Advance once and verify IDs changed]
    P --> D
    O -- Yes --> Q[Reconcile tracker and build queue]
~~~

- Preserve the current query, filters, sort, and collection.
- Inspect pages 1 through 10 inclusive by default; stop sooner when results end.
- Finish lazy-loading every card on a page before counting it complete.
- For infinite scroll, use observed page size or 25 stable slots per page equivalent, capped at 250 unique jobs.
- If recommendations rather than search results are open, use the unambiguous primary collection matching the user's criteria.
- Do not silently broaden location, level, work mode, recency, or company scope.
- Clarify material title or geography ambiguity. Never infer work authorization.
- A discovery request permits only the unavoidable viewed-job signal.

## Navigate job by job

The primary agent uses the authenticated UI and one result tab. Enumerate cards top to bottom, open one detail at a time, wait for it to settle, record it, then continue. Never parallelize UI navigation, use unofficial APIs, hidden endpoints, bulk scrapers, or automation extensions.

For each stable job:

1. Extract the numeric job ID and canonicalize the URL to https://www.linkedin.com/jobs/view/<job-id>/.
2. Parse tracker.csv, normalize every existing LinkedIn URL by numeric job ID, stop on normalized collisions, and reuse the unique matching row even when its legacy URL text differs.
3. Upsert a new row with blank Research File, Status = Researching, and blank Last Applied.
4. Preserve existing status, path, and application history for an existing row.
5. Atomically write and reparse the CSV.
6. Stop on a conflicting Applied badge or unverified application history.
7. Finalize fit only after the assigned research completes and its Markdown role section is verified.

After the page is recorded, follow subagent-orchestration.md. Complete the full page wave before navigating to the next page. Queue agents when runtime capacity is lower; never combine or drop jobs.

For every unique job record:

- Job ID and canonical URL.
- Page and ordinal occurrence.
- Company, title, location, work mode, employment type.
- Posting age/date, promoted or reposted state.
- Stated compensation and type.
- Application channel without opening it.
- Visible badges and applicant count.
- Language, authorization, sponsorship, relocation, clearance, travel, or on-call requirements.
- Central qualifications.
- Company business, ownership, workforce, AI relevance, and financial or market signals.
- Salary and interview evidence with estimates and anecdotes labeled.
- Visible Premium signals.
- Fit rationale, strongest evidence, largest gap, confidence, and final label.

Use only the PDF accepted by the mandatory gate for personal fit. Do not substitute the LinkedIn profile or another resume. Premium is a tie-breaker, never proof of qualification.

## Fit labels

| Label | Meaning |
| --- | --- |
| A — Great Fit | All known hard constraints are met, duties and level align strongly, and no material blocker is known |
| B — Normal Fit | Decision-critical constraints are met with one or two manageable gaps |
| Investigate | Material gaps or an unresolved hard gate remain, but no confirmed disqualifier exists |
| Skip | Verified hard blocker, level mismatch, stale/closed role, or explicit user exclusion |

Unknown information lowers confidence; it is not automatically negative. Never write a provisional fit label.

## Deduplication

Use job ID as the temporary identity and canonical LinkedIn URL as the CSV identity.

- Consolidate repeated cards with the same ID and retain every occurrence position.
- Keep distinct URLs separate unless requisition, description, employer URL, and date evidence proves one vacancy.
- Record confirmed repost clusters in research Markdown and treat them as one application opportunity.
- Track clear mismatches as Skip instead of silently dropping them.
- Keep a short exclusion reason.
- Never dismiss or hide a LinkedIn job.

## Read-only boundaries

Do not:

- Click Apply, Easy Apply, or an employer application link.
- Save or dismiss jobs, create alerts, follow companies, or change preferences.
- Use Top Choice or interest signals.
- Send messages or requests.
- Open named profiles.
- Change tracker schema, template, or files outside the bounded jobs paths.

## Stopping conditions

Stop when:

1. Page 10 or the tenth batch is fully processed.
2. LinkedIn shows the end of results.
3. Two consecutive bottom checks contain no new stable IDs.
4. Next fails to change page or IDs after one retry.
5. Search context changes and cannot be restored once.
6. A sign-in checkpoint, CAPTCHA, security warning, restriction, or rate limit appears.
7. Reliable order or identity cannot be established.
8. An application opens unexpectedly and context cannot be restored.
9. The user interrupts or changes criteria.

Never bypass safety barriers or rapidly retry unchanged pages. Preserve a cursor with search fingerprint, last page/ordinal/job ID, and stop reason.

## Discovery output

Return:

1. Search criteria and actual filters.
2. Pages inspected and stop reason.
3. Counts for cards, unique jobs, duplicates, unknown gates, and fit labels.
4. Fit-grouped results with material evidence and links.
5. Skip reasons and Investigate gap themes.
6. Verified Markdown paths and CSV rows.
7. Eligible queue ordered by Great Fit then Normal Fit.
8. Compact resume cursor and private ledger handle only when needed.

Describe coverage as observed at scan time. LinkedIn can reorder or remove cards.
