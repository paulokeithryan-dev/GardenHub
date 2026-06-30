-- =====================================================================
-- THE LIVE CLOUD ORCHESTRATOR
-- =====================================================================
local Config = loadstring(game:HttpGet("https://raw.githubusercontent.com/paulokeithryan-dev/GardenHub/main/config.lua"))()
local UILibrary = loadstring(game:HttpGet("https://raw.githubusercontent.com/paulokeithryan-dev/GardenHub/main/ui_library.lua"))()
local Features = loadstring(game:HttpGet("https://raw.githubusercontent.com/paulokeithryan-dev/GardenHub/main/features.lua"))()

-- Initialize the window canvas
local Window = UILibrary.CreateWindow("Grow a Garden 2")

-- Create layout tabs 
local AutomationTab = Window:CreateTab("Automation", "🤖")
local ShopTab = Window:CreateTab("Shop Manager", "🛒")

-- Populate Automation Layout Controls
AutomationTab:AddSection("Background Automation Settings")
AutomationTab:AddToggle("Enable Auto Farming", Config.PetHuntEnabled, function(state)
    Config.PetHuntEnabled = state
end, "PetHuntEnabled")

-- Populate Shop Controls
ShopTab:AddSection("Seed Purchasing Automation")
ShopTab:AddToggle("Buy All Seeds", Config.AutoBuyAllSeeds, function(state)
    Config.AutoBuyAllSeeds = state
end, "AutoBuyAllSeeds")

ShopTab:AddMultiDropdown("Target Crops", Config.ShopSelectedSeeds, {"Pineapple", "Banana", "Grape"}, function(selections)
    Config.ShopSelectedSeeds = selections
end, "ShopSelectedSeeds")

-- Kickstart your loops 
Features.StartAutomationLoops(Config)
