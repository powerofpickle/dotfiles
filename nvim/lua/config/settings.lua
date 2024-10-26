local ok, result = pcall(require, 'settings')
if ok then
  return result
else
  return {
    enable_avante = false,
    nvim_tree_performance_mode = false,
  }
end
