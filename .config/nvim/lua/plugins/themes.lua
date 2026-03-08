-- every spec file under the "plugins" directory will be loaded automatically by lazy.nvim
--
-- In your plugin files, you can:
-- * add extra plugins
-- * disable/enabled LazyVim plugins
-- * override the configuration of LazyVim plugins
--
--
return {
  -- Disable dynamic base16 theme overrides from danklinux/matugen.
  { "RRethy/base16-nvim", enabled = false },
  {
    "neanias/everforest-nvim",
    config = function()
      require("everforest").setup({
        background = "hard",
        transparent_background_level = 0,
        ui_contrast = "high",
        show_eob = true,
        float_style = "bright",
        ---@param palette Everforest.Palette
        colours_override = function(palette)
          local black = "#000000"
          -- Keep only the core canvas dark; leave accent/utility backgrounds intact
          -- so visual/search/diagnostic highlights preserve contrast.
          palette.bg_dim = black
          palette.bg0 = black
          palette.bg1 = black
        end,
      })
    end,
  },
  {
    "LazyVim/LazyVim",
    opts = function(_, opts)
      opts.colorscheme = "everforest"

      -- Stop an already-running matugen watcher from previous config loads.
      if _G._matugen_theme_watcher then
        pcall(_G._matugen_theme_watcher.stop, _G._matugen_theme_watcher)
        pcall(_G._matugen_theme_watcher.close, _G._matugen_theme_watcher)
        _G._matugen_theme_watcher = nil
      end

      local function force_black_background()
        local black = "#000000"

        local groups = { "Normal", "NormalNC", "SignColumn", "EndOfBuffer" }

        for _, group in ipairs(groups) do
          local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = group, link = false })
          if ok then
            hl.bg = black
            pcall(vim.api.nvim_set_hl, 0, group, hl)
          end
        end
      end

      local augroup = vim.api.nvim_create_augroup("force_pure_black_bg", { clear = true })
      vim.api.nvim_create_autocmd("ColorScheme", {
        group = augroup,
        callback = function()
          if vim.g.colors_name ~= "everforest" then
            vim.schedule(function()
              vim.cmd.colorscheme("everforest")
            end)
            return
          end
          force_black_background()
        end,
      })

      -- Ensure this applies on startup and after theme plugin loads.
      vim.schedule(function()
        if vim.g.colors_name ~= "everforest" then
          vim.cmd.colorscheme("everforest")
        end
        force_black_background()
      end)

      return opts
    end,
  },
}
