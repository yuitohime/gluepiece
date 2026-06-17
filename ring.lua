-- Project: Glue Piece Custom Hub thuần Lua
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")
local LocalPlayer = Players.LocalPlayer

local guiName = "GluePiece_CustomUI"
local CoreGui = pcall(function() return game:GetService("CoreGui").Name end) and game:GetService("CoreGui") or LocalPlayer.PlayerGui

-- Xóa UI cũ nếu có
if CoreGui:FindFirstChild(guiName) then CoreGui[guiName]:Destroy() end

-- ==========================================
-- 1. THIẾT KẾ GIAO DIỆN CHÍNH
-- ==========================================
local ScreenGui = Instance.new("ScreenGui", CoreGui)
ScreenGui.Name = guiName

-- Nút mở UI khi thu nhỏ
local OpenBtn = Instance.new("TextButton", ScreenGui)
OpenBtn.Size = UDim2.new(0, 50, 0, 50)
OpenBtn.Position = UDim2.new(0, 10, 0.5, -25)
OpenBtn.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
OpenBtn.Text = "MỞ"
OpenBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
OpenBtn.Font = Enum.Font.GothamBold
OpenBtn.Visible = false
Instance.new("UICorner", OpenBtn).CornerRadius = UDim.new(0, 8)

-- Khung Main (Chữ nhật to)
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 550, 0, 320)
MainFrame.Position = UDim2.new(0.5, -275, 0.5, -160)
MainFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
MainFrame.Active = true
MainFrame.Draggable = true -- Hỗ trợ kéo thả
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)

-- Thanh TopBar (Tiêu đề + Nút Đóng/Thu nhỏ)
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 30)
TopBar.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
Instance.new("UICorner", TopBar).CornerRadius = UDim.new(0, 8)
local TopBarHide = Instance.new("Frame", TopBar) -- Xóa góc bo tròn ở dưới
TopBarHide.Size = UDim2.new(1, 0, 0, 5)
TopBarHide.Position = UDim2.new(0, 0, 1, -5)
TopBarHide.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
TopBarHide.BorderSizePixel = 0

local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -70, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "Glue Piece Hub - Custom UI"
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Font = Enum.Font.GothamBold
Title.TextXAlignment = Enum.TextXAlignment.Left

local MinBtn = Instance.new("TextButton", TopBar)
MinBtn.Size = UDim2.new(0, 25, 0, 20)
MinBtn.Position = UDim2.new(1, -60, 0, 5)
MinBtn.BackgroundColor3 = Color3.fromRGB(50, 150, 255)
MinBtn.Text = "-"
MinBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
MinBtn.Font = Enum.Font.GothamBold

local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 25, 0, 20)
CloseBtn.Position = UDim2.new(1, -30, 0, 5)
CloseBtn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
CloseBtn.Font = Enum.Font.GothamBold

-- Cột Trái (Menu Tabs)
local LeftPanel = Instance.new("ScrollingFrame", MainFrame)
LeftPanel.Size = UDim2.new(0, 130, 1, -30)
LeftPanel.Position = UDim2.new(0, 0, 0, 30)
LeftPanel.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
LeftPanel.BorderSizePixel = 0
LeftPanel.ScrollBarThickness = 2
local LeftLayout = Instance.new("UIListLayout", LeftPanel)
LeftLayout.Padding = UDim.new(0, 5)

-- Cột Phải (Nội dung)
local RightPanel = Instance.new("Frame", MainFrame)
RightPanel.Size = UDim2.new(1, -140, 1, -40)
RightPanel.Position = UDim2.new(0, 135, 0, 35)
RightPanel.BackgroundTransparency = 1

-- ==========================================
-- 2. LOGIC TẠO TABS VÀ CÁC NÚT (COMPONENT)
-- ==========================================
local Tabs = {}
local function CreateTab(name)
    local TabBtn = Instance.new("TextButton", LeftPanel)
    TabBtn.Size = UDim2.new(1, -10, 0, 35)
    TabBtn.Position = UDim2.new(0, 5, 0, 0)
    TabBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    TabBtn.Text = name
    TabBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabBtn.Font = Enum.Font.GothamSemibold
    Instance.new("UICorner", TabBtn).CornerRadius = UDim.new(0, 6)

    local TabContent = Instance.new("ScrollingFrame", RightPanel)
    TabContent.Size = UDim2.new(1, 0, 1, 0)
    TabContent.BackgroundTransparency = 1
    TabContent.ScrollBarThickness = 4
    TabContent.Visible = false
    local ContentLayout = Instance.new("UIListLayout", TabContent)
    ContentLayout.Padding = UDim.new(0, 8)

    TabBtn.MouseButton1Click:Connect(function()
        for _, content in pairs(Tabs) do content.Visible = false end
        TabContent.Visible = true
    end)
    
    table.insert(Tabs, TabContent)
    if #Tabs == 1 then TabContent.Visible = true end -- Hiện tab đầu tiên
    return TabContent
end

local function CreateToggle(parent, text, globalVar, callback)
    local Frame = Instance.new("Frame", parent)
    Frame.Size = UDim2.new(1, -10, 0, 35)
    Frame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 6)
    
    local Label = Instance.new("TextLabel", Frame)
    Label.Size = UDim2.new(1, -50, 1, 0)
    Label.Position = UDim2.new(0, 10, 0, 0)
    Label.BackgroundTransparency = 1
    Label.Text = text
    Label.TextColor3 = Color3.fromRGB(255, 255, 255)
    Label.Font = Enum.Font.Gotham
    Label.TextXAlignment = Enum.TextXAlignment.Left

    local Btn = Instance.new("TextButton", Frame)
    Btn.Size = UDim2.new(0, 30, 0, 20)
    Btn.Position = UDim2.new(1, -40, 0.5, -10)
    Btn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
    Btn.Text = "OFF"
    Btn.TextColor3 = Color3.fromRGB(255,255,255)
    Btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 4)

    Btn.MouseButton1Click:Connect(function()
        _G[globalVar] = not _G[globalVar]
        if _G[globalVar] then
            Btn.BackgroundColor3 = Color3.fromRGB(50, 200, 50)
            Btn.Text = "ON"
        else
            Btn.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
            Btn.Text = "OFF"
        end
        if callback then callback(_G[globalVar]) end
    end)
end

local function CreateCycleBtn(parent, text, optionsList, globalVar)
    local idx = 1
    _G[globalVar] = optionsList[idx] -- Default

    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(1, -10, 0, 35)
    Btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    Btn.Text = text .. ": " .. tostring(_G[globalVar])
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.Gotham
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)

    Btn.MouseButton1Click:Connect(function()
        idx = idx + 1
        if idx > #optionsList then idx = 1 end
        _G[globalVar] = optionsList[idx]
        Btn.Text = text .. ": " .. tostring(_G[globalVar])
    end)
end

local function CreateButton(parent, text, callback)
    local Btn = Instance.new("TextButton", parent)
    Btn.Size = UDim2.new(1, -10, 0, 35)
    Btn.BackgroundColor3 = Color3.fromRGB(70, 130, 250)
    Btn.Text = text
    Btn.TextColor3 = Color3.fromRGB(255, 255, 255)
    Btn.Font = Enum.Font.GothamBold
    Instance.new("UICorner", Btn).CornerRadius = UDim.new(0, 6)
    Btn.MouseButton1Click:Connect(callback)
end

-- Tương tác cửa sổ
MinBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = false
    OpenBtn.Visible = true
end)
OpenBtn.MouseButton1Click:Connect(function()
    MainFrame.Visible = true
    OpenBtn.Visible = false
end)
CloseBtn.MouseButton1Click:Connect(function()
    ScreenGui:Destroy()
end)

-- Anti AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- ==========================================
-- 3. DỮ LIỆU & TẠO CÁC TAB CHỨC NĂNG
-- ==========================================
local MobsList = {"Slime", "Snake", "Thug", "Cutie Noob", "Elite Noob", "Evil Thug"}
local BossesList = {"Cutie Boss", "King Noob", "Nooby", "Unknown Boss", "King Slime", "Duck Boss", "Kyo", "Sans", "Shinoa", "Sword Master"}
local ShopList = {"Awakening Book", "Black Leg", "Limitless", "OFA [Deku]", "Busoshoku", "Observation", "Random Fruity", "Reset Fruity", "Reset Stats", "Dual Sword", "Geppo", "Soru", "Epic Sword", "Saber", "Triple Katana"}
local SkillKeys = {"Q", "E", "R", "T", "F", "Z", "X", "C", "V"}

-- Khởi tạo Global Vars
_G.AutoAttack = false
_G.EquipAllWeapons = false
_G.AutoFarmAll = false
_G.AutoFarmSelected = false
_G.AutoBoss = false
_G.AutoSkill = false
_G.SelectedSkills = {}
_G.SelectedSpawn = "Eight Island [Spawn Manager]"

-- TAB 1: MAIN (FARM)
local TabMain = CreateTab("Main Farm")
CreateToggle(TabMain, "Tự Động Đánh (Click chuột)", "AutoAttack")
CreateToggle(TabMain, "Cầm 100% Vũ Khí Cùng Lúc", "EquipAllWeapons", function(val)
    if not val then
        for _, t in pairs(LocalPlayer.Character:GetChildren()) do
            if t:IsA("Tool") then t.Parent = LocalPlayer.Backpack end
        end
    end
end)
CreateToggle(TabMain, "Farm TẤT CẢ Quái", "AutoFarmAll")
CreateCycleBtn(TabMain, "Mục Tiêu", MobsList, "SelectedMob")
CreateToggle(TabMain, "Farm Quái Đã Chọn", "AutoFarmSelected")

-- TAB 2: BOSS
local TabBoss = CreateTab("Boss")
CreateCycleBtn(TabBoss, "Chọn Boss", BossesList, "SelectedBoss")
CreateToggle(TabBoss, "Bật Auto Săn Boss", "AutoBoss")

-- TAB 3: SKILL
local TabSkill = CreateTab("Skills")
CreateToggle(TabSkill, "Bật Xả Kỹ Năng", "AutoSkill")
CreateCycleBtn(TabSkill, "Chọn Phím Skill", SkillKeys, "SingleSkillKey")
CreateButton(TabSkill, "Thêm Phím Vào Danh Sách", function()
    local key = _G.SingleSkillKey
    local found = false
    for _, v in ipairs(_G.SelectedSkills) do if v == key then found = true end end
    if not found then 
        table.insert(_G.SelectedSkills, key) 
        print("Đã thêm skill: " .. key)
    end
end)
CreateButton(TabSkill, "Xóa Hết Danh Sách Skill", function()
    _G.SelectedSkills = {}
    print("Đã xóa danh sách skill")
end)

-- TAB 4: SHOP & SPAWN
local TabShop = CreateTab("Shop & Spawn")
CreateCycleBtn(TabShop, "Đảo Hồi Sinh", {"Eight Island [Spawn Manager]"}, "SelectedSpawn")
CreateToggle(TabShop, "Auto Lưu Điểm Hồi Sinh", "AutoSetSpawn", function(val)
    if val then
        task.spawn(function()
            while _G.AutoSetSpawn do
                pcall(function()
                    local sm = workspace:FindFirstChild("Spawn Manager")
                    if sm then
                        local isl = sm:FindFirstChild(_G.SelectedSpawn)
                        if isl then fireclickdetector(isl:FindFirstChildWhichIsA("ClickDetector", true)) end
                    end
                end)
                task.wait(5)
            end
        end)
    end
end)
CreateCycleBtn(TabShop, "Mua Đồ", ShopList, "SelectedShopItem")
CreateButton(TabShop, "Xác Nhận Mua", function()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj.Name == _G.SelectedShopItem then
            local click = obj:FindFirstChildWhichIsA("ClickDetector", true)
            if click then fireclickdetector(click) end
        end
    end
end)

-- TAB 5: ESP
local TabESP = CreateTab("ESP Đồ")
CreateButton(TabESP, "Bật/Quét Tìm Đồ Rơi (Fruit)", function()
    for _, obj in pairs(workspace:GetDescendants()) do
        if obj:IsA("Tool") and obj.Parent ~= LocalPlayer.Character and obj.Parent ~= LocalPlayer.Backpack then
            if not obj:FindFirstChild("ESPTag") then
                local billboard = Instance.new("BillboardGui", obj)
                billboard.Name = "ESPTag"
                billboard.Size = UDim2.new(0, 150, 0, 50)
                billboard.StudsOffset = Vector3.new(0, 2, 0)
                billboard.AlwaysOnTop = true
                local txt = Instance.new("TextLabel", billboard)
                txt.Size = UDim2.new(1, 0, 1, 0)
                txt.BackgroundTransparency = 1
                txt.Text = obj.Name .. " [Rơi]"
                txt.TextColor3 = Color3.fromRGB(50, 255, 50)
                txt.TextScaled = true
                txt.Font = Enum.Font.GothamBold
            end
        end
    end
end)

-- ==========================================
-- 4. LOGIC TỰ ĐỘNG CHÍNH (VÒNG LẶP)
-- ==========================================
local function EquipWeapons()
    if _G.EquipAllWeapons then
        for _, tool in pairs(LocalPlayer.Backpack:GetChildren()) do
            if tool:IsA("Tool") then tool.Parent = LocalPlayer.Character end
        end
    end
end

local function GetTarget()
    if _G.AutoBoss then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj.Name == _G.SelectedBoss and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
                if obj.Humanoid.Health > 0 then return obj end
            end
        end
        return nil
    end

    if _G.AutoFarmAll or _G.AutoFarmSelected then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj:FindFirstChild("HumanoidRootPart") then
                if obj.Humanoid.Health > 0 and obj.Name ~= LocalPlayer.Name then
                    local isBoss = false
                    for _, b in pairs(BossesList) do if obj.Name == b then isBoss = true break end end
                    
                    if not isBoss then
                        if _G.AutoFarmAll then return obj end
                        if _G.AutoFarmSelected and obj.Name == _G.SelectedMob then return obj end
                    end
                end
            end
        end
    end
    return nil
end

task.spawn(function()
    while task.wait() do
        if _G.AutoFarmAll or _G.AutoFarmSelected or _G.AutoBoss then
            EquipWeapons()
            local targetMob = GetTarget()
            
            if targetMob then
                while targetMob and targetMob:FindFirstChild("Humanoid") and targetMob.Humanoid.Health > 0 do
                    if not (_G.AutoFarmAll or _G.AutoFarmSelected or _G.AutoBoss) then break end
                    pcall(function()
                        local char = LocalPlayer.Character
                        if char and char:FindFirstChild("HumanoidRootPart") then
                            -- Tele ra sau lưng 4 stud
                            char.HumanoidRootPart.CFrame = targetMob.HumanoidRootPart.CFrame * CFrame.new(0, 0, 4)
                            if _G.AutoAttack then
                                VirtualUser:CaptureController()
                                VirtualUser:ClickButton1(Vector2.new())
                            end
                        end
                    end)
                    task.wait(0.05)
                end
            end
        end
    end
end)

task.spawn(function()
    while task.wait(0.2) do
        if _G.AutoSkill and (_G.AutoFarmAll or _G.AutoFarmSelected or _G.AutoBoss) then
            for _, key in pairs(_G.SelectedSkills) do
                if not _G.AutoSkill then break end
                pcall(function()
                    VirtualInputManager:SendKeyEvent(true, Enum.KeyCode[key], false, game)
                    task.wait(0.1)
                    VirtualInputManager:SendKeyEvent(false, Enum.KeyCode[key], false, game)
                end)
                task.wait(0.2)
            end
        end
    end
end)
