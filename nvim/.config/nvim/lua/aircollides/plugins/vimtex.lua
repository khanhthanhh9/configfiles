return {
	"lervag/vimtex",
	config = function()
		vim.g.tex_flavor = "latex"
		vim.g.vimtex_view_method = "zathura" -- or skim/okular if not on Linux
		vim.g.vimtex_quickfix_mode = 0

		-- conceal: hide ugly syntax, show clean math symbols
		vim.o.conceallevel = 1
		vim.g.tex_conceal = "abdmg"
	end,
}
