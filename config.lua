local Config = {
    -- INTERCEPTION SETTINGS
    PetHuntEnabled = false,
    ProtectionEnabled = false, 
    ProtectionRadius = 15,     
    TargetPets = {
        ["Bunny"] = false,
        ["Frog"] = false,
        ["Owl"] = false,
        ["Deer"] = false,
        ["Robin"] = false,
        ["Turtle"] = false,
        ["Bee"] = false,
        ["Raccoon"] = false,
        ["Monkey"] = false,
        ["Unicorn"] = false,
        ["GoldenDragonfly"] = false,
        ["Bear"] = false,
        ["BlackDragon"] = false,
        ["IceSerpent"] = false,
    },
    
    -- PET FINDER SETTINGS
    ServerHopEnabled = false,
    MaxServerPlayers = 2,

    -- VELOCITY
    FlyHeight = 2.2,
    TweenSpeed = 38,           
    CombatDashSpeed = 155,    
    
    -- MISC OPTIMIZATION & ADVANCED CONTROLS
    AutoRemoveOtherGardens = false,
    FullBright = false,
    InfiniteZoom = false,
    AntiFling = false,
    LessKnockback = false,
    InstantPrompt = false,
    BypassGameplayPaused = false,
    
    -- ESP VECTOR INTEGRATION
    ESPEnabled = false,
    ESPSelectedPets = "IceSerpent",
    ESPSelectedRarities = "Select Options",
    ESPSelectedSizes = "Select Options",
    
    -- SETTINGS CONTROL MATRIX
    TeleportMode = "Tween",
    SkipLoadingScreen = false,
    
    -- SHOP AUTOMATION MATRIX
    ShopSelectedSeeds = "Select Options",
    AutoBuySeeds = false,
    AutoBuyAllSeeds = false
}

return Config
