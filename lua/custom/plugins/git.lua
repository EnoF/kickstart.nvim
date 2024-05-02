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
