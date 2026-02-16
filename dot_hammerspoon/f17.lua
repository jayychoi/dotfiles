bindLayer(key["f17"], {
	-- utility keys
	[key["i"]] = function()
		hs.eventtap.keyStroke({}, "delete", 0)
	end,
	[key["o"]] = function()
		hs.eventtap.keyStroke({}, "forwarddelete", 0)
	end,
	[key[";"]] = function()
		hs.eventtap.keyStroke({"cmd"}, "left", 0)
	end,
	[key["'"]] = function()
		hs.eventtap.keyStroke({"cmd"}, "right", 0)
	end,

	-- window focus
	[key["h"]] = function()
		aerospace("focus --boundaries all-monitors-outer-frame --boundaries-action wrap-around-all-monitors left")
	end,
	[key["j"]] = function()
		aerospace("focus --boundaries all-monitors-outer-frame --boundaries-action wrap-around-all-monitors down")
	end,
	[key["k"]] = function()
		aerospace("focus --boundaries all-monitors-outer-frame --boundaries-action wrap-around-all-monitors up")
	end,
	[key["l"]] = function()
		aerospace("focus --boundaries all-monitors-outer-frame --boundaries-action wrap-around-all-monitors right")
	end,

	-- window resize
	[key["-"]] = function()
		aerospace("resize smart -50")
	end,
	[key["="]] = function()
		aerospace("resize smart +50")
	end,

	-- workspace
	[key["q"]] = function()
		aerospace("workspace 1")
	end,
	[key["w"]] = function()
		aerospace("workspace 2")
	end,
	[key["e"]] = function()
		aerospace("workspace 3")
	end,
	[key["r"]] = function()
		aerospace("workspace 4")
	end,
	[key["a"]] = function()
		aerospace("workspace 5")
	end,
	[key["s"]] = function()
		aerospace("workspace 6")
	end,
	[key["d"]] = function()
		aerospace("workspace 7")
	end,
	[key["f"]] = function()
		aerospace("workspace 8")
	end,

	-- shift: move / move-node-to-workspace
	shift = {
		[key["h"]] = function()
			aerospace("move --boundaries all-monitors-outer-frame left")
		end,
		[key["j"]] = function()
			aerospace("move --boundaries all-monitors-outer-frame down")
		end,
		[key["k"]] = function()
			aerospace("move --boundaries all-monitors-outer-frame up")
		end,
		[key["l"]] = function()
			aerospace("move --boundaries all-monitors-outer-frame right")
		end,

		-- shift: move-node-to-workspace
		[key["q"]] = function()
			aerospace("move-node-to-workspace 1")
		end,
		[key["w"]] = function()
			aerospace("move-node-to-workspace 2")
		end,
		[key["e"]] = function()
			aerospace("move-node-to-workspace 3")
		end,
		[key["r"]] = function()
			aerospace("move-node-to-workspace 4")
		end,
		[key["a"]] = function()
			aerospace("move-node-to-workspace 5")
		end,
		[key["s"]] = function()
			aerospace("move-node-to-workspace 6")
		end,
		[key["d"]] = function()
			aerospace("move-node-to-workspace 7")
		end,
		[key["f"]] = function()
			aerospace("move-node-to-workspace 8")
		end,
	},
})
