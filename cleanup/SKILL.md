---
name: cleanup
description: Safely clean up existing code by improving names, removing proven dead code, splitting oversized classes or methods, and replacing hand-rolled generic utilities with established libraries. Use for cleanup, refactoring, dead-code removal, or no-regression code-hygiene requests.
---

# Cleanup

Improve maintainability without changing observable behavior.

## Preserve behavior

- Read and follow repository instructions, including `AGENTS.md` and
  `CONTRIBUTING.md`, before editing.
- Treat public APIs, contracts, persisted data, side effects, error behavior,
  and user-visible behavior as invariants unless the user explicitly changes
  the scope.
- Inspect the working tree and preserve unrelated user changes.
- Establish a baseline with relevant existing tests. Add characterization tests
  first when important behavior is not covered.
- Keep each change small and reviewable. Do not turn cleanup into a redesign or
  feature change.

## Clean up the code

- Make class, method, and variable names simple, concise, and human-readable.
  Rename related tests and call sites together.
- Remove dead code only after checking references, exports, configuration,
  reflection, dependency injection, and other dynamic uses.
- Split oversized classes and methods along cohesive responsibilities. Avoid
  merely moving complexity into fragmented helpers or pass-through wrappers.
- Before implementing generic functionality, check the language or platform
  standard library, existing project dependencies, and established popular
  libraries.
- Adopt a library only when it is maintained, compatible with the repository,
  appropriately licensed, and preferable in security, correctness, size, and
  operational cost. Preserve output and wire compatibility unless a migration
  is explicitly in scope.
- Remove superseded custom utilities and dependencies only after all callers
  have migrated and verification passes.

## Prevent regressions

- Run focused tests after each logical change, then the repository's applicable
  format, lint, typecheck, test, and build checks.
- Exercise integration boundaries affected by renames, dependency changes, or
  structural refactors.
- Compare behavior with the baseline. Fix regressions before proceeding; never
  weaken or delete a valid test merely to make the cleanup pass.
- If full verification is unavailable, stop short of claiming completion and
  report exactly what remains unverified and why.

Summarize the cleanup, the evidence that removed code was unused, any library
tradeoffs, and the checks that demonstrate behavior was preserved.
