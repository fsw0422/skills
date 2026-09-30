# Cover letters

Read this file when an application form asks for a cover letter, either as a file upload or as a text box.

The cover letter speaks for the user. Always draft the full version, include its exact text in the bundled Gate 1 packet, and only after approval save it, turn it into a PDF, or put it in the form.

## Flow

~~~mermaid
flowchart TD
    A[Form asks for a cover letter] --> B[Draft from the resume, job post, and research]
    B --> C[Show the exact full letter in Gate 1 packet]
    C --> D{User approves content and entry or upload?}
    D -- Revise --> B
    D -- Yes --> E{Upload field or text box?}
    E -- Text box --> H[Enter exact approved text]
    E -- Upload field --> F[Save text and render one-page PDF]
    F --> G[Verify PDF]
    G --> H[Upload exact approved PDF]
    H --> I[Include letter and file details in Gate 2 packet]
    I --> J{User approves final submission?}
    J -- Yes --> K[Submit application]
    J -- No --> L[Stop or revise]
~~~

## Style

Write the way the user asked:

- Colloquial and warm, like a real person talking.
- Full of excitement. Use `!` to show it.
- Only easy, everyday words. No buzzwords or stiff corporate phrases.
- Short sentences. Simple and concise: about 150 to 250 words in three or four short paragraphs, always one page.
- Easy to read at a glance.

Use this shape:

1. A greeting, such as `Hi Acme team!`. Use a person's name only when the posting or research names them.
2. Why this role and company excite the user, with one or two specific, verified reasons.
3. Two or three matching experiences, taken only from the resume.
4. A short, warm close.
5. A sign-off with the name exactly as it appears on the resume.

Write in English unless the posting asks for another language. In that case, ask the user first.

## Truth rules

The excited tone is the user's chosen style. The facts inside the letter must still be true:

- Use only experience, skills, titles, dates, and numbers that appear in the provided resume PDF.
- Use only company facts from the posting or cited research.
- Never invent metrics, responsibilities, relationships, referrals, or company knowledge.
- Leave out salary, visa or work authorization, notice period, and other sensitive facts unless the user supplies them for this letter.
- Point out any sentence the user must confirm.

## Full-letter default

Always use the full 150-to-250-word letter described above whenever an application requests or accepts a cover letter. Do not offer A/B length choices or a routine `Do not include` option. Show one optimized full draft and allow the user to approve it or request edits.

If a hard character or file limit cannot accept the full version, produce the longest compliant version that preserves the same structure and substance, explain the limit, and include that exact text in Gate 1. The user may approve the exact letter and its listed entry or upload in the same reply. This does not approve final submission.

## Save and render

After the user approves the exact text and listed entry or upload in Gate 1, save it in `<home-directory>/jobhunt/cover-letters/<company-file>-<job-id>/`:

- `letter.txt` holds the exact approved text. Write it through a temporary sibling file and an atomic rename.
- The PDF is named `<First>-<Last>-Cover-Letter-<Company>.pdf`, because recruiters see this name. Take the name from the resume and replace spaces and unsafe characters with hyphens. Create it only when the form wants a file.

Render the PDF with:

```sh
python3 scripts/render-cover-letter.py \
  --letter <folder>/letter.txt \
  --name "<name from the resume>" \
  --contact "<email · phone · city from the resume>" \
  --title "<Name> – Cover Letter – <Company>" \
  --date "<today, such as 29 September 2026>" \
  --paper a4 \
  --out "<folder>/<PDF name>"
```

Use `--paper letter` for postings in the US or Canada. The header uses the name and contact line exactly as they appear on the resume; show them with the letter for approval. If the script is unavailable, use another tool that produces the same one-page PDF, and apply the same checks.

If the script reports that the letter does not fit on one page, shorten it and get the new text approved. If the user changes the letter later, update `letter.txt` and render again. Never keep a PDF that differs from the approved text.

## Verify

Before the final packet:

1. Confirm the PDF opens and has exactly one page.
2. Extract its text, for example with `pdftotext`, and confirm it matches the approved letter, header, and sign-off.
3. Record the path, filename, page count, and SHA-256 hash.
4. When possible, look at an image of the page to catch layout problems.

Keep cover letters out of the company research Markdown. It is a research record, not an application timeline.

## Upload

Attach the PDF, or type the text, only after the user approves that exact upload or entry in Gate 1, the same way as attaching the resume. Show the letter text, PDF filename, page count, and SHA-256 again in the Gate 2 packet. If anything changes after Gate 1, ask again before transmitting the changed content.

Never upload the cover letter in place of the resume, and never add it to LinkedIn `My qualifications`.
