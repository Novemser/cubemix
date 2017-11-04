PLUGIN = nil
PLAYER = nil


function Initialize(Plugin)
	Plugin:SetName("NovaNewPlugin")
	Plugin:SetVersion(1)

	-- Hooks
	cPluginManager.AddHook(cPluginManager.HOOK_PLAYER_MOVING, OnPlayerMoving)
	cRankManager:SetDefaultRank("Admin")

	PLUGIN = Plugin -- NOTE: only needed if you want OnDisable() to use GetName() or something like that

	-- Command Bindings
	-- ADD THIS IF COMMAND DOES NOT REQUIRE A PARAMETER (/explode)
	cPluginManager.BindCommand("/nova", "*", NovaMove, " ~ Simple Test")
	cNetwork:Connect("10.1.1.41", 4700, CLIENT_HANDLER)

	LOG("NOVA...Initialised " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())
	return true
end

function NovaMove(Split, Player)
	PLAYER = Player
	CONNECTION:Send("GET / HTTP/1.0\r\nHost: www.baidu.com\r\n\r\n")
	return true
end

function OnPlayerMoving(Player) -- See API docs for parameters of all hooks
	return false -- Not Prohibit player movement, see docs for whether a hook is cancellable
end

function OnDisable()
	LOG(PLUGIN:GetName() .. " is shutting down...")
end
