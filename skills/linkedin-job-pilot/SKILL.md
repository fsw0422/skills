---
name: linkedin-job-pilot
description: Discover, curate, research, and track LinkedIn roles, then prepare, submit, and update applications using a user-provided PDF resume, local Markdown research files, a local CSV tracker, and explicit approval gates. Use when the user asks to browse or shortlist jobs, provide a company or role manually, evaluate a role, apply through LinkedIn or an employer site, or track applications. Require a readable PDF resume before doing any work; resume creation and revision belong to resume-pilot.
---

# LinkedIn Job Pilot

Run an evidence-based job search while leaving every consequential choice with the user.

Use the authenticated browser for LinkedIn, employer application sites, and the approved Reddit fallback. Store all durable research and tracking data inside the current workspace. Never fall back to a previous workspace, a home-directory cache, or a cloud file.

## Canonical local resources

At the start of each run:

1. Resolve the workspace root once with pwd -P.
2. Use <workspace-root>/jobs as the only durable job-data root.
3. Use <workspace-root>/jobs/applications for company research Markdown.
4. Use <workspace-root>/jobs/tracker.csv for the tracker.
5. Use references/company-research-template.md as the research template.

Create the jobs and jobs/applications directories when missing. Reject symlinks or resolved paths that escape the workspace root. The tracker is a file, not a directory.

The exact tracker columns are:

Company, Role, LinkedIn URL, Research File, Status, Last Applied

Store Research File as a POSIX path relative to jobs/tracker.csv, for example applications/acme.md.

## Default explicit invocation

When the user explicitly invokes this skill, first apply the mandatory PDF gate. Once a PDF is verified, an invocation with no additional scope, or only Start discovery, begins from the already-open LinkedIn Jobs tab using its current search, collection, location, and filters.

Run the complete workflow: capacity preflight, ten-page discovery horizon, immediate CSV tracking, one research agent per stable job, company-role expansion, automatic Markdown research-file population, final four-label fit classification, and application queue preparation. Ask only for a genuinely missing material search criterion or an ambiguous choice between multiple open LinkedIn collections.

## Mandatory PDF resume gate

Before opening LinkedIn, reading the tracker, researching a company, evaluating a role, or entering an application workflow, require one exact PDF resume for the run. If no accessible PDF is provided, ask for it and stop.

Verify that the file exists, is a PDF, opens successfully, and contains usable extractable text. Record its absolute path, visible filename, SHA-256 hash, page count, and modification time. If it is unreadable, image-only, ambiguous, or replaced during the run, stop and ask for a valid PDF again.

Treat the PDF as immutable input. This skill may read it for fit assessment, draft answers from verified contents, and attach that exact file after approval. It must not critique, edit, optimize, rebuild, rename, copy, commit, push, or upload it to LinkedIn preferences. Resume work belongs to resume-pilot.

## Non-negotiable approvals

Research, comparison, local Markdown authoring, and bounded tracker updates may proceed without approval. Stop and obtain explicit approval immediately before:

1. Opening an application workflow that may save an application or expose applicant data.
2. Attaching the provided PDF to an application.
3. Submitting an application or sending any application-related message.
4. Activating Top Choice, I’m interested, or another recruiter-visible signal.
5. Posting an approved question to r/cscareerquestionsEU.
6. Changing the tracker schema or research template.
7. Moving, renaming, deleting, merging, or overwriting local research files outside the bounded rules below.
8. Writing outside <workspace-root>/jobs.

An approval must identify the company, role, action, materials, recipient, and exact message when relevant. Earlier approval for another role or action does not carry over.

Never infer work authorization, sponsorship, relocation, compensation expectations, notice period, demographic answers, disability, veteran status, criminal history, or other sensitive application data.

## Bounded local-write authorization

Explicitly invoking discovery or manual-role research authorizes these bounded workspace-local writes for that run:

- Create or update jobs/tracker.csv without changing its six-column schema.
- Create or update jobs/applications/<company-file>.md from the canonical Markdown template.
- Replace Research File values with verified relative Markdown paths.
- Update Status after research and Last Applied only after the separate post-submit approval.

The primary agent is the sole writer. Subagents return structured research only.

For every CSV or Markdown change:

1. Read and parse the current file.
2. Preserve row order, user-authored content, and unrelated fields.
3. Write a temporary sibling file.
4. Atomically rename it over the target.
5. Re-read and verify the exact row or role section.
6. Stop on parse errors, ambiguous company identity, multiple plausible research files, or path escape.

Use canonical LinkedIn URL as tracker row identity and role-section identity. Never split or join CSV on commas; use an RFC-4180-aware parser and UTF-8. Use YYYY-MM-DD for newly recorded dates.

## Workflow

~~~mermaid
flowchart TD
    A[Readable PDF] --> B[Resolve workspace jobs paths]
    B --> C[Discover LinkedIn roles]
    C --> D[Upsert tracker.csv as Researching]
    D --> E[Run one research agent per job]
    E --> F[Create or update company Markdown]
    F --> G[Verify Markdown and relative path]
    G --> H[Finalize CSV fit label]
    H --> I{More result pages?}
    I -- Yes --> C
    I -- No --> J[Build Great Fit then Normal Fit queue]
    J --> K{Final status Investigate and public question needed?}
    K -- Yes --> L[Draft exact Reddit post]
    L --> M{User approves exact post?}
    M -- Yes --> N[Post only to r/cscareerquestionsEU]
    M -- No --> O[Keep documented gap]
    K -- No --> O
    O --> P{User approves named application workflow?}
    P -- No --> Q[Stop or move to next role]
    P -- Yes --> R[Inspect form and prepare final packet]
    R --> S{User approves exact submission?}
    S -- Yes --> T[Submit and verify]
    T --> U{Tracking update approved?}
    U -- Yes --> V[Update tracker.csv]
~~~

## Route the work

### Discovery

Before discovery, read references/subagent-orchestration.md, references/job-discovery.md, references/company-research.md, and references/discovery-tracking.md.

Inspect every unique visible job through page 10, or stop earlier when LinkedIn genuinely ends. Select cards sequentially in the primary agent. Immediately upsert each stable canonical URL in tracker.csv as Researching. Complete and verify the current page’s research files and final statuses before advancing.

Do not cap tracking at a top-ten shortlist. A manually supplied role or company uses the same identity, research, persistence, and approval rules.

### Research

Use references/company-research.md and references/company-research-template.md. Keep one Markdown research file per normalized company when identity is unambiguous. Append one role section per canonical LinkedIn URL. Reuse current company facts, but verify role facts separately.

If multiple plausible local files exist for one company, use the file already referenced by the tracker row. If no row resolves the ambiguity, stop for user direction rather than merging or creating another file.

Use official sources first, then reputable reporting. Check recent role- and location-relevant Reddit, Blind, and Glassdoor reports when accessible and material. Treat anonymous reports as anecdotal.

A public Reddit fallback is allowed only after ordinary research, Markdown and CSV verification, a final Status of Investigate, and a remaining decision-critical gap. Never propose a public post for Great Fit, Normal Fit, or Skip.

### Application queue

Build the queue from the local CSV after research. Process A — Great Fit first, then B — Normal Fit. Include Investigate only when the user explicitly advances it. Exclude Skip.

A role must remain open and must not have Last Applied within the previous 30 calendar days. Treat confirmed reposts as one application opportunity. Never auto-reapply.

### Applications and Premium

Before opening an application flow, read references/application-gates.md. Prepare the exact decision packet and preserve every approval gate.

Use visible Premium information as research and prioritization evidence only. Do not claim it guarantees ranking or response. Do not use bots, unofficial APIs, scrapers, mass invitations, or automated engagement.

### Post-application tracking

After reliable submission confirmation and explicit approval for the local update, read references/tracking.md. Update the existing CSV row, preserve the fit label, append the lifecycle, and set Last Applied to the confirmed date. Never mark Applied from a click or assumption.

## Completion standard

Report:

- PDF filename and hash used for fit.
- Workspace root and exact jobs paths.
- Search criteria, pages inspected, counts, duplicates, and stop reason.
- Final totals for A — Great Fit, B — Normal Fit, Investigate, and Skip.
- Research Markdown paths and exact tracker rows.
- Partial write or verification failures.
- Eligible application queue.
- Exact outcome of any approved application action.

Never mark an application submitted without reliable confirmation.
