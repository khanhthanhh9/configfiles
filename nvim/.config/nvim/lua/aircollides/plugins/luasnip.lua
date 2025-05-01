return {
	"L3MON4D3/LuaSnip",
	version = "v2.*", -- use the latest stable version
	build = "make install_jsregexp", -- required for regex features
	dependencies = {
		"rafamadriz/friendly-snippets", -- optional: community snippets
	},
	config = function()
		require("luasnip.loaders.from_vscode").lazy_load() -- load friendly snippets

		local ls = require("luasnip")
		local s = ls.snippet
		local t = ls.text_node
		local i = ls.insert_node

		-- Define a simple snippet
		ls.add_snippets("lua", {
			s("hello", {
				t("Hello, world!"),
			}),
		})

		vim.keymap.set({ "i", "s" }, "<C-k>", function()
			if ls.expand_or_jumpable() then
				ls.expand_or_jump()
			end
		end, { silent = true })

		vim.keymap.set({ "i", "s" }, "<C-j>", function()
			if ls.jumpable(-1) then
				ls.jump(-1)
			end
		end, { silent = true })

		ls.add_snippets("lua", {
			s("fn", {
				t("function "),
				i(1, "name"),
				t("()"),
				t({ "", "  " }),
				i(2, "-- body"),
				t({ "", "end" }),
			}),
		})
	end,
}
