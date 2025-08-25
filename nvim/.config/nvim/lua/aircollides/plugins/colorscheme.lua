-- lua/plugins/rose-pine.lua
return {
	"rose-pine/neovim",
	name = "rose-pine",
	config = function()
		require("rose-pine").setup({
			-- optional config
			variant = "auto", -- auto, main, moon, or dawn
			dark_variant = "main",
			dim_inactive_windows = false,
			extend_background_behind_borders = true,

			highlight_groups = {
				ColorColumn = { bg = "rose" },
			},
		})

		-- Set colorscheme
		vim.cmd("colorscheme rose-pine")
	end,
}
