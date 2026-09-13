# Git Etiquette

- Get permission before committing; permission need only be granted once per conversation.
- Make each commit an independently understandable and verifiable change.
  Prefer the fewest coherent, reviewable commits: keep a feature or fix with its tests, and split
  only independent concerns or necessary preparatory refactors—not files or hunks.
- When moving code before changing its behavior, commit the move first and the behavior change
  second.
- Every commit must remain buildable and pass all relevant available checks; report anything not
  run.
  Do not create WIP commits or rely on later commits to restore a working tree.
- Format only code touched by the commit.
- Stage selectively with `git add -p` or explicit paths; never use `git add -A` for a commit.
- Do not use conventional prefixes such as `feat:` or `fix:`.
  Describe why the change was needed—the motivation, constraint, or bug—not what the diff does.
  Omit the body when the subject says enough.
- Before committing, inspect `git status` and the complete staged diff.
  Preserve unrelated work; never revert, overwrite, or stash changes you did not make.
- Do not discard changes or rewrite history—including with `reset --hard`, `clean`, amend, rebase,
  or force-push—without explicit permission in the current conversation.
- Do not push, create or update pull requests, or bypass hooks or signing unless explicitly
  requested.
- Name branches you create as `feature/<short logical name for branch>`.
- Merge or otherwise complete a pull request only when explicitly asked in the current conversation.
  Permission to implement, review, fix CI, push, or manage the pull request does not include
  merging.

# Coding

- Handle obvious, expected errors such as null values or missing files, but do not add defensive
  code for every hypothetical failure.
  Let unexpected failures surface.
- Keep docstrings terse; do not restate what the function or class name and type signature already
  convey.
- Prefer standard-library functions, methods, and data structures when they simplify the code and
  remain well suited to the task.
- Do not introduce abstractions for hypothetical reuse or extensibility; add one only when it makes
  the current code simpler.

# Responses

- Lead with the answer; skip preambles, restatement, and unnecessary narration.
- Explain one concept at a time instead of dumping everything relevant.
- Keep paragraphs focused and easy to scan.
  Use headings and bullets only when they clarify the structure.
- Prefer a small example, code excerpt, or diagram when it explains the idea better than more prose.
