local ls = require "luasnip"

--{{{ Short aliases
local snip = ls.snippet
local node = ls.snippet_node
local text = ls.text_node
local insert = ls.insert_node
local func = ls.function_node
local choice = ls.choice_node
local dynamicn = ls.dynamic_node
--}}}

--{{{ Obsidian
local global_task_filter = "#task"
if global_task_filter ~= nil and global_task_filter ~= "" then
  global_task_filter = global_task_filter .. " "
end
local function is_on_task_line (line_to_cursor)
  return string.match(line_to_cursor, "^%s*- %[.] " .. global_task_filter .. ".*%s?")
end
ls.add_snippets("markdown", {
  snip({
    trig = ":t",
    name = "[t]ask",
    dscr = "Obsidian Task: insert new [t]ask",
  }, {
    func( function() return "[ ] " .. global_task_filter end ),
  }, {
    condition = function (line_to_cursor)
      return string.match(line_to_cursor, "^%s*- :t")
    end,
  }),
  snip({
    trig = ":dt",
    name = "[d]ate [t]oday",
    dscr = "Obsidian Task: today's date in the form of YYYY-MM-DD",
  }, {
    func(function()
      return {os.date('%Y-%m-%d')}
    end),
  }, {
    condition = is_on_task_line,
  }),
  snip({
    trig = ":dp",
    name = "[d]ate [p]icker",
    dscr = "Obsidian Task: picked date in the form of YYYY-MM-DD",
  }, {
    func(function()
      -- TODO: Make a date picker TUI
      return {os.date('%Y-%m-%d')}
    end),
  }, {
    condition = is_on_task_line,
  }),
  snip({
    trig = ":pl",
    name = "[p]riority [l]ow",
    dscr = "Obsidian Task: [p]riority [l]ow",
  }, {
    func( function() return "🔽 " end ),
  }, {
    condition = is_on_task_line,
  }),
  snip({
    trig = ":pm",
    name = "[p]riority [m]edium",
    dscr = "Obsidian Task: [p]riority [m]edium",
  }, {
    func( function() return "🔼 " end ),
  }, {
    condition = is_on_task_line,
  }),
  snip({
    trig = ":ph",
    name = "[p]riority [h]igh",
    dscr = "Obsidian Task: [p]riority [h]igh",
  }, {
    func( function() return "⏫ " end ),
  }, {
    condition = is_on_task_line,
  }),
  snip({
    trig = ":D",
    name = "[D]one",
    dscr = "Obsidian Task: [D]one",
  }, {
    func( function() return "✅ " .. os.date "%Y-%m-%d" end ),
  }, {
    condition = is_on_task_line,
  }),
  snip({
    trig = ":s",
    name = "[s]tart",
    dscr = "Obsidian Task: [s]tart",
  }, {
    func( function() return "🛫 " .. os.date "%Y-%m-%d" end ),
  }, {
    condition = is_on_task_line,
  }),
  snip({
    trig = ":r",
    name = "[r]ecurs",
    dscr = "Obsidian Task: [r]ecurs",
  }, {
    func( function()
      -- TODO: Some logic to match Obsidian Tasks recurs magic strings
      return "🔁 "
    end ),
  }, {
    condition = is_on_task_line,
  }),
  snip({
    trig = ":d",
    name = "[d]ue date",
    dscr = "Obsidian Task: [d]ue date",
  }, {
    -- TODO: Date picker TUI
    func( function() return "📅 " end ),
  }, {
    condition = is_on_task_line,
  }),
  snip({
    trig = ":S",
    name = "[S]cheduled",
    dscr = "Obsidian Task: [S]cheduled",
  }, {
    -- TODO: Date picker TUI
    func( function() return "⏳ " end ),
  }, {
    condition = is_on_task_line,
  }),
})
--}}}
