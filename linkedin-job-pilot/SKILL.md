---
name: linkedin-job-pilot
description: Discover, curate, research, and track LinkedIn roles, then prepare, submit, and update applications, including cover letter PDFs, using a user-provided PDF resume, local Markdown research files, a local CSV tracker, and a single submit-approval application flow. Use when the user asks to browse or shortlist jobs, provide a company or role manually, evaluate a role, apply through LinkedIn or an employer site, write a cover letter, or track applications. Require a readable PDF resume before doing any work; resume creation and revision belong to resume-pilot.
---

# LinkedIn Job Pilot

Run an evidence-based job search while leaving every consequential choice with the user.

For all browser work on LinkedIn, careers pages, employer application sites, and the approved Reddit fallback, read and follow [../browser-pilot/SKILL.md](../browser-pilot/SKILL.md): browser choice, tabs, allowed tools, page loading, sign-in handoff, and form filling and read-back. This skill's approval and data rules take precedence over it.

Store all durable research and tracking data under the active user's home directory in `jobhunt`. Never fall back to a workspace-local copy, another home directory, a cache, or a cloud file.

## Canonical local resources

At the start of each run:

1. Resolve the active user's home directory once without deriving it from the current workspace.
2. Use <home-directory>/jobhunt as the only durable job-data root.
3. Use <home-directory>/jobhunt/applications for company research Markdown.
4. Use <home-directory>/jobhunt/tracker.csv for the tracker.
5. Use references/company-research-template.md as the research template.
6. Use <home-directory>/jobhunt/applicant-profile.md for the user's private application answers. Never commit, copy, or upload it; see references/applicant-profile.md.

Create `jobhunt` and `jobhunt/applications` when missing. Reject symlinks or resolved paths that escape the active user's home directory. The tracker is a file, not a directory.

The exact tracker columns are:

Company, Role, LinkedIn URL, Research File, Status, Last Applied, Last Interviewed, Notes

Last Interviewed is the date of the most recent interview for that row in YYYY-MM-DD, blank by default. Write it only when the user gives the date or approves a verified interview update.

Notes is free text owned by the user, for example recruiters or people contacted individually. Preserve it on every change, and write to it only when the user asks.

Store Research File as a POSIX path relative to <home-directory>/jobhunt, the directory containing tracker.csv. Example: applications/acme.md.

## Default explicit invocation

When the user explicitly invokes this skill, first apply the mandatory PDF gate. Once a PDF is verified, an invocation with no additional scope, or only Start discovery, begins from the already-open LinkedIn Jobs tab in the built-in browser using its current search, collection, location, and filters. If no such tab exists, open LinkedIn Jobs in the built-in browser and use a secure browser handoff for sign-in when needed.

Run the complete workflow: capacity preflight, ten-page discovery horizon, immediate CSV tracking, one research agent per stable job, company-role expansion, automatic Markdown research-file population, final four-label fit classification, and application queue preparation. Ask only for a genuinely missing material search criterion or an ambiguous choice between multiple open LinkedIn collections.

## Mandatory PDF resume gate

Before opening LinkedIn, reading the tracker, researching a company, evaluating a role, or entering an application workflow, require one exact PDF resume for the session. If no accessible PDF is provided, ask for it and stop.

Verify the resume once per session, the first time the skill runs: open it with the Read tool to confirm it is a PDF with usable extractable text, and record its absolute path, visible filename, page count, and SHA-256 from `shasum -a 256`. Later invocations in the same session reuse that record without re-reading the file or reporting the check again. Immediately before each upload, run `shasum -a 256` again and compare it with the recorded hash; if it differs, stop and ask the user to confirm the new file, then verify it again. If the file is unreadable, image-only, or ambiguous, stop and ask for a valid PDF.

Treat the PDF as immutable input. This skill may read it for fit assessment, draft answers from verified contents, and attach that exact file after the user approves submission. Extract the exact phone number, LinkedIn URL, and residence from it when those values are unambiguous so application forms can reuse them without asking again. When the resume has no phone number, ask the user for it once per session, the first time a form or cover letter needs it, and reuse that value for the rest of the session; never write it into the skill or research Markdown. Extraction is not authorization to transmit them: show the values in the application packet and transmit them only after the submit approval below. The skill must not critique, edit, optimize, rebuild, rename, copy, commit, push, or upload the resume to LinkedIn preferences. Resume work belongs to resume-pilot.

## Applicant profile questionnaire

Before the first application work in a session, read references/applicant-profile.md and the user's profile file. If the catalog has questions the profile does not answer yet, ask all of them in one message, save the answers, and never ask them again. During an application, when a form asks a personal question that the profile does not cover, ask for the answer and whether to save it to the profile. Do not propose skill changes for new questions; the user maintains the catalog.

## Non-negotiable approvals

Research, comparison, local Markdown authoring, cover letter drafting and PDF rendering, bounded tracker updates, and read-only application-form inspection may proceed without approval. For an ordinary named application, use exactly one approval gate:

1. **Submit approval:** after inspecting the form, present one complete application packet with every drafted answer, the full cover letter text and its PDF, every personal-data value, and every named file upload. When the user replies `submit` for that named role, enter everything in the browser, upload the files, verify the populated form against the packet, and click the final submit control without asking again.

Stop before submitting and ask again only when the populated form cannot be made to match the packet, a required field still lacks an answer, or a later form step reveals new personal data, files, or substantive content that the packet did not show. A newly revealed field whose answer exactly matches an applicant-profile answer or a value from the verified resume is not new: fill it, list it in the outcome report, and continue without asking. Present only the remaining items; the user's next `submit` covers them.

Do not ask for approval merely to open, navigate to, or inspect an application form when that action is read-only and shares no applicant data. If opening or advancing the form would itself save an application, transmit applicant data, or trigger a recruiter-visible action, do it only after the user says `submit`.

Outside the ordinary submit approval, stop and obtain explicit approval immediately before:

1. Sending any application-related message.
2. Activating Top Choice, I’m interested, or another recruiter-visible signal.
3. Posting an approved question to r/cscareerquestionsEU.
4. Changing the tracker schema or research template.
5. Moving, renaming, deleting, merging, or overwriting local research files outside the bounded rules below.
6. Writing outside <home-directory>/jobhunt, except owner-only temporary scratch ledgers described in references/job-discovery.md and the temporary folder that scripts/render-cover-letter.py creates and deletes.
7. Changing the user-level Codex configuration, including discovery concurrency.

An approval must identify the company, role, action, materials, recipient, and exact message when relevant. Earlier approval for another role or action does not carry over.

Use the user's applicant-profile answers when a field has the same meaning and scope. Otherwise never infer work authorization, sponsorship, relocation, compensation expectations, notice period, demographic answers, disability, veteran status, criminal history, or other sensitive application data.

## Tooling: no ad-hoc scripts

Do not write one-off code at any step of this skill: no shell pipelines, inline Python, curl or API calls, or custom browser JavaScript. Use only these tools:

| Need | Use |
| --- | --- |
| Open, read, check, fill, and submit any website, including careers pages, job boards, and application forms | The browser tools allowed by browser-pilot |
| Read the resume or another PDF | The Read tool |
| Record the resume's SHA-256 | `shasum -a 256 <resume.pdf>`, the only allowed hashing command |
| Change tracker.csv, research Markdown, the applicant profile, or `letter.txt` | The Read, Edit, and Write tools |
| Render and verify a cover letter PDF | `scripts/render-cover-letter.py`, which prints pages, SHA-256, and text and header match |
| Research the web | Web search and web fetch tools, or subagents that use them |

Never run custom JavaScript in a page; browser-pilot lists the allowed browser tools. If a step cannot be done with these tools, stop and tell the user what is missing instead of improvising a script.

## Bounded local-write authorization

Explicitly invoking discovery or manual-role research authorizes these bounded home-local writes for that run:

- Create or update <home-directory>/jobhunt/tracker.csv without changing its eight-column schema.
- Create or update <home-directory>/jobhunt/applications/<company-file>.md from the canonical Markdown template.
- Replace Research File values with verified relative Markdown paths.
- After reliable submission confirmation, automatically update the existing tracker row to preserve the fit label, set the lifecycle to `Applied`, and record `Last Applied`. This standing authorization covers only those two fields for the confirmed application; all other tracker changes keep their normal authorization requirements.

The run may also create or update <home-directory>/jobhunt/applicant-profile.md with answers the user gives in the questionnaire or agrees to save, as described in references/applicant-profile.md.

The run may also create or update <home-directory>/jobhunt/cover-letters/<company-file>-<job-id>/ with a drafted letter.txt and its PDF without approval, as described in references/cover-letter.md.

For browser-pilot's Playwright output rule, this skill's folder is <home-directory>/jobhunt/.playwright-mcp/. Playwright may write its snapshots, console logs, and screenshots there without approval; they are temporary browser artifacts, not research or tracking records. If Playwright's output folder would resolve outside <home-directory>/jobhunt, for example because the session started in another directory, stop and ask before using it.

The primary agent is the sole writer. Subagents return structured research only.

For every CSV or Markdown change:

1. Read the current file with the Read tool.
2. Change only the target row or section with the Edit tool, replacing one exact, unique line or block; use the Write tool only to create a new file. Never rewrite the whole tracker.
3. Preserve user-authored content and unrelated fields. Keep tracker rows sorted by Company, case-insensitively, by inserting each new or renamed row at its sorted position; see "Row order" in references/discovery-tracking.md.
4. Keep CSV rows valid RFC-4180 UTF-8: eight fields, and quote a field that contains a comma, quote, or line break.
5. Re-read with the Read tool and verify the exact row or role section, and that nothing else changed.
6. Stop on a malformed row, ambiguous company identity, multiple plausible research files, or path escape.

Use https://www.linkedin.com/jobs/view/<job-id>/ as the canonical row identity and role-section identity. Normalize localized hosts, slugged paths, query parameters, and fragments to this numeric-ID form. Use YYYY-MM-DD for newly recorded dates.

## Workflow

~~~mermaid
flowchart TD
    A[Readable PDF] --> B[Resolve home jobhunt paths]
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
    O --> P[Inspect application form read-only]
    P --> Q[Draft answers and render cover letter PDF]
    Q --> R[Present full application packet]
    R --> S{User says submit?}
    S -- No --> T[Revise, stop, or move to next role]
    T --> R
    S -- Yes --> U[Enter data, upload files, verify form]
    U --> V{Form matches packet?}
    V -- No --> R
    V -- Yes --> W[Submit and verify]
    W --> X{Submission reliably confirmed?}
    X -- Yes --> Y[Update tracker.csv automatically]
    X -- No --> Z[Report unconfirmed outcome]
~~~

## Route the work

### Discovery

Before discovery, read references/subagent-orchestration.md, references/job-discovery.md, references/company-research.md, and references/discovery-tracking.md.

Inspect every unique visible job through page 10, or stop earlier when LinkedIn genuinely ends. Select cards sequentially in the primary agent. Immediately upsert each stable canonical URL in tracker.csv as Researching. Complete and verify the current page’s research files and final statuses before advancing.

Do not cap tracking at a top-ten shortlist. A manually supplied role or company uses the same identity, research, persistence, and approval rules. For hand-picked companies or roles, discover and research openings on each company's official careers page, not through LinkedIn search; see Manual intake in references/discovery-tracking.md.

### Research

Use references/company-research.md and references/company-research-template.md. Keep one Markdown research file per normalized company when identity is unambiguous. Append one role section per canonical LinkedIn URL. Reuse current company facts, but verify role facts separately.

If multiple plausible local files exist for one company, use the file already referenced by the tracker row. If no row resolves the ambiguity, stop for user direction rather than merging or creating another file.

Use official sources first, then reputable reporting. Check recent role- and location-relevant Reddit, Blind, and Glassdoor reports when accessible and material. Treat anonymous reports as anecdotal.

A public Reddit fallback is allowed only after ordinary research, Markdown and CSV verification, a final Status of Investigate, and a remaining decision-critical gap. Never propose a public post for Great Fit, Normal Fit, or Skip.

### Application queue

Build the queue from the local CSV after research. Process A — Great Fit first, then B — Normal Fit. Include Investigate only when the user explicitly advances it. Exclude Skip.

A role must remain open and must not have Last Applied within the previous 30 calendar days. Treat confirmed reposts as one application opportunity. Never auto-reapply.

### Applications and Premium

Before opening an application flow, read references/application-gates.md. Prepare the full application packet and preserve the submit approval. When a form asks for or accepts a cover letter, also read references/cover-letter.md.

Use visible Premium information as research and prioritization evidence only. Do not claim it guarantees ranking or response. Do not use bots, unofficial APIs, scrapers, mass invitations, or automated engagement.

### Post-application tracking

After reliable submission confirmation, read references/tracking.md and apply the user's standing authorization without asking again. Update the existing CSV row, preserve the fit label, set the lifecycle to `Applied`, and set Last Applied to the confirmed date. Never mark Applied from a click or assumption, and never extend this standing authorization to another lifecycle, field, row, or schema change.

## Completion standard

Report:

- PDF filename and hash used for fit.
- Resolved home directory and exact jobhunt paths.
- Search criteria, pages inspected, counts, duplicates, and stop reason.
- Final totals for A — Great Fit, B — Normal Fit, Investigate, and Skip.
- Research Markdown paths and exact tracker rows.
- Partial write or verification failures.
- Eligible application queue.
- Exact outcome of any approved application action.
- Cover letter text and PDF paths for any application that used one.

Never mark an application submitted without reliable confirmation.
