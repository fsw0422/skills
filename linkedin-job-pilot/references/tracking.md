# Post-application tracker updates

Read this file only after submission is reliably confirmed. The user has provided standing authorization for the scoped update defined below, so do not ask for a separate tracker approval.

Identify the existing tracker.csv row by canonical LinkedIn URL. Update that row; never create a second row for the same vacancy.
## Consistency flow

~~~mermaid
sequenceDiagram
    participant A as Agent
    participant C as tracker.csv
    A->>C: Parse and find canonical LinkedIn URL
    A->>A: Derive scoped Applied status and confirmed date
    A->>C: Edit the row's Status and Last Applied
    C-->>A: Re-read exact row
    A->>A: Verify against submission evidence
~~~

## Confirmed values

Use only a confirmation page, receipt, or application ID:

- Status: preserve the fit label and append or replace the middle-dot lifecycle with Applied.
- Last Applied: confirmed date in YYYY-MM-DD.

## Standing authorization

After reliable submission confirmation, automatically update the existing canonical row without asking again. The standing authorization is limited to:

- preserving the existing fit label and setting its lifecycle to `Applied`;
- setting `Last Applied` to the confirmed submission date.

It does not authorize creating another row, changing the schema, editing company or role identity, recording an unconfirmed attempt, or changing later lifecycle stages.

Do not overwrite Company, Role, LinkedIn URL, the research columns (Company Website, Summary, Salary Range, Glassdoor Review), Last Interviewed, or Notes during an ordinary post-submit update.

Read tracker.csv with the Read tool, replace only that row's line with the Edit tool, then re-read and verify the exact row and that nothing else changed. If submission is ambiguous, do not update Last Applied or claim Applied. Never retry or mark the role applied without renewed approval.

## Later stages

Use the same row for verified recruiter screen, interview, rejection, withdrawal, or offer changes. Preserve the fit label and change only the lifecycle. For an interview, also set Last Interviewed to the interview date in YYYY-MM-DD when the user gives it; replace it only with a later date. Each new external write must be authorized by the user's request or an exact approved manifest. Preserve Last Applied and never replace a newer stage with an older one.
