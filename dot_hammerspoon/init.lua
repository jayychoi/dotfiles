_G.key = hs.keycodes.map
_G.layerTap = require("layers")

function aerospace(cmd)
	local args = {}
	for arg in cmd:gmatch("%S+") do
		table.insert(args, arg)
	end
	hs.task.new("/opt/homebrew/bin/aerospace", nil, args):start()
end

require("f17")
require("f19")
require("f20")
