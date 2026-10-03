# Research and pre-application tracking

Read this file before the first discovery-row upsert, after each job's research finishes, and for manually supplied roles or companies.

## Canonical local paths

Resolve the active user's home directory once without deriving it from the current workspace.

- Tracker: <home-directory>/jobhunt/tracker.csv
- Research directory: <home-directory>/jobhunt/applications
- Template: references/company-research-template.md

Create `jobhunt` and `jobhunt/applications` when missing. Reject symlinks or resolved paths that escape the active user's home directory. Do not search a workspace-local copy, another home directory, or a cloud fallback.

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

The initial CSV row, bounded research-file write, Research File update, and final Status update are authorized discovery writes. Schema changes, template changes, file moves/renames/deletions, writes outside `jobhunt`, and post-submit updates require the applicable approval.

## Exact CSV schema

Use exactly these seven columns and this order:

| Column | Meaning |
| --- | --- |
| Company | Employer name |
| Role | Exact role title |
| LinkedIn URL | Canonical LinkedIn job URL and normal row identity |
| Research File | POSIX path relative to <home-directory>/jobhunt, the directory containing tracker.csv, such as applications/acme.md |
| Status | Fit label plus optional lifecycle |
| Last Applied | Confirmed application date in YYYY-MM-DD; otherwise blank |
| Notes | Free text owned by the user, such as recruiters or people contacted individually; blank by default. Preserve it on every change and write to it only when the user asks. |

The header row is:

Company,Role,LinkedIn URL,Research File,Status,Last Applied,Notes

Use UTF-8 and RFC-4180 quoting. Do not add hidden columns, formulas, or formatting metadata.

Keep detailed requirements, compensation, interviews, classification rationale, risks, sources, job IDs, repost analysis, and application notes in the research Markdown or private scratch ledger. The Notes column is only for the user's own short notes.

## Safe CSV writes

Before the first job:

1. Resolve and verify tracker.csv.
2. If it is missing, create it with the Write tool containing only the exact header line, then re-read it.
3. Read the complete file with the Read tool.
4. Confirm the exact seven-column header.
5. Confirm the `jobhunt` directory remains inside the active user's home directory.

For each stable selected job:

1. Extract the numeric job ID and canonicalize the URL to https://www.linkedin.com/jobs/view/<job-id>/, regardless of localized host, slug, query, or fragment.
2. Extract numeric job IDs from every existing nonblank LinkedIn URL and compare normalized IDs, not raw URL strings.
3. If multiple existing rows normalize to the same job ID, stop and reconcile them before any new write.
4. Reuse the one matching row regardless of legacy host, slug, query, fragment, or missing trailing slash. After confirming there is no collision, normalize that row's URL to the canonical form during the bounded update.
5. For a new row, write Company, Role, LinkedIn URL, blank Research File, Status = Researching, blank Last Applied, and blank Notes.
6. For an existing row, preserve Research File, Status, Last Applied, Notes, and user-authored values unless verified evidence supports a specific update.
7. If LinkedIn shows Applied but tracker history is blank or inconsistent, stop and reconcile.
8. Make the change with the Edit tool: replace one exact, unique row line, or insert a new row line at its sorted position as described in "Row order" below. Never rewrite the whole file.
9. Keep each row valid RFC-4180 UTF-8: seven fields, and quote a field that contains a comma, quote, or line break.
10. Re-read with the Read tool and verify the exact row, that nothing else changed, and that the rows around it are still in order, before selecting the next job.

Stop on a malformed row or duplicate canonical LinkedIn URLs.

### Row order

Keep data rows sorted by Company, compared case-insensitively, so digits come first and a lowercase name such as "n8n" sorts among the other N companies. Within one company, keep the order in which rows were added; do not sort by role.

~~~mermaid
flowchart TD
    A[Add a row] --> B{Company already has rows?}
    B -- Yes --> C[Replace that company's last row line with it plus the new line]
    B -- No --> D[Replace the first row whose company sorts after it with the new line plus it]
    D --> E{No later company?}
    E -- Yes --> F[Replace the last row line with it plus the new line]
    G[Company name changes] --> H[Remove the old line, then insert the new line at its sorted position]
    C --> I[Re-read: row present, neighbors in order]
    D --> I
    F --> I
    H --> I
~~~

1. **New row, existing company:** replace the company's last existing row line with that same line followed by the new line.
2. **New row, new company:** replace the first row line whose Company sorts after the new one with the new line followed by that line. If no company sorts after it, replace the last row line with that line followed by the new line. In an empty tracker, add the line after the header.
3. **Company name change:** remove the old line with one Edit, then insert the updated line at its new sorted position with another.
4. **Out-of-order file:** if the rows are not sorted, for example after the user edits the file in a spreadsheet, report it and offer a one-time re-sort that keeps every row and field unchanged. Do not re-sort silently.

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
2. Resolve their Research File paths inside <home-directory>/jobhunt/applications.
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
4. Change only the target section with the Edit tool, or create a new file with the Write tool.
5. Re-read with the Read tool and verify required headings, tables, links, dates, and the exact role section.
6. Update matching tracker rows with the relative path and verify them.

Do not store credentials, demographic answers, confidential work-system text, or unnecessary personal data.

## Manual intake

When the user hand-picks companies or roles, use each company's official careers page as the source of truth for discovery and research. Do not discover roles through LinkedIn search.

~~~mermaid
flowchart TD
    A[User hand-picks companies or roles] --> B[Open each company's official careers page]
    B --> C[List open roles matching the user's criteria]
    C --> D[Verify each official posting and research from it]
    D --> E[Write company Markdown with every researched role]
    E --> F{Exact LinkedIn post exists?}
    F -- Yes --> G[Track with canonical LinkedIn URL]
    F -- No --> H[Preview rows with official posting URL]
    H --> I{User approves?}
    I -- Yes --> J[Track with official posting URL]
    I -- No --> K[Keep role in Markdown only]
~~~

1. For each supplied company, open its official careers page and follow it to the job board it uses, such as Greenhouse, Ashby, Lever, Workday, SmartRecruiters, Personio, or a company-run site. Read the listings in the browser; do not call job-board APIs or feeds. Confirm the board belongs to the same company; similar slugs can belong to unrelated employers.
2. List every open role that matches the user's stated criteria. For a supplied role, find that exact posting on the careers page. Record excluded roles briefly in the company Markdown.
3. Research each role from its official posting first: requirements, location, work mode, compensation, and posting date. Then follow company-research.md for the rest.
4. Use LinkedIn only for a targeted lookup of the exact posting to get its canonical URL. A lookup is not discovery: never add roles found only on LinkedIn.
5. When the same official posting appears on LinkedIn several times, for example once per country, track one canonical URL and list the other copies in the role section.
6. When no LinkedIn post exists, write `LinkedIn: Not found on LinkedIn as of <date> (official careers posting only)` in the role section.

A company-only watchlist row or any normal row without an exact LinkedIn URL requires an explicit preview and approval. After approval, put the official posting URL in the LinkedIn URL column. Such rows cannot be deduplicated by LinkedIn job ID; compare official URLs instead, and reconcile manually if the role later appears on LinkedIn.

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
