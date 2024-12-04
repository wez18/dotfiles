return {
  "folke/edgy.nvim",
  event = "VeryLazy",
  opts = {
    keys = {
      -- increase width
      ["<S-Right>"] = function(win)
        win:resize("width", 2)
      end,
      -- decrease width
      ["<S-Left>"] = function(win)
        win:resize("width", -2)
      end,
      -- increase height
      ["<S-Up>"] = function(win)
        win:resize("height", 2)
      end,
      -- decrease height
      ["<S-Down>"] = function(win)
        win:resize("height", -2)
      end,
    },
  },
}
