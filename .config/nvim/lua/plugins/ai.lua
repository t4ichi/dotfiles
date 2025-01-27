return {
	{
		"github/copilot.vim",
		event = {
			"CmdlineEnter",
			"InsertEnter",
		},
		keys = {
			{ "<C-j>", "<Plug>(copilot-next)", desc = "Copilot Next Suggestion", mode = { "i" } },
			{ "<C-k>", "<Plug>(copilot-previous)", desc = "Copilot Previous Suggestion", mode = { "i" } },
			{ "<C-o>", "<Plug>(copilot-dismiss)", desc = "Copilot Dismiss Suggestion", mode = { "i" } },
			{ "<C-l>", "<Plug>(copilot-accept-word)", desc = "Copilot Accept Word", mode = { "i" } },
			{ "<C-s>", "<Plug>(copilot-suggest)", desc = "Copilot Suggest", mode = { "i" } },
			{ "<C-a>", "<Plug>(copilot-accept-line)", desc = "Copilot Accept Line", mode = { "i" } },
		},
		config = function()
			if os.getenv("http_proxy") ~= nil then
				local proxy_url = os.getenv("http_proxy")
				vim.g.copilot_proxy = proxy_url
			end
		end,
	},
	{
		"CopilotC-Nvim/CopilotChat.nvim",
		event = "VeryLazy",
		dependencies = {
			{ "github/copilot.vim" },
			{ "nvim-lua/plenary.nvim", branch = "master" },
			{ "nvim-telescope/telescope.nvim" },
		},
		build = "make tiktoken",
		opts = {
			show_help = true,
			question_header = "  User ",
			answer_header = "  Copilot ",
			prompts = {
				Explain = {
					prompt = "> /COPILOT_EXPLAIN\n\n選択されたコードの機能と動作を詳細に説明してください。以下の点に触れてください：\n"
						.. "- コードの主な目的\n"
						.. "- 使用されているアルゴリズムや手法\n"
						.. "- 重要な変数や関数の役割\n"
						.. "段落形式で、技術的な正確性を保ちながら分かりやすく説明してください。",
				},
				Review = {
					prompt = "> /COPILOT_REVIEW\n\n以下の観点からコードレビューを行ってください：\n"
						.. "- コードの品質（可読性、保守性）\n"
						.. "- 命名規則の改善\n"
						.. "- パフォーマンスの考慮点\n"
						.. "- セキュリティリスク\n"
						.. "- ベストプラクティスの適用\n"
						.. "改善点がある場合は、具体的な提案を含めてください。",
				},
				Fix = {
					prompt = "> /COPILOT_GENERATE\n\nこのコードの問題点を修正してください。\n"
						.. "修正後のコードを提示し、以下も含めてください：\n"
						.. "- 特定された問題の説明\n"
						.. "- 修正内容とその理由\n"
						.. "- 修正による影響範囲",
				},
				Optimize = {
					prompt = "> /COPILOT_GENERATE\n\n選択されたコードのパフォーマンスと可読性を改善してください。\n"
						.. "以下の点を考慮してください：\n"
						.. "- 実行速度の最適化\n"
						.. "- メモリ使用量の効率化\n"
						.. "- コードの構造化と整理\n"
						.. "最適化前後のコードを比較し、改善点を説明してください。",
				},
				Docs = {
					prompt = "> /COPILOT_GENERATE\n\n選択されたコードにドキュメントコメントを追加してください。\n"
						.. "以下の要素を含めてください：\n"
						.. "- 関数/クラスの目的と動作\n"
						.. "- パラメータの説明\n"
						.. "- 戻り値の説明\n"
						.. "- 使用例\n"
						.. "- 注意事項（該当する場合）",
				},
				Tests = {
					prompt = "> /COPILOT_GENERATE\n\n選択されたコードのテストコードを生成してください。\n"
						.. "以下のテストケースを含めてください：\n"
						.. "- 正常系のテスト\n"
						.. "- エッジケース\n"
						.. "- エラー処理のテスト\n"
						.. "テストフレームワークのベストプラクティスに従い、テストの目的も説明してください。",
				},
				Commit = {
					prompt = "> #git:staged\n\n"
						.. "以下の形式で日本語のコミットメッセージを生成してください：\n"
						.. "形式: <Prefix>: <理由>、<変更内容>\n\n"
						.. "要件：\n"
						.. "1. Prefix（必須）は以下から選択：\n"
						.. "   - feat: 新しい機能\n"
						.. "   - fix: バグの修正\n"
						.. "   - docs: ドキュメントのみの変更\n"
						.. "   - style: 空白、フォーマット、セミコロン追加など\n"
						.. "   - refactor: 仕様に影響がないコード改善(リファクタ)\n"
						.. "   - perf: パフォーマンス向上関連\n"
						.. "   - test: テスト関連\n"
						.. "   - chore: ビルド、補助ツール、ライブラリ関連\n\n"
						.. "2. メッセージの構成：\n"
						.. "   - 「〇〇なため、△△を追加/修正/変更」の形式\n"
						.. "   - 理由（なぜその変更が必要か）を必ず含める\n"
						.. "   - 変更内容は具体的に記述\n\n"
						.. "3. 記述のポイント：\n"
						.. "   - コードレビューがしやすいように具体的に\n"
						.. "   - 変更の意図が明確に伝わるように\n"
						.. "   - 将来のメンテナンスを考慮した説明を含める\n\n"
						.. "メッセージは gitcommit コードブロックで囲んでください。\n",
				},
			},
			mappings = {
				reset = {
					normal = "<C-x>",
					insert = "<C-x>",
				},
			},
		},
		keys = {
			{
				"<leader>cc",
				"<cmd>CopilotChatToggle<CR>",
				desc = "Toggle (CopilotChat)",
				mode = { "n", "v" },
			},
			{
				"<leader>cx",
				"<cmd>CopilotChatReset<CR>",
				desc = "Clear (CopilotChat)",
				mode = { "n", "v" },
			},
			{
				"<leader>cq",
				function()
					local input = vim.fn.input("Quick Chat: ")
					if input ~= "" then
						require("CopilotChat").ask(input)
					end
				end,
				desc = "Quick Chat (CopilotChat)",
				mode = { "n", "v" },
			},
			{
				"<leader>cp",
				function()
					local actions = require("CopilotChat.actions")
					require("CopilotChat.integrations.telescope").pick(actions.prompt_actions())
				end,
				desc = "CopilotChat - Prompt actions",
			},
			{
				"<leader>cm",
				"<cmd>CopilotChatModels<CR>",
				desc = "CopilotChat - Models",
			},
			{
				"<leader>cs",
				"<cmd>CopilotChatStop<CR>",
				desc = "CopilotChat - Stop",
			},
			{
				"<leader>cw",
				function()
					local current_time = os.date("%Y-%m-%d_%H-%M-%S")
					vim.cmd("CopilotChatSave " .. current_time)
				end,
				desc = "CopilotChat - Save",
			},
			{
				"<leader>cl",
				function()
					local session_dir = vim.fn.stdpath("data") .. "/copilotchat_history"
					local sessions = vim.fn.globpath(session_dir, "*", false, true)
					table.sort(sessions, function(a, b)
						return vim.fn.getftime(a) < vim.fn.getftime(b)
					end)
					require("telescope.builtin").find_files({
						prompt_title = "Load CopilotChat Session",
						cwd = session_dir,
						find_command = { "ls", "-t" },
						attach_mappings = function(_, map)
							map("i", "<CR>", function(prompt_bufnr)
								local selection = require("telescope.actions.state").get_selected_entry()
								local filename = selection.value:gsub("%.json$", "")

								vim.cmd("CopilotChatLoad " .. filename)
								require("telescope.actions").close(prompt_bufnr)
							end)
							return true
						end,
					})
				end,
				desc = "CopilotChat - Load",
			},
		},
	},
}
