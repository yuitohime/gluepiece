-- ==========================================
-- GLUE PIECE - YUI HUB V15 (MAX FPS, SMOOTH FLY & FLASH ATTACK)
-- ==========================================
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local LocalPlayer = Players.LocalPlayer

local guiName = "GluePiece_YuiStyle_V15"
local CoreGui = pcall(function() return game:GetService("CoreGui").Name end) and game:GetService("CoreGui") or LocalPlayer.PlayerGui

if CoreGui:FindFirstChild(guiName) then CoreGui[guiName]:Destroy() end

-- ==========================================
-- 1. GLOBALS & THIẾT LẬP
-- ==========================================
_G.FarmMobs = {}
_G.FarmBosses = {}
_G.SelectedSkills = {}
_G.SelectedWeapons = {}
_G.SelectedDrop = ""
_G.SelectedNPC = ""

_G.AutoFarm = false
_G.AutoDuck = false
_G.AutoKyo = false
_G.AutoSkill = false
_G.AutoAttack = false
_G.FastAttack = false -- Flash Attack
_G.AutoWeapon = false
_G.AutoSwitchWeaponFruit = false 
_G.SwitchDelay = 3 
_G.AutoKirito = false 

_G.AutoBuso = false -- Haki Vũ Trang (B)
_G.AutoKen = false  -- Haki Quan Sát (V)

_G.ESPItem = false
_G.ESPBoss = false

-- Di chuyển & Định vị
_G.AtkPosition = "Trên Đầu"
_G.AtkDistance = 5
_G.MoveMethod = "Bay Mượt (Tween)"
_G.FlySpeed = 300

-- Chia Dame & Safe Mode
_G.SplitDamage = false
_G.SplitTime = 3 
_G.AutoSafe = false
_G.SafeHP = 30 
_G.IsHealing = false

local MobsList = {"Slime", "Snake", "Thug", "Cutie Noob", "Elite Noob", "Evil Thug"}
local WorldBosses = {"Kyo", "Duck Boss"}
local NormalBosses = {"Chara", "Cutie Boss", "King Noob", "Nooby", "Unknown Boss", "King Slime", "Sans", "Shinoa", "Sword Master"}
local NPCList = {"Awakening Book", "Black Leg", "Limitless", "OFA [Deku]", "Busoshoku", "Observation", "Random Fruity", "Reset Fruity", "Reset Stats", "Dual Sword", "Geppo", "Soru"}
local PosList = {"Trên Đầu", "Sau Lưng", "Dưới Chân", "Trước Mặt"}
local MoveList = {"Dịch Chuyển", "Bay Mượt (Tween)"}
local SkillKeys = {"Q", "E", "R", "T", "F", "Z", "X", "C", "V"}

-- ==========================================
-- 2. UI THEME (MAX MOBILE COMPACT)
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

local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 40, 0, 40)
OpenBtn.Position = UDim2.new(0, 10, 0.5, -20)
OpenBtn.BackgroundColor3 = Colors.Card
OpenBtn.Text = "YUI"
OpenBtn.TextColor3 = Colors.Green
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.TextSize = 12
OpenBtn.Visible = false
OpenBtn.Active = true
OpenBtn.Draggable = true
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", OpenBtn).Color = Colors.Green

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 480, 0, 280)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -140)
MainFrame.BackgroundColor3 = Colors.BG
MainFrame.Active = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundTransparency = 1
TopBar.Active = true

local dragging, dragInput, dragStart, startPos
TopBar.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true dragStart = input.Position startPos = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
TopBar.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local GreenLine = Instance.new("Frame", TopBar)
GreenLine.Size = UDim2.new(0, 3, 0, 16)
GreenLine.Position = UDim2.new(0, 10, 0.5, -8)
GreenLine.BackgroundColor3 = Colors.Green
Instance.new("UICorner", GreenLine).CornerRadius = UDim.new(1, 0)

local TitleBot = Instance.new("TextLabel", TopBar)
TitleBot.Size = UDim2.new(0, 200, 0, 20)
TitleBot.Position = UDim2.new(0, 20, 0.5, -10)
TitleBot.BackgroundTransparency = 1
TitleBot.Text = "Glue Piece V15 - Max Speed"
TitleBot.TextColor3 = Colors.Green
TitleBot.Font = Enum.Font.GothamBold
TitleBot.TextSize = 13
TitleBot.TextXAlignment = Enum.TextXAlignment.Left

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0, 25, 0, 25)
MinBtn.Position = UDim2.new(1, -60, 0.5, -12)
MinBtn.BackgroundTransparency = 1
MinBtn.Text = "—"
MinBtn.TextColor3 = Colors.Text
MinBtn.Font = Enum.Font.GothamBold

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 25, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0.5, -12)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 80, 80)
CloseBtn.Font = Enum.Font.GothamBold

MinBtn.MouseButton1Click:Connect(function() MainFrame.Visible = false OpenBtn.Visible = true end)
OpenBtn.MouseButton1Click:Connect(function() MainFrame.Visible = true OpenBtn.Visible = false end)
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local LeftPanel = Instance.new("ScrollingFrame", MainFrame)
LeftPanel.Size = UDim2.new(0, 120, 1, -40)
LeftPanel.Position = UDim2.new(0, 5, 0, 35)
LeftPanel.BackgroundTransparency = 1
LeftPanel.ScrollBarThickness = 0
LeftPanel.AutomaticCanvasSize = Enum.AutomaticSize.Y
local LeftLayout = Instance.new("UIListLayout", LeftPanel)
LeftLayout.Padding = UDim.new(0, 3)

local RightPanel = Instance.new("Frame", MainFrame)
RightPanel.Size = UDim2.new(1, -135, 1, -40)
RightPanel.Position = UDim2.new(0, 130, 0, 35)
RightPanel.BackgroundTransparency = 1

-- ==========================================
-- 3. UI COMPONENTS
-- ==========================================
local Tabs, TabButtons = {}, {}

local function CreateTab(name)
    local TabBtn = Instance.new("TextButton", LeftPanel)
    TabBtn.Size = UDim2.new(1, 0, 0, 28)
    TabBtn.BackgroundTransparency = 1
    TabBtn.Text = "  " .. name
    TabBtn.TextColor3 = Color3.fromRGB(150, 150, 160)
    TabBtn.Font = Enum.Font.GothamSemibold
    TabBtn.TextSize = 10
    TabBtn.TextXAlignment = Enum.TextXAlignment.Left

    local Indicator = Instance.new("Frame", TabBtn)
    Indicator.Size = UDim2.new(0, 3, 0, 14)
    Indicator.Position = UDim2.new(0, 0, 0.5, -7)
    Indicator.BackgroundColor3 = Colors.Green
    Indicator.Visible = false
    Instance.new("UICorner", Indicator).CornerRadius = UDim.new(1, 0)

    local TabContent = Instance.new("ScrollingFrame", RightPanel)
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.ScrollBarThickness = 2
    TabContent.AutomaticCanvasSize = Enum.AutomaticSize.Y
    TabContent.Visible = false
    local ContentLayout = Instance.new("UIListLayout", TabContent)
    ContentLayout.Padding = UDim.new(0, 6)

    TabBtn.MouseButton1Click:Connect(function()
        for _, c in pairs(Tabs) do c.Visible = false end
        for _, b in pairs(TabButtons) do b.TextColor3 = Color3.fromRGB(150, 150, 160) b:FindFirstChild("Frame").Visible = false end
        TabContent.Visible = true
        TabBtn.TextColor3 = Colors.Green
        Indicator.Visible = true
    end)
    
    table.insert(Tabs, TabContent)
    table.insert(TabButtons, TabBtn)
    if #Tabs == 1 then TabContent.Visible = true TabBtn.TextColor3 = Colors.Green Indicator.Visible = true end
    return TabContent
end

local function CreateSection(parent, title)
    local Section = Instance.new("Frame", parent)
    Section.BackgroundColor3 = Colors.Card
    Instance.new("UICorner", Section).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", Section).Color = Colors.Border
    local Layout = Instance.new("UIListLayout", Section)
    Layout.Padding = UDim.new(0, 6)
    Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    local Padding = Instance.new("UIPadding", Section)
    Padding.PaddingTop = UDim.new(0, 8)
    Padding.PaddingBottom = UDim.new(0, 8)

    if title then
        local TitleLbl = Instance.new("TextLabel", Section)
        TitleLbl.Size = UDim2.new(1, -16, 0, 14)
        TitleLbl.BackgroundTransparency = 1
        TitleLbl.Text = title
        TitleLbl.TextColor3 = Colors.Green
        TitleLbl.Font = Enum.Font.GothamBold
        TitleLbl.TextSize = 10
        TitleLbl.TextXAlignment = Enum.TextXAlignment.Left
    end
    Layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() Section.Size = UDim2.new(1, -10, 0, Layout.AbsoluteContentSize.Y + 16) end)
    return Section
end

local function CreateToggle(parent, text, globalVar, tableKey)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -16, 0, 22)
    Frame.BackgroundTransparency = 1
    
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, -45, 1, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Colors.Text
    Label.Font = Enum.Font.GothamSemibold
    Label.TextSize = 10
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local ToggleBg = Instance.new("Frame", Frame)
    ToggleBg.Size = UDim2.new(0, 28, 0, 14)
    ToggleBg.Position = UDim2.new(1, -28, 0.5, -7)
    ToggleBg.BackgroundColor3 = Colors.ToggleBgOff
    Instance.new("UICorner", ToggleBg).CornerRadius = UDim.new(1, 0)

    local Circle = Instance.new("Frame", ToggleBg)
    Circle.Size = UDim2.new(0, 10, 0, 10)
    Circle.Position = UDim2.new(0, 2, 0.5, -5)
    Circle.BackgroundColor3 = Colors.ToggleOff
    Instance.new("UICorner", Circle).CornerRadius = UDim.new(1, 0)

    local btn = Instance.new("TextButton", Frame)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""

    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        if tableKey then _G[globalVar][tableKey] = state else _G[globalVar] = state end
        TweenService:Create(ToggleBg, TweenInfo.new(0.2), {BackgroundColor3 = state and Colors.Green or Colors.ToggleBgOff}):Play()
        TweenService:Create(Circle, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -12, 0.5, -5) or UDim2.new(0, 2, 0.5, -5)}):Play()
    end)
end

local function CreateDropdown(parent, text, list, globalVar, isMulti)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -16, 0, 26)
    Frame.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
    Frame.ClipsDescendants = true
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 4)
    Instance.new("UIStroke", Frame).Color = Colors.Border

    local MainBtn = Instance.new("TextButton", Frame)
    MainBtn.Size = UDim2.new(1, 0, 0, 26)
    MainBtn.BackgroundTransparency = 1
    MainBtn.Text = "  " .. text .. " ▼"
    MainBtn.TextColor3 = Colors.Green
    MainBtn.Font = Enum.Font.GothamSemibold
    MainBtn.TextSize = 10
    MainBtn.TextXAlignment = Enum.TextXAlignment.Left

    local ScrollList = Instance.new("ScrollingFrame", Frame)
    ScrollList.Size = UDim2.new(1, 0, 1, -26)
    ScrollList.Position = UDim2.new(0, 0, 0, 26)
    ScrollList.BackgroundTransparency = 1
    ScrollList.ScrollBarThickness = 2
    ScrollList.AutomaticCanvasSize = Enum.AutomaticSize.Y
    local ListLayout = Instance.new("UIListLayout", ScrollList)

    local isExpanded = false
    MainBtn.MouseButton1Click:Connect(function()
        isExpanded = not isExpanded
        TweenService:Create(Frame, TweenInfo.new(0.2), {Size = isExpanded and UDim2.new(1, -16, 0, 110) or UDim2.new(1, -16, 0, 26)}):Play()
    end)

    local function Populate(dataList)
        for _, c in pairs(ScrollList:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
        for _, opt in ipairs(dataList) do
            local OptBtn = Instance.new("TextButton", ScrollList)
            OptBtn.Size = UDim2.new(1, 0, 0, 22)
            OptBtn.BackgroundColor3 = Color3.fromRGB(22, 25, 37)
            OptBtn.Text = "  " .. opt
            OptBtn.TextColor3 = Colors.Text
            OptBtn.Font = Enum.Font.Gotham
            OptBtn.TextSize = 10
            OptBtn.TextXAlignment = Enum.TextXAlignment.Left

            OptBtn.MouseButton1Click:Connect(function()
                if isMulti then
                    if _G[globalVar][opt] then _G[globalVar][opt] = nil OptBtn.TextColor3 = Colors.Text OptBtn.Text = "  " .. opt
                    else _G[globalVar][opt] = true OptBtn.TextColor3 = Colors.Green OptBtn.Text = "[ V ] " .. opt end
                else
                    _G[globalVar] = opt MainBtn.Text = "  " .. opt .. " ▼" isExpanded = false
                    TweenService:Create(Frame, TweenInfo.new(0.2), {Size = UDim2.new(1, -16, 0, 26)}):Play()
                end
            end)
        end
    end
    Populate(list)
    return Populate
end

local function CreateSlider(parent, text, min, max, globalVar)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -16, 0, 36)
    Frame.BackgroundColor3 = Color3.fromRGB(18, 20, 28)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 4)
    Instance.new("UIStroke", Frame).Color = Colors.Border

    local Lbl = Instance.new("TextLabel", Frame)
    Lbl.Size = UDim2.new(1, -10, 0, 14)
    Lbl.Position = UDim2.new(0, 8, 0, 2)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = text
    Lbl.TextColor3 = Colors.Text
    Lbl.Font = Enum.Font.GothamSemibold
    Lbl.TextSize = 10
    Lbl.TextXAlignment = Enum.TextXAlignment.Left

    local ValLbl = Instance.new("TextLabel", Frame)
    ValLbl.Size = UDim2.new(0, 40, 0, 14)
    ValLbl.Position = UDim2.new(1, -48, 0, 2)
    ValLbl.BackgroundTransparency = 1
    ValLbl.Text = tostring(_G[globalVar])
    ValLbl.TextColor3 = Colors.Green
    ValLbl.Font = Enum.Font.GothamBold
    ValLbl.TextSize = 10

    local SliderBg = Instance.new("Frame", Frame)
    SliderBg.Size = UDim2.new(1, -16, 0, 4)
    SliderBg.Position = UDim2.new(0, 8, 0, 24)
    SliderBg.BackgroundColor3 = Color3.fromRGB(40,45,60)
    Instance.new("UICorner", SliderBg).CornerRadius = UDim.new(1, 0)

    local Fill = Instance.new("Frame", SliderBg)
    local startScale = (_G[globalVar] - min) / (max - min)
    Fill.Size = UDim2.new(startScale, 0, 1, 0)
    Fill.BackgroundColor3 = Colors.Green
    Instance.new("UICorner", Fill).CornerRadius = UDim.new(1, 0)

    local Btn = Instance.new("TextButton", SliderBg)
    Btn.Size = UDim2.new(1, 0, 1, 20)
    Btn.Position = UDim2.new(0, 0, 0, -10)
    Btn.BackgroundTransparency = 1
    Btn.Text = ""

    local dragging = false
    Btn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = true end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then dragging = false end end)
    UserInputService.InputChanged:Connect(function(input)
        if dragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            local pos = math.clamp((input.Position.X - SliderBg.AbsolutePosition.X) / SliderBg.AbsoluteSize.X, 0, 1)
            Fill.Size = UDim2.new(pos, 0, 1, 0)
            local val = math.floor(min + (max - min) * pos)
            _G[globalVar] = val
            ValLbl.Text = tostring(val)
        end
    end)
end

local function CreateNote(parent, height)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -16, 0, height or 60)
    Frame.BackgroundColor3 = Color3.fromRGB(15, 17, 26)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 4)
    
    local Lbl = Instance.new("TextLabel", Frame)
    Lbl.Size = UDim2.new(1, -10, 1, -10)
    Lbl.Position = UDim2.new(0, 5, 0, 5)
    Lbl.BackgroundTransparency = 1
    Lbl.Text = ""
    Lbl.TextColor3 = Color3.fromRGB(180, 180, 200)
    Lbl.Font = Enum.Font.Gotham
    Lbl.TextSize = 10
    Lbl.RichText = true
    Lbl.TextYAlignment = Enum.TextYAlignment.Top
    Lbl.TextXAlignment = Enum.TextXAlignment.Left
    Lbl.TextWrapped = true
    return Lbl
end

local function CreateButton(parent, text, callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(1, -16, 0, 24)
    Btn.BackgroundColor3 = Color3.fromRGB(30, 35, 50)
    Btn.Text = text
    Btn.TextColor3 = Colors.Text
    Btn.Font = Enum.Font.GothamBold
    Btn.TextSize = 10
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)
    Btn.MouseButton1Click:Connect(callback)
    return Btn
end

-- ==========================================
-- 4. TẠO TABS CHỨC NĂNG 
-- ==========================================

-- TAB 1: SĂN BOSS 
local TabBoss = CreateTab("Săn Boss")
local SecSpecial = CreateSection(TabBoss, "Boss Thế Giới")
CreateToggle(SecSpecial, "[ VIP ] Auto Kyo", "AutoKyo")
CreateToggle(SecSpecial, "[ HOT ] Auto Duck Boss", "AutoDuck")

local SecBossList = CreateSection(TabBoss, "Công Tắc Từng Boss")
for _, boss in ipairs(NormalBosses) do CreateToggle(SecBossList, "Săn: " .. boss, "FarmBosses", boss) end

local SecTracker = CreateSection(TabBoss, "Live Boss Tracker")
local BossNoteLabel = CreateNote(SecTracker, 210)

task.spawn(function()
    local cYes = "<font color='rgb(0, 255, 136)'>[ YES ]</font> "
    local cNo = "<font color='rgb(255, 80, 80)'>[ NO ]</font> "

    while task.wait(1) do
        local alive = {}
        for _, obj in pairs(workspace:GetDescendants()) do if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then alive[obj.Name] = true end end

        local txt = "<font color='rgb(0, 255, 136)'>[ BOSS THẾ GIỚI ]</font>\n"
        for _, b in ipairs(WorldBosses) do if alive[b] then txt = txt .. cYes .. b .. "\n" else txt = txt .. cNo .. b .. "\n" end end
        
        txt = txt .. "\n<font color='rgb(255, 200, 50)'>[ BOSS THƯỜNG ]</font>\n"
        for _, b in ipairs(NormalBosses) do if alive[b] then txt = txt .. cYes .. b .. "\n" else txt = txt .. cNo .. b .. "\n" end end
        BossNoteLabel.Text = txt
    end
end)

-- TAB 2: QUÁI THƯỜNG
local TabFarm = CreateTab("Farm Quái")
local SecFarm = CreateSection(TabFarm, "Cài Đặt Quái")
CreateToggle(SecFarm, "TỰ ĐỘNG FARM QUÁI BẬT DƯỚI", "AutoFarm")
for _, mob in ipairs(MobsList) do CreateToggle(SecFarm, "Đánh: " .. mob, "FarmMobs", mob) end

-- TAB 3: SETTING FARM & OPTIMIZE
local TabSetting = CreateTab("Cài Đặt Farm")

local SecOpt = CreateSection(TabSetting, "Tối Ưu / Chống Lag")
CreateButton(SecOpt, "[ OPTIMIZE ] Giảm Lag / Xóa Hiệu Ứng", function()
    settings().Rendering.QualityLevel = 1
    game.Lighting.GlobalShadows = false
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("Part") or v:IsA("Union") or v:IsA("CornerWedgePart") or v:IsA("TrussPart") then
            v.Material = Enum.Material.Plastic
            v.Reflectance = 0
        elseif v:IsA("Decal") or (v:IsA("Texture") and v.Name ~= "Yui_ESP") then
            v:Destroy()
        elseif v:IsA("ParticleEmitter") or v:IsA("Trail") then
            v.Lifetime = NumberRange.new(0)
        end
    end
    workspace.Terrain.WaterWaveSize = 0
end)

local SecSplit = CreateSection(TabSetting, "Chia Dame")
CreateToggle(SecSplit, "Bật Chia Dame (Nhảy từng con)", "SplitDamage")
CreateSlider(SecSplit, "Đổi mục tiêu sau (Giây):", 1, 10, "SplitTime")

local SecMove = CreateSection(TabSetting, "Di Chuyển")
CreateDropdown(SecMove, "Cách Bay Đến Quái", MoveList, "MoveMethod", false)
CreateSlider(SecMove, "Tốc Độ Bay:", 100, 2000, "FlySpeed")

local SecSet = CreateSection(TabSetting, "Góc Đánh")
CreateToggle(SecSet, "🔥 Flash Attack (Đánh Siêu Tốc Render)", "FastAttack")
CreateToggle(SecSet, "Đánh Thường (Tool:Activate)", "AutoAttack")
CreateDropdown(SecSet, "Chọn Hướng Đứng", PosList, "AtkPosition", false)
CreateSlider(SecSet, "Khoảng cách đánh:", 0, 50, "AtkDistance")

local SecSafe = CreateSection(TabSetting, "Trú Ẩn Hồi Máu")
CreateToggle(SecSafe, "Tự Động Bay Lên Trời Khi Yếu", "AutoSafe")
CreateSlider(SecSafe, "Phần trăm máu (%) bỏ chạy:", 10, 90, "SafeHP")

-- TAB 4: SKILL & VŨ KHÍ 
local TabSkill = CreateTab("Vũ Khí & Skill")

local SecHaki = CreateSection(TabSkill, "Haki Tự Động")
CreateToggle(SecHaki, "Auto Haki Vũ Trang (B)", "AutoBuso")
CreateToggle(SecHaki, "Auto Haki Quan Sát (V)", "AutoKen")

local SecSpecialWep = CreateSection(TabSkill, "Vũ Khí Đặc Biệt (Từ Shop)")
CreateToggle(SecSpecialWep, "Auto Lấy Kiếm Kirito (Dual Sword)", "AutoKirito")

local SecWeap = CreateSection(TabSkill, "Sử Dụng Vũ Khí")
local UpdateWeaponMenu = CreateDropdown(SecWeap, "Vũ Khí Trong Túi", {"Chưa quét"}, "SelectedWeapons", true)
CreateButton(SecWeap, "🔄 Quét Vũ Khí", function()
    local wpList = {}
    for _, t in pairs(LocalPlayer.Backpack:GetChildren()) do if t:IsA("Tool") then table.insert(wpList, t.Name) end end
    for _, t in pairs(LocalPlayer.Character:GetChildren()) do if t:IsA("Tool") then table.insert(wpList, t.Name) end end
    if #wpList == 0 then table.insert(wpList, "Trống") end
    _G.SelectedWeapons = {} UpdateWeaponMenu(wpList)
end)
CreateToggle(SecWeap, "[ COMBO ] Đổi Liên Tục Vũ Khí <-> Trái", "AutoSwitchWeaponFruit")
CreateSlider(SecWeap, "Thời gian đổi (Giây):", 1, 10, "SwitchDelay")
CreateToggle(SecWeap, "Chỉ Cầm Cứng 1 Vũ Khí", "AutoWeapon")

local SecSkill = CreateSection(TabSkill, "Kỹ Năng")
CreateDropdown(SecSkill, "Phím Kỹ Năng", SkillKeys, "SelectedSkills", true)
CreateToggle(SecSkill, "Auto Xả Skill", "AutoSkill")

-- TAB 5: ESP & TELEPORT
local TabItems = CreateTab("ESP & Dịch Chuyển")
local SecNPC = CreateSection(TabItems, "Shop / NPCs")
CreateDropdown(SecNPC, "Chọn Shop / NPC", NPCList, "SelectedNPC", false)
local TeleNPCBtn = CreateButton(SecNPC, "Bay Đến Shop/NPC", function()
    if _G.SelectedNPC ~= "" then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name == _G.SelectedNPC and (obj:IsA("Model") or obj:IsA("Folder")) then
                local t = obj:FindFirstChild("HumanoidRootPart") or obj:FindFirstChildWhichIsA("Part")
                if t and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.CFrame = t.CFrame * CFrame.new(0, 0, 3) end
                break
            end
        end
    end
end)
TeleNPCBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)

local SecDrop = CreateSection(TabItems, "Đồ Rơi")
local UpdateDropMenu = CreateDropdown(SecDrop, "Vật Phẩm Trên Đất", {"Đang chờ..."}, "SelectedDrop", false)
CreateButton(SecDrop, "🔄 Quét Lại Map", function()
    local drops = {}
    for _, obj in pairs(workspace:GetDescendants()) do if obj:IsA("Tool") and obj.Parent ~= LocalPlayer.Character and obj.Parent ~= LocalPlayer.Backpack then table.insert(drops, obj.Name) end end
    if #drops == 0 then table.insert(drops, "Trống") end UpdateDropMenu(drops)
end)
local TeleDropBtn = CreateButton(SecDrop, "Bay Đến Lượm Đồ", function()
    if _G.SelectedDrop ~= "" and _G.SelectedDrop ~= "Trống" then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name == _G.SelectedDrop and obj:IsA("Tool") then
                local t = obj:FindFirstChild("Handle") or obj:FindFirstChildWhichIsA("Part")
                if t and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("HumanoidRootPart") then LocalPlayer.Character.HumanoidRootPart.CFrame = t.CFrame end
                break
            end
        end
    end
end)
TeleDropBtn.BackgroundColor3 = Colors.Green TeleDropBtn.TextColor3 = Colors.BG

local SecESP = CreateSection(TabItems, "ESP (Nhìn xuyên tường)")
CreateToggle(SecESP, "Bật ESP Item", "ESPItem")
CreateToggle(SecESP, "Bật ESP Boss", "ESPBoss")

-- VÒNG LẶP ESP
task.spawn(function()
    local ESP_Color = {Item = Color3.fromRGB(0, 255, 136), Boss = Color3.fromRGB(255, 50, 50)}
    while task.wait(1) do
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:FindFirstChild("Yui_ESP") then if (obj:IsA("Tool") and not _G.ESPItem) or (obj:IsA("Model") and not _G.ESPBoss) then obj.Yui_ESP:Destroy() end end
        end
        if _G.ESPItem then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Tool") and obj.Parent ~= LocalPlayer.Character and obj.Parent ~= LocalPlayer.Backpack and not obj:FindFirstChild("Yui_ESP") then
                    local bb = Instance.new("BillboardGui", obj) bb.Name = "Yui_ESP" bb.Size = UDim2.new(0, 150, 0, 30) bb.StudsOffset = Vector3.new(0, 2, 0) bb.AlwaysOnTop = true
                    local txt = Instance.new("TextLabel", bb) txt.Size = UDim2.new(1, 0, 1, 0) txt.BackgroundTransparency = 1 txt.Text = "[ ITEM ] " .. obj.Name txt.TextColor3 = ESP_Color.Item txt.TextScaled = true txt.Font = Enum.Font.GothamBold
                end
            end
        end
        if _G.ESPBoss then
            for _, obj in pairs(workspace:GetDescendants()) do
                if obj:IsA("Model") and (table.find(NormalBosses, obj.Name) or table.find(WorldBosses, obj.Name)) and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 and not obj:FindFirstChild("Yui_ESP") then
                    local bb = Instance.new("BillboardGui", obj) bb.Name = "Yui_ESP" bb.Size = UDim2.new(0, 150, 0, 30) bb.StudsOffset = Vector3.new(0, 4, 0) bb.AlwaysOnTop = true
                    local txt = Instance.new("TextLabel", bb) txt.Size = UDim2.new(1, 0, 1, 0) txt.BackgroundTransparency = 1 txt.Text = "[ BOSS ] " .. obj.Name txt.TextColor3 = ESP_Color.Boss txt.TextScaled = true txt.Font = Enum.Font.GothamBold
                end
            end
        end
    end
end)

-- ==========================================
-- 5. LOGIC DI CHUYỂN, ĐÁNH, SAFE, HAKI, COMBO
-- ==========================================
local function PreventFalling(hrp)
    if not hrp:FindFirstChild("AntiFall_Yui") then
        local bv = Instance.new("BodyVelocity")
        bv.Name = "AntiFall_Yui"
        bv.MaxForce = Vector3.new(9e9, 9e9, 9e9)
        bv.Velocity = Vector3.new(0,0,0)
        bv.Parent = hrp
    end
end
local function AllowFalling(hrp) if hrp:FindFirstChild("AntiFall_Yui") then hrp.AntiFall_Yui:Destroy() end end

-- AUTO HAKI THÔNG MINH (Không bật đè)
task.spawn(function()
    while task.wait(1) do
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then continue end

        if _G.AutoBuso then
            local hasBuso = char:FindFirstChild("Buso") or char:FindFirstChild("Haki")
            if not hasBuso then
                for _, v in pairs(char:GetChildren()) do if v:IsA("Part") and v.Name:match("Arm") and (v.Color == Color3.new(0,0,0) or v.Material == Enum.Material.Neon) then hasBuso = true break end end
            end
            if not hasBuso then
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.B, false, game) task.wait(0.1) VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.B, false, game)
            end
        end

        if _G.AutoKen then
            local hasKen = char:FindFirstChild("Ken") or char:FindFirstChild("Observation")
            if not hasKen then
                VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.V, false, game) task.wait(0.1) VirtualInputManager:SendKeyEvent(false, Enum.KeyCode.V, false, game)
            end
        end
    end
end)

-- Vòng lặp Safe Mode
task.spawn(function()
    while task.wait(0.5) do
        if _G.AutoSafe and LocalPlayer.Character and LocalPlayer.Character:FindFirstChild("Humanoid") then
            local hum = LocalPlayer.Character.Humanoid
            local hrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
            if hum.Health > 0 and hrp then
                local hpPercent = (hum.Health / hum.MaxHealth) * 100
                if hpPercent < _G.SafeHP then _G.IsHealing = true elseif hpPercent > 90 then _G.IsHealing = false end
                if _G.IsHealing then 
                    hrp.CFrame = CFrame.new(hrp.Position.X, math.max(hrp.Position.Y, 1500), hrp.Position.Z) 
                    PreventFalling(hrp) 
                end
            end
        end
    end
end)

local function GetOffsetCFrame(targetCFrame)
    local dist = _G.AtkDistance
    if _G.AtkPosition == "Trên Đầu" then return targetCFrame * CFrame.new(0, dist, 0) * CFrame.Angles(math.rad(-90), 0, 0)
    elseif _G.AtkPosition == "Sau Lưng" then return targetCFrame * CFrame.new(0, 0, dist)
    elseif _G.AtkPosition == "Trước Mặt" then return targetCFrame * CFrame.new(0, 0, -dist) * CFrame.Angles(0, math.rad(180), 0)
    elseif _G.AtkPosition == "Dưới Chân" then return targetCFrame * CFrame.new(0, -dist, 0) * CFrame.Angles(math.rad(90), 0, 0) end
    return targetCFrame * CFrame.new(0, 0, dist)
end

local function IsFarmingEnabled()
    if _G.AutoDuck or _G.AutoKyo or _G.AutoFarm then return true end
    for _, v in pairs(_G.FarmBosses) do if v then return true end end
    return false
end

local lastTargetIndex = 0
local function GetStrictTarget()
    if _G.AutoDuck then for _, obj in pairs(workspace:GetDescendants()) do if obj.Name == "Duck Boss" and obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then return obj end end return nil end
    if _G.IsHealing then return nil end
    if _G.AutoKyo then for _, obj in pairs(workspace:GetDescendants()) do if obj.Name == "Kyo" and obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then return obj end end return nil end

    local validTargets = {}
    for bName, isSelected in pairs(_G.FarmBosses) do
        if isSelected then
            for _, obj in pairs(workspace:GetDescendants()) do if obj.Name == bName and obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then table.insert(validTargets, obj) end end
        end
    end
    
    local isBossEnabled = false for _, v in pairs(_G.FarmBosses) do if v then isBossEnabled = true break end end
    if isBossEnabled then
        if #validTargets > 0 then
            if _G.SplitDamage then lastTargetIndex = lastTargetIndex + 1 if lastTargetIndex > #validTargets then lastTargetIndex = 1 end return validTargets[lastTargetIndex]
            else return validTargets[1] end
        else return nil end
    end

    if _G.AutoFarm then
        for mName, isSelected in pairs(_G.FarmMobs) do
            if isSelected then
                for _, obj in pairs(workspace:GetDescendants()) do if obj.Name == mName and obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then table.insert(validTargets, obj) end end
            end
        end
        if #validTargets > 0 then
            if _G.SplitDamage then lastTargetIndex = lastTargetIndex + 1 if lastTargetIndex > #validTargets then lastTargetIndex = 1 end return validTargets[lastTargetIndex]
            else return validTargets[1] end
        end
    end
    return nil
end

local function MoveToSafe(hrp, targetCFrame)
    local curPos = hrp.Position
    local tgtPos = targetCFrame.Position
    local distXZ = (Vector3.new(curPos.X, 0, curPos.Z) - Vector3.new(tgtPos.X, 0, tgtPos.Z)).Magnitude
    
    local dest
    if distXZ > 150 then
        if curPos.Y < 250 then dest = CFrame.new(curPos.X, 300, curPos.Z) 
        else dest = CFrame.new(tgtPos.X, curPos.Y, tgtPos.Z) end
    else
        dest = targetCFrame
    end

    if _G.MoveMethod == "Bay Mượt (Tween)" then
        local dist = (curPos - dest.Position).Magnitude
        if dist > 5 then
            local moveDir = (dest.Position - curPos).Unit
            local step = math.min(_G.FlySpeed * 0.05, dist)
            hrp.CFrame = CFrame.new(curPos + moveDir * step, curPos + moveDir * step + dest.LookVector) * CFrame.Angles(dest:ToEulerAnglesXYZ())
            hrp.CFrame = hrp.CFrame:Lerp(dest, 0.5) 
        else
            hrp.CFrame = dest
        end
    else
        hrp.CFrame = dest
    end
end

-- VÒNG LẶP AUTO ĐỔI VŨ KHÍ / TRÁI ÁC QUỶ (COMBO)
task.spawn(function()
    while task.wait() do
        if not IsFarmingEnabled() or _G.IsHealing then task.wait(1) continue end
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 then task.wait(1) continue end

        if _G.AutoSwitchWeaponFruit then
            for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                if tool:IsA("Tool") and _G.SelectedWeapons[tool.Name] then tool.Parent = char end
            end
            task.wait(_G.SwitchDelay)
            
            char = LocalPlayer.Character
            if char and char:FindFirstChild("Humanoid") and char.Humanoid.Health > 0 then
                for _, tool in pairs(char:GetChildren()) do
                    if tool:IsA("Tool") then tool.Parent = LocalPlayer.Backpack end
                end
            end
            task.wait(_G.SwitchDelay)
        else
            if _G.AutoWeapon then
                for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
                    if tool:IsA("Tool") and _G.SelectedWeapons[tool.Name] then tool.Parent = char end
                end
                task.wait(1)
            else
                task.wait(1)
            end
        end
    end
end)

-- FLASH ATTACK (SIÊU TỐC RENDER)
task.spawn(function()
    RunService.RenderStepped:Connect(function()
        if _G.FastAttack and IsFarmingEnabled() and not _G.IsHealing then
            local char = LocalPlayer.Character
            if char then
                for _, tool in pairs(char:GetChildren()) do
                    if tool:IsA("Tool") then tool:Activate() end
                end
            end
        end
    end)
end)

-- VÒNG LẶP DI CHUYỂN VÀ ĐÁNH 
task.spawn(function()
    while task.wait() do
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("Humanoid") or char.Humanoid.Health <= 0 or not char:FindFirstChild("HumanoidRootPart") then 
            task.wait(1) 
            continue 
        end
        local hrp = char.HumanoidRootPart

        if not _G.IsHealing and IsFarmingEnabled() then
            local targetMob = GetStrictTarget()
            if targetMob then
                local attackStartTime = tick()
                while targetMob and targetMob:FindFirstChild("Humanoid") and targetMob.Humanoid.Health > 0 do
                    if not LocalPlayer.Character or not LocalPlayer.Character:FindFirstChild("Humanoid") or LocalPlayer.Character.Humanoid.Health <= 0 then break end
                    if _G.SplitDamage and (tick() - attackStartTime) >= _G.SplitTime then break end
                    if _G.IsHealing and not _G.AutoDuck then break end
                    if not IsFarmingEnabled() then break end
                    
                    pcall(function()
                        local currentHrp = LocalPlayer.Character:FindFirstChild("HumanoidRootPart")
                        if currentHrp then
                            local dest = GetOffsetCFrame(targetMob.HumanoidRootPart.CFrame)
                            PreventFalling(currentHrp)
                            MoveToSafe(currentHrp, dest)
                            
                            -- Đánh thường (Bình thường)
                            if _G.AutoAttack and not _G.FastAttack then
                                for _, tool in pairs(LocalPlayer.Character:GetChildren()) do if tool:IsA("Tool") then tool:Activate() end end
                            end
                        end
                    end)
                    task.wait(0.03)
                end
            else
                AllowFalling(hrp)
            end
        end
    end
end)

-- VÒNG LẶP SKILL 
task.spawn(function()
    while task.wait(0.2) do
        if not _G.IsHealing and _G.AutoSkill and IsFarmingEnabled() then
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

-- VÒNG LẶP SPAM LẤY KIẾM KIRITO
task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoKirito then
            pcall(function()
                local clickDetector = workspace.Shop["Special Weapon"]["Dual Sword"]:FindFirstChildWhichIsA("ClickDetector", true)
                if clickDetector then fireclickdetector(clickDetector) end
            end)
        end
    end
end)
