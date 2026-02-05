local plugin_dir = vim.fn.stdpath('config') .. "/pack/plugins/start/"

vim.opt.runtimepath:append(plugin_dir .. "nvim-treesitter")
vim.opt.runtimepath:append(plugin_dir .. "nvim-dap")
vim.opt.runtimepath:append(plugin_dir .. "nvim-dap-ui")
vim.opt.runtimepath:append(plugin_dir .. "nvim-dap-virtual-text")

vim.opt.number = true
require("treesitter_setup")
require("dap")
require("dapui")
require("nvim-dap-virtual-text").setup()

require('keymaps')
require("appearance")
require("lsp_setup")
require("dap_setup")

