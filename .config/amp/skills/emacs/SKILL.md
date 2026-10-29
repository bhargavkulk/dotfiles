---
name: emacs
description: "Queries the currently open Emacs editor through the bundled emacs_cli script. Use only when asked to inspect the live editor state: current region, cursor, active buffer, Flymake diagnostics, or symbol at point. Do not use for Emacs configuration, packages, Elisp, or general Emacs research."
---

# Emacs

Run the bundled script as `~/.config/amp/skills/emacs/emacs_cli`. Every command prints JSON and sends only fixed read-only Elisp through `emacsclient`.

Use the narrowest command that answers the request. Do not automatically gather `context` or `read_context` alongside a region request. When the user asks to read the current region, call only `read_region`. If the selected text is insufficient to proceed, ask the user for the specific additional context needed instead of querying more automatically.

Retrieve selected text:

```sh
~/.config/amp/skills/emacs/emacs_cli read_region
```

This returns the GUI `PRIMARY` selection, falling back to `CLIPBOARD`, or `null` when neither is available.

Retrieve editor context only when the user asks for it:

```sh
~/.config/amp/skills/emacs/emacs_cli context
~/.config/amp/skills/emacs/emacs_cli read_context --before 10 --after 10
```

`context` returns the visible buffer's file, name, mode, modified state, cursor line and zero-based column, and Emacs-region offsets. `read_context` includes complete lines around the cursor plus its line and zero-based column. If the buffer is a transient UI buffer such as ` *corfu*`, wait for it to close and query again. Use the regular file-reading tool for arbitrary file ranges.

Retrieve specific metadata:

```sh
~/.config/amp/skills/emacs/emacs_cli current_file
~/.config/amp/skills/emacs/emacs_cli diagnostics
~/.config/amp/skills/emacs/emacs_cli symbol_at_point
```

`current_file` returns the file path or `null` for a non-file buffer. `diagnostics` returns Flymake diagnostics as severity, line, zero-based column, and message; it returns `[]` when Flymake is inactive or has none. `symbol_at_point` returns the symbol string or `null`.

Do not use `emacsclient --eval` directly for editor interaction. The command evaluates in Emacs's ` *server*` buffer, so bare buffer-local queries do not necessarily describe the visible editor window. `emacs_cli` targets the selected GUI frame and window first.
