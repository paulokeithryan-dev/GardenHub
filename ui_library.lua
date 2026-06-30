local UILibrary = {}
local ToggleRegistry = {}

function UILibrary.GetRegistry()
    return ToggleRegistry
end

function UILibrary.CreateWindow(hubTitle)
    local targetParent = (gethui and gethui()) or game:GetService("CoreGui") or game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui")
    if targetParent:FindFirstChild("SleekPremiumUI") then targetParent.SleekPremiumUI:Destroy() end
    
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "SleekPremiumUI"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.Parent = targetParent
    
    local MainWindow = Instance.new("Frame")
    MainWindow.Size = UDim2.new(0, 580, 0, 380)
    MainWindow.Position = UDim2.new(0.5, -290, 0.5, -190)
    MainWindow.BackgroundColor3 = Color3.fromRGB(24, 24, 26)
    MainWindow.BorderSizePixel = 0
    MainWindow.Active = true
    MainWindow.Parent = ScreenGui
    
    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = UDim.new(0, 12)
    MainCorner.Parent = MainWindow
    
    local Sidebar = Instance.new("Frame")
    Sidebar.Size = UDim2.new(0, 150, 1, 0)
    Sidebar.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
    Sidebar.BorderSizePixel = 0
    Sidebar.Parent = MainWindow
    
    local SidebarCorner = Instance.new("UICorner")
    SidebarCorner.CornerRadius = UDim.new(0, 12)
    SidebarCorner.Parent = Sidebar
    
    local SidebarFix = Instance.new("Frame")
    SidebarFix.Size = UDim2.new(0, 20, 1, 0)
    SidebarFix.Position = UDim2.new(1, -20, 0, 0)
    SidebarFix.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
    SidebarFix.BorderSizePixel = 0
    SidebarFix.Parent = Sidebar
    
    local ViewContainer = Instance.new("Frame")
    ViewContainer.Size = UDim2.new(1, -170, 1, -20)
    ViewContainer.Position = UDim2.new(0, 160, 0, 10)
    ViewContainer.BackgroundTransparency = 1
    ViewContainer.Parent = MainWindow

    -- Dragging Handler Matrix
    local UserInputService = game:GetService("UserInputService")
    local dragging = false
    local dragInput, dragStart, startPos

    local function updateDrag(input)
        local delta = input.Position - dragStart
        MainWindow.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end

    local function connectDragSurface(surface)
        surface.InputBegan:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch) then
                if UserInputService:GetFocusedTextBox() then return end
                local clickElements = targetParent:GetGuiObjectsAtPosition(input.Position.X, input.Position.Y)
                for _, obj in ipairs(clickElements) do
                    if obj:IsDescendantOf(ViewContainer) or obj:IsA("ScrollingFrame") or obj:IsA("TextButton") then
                        return
                    end
                end
                dragging = true
                dragStart = input.Position
                startPos = MainWindow.Position
                input.Changed:Connect(function()
                    if input.UserInputState == Enum.UserInputState.End then dragging = false end
                end)
            end
        end)
        surface.InputChanged:Connect(function(input)
            if (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
                dragInput = input
            end
        end)
    end

    connectDragSurface(MainWindow)
    connectDragSurface(Sidebar)

    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then updateDrag(input) end
    end)

    local MinimizeBtn = Instance.new("TextButton")
    MinimizeBtn.Size = UDim2.new(0, 26, 0, 26)
    MinimizeBtn.Position = UDim2.new(1, -34, 0, 8)
    MinimizeBtn.BackgroundColor3 = Color3.fromRGB(32, 32, 36)
    MinimizeBtn.Text = "—"
    MinimizeBtn.TextColor3 = Color3.fromRGB(200, 200, 205)
    MinimizeBtn.Font = Enum.Font.GothamBold
    MinimizeBtn.TextSize = 12
    MinimizeBtn.Parent = MainWindow

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
    RestoreBtn.Parent = ScreenGui

    Instance.new("UICorner", RestoreBtn).CornerRadius = UDim.new(0, 6)
    local RestoreStroke = Instance.new("UIStroke", RestoreBtn)
    RestoreStroke.Color = Color3.fromRGB(45, 45, 48)

    MinimizeBtn.MouseButton1Click:Connect(function()
        MainWindow.Visible = false
        RestoreBtn.Visible = true
    end)

    RestoreBtn.MouseButton1Click:Connect(function()
        MainWindow.Visible = true
        RestoreBtn.Visible = false
    end)

    local SearchBox = Instance.new("Frame")
    SearchBox.Size = UDim2.new(1, -16, 0, 32)
    SearchBox.Position = UDim2.new(0, 8, 0, 12)
    SearchBox.BackgroundColor3 = Color3.fromRGB(30, 30, 34)
    SearchBox.Parent = Sidebar
    Instance.new("UICorner", SearchBox).CornerRadius = UDim.new(0, 6)
    
    local SearchText = Instance.new("TextLabel", SearchBox)
    SearchText.Size = UDim2.new(1, -10, 1, 0)
    SearchText.Position = UDim2.new(0, 10, 0, 0)
    SearchText.BackgroundTransparency = 1
    SearchText.Text = "🔍 Search"
    SearchText.TextColor3 = Color3.fromRGB(110, 110, 115)
    SearchText.TextSize = 12
    SearchText.Font = Enum.Font.Gotham
    SearchText.TextXAlignment = Enum.TextXAlignment.Left

    local ListContainer = Instance.new("Frame", Sidebar)
    ListContainer.Size = UDim2.new(1, 0, 1, -60)
    ListContainer.Position = UDim2.new(0, 0, 0, 55)
    ListContainer.BackgroundTransparency = 1
    
    local ListLayout = Instance.new("UIListLayout", ListContainer)
    ListLayout.Padding = UDim.new(0, 4)
    ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    Instance.new("UIPadding", ListContainer).PaddingLeft = UDim.new(0, 8)

    local TabEngine = {}
    local RegisteredButtons = {}
    local RegisteredViews = {}

    function TabEngine:CreateTab(tabName, iconText)
        local ViewFrame = Instance.new("Frame", ViewContainer)
        ViewFrame.Size = UDim2.new(1, 0, 1, 0)
        ViewFrame.BackgroundTransparency = 1
        ViewFrame.Visible = false
        
        local HeaderTitle = Instance.new("TextLabel", ViewFrame)
        HeaderTitle.Size = UDim2.new(1, -40, 0, 32)
        HeaderTitle.Position = UDim2.new(0, 0, 0, 5)
        HeaderTitle.BackgroundTransparency = 1
        HeaderTitle.Text = tabName
        HeaderTitle.TextColor3 = Color3.fromRGB(255, 255, 255)
        HeaderTitle.TextSize = 22
        HeaderTitle.Font = Enum.Font.GothamBold
        HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
        
        local Scroll = Instance.new("ScrollingFrame", ViewFrame)
        Scroll.Size = UDim2.new(1, 0, 1, -45)
        Scroll.Position = UDim2.new(0, 0, 0, 45)
        Scroll.BackgroundTransparency = 1
        Scroll.BorderSizePixel = 0
        Scroll.ScrollBarThickness = 4
        Scroll.ScrollBarImageColor3 = Color3.fromRGB(65, 65, 70)
        Scroll.Active = true
        
        local Layout = Instance.new("UIListLayout", Scroll)
        Layout.SortOrder = Enum.SortOrder.LayoutOrder
        Layout.Padding = UDim.new(0, 6)
        Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
            Scroll.CanvasSize = UDim2.new(0, 0, 0, Layout.AbsoluteContentSize.Y + 12)
        end)

        local order = #RegisteredButtons + 1
        local Btn = Instance.new("TextButton", ListContainer)
        Btn.Size = UDim2.new(1, 0, 0, 34)
        Btn.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
        Btn.Text = "    " .. iconText .. "  " .. tabName
        Btn.TextColor3 = Color3.fromRGB(160, 160, 165)
        Btn.Font = Enum.Font.GothamMedium
        Btn.TextSize = 12
        Btn.TextXAlignment = Enum.TextXAlignment.Left
        Btn.LayoutOrder = order
        Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
        
        local ActiveStrip = Instance.new("Frame", Btn)
        ActiveStrip.Name = "ActiveStrip"
        ActiveStrip.Size = UDim2.new(0, 3, 0, 16)
        ActiveStrip.Position = UDim2.new(0, 6, 0.5, -8)
        ActiveStrip.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        ActiveStrip.Visible = false

        Btn.MouseButton1Click:Connect(function()
            for _, v in pairs(RegisteredViews) do v.Visible = false end
            for _, b in pairs(RegisteredButtons) do
                b.BackgroundColor3 = Color3.fromRGB(18, 18, 20)
                b.TextColor3 = Color3.fromRGB(160, 160, 165)
                if b:FindFirstChild("ActiveStrip") then b.ActiveStrip.Visible = false end
            end
            ViewFrame.Visible = true
            Btn.BackgroundColor3 = Color3.fromRGB(32, 32, 36)
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            ActiveStrip.Visible = true
        end)

        table.insert(RegisteredButtons, Btn)
        RegisteredViews[tabName] = ViewFrame

        if order == 1 then
            ViewFrame.Visible = true
            Btn.BackgroundColor3 = Color3.fromRGB(32, 32, 36)
            Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
            ActiveStrip.Visible = true
        end

        local LayoutElements = {}

        function LayoutElements:AddSection(text)
            local SectionFrame = Instance.new("Frame", Scroll)
            SectionFrame.Size = UDim2.new(1, -8, 0, 24)
            SectionFrame.BackgroundTransparency = 1
            
            local HeaderLabel = Instance.new("TextLabel", SectionFrame)
            HeaderLabel.Size = UDim2.new(1, 0, 1, 0)
            HeaderLabel.BackgroundTransparency = 1
            HeaderLabel.Text = "— [ " .. text .. " ] —"
            HeaderLabel.TextColor3 = Color3.fromRGB(180, 75, 75)
            HeaderLabel.TextSize = 12
            HeaderLabel.Font = Enum.Font.GothamBold
            HeaderLabel.TextXAlignment = Enum.TextXAlignment.Left
        end

        function LayoutElements:AddToggle(labelText, checkState, onClickEvent, registryKey)
            local Card = Instance.new("Frame", Scroll)
            Card.Size = UDim2.new(1, -8, 0, 42)
            Card.BackgroundColor3 = Color3.fromRGB(30, 30, 34)
            Card.Active = true
            Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 8)
            
            local CardTitle = Instance.new("TextLabel", Card)
            CardTitle.Size = UDim2.new(0.7, 0, 1, 0)
            CardTitle.Position = UDim2.new(0, 12, 0, 0)
            CardTitle.BackgroundTransparency = 1
            CardTitle.Text = labelText
            CardTitle.TextColor3 = Color3.fromRGB(230, 230, 235)
            CardTitle.TextSize = 13
            CardTitle.Font = Enum.Font.GothamMedium
            CardTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local ToggleFrame = Instance.new("TextButton", Card)
            ToggleFrame.Size = UDim2.new(0, 42, 0, 20)
            ToggleFrame.Position = UDim2.new(1, -54, 0.5, -10)
            ToggleFrame.BackgroundColor3 = Color3.fromRGB(42, 42, 48)
            ToggleFrame.Text = ""
            Instance.new("UICorner", ToggleFrame).CornerRadius = UDim.new(1, 0)
            
            local SliderDot = Instance.new("Frame", ToggleFrame)
            SliderDot.Size = UDim2.new(0, 14, 0, 14)
            SliderDot.Position = UDim2.new(0, 3, 0.5, -7)
            SliderDot.BackgroundColor3 = Color3.fromRGB(150, 150, 155)
            Instance.new("UICorner", SliderDot).CornerRadius = UDim.new(1, 0)
            
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

        function LayoutElements:AddAction(labelText, buttonText, onClickEvent)
            local Card = Instance.new("Frame", Scroll)
            Card.Size = UDim2.new(1, -8, 0, 42)
            Card.BackgroundColor3 = Color3.fromRGB(30, 30, 34)
            Card.Active = true
            Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 8)
            
            local CardTitle = Instance.new("TextLabel", Card)
            CardTitle.Size = UDim2.new(0.6, 0, 1, 0)
            CardTitle.Position = UDim2.new(0, 12, 0, 0)
            CardTitle.BackgroundTransparency = 1
            CardTitle.Text = labelText
            CardTitle.TextColor3 = Color3.fromRGB(230, 230, 235)
            CardTitle.TextSize = 13
            CardTitle.Font = Enum.Font.GothamMedium
            CardTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local ActionBtn = Instance.new("TextButton", Card)
            ActionBtn.Size = UDim2.new(0, 70, 0, 24)
            ActionBtn.Position = UDim2.new(1, -82, 0.5, -12)
            ActionBtn.BackgroundColor3 = Color3.fromRGB(42, 42, 48)
            ActionBtn.Text = buttonText
            ActionBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
            ActionBtn.Font = Enum.Font.GothamBold
            ActionBtn.TextSize = 10
            Instance.new("UICorner", ActionBtn).CornerRadius = UDim.new(0, 6)
            
            ActionBtn.MouseButton1Click:Connect(onClickEvent)
        end

        function LayoutElements:AddInput(labelText, defaultText, onTextChange, registryKey)
            local Card = Instance.new("Frame", Scroll)
            Card.Size = UDim2.new(1, -8, 0, 42)
            Card.BackgroundColor3 = Color3.fromRGB(30, 30, 34)
            Card.Active = true
            Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 8)
            
            local CardTitle = Instance.new("TextLabel", Card)
            CardTitle.Size = UDim2.new(0.5, 0, 1, 0)
            CardTitle.Position = UDim2.new(0, 12, 0, 0)
            CardTitle.BackgroundTransparency = 1
            CardTitle.Text = labelText
            CardTitle.TextColor3 = Color3.fromRGB(230, 230, 235)
            CardTitle.TextSize = 13
            CardTitle.Font = Enum.Font.GothamMedium
            CardTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local TextBox = Instance.new("TextBox", Card)
            TextBox.Size = UDim2.new(0.42, 0, 0, 26)
            TextBox.Position = UDim2.new(1, -192, 0.5, -13)
            TextBox.BackgroundColor3 = Color3.fromRGB(42, 42, 48)
            TextBox.Text = defaultText or ""
            TextBox.TextColor3 = Color3.fromRGB(255, 255, 255)
            TextBox.Font = Enum.Font.Gotham
            TextBox.TextSize = 12
            TextBox.ClearTextOnFocus = false
            Instance.new("UICorner", TextBox).CornerRadius = UDim.new(0, 6)
            
            if registryKey then ToggleRegistry[registryKey] = function(txt) TextBox.Text = tostring(txt) end end
            TextBox.FocusLost:Connect(function() onTextChange(TextBox.Text) end)
        end

        function LayoutElements:AddMultiDropdown(labelText, defaultText, optionsList, onSelect, registryKey)
            local Card = Instance.new("Frame", Scroll)
            Card.Size = UDim2.new(1, -8, 0, 42)
            Card.BackgroundColor3 = Color3.fromRGB(30, 30, 34)
            Card.Active = true
            Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 8)
            
            local CardTitle = Instance.new("TextLabel", Card)
            CardTitle.Size = UDim2.new(0.5, 0, 1, 0)
            CardTitle.Position = UDim2.new(0, 12, 0, 0)
            CardTitle.BackgroundTransparency = 1
            CardTitle.Text = labelText
            CardTitle.TextColor3 = Color3.fromRGB(230, 230, 235)
            CardTitle.TextSize = 13
            CardTitle.Font = Enum.Font.GothamMedium
            CardTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local DropdownBtn = Instance.new("TextButton", Card)
            DropdownBtn.Size = UDim2.new(0.42, 0, 0, 26)
            DropdownBtn.Position = UDim2.new(1, -192, 0.5, -13)
            DropdownBtn.BackgroundColor3 = Color3.fromRGB(42, 42, 48)
            DropdownBtn.Text = defaultText or "Select Options"
            DropdownBtn.TextColor3 = Color3.fromRGB(220, 220, 225)
            DropdownBtn.Font = Enum.Font.Gotham
            DropdownBtn.TextSize = 12
            DropdownBtn.TextTruncate = Enum.TextTruncate.AtEnd
            Instance.new("UICorner", DropdownBtn).CornerRadius = UDim.new(0, 6)
            
            local DropdownList = Instance.new("ScrollingFrame", ScreenGui)
            DropdownList.Size = UDim2.new(0, 180, 0, 120)
            DropdownList.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
            DropdownList.BorderSizePixel = 0
            DropdownList.ScrollBarThickness = 4
            DropdownList.ScrollBarImageColor3 = Color3.fromRGB(70, 70, 75)
            DropdownList.Visible = false
            DropdownList.ZIndex = 5000
            Instance.new("UICorner", DropdownList).CornerRadius = UDim.new(0, 6)
            
            local ListStroke = Instance.new("UIStroke", DropdownList)
            ListStroke.Color = Color3.fromRGB(48, 48, 54)

            local ListLayout = Instance.new("UIListLayout", DropdownList)
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ListLayout.Padding = UDim.new(0, 1)
            
            local isOpen = false
            DropdownBtn.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                if isOpen then
                    DropdownList.Position = UDim2.new(0, DropdownBtn.AbsolutePosition.X, 0, DropdownBtn.AbsolutePosition.Y + DropdownBtn.AbsoluteSize.Y + 3)
                    DropdownList.Size = UDim2.new(0, DropdownBtn.AbsoluteSize.X, 0, math.min(#optionsList * 26 + 4, 150))
                    DropdownList.Visible = true
                else
                    DropdownList.Visible = false
                end
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
                local count, names = 0, {}
                for name, _ in pairs(activeSelections) do table.insert(names, name) count = count + 1 end
                local finalString = count == 0 and "Select Options" or (count == 1 and names[1] or count .. " Selected")
                DropdownBtn.Text = finalString
                onSelect(count == 0 and "Select Options" or table.concat(names, ", "))
            end
            
            if registryKey then
                ToggleRegistry[registryKey] = function(txt)
                    parseInitialState(txt)
                    for _, updater in pairs(optionVisualUpdaters) do updater() end
                    updateMainButtonText()
                end
            end
            
            for i, option in ipairs(optionsList) do
                local OptBtn = Instance.new("TextButton", DropdownList)
                OptBtn.Size = UDim2.new(1, 0, 0, 26)
                OptBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
                OptBtn.BorderSizePixel = 0
                OptBtn.Font = Enum.Font.Gotham
                OptBtn.TextSize = 12
                OptBtn.TextXAlignment = Enum.TextXAlignment.Left
                OptBtn.LayoutOrder = i
                OptBtn.ZIndex = 5001
                
                optionVisualUpdaters[option] = function()
                    if activeSelections[option] then
                        OptBtn.Text = "  ✓  " .. option
                        OptBtn.TextColor3 = Color3.fromRGB(100, 255, 150)
                    else
                        OptBtn.Text = "      " .. option
                        OptBtn.TextColor3 = Color3.fromRGB(190, 190, 195)
                    end
                end
                optionVisualUpdaters[option]()
                
                OptBtn.MouseButton1Click:Connect(function()
                    if option == "None" then table.clear(activeSelections) else
                        activeSelections["None"] = nil
                        activeSelections[option] = activeSelections[option] and nil or true
                    end
                    for _, updater in pairs(optionVisualUpdaters) do updater() end
                    updateMainButtonText()
                end)
            end
            updateMainButtonText()
        end

        function LayoutElements:AddSingleDropdown(labelText, defaultText, optionsList, onSelect, registryKey)
            local Card = Instance.new("Frame", Scroll)
            Card.Size = UDim2.new(1, -8, 0, 42)
            Card.BackgroundColor3 = Color3.fromRGB(30, 30, 34)
            Card.Active = true
            Instance.new("UICorner", Card).CornerRadius = UDim.new(0, 8)
            
            local CardTitle = Instance.new("TextLabel", Card)
            CardTitle.Size = UDim2.new(0.5, 0, 1, 0)
            CardTitle.Position = UDim2.new(0, 12, 0, 0)
            CardTitle.BackgroundTransparency = 1
            CardTitle.Text = labelText
            CardTitle.TextColor3 = Color3.fromRGB(230, 230, 235)
            CardTitle.TextSize = 13
            CardTitle.Font = Enum.Font.GothamMedium
            CardTitle.TextXAlignment = Enum.TextXAlignment.Left
            
            local DropdownBtn = Instance.new("TextButton", Card)
            DropdownBtn.Size = UDim2.new(0.42, 0, 0, 26)
            DropdownBtn.Position = UDim2.new(1, -192, 0.5, -13)
            DropdownBtn.BackgroundColor3 = Color3.fromRGB(42, 42, 48)
            DropdownBtn.Text = defaultText or "Select Option"
            DropdownBtn.TextColor3 = Color3.fromRGB(220, 220, 225)
            DropdownBtn.Font = Enum.Font.Gotham
            DropdownBtn.TextSize = 12
            Instance.new("UICorner", DropdownBtn).CornerRadius = UDim.new(0, 6)
            
            local DropdownList = Instance.new("ScrollingFrame", ScreenGui)
            DropdownList.Size = UDim2.new(0, 180, 0, 120)
            DropdownList.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
            DropdownList.BorderSizePixel = 0
            DropdownList.ScrollBarThickness = 4
            DropdownList.ScrollBarImageColor3 = Color3.fromRGB(70, 70, 75)
            DropdownList.Visible = false
            DropdownList.ZIndex = 5000
            Instance.new("UICorner", DropdownList).CornerRadius = UDim.new(0, 6)
            
            local ListStroke = Instance.new("UIStroke", DropdownList)
            ListStroke.Color = Color3.fromRGB(48, 48, 54)

            local ListLayout = Instance.new("UIListLayout", DropdownList)
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            
            local isOpen = false
            DropdownBtn.MouseButton1Click:Connect(function()
                isOpen = not isOpen
                if isOpen then
                    DropdownList.Position = UDim2.new(0, DropdownBtn.AbsolutePosition.X, 0, DropdownBtn.AbsolutePosition.Y + DropdownBtn.AbsoluteSize.Y + 3)
                    DropdownList.Size = UDim2.new(0, DropdownBtn.AbsoluteSize.X, 0, math.min(#optionsList * 26 + 4, 150))
                    DropdownList.Visible = true
                else
                    DropdownList.Visible = false
                end
            end)
            
            local currentSelection = defaultText
            local optionVisualUpdaters = {}
            
            if registryKey then
                ToggleRegistry[registryKey] = function(val)
                    currentSelection = val
                    for _, updater in pairs(optionVisualUpdaters) do updater() end
                    DropdownBtn.Text = currentSelection or "Select Option"
                end
            end
            
            for i, option in ipairs(optionsList) do
                local OptBtn = Instance.new("TextButton", DropdownList)
                OptBtn.Size = UDim2.new(1, 0, 0, 26)
                OptBtn.BackgroundColor3 = Color3.fromRGB(28, 28, 32)
                OptBtn.BorderSizePixel = 0
                OptBtn.Font = Enum.Font.Gotham
                OptBtn.TextSize = 12
                OptBtn.TextXAlignment = Enum.TextXAlignment.Left
                OptBtn.LayoutOrder = i
                OptBtn.ZIndex = 5001
                
                optionVisualUpdaters[option] = function()
                    if currentSelection == option then
                        OptBtn.Text = "  ✓  " .. option
                        OptBtn.TextColor3 = Color3.fromRGB(100, 255, 150)
                    else
                        OptBtn.Text = "      " .. option
                        OptBtn.TextColor3 = Color3.fromRGB(190, 190, 195)
                    end
                end
                optionVisualUpdaters[option]()
                
                OptBtn.MouseButton1Click:Connect(function()
                    currentSelection = option
                    for _, updater in pairs(optionVisualUpdaters) do updater() end
                    DropdownBtn.Text = currentSelection
                    onSelect(currentSelection)
                    isOpen = false
                    DropdownList.Visible = false
                end)
            end
        end

        return LayoutElements
    end

    return TabEngine
end

return UILibrary
