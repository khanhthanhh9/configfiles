-- ~/.config/nvim/lua/aircollides/plugins/lsp/lspconfig.lua
return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{
			"williamboman/mason.nvim",
			version = "1.9.0", -- stable with lspconfig <2.0
		},
		{
			"williamboman/mason-lspconfig.nvim",
			version = "1.32.0", -- ⬅ pin here
		},
		{
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			version = "1.7.0", -- avoids lspconfig_to_package nil
		},
		"hrsh7th/cmp-nvim-lsp",
		{ "antosha417/nvim-lsp-file-operations", config = true },
		{ "folke/neodev.nvim", opts = {} },
	},
	config = function()
		-- Capabilities (for nvim-cmp completion)
		local capabilities = require("cmp_nvim_lsp").default_capabilities()

		-- LSP keymaps
		local keymap = vim.keymap
		vim.api.nvim_create_autocmd("LspAttach", {
			group = vim.api.nvim_create_augroup("UserLspConfig", {}),
			callback = function(ev)
				local opts = { buffer = ev.buf, silent = true }

				opts.desc = "Show LSP references"
				keymap.set("n", "gR", "<cmd>Telescope lsp_references<CR>", opts)

				opts.desc = "Go to declaration"
				keymap.set("n", "gD", vim.lsp.buf.declaration, opts)

				opts.desc = "Show LSP definitions"
				keymap.set("n", "gd", "<cmd>Telescope lsp_definitions<CR>", opts)

				opts.desc = "Show LSP implementations"
				keymap.set("n", "gi", "<cmd>Telescope lsp_implementations<CR>", opts)

				opts.desc = "Show LSP type definitions"
				keymap.set("n", "gt", "<cmd>Telescope lsp_type_definitions<CR>", opts)

				opts.desc = "See available code actions"
				keymap.set({ "n", "v" }, "<leader>ca", vim.lsp.buf.code_action, opts)

				opts.desc = "Smart rename"
				keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)

				opts.desc = "Show buffer diagnostics"
				keymap.set("n", "<leader>D", "<cmd>Telescope diagnostics bufnr=0<CR>", opts)

				opts.desc = "Show line diagnostics"
				keymap.set("n", "<leader>d", vim.diagnostic.open_float, opts)

				opts.desc = "Prev diagnostic"
				keymap.set("n", "[d", vim.diagnostic.goto_prev, opts)

				opts.desc = "Next diagnostic"
				keymap.set("n", "]d", vim.diagnostic.goto_next, opts)

				opts.desc = "Hover docs"
				keymap.set("n", "K", vim.lsp.buf.hover, opts)

				opts.desc = "Restart LSP"
				keymap.set("n", "<leader>rs", ":LspRestart<CR>", opts)
			end,
		})

		-- Diagnostic signs
		local signs = { Error = " ", Warn = " ", Hint = "󰠠 ", Info = " " }
		for type, icon in pairs(signs) do
			local hl = "DiagnosticSign" .. type
			vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
		end

		-- Mason setup
		require("mason").setup()

		-- Mason-lspconfig setup (v1.32 style)
		local mason_lspconfig = require("mason-lspconfig")
		mason_lspconfig.setup({
			ensure_installed = {
				"lua_ls",
				"emmet_ls",
				"graphql",
				"svelte",
				"pyright", -- Python
			},
			automatic_installation = true,
		})

		mason_lspconfig.setup_handlers({
			function(server_name) -- default handler
				require("lspconfig")[server_name].setup({
					capabilities = capabilities,
				})
			end,

			-- Lua
			["lua_ls"] = function()
				require("lspconfig").lua_ls.setup({
					capabilities = capabilities,
					settings = {
						Lua = {
							runtime = { version = "LuaJIT" },
							diagnostics = { globals = { "vim", "require" } },
							completion = { callSnippet = "Replace" },
						},
					},
				})
			end,

			-- Emmet
			["emmet_ls"] = function()
				require("lspconfig").emmet_ls.setup({
					capabilities = capabilities,
					filetypes = {
						"html",
						"css",
						"sass",
						"scss",
						"less",
						"javascriptreact",
						"typescriptreact",
						"svelte",
					},
				})
			end,

			-- GraphQL
			["graphql"] = function()
				require("lspconfig").graphql.setup({
					capabilities = capabilities,
					filetypes = { "graphql", "gql", "svelte", "typescriptreact", "javascriptreact" },
				})
			end,

			-- Svelte
			["svelte"] = function()
				require("lspconfig").svelte.setup({
					capabilities = capabilities,
					on_attach = function(client, _)
						vim.api.nvim_create_autocmd("BufWritePost", {
							pattern = { "*.js", "*.ts" },
							callback = function(ctx)
								client.notify("$/onDidChangeTsOrJsFile", { uri = ctx.match })
							end,
						})
					end,
				})
			end,

			-- Python
			["pyright"] = function()
				require("lspconfig").pyright.setup({
					capabilities = capabilities,
					settings = {
						python = {
							analysis = {
								typeCheckingMode = "basic",
								autoImportCompletions = true,
							},
						},
					},
				})
			end,

			-- Go
			["gopls"] = function()
				require("lspconfig").gopls.setup({
					capabilities = capabilities,
					settings = {
						gopls = {
							analyses = {
								unusedparams = true,
								shadow = true,
							},
							staticcheck = true,
						},
					},
				})
			end,
		})
	end,
}
