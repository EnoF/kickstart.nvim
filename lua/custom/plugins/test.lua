return {
  {
    'nvim-neotest/neotest',
    dependencies = {
      'marilari88/neotest-vitest',
      'nvim-neotest/nvim-nio',
      'plenary.nvim',
    },
    config = function()
      ---@diagnostic disable-next-line: missing-fields
      require('neotest').setup {
        adapters = {
          require 'neotest-vitest' {
            vitestCommand = 'npx vitest --disable-console-intercept',
          },
        },
      }
    end,
    keys = {
      {
        '<leader>tt',
        function()
          require('neotest').run.run(vim.fn.expand '%')
        end,
        desc = 'Run File',
      },
      {
        '<leader>tT',
        function()
          require('neotest').run.run(vim.uv.cwd())
        end,
        desc = 'Run All Test Files',
      },
      {
        '<leader>tr',
        function()
          if vim.bo.filetype == 'pact' then
            local file = vim.api.nvim_buf_get_name(0)
            local out = vim.api.nvim_exec2('! pact -t ' .. file, { output = true })
            local res = vim.split(out.output, '\n', { plain = true })
            vim.cmd 'split new'
            vim.api.nvim_buf_set_lines(0, 0, -1, true, res)
            vim.opt_local.modified = false
            vim.cmd '$'
          else
            require('neotest').run.run()
          end
        end,
        desc = 'Run Nearest',
      },
      {
        '<leader>tl',
        function()
          require('neotest').run.run_last()
        end,
        desc = 'Run Last',
      },
      {
        '<leader>ts',
        function()
          require('neotest').summary.toggle()
        end,
        desc = 'Toggle Summary',
      },
      {
        '<leader>to',
        function()
          require('neotest').output.open { enter = true, auto_close = true }
        end,
        desc = 'Show Output',
      },
      {
        '<leader>tO',
        function()
          require('neotest').output_panel.toggle()
        end,
        desc = 'Toggle Output Panel',
      },
      {
        '<leader>tS',
        function()
          require('neotest').run.stop()
        end,
        desc = 'Stop',
      },
      {
        '<leader>twf',
        function()
          ---@diagnostic disable-next-line: missing-fields
          require('neotest').run.run { vim.fn.expand '%', vitestCommand = 'npx vitest --disable-console-intercept --watch' }
        end,
        desc = 'Run Watch File',
      },
    },
  },
  {
    'mfussenegger/nvim-dap',
    config = function()
      local present_dapui, dapui = pcall(require, 'dapui')
      local present_dap, dap = pcall(require, 'dap')
      local present_virtual_text, dap_vt = pcall(require, 'nvim-dap-virtual-text')
      local present_dap_utils, dap_utils = pcall(require, 'dap.utils')
      local keymap = vim.keymap.set
      local opts = { noremap = true, silent = true }

      if not present_dapui or not present_dap or not present_virtual_text or not present_dap_utils then
        vim.notify 'Missing dap dependencies'
        return
      end

      -- ╭──────────────────────────────────────────────────────────╮
      -- │ DAP Virtual Text Setup                                   │
      -- ╰──────────────────────────────────────────────────────────╯
      dap_vt.setup {
        enabled = true, -- enable this plugin (the default)
        enabled_commands = true, -- create commands DapVirtualTextEnable, DapVirtualTextDisable, DapVirtualTextToggle, (DapVirtualTextForceRefresh for refreshing when debug adapter did not notify its termination)
        highlight_changed_variables = true, -- highlight changed values with NvimDapVirtualTextChanged, else always NvimDapVirtualText
        highlight_new_as_changed = false, -- highlight new variables in the same way as changed variables (if highlight_changed_variables)
        show_stop_reason = true, -- show stop reason when stopped for exceptions
        commented = false, -- prefix virtual text with comment string
        only_first_definition = true, -- only show virtual text at first definition (if there are multiple)
        all_references = false, -- show virtual text on all all references of the variable (not only definitions)
        filter_references_pattern = '<module', -- filter references (not definitions) pattern when all_references is activated (Lua gmatch pattern, default filters out Python modules)
        -- Experimental Features:
        virt_text_pos = 'eol', -- position of virtual text, see `:h nvim_buf_set_extmark()`
        all_frames = false, -- show virtual text for all stack frames not only current. Only works for debugpy on my machine.
        virt_lines = false, -- show virtual lines instead of virtual text (will flicker!)
        virt_text_win_col = nil, -- position the virtual text at a fixed window column (starting from the first text column) ,
      }

      -- ╭──────────────────────────────────────────────────────────╮
      -- │ DAP UI Setup                                             │
      -- ╰──────────────────────────────────────────────────────────╯
      dapui.setup {
        icons = { expanded = '▾', collapsed = '▸' },
        mappings = {
          -- Use a table to apply multiple mappings
          expand = { '<CR>', '<2-LeftMouse>' },
          open = 'o',
          remove = 'd',
          edit = 'e',
          repl = 'r',
          toggle = 't',
        },
        -- Expand lines larger than the window
        -- Requires >= 0.7
        expand_lines = vim.fn.has 'nvim-0.7',
        -- Layouts define sections of the screen to place windows.
        -- The position can be "left", "right", "top" or "bottom".
        -- The size specifies the height/width depending on position. It can be an Int
        -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
        -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
        -- Elements are the elements shown in the layout (in order).
        -- Layouts are opened in order so that earlier layouts take priority in window sizing.
        layouts = {
          {
            elements = {
              -- Elements can be strings or table with id and size keys.
              { id = 'scopes', size = 0.25 },
              'breakpoints',
              'stacks',
              'watches',
            },
            size = 40, -- 40 columns
            position = 'left',
          },
          {
            elements = {
              'repl',
              'console',
            },
            size = 0.25, -- 25% of total lines
            position = 'bottom',
          },
        },
        floating = {
          max_height = nil, -- These can be integers or a float between 0 and 1.
          max_width = nil, -- Floats will be treated as percentage of your screen.
          border = 'rounded', -- Border style. Can be "single", "double" or "rounded"
          mappings = {
            close = { 'q', '<Esc>' },
          },
        },
        windows = { indent = 1 },
        render = {
          max_type_length = nil, -- Can be integer or nil.
        },
      }

      -- ╭──────────────────────────────────────────────────────────╮
      -- │ DAP Setup                                                │
      -- ╰──────────────────────────────────────────────────────────╯
      dap.set_log_level 'TRACE'

      -- Automatically open UI
      dap.listeners.after.event_initialized['dapui_config'] = function()
        dapui.open()
      end
      dap.listeners.after.event_terminated['dapui_config'] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited['dapui_config'] = function()
        dapui.close()
      end

      -- Enable virtual text
      vim.g.dap_virtual_text = true

      -- ╭──────────────────────────────────────────────────────────╮
      -- │ Icons                                                    │
      -- ╰──────────────────────────────────────────────────────────╯
      vim.fn.sign_define('DapBreakpoint', { text = '', texthl = '', linehl = '', numhl = '' })
      vim.fn.sign_define('DapStopped', { text = '', texthl = '', linehl = '', numhl = '' })

      -- ╭──────────────────────────────────────────────────────────╮
      -- │ Keybindings                                              │
      -- ╰──────────────────────────────────────────────────────────╯
      keymap('n', '<Leader>da', "<CMD>lua require('dap').continue()<CR>", opts)
      keymap('n', '<Leader>db', "<CMD>lua require('dap').toggle_breakpoint()<CR>", opts)
      keymap('n', '<Leader>dc', "<CMD>lua require('dap').continue()<CR>", opts)
      keymap('n', '<Leader>dd', "<CMD>lua require('dap').continue()<CR>", opts)
      keymap('n', '<Leader>dh', "<CMD>lua require('dapui').eval()<CR>", opts)
      keymap('n', '<Leader>di', "<CMD>lua require('dap').step_into()<CR>", opts)
      keymap('n', '<Leader>do', "<CMD>lua require('dap').step_out()<CR>", opts)
      keymap('n', '<Leader>dO', "<CMD>lua require('dap').step_over()<CR>", opts)
      keymap('n', '<Leader>dt', "<CMD>lua require('dap').terminate()<CR>", opts)
      keymap('n', '<Leader>dU', "<CMD>lua require('dapui').open()<CR>", opts)
      keymap('n', '<Leader>dC', "<CMD>lua require('dapui').close()<CR>", opts)

      keymap('n', '<Leader>dw', "<CMD>lua require('dapui').float_element('watches', { enter = true })<CR>", opts)
      keymap('n', '<Leader>ds', "<CMD>lua require('dapui').float_element('scopes', { enter = true })<CR>", opts)
      keymap('n', '<Leader>dr', "<CMD>lua require('dapui').float_element('repl', { enter = true })<CR>", opts)

      -- ╭──────────────────────────────────────────────────────────╮
      -- │ Adapters                                                 │
      -- ╰──────────────────────────────────────────────────────────╯

      -- VSCODE JS (Node/Chrome/Terminal/Jest)
      require('dap-vscode-js').setup {
        node_path = 'node',
        debugger_path = os.getenv 'HOME' .. '/.DAP/vscode-js-debug',
        adapters = { 'pwa-node', 'pwa-chrome', 'pwa-msedge', 'node-terminal', 'pwa-extensionHost' },
      }

      -- ╭──────────────────────────────────────────────────────────╮
      -- │ Configurations                                           │
      -- ╰──────────────────────────────────────────────────────────╯
      local exts = {
        'javascript',
        'typescript',
        'javascriptreact',
        'typescriptreact',
        'vue',
        'svelte',
      }

      for i, ext in ipairs(exts) do
        dap.configurations[ext] = {
          {
            type = 'pwa-chrome',
            request = 'launch',
            name = 'Launch Chrome with "localhost"',
            url = function()
              local co = coroutine.running()
              return coroutine.create(function()
                vim.ui.input({ prompt = 'Enter URL: ', default = 'http://localhost:3000' }, function(url)
                  if url == nil or url == '' then
                    return
                  else
                    coroutine.resume(co, url)
                  end
                end)
              end)
            end,
            webRoot = vim.fn.getcwd(),
            protocol = 'inspector',
            sourceMaps = true,
            userDataDir = false,
            resolveSourceMapLocations = {
              '${workspaceFolder}/**',
              '!**/node_modules/**',
            },
          },
          {
            type = 'pwa-node',
            request = 'launch',
            name = 'Launch Current File (pwa-node)',
            cwd = vim.fn.getcwd(),
            args = { '${file}' },
            sourceMaps = true,
            protocol = 'inspector',
            runtimeExecutable = 'npm',
            runtimeArgs = {
              'run-script',
              'dev',
            },
            resolveSourceMapLocations = {
              '${workspaceFolder}/**',
              '!**/node_modules/**',
            },
          },
          {
            type = 'pwa-node',
            request = 'launch',
            name = 'Launch Current File (pwa-node with ts-node)',
            cwd = vim.fn.getcwd(),
            runtimeArgs = { '--loader', 'ts-node/esm' },
            runtimeExecutable = 'node',
            args = { '${file}' },
            sourceMaps = true,
            protocol = 'inspector',
            skipFiles = { '<node_internals>/**', 'node_modules/**' },
            resolveSourceMapLocations = {
              '${workspaceFolder}/**',
              '!**/node_modules/**',
            },
          },
          {
            type = 'pwa-node',
            request = 'launch',
            name = 'Launch Current File (pwa-node with deno)',
            cwd = vim.fn.getcwd(),
            runtimeArgs = { 'run', '--inspect-brk', '--allow-all', '${file}' },
            runtimeExecutable = 'deno',
            attachSimplePort = 9229,
          },
          {
            type = 'pwa-node',
            request = 'launch',
            name = 'Launch Test Current File (pwa-node with jest)',
            cwd = vim.fn.getcwd(),
            runtimeArgs = { '${workspaceFolder}/node_modules/.bin/jest' },
            runtimeExecutable = 'node',
            args = { '${file}', '--coverage', 'false' },
            rootPath = '${workspaceFolder}',
            sourceMaps = true,
            console = 'integratedTerminal',
            internalConsoleOptions = 'neverOpen',
            skipFiles = { '<node_internals>/**', 'node_modules/**' },
          },
          {
            type = 'pwa-node',
            request = 'launch',
            name = 'Launch Test Current File (pwa-node with vitest)',
            cwd = vim.fn.getcwd(),
            program = '${workspaceFolder}/node_modules/vitest/vitest.mjs',
            args = { '--inspect-brk', '--no-file-parallelism', 'run', '${file}' },
            -- autoAttachChildProcesses = true,
            attachSimplePort = 9229,
            smartStep = true,
            console = 'integratedTerminal',
            skipFiles = { '<node_internals>/**', 'node_modules/**' },
          },
          {
            type = 'pwa-node',
            request = 'launch',
            name = 'Launch Test Current File (pwa-node with deno)',
            cwd = vim.fn.getcwd(),
            runtimeArgs = { 'test', '--inspect-brk', '--allow-all', '${file}' },
            runtimeExecutable = 'deno',
            attachSimplePort = 9229,
          },
          {
            type = 'pwa-chrome',
            request = 'attach',
            name = 'Attach Program (pwa-chrome, select port)',
            program = '${file}',
            cwd = vim.fn.getcwd(),
            sourceMaps = true,
            protocol = 'inspector',
            port = function()
              return vim.fn.input('Select port: ', 9222)
            end,
            webRoot = '${workspaceFolder}',
          },
          {
            type = 'pwa-node',
            request = 'attach',
            name = 'Attach Program (pwa-node, select pid)',
            cwd = vim.fn.getcwd(),
            processId = dap_utils.pick_process,
            skipFiles = { '<node_internals>/**' },
          },
        }
      end
    end,
    keys = {
      '<Leader>da',
      '<Leader>db',
      '<Leader>dc',
      '<Leader>dd',
      '<Leader>dh',
      '<Leader>di',
      '<Leader>do',
      '<Leader>dO',
      '<Leader>dt',
    },
    dependencies = {
      'theHamsta/nvim-dap-virtual-text',
      'rcarriga/nvim-dap-ui',
      'mxsdev/nvim-dap-vscode-js',
    },
  },
  {
    'andrewferrier/debugprint.nvim',
    opts = {
      keymaps = {
        normal = {
          plain_below = '<leader>pp',
          plain_above = '<leader>pP',
          variable_below = '<leader>pv',
          variable_above = '<leader>pV',
          variable_below_alwaysprompt = nil,
          variable_above_alwaysprompt = nil,
          textobj_below = '<leader>po',
          textobj_above = '<leader>pO',
          toggle_comment_debug_prints = '<leader>pt',
          delete_debug_prints = '<leader>pd',
        },
        visual = {
          variable_below = '<leader>pv',
          variable_above = '<leader>pV',
        },
      },
      commands = {
        toggle_comment_debug_prints = 'ToggleCommentDebugPrints',
        delete_debug_prints = 'DeleteDebugPrints',
      },
    },
    -- The 'keys' and 'cmds' sections of this configuration are only needed if
    -- you want to take advantage of `lazy.nvim` lazy-loading.
    keys = {
      { '<leader>pp', mode = 'n' },
      { '<leader>pP', mode = 'n' },
      { '<leader>pv', mode = 'n' },
      { '<leader>pV', mode = 'n' },
      { '<leader>po', mode = 'n' },
      { '<leader>pO', mode = 'n' },
      { '<leader>pv', mode = 'x' },
      { '<leader>pV', mode = 'x' },
      { '<leader>pd', mode = 'n' },
      { '<leader>pt', mode = 'n' },
    },
    cmd = {
      'ToggleCommentDebugPrints',
      'DeleteDebugPrints',
    },
    version = '*',
  },
}
