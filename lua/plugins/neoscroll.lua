return {
  'karb94/neoscroll.nvim',
  opts = {
    hide_cursor = false,
    stop_eof = true,
    use_local_scrolloff = false,
    respect_scrolloff = false,
    cursor_scrolls_alone = true,
    easing_function = nil,
    pre_hook = nil,
    post_hook = nil,
    performance_mode = false,
  },
  config = function(_, opts)
    require('neoscroll').setup(opts)

    local scroll = require('neoscroll').scroll

    -- Helper: calculate one-third of window height
    local function one_third()
      return math.floor(vim.api.nvim_win_get_height(0) / 3)
    end

    -- Scroll down one-third of the window
    vim.keymap.set('n', '<C-d>', function()
      scroll(one_third(), { move_cursor = true, duration = 100 })
    end, { desc = 'Scroll down one-third of screen' })

    -- Scroll up one-third of the window
    vim.keymap.set('n', '<C-u>', function()
      scroll(-one_third(), { move_cursor = true, duration = 100 })
    end, { desc = 'Scroll up one-third of screen' })
  end,
}
