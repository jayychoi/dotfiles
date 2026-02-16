local colors = require("colors")
local icons = require("icons")
local settings = require("settings")
local app_icons = require("helpers.app_icons")

-- Aerospace workspaces grouped by monitor (from aerospace.toml)
local monitor_workspaces = {
	{ monitor = 1, workspaces = { "1", "2", "3", "4", "IntelliJ", "Browser", "KakaoTalk" } },
	{ monitor = 2, workspaces = { "5", "6", "7", "8", "Terminal", "Code", "Notion" } },
}

local spaces = {} -- ws_name -> { item, bracket }

sbar.add("event", "aerospace_workspace_change")

for _, group in ipairs(monitor_workspaces) do
	for _, ws_name in ipairs(group.workspaces) do
		local space = sbar.add("item", "space." .. ws_name, {
			display = group.monitor,
			icon = {
				font = { family = settings.font.numbers },
				string = ws_name,
				padding_left = 12,
				padding_right = 8,
				color = colors.white,
				highlight_color = colors.red,
			},
			label = {
				padding_right = 12,
				color = colors.grey,
				highlight_color = colors.red,
				font = "sketchybar-app-font:Regular:16.0",
				y_offset = -1,
			},
			padding_right = 1,
			padding_left = 1,
			background = {
				color = colors.bg1,
				border_width = 1,
				height = 26,
				border_color = colors.black,
			},
		})

		local bracket = sbar.add("bracket", { space.name }, {
			background = {
				color = colors.transparent,
				border_color = colors.bg2,
				height = 28,
				border_width = 2,
			},
		})

		sbar.add("item", "space.padding." .. ws_name, {
			display = group.monitor,
			width = settings.group_paddings,
		})

		spaces[ws_name] = { item = space, bracket = bracket }

		space:subscribe("mouse.clicked", function(env)
			sbar.exec("aerospace workspace " .. ws_name)
		end)
	end
end

local function update_workspace_icons(ws_name)
	local ws = spaces[ws_name]
	if not ws then
		return
	end
	sbar.exec("aerospace list-windows --workspace " .. ws_name .. " --format '%{app-name}'", function(result)
		local icon_line = ""
		local no_app = true
		if result then
			for app in result:gmatch("[^\r\n]+") do
				no_app = false
				local lookup = app_icons[app]
				local icon = ((lookup == nil) and app_icons["Default"] or lookup)
				icon_line = icon_line .. icon
			end
		end
		if no_app then
			icon_line = "—"
		end
		ws.item:set({ label = icon_line })
	end)
end

local function set_highlight(ws_name, selected)
	local ws = spaces[ws_name]
	if not ws then
		return
	end
	ws.item:set({
		icon = { highlight = selected },
		label = { highlight = selected },
		background = { border_color = selected and colors.black or colors.bg2 },
	})
	ws.bracket:set({
		background = { border_color = selected and colors.grey or colors.bg2 },
	})
end

local current_focused = ""

local function refresh_all()
	sbar.exec("aerospace list-workspaces --focused", function(focused)
		focused = focused:gsub("%s+", "")
		current_focused = focused
		for ws_name, _ in pairs(spaces) do
			set_highlight(ws_name, ws_name == focused)
			update_workspace_icons(ws_name)
		end
	end)
end

local space_observer = sbar.add("item", {
	drawing = false,
	updates = true,
})

space_observer:subscribe("aerospace_workspace_change", function(env)
	local focused = env.FOCUSED_WORKSPACE
	local prev = env.PREV_WORKSPACE
	if prev and prev ~= "" then
		set_highlight(prev, false)
		update_workspace_icons(prev)
	end
	if focused and focused ~= "" then
		current_focused = focused
		set_highlight(focused, true)
		update_workspace_icons(focused)
	end
end)

space_observer:subscribe("front_app_switched", function(env)
	sbar.exec("aerospace list-workspaces --focused", function(focused)
		focused = focused:gsub("%s+", "")
		if focused ~= "" then
			current_focused = focused
		end
		for ws_name, _ in pairs(spaces) do
			set_highlight(ws_name, ws_name == current_focused)
			update_workspace_icons(ws_name)
		end
	end)
end)

sbar.delay(1, refresh_all)

-- Spaces indicator (swap menus and spaces)
local spaces_indicator = sbar.add("item", {
	padding_left = -3,
	padding_right = 0,
	icon = {
		padding_left = 8,
		padding_right = 9,
		color = colors.grey,
		string = icons.switch.on,
	},
	label = {
		width = 0,
		padding_left = 0,
		padding_right = 8,
		string = "Spaces",
		color = colors.bg1,
	},
	background = {
		color = colors.with_alpha(colors.grey, 0.0),
		border_color = colors.with_alpha(colors.bg1, 0.0),
	},
})

spaces_indicator:subscribe("swap_menus_and_spaces", function(env)
	local currently_on = spaces_indicator:query().icon.value == icons.switch.on
	spaces_indicator:set({
		icon = currently_on and icons.switch.off or icons.switch.on,
	})
end)

spaces_indicator:subscribe("mouse.entered", function(env)
	sbar.animate("tanh", 30, function()
		spaces_indicator:set({
			background = {
				color = { alpha = 1.0 },
				border_color = { alpha = 1.0 },
			},
			icon = { color = colors.bg1 },
			label = { width = "dynamic" },
		})
	end)
end)

spaces_indicator:subscribe("mouse.exited", function(env)
	sbar.animate("tanh", 30, function()
		spaces_indicator:set({
			background = {
				color = { alpha = 0.0 },
				border_color = { alpha = 0.0 },
			},
			icon = { color = colors.grey },
			label = { width = 0 },
		})
	end)
end)

spaces_indicator:subscribe("mouse.clicked", function(env)
	sbar.trigger("swap_menus_and_spaces")
end)
