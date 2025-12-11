return {
	require("lspconfig").rust_analyzer.setup({
		settings = {
			["rust-analyzer"] = {
				inlayHints = {
					enable = false,
					typeHints = { enable = false }, -- Disables type hints
					chainingHints = { enable = false }, -- Optional: Disables chaining hints as well
					parameterHints = { enable = false }, -- Optional: Disables parameter hints
				},
			},
		},
	}),
}
