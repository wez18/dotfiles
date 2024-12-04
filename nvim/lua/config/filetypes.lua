local filetypes = vim.filetype

filetypes.add({
  extension = {
    gotmpl = "gotmpl",
  },
  pattern = {
    [".*templates/.*%.tpl"] = "helm",
    [".*templates/.*%.ya?ml"] = "helm",
    ["helmfile.*%.ya?ml"] = "helm",
  },
})

filetypes.add({
  extension = {
    tofu = "hcl",
  },
})
