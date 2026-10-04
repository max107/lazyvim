-- :Shipwright themes/shipwright_build.lua (run from ~/.config/nvim) compiles the lush spec
-- lua/lush_theme/sonokai.lua into the group table of colors/sonokai.lua, between its PATCH markers.

---@diagnostic disable: undefined-global
package.loaded["lush_theme.sonokai"] = nil -- pick up edits made earlier in this session

-- paths are relative to this file, not to the working directory
local dir = vim.fn.fnamemodify(debug.getinfo(1, "S").source:sub(2), ":h")
local lushwright = require("shipwright.transform.lush")
run(
  require("lush_theme.sonokai"),
  lushwright.to_lua,
  { patchwrite, dir .. "/colors/sonokai.lua", "-- PATCH_OPEN", "-- PATCH_CLOSE" }
)
