PLUGIN = nil
PLAYER = nil


function Initialize(Plugin)
	Plugin:SetName("Cubemix")
	Plugin:SetVersion(1)

	-- Hooks
	-- cPluginManager.AddHook(cPluginManager.HOOK_PLAYER_MOVING, OnPlayerMoving)
	cRankManager:SetDefaultRank("Admin")

	PLUGIN = Plugin

	-- Command Bindings
	-- ADD THIS IF COMMAND DOES NOT REQUIRE A PARAMETER (/explode)
	cPluginManager.BindCommand("/cubemix", "*", Cubemix, " ~ Cubemix command")
	cNetwork:Connect(CUBEMIX_SERVER_IP, CUBEMIX_SERVER_PORT, CLIENT_HANDLER)

	LOG("Cubemix Server Initialised " .. Plugin:GetName() .. " v." .. Plugin:GetVersion())
	return true
end

function Cubemix(Split, Player)
	PLAYER = Player
	
	if (#Split < 1) then
		Player:SendMessage("Usage: /cubemix [command] [args]")
		return true
	end

	ParseCommand(Split)
	return true
end

function OnPlayerMoving(Player) -- See API docs for parameters of all hooks
	return false -- Not Prohibit player movement, see docs for whether a hook is cancellable
end

function OnDisable()
	LOG(PLUGIN:GetName() .. " is shutting down...")
end
