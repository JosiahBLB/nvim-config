-- Was having trouble getting this to work until I found:
-- https://github.com/GLaDOS-418/vim/blob/fa1a6c171c0661ea537ca6f95d2caca7cf693fdd/nvim/lua/resession_cfg.lua#L4
-- Thanks my dude
return {
  {
    'stevearc/resession.nvim',
    config = function()
      local resession = require 'resession'

      -- Setup resession with autosave configuration
      resession.setup {
        autosave = {
          enabled = true,
          interval = 60, -- Save every 60 seconds
          notify = false,
        },
      }

      -- Helper: get session name based on git branch
      local function get_session_name()
        local cwd = vim.fn.getcwd()
        local branch = vim.trim(vim.fn.system 'git branch --show-current')
        if vim.v.shell_error == 0 and branch ~= '' then
          return cwd .. '-' .. branch
        end
        return cwd
      end

      -- Helper: check if cwd is HOME or ROOT
      local function is_home_or_root(cwd)
        local home = vim.fn.expand '~'
        return cwd == home or cwd == '/'
      end

      -- Keymaps
      vim.keymap.set('n', '<leader>ss', resession.save_tab, { desc = 'Save tab session' })
      vim.keymap.set('n', '<leader>sl', function()
        resession.load(get_session_name(), { dir = 'dirsession' })
      end, { desc = 'Load session' })
      vim.keymap.set('n', '<leader>sd', resession.delete, { desc = 'Delete session' })

      -- load on entry unless in home/root
      vim.api.nvim_create_autocmd('VimEnter', {
        callback = function()
          local cwd = vim.fn.getcwd()
          if is_home_or_root(cwd) then
            return
          end
          -- Only load the session if nvim was started with no args
          if vim.fn.argc(-1) == 0 then
            local session_name = get_session_name()
            resession.load(session_name, { dir = 'dirsession', silence_errors = true })
          end
        end,
      })

      -- Save on exit unless in home/root
      vim.api.nvim_create_autocmd('VimLeavePre', {
        callback = function()
          local cwd = vim.fn.getcwd()
          if is_home_or_root(cwd) then
            return
          end
          local session_name = get_session_name()
          resession.save(session_name, { dir = 'dirsession', notify = false })
        end,
      })
    end,
  },
}
