-- ==========================================
-- 1. HỆ THỐNG GIAO DIỆN (YUI HUB CUSTOM UI)
-- ==========================================
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local existingUI = CoreGui:FindFirstChild("YuiCustomHub") or Player:WaitForChild("PlayerGui"):FindFirstChild("YuiCustomHub")
if existingUI then existingUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YuiCustomHub"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = Player:WaitForChild("PlayerGui") end

-- KHUNG CHÍNH
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 600, 0, 400)
MainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(0, 170, 255)
Stroke.Thickness = 2

-- TIÊU ĐỀ
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 35)
TopBar.BackgroundTransparency = 1
local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -40, 1, 0)
Title.Position = UDim2.new(0, 15, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "Yui HUB Custom - ROCK FRUIT"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 14
Title.TextXAlignment = Enum.TextXAlignment.Left

local TitleLine = Instance.new("Frame", TopBar)
TitleLine.Size = UDim2.new(0, 3, 0, 18)
TitleLine.Position = UDim2.new(0, 5, 0.5, -9)
TitleLine.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
TitleLine.BorderSizePixel = 0

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- CONTAINER TAB VÀ NỘI DUNG
local TabContainer = Instance.new("Frame", MainFrame)
TabContainer.Size = UDim2.new(0, 130, 1, -45)
TabContainer.Position = UDim2.new(0, 10, 0, 40)
TabContainer.BackgroundTransparency = 1
local TabLayout = Instance.new("UIListLayout", TabContainer)
TabLayout.Padding = UDim.new(0, 5)

local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Size = UDim2.new(1, -150, 1, -45)
ContentContainer.Position = UDim2.new(0, 140, 0, 40)
ContentContainer.BackgroundTransparency = 1

-- ==========================================
-- THƯ VIỆN UI (TẠO NÚT CÔNG TẮC, SLIDER...)
-- ==========================================
local Tabs = {}
local function CreateTab(name, isFirst)
    local btn = Instance.new("TextButton", TabContainer)
    btn.Size = UDim2.new(1, 0, 0, 32)
    btn.BackgroundColor3 = isFirst and Color3.fromRGB(30, 30, 30) or Color3.fromRGB(15, 15, 15)
    btn.TextColor3 = isFirst and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
    btn.Text = "  " .. name
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    
    local Indicator = Instance.new("Frame", btn)
    Indicator.Size = UDim2.new(0, 3, 1, -10)
    Indicator.Position = UDim2.new(0, 0, 0, 5)
    Indicator.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    Indicator.BorderSizePixel = 0
    Indicator.Visible = isFirst

    local page = Instance.new("ScrollingFrame", ContentContainer)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.ScrollBarThickness = 3
    page.Visible = isFirst
    local pageLayout = Instance.new("UIListLayout", page)
    pageLayout.Padding = UDim.new(0, 8)
    
    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
            t.Btn.TextColor3 = Color3.fromRGB(150, 150, 150)
            t.Btn.Indicator.Visible = false
            t.Page.Visible = false
        end
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        btn.TextColor3 = Color3.fromRGB(255, 255, 255)
        Indicator.Visible = true
        page.Visible = true
    end)
    table.insert(Tabs, {Btn = btn, Page = page})
    return page
end

local function CreateToggle(parent, text, varName)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -10, 0, 35)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -60, 1, 0)
    label.Position = UDim2.new(0, 10, 0, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    
    -- Công tắc (Switch)
    local switchBg = Instance.new("Frame", frame)
    switchBg.Size = UDim2.new(0, 40, 0, 20)
    switchBg.Position = UDim2.new(1, -50, 0.5, -10)
    switchBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)
    
    local circle = Instance.new("Frame", switchBg)
    circle.Size = UDim2.new(0, 16, 0, 16)
    circle.Position = UDim2.new(0, 2, 0.5, -8)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        _G[varName] = state
        
        local goalCircle = {}
        local goalBg = {}
        if state then
            goalCircle.Position = UDim2.new(1, -18, 0.5, -8)
            goalBg.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
        else
            goalCircle.Position = UDim2.new(0, 2, 0.5, -8)
            goalBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end
        TweenService:Create(circle, TweenInfo.new(0.2), goalCircle):Play()
        TweenService:Create(switchBg, TweenInfo.new(0.2), goalBg):Play()
    end)
end

local function CreateButton(parent, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, -10, 0, 35)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.TextSize = 13
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 6)
    Instance.new("UIStroke", btn).Color = Color3.fromRGB(0, 100, 200)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function CreateSlider(parent, text, min, max, varName)
    local frame = Instance.new("Frame", parent)
    frame.Size = UDim2.new(1, -10, 0, 50)
    frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 6)
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -20, 0, 20)
    label.Position = UDim2.new(0, 10, 0, 5)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Text = text .. ": " .. min
    label.Font = Enum.Font.Gotham
    label.TextSize = 13
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local sliderBg = Instance.new("Frame", frame)
    sliderBg.Size = UDim2.new(1, -20, 0, 6)
    sliderBg.Position = UDim2.new(0, 10, 0, 30)
    sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)
    
    local fill = Instance.new("Frame", sliderBg)
    fill.Size = UDim2.new(0, 0, 1, 0)
    fill.BackgroundColor3 = Color3.fromRGB(0, 170, 255)
    Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    
    local btn = Instance.new("TextButton", sliderBg)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    
    local isDragging = false
    local function updateSlider(input)
        local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos)
        fill.Size = UDim2.new(pos, 0, 1, 0)
        label.Text = text .. ": " .. val
        _G[varName] = val
    end
    
    btn.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = true
            updateSlider(input)
        end
    end)
    game:GetService("UserInputService").InputEnded:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            isDragging = false
        end
    end)
    game:GetService("UserInputService").InputChanged:Connect(function(input)
        if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
            updateSlider(input)
        end
    end)
end

-- ==========================================
-- BIẾN TOÀN CỤC CHÍNH
-- ==========================================
_G.SelectedMobs = {}
_G.SelectedWeapons = {} -- Chọn nhiều vũ khí
_G.AutoFarm = false
_G.AutoAttack = false
_G.AutoEquip = false
_G.AttackPos = "Trên đầu"
_G.AttackDist = 5
_G.AutoZ, _G.AutoX, _G.AutoC, _G.AutoV = false, false, false, false

-- Biến Player
_G.WalkSpeed = 16
_G.JumpPower = 50
_G.Noclip = false
_G.Fly = false

-- ==========================================
-- XÂY DỰNG CÁC TAB
-- ==========================================

-- 1. TAB MAIN (FARM MOBS)
local TabMain = CreateTab("Main", true)

-- Dropdown Chọn Quái (Multi)
local MobDropBtn = CreateButton(TabMain, "Danh Sách Quái (▼)", function() end)
local MobScroll = Instance.new("ScrollingFrame", TabMain)
MobScroll.Size = UDim2.new(1, -10, 0, 150)
MobScroll.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MobScroll.Visible = false
local MobLayout = Instance.new("UIListLayout", MobScroll)

MobDropBtn.MouseButton1Click:Connect(function()
    MobScroll.Visible = not MobScroll.Visible
    MobDropBtn.Text = MobScroll.Visible and "Đóng Danh Sách (▲)" or "Danh Sách Quái (▼)"
end)

local function LoadMobs()
    for _, c in ipairs(MobScroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    _G.SelectedMobs = {}
    local foundMobs = {}
    local folder = workspace:FindFirstChild("mod") or workspace:FindFirstChild("Mob") or workspace
    for _, v in pairs(folder:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Name ~= Player.Name then
            if not table.find(foundMobs, v.Name) then table.insert(foundMobs, v.Name) end
        end
    end
    for _, mob in ipairs(foundMobs) do
        local btn = Instance.new("TextButton", MobScroll)
        btn.Size = UDim2.new(1, 0, 0, 30)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.Text = "  ☐ " .. mob
        btn.Font = Enum.Font.Gotham
        btn.TextXAlignment = Enum.TextXAlignment.Left
        local isSel = false
        btn.MouseButton1Click:Connect(function()
            isSel = not isSel
            btn.Text = isSel and "  ☑ " .. mob or "  ☐ " .. mob
            btn.TextColor3 = isSel and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(200, 200, 200)
            if isSel then table.insert(_G.SelectedMobs, mob)
            else for i, v in ipairs(_G.SelectedMobs) do if v == mob then table.remove(_G.SelectedMobs, i) break end end end
        end)
    end
    MobScroll.CanvasSize = UDim2.new(0, 0, 0, #foundMobs * 30)
end
CreateButton(TabMain, "🔄 Quét Lại Quái", LoadMobs)
LoadMobs()

-- Dropdown Chọn Vũ Khí (Multi - Cho phép cầm nhiều sức mạnh)
local WepDropBtn = CreateButton(TabMain, "Chọn Vũ Khí (▼)", function() end)
local WepScroll = Instance.new("ScrollingFrame", TabMain)
WepScroll.Size = UDim2.new(1, -10, 0, 100)
WepScroll.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
WepScroll.Visible = false
local WepLayout = Instance.new("UIListLayout", WepScroll)

WepDropBtn.MouseButton1Click:Connect(function()
    WepScroll.Visible = not WepScroll.Visible
end)

local function LoadWeps()
    for _, c in ipairs(WepScroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    _G.SelectedWeapons = {}
    local foundWeps = {}
    for _, v in pairs(Player.Backpack:GetChildren()) do if v:IsA("Tool") then table.insert(foundWeps, v.Name) end end
    for _, v in pairs(Player.Character:GetChildren()) do if v:IsA("Tool") then table.insert(foundWeps, v.Name) end end
    
    for _, wep in ipairs(foundWeps) do
        local btn = Instance.new("TextButton", WepScroll)
        btn.Size = UDim2.new(1, 0, 0, 30)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.Text = "  ☐ " .. wep
        btn.Font = Enum.Font.Gotham
        btn.TextXAlignment = Enum.TextXAlignment.Left
        local isSel = false
        btn.MouseButton1Click:Connect(function()
            isSel = not isSel
            btn.Text = isSel and "  ☑ " .. wep or "  ☐ " .. wep
            btn.TextColor3 = isSel and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(200, 200, 200)
            if isSel then table.insert(_G.SelectedWeapons, wep)
            else for i, v in ipairs(_G.SelectedWeapons) do if v == wep then table.remove(_G.SelectedWeapons, i) break end end end
        end)
    end
    WepScroll.CanvasSize = UDim2.new(0, 0, 0, #foundWeps * 30)
end
CreateButton(TabMain, "🔄 Quét Túi Đồ", LoadWeps)

-- Các nút bật tắt Farm ngay gần list
CreateToggle(TabMain, "Tự Động Cầm Vũ Khí", "AutoEquip")
CreateToggle(TabMain, "Tự Động Farm", "AutoFarm")
CreateToggle(TabMain, "Tự Động Click (Đánh)", "AutoAttack")

-- 2. TAB SETTING (Cài đặt góc đánh)
local TabSetting = CreateTab("Setting", false)
local PosList = {"Trên đầu", "Dưới chân", "Sau lưng", "Trước mặt"}
local PosIdx = 1
local PosBtn = CreateButton(TabSetting, "Góc Đánh: " .. PosList[1], function() end)
PosBtn.MouseButton1Click:Connect(function()
    PosIdx = PosIdx + 1
    if PosIdx > #PosList then PosIdx = 1 end
    _G.AttackPos = PosList[PosIdx]
    PosBtn.Text = "Góc Đánh: " .. _G.AttackPos
end)
CreateSlider(TabSetting, "Khoảng Cách Đánh", 0, 20, "AttackDist")

CreateToggle(TabSetting, "Tự Động Skill Z", "AutoZ")
CreateToggle(TabSetting, "Tự Động Skill X", "AutoX")
CreateToggle(TabSetting, "Tự Động Skill C", "AutoC")
CreateToggle(TabSetting, "Tự Động Skill V", "AutoV")

-- 3. TAB TELEPORT
local TabTeleport = CreateTab("Teleport", false)
local function CreateTPMenu(title, list)
    local Label = Instance.new("TextLabel", TabTeleport)
    Label.Size = UDim2.new(1, 0, 0, 25)
    Label.BackgroundTransparency = 1
    Label.TextColor3 = Color3.fromRGB(0, 170, 255)
    Label.Text = "◆ " .. title
    Label.Font = Enum.Font.GothamBold
    Label.TextXAlignment = Enum.TextXAlignment.Left
    
    local Drop = CreateButton(TabTeleport, list[1], function() end)
    local idx = 1
    Drop.MouseButton1Click:Connect(function()
        idx = idx + 1
        if idx > #list then idx = 1 end
        Drop.Text = list[idx]
    end)
    
    CreateButton(TabTeleport, "✈️ Bay Tới Đích", function()
        -- Quét toàn map thay vì 1 folder cố định để fix lỗi NPC
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name == Drop.Text then
                if v:IsA("Model") and v.PrimaryPart then
                    Player.Character.HumanoidRootPart.CFrame = v.PrimaryPart.CFrame * CFrame.new(0, 3, 0)
                elseif v:IsA("BasePart") then
                    Player.Character.HumanoidRootPart.CFrame = v.CFrame * CFrame.new(0, 3, 0)
                end
                break
            end
        end
    end)
end
CreateTPMenu("Đảo & Khu Vực", {"Starter Island", "Jungle", "Desert", "Snow"})
CreateTPMenu("Quest & NPC", {"Bandit Quest", "Sword Dealer", "Fruit Dealer"})

-- 4. TAB PLAYER
local TabPlayer = CreateTab("Player", false)
CreateSlider(TabPlayer, "Tốc Độ Chạy (WalkSpeed)", 16, 200, "WalkSpeed")
CreateSlider(TabPlayer, "Sức Bật (JumpPower)", 50, 300, "JumpPower")
CreateToggle(TabPlayer, "Đi Xuyên Tường (Noclip)", "Noclip")
-- Logic WalkSpeed/JumpPower & Noclip
RunService.Stepped:Connect(function()
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = _G.WalkSpeed
        Player.Character.Humanoid.JumpPower = _G.JumpPower
    end
    if _G.Noclip and Player.Character then
        for _, v in pairs(Player.Character:GetChildren()) do
            if v:IsA("BasePart") then v.CanCollide = false end
        end
    end
end)

-- 5. TAB SERVER
local TabServer = CreateTab("Server", false)
CreateButton(TabServer, "Tối Ưu FPS (Giảm Lag)", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then
            v.Material = Enum.Material.SmoothPlastic
            v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") then
            v:Destroy()
        end
    end
    game.Lighting.GlobalShadows = false
    game.Lighting.FogEnd = 9e9
end)
CreateButton(TabServer, "Xóa Hiệu Ứng (Remove Effects)", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("ParticleEmitter") or v:IsA("Trail") or v:IsA("Sparkles") or v:IsA("Fire") then v:Destroy() end
    end
end)
CreateButton(TabServer, "Rejoin (Vào Lại Server Cũ)", function()
    TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Player)
end)
CreateButton(TabServer, "Hop Server Ít Người (Low Server)", function()
    local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")).data
    for _, server in pairs(servers) do
        if server.playing < server.maxPlayers and server.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, Player)
            break
        end
    end
end)

-- ==========================================
-- VÒNG LẶP AUTO FARM (MAIN LOOP)
-- ==========================================
task.spawn(function()
    while task.wait(0.1) do
        
        -- Auto Equip Multi-Weapon
        if _G.AutoEquip and Player.Character then
            for _, wepName in pairs(_G.SelectedWeapons) do
                local tool = Player.Backpack:FindFirstChild(wepName)
                if tool then Player.Character.Humanoid:EquipTool(tool) end
            end
        end

        -- Auto Attack (Bị động, Fix loạn cảm ứng)
        if _G.AutoAttack and Player.Character then
            for _, tool in pairs(Player.Character:GetChildren()) do
                if tool:IsA("Tool") then tool:Activate() end
            end
        end

        -- Auto Skill
        if _G.AutoFarm or _G.AutoAttack then
            if _G.AutoZ then VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game) end
            if _G.AutoX then VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game) end
            if _G.AutoC then VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game) end
            if _G.AutoV then VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.V, false, game) end
        end

        -- Auto Farm (Fix Lỗi Teleport Tứ Tung)
        if _G.AutoFarm and #_G.SelectedMobs > 0 then
            local folder = workspace:FindFirstChild("mod") or workspace:FindFirstChild("Mob") or workspace
            local targetFound = false
            
            for _, mobName in pairs(_G.SelectedMobs) do
                local target = folder:FindFirstChild(mobName)
                -- Kiểm tra máu > 0 để tránh tele vào xác quái
                if target and target:FindFirstChild("HumanoidRootPart") and target:FindFirstChild("Humanoid") and target.Humanoid.Health > 0 then
                    targetFound = true
                    local hrp = Player.Character.HumanoidRootPart
                    
                    -- Reset vận tốc rơi tự do để không bị văng vọt lên trời
                    hrp.Velocity = Vector3.new(0, 0, 0) 
                    
                    local offset = CFrame.new(0, 0, 0)
                    local dist = _G.AttackDist
                    
                    if _G.AttackPos == "Trên đầu" then offset = CFrame.new(0, dist, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                    elseif _G.AttackPos == "Dưới chân" then offset = CFrame.new(0, -dist, 0) * CFrame.Angles(math.rad(90), 0, 0)
                    elseif _G.AttackPos == "Sau lưng" then offset = CFrame.new(0, 0, dist)
                    elseif _G.AttackPos == "Trước mặt" then offset = CFrame.new(0, 0, -dist) * CFrame.Angles(0, math.rad(180), 0)
                    end
                    
                    hrp.CFrame = target.HumanoidRootPart.CFrame * offset
                    break -- Đánh xong 1 con sống rồi mới quét con khác
                end
            end
        end
        
    end
end)
