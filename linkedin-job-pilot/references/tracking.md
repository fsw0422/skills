# Post-application tracker updates

Read this file only after submission is reliably confirmed. The user has provided standing authorization for the scoped update defined below, so do not ask for a separate tracker approval.

Identify the existing tracker.csv row by Company and Role. Update that row; never create a second row for the same vacancy.
## Consistency flow

~~~mermaid
sequenceDiagram
    participant A as Agent
    participant C as tracker.csv
    A->>C: Parse and find the Company and Role row
    A->>A: Derive scoped Applied status
    A->>C: Edit the row's Status
    C-->>A: Re-read exact row
    A->>A: Verify against submission evidence
~~~

## Confirmed values

Use only a confirmation page, receipt, or application ID:

- Status: preserve the fit label and append or replace the middle-dot lifecycle with Applied.

## Standing authorization

After reliable submission confirmation, automatically update the existing row without asking again. The standing authorization is limited to preserving the existing fit label and setting its lifecycle to `Applied`.

It does not authorize creating another row, changing the schema, editing company or role identity, recording an unconfirmed attempt, or changing later lifecycle stages.

Do not overwrite Company, Role, the research columns (Company Website, Summary, Salary Range, Glassdoor Review), or Notes during an ordinary post-submit update.

Read tracker.csv with the Read tool, replace only that row's line with the Edit tool, then re-read and verify the exact row and that nothing else changed. If submission is ambiguous, do not claim Applied. Never retry or mark the role applied without renewed approval.

## Later stages

Use the same row for verified recruiter screen, technical round, interview, rejection, withdrawal, or offer changes, such as `B — Normal Fit · Technical Round`. Preserve the fit label and change only the lifecycle. Write dates only into Notes, and only when the user gives them. Each new external write must be authorized by the user's request or an exact approved manifest. Never replace a newer stage with an older one.
