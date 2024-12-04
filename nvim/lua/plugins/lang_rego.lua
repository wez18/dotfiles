return {
  {
    "nvim-treesitter/nvim-treesitter",
    opts = {
      ensure_installed = { "rego" },
    },
  },
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        regols = {},
        regal = {},
      },
    },
  },
}
