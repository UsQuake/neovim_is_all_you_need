local dap = require("dap")

local dapui = require("dapui")

dap.adapters.cpp= {

	type = "executable",

	command = "/usr/bin/lldb",

	-- args = {""}

}

dapui.setup()

local function find_root()

	return vim.fs.dirname(vim.fs.find({

		"compile_commands.json",

		".git",

		"CMakeLists.txt",

	}, {upward = true})[1])

end



local root = find_root() or vim.fn.getcwd()

dap.configurations.cpp = {

	{

	name = "Launch file",

	type = "cpp",

	request = "launch",

	program = function()

		return vim.fn.input("Path to executable: ", root .. "/build/bin/llama-bench", "file")

	end,

	cwd = root,

	stopOnEntry = false,

	args = {"-m", root .. "/models/gemma3-270m/gemma-3-270m-f16.gguf"},

	},

}

dap.configurations.c = dap.configurations.cpp



dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end

dap.listeners.after.event_terminated["dapui_config"] = function() dapui.close() end

dap.listeners.after.event_exited["dapui_config"] = function() dapui.close() end



vim.keymap.set("n", "<leader>co", function() dap.continue() end)

vim.keymap.set("n", "<leader>br", function() dap.toggle_breakpoint() end)

vim.keymap.set("n", "<leader>st", function() dap.step_over() end)

vim.keymap.set("n", "<leader>sti", function() dap.step_into() end)

vim.keymap.set("n", "<leader>sto", function() dap.step_out() end)

vim.keymap.set("n", "<leader>du", dapui.toggle)
