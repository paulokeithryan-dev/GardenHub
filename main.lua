-- =====================================================================
-- MASTER CLOUD ORCHESTRATOR 
-- =====================================================================
local Config = loadstring(game:HttpGet("https://raw.githubusercontent.com/paulokeithryan-dev/GardenHub/main/config.lua"))()
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/paulokeithryan-dev/GardenHub/main/ui_library.lua"))()
local Features = loadstring(game:HttpGet("https://raw.githubusercontent.com/paulokeithryan-dev/GardenHub/main/features.lua"))()

-- Initialize window dashboard canvas 
local TabEngine = UILibrary.CreateWindow("GardenHub Premium")
local ToggleRegistry = UILibrary.GetRegistry()

-- ---------------------------------------------------------------------
-- TAB 1: PET HUNTER MODULES
-- ---------------------------------------------------------------------
local HuntTab = TabEngine:CreateTab("Pet Hunter", "🐾")
HuntTab:AddSection("Wild Pet Automation")

HuntTab:AddToggle("⭐ ENABLE AUTO PET HUNT", Config.PetHuntEnabled, function(bool)
    Config.PetHuntEnabled = bool Features.SaveConfig(Config)
end, "PetHuntEnabled")

HuntTab:AddToggle("🛡️ PET PURCHASE PROTECTION", Config.ProtectionEnabled, function(bool)
    Config.ProtectionEnabled = bool Features.SaveConfig(Config)
end, "ProtectionEnabled")

local PetList = {"Frog", "Bunny", "Owl", "Deer", "Turtle", "Robin", "Bee", "Monkey", "Unicorn", "Raccoon", "Bear", "IceSerpent"}
for _, name in ipairs(PetList) do
    HuntTab:AddToggle("Target: " .. name, Config.TargetPets[name] or false, function(bool)
        Config.TargetPets[name] = bool Features.SaveConfig(Config)
    end, "Pet_" .. name)
end

HuntTab:AddSection("Server Rotation Matrix")
HuntTab:AddToggle("🔄 Enable Automated Server Hopping", Config.ServerHopEnabled, function(bool)
    Config.ServerHopEnabled = bool Features.SaveConfig(Config)
end, "ServerHopEnabled")

-- ---------------------------------------------------------------------
-- TAB 2: MISCELLANEOUS ENVIRONMENT CONTROLS
-- ---------------------------------------------------------------------
local MiscTab = TabEngine:CreateTab("Misc", "⚙️")
MiscTab:AddSection("Map Controls")

MiscTab:AddAction("Remove Other Gardens", "Clean", function()
    Features.RemoveOtherGardensInstantly()
end)

MiscTab:AddToggle("Auto Remove Gardens (Loop)", Config.AutoRemoveOtherGardens, function(bool)
    Config.AutoRemoveOtherGardens = bool Features.SaveConfig(Config)
end, "AutoRemoveOtherGardens")

MiscTab:AddAction("Reduce Lag (Clear Assets)", "Optimize", function()
    Features.ApplyAggressiveLagReduction()
end)

MiscTab:AddSection("Visual Enhancements")
MiscTab:AddToggle("Full Bright", Config.FullBright, function(bool)
    Config.FullBright = bool Features.SaveConfig(Config)
end, "FullBright")

MiscTab:AddToggle("Infinite Zoom Out", Config.InfiniteZoom, function(bool)
    Config.InfiniteZoom = bool Features.SaveConfig(Config)
end, "InfiniteZoom")

-- ---------------------------------------------------------------------
-- TAB 3: CORE SETTINGS parameters
-- ---------------------------------------------------------------------
local SettingsTab = TabEngine:CreateTab("Settings", "🛠️")
SettingsTab:AddSection("Movement Parameters")

SettingsTab:AddSingleDropdown("Teleport Manager Mode", Config.TeleportMode, {"Tween", "Walk", "Teleport"}, function(mode)
    Config.TeleportMode = mode Features.SaveConfig(Config)
end, "TeleportMode")

SettingsTab:AddSection("Quick World Navigation Teleports")
SettingsTab:AddAction("Teleport to Gears Vendor", "Teleport", function() Features.SafeUIRegionTeleport("Gears") end)
SettingsTab:AddAction("Teleport to Props Vendor", "Teleport", function() Features.SafeUIRegionTeleport("Props") end)

-- ---------------------------------------------------------------------
-- TAB 4: JSON CONFIG MANAGEMENT ARCHIVE
-- ---------------------------------------------------------------------
local ConfigTab = TabEngine:CreateTab("Configs", "💾")
ConfigTab:AddSection("Storage Controls")
ConfigTab:AddAction("Save Current System Settings", "Save Config", function() Features.SaveConfig(Config) end)
ConfigTab:AddAction("Load Configuration History", "Load Config", function() Features.LoadConfig(Config, ToggleRegistry) end)

-- ---------------------------------------------------------------------
-- TAB 5: AUTOMATED MERCHANDISE SHOP MANAGER
-- ---------------------------------------------------------------------
local ShopTab = TabEngine:CreateTab("Shop", "🛒")
ShopTab:AddSection("Restock Timers")
ShopTab:AddSection("Shop Seed Procurement")

local SeedOptions = {"Pineapple", "Mushroom", "Green Bean", "Banana", "Grape", "Coconut", "Dragon Fruit", "Acorn", "Cherry"}
ShopTab:AddMultiDropdown("Select Seeds to Buy", Config.ShopSelectedSeeds, SeedOptions, function(val)
    Config.ShopSelectedSeeds = val Features.SaveConfig(Config)
end, "ShopSelectedSeeds")

ShopTab:AddToggle("Auto Buy Selected Seeds", Config.AutoBuySeeds, function(bool)
    Config.AutoBuySeeds = bool Features.SaveConfig(Config)
end, "AutoBuySeeds")

ShopTab:AddToggle("Auto Buy All Seeds", Config.AutoBuyAllSeeds, function(bool)
    Config.AutoBuyAllSeeds = bool Features.SaveConfig(Config)
end, "AutoBuyAllSeeds")

-- Fire and start execution environment processes
Features.StartAutomationLoops(Config, ToggleRegistry)
