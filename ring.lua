-- ==========================================
-- 1. HỆ THỐNG GIAO DIỆN (MOBILE FRIENDLY - YUI HUB CLONE)
-- ==========================================
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local existingUI = CoreGui:FindFirstChild("YuiMobileHub") or Player:WaitForChild("PlayerGui"):FindFirstChild("YuiMobileHub")
if existingUI then existingUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YuiMobileHub"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = Player:WaitForChild("PlayerGui") end

-- KHUNG CHÍNH (THU NHỎ CHO ĐIỆN THOẠI: 480x280)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 480, 0, 280)
MainFrame.Position = UDim2.new(0.5, -240, 0.5, -140)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)
local Stroke = Instance.new("UIStroke", MainFrame)
Stroke.Color = Color3.fromRGB(0, 150, 255)
Stroke.Thickness = 1.5

-- TIÊU ĐỀ
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 25)
TopBar.BackgroundTransparency = 1
local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -30, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "Yui HUB - ROCK FRUIT (Mobile)"
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left

local TitleLine = Instance.new("Frame", TopBar)
TitleLine.Size = UDim2.new(0, 2, 0, 12)
TitleLine.Position = UDim2.new(0, 4, 0.5, -6)
TitleLine.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
TitleLine.BorderSizePixel = 0

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 25)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 14
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- CỘT TAB (TRÁI) VÀ NỘI DUNG (PHẢI)
local TabContainer = Instance.new("ScrollingFrame", MainFrame)
TabContainer.Size = UDim2.new(0, 110, 1, -30)
TabContainer.Position = UDim2.new(0, 5, 0, 25)
TabContainer.BackgroundTransparency = 1
TabContainer.ScrollBarThickness = 0
local TabLayout = Instance.new("UIListLayout", TabContainer)
TabLayout.Padding = UDim.new(0, 3)

local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Size = UDim2.new(1, -125, 1, -30)
ContentContainer.Position = UDim2.new(0, 120, 0, 25)
ContentContainer.BackgroundTransparency = 1

-- ==========================================
-- THƯ VIỆN CHIA MỤC (SECTION) GIỐNG ẢNH
-- ==========================================
local Tabs = {}
local function CreateTab(name, isFirst)
    local btn = Instance.new("TextButton", TabContainer)
    btn.Size = UDim2.new(1, 0, 0, 28)
    btn.BackgroundColor3 = isFirst and Color3.fromRGB(30, 30, 30) or Color3.fromRGB(15, 15, 15)
    btn.TextColor3 = isFirst and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150)
    btn.Text = "  " .. name
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 11
    btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    
    local Indicator = Instance.new("Frame", btn)
    Indicator.Size = UDim2.new(0, 2, 1, -10)
    Indicator.Position = UDim2.new(0, 0, 0, 5)
    Indicator.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
    Indicator.BorderSizePixel = 0
    Indicator.Visible = isFirst

    -- Khung chứa 2 cột cho mỗi Tab
    local page = Instance.new("Frame", ContentContainer)
    page.Size = UDim2.new(1, 0, 1, 0)
    page.BackgroundTransparency = 1
    page.Visible = isFirst
    
    local LeftCol = Instance.new("ScrollingFrame", page)
    LeftCol.Size = UDim2.new(0.5, -4, 1, 0)
    LeftCol.BackgroundTransparency = 1
    LeftCol.ScrollBarThickness = 2
    local LeftLayout = Instance.new("UIListLayout", LeftCol)
    LeftLayout.Padding = UDim.new(0, 5)
    
    local RightCol = Instance.new("ScrollingFrame", page)
    RightCol.Size = UDim2.new(0.5, -4, 1, 0)
    RightCol.Position = UDim2.new(0.5, 4, 0, 0)
    RightCol.BackgroundTransparency = 1
    RightCol.ScrollBarThickness = 2
    local RightLayout = Instance.new("UIListLayout", RightCol)
    RightLayout.Padding = UDim.new(0, 5)
    
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
    return LeftCol, RightCol
end

local function CreateSection(parentCol, titleText)
    local sec = Instance.new("Frame", parentCol)
    sec.Size = UDim2.new(1, 0, 0, 0) -- Tự động dãn
    sec.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Instance.new("UICorner", sec).CornerRadius = UDim.new(0, 4)
    Instance.new("UIStroke", sec).Color = Color3.fromRGB(40, 40, 40)
    
    local title = Instance.new("TextLabel", sec)
    title.Size = UDim2.new(1, -10, 0, 20)
    title.Position = UDim2.new(0, 5, 0, 0)
    title.BackgroundTransparency = 1
    title.TextColor3 = Color3.fromRGB(0, 150, 255)
    title.Text = titleText
    title.Font = Enum.Font.GothamBold
    title.TextSize = 11
    title.TextXAlignment = Enum.TextXAlignment.Left
    
    local layout = Instance.new("UIListLayout", sec)
    layout.Padding = UDim.new(0, 3)
    layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    
    -- Khung đệm phía trên cho title
    local pad = Instance.new("Frame", sec)
    pad.Size = UDim2.new(1, 0, 0, 20)
    pad.BackgroundTransparency = 1
    
    -- Tự động điều chỉnh chiều cao section theo nội dung
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        sec.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y + 5)
    end)
    return sec
end

-- ==========================================
-- CÁC NÚT (CÔNG TẮC, DROPDOWN, BUTTON) NHỎ GỌN
-- ==========================================
local function CreateToggle(parentSec, text, varName)
    local frame = Instance.new("Frame", parentSec)
    frame.Size = UDim2.new(1, -10, 0, 24)
    frame.BackgroundTransparency = 1
    
    local label = Instance.new("TextLabel", frame)
    label.Size = UDim2.new(1, -40, 1, 0)
    label.BackgroundTransparency = 1
    label.TextColor3 = Color3.fromRGB(200, 200, 200)
    label.Text = text
    label.Font = Enum.Font.Gotham
    label.TextSize = 11
    label.TextXAlignment = Enum.TextXAlignment.Left
    
    local btn = Instance.new("TextButton", frame)
    btn.Size = UDim2.new(1, 0, 1, 0)
    btn.BackgroundTransparency = 1
    btn.Text = ""
    
    local switchBg = Instance.new("Frame", frame)
    switchBg.Size = UDim2.new(0, 30, 0, 14)
    switchBg.Position = UDim2.new(1, -30, 0.5, -7)
    switchBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)
    
    local circle = Instance.new("Frame", switchBg)
    circle.Size = UDim2.new(0, 10, 0, 10)
    circle.Position = UDim2.new(0, 2, 0.5, -5)
    circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        _G[varName] = state
        
        local goalCircle = {}
        local goalBg = {}
        if state then
            goalCircle.Position = UDim2.new(1, -12, 0.5, -5)
            goalBg.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
        else
            goalCircle.Position = UDim2.new(0, 2, 0.5, -5)
            goalBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        end
        TweenService:Create(circle, TweenInfo.new(0.2), goalCircle):Play()
        TweenService:Create(switchBg, TweenInfo.new(0.2), goalBg):Play()
    end)
end

local function CreateButton(parentSec, text, callback)
    local btn = Instance.new("TextButton", parentSec)
    btn.Size = UDim2.new(1, -10, 0, 24)
    btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text
    btn.Font = Enum.Font.Gotham
    btn.TextSize = 11
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- ==========================================
-- BIẾN TOÀN CỤC CHÍNH
-- ==========================================
_G.SelectedMobs = {}
_G.SelectedWeapons = {}
_G.AutoFarm = false
_G.AutoAttack = false
_G.AutoEquip = false
_G.AttackPos = "Trên đầu"
_G.AttackDist = 5
_G.AutoZ, _G.AutoX, _G.AutoC, _G.AutoV = false, false, false, false
_G.WalkSpeed, _G.JumpPower, _G.Noclip = 16, 50, false

-- ==========================================
-- XÂY DỰNG CÁC TAB CHÍNH
-- ==========================================

-- [1] TAB FARM MOBS
local FarmLeft, FarmRight = CreateTab("Farm Mobs", true)

-- Mục: Chọn Quái (Trái)
local SecMob = CreateSection(FarmLeft, "Mob Selection")
local MobDropBtn = CreateButton(SecMob, "Danh Sách Quái ▼", function() end)
local MobScroll = Instance.new("ScrollingFrame", SecMob)
MobScroll.Size = UDim2.new(1, -10, 0, 100)
MobScroll.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
MobScroll.Visible = false
local MobLayout = Instance.new("UIListLayout", MobScroll)

MobDropBtn.MouseButton1Click:Connect(function()
    MobScroll.Visible = not MobScroll.Visible
    MobDropBtn.Text = MobScroll.Visible and "Đóng List Quái ▲" or "Danh Sách Quái ▼"
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
        btn.Size = UDim2.new(1, 0, 0, 22)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.Text = "  ☐ " .. mob
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 10
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
    MobScroll.CanvasSize = UDim2.new(0, 0, 0, #foundMobs * 22)
end
CreateButton(SecMob, "🔄 Quét Lại Quái", LoadMobs)
LoadMobs()

-- Mục: Vũ Khí (Trái)
local SecWep = CreateSection(FarmLeft, "Auto Equip Weapon")
local WepDropBtn = CreateButton(SecWep, "Chọn Vũ Khí ▼", function() end)
local WepScroll = Instance.new("ScrollingFrame", SecWep)
WepScroll.Size = UDim2.new(1, -10, 0, 80)
WepScroll.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
WepScroll.Visible = false
local WepLayout = Instance.new("UIListLayout", WepScroll)

WepDropBtn.MouseButton1Click:Connect(function() WepScroll.Visible = not WepScroll.Visible end)

local function LoadWeps()
    for _, c in ipairs(WepScroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    _G.SelectedWeapons = {}
    local foundWeps = {}
    for _, v in pairs(Player.Backpack:GetChildren()) do if v:IsA("Tool") then table.insert(foundWeps, v.Name) end end
    for _, v in pairs(Player.Character:GetChildren()) do if v:IsA("Tool") then table.insert(foundWeps, v.Name) end end
    for _, wep in ipairs(foundWeps) do
        local btn = Instance.new("TextButton", WepScroll)
        btn.Size = UDim2.new(1, 0, 0, 22)
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.Text = "  ☐ " .. wep
        btn.Font = Enum.Font.Gotham
        btn.TextSize = 10
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
    WepScroll.CanvasSize = UDim2.new(0, 0, 0, #foundWeps * 22)
end
CreateButton(SecWep, "🔄 Quét Túi Đồ", LoadWeps)
CreateToggle(SecWep, "Tự Động Cầm", "AutoEquip")

-- Mục: Cài Đặt Farm (Phải)
local SecFarm = CreateSection(FarmRight, "Farming Config")
CreateToggle(SecFarm, "Auto Attack", "AutoAttack")
CreateToggle(SecFarm, "Auto Farm", "AutoFarm")

-- [2] TAB SETTING
local SetLeft, SetRight = CreateTab("Setting", false)
local SecPos = CreateSection(SetLeft, "Attack Position")
local PosList = {"Trên đầu", "Dưới chân", "Sau lưng", "Trước mặt"}
local PosIdx = 1
local PosBtn = CreateButton(SecPos, "Vị Trí: Trên đầu", function() end)
PosBtn.MouseButton1Click:Connect(function()
    PosIdx = PosIdx + 1
    if PosIdx > #PosList then PosIdx = 1 end
    _G.AttackPos = PosList[PosIdx]
    PosBtn.Text = "Vị Trí: " .. _G.AttackPos
end)

local DistList = {3, 5, 8, 12, 15}
local DistIdx = 2
local DistBtn = CreateButton(SecPos, "Khoảng Cách: 5", function() end)
DistBtn.MouseButton1Click:Connect(function()
    DistIdx = DistIdx + 1
    if DistIdx > #DistList then DistIdx = 1 end
    _G.AttackDist = DistList[DistIdx]
    DistBtn.Text = "Khoảng Cách: " .. _G.AttackDist
end)

local SecSkill = CreateSection(SetRight, "Auto Skills")
CreateToggle(SecSkill, "Dùng Skill Z", "AutoZ")
CreateToggle(SecSkill, "Dùng Skill X", "AutoX")
CreateToggle(SecSkill, "Dùng Skill C", "AutoC")
CreateToggle(SecSkill, "Dùng Skill V", "AutoV")

-- [3] TAB TELEPORT
local TpLeft, TpRight = CreateTab("Teleport", false)
local SecMap = CreateSection(TpLeft, "Map & Island")
local MapList = {"Starter Island", "Jungle", "Desert", "Snow"}
local MapBtn = CreateButton(SecMap, "Đích: Starter Island", function() end)
local MapIdx = 1
MapBtn.MouseButton1Click:Connect(function()
    MapIdx = MapIdx + 1
    if MapIdx > #MapList then MapIdx = 1 end
    MapBtn.Text = "Đích: " .. MapList[MapIdx]
end)
CreateButton(SecMap, "✈️ Bay Tới", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == MapList[MapIdx] then
            if v:IsA("Model") and v.PrimaryPart then Player.Character.HumanoidRootPart.CFrame = v.PrimaryPart.CFrame * CFrame.new(0, 3, 0)
            elseif v:IsA("BasePart") then Player.Character.HumanoidRootPart.CFrame = v.CFrame * CFrame.new(0, 3, 0) end
            break
        end
    end
end)

local SecNpc = CreateSection(TpRight, "Quest & NPC")
local NpcList = {"Bandit Quest", "Sword Dealer", "Fruit Dealer"}
local NpcBtn = CreateButton(SecNpc, "Đích: Bandit Quest", function() end)
local NpcIdx = 1
NpcBtn.MouseButton1Click:Connect(function()
    NpcIdx = NpcIdx + 1
    if NpcIdx > #NpcList then NpcIdx = 1 end
    NpcBtn.Text = "Đích: " .. NpcList[NpcIdx]
end)
CreateButton(SecNpc, "✈️ Bay Tới", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == NpcList[NpcIdx] then
            if v:IsA("Model") and v.PrimaryPart then Player.Character.HumanoidRootPart.CFrame = v.PrimaryPart.CFrame * CFrame.new(0, 3, 0)
            elseif v:IsA("BasePart") then Player.Character.HumanoidRootPart.CFrame = v.CFrame * CFrame.new(0, 3, 0) end
            break
        end
    end
end)

-- [4] TAB PLAYER & SERVER
local MiscLeft, MiscRight = CreateTab("Misc", false)
local SecPlayer = CreateSection(MiscLeft, "Local Player")
CreateToggle(SecPlayer, "Đi Xuyên Tường", "Noclip")

RunService.Stepped:Connect(function()
    if _G.Noclip and Player.Character then
        for _, v in pairs(Player.Character:GetChildren()) do if v:IsA("BasePart") then v.CanCollide = false end end
    end
end)

local SecServer = CreateSection(MiscRight, "Server Info")
CreateButton(SecServer, "Hop Server Ít Người", function()
    local servers = HttpService:JSONDecode(game:HttpGet("https://games.roblox.com/v1/games/"..game.PlaceId.."/servers/Public?sortOrder=Asc&limit=100")).data
    for _, server in pairs(servers) do
        if server.playing < server.maxPlayers and server.id ~= game.JobId then
            TeleportService:TeleportToPlaceInstance(game.PlaceId, server.id, Player)
            break
        end
    end
end)
CreateButton(SecServer, "Tối Ưu FPS (Xóa Đồ Họa)", function()
    for _, v in pairs(workspace:GetDescendants()) do
        if v:IsA("BasePart") and not v.Parent:FindFirstChild("Humanoid") then v.Material = Enum.Material.SmoothPlastic v.Reflectance = 0
        elseif v:IsA("Decal") or v:IsA("Texture") or v:IsA("ParticleEmitter") then v:Destroy() end
    end
end)

-- ==========================================
-- VÒNG LẶP CHỐNG LỖI VĂNG LÊN TRỜI (MAIN LOOP)
-- ==========================================
task.spawn(function()
    while task.wait() do
        -- Xử lý Bộ đệm chống Văng/Rơi tự do (Chỉ tạo ra khi đang Farm)
        local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
        if hrp then
            local bv = hrp:FindFirstChild("AntiFlingBV")
            if _G.AutoFarm then
                if not bv then
                    bv = Instance.new("BodyVelocity")
                    bv.Name = "AntiFlingBV"
                    bv.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
                    bv.Velocity = Vector3.new(0, 0, 0) -- Giữ nhân vật lơ lửng ổn định ở 1 chỗ
                    bv.Parent = hrp
                end
            else
                if bv then bv:Destroy() end
            end
        end

        -- Tự cầm đồ
        if _G.AutoEquip and Player.Character then
            for _, wepName in pairs(_G.SelectedWeapons) do
                local tool = Player.Backpack:FindFirstChild(wepName)
                if tool then Player.Character.Humanoid:EquipTool(tool) end
            end
        end

        -- Tự click
        if _G.AutoAttack and Player.Character then
            for _, tool in pairs(Player.Character:GetChildren()) do if tool:IsA("Tool") then tool:Activate() end end
        end

        -- Tự Skill
        if _G.AutoFarm or _G.AutoAttack then
            if _G.AutoZ then VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game) end
            if _G.AutoX then VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game) end
            if _G.AutoC then VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game) end
            if _G.AutoV then VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.V, false, game) end
        end

        -- Tự bay đến đánh (Đã khóa vật lý chống văng)
        if _G.AutoFarm and hrp and #_G.SelectedMobs > 0 then
            local folder = workspace:FindFirstChild("mod") or workspace:FindFirstChild("Mob") or workspace
            for _, mobName in pairs(_G.SelectedMobs) do
                local target = folder:FindFirstChild(mobName)
                -- Kiểm tra quái phải SỐNG và TỒN TẠI HRP để tránh lỗi tele loạn xạ
                if target and target:FindFirstChild("HumanoidRootPart") and target:FindFirstChild("Humanoid") and target.Humanoid.Health > 0 then
                    
                    local offset = CFrame.new(0, 0, 0)
                    local dist = _G.AttackDist
                    
                    if _G.AttackPos == "Trên đầu" then offset = CFrame.new(0, dist, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                    elseif _G.AttackPos == "Dưới chân" then offset = CFrame.new(0, -dist, 0) * CFrame.Angles(math.rad(90), 0, 0)
                    elseif _G.AttackPos == "Sau lưng" then offset = CFrame.new(0, 0, dist)
                    elseif _G.AttackPos == "Trước mặt" then offset = CFrame.new(0, 0, -dist) * CFrame.Angles(0, math.rad(180), 0)
                    end
                    
                    hrp.CFrame = target.HumanoidRootPart.CFrame * offset
                    break -- Farm xong con này mới nhảy qua con khác
                end
            end
        end
        
    end
end)
