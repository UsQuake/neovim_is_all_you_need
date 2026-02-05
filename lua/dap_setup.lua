local dap = require("dap")
local dapui = require("dapui")


--------------------------------------------------------------------------------
-- 1. Adapter setup (using CodeLLDB)
--------------------------------------------------------------------------------
local codelldb_path = vim.fn.stdpath("config") .. "/codelldb/adapter/codelldb"

dap.adapters.codelldb = {
    type = "server",
    port = "${port}",
    executable = {
        command = codelldb_path,
        args = { "--port", "${port}" },
    }
}

--------------------------------------------------------------------------------
-- 2. Configuration
--------------------------------------------------------------------------------
local function find_root()
    local paths = vim.fs.find(
        { "compile_commands.json", ".git", "CMakeLists.txt" },
        { upward = true, path = vim.fn.getcwd() }
    )
    if #paths > 0 then
        return vim.fs.dirname(paths[1])
    end
    return vim.fn.getcwd()
end

local root = find_root()

dap.configurations.cpp = {
    {
        name = "Launch Llama Bench (Manual)",
        type = "codelldb", 
        request = "launch",
        program = function()
            local default_path = root .. "/build/bin/llama-bench"
            return vim.fn.input("Path to executable: ", default_path, "file")
        end,
        cwd = root,
        stopOnEntry = false,
        
        args = function()
            local default_args = "-m " .. root .. "/models/gemma3-270m/gemma-3-270m-f16.gguf"
            local input = vim.fn.input("Args: ", default_args)
            return vim.split(input, " ")
        end,
        
        console = "integratedTerminal",
    },
}

dap.configurations.c = dap.configurations.cpp
dap.configurations.rust = dap.configurations.cpp

--------------------------------------------------------------------------------
-- 3. UI setup (DAP even listener setup)
--------------------------------------------------------------------------------
dapui.setup()

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

--------------------------------------------------------------------------------
-- 4. Keymaps
--------------------------------------------------------------------------------
vim.keymap.set("n", "<leader>co", dap.continue, { desc = "DAP Continue" })
vim.keymap.set("n", "<leader>br", dap.toggle_breakpoint, { desc = "DAP Toggle Breakpoint" })
vim.keymap.set("n", "<leader>st", dap.step_over, { desc = "DAP Step Over" })
vim.keymap.set("n", "<leader>sti", dap.step_into, { desc = "DAP Step Into" })
vim.keymap.set("n", "<leader>sto", dap.step_out, { desc = "DAP Step Out" })
vim.keymap.set("n", "<leader>du", dapui.toggle, { desc = "DAP UI Toggle" })
