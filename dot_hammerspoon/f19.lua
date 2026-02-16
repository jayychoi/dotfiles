bindLayer(key["f19"], {
	-- Focus to named space
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

	-- Move to named space
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

	-- Open music player
	[key["m"]] = function()
		hs.execute([[
			/Applications/Ghostty.app/Contents/MacOS/ghostty -e /usr/bin/env zsh -l -c '/opt/homebrew/bin/tmux -L Music new-session -A -s Music musikcube'
		]])
	end,
})
