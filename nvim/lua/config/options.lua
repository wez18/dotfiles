-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

vim.g.have_nerd_font = true

local opt = vim.opt

-- Nvim clipboard separate from system clipboard
opt.clipboard = "unnamed"
-- opt.clipboard = "unnamedplus"

opt.title = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }
opt.inccommand = "split"
opt.titlestring = ""
opt.shell = "/opt/homebrew/bin/zsh"

-- Edgy recomended options
opt.laststatus = 3
opt.splitkeep = "screen"
