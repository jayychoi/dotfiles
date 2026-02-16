bindLayer(key["f19"], {
	[key["t"]] = function()
		aerospace("workspace Terminal")
	end,
	[key["b"]] = function()
		aerospace("workspace Browser")
	end,
	[key["n"]] = function()
		aerospace("workspace Notion")
	end,
	[key["c"]] = function()
		aerospace("workspace Code")
	end,
	[key["i"]] = function()
		aerospace("workspace IntelliJ")
	end,
	[key["k"]] = function()
		aerospace("workspace KakaoTalk")
	end,

	[key["/"]] = function()
		hs.reload()
	end,

	shift = {
		[key["t"]] = function()
			aerospace("move-node-to-workspace Terminal")
		end,
		[key["b"]] = function()
			aerospace("move-node-to-workspace Browser")
		end,
		[key["n"]] = function()
			aerospace("move-node-to-workspace Notion")
		end,
		[key["c"]] = function()
			aerospace("move-node-to-workspace Code")
		end,
		[key["i"]] = function()
			aerospace("move-node-to-workspace IntelliJ")
		end,
		[key["k"]] = function()
			aerospace("move-node-to-workspace KakaoTalk")
		end,
	},
})
