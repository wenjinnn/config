local in_vscode = require("util").in_vscode
if in_vscode() then
  return
end
local add, later = MiniDeps.add, MiniDeps.later
later(function()
  add({ source = "rafamadriz/friendly-snippets" })
  add({ source = "garymjr/nvim-snippets" })
  add({ source = "kristijanhusak/vim-dadbod-completion" })
end)
