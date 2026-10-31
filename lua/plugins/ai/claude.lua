-- claudecode.nvim: https://github.com/coder/claudecode.nvim
--
-- Fresh-install notes:
--  * Commands missing after install? lazy.nvim treats any `keys`/`cmd` table (even an empty
--    one) as "lazy-load", so the plugin never loads without a real trigger. Keep `cmd` below.
--  * `claude` must be on PATH (the native installer puts it in ~/.local/bin). Only set
--    `opts.terminal_cmd` if it lives elsewhere; the README's ~/.claude/local/claude is an old path.
--  * Verify: `:echo exists(':ClaudeCode')` should print 2.
local M = {}

M.init = function()
  return {
    'coder/claudecode.nvim',
    dependencies = { 'folke/snacks.nvim' },
    config = true,
    -- lazy-load triggers; see fresh-install notes above
    cmd = {
      'ClaudeCode',
      'ClaudeCodeFocus',
      'ClaudeCodeSelectModel',
      'ClaudeCodeAdd',
      'ClaudeCodeSend',
      'ClaudeCodeTreeAdd',
      'ClaudeCodeDiffAccept',
      'ClaudeCodeDiffDeny',
    },
    keys = {
      { '<leader>a', nil, desc = 'AI/Claude Code' },
      { '<leader>ac', '<cmd>ClaudeCode<cr>', desc = 'Toggle Claude' },
      { '<leader>af', '<cmd>ClaudeCodeFocus<cr>', desc = 'Focus Claude' },
      { '<leader>ar', '<cmd>ClaudeCode --resume<cr>', desc = 'Resume Claude' },
      { '<leader>aC', '<cmd>ClaudeCode --continue<cr>', desc = 'Continue Claude' },
      { '<leader>am', '<cmd>ClaudeCodeSelectModel<cr>', desc = 'Select Claude model' },
      { '<leader>ab', '<cmd>ClaudeCodeAdd %<cr>', desc = 'Add current buffer' },
      { '<leader>as', '<cmd>ClaudeCodeSend<cr>', mode = 'v', desc = 'Send to Claude' },
      { '<leader>as', '<cmd>ClaudeCodeTreeAdd<cr>', desc = 'Add file', ft = { 'neo-tree' } },
      { '<leader>aa', '<cmd>ClaudeCodeDiffAccept<cr>', desc = 'Accept diff' },
      { '<leader>ad', '<cmd>ClaudeCodeDiffDeny<cr>', desc = 'Deny diff' },
    },
  }
end

return M
