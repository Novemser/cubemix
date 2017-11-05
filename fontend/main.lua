PLUGIN = nil
PLAYER = nil
x0 = 0
z0 = 0

----------------------------------------
-- GLOBALS
----------------------------------------

-- queue containing the updates that need to be applied to the minecraft world
UpdateQueue = nil
-- array of Bucket objects
Buckets = {}
Objects = {}
MAX_BLOCK_UPDATE_PER_TICK = 50

--
SignsToUpdate = {}
-- as a lua array cannot contain nil values, we store references to this object
-- in the "Buckets" array to indicate that there is no Bucket at an index
EmptyBucketspace = {}

-- Tick is triggered by cPluginManager.HOOK_TICK
function Tick(TimeDelta)
  UpdateQueue:update(MAX_BLOCK_UPDATE_PER_TICK)
end

function Initialize(Plugin)
	Plugin:SetName("Cubemix")
	Plugin:SetVersion(1)
	UpdateQueue = NewUpdateQueue()

	-- Hooks
  -- cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_JOINED, PlayerJoined);
  -- cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_USING_BLOCK, PlayerUsingBlock);
  -- cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_FOOD_LEVEL_CHANGE, OnPlayerFoodLevelChange);
  -- cPluginManager:AddHook(cPluginManager.HOOK_TAKE_DAMAGE, OnTakeDamage);
  -- cPluginManager:AddHook(cPluginManager.HOOK_WEATHER_CHANGING, OnWeatherChanging);
  -- cPluginManager:AddHook(cPluginManager.HOOK_SERVER_PING, OnServerPing);
--    cPluginManager:AddHook(cPluginManager.HOOK_TICK, Tick);
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_JOINED, MyOnPlayerJoined);
	cPluginManager:AddHook(cPluginManager.HOOK_PLAYER_BROKEN_BLOCK, MyOnPlayerBrokenBlock);
--	cPluginManager.AddHook(cPluginManager.HOOK_PLAYER_MOVING, OnPlayerMoving)
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

--function OnPlayerMoving(Player)
--	x0=Player:GetPosX()
--	z0=Player:GetPosZ()
--	return false
--end

function MyOnPlayerJoined(Player)
	Player:SetCanFly(true)
	x0=Player:GetPosX()
	z0=Player:GetPosZ()
--	SendRequest("listBucket",nil,nil)
end

function MyOnPlayerBrokenBlock(Player, BlockX, BlockY, BlockZ, BlockFace, BlockType, BlockMeta) -- See API docs for parameters of all hooks
	LOG("Block Broken")
	local world=Player:GetWorld()
	px=BlockX
	py=BlockY
	pz=BlockZ
	world:SetWeather(wSunny)
	world:SetTimeOfDay(3000)
	local bucket=NewBucket()
	bucket:init()
	bucket:setInfos("8","2",8)
	bucket:display(World)
	bucket:addGround()
end
