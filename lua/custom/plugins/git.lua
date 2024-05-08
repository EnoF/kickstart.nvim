return {
  { -- Adds git related signs to the gutter, as well as utilities for managing changes
    'lewis6991/gitsigns.nvim',
    opts = {
      signs = {
        add = { text = '+' },
        change = { text = '~' },
        delete = { text = '_' },
        topdelete = { text = '‾' },
        changedelete = { text = '~' },
      },
    },
  },
  {
    'samoshkin/vim-mergetool',
    config = function()
      vim.g.mergetool_layout = 'LbR,m'
    end,
    keys = {
      { '<leader>mt', ':MergetoolToggle<CR>', mode = 'n', desc = '[M]ergetool [T]oggle' },
    },
  },
  {
    'kdheepak/lazygit.nvim',
    cmd = {
      'LazyGit',
      'LazyGitConfig',
      'LazyGitCurrentFile',
      'LazyGitFilter',
      'LazyGitFilterCurrentFile',
    },
    -- optional for floating window border decoration
    dependencies = {
      'nvim-lua/plenary.nvim',
    },
    -- setting the keybinding for LazyGit with 'keys' is recommended in
    -- order to load the plugin when the command is run for the first time
    keys = {
      { '<leader>gg', '<cmd>LazyGit<cr>', desc = 'LazyGit' },
    },
  },
  {
    'tpope/vim-fugitive',
    keys = {
      {
        '<leader>gf',
        ':Git fetch<CR>',
        mode = 'n',
        desc = '[G]it [F]etch',
      },
      {
        '<leader>gs',
        ':Git<CR>',
        mode = 'n',
        desc = '[G]it [S]tatus',
      },
      {
        '<leader>ga',
        ':Git add<CR>',
        mode = 'n',
        desc = '[G]it [A]dd',
      },
      {
        '<leader>gp',
        ':Git push --force-with-lease<CR>',
        mode = 'n',
        desc = '[G]it [P]ush force with lease',
      },
      {
        '<leader>gc',
        ':Git commit<CR>',
        mode = 'n',
        desc = '[G]it [C]ommit',
      },
      {
        '<leader>gb',
        ':!git checkout -b ',
        mode = 'n',
        desc = '[G]it checkout [B]ranch',
      },
    },
  },
}
