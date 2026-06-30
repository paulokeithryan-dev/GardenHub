-- =====================================================================
-- PREMIUM UI ENGINE MODULE - FULL ARCHITECTURE
-- =====================================================================
local UILibrary = {}
UILibrary.__index = UILibrary

local targetParent = (gethui and gethui()) or game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
local UserInputService = game:GetService("UserInputService")

ToggleRegistry = ToggleRegistry or {}

function UILibrary.CreateWindow(hubTitle)
    local self = setmetatable({}, UILibrary)
    
    if targetParent:FindFirstChild("SleekPremiumUI") then 
        targetParent.SleekPremiumUI:Destroy() 
    end
    
    self.ScreenGui = Instance.new("ScreenGui")
    self.ScreenGui.Name = "SleekPremiumUI"
    self.ScreenGui.ResetOnSpawn = false
    self.ScreenGui.Parent = targetParent
    
    self.MainWindow = Instance.new("Frame")
    self.MainWindow.Size = UDim2.new(0, 580, 0, 380)
    self.MainWindow.Position = UDim2.new(0.5, -290, 0.5, -190)
    self.MainWindow.BackgroundColor3 = Color3.fromRGB(24, 24, 26)
    self.MainWindow.BorderSizePixel = 0
    self.MainWindow.Active = true
    self.MainWindow.Parent = self.ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = self.MainWindow
    
    self.Sidebar = Instance.new("Frame")
    self.Sidebar.Size = UDim2.new(0, 150, 1, 0)
    self.Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
    self.Sidebar.BorderSizePixel = 0
    self.Sidebar.Parent = self.MainWindow
    
    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 12)
    SidebarCorner.Parent = self.Sidebar
    
    local SidebarFix = Instance.new("Frame")
    SidebarFix.Size = UDim2.new(0, 20, 1, 0)
    SidebarFix.Position = UDim2.new(1, -20, 0, 0)
    SidebarFix.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
    SidebarFix.BorderSizePixel = 0
    SidebarFix.Parent = self.Sidebar
    
    self.ViewContainer = Instance.new("Frame")
    self.ViewContainer.Size = UDim2.new(1, -170, 1, -20)
    self.ViewContainer.Position = UDim2.new(0, 160, 0, 10)
    self.ViewContainer.BackgroundTransparency = 1
    self.ViewContainer.Parent = self.MainWindow

    local SearchBox = Instance.new("Frame")
    SearchBox.Size = UDim2.new(1, -16, 0, 32)
    SearchBox.Position = UDim2.new(0, 8, 0, 12)
    SearchBox.BackgroundColor3 = Color3.fromRGB(30, 30, 34)
    SearchBox.BorderSizePixel = 0
    SearchBox.Parent = self.Sidebar
    
    local SearchCorner = Instance.new("UICorner")
    SearchCorner.CornerRadius = UDim.new(0, 6)
    SearchCorner.Parent = SearchBox
    
    local SearchText = Instance.new("TextLabel")
    SearchText.Size = UDim2.new(1, -10, 1, 0)
    SearchText.Position = UDim2.new(0, 10, 0, 0)
    SearchText.BackgroundTransparency = 1
    SearchText.Text = "🔍 Search"
    SearchText.TextColor3 = Color3.fromRGB(110, 110, 115)
    SearchText.TextSize = 12
    SearchText.Font = Enum.Font.Gotham
    SearchText.TextXAlignment = Enum.TextXAlignment.Left
    SearchText.Parent = SearchBox
    
    self.NavContainer = Instance.new("Frame")
    self.NavContainer.Size = UDim2.new(1, 0, 1, -60)
    self.NavContainer.Position = UDim2.new(0, 0, 0, 55)
    self.NavContainer.BackgroundTransparency = 1
    self.NavContainer.Parent = self.Sidebar
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.Padding = UDim.new(0, 4)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Parent = self.NavContainer
    
    local ListPadding = Instance.new("UIPadding")
    ListPadding.PaddingLeft = UDim.new(0, 8)
    ListPadding.PaddingRight = UDim.new(0, 8)
    ListPadding.Parent = self.NavContainer

    self.TabButtons = {}
    self.TabFrames = {}
    self.HubTitleName = hubTitle

    local dragging, dragInput, dragStart, startPos
    local function connectDrag(surface)
        surface.InputBegan:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                if UserInputService:GetFocusedTextBox() then return end
                local clickElements = targetParent:GetGuiObjectsAtPosition(input.Position.X, input.Position.Y)
                for _, obj in ipairs(clickElements) do
                    if obj:IsDescendantOf(self.ViewContainer) or obj:IsA("ScrollingFrame") or obj:IsA("TextButton") then return end
                end
                dragging = true
                dragStart = input.Position
                startPos = self.MainWindow.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        surface.InputChanged:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then dragInput = input end
        end)
    end
    connectDrag(self.MainWindow)
    connectDrag(self.Sidebar)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            self.MainWindow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)

    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Size = UDim2.new(0, 26, 0, 26)
    MinimizeBtn.Position = UDim2.new(1, -34, 0, 8)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 36)
    MinimizeBtn.Text = "—"
    MinimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 205)
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.TextSize = 12
    MinimizeBtn.Parent = self.MainWindow

    local MinCorner = Instance.new("UICorner")
    MinCorner.CornerRadius = UDim.new(0, 6)
    MinCorner.Parent = MinimizeBtn

    local RestoreBtn = Instance.new("TextButton")
    RestoreBtn.Size = UDim2.new(0, 85, 0, 30)
    RestoreBtn.Position = UDim2.new(0, 15, 0, 15)
    RestoreBtn.BackgroundColor3 = Color3.fromRGB(24, 24, 26)
    RestoreBtn.Text = "Open UI"
    RestoreBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    RestoreBtn.Font = Enum.Font.GothamMedium
    RestoreBtn.TextSize = 12
    RestoreBtn.Visible = false
    RestoreBtn.ZIndex = 100000 
    RestoreBtn.Parent = self.ScreenGui

    local RestoreCorner = Instance.new("UICorner")
    RestoreCorner.CornerRadius = UDim.new(0, 6)
    RestoreCorner.Parent = RestoreBtn

    local RestoreStroke = Instance.new("UIStroke")
    RestoreStroke.Color = Color3.fromRGB(45, 45, 48)
    RestoreStroke.Thickness = 1
    RestoreStroke.Parent = RestoreBtn

    MinimizeBtn.MouseButton1Click:Connect(function() self.MainWindow.Visible = false RestoreBtn.Visible = true end)
    RestoreBtn.MouseButton1Click:Connect(function() self.MainWindow.Visible = true RestoreBtn.Visible = false end)

    return self
end

-- =====================================================================
-- TAB CLASS ARCHITECTURE
-- =====================================================================
local Tab = {}
Tab.__index = Tab

function UILibrary:CreateTab(tabName, iconText)
    local tabSelf = setmetatable({}, Tab)
    local order = #self.TabButtons + 1
    
    local ViewFrame = Instance.new("Frame")
    ViewFrame.Size = UDim2.new(1, 0, 1, 0)
    ViewFrame.BackgroundTransparency = 1
    ViewFrame.Visible = false
    ViewFrame.Parent = self.ViewContainer
    
    local HeaderTitle = Instance.new("TextLabel")
    HeaderTitle.Size = UDim2.new(1, -40, 0, 32)
    HeaderTitle.Position = UDim2.new(0, 0, 0, 5)
    HeaderTitle.BackgroundTransparency = 1
    HeaderTitle.Text = tabName
    HeaderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
    HeaderTitle.TextSize = 22
    HeaderTitle.Font = Enum.Font.GothamBold
    HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
    HeaderTitle.Parent = ViewFrame
    
    local Scroll = Instance.new("ScrollingFrame")
    Scroll.Size = UDim2.new(1, 0, 1, -45)
    Scroll.Position = UDim2.new(0, 0, 0, 45)
    Scroll.BackgroundTransparency = 1
    Scroll.BorderSizePixel = 0
    Scroll.ScrollBarThickness = 4
    Scroll.ScrollBarImageColor3 = Color3.fromRGB(65, 65, 70)
    Scroll.Active = true
    Scroll.Parent = ViewFrame
    
    local ListLayout = Instance.new("UIListLayout")
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 6)
    ListLayout.Parent = Scroll
    
    ListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Scroll.CanvasSize = UDim2.new(0, 0, 0, ListLayout.AbsoluteContentSize.Y + 12)
    end)
    
    tabSelf.ScrollTarget = Scroll
    self.TabFrames[tabName] = ViewFrame

    local Btn = Instance.new("TextButton")
    Btn.Size = UDim2.new(1, 0, 0, 34)
    Btn.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
    Btn.Text = "    " .. iconText .. "  " .. tabName
    Btn.TextColor3 = Color3.fromRGB(160, 160, 165)
    Btn.Font = Enum.Font.GothamMedium
    Btn.TextSize = 12
    Btn.TextXAlignment = Enum.TextXAlignment.Left
    Btn.LayoutOrder = order
    Btn.Parent = self.NavContainer
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = Btn
    
    local ActiveStrip = Instance.new("Frame")
    ActiveStrip.Name = "ActiveStrip"
    ActiveStrip.Size = UDim2.new(0, 3, 0, 16)
    ActiveStrip.Position = UDim2.new(0, 6, 0.5, -8)
    ActiveStrip.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ActiveStrip.BorderSizePixel = 0
    ActiveStrip.Visible = false
    ActiveStrip.Parent = Btn
    
    Btn.MouseButton1Click:Connect(function()
        for name, frame in pairs(self.TabFrames) do frame.Visible = (name == tabName) end
        for _, otherBtn in pairs(self.TabButtons) do
            otherBtn.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
            otherBtn.TextColor3 = Color3.fromRGB(160, 160, 165)
            local strip = otherBtn:FindFirstChild("ActiveStrip")
            if strip then strip.Visible = false end
        end
        Btn.BackgroundColor3 = Color3.fromRGB(32, 32, 36)
        Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        ActiveStrip.Visible = true
    end)
    
    table.insert(self.TabButtons, Btn)
    
    if order == 1 then
        ViewFrame.Visible = true
        Btn.BackgroundColor3 = Color3.fromRGB(32, 32, 36)
        Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        ActiveStrip.Visible = true
    end
    
    return tabSelf
end

function Tab:AddSection(text)
    local SectionFrame = Instance.new("Frame")
    SectionFrame.Size = UDim2.new(1, -8, 0, 24)
    SectionFrame.BackgroundTransparency = 1
    SectionFrame.Parent = self.ScrollTarget
    
    local HeaderLabel = Instance.new("TextLabel")
    HeaderLabel.Size = UDim2.new(1, 0, 1, 0)
    HeaderLabel.BackgroundTransparency = 1
    HeaderLabel.Text = "— [ " .. text .. " ] —"
    HeaderLabel.TextColor3 = Color3.fromRGB(180, 75, 75)
    HeaderLabel.TextSize = 12
    HeaderLabel.Font = Enum.Font.GothamBold
    HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
    HeaderLabel.Parent = SectionFrame
end

function Tab:AddToggle(labelText, checkState, onClickEvent, registryKey)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, -8, 0, 42)
    Card.BackgroundColor3 = Color3.fromRGB(30, 30, 34)
    Card.BorderSizePixel = 0
    Card.Active = true
    Card.Parent = self.ScrollTarget
    
    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 8)
    CardCorner.Parent = Card
    
    local CardTitle = Instance.new("TextLabel")
    CardTitle.Size = UDim2.new(0.7, 0, 1, 0)
    CardTitle.Position = UDim2.new(0, 12, 0, 0)
    CardTitle.BackgroundTransparency = 1
    CardTitle.Text = labelText
    CardTitle.TextColor3 = Color3.fromRGB(230, 230, 235)
    CardTitle.TextSize = 13
    CardTitle.Font = Enum.Font.GothamMedium
    CardTitle.TextXAlignment = Enum.TextXAlignment.Left
    CardTitle.Parent = Card
    
    local ToggleFrame = Instance.new("TextButton")
    ToggleFrame.Size = UDim2.new(0, 42, 0, 20)
    ToggleFrame.Position = UDim2.new(1, -54, 0.5, -10)
    ToggleFrame.BackgroundColor3 = Color3.fromRGB(42, 42, 48)
    ToggleFrame.Text = ""
    ToggleFrame.Parent = Card
    
    local ToggleCorner = Instance.new("UICorner")
    ToggleCorner.CornerRadius = UDim.new(1, 0)
    ToggleCorner.Parent = ToggleFrame
    
    local SliderDot = Instance.new("Frame")
    SliderDot.Size = UDim2.new(0, 14, 0, 14)
    SliderDot.Position = UDim2.new(0, 3, 0.5, -7)
    SliderDot.BackgroundColor3 = Color3.fromRGB(150, 150, 155)
    SliderDot.BorderSizePixel = 0
    SliderDot.Parent = ToggleFrame
    
    local DotCorner = Instance.new("UICorner")
    DotCorner.CornerRadius = UDim.new(1, 0)
    DotCorner.Parent = SliderDot
    
    local currentState = checkState
    local function updateVisuals(enabled)
        currentState = enabled
        if enabled then
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(0, 180, 110)
            SliderDot.Position = UDim2.new(1, -17, 0.5, -7)
            SliderDot.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        else
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(42, 42, 48)
            SliderDot.Position = UDim2.new(0, 3, 0.5, -7)
            SliderDot.BackgroundColor3 = Color3.fromRGB(150, 150, 155)
        end
    end
    
    if registryKey then ToggleRegistry[registryKey] = updateVisuals end
    updateVisuals(currentState)
    
    ToggleFrame.MouseButton1Click:Connect(function()
        currentState = not currentState
        updateVisuals(currentState)
        onClickEvent(currentState)
    end)
end

function Tab:AddButton(labelText, buttonText, onClickEvent)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, -8, 0, 42)
    Card.BackgroundColor3 = Color3.fromRGB(30, 30, 34)
    Card.BorderSizePixel = 0
    Card.Active = true
    Card.Parent = self.ScrollTarget
    
    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 8)
    CardCorner.Parent = Card
    
    local CardTitle = Instance.new("TextLabel")
    CardTitle.Size = UDim2.new(0.6, 0, 1, 0)
    CardTitle.Position = UDim2.new(0, 12, 0, 0)
    CardTitle.BackgroundTransparency = 1
    CardTitle.Text = labelText
    CardTitle.TextColor3 = Color3.fromRGB(230, 230, 235)
    CardTitle.TextSize = 13
    CardTitle.Font = Enum.Font.GothamMedium
    CardTitle.TextXAlignment = Enum.TextXAlignment.Left
    CardTitle.Parent = Card
    
    local ActionBtn = Instance.new("TextButton")
    ActionBtn.Size = UDim2.new(0, 70, 0, 24)
    ActionBtn.Position = UDim2.new(1, -82, 0.5, -12)
    ActionBtn.BackgroundColor3 = Color3.fromRGB(42, 42, 48)
    ActionBtn.Text = buttonText
    ActionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    ActionBtn.Font = Enum.Font.GothamBold
    ActionBtn.TextSize = 10
    ActionBtn.Parent = Card
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = ActionBtn
    
    ActionBtn.MouseButton1Click:Connect(onClickEvent)
end

function Tab:AddInput(labelText, defaultText, onTextChange, registryKey)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, -8, 0, 42)
    Card.BackgroundColor3 = Color3.fromRGB(30, 30, 34)
    Card.BorderSizePixel = 0
    Card.Active = true
    Card.Parent = self.ScrollTarget
    
    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 8)
    CardCorner.Parent = Card
    
    local CardTitle = Instance.new("TextLabel")
    CardTitle.Size = UDim2.new(0.5, 0, 1, 0)
    CardTitle.Position = UDim2.new(0, 12, 0, 0)
    CardTitle.BackgroundTransparency = 1
    CardTitle.Text = labelText
    CardTitle.TextColor3 = Color3.fromRGB(230, 230, 235)
    CardTitle.TextSize = 13
    CardTitle.Font = Enum.Font.GothamMedium
    CardTitle.TextXAlignment = Enum.TextXAlignment.Left
    CardTitle.Parent = Card
    
    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(0.42, 0, 0, 26)
    TextBox.Position = UDim2.new(1, -192, 0.5, -13)
    TextBox.BackgroundColor3 = Color3.fromRGB(42, 42, 48)
    TextBox.Text = defaultText or ""
    TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextBox.PlaceholderText = "..."
    TextBox.PlaceholderColor3 = Color3.fromRGB(100, 100, 105)
    TextBox.Font = Enum.Font.Gotham
    TextBox.TextSize = 12
    TextBox.ClearTextOnFocus = false
    TextBox.Parent = Card
    
    local BoxCorner = Instance.new("UICorner")
    BoxCorner.CornerRadius = UDim.new(0, 6)
    BoxCorner.Parent = TextBox
    
    local function updateVisuals(txt) TextBox.Text = tostring(txt) end
    if registryKey then ToggleRegistry[registryKey] = updateVisuals end
    
    TextBox.FocusLost:Connect(function() onTextChange(TextBox.Text) end)
end

function Tab:AddMultiDropdown(labelText, defaultText, optionsList, onSelect, registryKey)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, -8, 0, 42)
    Card.BackgroundColor3 = Color3.fromRGB(30, 30, 34)
    Card.BorderSizePixel = 0
    Card.Active = true
    Card.Parent = self.ScrollTarget
    
    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 8)
    CardCorner.Parent = Card
    
    local CardTitle = Instance.new("TextLabel")
    CardTitle.Size = UDim2.new(0.5, 0, 1, 0)
    CardTitle.Position = UDim2.new(0, 12, 0, 0)
    CardTitle.BackgroundTransparency = 1
    CardTitle.Text = labelText
    CardTitle.TextColor3 = Color3.fromRGB(230, 230, 235)
    CardTitle.TextSize = 13
    CardTitle.Font = Enum.Font.GothamMedium
    CardTitle.TextXAlignment = Enum.TextXAlignment.Left
    CardTitle.Parent = Card
    
    local DropdownBtn = Instance.new("TextButton")
    DropdownBtn.Size = UDim2.new(0.42, 0, 0, 26)
    DropdownBtn.Position = UDim2.new(1, -192, 0.5, -13)
    DropdownBtn.BackgroundColor3 = Color3.fromRGB(42, 42, 48)
    DropdownBtn.Text = defaultText or "Select Options"
    DropdownBtn.TextColor3 = Color3.fromRGB(220, 220, 225)
    DropdownBtn.Font = Enum.Font.Gotham
    DropdownBtn.TextSize = 12
    DropdownBtn.TextTruncate = Enum.TextTruncate.AtEnd
    DropdownBtn.Parent = Card
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = DropdownBtn
    
    local DropdownList = Instance.new("ScrollingFrame")
    DropdownList.Size = UDim2.new(0, 180, 0, 120)
    DropdownList.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
    DropdownList.BorderSizePixel = 0
    DropdownList.ScrollBarThickness = 4
    DropdownList.ScrollBarImageColor3 = Color3.fromRGB(70, 70, 75)
    DropdownList.Visible = false
    DropdownList.ZIndex = 5000
    DropdownList.Parent = self.ScrollTarget:FindFirstAncestorOfClass("ScreenGui") or targetParent:WaitForChild("SleekPremiumUI")

    local ListCorner = Instance.new("UICorner")
    ListCorner.CornerRadius = UDim.new(0, 6)
    ListCorner.Parent = DropdownList
    
    local ListStroke = Instance.new("UIStroke")
    ListStroke.Color = Color3.fromRGB(48, 48, 54)
    ListStroke.Thickness = 1
    ListStroke.Parent = DropdownList

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 1)
    ListLayout.Parent = DropdownList
    
    local isOpen = false
    local function toggleDropdown()
        isOpen = not isOpen
        if isOpen then
            DropdownList.Position = UDim2.new(0, DropdownBtn.AbsolutePosition.X, 0, DropdownBtn.AbsolutePosition.Y + DropdownBtn.AbsoluteSize.Y + 3)
            DropdownList.Size = UDim2.new(0, DropdownBtn.AbsoluteSize.X, 0, math.min(#optionsList * 26 + 4, 150))
            DropdownList.Visible = true
        else
            DropdownList.Visible = false
        end
    end
    
    DropdownBtn.MouseButton1Click:Connect(toggleDropdown)
    DropdownBtn:GetPropertyChangedSignal("AbsolutePosition"):Connect(function()
        if isOpen then DropdownList.Position = UDim2.new(0, DropdownBtn.AbsolutePosition.X, 0, DropdownBtn.AbsolutePosition.Y + DropdownBtn.AbsoluteSize.Y + 3) end
    end)
    
    local activeSelections = {}
    local function parseInitialState(txt)
        table.clear(activeSelections)
        if txt and txt ~= "Select Options" and txt ~= "None" and txt ~= "" then
            for token in string.gmatch(txt, "[^,%s]+") do activeSelections[token] = true end
        end
    end
    parseInitialState(defaultText)
    
    local optionVisualUpdaters = {}
    local function updateMainButtonText()
        local count = 0
        local names = {}
        for name, _ in pairs(activeSelections) do table.insert(names, name) count = count + 1 end
        
        local finalString = ""
        if count == 0 then finalString = "Select Options" DropdownBtn.Text = finalString
        elseif count == 1 then finalString = names[1] DropdownBtn.Text = finalString
        else finalString = count .. " Selected" end
        onSelect(finalString)
    end
    
    if registryKey then ToggleRegistry[registryKey] = function(txt) parseInitialState(txt) for _, u in pairs(optionVisualUpdaters) do u() end updateMainButtonText() end end
    
    for i, option in ipairs(optionsList) do
        local OptBtn = Instance.new("TextButton")
        OptBtn.Size = UDim2.new(1, 0, 0, 26)
        OptBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
        OptBtn.BorderSizePixel = 0
        OptBtn.Font = Enum.Font.Gotham
        OptBtn.TextSize = 12
        OptBtn.TextXAlignment = Enum.TextXAlignment.Left
        OptBtn.LayoutOrder = i
        OptBtn.ZIndex = 5001
        OptBtn.Parent = DropdownList
        
        optionVisualUpdaters[option] = function()
            if activeSelections[option] then OptBtn.Text = "  ✓  " .. option OptBtn.TextColor3 = Color3.fromRGB(100, 255, 150)
            else OptBtn.Text = "      " .. option OptBtn.TextColor3 = Color3.fromRGB(190, 190, 195) end
        end
        optionVisualUpdaters[option]()
        
        OptBtn.MouseEnter:Connect(function() OptBtn.BackgroundColor3 = Color3.fromRGB(38, 38, 44) end)
        OptBtn.MouseLeave:Connect(function() OptBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 32) end)
        OptBtn.MouseButton1Click:Connect(function()
            if option == "None" then table.clear(activeSelections) else activeSelections["None"] = nil activeSelections[option] = not activeSelections[option] or nil end
            for _, u in pairs(optionVisualUpdaters) do u() end updateMainButtonText()
        end)
    end
    updateMainButtonText()
end

function Tab:AddSingleDropdown(labelText, defaultText, optionsList, onSelect, registryKey)
    local Card = Instance.new("Frame")
    Card.Size = UDim2.new(1, -8, 0, 42)
    Card.BackgroundColor3 = Color3.fromRGB(30, 30, 34)
    Card.BorderSizePixel = 0
    Card.Active = true
    Card.Parent = self.ScrollTarget
    
    local CardCorner = Instance.new("UICorner")
    CardCorner.CornerRadius = UDim.new(0, 8)
    CardCorner.Parent = Card
    
    local CardTitle = Instance.new("TextLabel")
    CardTitle.Size = UDim2.new(0.5, 0, 1, 0)
    CardTitle.Position = UDim2.new(0, 12, 0, 0)
    CardTitle.BackgroundTransparency = 1
    CardTitle.Text = labelText
    CardTitle.TextColor3 = Color3.fromRGB(230, 230, 235)
    CardTitle.TextSize = 13
    CardTitle.Font = Enum.Font.GothamMedium
    CardTitle.TextXAlignment = Enum.TextXAlignment.Left
    CardTitle.Parent = Card
    
    local DropdownBtn = Instance.new("TextButton")
    DropdownBtn.Size = UDim2.new(0.42, 0, 0, 26)
    DropdownBtn.Position = UDim2.new(1, -192, 0.5, -13)
    DropdownBtn.BackgroundColor3 = Color3.fromRGB(42, 42, 48)
    DropdownBtn.Text = defaultText or "Select Option"
    DropdownBtn.TextColor3 = Color3.fromRGB(220, 220, 225)
    DropdownBtn.Font = Enum.Font.Gotham
    DropdownBtn.TextSize = 12
    DropdownBtn.TextTruncate = Enum.TextTruncate.AtEnd
    DropdownBtn.Parent = Card
    
    local BtnCorner = Instance.new("UICorner")
    BtnCorner.CornerRadius = UDim.new(0, 6)
    BtnCorner.Parent = DropdownBtn
    
    local DropdownList = Instance.new("ScrollingFrame")
    DropdownList.Size = UDim2.new(0, 180, 0, 120)
    DropdownList.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
    DropdownList.BorderSizePixel = 0
    DropdownList.ScrollBarThickness = 4
    DropdownList.ScrollBarImageColor3 = Color3.fromRGB(70, 70, 75)
    DropdownList.Visible = false
    DropdownList.ZIndex = 5000
    DropdownList.Parent = self.ScrollTarget:FindFirstAncestorOfClass("ScreenGui") or targetParent:WaitForChild("SleekPremiumUI")

    local ListCorner = Instance.new("UICorner")
    ListCorner.CornerRadius = UDim.new(0, 6)
    ListCorner.Parent = DropdownList
    
    local ListStroke = Instance.new("UIStroke")
    ListStroke.Color = Color3.fromRGB(48, 48, 54)
    ListStroke.Thickness = 1
    ListStroke.Parent = DropdownList

    local ListLayout = Instance.new("UIListLayout")
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    ListLayout.Padding = UDim.new(0, 1)
    ListLayout.Parent = DropdownList
    
    local isOpen = false
    local function toggleDropdown()
        isOpen = not isOpen
        if isOpen then
            DropdownList.Position = UDim2.new(0, DropdownBtn.AbsolutePosition.X, 0, DropdownBtn.AbsolutePosition.Y + DropdownBtn.AbsoluteSize.Y + 3)
            DropdownList.Size = UDim2.new(0, DropdownBtn.AbsoluteSize.X, 0, math.min(#optionsList * 26 + 4, 150))
            DropdownList.Visible = true
        else
            DropdownList.Visible = false
        end
    end
    
    DropdownBtn.MouseButton1Click:Connect(toggleDropdown)
    
    local currentSelection = defaultText
    local optionVisualUpdaters = {}
    local function updateMainButtonText() DropdownBtn.Text = currentSelection or "Select Option" onSelect(currentSelection) end
    
    if registryKey then ToggleRegistry[registryKey] = function(val) currentSelection = val for _, u in pairs(optionVisualUpdaters) do u() end DropdownBtn.Text = val or "Select Option" end end
    
    for i, option in ipairs(optionsList) do
        local OptBtn = Instance.new("TextButton")
        OptBtn.Size = UDim2.new(1, 0, 0, 26)
        OptBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
        OptBtn.BorderSizePixel = 0
        OptBtn.Font = Enum.Font.Gotham
        OptBtn.TextSize = 12
        OptBtn.TextXAlignment = Enum.TextXAlignment.Left
        OptBtn.LayoutOrder = i
        OptBtn.ZIndex = 5001
        OptBtn.Parent = DropdownList
        
        optionVisualUpdaters[option] = function()
            if currentSelection == option then OptBtn.Text = "  ✓  " .. option OptBtn.TextColor3 = Color3.fromRGB(100, 255, 150)
            else OptBtn.Text = "      " .. option OptBtn.TextColor3 = Color3.fromRGB(190, 190, 195) end
        end
        optionVisualUpdaters[option]()
        
        OptBtn.MouseEnter:Connect(function() OptBtn.BackgroundColor3 = Color3.fromRGB(38, 38, 44) end)
        OptBtn.MouseLeave:Connect(function() OptBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 32) end)
        OptBtn.MouseButton1Click:Connect(function() currentSelection = option for _, u in pairs(optionVisualUpdaters) do u() end updateMainButtonText() toggleDropdown() end)
    end
    updateMainButtonText()
end

return UILibrary