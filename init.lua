-- `lazy.nvim` の初期化
vim.opt.rtp:prepend("~/.local/share/nvim/lazy/lazy.nvim")
require("lazy").setup({
  -- UI
  {"nvim-tree/nvim-tree.lua"},
  {"nvim-lualine/lualine.nvim"},
  {"catppuccin/nvim"},
  {"akinsho/toggleterm.nvim"},

  -- LSP・補完
  {"neovim/nvim-lspconfig"},
  {"hrsh7th/nvim-cmp"},
  {"hrsh7th/cmp-nvim-lsp"},
  {"L3MON4D3/LuaSnip"},

  -- Git
  {"lewis6991/gitsigns.nvim"},
  {"tpope/vim-fugitive"},

  -- 検索・ナビゲーション
  {"nvim-telescope/telescope.nvim"},
  {"nvim-treesitter/nvim-treesitter", build = ":TSUpdate"},
  {"nvim-treesitter/playground"},
  -- フォーマット・補助機能
  {"lukas-reineke/indent-blankline.nvim"},
  {"windwp/nvim-autopairs"},
  {"numToStr/Comment.nvim"},

  -- Mason（LSP管理）
  {"williamboman/mason.nvim"},
  {"williamboman/mason-lspconfig.nvim"},

  --Markdown Preview
  {
      "iamcco/markdown-preview.nvim",
      build = "cd app && npm install",
      ft = { "markdown" },
      config = function()
          vim.g.mkdp_auto_start = 1  -- 自動プレビュー開始
      end,
  }
})

-- `mason.nvim` のセットアップ
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "clangd", "lua_ls" },
  automatic_installation = true,
})

-- LSP 設定
local lspconfig = require("lspconfig")
lspconfig.lua_ls.setup({})
lspconfig.clangd.setup({
  cmd = { "/opt/microchip/xc8/v3.00/bin/xc8-clangd" },  -- xc8-clangd のパス
  filetypes = { "c" },  -- C言語のみ適用
  root_dir = lspconfig.util.root_pattern("Makefile", ".git"), -- プロジェクトのルートを決定
  settings = {
    clangd = {
      fallbackFlags = { "--target=pic32mx", "-I/opt/microchip/xc8/v3.00/include" }, -- 必要に応じて変更
    },
  },
})


-- Treesitter 設定
require("nvim-treesitter.configs").setup({
  ensure_installed = "all",
  highlight = { enable = true },
})

-- nvim-cmp 設定
local cmp = require("cmp")
cmp.setup({
  mapping = {
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
  },
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
  },
})

-- nvim-tree 設定
require("nvim-tree").setup({})
vim.api.nvim_set_keymap("n", "<leader>e", ":NvimTreeToggle<CR>", { noremap = true, silent = true })

-- Telescope 設定
vim.api.nvim_set_keymap("n", "<leader>ff", ":Telescope find_files<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>fg", ":Telescope live_grep<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>fr", ":Telescope oldfiles<CR>", { noremap = true, silent = true })

-- GitSigns 設定
require("gitsigns").setup({})

-- Lualine 設定
require("lualine").setup({ options = { theme = "catppuccin" } })

-- autopairs 設定
require("nvim-autopairs").setup({
    check_ts = true,  -- Treesitterとの連携
    disable_filetype = { "TelescopePrompt", "vim" },  -- 除外するファイルタイプ
})

-- toggleterm (ターミナル) 設定
require("toggleterm").setup({
    size = 20,
    open_mapping = [[<leader>t]],
    direction = "horizontal",
    shade_terminals = true,
})
vim.api.nvim_set_keymap("n", "<leader>t", ":ToggleTerm<CR>", { noremap = true, silent = true })
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]], { noremap = true, silent = true })

-- ウィンドウ間の移動 (コーディング画面 ⇄ ツリー ⇄ ターミナル)
vim.api.nvim_set_keymap("n", "<C-h>", "<C-w>h", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-j>", "<C-w>j", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-k>", "<C-w>k", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<C-l>", "<C-w>l", { noremap = true, silent = true })


-- C 言語のスニペットを追加
require("luasnip.loaders.from_vscode").lazy_load()
local ls = require("luasnip")
ls.add_snippets("c", {
    ls.parser.parse_snippet("main", "int main() {\n    return 0;\n}"),
    ls.parser.parse_snippet("for", "for(int i = 0; i < N; i++) {\n    \n}"),
    ls.parser.parse_snippet("while", "while(condition) {\n    \n}")
})


-- MarkdownPreview 設定
vim.api.nvim_set_keymap("n", "<leader>mp", ":MarkdownPreview<CR>", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<leader>ms", ":MarkdownPreviewStop<CR>", { noremap = true, silent = true })


-- その他の基本設定
vim.opt.number = true  -- 行番号表示
vim.opt.shiftwidth = 4
vim.opt.clipboard = "unnamedplus"
vim.opt.expandtab = true  -- タブをスペースに変換
vim.opt.tabstop = 4  -- タブの幅を4スペースに設定
vim.opt.smartindent = true  -- スマートインデントを有効にする

-- 行を移動 (Alt + j / Alt + k)
vim.api.nvim_set_keymap("n", "<M-j>", ":m .+1<CR>==", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<M-k>", ":m .-2<CR>==", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<M-j>", ":m '>+1<CR>gv=gv", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<M-k>", ":m '<-2<CR>gv=gv", { noremap = true, silent = true })

-- 行をコピーして上下に貼り付け (Alt + Shift + j / Alt + Shift + k)
vim.api.nvim_set_keymap("n", "<M-J>", "yyp", { noremap = true, silent = true })
vim.api.nvim_set_keymap("n", "<M-K>", "yyP", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<M-J>", "ygvP", { noremap = true, silent = true })
vim.api.nvim_set_keymap("v", "<M-K>", "yPgvgv", { noremap = true, silent = true })

-- 挿入モードで Alt + ↑ / ↓ で行を移動
vim.api.nvim_set_keymap("i", "<M-Up>", "<Esc>:m .-2<CR>==gi", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<M-Down>", "<Esc>:m .+1<CR>==gi", { noremap = true, silent = true })

-- 挿入モードで Alt + Shift + ↑ / ↓ で行をコピー
vim.api.nvim_set_keymap("i", "<M-S-Up>", "<Esc>yyPgi", { noremap = true, silent = true })
vim.api.nvim_set_keymap("i", "<M-S-Down>", "<Esc>yypgi", { noremap = true, silent = true })

