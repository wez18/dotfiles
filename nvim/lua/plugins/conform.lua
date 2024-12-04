return {
  {
    "stevearc/conform.nvim",
    opts = {
      formatters_by_ft = {
        lua = { "stylua" },
        ["*"] = { "trim_whitespace", "squeeze_blanks" },
      },
    },
  },
}
