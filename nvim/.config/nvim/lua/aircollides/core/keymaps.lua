vim.g.mapleader = " "
vim.keymap.set("n", "<leader><leader>s", function()
	-- Adjust the module name to wherever you define your snippets
	local snippet_module = "aircollides.plugins.luasnip" -- example: `lua/snippets.lua`

	-- Unload and reload
	package.loaded[snippet_module] = nil
	require(snippet_module)

	print("Snippets reloaded!")
end, { desc = "Reload LuaSnip snippets" })

vim.cmd([[
  nnoremap <C-p> :GFiles<CR>
  nnoremap <leader>pf :Files<CR>
  nnoremap j  jzz
  nnoremap k  kzz
  nnoremap <C-d>  <C-d>zz
  nnoremap <C-u>  <C-u>zz

  " nnoremap <C-j> :cnext<CR>
  " nnoremap <C-k> :cprev<CR>
  vnoremap <leader>p "_dP
  vnoremap <leader>y "+y
  nnoremap <leader>y "+y
  nnoremap <leader>Y gg"+yG
  vnoremap J :m '>+1<CR>gv=gv
  vnoremap K :m '<-2<CR>gv=gv
  nnoremap <silent> [b :bprevious<CR>
  nnoremap <silent> ]b :bnext<CR>
  nnoremap <silent> [B :bfirst<CR>
  nnoremap <silent> ]B :blast<CR>
  ]])
local keymap = vim.keymap -- for conciseness

keymap.set(
	"n",
	"<C-f>",
	"<cmd>silent !tmux neww ~/airutils/tmux-sessionizer<CR>",
	{ desc = "Run tmux-sessionizer in a new tmux window" }
)

keymap.set(
	"n",
	"<C-T>",
	"<cmd>silent !tmux neww ~/airutils/tmux-cht.sh<CR>",
	{ desc = "Run tmux-cheatsheet in a new tmux window" }
)
keymap.set("n", "<C-s>", "<cmd>silent !tmux neww ~/airutils/tmux-snip<CR>", { desc = "Run snippet for saving code" })

keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment/decrement numbers
keymap.set("n", "<leader>+", "<C-a>", { desc = "Increment number" }) -- increment
keymap.set("n", "<leader>-", "<C-x>", { desc = "Decrement number" }) -- decrement

-- window management
keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

keymap.set("n", "<leader>to", "<cmd>tabnew<CR>", { desc = "Open new tab" }) -- open new tab
keymap.set("n", "<leader>tx", "<cmd>tabclose<CR>", { desc = "Close current tab" }) -- close current tab
keymap.set("n", "<leader>tn", "<cmd>tabn<CR>", { desc = "Go to next tab" }) --  go to next tab
keymap.set("n", "<leader>tp", "<cmd>tabp<CR>", { desc = "Go to previous tab" }) --  go to previous tab
keymap.set("n", "<leader>tf", "<cmd>tabnew %<CR>", { desc = "Open current buffer in new tab" }) --  move current buffer to new tab
