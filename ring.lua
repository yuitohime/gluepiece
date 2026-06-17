-- ==========================================
-- GLUE PIECE - YUI HUB STYLE V4 (FIXED DRAG & PASSIVE ATTACK)
-- ==========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local guiName = "GluePiece_YuiStyle_V4"
local CoreGui = pcall(function() return game:GetService("CoreGui").Name end) and game:GetService("CoreGui") or LocalPlayer.PlayerGui

if CoreGui:FindFirstChild(guiName) then CoreGui[guiName]:Destroy() end

-- ==========================================
-- 1. GLOBALS & SETTINGS
-- ==========================================
_G.FarmMobs = {}
_G.FarmBosses = {}
_G.SelectedSkills = {}
_G.SelectedWeapons = {}
_G.SelectedDrop = ""

_G.AutoFarm = false
_G.AutoBoss = false
_G.AutoDuck = false
_G.AutoKyo = false
_G.AutoSkill = false
_G.AutoAttack = false
_G.AutoWeapon = false

-- Định vị đánh
_G.AtkPosition = "Trên Đầu"
_G.AtkDistance = 5

local MobsList = {"Slime", "Snake", "Thug", "Cutie Noob", "Elite Noob", "Evil Thug"}
local BossesList = {"Cutie Boss", "King Noob", "Nooby", "Unknown Boss", "King Slime", "Duck Boss", "Kyo", "Sans", "Shinoa", "Sword Master"}
local PosList = {"Trên Đầu", "Sau Lưng", "Dưới Chân", "Trước Mặt"}
local SkillKeys = {"Q", "E", "R", "T", "F", "Z", "X", "C", "V"}

-- ==========================================
-- 2. UI THEME & DRAG LOGIC
-- ==========================================
local Colors = {
    BG = Color3.fromRGB(15, 17, 26),
    Card = Color3.fromRGB(22, 25, 37),
    Border = Color3.fromRGB(37, 41, 60),
    Text = Color3.fromRGB(230, 230, 230),
    Green = Color3.fromRGB(0, 255, 136),
    ToggleOff = Color3.fromRGB(255,255,255),
    ToggleBgOff = Color3.fromRGB(40,45,60)
}

local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = guiName
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 680, 0, 420)
MainFrame.Position = UDim2.new(0.5, -340, 0.5, -210)
MainFrame.BackgroundColor3 = Colors.BG
MainFrame.Active = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 10)

-- Header (TopBar) - CHỈ CHO PHÉP KÉO Ở ĐÂY ĐỂ TRÁNH LỖI SCROLL
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 50)
TopBar.BackgroundTransparency = 1
TopBar.Active = true

-- LOGIC KÉO THẢ TÙY CHỈNH CHO TOPBAR
local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true
        dragStart = input.Position
        startPos = MainFrame.Position
        input.Changed:Connect(function()
            if input.UserInputState == Enum.UserInputState.End then dragging = false end
        end)
    end
end)
TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
        dragInput = input
    end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local GreenLine = Instance.new("Frame", TopBar)
GreenLine.Size = UDim2.new(0, 3, 0, 24)
GreenLine.Position = UDim2.new(0, 20, 0.5, -12)
GreenLine.BackgroundColor3 = Colors.Green
Instance.new("UICorner", GreenLine).CornerRadius = UDim.new(1, 0)

local TitleTop = Instance.new("TextLabel", TopBar)
TitleTop.Size = UDim2.new(0, 200, 0, 15)
TitleTop.Position = UDim2.new(0, 30, 0.5, -14)
TitleTop.BackgroundTransparency = 1
TitleTop.Text = "Ultimate Script Hub"
TitleTop.TextColor3 = Color3.fromRGB(150, 150, 160)
TitleTop.Font = Enum.Font.Gotham
TitleTop.TextSize = 11
TitleTop.TextXAlignment = Enum.TextXAlignment.Left

local TitleBot = Instance.new("TextLabel", TopBar)
TitleBot.Size = UDim2.new(0, 200, 0, 20)
TitleBot.Position = UDim2.new(0, 30, 0.5, 0)
TitleBot.BackgroundTransparency = 1
TitleBot.Text = "Glue Piece V4"
TitleBot.TextColor3 = Colors.Green
TitleBot.Font = Enum.Font.GothamBold
TitleBot.TextSize = 18
TitleBot.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -40, 0.5, -15)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local LeftPanel = Instance.new("ScrollingFrame", MainFrame)
LeftPanel.Size = UDim2.new(0, 160, 1, -60)
LeftPanel.Position = UDim2.new(0, 10, 0, 50)
LeftPanel.BackgroundTransparency = 1
LeftPanel.ScrollBarThickness = 0
local LeftLayout = Instance.new("UIListLayout", LeftPanel)
LeftLayout.Padding = UDim.new(0, 5)

local RightPanel = Instance.new("Frame", MainFrame)
RightPanel.Size = UDim2.new(1, -190, 1, -60)
RightPanel.Position = UDim2.new(0, 180, 0, 50)
RightPanel.BackgroundTransparency = 1

-- ==========================================
-- 3. UI COMPONENTS
-- ==========================================
local Tabs, TabButtons = {}, {}

local function CreateTab(name)
    local TabBtn = Instance.new("TextButton", LeftPanel)
    TabBtn.Size = UDim2.new(1, 0, 0, 35)
    TabBtn.BackgroundTransparency = 1
    TabBtn.Text = "   " .. name
    TabBtn.TextColor3 = Color3.fromRGB(150, 150, 160)
    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.TextSize = 13
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left

    local Indicator = Instance.new("Frame", TabBtn)
    Indicator.Size = UDim2.new(0, 3, 0, 16)
    Indicator.Position = UDim2.new(0, 0, 0.5, -8)
    Indicator.BackgroundColor3 = Colors.Green
    Indicator.Visible = false
    Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

    local TabContent = Instance.new("ScrollingFrame", RightPanel)
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.ScrollBarThickness = 3
    TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabContent.Visible = false
    local ContentLayout = Instance.new("UIListLayout", TabContent)
    ContentLayout.Padding = UDim.new(0, 10)

    TabBtn.MouseButton1Click:Connect(function()
        for _, c in pairs(Tabs) do c.Visible = false end
        for _, b in pairs(TabButtons) do 
            b.TextColor3 = Color3.fromRGB(150, 150, 160)
            b:FindFirstChild("Frame").Visible = false 
        end
        TabContent.Visible = true
        TabBtn.TextColor3 = Colors.Green
        Indicator.Visible = true
    end)
    
    table.insert(Tabs, TabContent)
    table.insert(TabButtons, TabBtn)
    
    if #Tabs == 1 then 
        TabContent.Visible = true 
        TabBtn.TextColor3 = Colors.Green
        Indicator.Visible = true
    end
    return TabContent
end

local function CreateSection(parent, title)
    local Section = Instance.new("Frame", parent)
    Section.BackgroundColor3 = Colors.Card
    Instance.new("UICorner", Section).CornerRadius = UDim.new(0, 8)
    Instance.new("UIStroke", Section).Color = Colors.Border

    local Layout = Instance.new("UIListLayout", Section)
    Layout.Padding = UDim.new(0, 10)
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    local Padding = Instance.new("UIPadding", Section)
    Padding.PaddingTop = UDim.new(0, 15)
    Padding.PaddingBottom = UDim.new(0, 15)

    if title then
        local TitleLbl = Instance.new("TextLabel", Section)
        TitleLbl.Size = UDim2.new(1, -30, 0, 20)
        TitleLbl.BackgroundTransparency = 1
        TitleLbl.Text = title
        TitleLbl.TextColor3 = Colors.Green
        TitleLbl.Font = Enum.Font.GothamBold
        TitleLbl.TextSize = 13
        TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    end

    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        Section.Size = UDim2.new(1, -10, 0, Layout.AbsoluteContentSize.Y + 30)
    end)

    return Section
end

local function CreateToggle(parent, text, globalVar)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -30, 0, 25)
    Frame.BackgroundTransparency = 1
    
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, -60, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Colors.Text
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = 12
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local ToggleBg = Instance.new("Frame", Frame)
    ToggleBg.Size = UDim2.new(0, 36, 0, 18)
    ToggleBg.Position = UDim2.new(1, -36, 0.5, -9)
    ToggleBg.BackgroundColor3 = Colors.ToggleBgOff
    Instance.new("UICorner", ToggleBg).CornerRadius = UDim.new(1, 0)

    local Circle = Instance.new("Frame", ToggleBg)
    Circle.Size = UDim2.new(0, 14, 0, 14)
    Circle.Position = UDim2.new(0, 2, 0.5, -7)
    Circle.BackgroundColor3 = Colors.ToggleOff
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

    local btn = Instance.new("TextButton", Frame)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        _G[globalVar] = state
        TweenService:Create(ToggleBg, TweenInfo.new(0.2), {BackgroundColor3 = state and Colors.Green or Colors.ToggleBgOff}):Play()
        TweenService:Create(Circle, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -16, 0.5, -7) or UDim2.new(0, 2, 0.5, -7)}):Play()
    end)
end

local function CreateDropdown(parent, text, list, globalVar, isMulti)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -30, 0, 32)
    Frame.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
    Frame.ClipsDescendants = true
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", Frame).Color = Colors.Border

    local MainBtn = Instance.new("TextButton", Frame)
    MainBtn.Size = UDim2.new(1, 0, 0, 32)
    MainBtn.BackgroundTransparency = 1
    MainBtn.Text = "  " .. text .. (isMulti and " (Multi) ▼" or " ▼")
    MainBtn.TextColor3 = Colors.Green
    MainBtn.Font = Enum.Font.GothamSemibold
    MainBtn.TextSize = 12
    MainBtn.TextXAlignment = Enum.TextXAlignment.Left

    local ScrollList = Instance.new("ScrollingFrame", Frame)
    ScrollList.Size = UDim2.new(1, 0, 1, -32)
    ScrollList.Position = UDim2.new(0, 0, 0, 32)
    ScrollList.BackgroundTransparency = 1
    ScrollList.ScrollBarThickness = 2
    ScrollList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local ListLayout = Instance.new("UIListLayout", ScrollList)

    local isExpanded = false
    MainBtn.MouseButton1Click:Connect(function()
        isExpanded = not isExpanded
        TweenService:Create(Frame, TweenInfo.new(0.2), {Size = isExpanded and UDim2.new(1, -30, 0, 150) or UDim2.new(1, -30, 0, 32)}):Play()
    end)

    local function Populate(dataList)
        for _, c in pairs(ScrollList:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
        for _, opt in ipairs(dataList) do
            local OptBtn = Instance.new("TextButton", ScrollList)
            OptBtn.Size = UDim2.new(1, 0, 0, 28)
            OptBtn.BackgroundColor3 = Color3.fromRGB(22, 25, 37)
            OptBtn.Text = "  " .. opt
            OptBtn.TextColor3 = Colors.Text
            OptBtn.Font = Enum.Font.Gotham
            OptBtn.TextSize = 11
            OptBtn.TextXAlignment = Enum.TextXAlignment.Left

            OptBtn.MouseButton1Click:Connect(function()
                if isMulti then
                    if _G[globalVar][opt] then
                        _G[globalVar][opt] = nil
                        OptBtn.TextColor3 = Colors.Text
                        OptBtn.Text = "  " .. opt
                    else
                        _G[globalVar][opt] = true
                        OptBtn.TextColor3 = Colors.Green
                        OptBtn.Text = "✓ " .. opt
                    end
                else
                    _G[globalVar] = opt
                    MainBtn.Text = "  " .. opt .. " ▼"
                    isExpanded = false
                    TweenService:Create(Frame, TweenInfo.new(0.2), {Size = UDim2.new(1, -30, 0, 32)}):Play()
                end
            end)
        end
    end
    Populate(list)
    return Populate
end

local function CreateDistanceSlider(parent)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -30, 0, 32)
    Frame.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", Frame).Color = Colors.Border

    local Lbl = Instance.new("TextLabel", Frame)
    Lbl.Size = UDim2.new(0, 120, 1, 0)
    Lbl.Position = UDim2.new(0, 10, 0, 0)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = "Khoảng cách (Studs):"
    Lbl.TextColor3 = Colors.Text
    Lbl.Font = Enum.Font.GothamSemibold
    Lbl.TextSize = 11
    Lbl.TextXAlignment = Enum.TextXAlignment.Left

    local ValLbl = Instance.new("TextLabel", Frame)
    ValLbl.Size = UDim2.new(0, 30, 1, 0)
    ValLbl.Position = UDim2.new(0.5, 0, 0, 0)
    ValLbl.BackgroundTransparency = 1
    ValLbl.Text = tostring(_G.AtkDistance)
    ValLbl.TextColor3 = Colors.Green
    ValLbl.Font = Enum.Font.GothamBold
    ValLbl.TextSize = 12

    local MinBtn = Instance.new("TextButton", Frame)
    MinBtn.Size = UDim2.new(0, 30, 1, 0)
    MinBtn.Position = UDim2.new(1, -60, 0, 0)
    MinBtn.BackgroundTransparency = 1
    MinBtn.Text = "-"
    MinBtn.TextColor3 = Color3.fromRGB(255,100,100)
    MinBtn.Font = Enum.Font.GothamBold
    
    local AddBtn = Instance.new("TextButton", Frame)
    AddBtn.Size = UDim2.new(0, 30, 1, 0)
    AddBtn.Position = UDim2.new(1, -30, 0, 0)
    AddBtn.BackgroundTransparency = 1
    AddBtn.Text = "+"
    AddBtn.TextColor3 = Colors.Green
    AddBtn.Font = Enum.Font.GothamBold

    MinBtn.MouseButton1Click:Connect(function()
        _G.AtkDistance = math.max(0, _G.AtkDistance - 1)
        ValLbl.Text = tostring(_G.AtkDistance)
    end)
    AddBtn.MouseButton1Click:Connect(function()
        _G.AtkDistance = _G.AtkDistance + 1
        ValLbl.Text = tostring(_G.AtkDistance)
    end)
end

local function CreateNote(parent, initialText)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -30, 0, 60)
    Frame.BackgroundColor3 = Color3.fromRGB(15, 17, 26)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    
    local Lbl = Instance.new("TextLabel", Frame)
    Lbl.Size = UDim2.new(1, -10, 1, -10)
    Lbl.Position = UDim2.new(0, 5, 0, 5)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = initialText
    Lbl.TextColor3 = Color3.fromRGB(180, 180, 200)
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextSize = 11
    Lbl.TextYAlignment = Enum.TextYAlignment.Top
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.TextWrapped = true

    return Lbl
end

local function CreateButton(parent, text, callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(1, -30, 0, 30)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
    Btn.Text = text
    Btn.TextColor3 = Colors.Text
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 12
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    Btn.MouseButton1Click:Connect(callback)
    return Btn
end

-- ==========================================
-- 4. BUILDING TABS & SECTIONS
-- ==========================================

-- TAB 1: SĂN BOSS & ĐỊNH VỊ
local TabBoss = CreateTab("Săn Boss & Định Vị")
local SecBossSet = CreateSection(TabBoss, "Cấu Hình Góc Đánh")
CreateToggle(SecBossSet, "Tự Động Đánh (Thụ Động - Không chiếm chuột)", "AutoAttack")
CreateDropdown(SecBossSet, "Chọn Hướng Đứng (Góc Đánh)", PosList, "AtkPosition", false)
CreateDistanceSlider(SecBossSet)

local SecBoss = CreateSection(TabBoss, "Live Boss Tracker")
local BossNoteLabel = CreateNote(SecBoss, "Đang quét server...")
CreateDropdown(SecBoss, "Danh Sách Boss Tùy Chọn", BossesList, "FarmBosses", true)
CreateToggle(SecBoss, "Bật Auto Săn Boss Tùy Chọn", "AutoBoss")

local SecSpecial = CreateSection(TabBoss, "Boss Ưu Tiên Cao")
CreateToggle(SecSpecial, "🔥 Auto Săn Kyo (Cực VIP)", "AutoKyo")
CreateToggle(SecSpecial, "🔥 Auto Săn Duck Boss", "AutoDuck")

task.spawn(function()
    while task.wait(1.5) do
        local alive = {}
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and table.find(BossesList, obj.Name) and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then
                if not table.find(alive, obj.Name) then table.insert(alive, "• " .. obj.Name) end
            end
        end
        if #alive > 0 then
            BossNoteLabel.TextColor3 = Colors.Green
            BossNoteLabel.Text = "[ BOSS ĐANG SỐNG TRÊN MAP ]\n" .. table.concat(alive, "\n")
        else
            BossNoteLabel.TextColor3 = Color3.fromRGB(180,180,200)
            BossNoteLabel.Text = "Hiện tại không có Boss nào xuất hiện."
        end
    end
end)


-- TAB 2: QUÁI THƯỜNG
local TabFarm = CreateTab("Farm Quái Thường")
local SecFarm = CreateSection(TabFarm, "Cài Đặt Quái")
CreateDropdown(SecFarm, "Danh Sách Quái Mobs", MobsList, "FarmMobs", true)
CreateToggle(SecFarm, "Bật Auto Farm Mobs", "AutoFarm")


-- TAB 3: SKILL & VŨ KHÍ (QUÉT TÚI ĐỒ)
local TabSkill = CreateTab("Vũ Khí & Kỹ Năng")
local SecWeap = CreateSection(TabSkill, "Sử Dụng Vũ Khí")

-- Dropdown Rỗng lúc đầu, sẽ có Update Menu
local UpdateWeaponMenu = CreateDropdown(SecWeap, "Vũ Khí Đang Có (Hãy Quét Trước)", {"Chưa quét"}, "SelectedWeapons", true)

CreateButton(SecWeap, "🔄 Quét Vũ Khí Trong Túi", function()
    local wpList = {}
    for _, t in pairs(LocalPlayer.Backpack:GetChildren()) do
        if t:IsA("Tool") then table.insert(wpList, t.Name) end
    end
    for _, t in pairs(LocalPlayer.Character:GetChildren()) do
        if t:IsA("Tool") then table.insert(wpList, t.Name) end
    end
    if #wpList == 0 then table.insert(wpList, "Không tìm thấy vũ khí") end
    
    -- Xóa dữ liệu cũ nếu quét lại
    _G.SelectedWeapons = {} 
    UpdateWeaponMenu(wpList)
end)

CreateToggle(SecWeap, "Auto Cầm Tất Cả Vũ Khí Đã Chọn", "AutoWeapon")

local SecSkill = CreateSection(TabSkill, "Tự Động Kỹ Năng")
CreateDropdown(SecSkill, "Chọn Các Phím Cần Xả", SkillKeys, "SelectedSkills", true)
CreateToggle(SecSkill, "Bật Tự Động Xả Skill", "AutoSkill")


-- TAB 4: ESP & TELEPORT
local TabItems = CreateTab("Map Items & Teleport")
local SecESP = CreateSection(TabItems, "Tìm Đồ Vật")
local UpdateDropMenu = CreateDropdown(SecESP, "Danh Sách Vật Phẩm", {"Đang chờ..."}, "SelectedDrop", false)

CreateButton(SecESP, "Làm Mới Danh Sách Vật Phẩm", function()
    local drops = {}
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Tool") and obj.Parent ~= LocalPlayer.Character and obj.Parent ~= LocalPlayer.Backpack then
            table.insert(drops, obj.Name)
        end
    end
    if #drops == 0 then table.insert(drops, "Không có đồ") end
    UpdateDropMenu(drops)
end)

local TeleBtn = CreateButton(SecESP, "Teleport Đến Món Đã Chọn", function()
    if _G.SelectedDrop ~= "" and _G.SelectedDrop ~= "Không có đồ" then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name == _G.SelectedDrop and obj:IsA("Tool") then
                local t = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("Part")
                if t and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then
                    LocalPlayer.Character.HumanoidRootPart.CFrame = t.CFrame
                end
                break
            end
        end
    end
end)
TeleBtn.BackgroundColor3 = Colors.Green
TeleBtn.TextColor3 = Colors.BG

-- ==========================================
-- 5. LOGIC CORE
-- ==========================================
local function GetOffsetCFrame(targetCFrame)
    local dist = _G.AtkDistance
    if _G.AtkPosition == "Trên Đầu" then return targetCFrame * CFrame.new(0, dist, 0) * CFrame.Angles(math.rad(-90), 0, 0)
    elseif _G.AtkPosition == "Sau Lưng" then return targetCFrame * CFrame.new(0, 0, dist)
    elseif _G.AtkPosition == "Trước Mặt" then return targetCFrame * CFrame.new(0, 0, -dist) * CFrame.Angles(0, math.rad(180), 0)
    elseif _G.AtkPosition == "Dưới Chân" then return targetCFrame * CFrame.new(0, -dist, 0) * CFrame.Angles(math.rad(90), 0, 0)
    end
    return targetCFrame * CFrame.new(0, 0, dist)
end

local function GetStrictTarget()
    if _G.AutoKyo then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name == "Kyo" and obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then return obj end
        end return nil
    end

    if _G.AutoDuck then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name == "Duck Boss" and obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then return obj end
        end return nil
    end

    if _G.AutoBoss then
        local hasSelectedBoss = false
        for bName, isSelected in pairs(_G.FarmBosses) do if isSelected then hasSelectedBoss = true break end end
        if hasSelectedBoss then
            for _, obj in pairs(workspace:GetDescendants()) do
                if _G.FarmBosses[obj.Name] and obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then return obj end
            end return nil
        end
    end

    if _G.AutoFarm then
        for _, obj in pairs(workspace:GetDescendants()) do
            if _G.FarmMobs[obj.Name] and obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then return obj end
        end
    end

    return nil
end

local function EquipGuns()
    if _G.AutoWeapon then
        for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") and _G.SelectedWeapons[tool.Name] then
                tool.Parent = LocalPlayer.Character
            end
        end
    end
end

-- VÒNG LẶP DI CHUYỂN VÀ ĐÁNH (THỤ ĐỘNG)
task.spawn(function()
    while task.wait() do
        if _G.AutoFarm or _G.AutoBoss or _G.AutoKyo or _G.AutoDuck then
            EquipGuns()
            local targetMob = GetStrictTarget()
            
            if targetMob then
                while targetMob and targetMob:FindFirstChild("Humanoid") and targetMob.Humanoid.Health > 0 do
                    if not (_G.AutoFarm or _G.AutoBoss or _G.AutoKyo or _G.AutoDuck) then break end
                    pcall(function()
                        local char = LocalPlayer.Character
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            char.HumanoidRootPart.CFrame = GetOffsetCFrame(targetMob.HumanoidRootPart.CFrame)
                            
                            -- Đánh thụ động bằng cách kích hoạt Tool thay vì bấm chuột
                            if _G.AutoAttack then
                                for _, tool in pairs(char:GetChildren()) do
                                    if tool:IsA("Tool") then tool:Activate() end
                                end
                            end
                        end
                    end)
                    task.wait(0.05)
                end
            end
        end
    end
end)

-- VÒNG LẶP SKILL
task.spawn(function()
    while task.wait(0.2) do
        if _G.AutoSkill and (_G.AutoFarm or _G.AutoBoss or _G.AutoKyo or _G.AutoDuck) then
            for key, isSel in pairs(_G.SelectedSkills) do
                if isSel then
                    pcall(function()
                        VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
                        task.wait(0.1)
                        VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
                    end)
                end
            end
        end
    end
end)
