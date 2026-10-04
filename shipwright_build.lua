-- :Shipwright (run from ~/.config/nvim) compiles the lush spec lua/lush_theme/sonokai.lua into the
-- group table of colors/sonokai.lua, between its PATCH markers.

---@diagnostic disable: undefined-global
package.loaded["lush_theme.sonokai"] = nil -- pick up edits made earlier in this session

local lushwright = require("shipwright.transform.lush")
run(
  require("lush_theme.sonokai"),
  lushwright.to_lua,
  { patchwrite, "colors/sonokai.lua", "-- PATCH_OPEN", "-- PATCH_CLOSE" }
)
