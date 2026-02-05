local colors = {
	error = "#db4b4b",
	warn = "#e0af68",
	info = "#0db9d7",
	hint = "#10b981"
}

vim.api.nvim_set_hl(0, "DiagnosticUnderlineError", { undercurl = true, sp = colors.error})
vim.api.nvim_set_hl(0, "DiagnosticUnderlineWarn", { undercurl = true, sp = colors.warn})
vim.api.nvim_set_hl(0, "DiagnosticUnderlineInfo", { undercurl = true, sp = colors.info})
vim.api.nvim_set_hl(0, "DiagnosticUnderlineHint", { undercurl = true, sp = colors.hint})
