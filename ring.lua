-- ==========================================
-- 1. KHỞI TẠO GIAO DIỆN CHỐNG LỖI (RAW LUA)
-- ==========================================
local CoreGui = game:GetService("CoreGui")
local Player = game.Players.LocalPlayer
local VirtualInputManager = game:GetService("VirtualInputManager")

local existingUI = CoreGui:FindFirstChild("RockFruitProUI") or Player:WaitForChild("PlayerGui"):FindFirstChild("RockFruitProUI")
if existingUI then existingUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RockFruitProUI"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = Player:WaitForChild("PlayerGui") end

-- KHUNG CHÍNH (MAIN WINDOW)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 560, 0, 360)
MainFrame.Position = UDim2.new(0.5, -280, 0.4, -180)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 150, 255)
MainFrame.Active = true
MainFrame.Draggable = true

local TitleBar = Instance.new("TextLabel", MainFrame)
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TitleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleBar.Text = "  Yui HUB Custom - PRO FARM"
TitleBar.Font = Enum.Font.GothamBold
TitleBar.TextSize = 14
TitleBar.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", TitleBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Text = "X"
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 16
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- TẠO TAB & CONTENT
local TabContainer = Instance.new("Frame", MainFrame)
TabContainer.Size = UDim2.new(0, 120, 1, -30)
TabContainer.Position = UDim2.new(0, 0, 0, 30)
TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
local TabListLayout = Instance.new("UIListLayout", TabContainer)
TabListLayout.Padding = UDim.new(0, 5)

local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Size = UDim2.new(1, -120, 1, -30)
ContentContainer.Position = UDim2.new(0, 120, 0, 30)
ContentContainer.BackgroundTransparency = 1

-- BIẾN TOÀN CỤC
_G.SelectedMobs = {}
_G.AutoFarm = false
_G.AutoAttack = false
_G.AutoEquip = false
_G.SelectedWeapon = "Chưa chọn"
_G.AttackPos = "Trên đầu" -- Vị trí
_G.AttackDist = 5 -- Khoảng cách
_G.AutoZ = false _G.AutoX = false _G.AutoC = false _G.AutoV = false _G.AutoB = false

local Tabs = {}
local function CreateTabButton(name, isFirst)
    local btn = Instance.new("TextButton", TabContainer)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = isFirst and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(25, 25, 25)
    btn.TextColor3 = isFirst and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(200, 200, 200)
    btn.Text = name
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 12
    
    local contentFrame = Instance.new("Frame", ContentContainer)
    contentFrame.Size = UDim2.new(1, 0, 1, 0)
    contentFrame.BackgroundTransparency = 1
    contentFrame.Visible = isFirst
    
    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do
            t.Btn.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
            t.Btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            t.Content.Visible = false
        end
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        btn.TextColor3 = Color3.fromRGB(0, 150, 255)
        contentFrame.Visible = true
    end)
    table.insert(Tabs, {Btn = btn, Content = contentFrame})
    return contentFrame
end

-- ==========================================
-- TAB 1: FARM MOBS (CÓ VỊ TRÍ, KHOẢNG CÁCH)
-- ==========================================
local FarmTab = CreateTabButton("Farm Mobs", true)
local FarmLeftCol = Instance.new("Frame", FarmTab)
FarmLeftCol.Size = UDim2.new(0.45, -10, 1, -20)
FarmLeftCol.Position = UDim2.new(0, 10, 0, 10)
FarmLeftCol.BackgroundTransparency = 1

-- CHUYỂN CỘT PHẢI THÀNH SCROLLING ĐỂ CHỨA NHIỀU NÚT
local FarmRightCol = Instance.new("ScrollingFrame", FarmTab)
FarmRightCol.Size = UDim2.new(0.55, -15, 1, -20)
FarmRightCol.Position = UDim2.new(0.45, 5, 0, 10)
FarmRightCol.BackgroundTransparency = 1
FarmRightCol.ScrollBarThickness = 3
local RightLayout = Instance.new("UIListLayout", FarmRightCol)
RightLayout.Padding = UDim.new(0, 5)

-- [ CỘT TRÁI - LIST QUÁI ]
local MobDropBtn = Instance.new("TextButton", FarmLeftCol)
MobDropBtn.Size = UDim2.new(1, 0, 0, 30)
MobDropBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MobDropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MobDropBtn.Text = "Chọn Quái (▼)"
MobDropBtn.Font = Enum.Font.GothamBold

local MobScroll = Instance.new("ScrollingFrame", FarmLeftCol)
MobScroll.Size = UDim2.new(1, 0, 0, 210)
MobScroll.Position = UDim2.new(0, 0, 0, 35)
MobScroll.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MobScroll.ScrollBarThickness = 4
MobScroll.Visible = false
local MobLayout = Instance.new("UIListLayout", MobScroll)

MobDropBtn.MouseButton1Click:Connect(function()
    MobScroll.Visible = not MobScroll.Visible
    MobDropBtn.Text = MobScroll.Visible and "Đóng List (▲)" or "Chọn Quái (▼)"
end)

local RefreshMobsBtn = Instance.new("TextButton", FarmLeftCol)
RefreshMobsBtn.Size = UDim2.new(1, 0, 0, 30)
RefreshMobsBtn.Position = UDim2.new(0, 0, 1, -30)
RefreshMobsBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
RefreshMobsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshMobsBtn.Text = "🔄 Quét Folder 'mod'"
RefreshMobsBtn.Font = Enum.Font.GothamBold

local function LoadMobs()
    for _, c in ipairs(MobScroll:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
    _G.SelectedMobs = {}
    local foundMobs = {}
    local mobFolder = workspace:FindFirstChild("mod") or workspace:FindFirstChild("Mob") or workspace
    for _, v in pairs(mobFolder:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Name ~= Player.Name then
            if not table.find(foundMobs, v.Name) then table.insert(foundMobs, v.Name) end
        end
    end
    if #foundMobs == 0 then foundMobs = {"Bandit", "Monkey", "Boss"} end
    for _, mob in ipairs(foundMobs) do
        local btn = Instance.new("TextButton", MobScroll)
        btn.Size = UDim2.new(1, 0, 0, 25)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.Text = "☐ " .. mob
        btn.Font = Enum.Font.Gotham
        local isSel = false
        btn.MouseButton1Click:Connect(function()
            isSel = not isSel
            btn.Text = isSel and "☑ " .. mob or "☐ " .. mob
            btn.TextColor3 = isSel and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(200, 200, 200)
            if isSel then table.insert(_G.SelectedMobs, mob)
            else for i, v in ipairs(_G.SelectedMobs) do if v == mob then table.remove(_G.SelectedMobs, i) break end end end
        end)
    end
    MobScroll.CanvasSize = UDim2.new(0, 0, 0, #foundMobs * 25)
end
RefreshMobsBtn.MouseButton1Click:Connect(LoadMobs)
LoadMobs()

-- [ CỘT PHẢI - CÀI ĐẶT ]
local function CreateButton(parent, text, bgColor, action)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = bgColor
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text
    btn.Font = Enum.Font.GothamBold
    btn.MouseButton1Click:Connect(function() action(btn) end)
    return btn
end

-- Tự động quét vũ khí trong túi (Giải quyết lỗi không tìm thấy Melee/Combat)
local Weps = {"Chưa có vũ khí"}
local WepIdx = 1
local WepBtn = CreateButton(FarmRightCol, "Vũ khí: " .. Weps[1], Color3.fromRGB(50, 50, 50), function(btn)
    WepIdx = WepIdx + 1
    if WepIdx > #Weps then WepIdx = 1 end
    _G.SelectedWeapon = Weps[WepIdx]
    btn.Text = "Vũ khí: " .. _G.SelectedWeapon
end)

CreateButton(FarmRightCol, "🔄 Quét Túi Đồ (Lấy tên vũ khí)", Color3.fromRGB(0, 100, 200), function()
    Weps = {}
    for _, v in pairs(Player.Backpack:GetChildren()) do if v:IsA("Tool") then table.insert(Weps, v.Name) end end
    for _, v in pairs(Player.Character:GetChildren()) do if v:IsA("Tool") then table.insert(Weps, v.Name) end end
    if #Weps == 0 then table.insert(Weps, "Không tìm thấy đồ") end
    WepIdx = 1
    _G.SelectedWeapon = Weps[1]
    WepBtn.Text = "Vũ khí: " .. _G.SelectedWeapon
end)

-- Cài đặt vị trí & khoảng cách
local PosList = {"Trên đầu", "Dưới chân", "Sau lưng", "Trước mặt"}
local PosIdx = 1
CreateButton(FarmRightCol, "Vị trí: " .. PosList[1], Color3.fromRGB(80, 80, 40), function(btn)
    PosIdx = PosIdx + 1
    if PosIdx > #PosList then PosIdx = 1 end
    _G.AttackPos = PosList[PosIdx]
    btn.Text = "Vị trí: " .. _G.AttackPos
end)

local DistList = {3, 5, 8, 12, 15}
local DistIdx = 2
CreateButton(FarmRightCol, "Khoảng cách: 5", Color3.fromRGB(80, 80, 40), function(btn)
    DistIdx = DistIdx + 1
    if DistIdx > #DistList then DistIdx = 1 end
    _G.AttackDist = DistList[DistIdx]
    btn.Text = "Khoảng cách: " .. _G.AttackDist
end)

-- Toggles (Auto Farm, Equip, Attack)
local function CreateToggle(parent, text, varName)
    local state = false
    return CreateButton(parent, text .. ": TẮT", Color3.fromRGB(150, 40, 40), function(btn)
        state = not state
        btn.Text = state and text .. ": BẬT" or text .. ": TẮT"
        btn.BackgroundColor3 = state and Color3.fromRGB(40, 150, 40) or Color3.fromRGB(150, 40, 40)
        _G[varName] = state
    end)
end

CreateToggle(FarmRightCol, "Auto Equip", "AutoEquip")
CreateToggle(FarmRightCol, "Auto Farm", "AutoFarm")
CreateToggle(FarmRightCol, "Auto Attack", "AutoAttack")
FarmRightCol.CanvasSize = UDim2.new(0,0,0, 280) -- Cho phép cuộn để thấy hết nút

-- ==========================================
-- TAB 2: TELEPORT THÔNG MINH
-- ==========================================
local TeleportTab = CreateTabButton("Teleport", false)

local function TPToPart(name)
    local found = false
    -- Quét toàn bộ map để tìm tên NPC hoặc Đảo
    for _, v in pairs(workspace:GetDescendants()) do
        if v.Name == name then
            if v:IsA("Model") and v.PrimaryPart then
                Player.Character.HumanoidRootPart.CFrame = v.PrimaryPart.CFrame * CFrame.new(0, 3, 0)
                found = true; break
            elseif v:IsA("BasePart") then
                Player.Character.HumanoidRootPart.CFrame = v.CFrame * CFrame.new(0, 3, 0)
                found = true; break
            end
        end
    end
    if not found then print("Không tìm thấy mục tiêu trong map!") end
end

local function CreateTPSection(yPos, titleText, items)
    local Title = Instance.new("TextLabel", TeleportTab)
    Title.Size = UDim2.new(1, -20, 0, 20)
    Title.Position = UDim2.new(0, 10, 0, yPos)
    Title.BackgroundTransparency = 1
    Title.TextColor3 = Color3.fromRGB(0, 150, 255)
    Title.Text = titleText
    Title.Font = Enum.Font.GothamBold
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local DropBtn = Instance.new("TextButton", TeleportTab)
    DropBtn.Size = UDim2.new(0.6, 0, 0, 30)
    DropBtn.Position = UDim2.new(0, 10, 0, yPos + 25)
    DropBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
    DropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    DropBtn.Text = items[1]
    DropBtn.Font = Enum.Font.Gotham
    
    local idx = 1
    DropBtn.MouseButton1Click:Connect(function()
        idx = idx + 1
        if idx > #items then idx = 1 end
        DropBtn.Text = items[idx]
    end)
    
    local TpBtn = Instance.new("TextButton", TeleportTab)
    TpBtn.Size = UDim2.new(0.35, 0, 0, 30)
    TpBtn.Position = UDim2.new(0.65, 0, 0, yPos + 25)
    TpBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 200)
    TpBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TpBtn.Text = "Bay Tới"
    TpBtn.Font = Enum.Font.GothamBold
    TpBtn.MouseButton1Click:Connect(function() TPToPart(DropBtn.Text) end)
end

-- CHÚ Ý: Bạn có thể sửa tên trong ngoặc cho khớp với tên NPC trong game
CreateTPSection(10, "1. Teleport Maps (Đảo)", {"Starter Island", "Buggy Island", "Jungle", "Desert"})
CreateTPSection(80, "2. Teleport Quest NPC", {"Bandit Quest", "Monkey Quest", "Gorilla Quest"})
CreateTPSection(150, "3. Teleport Normal NPC", {"Sword Dealer", "Fruit Dealer", "Blacksmith"})

-- ==========================================
-- TAB 3: AUTO SKILLS
-- ==========================================
local SkillTab = CreateTabButton("Auto Skills", false)
local SkillListLayout = Instance.new("UIListLayout", SkillTab)
SkillListLayout.Padding = UDim.new(0, 10)
Instance.new("UIPadding", SkillTab).PaddingTop = UDim.new(0, 10)

CreateToggle(SkillTab, "Dùng Skill [Z]", "AutoZ")
CreateToggle(SkillTab, "Dùng Skill [X]", "AutoX")
CreateToggle(SkillTab, "Dùng Skill [C]", "AutoC")
CreateToggle(SkillTab, "Dùng Skill [V]", "AutoV")

-- ==========================================
-- VÒNG LẶP CHẠY CHỨC NĂNG (MAIN LOOP)
-- ==========================================
task.spawn(function()
    while task.wait(0.1) do
        
        -- 1. Tự động cầm vũ khí
        if _G.AutoEquip and Player.Character then
            for _, tool in pairs(Player.Backpack:GetChildren()) do
                if tool:IsA("Tool") and tool.Name == _G.SelectedWeapon then
                    Player.Character.Humanoid:EquipTool(tool)
                end
            end
        end

        -- 2. Tự động đánh (BỊ ĐỘNG - KHÔNG CHIẾM CHUỘT)
        if _G.AutoAttack and Player.Character then
            local tool = Player.Character:FindFirstChildOfClass("Tool")
            if tool then 
                -- Chỉ ép vũ khí kích hoạt, không đụng tới màn hình cảm ứng
                tool:Activate() 
            end
        end

        -- 3. Tự động xả Skill
        if _G.AutoFarm or _G.AutoAttack then
            if _G.AutoZ then VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game) task.wait(0.05) end
            if _G.AutoX then VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game) task.wait(0.05) end
            if _G.AutoC then VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game) task.wait(0.05) end
            if _G.AutoV then VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.V, false, game) task.wait(0.05) end
        end

        -- 4. Logic Auto Farm (VỊ TRÍ & KHOẢNG CÁCH)
        if _G.AutoFarm and #_G.SelectedMobs > 0 then
            local mobFolder = workspace:FindFirstChild("mod") or workspace:FindFirstChild("Mob") or workspace
            for _, mobName in pairs(_G.SelectedMobs) do
                local target = mobFolder:FindFirstChild(mobName)
                if target and target:FindFirstChild("HumanoidRootPart") and target:FindFirstChild("Humanoid") and target.Humanoid.Health > 0 then
                    
                    -- Tính toán CFrame tùy theo lựa chọn của bạn
                    local offset = CFrame.new(0, 0, 0)
                    local dist = _G.AttackDist
                    
                    if _G.AttackPos == "Trên đầu" then
                        offset = CFrame.new(0, dist, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                    elseif _G.AttackPos == "Dưới chân" then
                        offset = CFrame.new(0, -dist, 0) * CFrame.Angles(math.rad(90), 0, 0)
                    elseif _G.AttackPos == "Sau lưng" then
                        offset = CFrame.new(0, 0, dist)
                    elseif _G.AttackPos == "Trước mặt" then
                        offset = CFrame.new(0, 0, -dist) * CFrame.Angles(0, math.rad(180), 0)
                    end
                    
                    Player.Character.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * offset
                    break -- Farm từng con một
                end
            end
        end
        
    end
end)
