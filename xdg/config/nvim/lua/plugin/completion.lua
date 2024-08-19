local in_vscode = require("util").in_vscode
if in_vscode() then
  return
end
local add, later = MiniDeps.add, MiniDeps.later
later(function()
  require("mini.completion").setup()
end)
