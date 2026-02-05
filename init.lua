vim.opt.runtimepath:append("/home/songjuhyeon/.config/nvim/pack/plugins/start/nvim-treesitter")
vim.opt.runtimepath:append("/home/songjuhyeon/.config/nvim/pack/plugins/start/nvim-dap")
vim.opt.runtimepath:append("/home/songjuhyeon/.config/nvim/pack/plugins/start/nvim-dap-ui")
vim.opt.runtimepath:append("/home/songjuhyeon/.config/nvim/pack/plugins/start/nvim-dap-virtual-text")



vim.opt.number = true
require("treesitter_setup")
require("dap")
require("dapui")
require("nvim-dap-virtual-text").setup()

require('keymaps')
require("appearance")
require("lsp_setup")
require("dap_setup")

