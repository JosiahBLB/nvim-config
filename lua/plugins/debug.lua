return {
  {
    'mfussenegger/nvim-dap',
    dependencies = {
      -- Creates a beautiful debugger UI
      'rcarriga/nvim-dap-ui',

      -- Inline debug hints
      { 'theHamsta/nvim-dap-virtual-text', opts = {} },

      -- Required dependency for nvim-dap-ui
      'nvim-neotest/nvim-nio',

      -- Installs the debug adapters for you
      'williamboman/mason.nvim',
      'jay-babu/mason-nvim-dap.nvim',

      -- Add your own debuggers here
      'leoluz/nvim-dap-go',
    },
    keys = {
      {
        '<leader>dk',
        function()
          require('dap').continue()
        end,
        desc = '[d]ebug [k]ontinue',
      },
      {
        '<leader>dq',
        function()
          require('dap').close()
          require('nvim-dap-virtual-text').disable()
          require('dapui').close()
        end,
        desc = '[d]ebug [q]uit',
      },
      {
        '<leader>dl',
        function()
          require('dap').run_last()
        end,
        desc = '[r]un [l]ast',
      },
      {
        '<leader>b',
        function()
          require('dap').toggle_breakpoint()
        end,
        desc = 'Toggle [b]reakpoint',
      },
      {
        '<leader>dr',
        function()
          require('dap').repl.open()
        end,
        desc = '[d]ebug open [r]EPL',
      },
      {
        '<leader>db',
        function()
          require('dap').set_breakpoint(vim.fn.input 'Breakpoint condition: ')
        end,
        desc = '[d]ebug conditional [b]reakpoint',
      },
      {
        '<leader>dc',
        function()
          require('dap').run_to_cursor()
        end,
        desc = 'Continue debugging to [c]ursor',
      },
      {
        '<leader>di',
        function()
          require('dap').step_into()
        end,
        desc = '[d]ebug [i]nto',
      },
      {
        '<leader>do',
        function()
          require('dap').step_out()
        end,
        desc = '[d]ebug [o]ut',
      },
      {
        '<leader>n',
        function()
          require('dap').step_over()
        end,
        desc = '[n]ext (step over)',
      },
      {
        '<leader>dp',
        function()
          require('dap').pause()
        end,
        desc = '[d]ebug [p]ause execution',
      },
      {
        '<leader>de',
        function()
          require('dap').goto_()
        end,
        desc = '[d]ebug [e]dit source',
      },
      {
        '<leader>dw',
        function()
          require('dap').ui.widgets.hover()
        end,
        desc = 'Show variables',
      },
      {
        '<leader>K',
        function()
          require('dapui').eval(nil, { enter = true })
        end,
        desc = 'evaluate variable under cursor',
      },
    },
    config = function()
      local dap = require 'dap'
      local dapui = require 'dapui'

      require('mason-nvim-dap').setup {
        -- Makes a best effort to setup the various debuggers with
        -- reasonable debug configurations
        automatic_installation = true,

        -- You can provide additional configuration to the handlers,
        -- see mason-nvim-dap README for more information
        handlers = {},

        -- You'll need to check that you have the required things installed
        -- online, please don't ask me how to install them :)
        ensure_installed = {
          -- Update this to ensure that you have the debuggers for the langs you want
          'delve',
        },
      }

      dap.configurations.cpp = {
        {
          name = 'Launch',
          type = 'codelldb',
          request = 'launch',
          program = function()
            -- use the cached file location
            if vim.g.cpp_executable_file_path and vim.loop.fs_stat(vim.g.cpp_executable_file_path) then
              return vim.g.cpp_executable_file_path
            end

            -- get the user input location for the exe
            local path = vim.fn.input {
              prompt = 'Path to executable: ',
              default = vim.fn.getcwd() .. '/',
              completion = 'file',
            }

            -- save the new location
            if path ~= '' then
              vim.g.cpp_executable_file_path = path
              return path
            end
            return nil
          end,
          cwd = '${workspaceFolder}',
          stopOnEntry = false,
          args = {},
        },
      }

      dap.configurations.c = dap.configurations.cpp

      dap.run_last = function()
        -- Override run_last implementation
        if dap.last_run then
          dap.run(dap.last_run.config, dap.last_run.opts)
        else
          dap.continue()
        end
      end

      -- Dap UI setup
      -- For more information, see |:help nvim-dap-ui|
      dapui.setup {
        -- Set icons to characters that are more likely to work in every terminal.
        --    Feel free to remove or use ones that you like more! :)
        --    Don't feel like these are good choices.
        icons = { expanded = '▾', collapsed = '▸', current_frame = '*' },
        controls = {
          icons = {
            pause = '⏸',
            play = '▶',
            step_into = '⏎',
            step_over = '⏭',
            step_out = '⏮',
            step_back = 'b',
            run_last = '▶▶',
            terminate = '⏹',
            disconnect = '⏏',
          },
        },
      }

      -- Change breakpoint icons
      vim.api.nvim_set_hl(0, 'DapBreak', { fg = '#e51400' })
      vim.api.nvim_set_hl(0, 'DapStop', { fg = '#ffcc00' })
      local breakpoint_icons = vim.g.have_nerd_font
          and { Breakpoint = '', BreakpointCondition = '', BreakpointRejected = '', LogPoint = '', Stopped = '' }
        or { Breakpoint = '●', BreakpointCondition = '⊜', BreakpointRejected = '⊘', LogPoint = '◆', Stopped = '⭔' }
      for type, icon in pairs(breakpoint_icons) do
        local tp = 'Dap' .. type
        local hl = (type == 'Stopped') and 'DapStop' or 'DapBreak'
        vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
      end

      dap.listeners.after.event_initialized['dapui_config'] = dapui.open
      dap.listeners.before.event_terminated['dapui_config'] = dapui.close
      dap.listeners.before.event_exited['dapui_config'] = dapui.close

      -- Install golang specific config
      require('dap-go').setup {
        delve = {
          -- On Windows delve must be run attached or it crashes.
          -- See https://github.com/leoluz/nvim-dap-go/blob/main/README.md#configuring
          detached = vim.fn.has 'win32' == 0,
        },
      }
    end,
  },
}
