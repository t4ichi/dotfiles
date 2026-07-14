-- Markdown バッファ専用: go-grip で GitHub 風にブラウザ表示
-- （md間リンク遷移可・ライブ更新。編集中1枚のライブ確認は <leader>cp = markdown-preview.nvim）

local function go_grip_preview()
  local file = vim.fn.expand("%:p")
  if file == "" then
    vim.notify("go-grip: current buffer has no file", vim.log.levels.WARN)
    return
  end
  if vim.fn.executable("go-grip") == 0 then
    vim.notify("go-grip not found in PATH", vim.log.levels.ERROR)
    return
  end
  -- 既存の go-grip サーバーを落としてから起動（ポート競合＝404 を防ぐ）
  vim.system({ "pkill", "-f", "go-grip" }):wait()
  vim.system({ "go-grip", file }, { detach = true })
  vim.notify("go-grip: " .. vim.fn.fnamemodify(file, ":t"))
end

vim.api.nvim_buf_create_user_command(0, "Grip", go_grip_preview, { desc = "Markdown preview via go-grip" })
vim.api.nvim_buf_create_user_command(0, "GripStop", function()
  vim.system({ "pkill", "-f", "go-grip" }, { detach = true })
  vim.notify("go-grip stopped")
end, { desc = "Stop go-grip server" })

vim.keymap.set("n", "<leader>mg", go_grip_preview, {
  buffer = true,
  silent = true,
  desc = "Markdown preview (go-grip)",
})
