{ inputs, pkgs, ... }:

{
  environment.variables = {
    EDITOR = "nvim";
    VISUAL = "nvim";
  };

  # Include NixVim
  imports = [ inputs.nixvim.nixosModules.nixvim ];

  programs.nixvim = {
    enable = true;
    globals.mapleader = " ";
    colorschemes.gruvbox.enable = true;

    plugins = {
      # completions
      cmp.enable = true;
      cmp-nvim-lsp.enable = true;

      # Please explicitly define `plugins.web-devicons.enable` or alternatively
      # enable `plugins.mini.enable` with `plugins.mini.modules.icons` and `plugins.mini.mockDevIcons`.
      web-devicons.enable = true;

      # pretty statusline
      lualine.enable = true;

      # all commands available straight away
      telescope.enable = true;

      # browse with yazi, open in buffer
      yazi.enable = true;

      # all parsers included
      treesitter.enable = true;

      luasnip.enable = true;

      # Keybinding help popup
      which-key.enable = true;
      which-key.settings.expand = 1;

      #harpoon.enable = true;

      # Needed for lazygit
      toggleterm.enable = true;

      gitsigns.enable = true;
      neo-tree.enable = true;

      bufferline.enable = true;
      # bufferline.settings = 
    };

    plugins.lsp = {
      enable = true;
      servers = {
        rust_analyzer = {
          enable = true;
          settings = { inlayHints = { enable = false; }; };
          installCargo = false;
          installRustc = false;
        };
        ruff.enable = true;
        pyright.enable = true;
      };
    };

    extraConfigLua = ''
      local cmp = require'cmp'
      local luasnip = require'luasnip'

      cmp.setup({
        snippet = {
          expand = function(args)
            luasnip.lsp_expand(args.body)
          end,
        },
        mapping = {
          ['<C-Space>'] = cmp.mapping.complete(), -- Trigger autocomplete with Ctrl+Space
          ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Confirm the selection with Enter
          ['<C-n>'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Insert }),
          ['<C-p>'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Insert }),
          ['j'] = cmp.mapping.select_next_item({ behavior = cmp.SelectBehavior.Select }),
          ['k'] = cmp.mapping.select_prev_item({ behavior = cmp.SelectBehavior.Select }),
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'luasnip' },
        },
	window = {
          documentation = cmp.config.window.bordered({ 
	    max_width = 50,
	    max_height = 30,
	  }),
	  completion = cmp.config.window.bordered({ 
	    max_width = 70,
	    max_height = 100,
	  }),
        },
      })

      local capabilities = require('cmp_nvim_lsp').default_capabilities()

      require('lspconfig').rust_analyzer.setup {
        capabilities = capabilities,
      }
    '';

    opts = {
      number = true; # Show line numbers
      relativenumber = true; # Show relative line numbers
      shiftwidth = 2; # Tab width should be 2
    };

    keymaps = [
      # Telescope keymaps
      {
        key = "<leader><space>";
        action = ":Telescope find_files<CR>";
        options.desc = "Find files with Telescope";
      }
      {
        key = "<leader>ff";
        action = ":Telescope find_files<CR>";
        options.desc = "Find files with Telescope";
      }
      {
        key = "<leader>fg";
        action = ":Telescope live_grep<CR>";
        options.desc = "Grep files with Telescope";
      }
      {
        key = "<leader>fb";
        action = ":Telescope buffers<CR>";
        options.desc = "List open buffers with Telescope";
      }
      {
        key = "<leader>fh";
        action = ":Telescope help_tags<CR>";
        options.desc = "Find help tags with Telescope";
      }
      {
        key = "<leader>e";
        action = ":Neotree toggle<CR>";
        options.desc = "Toggle Neotree";
      }

      # Window navigation
      {
        key = "<C-h>";
        action = "<C-w>h";
        options.desc = "Move focus to left window";
      }
      {
        key = "<C-j>";
        action = "<C-w>j";
        options.desc = "Move focus to down window";
      }
      {
        key = "<C-k>";
        action = "<C-w>k";
        options.desc = "Move focus to up window";
      }
      {
        key = "<C-l>";
        action = "<C-w>l";
        options.desc = "Move focus to right window";
      }

      # explore with yazi!
      {
        key = "<leader>y";
        action = ":Yazi<CR>";
        options.desc = "yazi file browse";
      }

      # Buffer navigation
      {
        key = "<S-h>";
        action = ":bprev<CR>";
        options.desc = "Previous buffer";
      }
      {
        key = "<S-l>";
        action = ":bnext<CR>";
        options.desc = "Next buffer";
      }

      # LSP
      {
        key = "gd";
        action = ":lua vim.lsp.buf.definition()<CR>";
        options.desc = "Go to definition";
      }
      {
        key = "gr";
        action = ":lua vim.lsp.buf.references()<CR>";
        options.desc = "Show references";
      }
      {
        key = "gD";
        action = ":lua vim.lsp.buf.declaration()<CR>";
        options.desc = "Go to declaration";
      }
      {
        key = "K";
        action = ":lua vim.lsp.buf.hover()<CR>";
        options.desc = "Hover documentation";
      }

      # Diagnostic keymaps
      {
        key = "[d";
        action = ":lua vim.diagnostic.goto_prev()<CR>";
        options.desc = "Previous diagnostic";
      }
      {
        key = "]d";
        action = ":lua vim.diagnostic.goto_next()<CR>";
        options.desc = "Next diagnostic";
      }

      # Lazygit
      {
        key = "<leader>gg";
        action =
          ":lua require('toggleterm.terminal').Terminal:new({ cmd = 'lazygit', direction = 'float' }):toggle()<CR>";
        options.desc = "Lazygit with ToggleTerm";
      }
      {
        key = "<leader>gb";
        action = ":Gitsigns blame_line<CR>";
        options.desc = "Git Blame Line with Gitsigns";
      }
      {
        key = "<leader>q";
        action = ":qa<CR>";
        options.desc = "Quit All";
      }

    ];
  };
}
