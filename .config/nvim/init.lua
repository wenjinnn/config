-- my nvim config write in lua
vim.g.mapleader = ' '

local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)
require('lazy').setup('plugin', {
  dev = {
    path = '~/project/my'
  }
})

vim.api.nvim_create_user_command('BufferDelete', function()
  ---@diagnostic disable-next-line: missing-parameter
  local file_exists = vim.fn.filereadable(vim.fn.expand('%p'))
  local modified = vim.api.nvim_buf_get_option(0, 'modified')
  if file_exists == 0 and modified then
    local user_choice = vim.fn.input('The file is not saved, whether to force delete? Press enter or input [y/n]:')
    if user_choice == 'y' or string.len(user_choice) == 0 then
      vim.cmd('bd!')
    end
    return
  end
  -- local force = not vim.bo.buflisted or vim.bo.buftype == "nofile"
  -- vim.cmd(force and "bd!" or string.format("bp | bd! %s", vim.api.nvim_get_current_buf()))
  vim.cmd(string.format('bp | bd! %s', vim.api.nvim_get_current_buf()))
end, { desc = 'Delete the current Buffer while maintaining the window layout' })

-- sync wsl clipboard
if vim.fn.has('wsl') then
  vim.cmd [[
  augroup Yank
  autocmd!
  autocmd TextYankPost * :call system('/mnt/c/windows/system32/clip.exe ',@")
  augroup END
  ]]
end

-- fcitx5 rime
-- Disable the input method when exiting insert mode and save the state
-- 2 means that the input method was opened in the previous state, and the input method is started when entering the insert mode
vim.cmd [[
  autocmd InsertLeave * :silent call system("busctl call --user org.fcitx.Fcitx5 /rime org.fcitx.Fcitx.Rime1 SetAsciiMode b 1")
]]
