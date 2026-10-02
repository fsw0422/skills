# Cover letters

Read this file when an application form asks for or accepts a cover letter, either as a file upload or as a text box.

The cover letter speaks for the user. Always draft the full version, save it, and render the PDF when the form wants a file, all without asking for approval. Show the exact text and PDF details in the application packet. The letter is typed or uploaded only after the user says `submit`.

## Flow

~~~mermaid
flowchart TD
    A[Form asks for or accepts a cover letter] --> B[Draft from the resume, job post, and research]
    B --> C{Upload field or text box?}
    C -- Upload field --> D[Save letter.txt and render one-page PDF]
    D --> E[Verify PDF]
    E --> F[Show letter text and PDF details in application packet]
    C -- Text box --> F
    F --> G{User says submit?}
    G -- Revise --> B
    G -- Yes --> H[Type text or upload PDF with the rest of the form]
    H --> I[Submit application]
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
- Point out any sentence the user should check before saying `submit`.

## Full-letter default

Always use the full 150-to-250-word letter described above whenever an application requests or accepts a cover letter. Do not offer A/B length choices or a routine `Do not include` option. Show one optimized full draft in the application packet; the user may request edits before saying `submit`.

If a hard character or file limit cannot accept the full version, produce the longest compliant version that preserves the same structure and substance, explain the limit, and include that exact text in the application packet.

## Save and render

Save the drafted letter without asking for approval in `<home-directory>/jobhunt/cover-letters/<company-file>-<job-id>/`:

- `letter.txt` holds the exact drafted text. Write it through a temporary sibling file and an atomic rename.
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

Use `--paper letter` for postings in the US or Canada. The header uses the name and contact line exactly as they appear on the resume; show them with the letter in the application packet. If the script is unavailable, use another tool that produces the same one-page PDF, and apply the same checks.

If the script reports that the letter does not fit on one page, shorten it and render again. If the user asks for edits, update `letter.txt`, render again, and show the new version. Never keep a PDF that differs from `letter.txt`.

## Verify

Before presenting the application packet:

1. Confirm the PDF opens and has exactly one page.
2. Extract its text, for example with `pdftotext`, and confirm it matches `letter.txt`, the header, and the sign-off.
3. Record the path, filename, page count, and SHA-256 hash.
4. When possible, look at an image of the page to catch layout problems.

Keep cover letters out of the company research Markdown. It is a research record, not an application timeline.

## Upload

Attach the PDF, or type the text, only after the user says `submit`, together with the rest of the form and the same way as attaching the resume. If the letter changes after the packet was shown, show the new version before transmitting it.

Never upload the cover letter in place of the resume, and never add it to LinkedIn `My qualifications`.
