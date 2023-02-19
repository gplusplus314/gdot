-- Load plugins so they can be configured:
require "g.plugins"

-- Basic settings:
require "g.basic_settings"
require "g.config_hacks"

-- Load custom keybinds
require "g.keybinds"

-- Load LSP config
require "g.lsp"

-- Load snippets
require "g.snippets"

-- Overrides for embedded NeoVim editors:
require "g.firenvim"
