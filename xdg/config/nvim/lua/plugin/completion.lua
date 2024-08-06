local not_vscode = require("util").not_vscode

return {
  { "kristijanhusak/vim-dadbod-completion", cond = not_vscode },
  { "rafamadriz/friendly-snippets", cond = not_vscode },
  { "garymjr/nvim-snippets", cond = not_vscode, opts = { friendly_snippets = true } },
}
