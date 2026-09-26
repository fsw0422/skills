# Research and pre-application tracking

Read this file before the first discovery-row upsert, after each job's research finishes, and for manually supplied roles or companies.

## Canonical local paths

Resolve the workspace root once with pwd -P.

- Tracker: <workspace-root>/jobs/tracker.csv
- Research directory: <workspace-root>/jobs/applications
- Template: references/company-research-template.md

Create jobs and jobs/applications when missing. Reject symlinks or resolved paths that escape the workspace root. Do not search another workspace or use a cloud fallback.

Research Markdown holds detailed evidence and fit rationale. The CSV is the minimal index and application-status view.

## Lifecycle

~~~mermaid
flowchart LR
    A[Select LinkedIn job] --> B[Canonicalize URL]
    B --> C[Parse tracker.csv]
    C --> D[Upsert row as Researching]
    D --> E[Research company and role]
    E --> F[Assign final fit]
    F --> G[Create or update company Markdown]
    G --> H[Verify role section]
    H --> I[Write relative Research File path]
    I --> J[Finalize Status]
    J --> K[Build application queue]
~~~

The initial CSV row, bounded research-file write, Research File update, and final Status update are authorized discovery writes. Schema changes, template changes, file moves/renames/deletions, writes outside jobs, and post-submit updates require the applicable approval.

## Exact CSV schema

Use exactly these six columns and this order:

| Column | Meaning |
| --- | --- |
| Company | Employer name |
| Role | Exact role title |
| LinkedIn URL | Canonical LinkedIn job URL and normal row identity |
| Research File | POSIX path relative to <workspace-root>/jobs, the directory containing tracker.csv, such as applications/acme.md |
| Status | Fit label plus optional lifecycle |
| Last Applied | Confirmed application date in YYYY-MM-DD; otherwise blank |

The header row is:

Company,Role,LinkedIn URL,Research File,Status,Last Applied

Use UTF-8 and RFC-4180 quoting. Do not add hidden columns, formulas, or formatting metadata.

Keep detailed requirements, compensation, interviews, classification rationale, risks, sources, job IDs, repost analysis, and application notes in the research Markdown or private scratch ledger.

## Safe CSV writes

Before the first job:

1. Resolve and verify tracker.csv.
2. If it is missing, atomically create it with the exact header and no data rows, then reparse it.
3. Parse the complete CSV with an RFC-4180-aware parser.
4. Confirm the exact six-column header.
5. Confirm the jobs directory is writable and not outside the workspace.

For each stable selected job:

1. Extract the numeric job ID and canonicalize the URL to https://www.linkedin.com/jobs/view/<job-id>/, regardless of localized host, slug, query, or fragment.
2. Extract numeric job IDs from every existing nonblank LinkedIn URL and compare normalized IDs, not raw URL strings.
3. If multiple existing rows normalize to the same job ID, stop and reconcile them before any new write.
4. Reuse the one matching row regardless of legacy host, slug, query, fragment, or missing trailing slash. After confirming there is no collision, normalize that row's URL to the canonical form during the bounded update.
5. For a new row, write Company, Role, LinkedIn URL, blank Research File, Status = Researching, and blank Last Applied.
6. For an existing row, preserve Research File, Status, Last Applied, and user-authored values unless verified evidence supports a specific update.
7. If LinkedIn shows Applied but tracker history is blank or inconsistent, stop and reconcile.
8. Serialize the full CSV to a temporary sibling file.
9. Atomically rename it over tracker.csv.
10. Reparse and verify the exact row before selecting the next job.

Never split or join CSV by commas. Stop on parse errors or duplicate canonical LinkedIn URLs.

After research, use A — Great Fit, B — Normal Fit, Investigate, or Skip. Do not expose C or D. For a previously classified row, update the fit while preserving a verified lifecycle after a middle dot. Use Research blocked only for a new or unclassified row when evidence cannot support a final label.

## Stable identity and duplicates

The canonical LinkedIn URL is the CSV row identity. Keep the LinkedIn job ID, employer requisition ID, official URL, occurrence positions, and repost cluster in the research Markdown and private ledger.

- Consolidate repeated cards with the same job ID into one row.
- Keep distinct LinkedIn URLs as separate rows unless reliable evidence proves one vacancy.
- Block application preparation for unresolved duplicates.
- Add an official sibling role to the tracker only after finding its exact LinkedIn URL.
- Preserve duplicate/repost rows during import or export.

## Company research file

Create or reuse one Markdown file per normalized company when identity is unambiguous. Use the canonical structure in company-research-template.md.

Use a safe lowercase filename derived from the normalized company name. Convert separators and punctuation to hyphens. Keep Research File relative, for example applications/acme.md.

Before creating:

1. Check existing tracker rows for the normalized company.
2. Resolve their Research File paths inside jobs/applications.
3. Verify title, company website, and role identities.
4. Before reuse, verify that the derived target path belongs to the same company using the Markdown title, company website, and existing tracker paths.
5. If the path exists for another company or two distinct names normalize to the same path, stop for resolution; never overwrite.
6. Reuse the verified file.

If multiple plausible files exist, use the one already referenced by the exact row. If no row resolves the ambiguity, stop for user direction. Never silently merge files or create another.

Company-level content includes business model, ownership, funding, financial health, workforce, AI relevance, culture, market risks, sources, and confidence.

Each role section includes canonical LinkedIn URL, official posting, job IDs, work mode, dates, requirements, compensation, interviews, fit label, rationale, gaps, risks, recommendation, and repost evidence.

For every Markdown change:

1. Read the whole current file.
2. Locate the company overview and the role by canonical LinkedIn URL.
3. Preserve unrelated and user-authored content.
4. Write a temporary sibling file.
5. Atomically rename it.
6. Re-read and verify required headings, tables, links, dates, and the exact role section.
7. Update matching tracker rows with the relative path and verify them.

Do not store credentials, demographic answers, confidential work-system text, or unnecessary personal data.

## Manual intake

~~~mermaid
flowchart TD
    A[User supplies input] --> B{Exact LinkedIn role URL?}
    B -- Yes --> C[Deduplicate, track, research, classify]
    B -- Company and role --> D[Find exact current LinkedIn post]
    D -- Found --> C
    D -- Not found --> E[Record unresolved lead in company Markdown]
    B -- Company only --> F[Research company and current roles]
    F --> G[Update company Markdown and track resolved roles]
~~~

A company-only watchlist row or any normal row without an exact LinkedIn URL requires an explicit preview and approval.

## Thirty-day eligibility

Use the user's current local date. A confirmed Last Applied within the previous 30 calendar days, inclusive, is in cooldown.

A role is eligible only when:

- Status is A — Great Fit or B — Normal Fit.
- Investigate has been explicitly advanced by the user.
- The posting is open and materially unchanged.
- Last Applied is blank.
- No linked repost was applied to in the previous 30 days.
- The role is not closed, expired, deferred, or unresolved as a duplicate.

Never auto-reapply. An exact role older than 30 days requires an explicit reapply decision. Build the full queue after discovery, ordered by Great Fit then Normal Fit.
