vim.api.nvim_create_autocmd( 'LspAttach',{
	callback = function(args)
		local opts = { buffer = args.buf }
		vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
		vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
		vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
	end,

})
vim.keymap.set("n", "<leader>i", function()
	print("Indexing Status: "..
		vim.inspect(vim.lsp.get_active_clients()[1].server_capabilities.semanticTokensProvider ~= nil))
	end)
