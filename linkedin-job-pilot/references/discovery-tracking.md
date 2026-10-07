# Research and pre-application tracking

Read this file before the first discovery-row upsert, after each job's research finishes, and for manually supplied roles or companies.

## Canonical local paths

Resolve the active user's home directory once without deriving it from the current workspace.

- Tracker: <home-directory>/jobhunt/tracker.csv

Create `jobhunt` when missing. Reject symlinks or resolved paths that escape the active user's home directory. Do not search a workspace-local copy, another home directory, or a cloud fallback.

The tracker is the only research record. Each row holds a short research result in its research columns plus the application status. Do not write research Markdown or other per-company files.

## Lifecycle

~~~mermaid
flowchart LR
    A[Select LinkedIn job] --> B[Read company and exact title]
    B --> C[Parse tracker.csv]
    C --> D[Upsert row as Researching]
    D --> E[Research company and role]
    E --> F[Assign final fit]
    F --> G[Write research columns]
    G --> H[Verify the row]
    H --> J[Finalize Status]
    J --> K[Build application queue]
~~~

The initial CSV row, the research-column update, and the final Status update are authorized discovery writes. Schema changes, file moves/renames/deletions, writes outside `jobhunt`, and post-submit updates require the applicable approval.

## Exact CSV schema

Use exactly these ten columns and this order:

| Column | Meaning |
| --- | --- |
| Company | Employer name; with Role, the row identity |
| Role | Exact role title as the employer posts it; with Company, the row identity |
| Company Website | The company's main website as a bare URL, such as https://acme.com/; blank if not found |
| Summary | One plain line of at most 320 characters, without line breaks or Markdown: what the company does; its revenue, or `revenue not public`, plus funding or ownership; the role's location and work mode; the main fit reason; and the biggest gap or red flag for this role. Use only facts found in research. |
| Salary Range | Optional. A numeric pay range that the employer itself published for this role and its location, such as `€90K–€160K base + equity`, or a figure the user gives. Leave it blank when the posting has no number, when the only figure is an estimate (Glassdoor, Levels.fyi, Kununu, XING, aggregators, recruiters, or anecdotes), or when it covers another country. Never estimate or guess. |
| Glassdoor Review | Optional. The company's Glassdoor rating as seen on Glassdoor, with the review count when shown, such as `4.4/5 (17 reviews)`. Prefix a parent company's rating with its name, such as `Labelbox: 2.1/5 (91 reviews)`. Leave it blank when not found. Never estimate or guess. |
| Status | Fit label plus optional lifecycle |
| Last Applied | Confirmed application date in YYYY-MM-DD; otherwise blank |
| Last Interviewed | Date of the most recent interview for this row in YYYY-MM-DD; blank by default. Write it only when the user gives the date or approves a verified interview update. |
| Notes | Free text owned by the user, such as recruiters or people contacted individually; blank by default. Preserve it on every change and write to it only when the user asks. |

The header row is:

Company,Role,Company Website,Summary,Salary Range,Glassdoor Review,Status,Last Applied,Last Interviewed,Notes

Use UTF-8 and RFC-4180 quoting. Do not add hidden columns, formulas, or formatting metadata.

Do not store detailed requirements, interview reports, source lists, or long rationale anywhere durable; the Summary is the lasting record, and the application packet re-checks details from the official posting. Never store job-board or posting URLs; they change with reposts. Keep job IDs, posting URLs, occurrence positions, and repost analysis only in the private scratch ledger during a run. The Notes column is only for the user's own short notes.

## Safe CSV writes

Before the first job:

1. Resolve and verify tracker.csv.
2. If it is missing, create it with the Write tool containing only the exact header line, then re-read it.
3. Read the complete file with the Read tool.
4. Confirm the exact ten-column header.
5. Confirm the `jobhunt` directory remains inside the active user's home directory.

For each stable selected job:

1. Read the employer name and the exact role title. Use the official posting's title when it differs from the job card.
2. Compare Company and Role with every existing row, case-insensitively after trimming spaces.
3. If more than one existing row matches, stop and reconcile them before any new write.
4. Reuse the one matching row; a repost, another city, or another job ID for the same company and title is the same row.
5. For a new row, write Company, Role, blank research columns, Status = Researching, blank Last Applied, blank Last Interviewed, and blank Notes.
6. For an existing row, preserve the research columns, Status, Last Applied, Last Interviewed, Notes, and user-authored values unless verified evidence supports a specific update.
7. If LinkedIn shows Applied but tracker history is blank or inconsistent, stop and reconcile.
8. Make the change with the Edit tool: replace one exact, unique row line, or insert a new row line at its sorted position as described in "Row order" below. Never rewrite the whole file.
9. Keep each row valid RFC-4180 UTF-8: ten fields, and quote a field that contains a comma, quote, or line break.
10. Re-read with the Read tool and verify the exact row, that nothing else changed, and that the rows around it are still in order, before selecting the next job.

Stop on a malformed row or two rows with the same Company and Role.

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

Company plus Role is the CSV row identity. Keep LinkedIn job IDs, employer requisition IDs, posting URLs, occurrence positions, and repost clusters in the private ledger during the run only. When a repost or duplicate matters later, mention it briefly in the Summary.

- Consolidate every card or posting with the same company and title into one row, including reposts and copies for other cities.
- When one company posts two genuinely different roles under the same title, make the Role distinct by adding the team or city from the official posting, such as `Software Engineer (Payments)`.
- Block application preparation for unresolved duplicates.
- Add an official sibling role after confirming its exact title on the company's careers page.

## Research columns

After a role's research finishes, write its results into that row's research columns with one Edit:

1. Company Website, Salary Range, and Glassdoor Review are company or posting facts. Reuse the same Company Website and Glassdoor Review on every row of one company unless newer research changes them.
2. Write the Summary for the specific role. Rows of one company share the company and money clauses but differ in location, fit reason, and gap.
3. Quote any field that contains a comma or quote, and replace line breaks with spaces.
4. When research updates an existing row, replace only the research columns and Status; preserve Last Applied, Last Interviewed, and Notes.
5. A Salary Range the user gives is the user's value: preserve it like Notes, and replace it only when the user asks.

Do not store credentials, demographic answers, confidential work-system text, or unnecessary personal data in any column.

## Manual intake

When the user hand-picks companies or roles, use each company's official careers page as the source of truth for discovery and research. Do not discover roles through LinkedIn search.

~~~mermaid
flowchart TD
    A[User hand-picks companies or roles] --> B[Open each company's official careers page]
    B --> C[List open roles matching the user's criteria]
    C --> D[Verify each official posting and research from it]
    D --> H[Preview the proposed rows]
    H --> I{User approves?}
    I -- Yes --> J[Track by Company and Role]
    I -- No --> K[Report the role without tracking it]
~~~

1. For each supplied company, open its official careers page and follow it to the job board it uses, such as Greenhouse, Ashby, Lever, Workday, SmartRecruiters, Personio, or a company-run site. Read the listings in the browser; do not call job-board APIs or feeds. Confirm the board belongs to the same company; similar slugs can belong to unrelated employers.
2. List every open role that matches the user's stated criteria. For a supplied role, find that exact posting on the careers page. Report excluded roles briefly to the user; do not track them.
3. Research each role from its official posting first: requirements, location, work mode, compensation, and posting date. Then follow company-research.md for the rest.
4. Do not use LinkedIn for manual intake; never add roles found only on LinkedIn.

Every manually added row requires an explicit preview and approval. The preview shows every column of each proposed row, including the research columns.

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
