local not_vscode = require("util").not_vscode
return {
  {
    "stevearc/conform.nvim",
    cond = not_vscode,
    event = "CmdLineEnter",
    cmd = { "DiffFormat", "Format" },
    keys = {
      {
        mode = { "n", "v" },
        "<leader>mm",
        '<cmd>lua require"conform".format({async = true, lsp_fallback = true})<cr>',
        desc = "Format",
      },
      {
        "<leader>md",
        "<cmd>DiffFormat<cr>",
        desc = "Diff format",
      },
      {
        "<leader>mM",
        function()
          vim.g.conform_autoformat = not vim.g.conform_autoformat
          vim.notify("Autoformat: " .. (vim.g.conform_autoformat and "on" or "off"))
        end,
        desc = "Auto format toggle",
      },
    },
    init = function()
      vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
      vim.g.conform_autoformat = true
    end,
    opts = {
      formatters_by_ft = {
        nix = { "alejandra" },
      },
    },
    config = function(_, opts)
      require("conform").setup(opts)
      local diff_format = function()
        local data = MiniDiff.get_buf_data()
        if not data or not data.hunks or not vim.g.conform_autoformat then
          vim.notify("No hunks in this buffer or auto format is currently disabled")
          return
        end
        local ranges = {}
        for _, hunk in pairs(data.hunks) do
          if hunk.type ~= "delete" then
            -- always insert to index 1 so format below could start from last hunk, which this sort didn't mess up range
            table.insert(ranges, 1, {
              start = { hunk.buf_start, 0 },
              ["end"] = { hunk.buf_start + hunk.buf_count, 0 },
            })
          end
        end
        for _, range in pairs(ranges) do
          require("conform").format({ lsp_fallback = true, timeout_ms = 500, range = range })
        end
      end
      vim.api.nvim_create_user_command("DiffFormat", diff_format, { desc = "Format changed lines" })

      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        callback = diff_format,
        desc = "Auto format changed lines",
      })
    end,
  },
  {
    "mfussenegger/nvim-lint",
    cond = not_vscode,
    event = "BufRead",
    config = function()
      local lint = require("lint")
      -- just use the default lint
      -- TODO maybe add more linter in future
      lint.linters_by_ft = {}
      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "InsertLeave" }, {
        callback = function()
          lint.try_lint()
          lint.try_lint("compiler")
        end,
      })
    end,
  },
  {
    "echasnovski/mini.pairs",
    event = "InsertEnter",
    opts = {},
  },
  {
    "echasnovski/mini.surround",
    event = "BufRead",
    opts = {},
    config = function(_, opts)
      require("mini.surround").setup(opts)
      vim.keymap.set({ "n", "x" }, "s", "<Nop>")
    end,
  },
  {
    "echasnovski/mini.splitjoin",
    event = "BufRead",
    opts = function()
      local gen_hook = require("mini.splitjoin").gen_hook
      local curly = { brackets = { "%b{}" } }
      -- Add trailing comma when splitting inside curly brackets
      local add_comma_curly = gen_hook.add_trailing_separator(curly)

      -- Delete trailing comma when joining inside curly brackets
      local del_comma_curly = gen_hook.del_trailing_separator(curly)

      -- Pad curly brackets with single space after join
      local pad_curly = gen_hook.pad_brackets(curly)
      return {
        split = { hooks_post = { add_comma_curly } },
        join = { hooks_post = { del_comma_curly, pad_curly } },
      }
    end,
  },
  {
    "echasnovski/mini.ai",
    event = "BufRead",
    opts = function()
      local gen_ai_spec = require("mini.extra").gen_ai_spec
      local gen_spec = require("mini.ai").gen_spec
      return {
        custom_textobjects = {
          B = gen_ai_spec.buffer(),
          D = gen_ai_spec.diagnostic(),
          I = gen_ai_spec.indent(),
          L = gen_ai_spec.line(),
          N = gen_ai_spec.number(),
          -- Tweak argument to be recognized only inside `()` between `;`
          a = gen_spec.argument({ brackets = { "%b()" }, separator = ";" }),
          -- Tweak function call to not detect dot in function name
          f = gen_spec.function_call({ name_pattern = "[%w_]" }),
          -- Function definition (needs treesitter queries with these captures)
          -- This need nvim-treesitter-textobjects, see https://github.com/echasnovski/mini.nvim/issues/947#issuecomment-2154242659
          F = gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }),
          -- Make `|` select both edges in non-balanced way
          o = gen_spec.treesitter({
            a = { "@conditional.outer", "@loop.outer" },
            i = { "@conditional.inner", "@loop.inner" },
          }),
          c = gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }),
          ["|"] = gen_spec.pair("|", "|", { type = "non-balanced" }),
        },
        n_lines = 500,
      }
    end,
  },
  {
    "echasnovski/mini.align",
    event = "BufRead",
    opts = {},
  },
  {
    "echasnovski/mini.bracketed",
    event = "BufRead",
    opts = {},
  },
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPre", "SessionLoadPost" },
    cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
    init = function(plugin)
      -- PERF: add nvim-treesitter queries to the rtp and it's custom query predicates early
      -- This is needed because a bunch of plugins no longer `require("nvim-treesitter")`, which
      -- no longer trigger the **nvim-treeitter** module to be loaded in time.
      -- Luckily, the only thins that those plugins need are the custom queries, which we make available
      -- during startup.
      require("lazy.core.loader").add_to_rtp(plugin)
      require("nvim-treesitter.query_predicates")
      vim.g.skip_ts_context_commentstring_module = true
      local get_option = vim.filetype.get_option
      -- FIX native comment not work for jsx or vue template, relate issue: https://github.com/neovim/neovim/issues/28830
      ---@diagnostic disable-next-line: duplicate-set-field
      vim.filetype.get_option = function(filetype, option)
        return option == "commentstring"
            and require("ts_context_commentstring.internal").calculate_commentstring()
            or get_option(filetype, option)
      end
    end,
    dependencies = {
      { "nvim-treesitter/nvim-treesitter-textobjects" },
      { "nvim-treesitter/nvim-treesitter-context" },
      { "windwp/nvim-ts-autotag", opts = {} },
      { "JoosepAlviste/nvim-ts-context-commentstring", opts = { enable_autocmd = false } },
      { "hiphish/rainbow-delimiters.nvim" },
    },
    opts = {
      ensure_installed = {
        -- basic
        "vim",
        "vimdoc",
        "regex",
        "markdown",
        "lua",
        "luadoc",
        "luap",
        "query",
        "bash",
        "hurl",
        "diff",
        "markdown_inline",
        -- autotag dependencies
        "astro",
        "glimmer",
        "html",
        "javascript",
        "markdown",
        "php",
        "svelte",
        "tsx",
        "typescript",
        "vue",
        "xml",
        -- personal frequently used
        "nix",
        "java",
        "rust",
        "sql",
        "css",
        "scss",
      }, -- one of "all", "maintained" (parsers with maintainers), or a list of languages
      ignore_install = { "org" }, -- List of parsers to ignore installing
      auto_install = true,
      highlight = {
        enable = not_vscode, -- false will disable the whole extension
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
      incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<C-space>",
          node_incremental = "<C-space>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    },
    main = "nvim-treesitter.configs",
  },
  {
    "echasnovski/mini.bufremove",
    keys = {
      { "<leader>x", "<cmd>lua MiniBufremove.delete()<CR>", desc = "Buf delete" },
    },
    cond = not_vscode,
    config = true,
  },
  {
    "echasnovski/mini.sessions",
    cond = not_vscode,
    lazy = true,
    event = "VimEnter",
    keys = function()
      local session_name = function()
        local cwd = vim.fn.getcwd()
        local parent_path = vim.fn.fnamemodify(cwd, ":h")
        local current_tail_path = vim.fn.fnamemodify(cwd, ":t")
        return string.format("%s@%s", current_tail_path, parent_path:gsub("/", "-"))
      end
      return {
        {
          "<leader>sw",
          function()
            require("mini.sessions").write(session_name())
          end,
          desc = "Session write",
        },
        {
          "<leader>sW",
          function()
            MiniSessions.write(vim.fn.input("Session name: "))
          end,
          desc = "Session write custom",
        },
        {
          "<leader>sd",
          function()
            require("mini.sessions").delete(session_name())
          end,
          desc = "Session delete",
        },
        {
          "<leader>sD",
          function()
            MiniSessions.delete(vim.fn.input("Session name: "))
          end,
          desc = "Session delete custom",
        },
      }
    end,
    opts = function()
      return {
        -- Whether to force possibly harmful actions (meaning depends on function)
        force = { read = false, write = true, delete = true },
        hooks = {
          -- Before successful action
          pre = { read = nil, write = nil, delete = nil },
          -- After successful action
          post = { read = require("util").delete_dap_terminals, write = nil, delete = nil },
        },
      }
    end,
  },
}
