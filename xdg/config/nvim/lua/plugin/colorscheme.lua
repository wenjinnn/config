local not_vscode = require("util").not_vscode
return {
  {
    "folke/tokyonight.nvim",
    cond = not_vscode,
    lazy = false,
    priority = 1000,
    opts = {
      transparent = true,
    },
    config = function(_, opts)
      require("tokyonight").setup(opts)
      vim.cmd.colorscheme("tokyonight-night")
    end,
  },
}
