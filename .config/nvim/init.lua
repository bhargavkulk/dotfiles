local config_home = vim.env.XDG_CONFIG_HOME
if not config_home or config_home == "" then
    config_home = vim.fn.expand("~/.config")
end

local vimrc = config_home .. "/vim/vimrc"
if vim.fn.filereadable(vimrc) == 1 then
    vim.cmd("source " .. vim.fn.fnameescape(vimrc))
end

vim.pack.add({
    'https://github.com/folke/which-key.nvim',
})
