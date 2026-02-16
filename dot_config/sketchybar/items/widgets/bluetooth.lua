local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local DEVICE_MAC = "f4-2b-8c-e6-5f-89"

local bluetooth = sbar.add("item", "widgets.bluetooth", {
  position = "right",
  icon = {
    string = icons.bluetooth,
    color = colors.white,
    font = {
      family = settings.font.text,
      style = settings.font.style_map["Regular"],
      size = 16.0,
    },
  },
  label = { drawing = false },
  update_freq = 2,
})

local function update_status()
  sbar.exec("/opt/homebrew/bin/blueutil --is-connected " .. DEVICE_MAC, function(result)
    local connected = result:match("1")
    local color = connected and colors.blue or colors.white
    bluetooth:set({ icon = { color = color } })
  end)
end

bluetooth:subscribe("mouse.clicked", function()
  sbar.exec("/opt/homebrew/bin/blueutil --is-connected " .. DEVICE_MAC, function(result)
    local connected = result:match("1")
    local new_color = connected and colors.white or colors.blue
    bluetooth:set({ icon = { color = new_color } })
    if connected then
      sbar.exec("/opt/homebrew/bin/blueutil --disconnect " .. DEVICE_MAC)
    else
      sbar.exec("/opt/homebrew/bin/blueutil --connect " .. DEVICE_MAC)
    end
  end)
end)

bluetooth:subscribe({"routine", "forced", "system_woke"}, update_status)

sbar.add("bracket", "widgets.bluetooth.bracket", { bluetooth.name }, {
  background = { color = colors.bg1 },
})

sbar.add("item", "widgets.bluetooth.padding", {
  position = "right",
  width = settings.group_paddings,
})
