rex.bind("ctrl+alt+2", "pane.split.down")
rex.bind("ctrl+alt+3", "pane.split.right")
rex.bind("ctrl+alt+0", "pane.close")
rex.bind("ctrl+alt+1", "pane.zoom")
rex.bind("ctrl+alt+o", "pane.focus_next")

rex.action{
  name = "review_in_magit",
  title = "Review in Magit",
  run = function(ctx)
    if not ctx.block_id then error("Focus a terminal in a Git repository first", 0) end

    local block, block_err = rex.session.describe_block{ block_id = ctx.block_id }
    if not block then error(block_err, 0) end

    local terminal = "com.superlogical.terminal"
    local process, process_err = rex.block.call(terminal, "process", { block_id = ctx.block_id })
    if not process then error(process_err, 0) end
    local dir = process.foreground and process.foreground.cwd
    if not dir then
      local pwd, pwd_err = rex.block.call(terminal, "pwd", { block_id = ctx.block_id })
      if not pwd then error(pwd_err, 0) end
      dir = pwd.pwd
      if dir and dir:match("^file://") then
        dir = dir:match("^file://[^/]+(/.*)$")
        if dir then dir = dir:gsub("%%(%x%x)", function(hex) return string.char(tonumber(hex, 16)) end) end
      end
    end
    if not dir then error("Cannot determine this terminal's working directory", 0) end

    local git, git_err = rex.exec({ "git", "rev-parse", "--show-toplevel" }, { cwd = dir, timeout = 5 })
    if not git then error(git_err, 0) end
    if not git.ok then error("This terminal is not inside a Git working tree", 0) end
    local root = git.stdout:gsub("%s+$", "")
    local label = "Magit: " .. root

    local view, view_err = rex.session.view{}
    if not view then error(view_err, 0) end
    for _, window in ipairs(view.windows) do
      if window.window_id == block.block.window_id then
        for _, layer in ipairs(window.layers) do
          for _, pane in ipairs(layer.blocks) do
            if pane.label == label then
              local focused, focus_err = rex.session.focus_block{ block_id = pane.block_id }
              if not focused then error(focus_err, 0) end
              return { block_id = pane.block_id, root = root }
            end
          end
        end
      end
    end

    local magit = "(progn " ..
      "(require 'magit) " ..
      "(defun rex-magit-review--quit (original &rest args) " ..
        "(if (and (frame-parameter nil 'rex-magit-review) " ..
                 "(derived-mode-p 'magit-mode)) " ..
            "(save-buffers-kill-terminal) " ..
          "(apply original args))) " ..
      "(advice-add 'magit-mode-bury-buffer :around " ..
                  "#'rex-magit-review--quit) " ..
      "(when (fboundp 'meow-quit-dwim) " ..
        "(advice-add 'meow-quit-dwim :around " ..
                    "#'rex-magit-review--quit)) " ..
      "(magit-status " .. string.format("%q", root) .. ") " ..
      "(delete-other-windows) " ..
      "(set-frame-parameter nil 'rex-magit-review t))"

    local split, split_err = rex.session.new_split{
      anchor_id = ctx.block_id,
      direction = "horizontal",
      side = "after",
      ratio = 0.5,
      focus = true,
      layout = rex.layout.block{
        flavor = "com.superlogical.terminal.shell",
        label = label,
        options = {
          cwd = root,
          command = {
            "/bin/sh", "-c",
            "if command -v emacsclient >/dev/null 2>&1 && " ..
              "emacsclient -a false -w 2 -e t >/dev/null 2>&1; then " ..
              "exec emacsclient -nw -a false -e \"$1\"; " ..
              "else exec emacs -nw --eval \"$1\"; fi",
            "sh", magit,
          },
        },
      },
    }
    if not split then error(split_err, 0) end
    return { block_id = split.block_ids[1], root = root }
  end,
}

rex.bind("cmd+shift+g", "review_in_magit")
