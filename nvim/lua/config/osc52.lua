local M = {}

M.osc52_plugin_needed = function()
  -- native since 0.10
  local nvim_version = vim.version()
  return nvim_version.major == 0 and nvim_version.minor < 10
end

M.init = function()
  local function copy(lines, _)
    require('osc52').copy(table.concat(lines, '\n'))
  end

  local function paste()
    return {vim.fn.split(vim.fn.getreg(''), '\n'), vim.fn.getregtype('')}
  end

  vim.g.clipboard = {
    name = 'osc52',
    copy = {['+'] = copy, ['*'] = copy},
    paste = {['+'] = paste, ['*'] = paste},
  }
end

return M
