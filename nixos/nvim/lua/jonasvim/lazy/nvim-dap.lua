return {
  {
    "rcarriga/nvim-dap-ui",
    dependencies = {
      "mfussenegger/nvim-dap",
      "nvim-neotest/nvim-nio",
      "theHamsta/nvim-dap-virtual-text"
    },
    config = function()
      local dap = require "dap"
      local _ = require "dapui"

      require("dapui").setup()
      -- require("dap-go").setup()
      require("nvim-dap-virtual-text").setup()

      local elixir_ls_debugger = vim.fn.exepath "elixir-debug-adapter"
      dap.adapters.mix_task = {
        type = "executable",
        command = elixir_ls_debugger,
      }
      dap.configurations.elixir = {
        {
          type = "mix_task",
          name = "mix test (current file)",
          task = "test",
          taskArgs = function()
            return { "--trace", vim.fn.expand("%:p") }
          end,
          request = "launch",
          startApps = true,
          projectDir = "${workspaceFolder}",
          requireFiles = {
            "test/**/test_helper.exs",
            "test/**/*_test.exs"
          },
        },
        {
          type = "mix_task",
          name = "mix test (current line)",
          task = "test",
          taskArgs = function()
            return { "--trace", vim.fn.expand("%:p") .. ":" .. vim.fn.line(".") }
          end,
          request = "launch",
          startApps = true,
          projectDir = "${workspaceFolder}",
          requireFiles = {
            "test/**/test_helper.exs",
            -- "test/**/*_test.exs"
          },
        },
      }
      vim.keymap.set("n", "<leader>b", dap.toggle_breakpoint)
      vim.keymap.set("n", "<leader>gb", dap.run_to_cursor)
      vim.keymap.set("n", "<leader>B", function()
        require("dapui").toggle()
      end)

      -- Run debugger with current file
      vim.keymap.set("n", "<leader>Bt", function()
        require("dapui").open()
        dap.run(dap.configurations.elixir[1]) -- "mix test (current file)"
      end)

      -- Run debugger with current line
      vim.keymap.set("n", "<leader>Bl", function()
        -- local file = vim.fn.expand("%:p")
        -- local line = vim.fn.line(".")
        -- print("Would run: mix test " .. file .. ":" .. line)
        require("dapui").open()
        dap.run(dap.configurations.elixir[2]) -- "mix test (current line)"
      end)

      -- -- Run all tests
      -- vim.keymap.set("n", "<leader>da", function()
      --   dap.run(dap.configurations.elixir[3]) -- "mix test (all)"
      -- end)
    end

  }
}
