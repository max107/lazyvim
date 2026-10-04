-- tokyonight with a dark brown background and burgundy accents; the "burgundy" style is registered in
-- the tokyonight spec in themes/plugins.lua (requiring tokyonight here makes lazy.nvim load and configure it).
-- Not transparent: the brown background is the point of this variant.
require("tokyonight").load({ style = "burgundy", transparent = false })
