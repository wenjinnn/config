local not_vscode = require("util").not_vscode

return {
  "hrsh7th/nvim-cmp",
  cond = not_vscode,
  event = { "InsertEnter", "CmdLineEnter" },
  dependencies = {
    { "rafamadriz/friendly-snippets" },
    { "hrsh7th/vim-vsnip" },
    { "hrsh7th/cmp-vsnip" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "hrsh7th/cmp-nvim-lsp-signature-help" },
    { "octaltree/cmp-look" },
    { "petertriho/cmp-git" },
    { "rcarriga/cmp-dap" },
    { "kristijanhusak/vim-dadbod-completion" },
  },
  config = function()
    local cmp = require("cmp")
    local lspkind = require("lspkind")
    local feedkey = function(key, mode)
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes(key, true, true, true), mode, true)
    end
    local has_words_before = function()
      local line, col = unpack(vim.api.nvim_win_get_cursor(0))
      return col ~= 0
        and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s")
          == nil
    end

    local cmp_vsnip_source_config = {
      name = "vsnip",
      max_item_count = 10,
    }

    local cmp_buffer_source_config = {
      name = "buffer",
      max_item_count = 10,
      option = {
        get_bufnrs = function()
          return vim.api.nvim_list_bufs()
        end,
      },
    }
    local cmp_look_source_config = {
      name = "look",
      max_item_count = 5,
      keyword_length = 2,
      option = {
        convert_case = true,
        loud = true,
      },
    }
    local vim_dadbod_completion_config = { name = "vim-dadbod-completion" }

    cmp.setup({
      window = {
        documentation = {
          max_width = 70,
        },
      },
      experimental = {
        ghost_text = true,
      },
      snippet = {
        expand = function(args)
          vim.fn["vsnip#anonymous"](args.body)
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ["<C-b>"] = cmp.mapping.scroll_docs(-4),
        ["<C-f>"] = cmp.mapping.scroll_docs(4),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif vim.fn["vsnip#available"](1) == 1 then
            feedkey("<Plug>(vsnip-expand-or-jump)", "")
          elseif has_words_before() then
            cmp.complete()
          else
            fallback() -- The fallback function sends a already mapped key. In this case, it's probably `<Tab>`.
          end
        end, { "i", "s" }),
        ["<S-Tab>"] = cmp.mapping(function()
          if cmp.visible() then
            cmp.select_prev_item()
          elseif vim.fn["vsnip#jumpable"](-1) == 1 then
            feedkey("<Plug>(vsnip-jump-prev)", "")
          end
        end, { "i", "s" }),
      }),
      sources = {
        cmp_vsnip_source_config,
        { name = "nvim_lsp" },
        { name = "nvim_lsp_signature_help" },
        { name = "git" },
        { name = "orgmode" },
        cmp_buffer_source_config,
        { name = "path" },
        cmp_look_source_config,
      },
      formatting = {
        expandable_indicator = false,
        deprecated = true,
        fields = { "abbr", "menu", "kind" },
        format = function(entry, vim_item)
          local item_source = {
            buffer = "buf",
            nvim_lsp = "lsp",
            vsnip = "snip",
            nvim_lsp_signature_help = "sign",
            path = "path",
            cmp_tabnine = "tabnine",
            look = "look",
            cmdline = "cmd",
            treesitter = "treesitter",
            nvim_lua = "lua",
            latex_symbols = "latex",
            dap = "dap",
            git = "git",
            orgmode = "org",
            ["cmp-dbee"] = "dbee",
            ["vim-dadbod-completion"] = "dadbod",
          }
          local item_maxwidth = 30
          local ellipsis_char = "…"
          local lspkind_format = lspkind.cmp_format({
            mode = "symbol", -- show only symbol annotations
            maxwidth = item_maxwidth, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
            ellipsis_char = ellipsis_char, -- when popup menu exceed maxwidth, the truncated part would show ellipsis_char instead (must define maxwidth first)

            -- The function below will be called before any actual modifications from lspkind
            -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
            before = function(entry, inner_item)
              local menu = inner_item.menu
              if menu ~= nil and menu:len() > item_maxwidth then
                menu = menu:sub(0, item_maxwidth) .. ellipsis_char
                inner_item.menu = menu
              end
              return inner_item
            end,
          })
          local final_item = lspkind_format(entry, vim_item)
          local source = (item_source)[entry.source.name]
          if source ~= nil then
            final_item.kind = final_item.kind .. " " .. source .. " "
          end
          return final_item
        end,
      },
    })
    -- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      }),
    })
    cmp.setup.cmdline({ "/", "?" }, {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "buffer" },
      }),
    })
    cmp.setup.filetype({ "dap-repl" }, {
      enabled = function()
        return vim.api.nvim_buf_get_option(0, "buftype") ~= "prompt"
          or require("cmp_dap").is_dap_buffer()
      end,
      sources = {
        { name = "dap", keyword_length = 1 },
        cmp_buffer_source_config,
      },
    })
    cmp.setup.filetype({ "sql", "mysql", "plsql" }, {
      sources = {
        cmp_vsnip_source_config,
        vim_dadbod_completion_config,
        cmp_buffer_source_config,
        cmp_look_source_config,
      },
    })
    require("cmp_git").setup()
  end,
}
