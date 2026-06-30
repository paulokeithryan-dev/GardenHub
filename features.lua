local Features = {}
local MasterSeedList = {"Pineapple", "Banana", "Grape"} -- Add your game's full seed list here

function Features.StartAutomationLoops(Config)
    -- Safe isolated background loop thread
    task.spawn(function()
        while task.wait(1.0) do
            -- Ensure global v3 or your game's store system is active here
            if _G.v3 and _G.v3.SeedShop then
                if Config.AutoBuyAllSeeds then
                    for _, seedName in ipairs(MasterSeedList) do
                        pcall(function() _G.v3.SeedShop.PurchaseSeed(seedName) end)
                        task.wait(0.1)
                    end
                elseif Config.AutoBuySeeds and Config.ShopSelectedSeeds ~= "Select Options" then
                    -- Tokenize and clean up string data picked by the multi-dropdown
                    for token in string.gmatch(Config.ShopSelectedSeeds, "([^,]+)") do
                        local cleanSeed = string.match(token, "^%s*(.-)%s*$")
                        pcall(function() _G.v3.SeedShop.PurchaseSeed(cleanSeed) end)
                        task.wait(0.1)
                    end
                end
            end
        end
    end)
end

return Features