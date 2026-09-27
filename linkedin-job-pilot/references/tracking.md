# Post-application tracker updates

Read this file only after submission is reliably confirmed and the exact local update was approved.

Identify the existing tracker.csv row by canonical LinkedIn URL. Update that row; never create a second row for the same vacancy. Research Markdown remains a research record rather than an application timeline.

## Consistency flow

~~~mermaid
sequenceDiagram
    participant A as Agent
    participant C as tracker.csv
    A->>C: Parse and find canonical LinkedIn URL
    A->>A: Reconfirm approved Status and date
    A->>C: Atomically update Status and Last Applied
    C-->>A: Reparse exact row
    A->>A: Verify against submission evidence
~~~

## Confirmed values

Use only a confirmation page, receipt, or application ID:

- Status: preserve the fit label and append or replace the middle-dot lifecycle with Applied.
- Last Applied: confirmed date in YYYY-MM-DD.

Do not overwrite Company, Role, LinkedIn URL, or Research File during an ordinary post-submit update.

Write a temporary sibling CSV, atomically rename it over tracker.csv, then reparse and verify the exact row. If submission is ambiguous, do not update Last Applied or claim Applied. Never retry or mark the role applied without renewed approval.

## Later stages

Use the same row for verified recruiter screen, interview, rejection, withdrawal, or offer changes. Preserve the fit label and change only the lifecycle. Each new external write must be authorized by the user's request or an exact approved manifest. Preserve Last Applied and never replace a newer stage with an older one.
