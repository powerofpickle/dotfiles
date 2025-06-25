local ok, result = pcall(require, 'settings')
if ok then
  -- TODO: use vim.tbl_extend with defaults
  return result
else
  return {
    enable_avante = false,
    enable_copilot = false,
    nvim_tree_performance_mode = false,
    force_osc52_clipboard = false,
  }
end
