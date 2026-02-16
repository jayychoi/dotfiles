local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Execute the event provider binary which provides the event "memory_update" for
-- the memory usage data, which is fired every 2.0 seconds.
sbar.exec("killall memory_load >/dev/null 2>&1; $CONFIG_DIR/helpers/event_providers/memory_load/bin/memory_load memory_update 0.5")

local memory = sbar.add("graph", "widgets.memory" , 56, {
  display = "1 2",
  position = "right",
  graph = { color = colors.magenta },
  background = {
    height = 22,
    color = { alpha = 0 },
    border_color = { alpha = 0 },
    drawing = true,
  },
  icon = { string = icons.memory },
  label = {
    -- string = "mem ??%",
    font = {
      family = settings.font.numbers,
      style = settings.font.style_map["Bold"],
      size = 12.0,
    },
    align = "right",
    padding_right = 0,
    width = 0,
    y_offset = 2
  },
  padding_right = settings.paddings + 6
})

memory:subscribe("memory_update", function(env)
  local load = tonumber(env.usage)
  memory:push({ load / 100. })

  local color = colors.magenta
  if load > 50 then
    if load < 70 then
      color = colors.yellow
    elseif load < 85 then
      color = colors.orange
    else
      color = colors.red
    end
  end

  memory:set({
    graph = { color = color },
    label = "RAM " .. string.format("%2d", tonumber(env.usage)) .. "%",
  })
end)

memory:subscribe("mouse.clicked", function(env)
  sbar.exec("open -a 'Activity Monitor'")
end)

-- Background around the memory item
sbar.add("bracket", "widgets.memory.bracket", { memory.name }, {
  background = { color = colors.bg1 }
})

-- Padding after memory item
sbar.add("item", "widgets.memory.padding", {
  position = "right",
  width = settings.group_paddings
})
