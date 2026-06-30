local Features = {}

local TweenService = game:GetService("TweenService")
local Players = game:GetService("Players")
local VirtualInputManager = game:GetService("VirtualInputManager") 
local Lighting = game:GetService("Lighting")
local HttpService = game:GetService("HttpService")
local GuiService = game:GetService("GuiService")
local PathfindingService = game:GetService("PathfindingService")
local TeleportService = game:GetService("TeleportService")
local LocalPlayer = Players.LocalPlayer
local PLACE_ID = game.PlaceId

local FILE_NAME = "PetHunter_PremiumConfig.json"
local OriginalLightingSettings = {
    Ambient = Lighting.Ambient,
    ColorShift_Top = Lighting.ColorShift_Top,
    Brightness = Lighting.Brightness
}

local Database = {
    {"Frog", "Common ($10K)"},
    {"Bunny", "Common ($20K)"},
    {"Owl", "Uncommon ($25K)"},
    {"Deer", "Rare ($50K)"},
    {"Turtle", "Rare ($70K)"},
    {"Robin", "Legendary ($75K)"},
    {"Bee", "Legendary ($1M)"},
    {"Monkey", "Mythic ($1M)"},
    {"Golden Dragonfly", "GoldenDragonfly", "Mythic ($3M)"},
    {"Unicorn", "Mythic ($4M)"},
    {"Raccoon", "Super ($5M)"},
    {"Bear", "Mythic ($5M)"},
    {"Black Dragon", "BlackDragon", "Super ($20M)"},
    {"Ice Serpent", "IceSerpent", "Super ($20M)"}
}

local RarityHexColors = {
    ["Common"] = "#FFFFFF", ["Uncommon"] = "#00FF00", ["Rare"] = "#00BFFF",
    ["Legendary"] = "#FFFF00", ["Mythic"] = "#FF0000", ["Super"] = "#FF00FF", ["Unknown"] = "#FFFFFF"
}

local ESPCache = { Pets = {}, Rarities = {}, Sizes = {} }
local function updateESPCache(cacheType, commaStr)
    ESPCache[cacheType] = {}
    if commaStr and commaStr ~= "None" and commaStr ~= "Select Options" and commaStr ~= "" then
        for token in string.gmatch(commaStr, "[^,%s]+") do
            ESPCache[cacheType][string.lower(string.gsub(token, "%s+", ""))] = true
        end
    end
end

local function rotateServerInstance(Config)
    local apiURL = string.format("https://games.roblox.com/v1/games/%s/servers/Public?sortOrder=Asc&limit=100", tostring(PLACE_ID))
    local fetchSuccess, serverData = pcall(function() return HttpService:JSONDecode(game:HttpGet(apiURL)) end)
    if fetchSuccess and serverData and serverData.data then
        local priorityServers, backupServers = {}, {}
        for _, server in pairs(serverData.data) do
            if server.id and server.id ~= game.JobId and server.playing then
                if server.playing >= 1 and server.playing <= Config.MaxServerPlayers then
                    table.insert(priorityServers, server)
                elseif server.playing < server.maxPlayers then
                    table.insert(backupServers, server)
                end
            end
        end
        math.randomseed(os.time())
        for _, server in pairs(priorityServers) do
            pcall(function() TeleportService:TeleportToPlaceInstance(PLACE_ID, server.id, LocalPlayer) end)
            task.wait(0.5)
        end
        for _, server in pairs(backupServers) do
            pcall(function() TeleportService:TeleportToPlaceInstance(PLACE_ID, server.id, LocalPlayer) end)
            task.wait(0.5)
        end
    end
    pcall(function() TeleportService:Teleport(PLACE_ID, LocalPlayer) end)
end

local function smoothFlyTo(targetCFrame, speed)
    local rootPart = LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
    if not rootPart then return end
    local distance = (rootPart.Position - targetCFrame.Position).Magnitude
    TweenService:Create(rootPart, TweenInfo.new(distance / speed, Enum.EasingStyle.Linear), {CFrame = targetCFrame}):Play()
    task.wait(distance / speed)
end

local function executeDualActionStrike(shovel)
    VirtualInputManager:SendMouseButtonEvent(20, 220, 0, true, game, 0)
    VirtualInputManager:SendMouseButtonEvent(20, 220, 0, false, game, 0)
    if shovel then
        shovel:Activate()
        for _, obj in ipairs(shovel:GetDescendants()) do
            if obj:IsA("RemoteEvent") or obj:IsA("UnreliableRemoteEvent") then obj:FireServer() end
        end
    end
end

local function isMyGarden(garden)
    if garden.Name == LocalPlayer.Name or string.find(garden.Name, tostring(LocalPlayer.UserId)) then return true end
    if garden:GetAttribute("Owner") == LocalPlayer.Name or garden:GetAttribute("OwnerID") == LocalPlayer.UserId then return true end
    return false
end

local function removeOtherGardensInstantly()
    local gardens = workspace:FindFirstChild("Gardens")
    if gardens then
        for _, garden in ipairs(gardens:GetChildren()) do
            if not isMyGarden(garden) then pcall(function() garden:Destroy() end) end
        end
    end
end

function Features.SaveConfig(Config)
    pcall(function() writefile(FILE_NAME, HttpService:JSONEncode(Config)) end)
end

-- FIXED: Added missing "in pairs(decodedTable)" generator to fix compilation failure
function Features.LoadConfig(Config, ToggleRegistry)
    if isfile and isfile(FILE_NAME) then
        local success, decodedTable = pcall(function() return HttpService:JSONDecode(readfile(FILE_NAME)) end)
        if success and type(decodedTable) == "table" then
            for key, value in pairs(decodedTable) do
                if type(value) == "table" and type(Config[key]) == "table" then
                    for subKey, subValue in pairs(value) do Config[key][subKey] = subValue end
                else Config[key] = value end
                if ToggleRegistry[key] then ToggleRegistry[key](Config[key]) end
            end
            for petName, isTargeted in pairs(Config.TargetPets) do
                if ToggleRegistry["Pet_" .. petName] then ToggleRegistry["Pet_" .. petName](isTargeted) end
            end
            updateESPCache("Pets", Config.ESPSelectedPets)
            updateESPCache("Rarities", Config.ESPSelectedRarities)
            updateESPCache("Sizes", Config.ESPSelectedSizes)
        end
    end
end

function Features.SafeUIRegionTeleport(targetName)
    local part = workspace:FindFirstChild("Teleports") and workspace.Teleports:FindFirstChild(targetName)
    if part and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
        LocalPlayer.Character.HumanoidRootPart.CFrame = part.CFrame + Vector3.new(0, 3, 0)
    end
end

function Features.ApplyAggressiveLagReduction()
    pcall(function()
        Lighting.GlobalShadows = false
        Lighting.FogEnd = 9e9
    end)
    for _, instance in ipairs(workspace:GetDescendants()) do
        pcall(function()
            if instance:IsA("ParticleEmitter") or instance:IsA("Smoke") or instance:IsA("Decal") then instance:Destroy()
            elseif instance:IsA("BasePart") then instance.Material = Enum.Material.SmoothPlastic end
        end)
    end
end

function Features.UpdateCacheAndSave(cType, value, Config)
    updateESPCache(cType, value)
    Features.SaveConfig(Config)
end

function Features.StartAutomationLoops(Config, ToggleRegistry)
    -- Initial environment setups
    pcall(function() Features.LoadConfig(Config, ToggleRegistry) end)
    
    -- Teleport fallback failure system hook
    TeleportService.TeleportInitFailed:Connect(function(player)
        if player == LocalPlayer then task.wait(1.5) pcall(function() TeleportService:Teleport(PLACE_ID, LocalPlayer) end) end
    end)

    -- Dynamic Environment Thread
    task.spawn(function()
        while task.wait(0.5) do
            if Config.FullBright then
                Lighting.Ambient = Color3.fromRGB(255, 255, 255)
                Lighting.Brightness = 2
            end
            if LocalPlayer then LocalPlayer.CameraMaxZoomDistance = Config.InfiniteZoom and 9e9 or 400 end
        end
    end)

    -- Character Fling & Anti-Knockback Thread
    task.spawn(function()
        while task.wait(0.1) do
            if Config.AntiFling then
                for _, player in ipairs(Players:GetPlayers()) do
                    if player ~= LocalPlayer and player.Character then
                        for _, part in ipairs(player.Character:GetChildren()) do
                            if part:IsA("BasePart") then part.CanCollide = false part.Velocity = Vector3.zero end
                        end
                    end
                end
            end
        end
    end)

    -- Proximity Prompt Optimization Thread
    task.spawn(function()
        while task.wait(0.5) do
            if Config.InstantPrompt then
                for _, prompt in ipairs(workspace:GetDescendants()) do
                    if prompt:IsA("ProximityPrompt") then prompt.HoldDuration = 0 end
                end
            end
            GuiService:SetGameplayPausedNotificationEnabled(not Config.BypassGameplayPaused)
        end
    end)

    -- Shop Thread Integration Matrix
    -- NOTE: Ensure 'v3' framework environment variable is loaded/globally defined by your executor for this to complete orders!
    task.spawn(function()
        local MasterSeedList = {"Pineapple", "Mushroom", "Green Bean", "Banana", "Grape", "Coconut", "Dragon Fruit", "Acorn", "Cherry"}
        while task.wait(1) do
            if Config.AutoBuyAllSeeds then
                for _, seed in ipairs(MasterSeedList) do pcall(function() v3.SeedShop.PurchaseSeed(seed) end) task.wait(0.1) end
            elseif Config.AutoBuySeeds and Config.ShopSelectedSeeds ~= "Select Options" and Config.ShopSelectedSeeds ~= "" then
                for token in string.gmatch(Config.ShopSelectedSeeds, "([^,]+)") do
                    local cleanSeed = string.match(token, "^%s*(.-)%s*$")
                    if cleanSeed and cleanSeed ~= "" and cleanSeed ~= "None" then
                        pcall(function() v3.SeedShop.PurchaseSeed(cleanSeed) end) task.wait(0.1)
                    end
                end
            end
        end
    end)

    -- Ultimate Studio UI Extension Integration
    task.spawn(function()
        -- FIXED: Removed "pink" text syntax error inside Color3 parameters
        local GEARS_COLOR, PROPS_COLOR = Color3.fromRGB(0, 162, 255), Color3.fromRGB(255, 138, 21)
        while true do
            task.wait(2)
            pcall(function()
                local buttonContainer = LocalPlayer.PlayerGui.TeleportButtons.TeleportButtons
                local templateButton = buttonContainer.SeedsButton
                local teleports = workspace.Teleports
                
                if buttonContainer and templateButton then
                    if teleports:FindFirstChild("Gears") and not buttonContainer:FindFirstChild("GearsButton") then
                        local b = templateButton:Clone() b.Name = "GearsButton" b.Parent = buttonContainer
                    end
                end
            end)
        end
    end)

    -- Master Hunting Core Framework
    task.spawn(function()
        while task.wait(0.1) do
            if Config.AutoRemoveOtherGardens then removeOtherGardensInstantly() end
            if Config.PetHuntEnabled then
                local wildFolder = workspace:FindFirstChild("Map") and workspace.Map:FindFirstChild("WildPetSpawns")
                local character = LocalPlayer.Character
                local rootPart = character and character:FindFirstChild("HumanoidRootPart")
                
                if rootPart and wildFolder then
                    local targetPet = nil
                    for _, petModel in ipairs(wildFolder:GetChildren()) do
                        local attr = petModel:GetAttribute("PetName")
                        if attr and Config.TargetPets[attr] and petModel:FindFirstChild("RootPart") then
                            targetPet = petModel break
                        end
                    end
                    
                    if targetPet then
                        local pRoot = targetPet.RootPart
                        local shovel = character:FindFirstChild("Shovel") or LocalPlayer.Backpack:FindFirstChild("Shovel")
                        if shovel and shovel.Parent == LocalPlayer.Backpack then character.Humanoid:EquipTool(shovel) end
                        
                        while Config.PetHuntEnabled and targetPet and targetPet:IsDescendantOf(wildFolder) and pRoot do
                            if Config.TeleportMode == "Teleport" then rootPart.CFrame = pRoot.CFrame * CFrame.new(0, Config.FlyHeight, 0)
                            elseif Config.TeleportMode == "Tween" then smoothFlyTo(pRoot.CFrame * CFrame.new(0, Config.FlyHeight, 0), Config.TweenSpeed) end
                            if shovel then executeDualActionStrike(shovel) end
                            task.wait()
                        end
                        if Config.ServerHopEnabled then rotateServerInstance(Config) end
                    elseif Config.ServerHopEnabled then rotateServerInstance(Config) end
                end
            end
        end
    end)
end

return Features
