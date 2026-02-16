local eventtap = hs.eventtap
local event = eventtap.event
local types = event.types

local activeLayer = nil
local layers = {}

local function modKey(flags)
	local mods = {}
	if flags.alt then table.insert(mods, "alt") end
	if flags.cmd then table.insert(mods, "cmd") end
	if flags.ctrl then table.insert(mods, "ctrl") end
	if flags.shift then table.insert(mods, "shift") end
	table.sort(mods)
	return table.concat(mods, "+")
end

function bindLayer(triggerKey, bindings)
	layers[triggerKey] = bindings
end

local layerTap = eventtap.new({ types.keyDown, types.keyUp }, function(e)
	local kc = e:getKeyCode()
	local down = (e:getType() == types.keyDown)

	if layers[kc] then
		if down then
			activeLayer = kc
		elseif activeLayer == kc then
			activeLayer = nil
		end
		return true
	end

	if activeLayer and down then
		local layerBindings = layers[activeLayer]
		local mk = modKey(e:getFlags())
		local handler

		if mk ~= "" and layerBindings[mk] then
			handler = layerBindings[mk][kc]
		elseif mk == "" then
			handler = layerBindings[kc]
		end

		if handler then
			handler()
			return true
		end
	end

	return false
end)

layerTap:start()

return layerTap
