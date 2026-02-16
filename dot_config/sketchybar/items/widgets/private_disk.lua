local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Execute the event provider binary which provides the event "disk_update" for
-- the disk usage data, which is fired every 60 seconds.
sbar.exec("killall disk_load >/dev/null; $CONFIG_DIR/helpers/event_providers/disk_load/bin/disk_load / disk_update 60.0")

local disk = sbar.add("item", "widgets.disk" , {
  position = "right",
  background = {
    height = 22,
    color = { alpha = 0 },
    border_color = { alpha = 0 },
    drawing = true,
  },
  icon = { string = icons.disk },
  label = {
    string = "disk ??%",
    font = {
      family = settings.font.numbers,
      style = settings.font.style_map["Bold"],
      size = 12.0,
    },
    padding_left = 6,
    padding_right = 0
  },
  padding_right = settings.paddings + 6
})

disk:subscribe("disk_update", function(env)
  local usage = tonumber(env.usage)

  local color = colors.green
  if usage > 50 then
    if usage < 70 then
      color = colors.yellow
    elseif usage < 85 then
      color = colors.orange
    else
      color = colors.red
    end
  end

  disk:set({
    icon = { color = color },
    label = "disk " .. env.usage .. "%",
  })
end)

disk:subscribe("mouse.clicked", function(env)
  sbar.exec("open /")
end)

-- Background around the disk item
sbar.add("bracket", "widgets.disk.bracket", { disk.name }, {
  background = { color = colors.bg1 }
})

-- Padding after disk item
sbar.add("item", "widgets.disk.padding", {
  position = "right",
  width = settings.group_paddings
})
