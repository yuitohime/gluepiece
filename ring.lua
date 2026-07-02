-- ==========================================
-- 1. TẠO GIAO DIỆN (RAW LUA - CHỐNG LỖI 100%)
-- ==========================================
local CoreGui = game:GetService("CoreGui")
local Player = game.Players.LocalPlayer
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")

local existingUI = CoreGui:FindFirstChild("RockFruitCustomUI") or Player:WaitForChild("PlayerGui"):FindFirstChild("RockFruitCustomUI")
if existingUI then existingUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "RockFruitCustomUI"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = Player:WaitForChild("PlayerGui") end

-- KHUNG CHÍNH (MAIN WINDOW)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 550, 0, 350)
MainFrame.Position = UDim2.new(0.5, -275, 0.4, -175)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.BorderSizePixel = 2
MainFrame.BorderColor3 = Color3.fromRGB(0, 150, 255) -- Viền xanh dương giống ảnh
MainFrame.Active = true
MainFrame.Draggable = true

-- TIÊU ĐỀ
local TitleBar = Instance.new("TextLabel", MainFrame)
TitleBar.Size = UDim2.new(1, 0, 0, 30)
TitleBar.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
TitleBar.TextColor3 = Color3.fromRGB(255, 255, 255)
TitleBar.Text = "  Yui HUB Custom - ROCK FRUIT"
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

-- ==========================================
-- BỐ CỤC CHIA 2 BÊN (TRÁI: TAB | PHẢI: NỘI DUNG)
-- ==========================================
local TabContainer = Instance.new("Frame", MainFrame)
TabContainer.Size = UDim2.new(0, 120, 1, -30)
TabContainer.Position = UDim2.new(0, 0, 0, 30)
TabContainer.BackgroundColor3 = Color3.fromRGB(25, 25, 25)

local TabListLayout = Instance.new("UIListLayout", TabContainer)
TabListLayout.Padding = UDim.new(0, 5)
TabListLayout.SortOrder = Enum.SortOrder.LayoutOrder

local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Size = UDim2.new(1, -120, 1, -30)
ContentContainer.Position = UDim2.new(0, 120, 0, 30)
ContentContainer.BackgroundTransparency = 1

-- Biến lưu trữ trạng thái
_G.SelectedMobs = {}
_G.AutoFarm = false
_G.AutoAttack = false
_G.AutoEquip = false
_G.WeaponType = "Melee"

_G.AutoZ, _G.AutoX, _G.AutoC, _G.AutoV, _G.AutoB = false, false, false, false, false

local Tabs = {}
local function CreateTabButton(name, isFirst)
    local btn = Instance.new("TextButton", TabContainer)
    btn.Size = UDim2.new(1, 0, 0, 35)
    btn.BackgroundColor3 = isFirst and Color3.fromRGB(40, 40, 40) or Color3.fromRGB(25, 25, 25)
    btn.TextColor3 = isFirst and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(200, 200, 200)
    btn.Text = name
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 13
    
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
-- XÂY DỰNG TAB 1: FARM MOBS
-- ==========================================
local FarmTab = CreateTabButton("Farm Mobs", true)

-- Chia cột bên phải (Cột trái: Mobs | Cột phải: Equip & Attack)
local FarmLeftCol = Instance.new("Frame", FarmTab)
FarmLeftCol.Size = UDim2.new(0.5, -10, 1, -20)
FarmLeftCol.Position = UDim2.new(0, 10, 0, 10)
FarmLeftCol.BackgroundTransparency = 1

local FarmRightCol = Instance.new("Frame", FarmTab)
FarmRightCol.Size = UDim2.new(0.5, -15, 1, -20)
FarmRightCol.Position = UDim2.new(0.5, 5, 0, 10)
FarmRightCol.BackgroundTransparency = 1

-- Nút Bật/Tắt Dropdown Mobs
local MobDropBtn = Instance.new("TextButton", FarmLeftCol)
MobDropBtn.Size = UDim2.new(1, 0, 0, 30)
MobDropBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
MobDropBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MobDropBtn.Text = "Chọn Quái (▼)"
MobDropBtn.Font = Enum.Font.Gotham

-- Khung chứa List quái (Sẽ bật/tắt khi bấm nút trên)
local MobScroll = Instance.new("ScrollingFrame", FarmLeftCol)
MobScroll.Size = UDim2.new(1, 0, 0, 180)
MobScroll.Position = UDim2.new(0, 0, 0, 35)
MobScroll.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MobScroll.ScrollBarThickness = 4
MobScroll.Visible = false -- Mặc định ẩn
local MobListLayout = Instance.new("UIListLayout", MobScroll)

-- Logic Mở/Đóng Dropdown không mất list
MobDropBtn.MouseButton1Click:Connect(function()
    MobScroll.Visible = not MobScroll.Visible
    MobDropBtn.Text = MobScroll.Visible and "Đóng List Quái (▲)" or "Chọn Quái (▼)"
end)

-- Nút Refresh Mobs
local RefreshMobsBtn = Instance.new("TextButton", FarmLeftCol)
RefreshMobsBtn.Size = UDim2.new(1, 0, 0, 30)
RefreshMobsBtn.Position = UDim2.new(0, 0, 1, -30)
RefreshMobsBtn.BackgroundColor3 = Color3.fromRGB(0, 100, 200)
RefreshMobsBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshMobsBtn.Text = "🔄 Quét Folder 'mod'"
RefreshMobsBtn.Font = Enum.Font.GothamBold

-- Hàm Load Mobs từ folder "mod"
local function LoadMobs()
    for _, child in ipairs(MobScroll:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    _G.SelectedMobs = {}
    
    local foundMobs = {}
    -- Tìm trong workspace.mod hoặc workspace.Mob
    local mobFolder = workspace:FindFirstChild("mod") or workspace:FindFirstChild("Mob") or workspace
    
    for _, v in pairs(mobFolder:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Name ~= Player.Name then
            if not table.find(foundMobs, v.Name) then table.insert(foundMobs, v.Name) end
        end
    end
    if #foundMobs == 0 then foundMobs = {"Bandit", "Boss"} end -- Fallback
    
    for _, mob in ipairs(foundMobs) do
        local btn = Instance.new("TextButton", MobScroll)
        btn.Size = UDim2.new(1, 0, 0, 25)
        btn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        btn.TextColor3 = Color3.fromRGB(200, 200, 200)
        btn.Text = "☐ " .. mob
        btn.TextXAlignment = Enum.TextXAlignment.Left
        btn.Font = Enum.Font.Gotham
        
        local isSel = false
        btn.MouseButton1Click:Connect(function()
            isSel = not isSel
            btn.Text = isSel and "☑ " .. mob or "☐ " .. mob
            btn.TextColor3 = isSel and Color3.fromRGB(50, 255, 50) or Color3.fromRGB(200, 200, 200)
            if isSel then
                table.insert(_G.SelectedMobs, mob)
            else
                for i, v in ipairs(_G.SelectedMobs) do if v == mob then table.remove(_G.SelectedMobs, i) break end end
            end
        end)
    end
    MobScroll.CanvasSize = UDim2.new(0, 0, 0, #foundMobs * 25)
end
RefreshMobsBtn.MouseButton1Click:Connect(LoadMobs)
LoadMobs()

-- Cột Phải: Các Nút Cài Đặt Farm
local function CreateToggle(parent, yPos, text, callback)
    local btn = Instance.new("TextButton", parent)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.Position = UDim2.new(0, 0, 0, yPos)
    btn.BackgroundColor3 = Color3.fromRGB(150, 40, 40)
    btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    btn.Text = text .. ": TẮT"
    btn.Font = Enum.Font.GothamBold
    
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.Text = state and text .. ": BẬT" or text .. ": TẮT"
        btn.BackgroundColor3 = state and Color3.fromRGB(40, 150, 40) or Color3.fromRGB(150, 40, 40)
        callback(state)
    end)
    return btn
end

-- Chuyển đổi vũ khí xoay vòng
local WepBtn = Instance.new("TextButton", FarmRightCol)
WepBtn.Size = UDim2.new(1, 0, 0, 30)
WepBtn.Position = UDim2.new(0, 0, 0, 0)
WepBtn.BackgroundColor3 = Color3.fromRGB(35, 35, 35)
WepBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
WepBtn.Text = "Vũ khí: Melee"
WepBtn.Font = Enum.Font.Gotham

local weps = {"Melee", "Sword", "Fruit", "Gun"}
local wepIdx = 1
WepBtn.MouseButton1Click:Connect(function()
    wepIdx = wepIdx + 1
    if wepIdx > #weps then wepIdx = 1 end
    _G.WeaponType = weps[wepIdx]
    WepBtn.Text = "Vũ khí: " .. _G.WeaponType
end)

CreateToggle(FarmRightCol, 35, "Auto Equip", function(v) _G.AutoEquip = v end)
CreateToggle(FarmRightCol, 80, "Auto Farm", function(v) _G.AutoFarm = v end)
CreateToggle(FarmRightCol, 115, "Auto Attack", function(v) _G.AutoAttack = v end)

-- ==========================================
-- XÂY DỰNG TAB 2: TELEPORT (MAP, QUEST, NPC)
-- ==========================================
local TeleportTab = CreateTabButton("Teleport", false)

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
    TpBtn.MouseButton1Click:Connect(function()
        -- Gắn code CFrame dịch chuyển tới items[idx] tại đây
        print("Teleporting to: " .. DropBtn.Text)
    end)
end

-- Chú ý: Bấm vào tên để đổi địa điểm, sau đó bấm "Bay Tới"
CreateTPSection(10, "1. Teleport Islands (Đảo)", {"Starter Island", "Jungle", "Desert", "Snow"})
CreateTPSection(80, "2. Teleport Quest NPC (Nhận NV)", {"Quest Lv1", "Quest Lv50", "Quest Lv100"})
CreateTPSection(150, "3. Teleport Normal NPC", {"Sword Seller", "Fruit Dealer", "Blacksmith"})

-- ==========================================
-- XÂY DỰNG TAB 3: AUTO SKILLS
-- ==========================================
local SkillTab = CreateTabButton("Auto Skills", false)

local SkillListLayout = Instance.new("UIListLayout", SkillTab)
SkillListLayout.Padding = UDim.new(0, 10)
Instance.new("UIPadding", SkillTab).PaddingTop = UDim.new(0, 10)

CreateToggle(SkillTab, 0, "Dùng Skill [Z]", function(v) _G.AutoZ = v end)
CreateToggle(SkillTab, 0, "Dùng Skill [X]", function(v) _G.AutoX = v end)
CreateToggle(SkillTab, 0, "Dùng Skill [C]", function(v) _G.AutoC = v end)
CreateToggle(SkillTab, 0, "Dùng Skill [V]", function(v) _G.AutoV = v end)

-- ==========================================
-- VÒNG LẶP CHẠY CHỨC NĂNG (MAIN LOOP)
-- ==========================================
task.spawn(function()
    while task.wait(0.1) do
        
        -- 1. Tự động cầm vũ khí
        if _G.AutoEquip and Player.Character then
            for _, tool in pairs(Player.Backpack:GetChildren()) do
                if tool:IsA("Tool") and (tool.ToolTip == _G.WeaponType or string.match(tool.Name, _G.WeaponType)) then
                    Player.Character.Humanoid:EquipTool(tool)
                end
            end
        end

        -- 2. Tự động đánh (Click)
        if _G.AutoAttack then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(0, 0))
            if Player.Character then
                local tool = Player.Character:FindFirstChildOfClass("Tool")
                if tool then tool:Activate() end
            end
        end

        -- 3. Tự động xả Skill
        if _G.AutoFarm or _G.AutoAttack then
            if _G.AutoZ then VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game) task.wait(0.05) end
            if _G.AutoX then VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game) task.wait(0.05) end
            if _G.AutoC then VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game) task.wait(0.05) end
            if _G.AutoV then VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.V, false, game) task.wait(0.05) end
        end

        -- 4. Logic Auto Farm (Tìm quái trong folder mod và bay tới)
        if _G.AutoFarm and #_G.SelectedMobs > 0 then
            local mobFolder = workspace:FindFirstChild("mod") or workspace:FindFirstChild("Mob") or workspace
            for _, mobName in pairs(_G.SelectedMobs) do
                local target = mobFolder:FindFirstChild(mobName)
                if target and target:FindFirstChild("HumanoidRootPart") and target.Humanoid.Health > 0 then
                    Player.Character.HumanoidRootPart.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 5, 3)
                    break
                end
            end
        end
        
    end
end)
