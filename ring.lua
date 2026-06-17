-- ==========================================
-- BỘ KIỂM TRA LỖI EXECUTOR (FAILSAFE)
-- ==========================================
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local CoreGui = pcall(function() return game:GetService("CoreGui").Name end) and game:GetService("CoreGui") or LocalPlayer.PlayerGui

local success, Rayfield = pcall(function()
    return loadstring(game:HttpGet('https://sirius.menu/rayfield'))()
end)

if not success then
    -- Nếu Executor quá yếu và không tải được UI, hiện thông báo đỏ
    local ErrorUI = Instance.new("ScreenGui", CoreGui)
    local Frame = Instance.new("Frame", ErrorUI)
    Frame.Size = UDim2.new(0, 450, 0, 150)
    Frame.Position = UDim2.new(0.5, -225, 0.5, -75)
    Frame.BackgroundColor3 = Color3.fromRGB(200, 50, 50)
    Instance.new("UICorner", Frame).CornerRadius = UDim.new(0, 8)
    
    local Text = Instance.new("TextLabel", Frame)
    Text.Size = UDim2.new(1, -20, 1, -20)
    Text.Position = UDim2.new(0, 10, 0, 10)
    Text.BackgroundTransparency = 1
    Text.Text = "LỖI EXECUTOR: Trình chạy Script của bạn không hỗ trợ tải UI (thiếu game:HttpGet).\nVui lòng đổi sang Executor khác như Delta, Codex, Arceus X (Điện thoại) hoặc Wave, Solara (PC)!"
    Text.TextColor3 = Color3.fromRGB(255, 255, 255)
    Text.TextScaled = true
    Text.Font = Enum.Font.GothamBold
    return -- Dừng chạy script ngay lập tức
end

-- ==========================================
-- TẠO GIAO DIỆN RAYFIELD (CÓ THỂ THU NHỎ / KÉO THẢ)
-- ==========================================
local Window = Rayfield:CreateWindow({
    Name = "Glue Piece Ultimate Hub",
    LoadingTitle = "Đang tải chức năng...",
    LoadingSubtitle = "Auto Farm & Boss",
    ConfigurationSaving = {Enabled = false},
    KeySystem = false
})

-- Dữ Liệu Các Chức Năng
local MobsList = {"Slime", "Snake", "Thug", "Cutie Noob", "Elite Noob", "Evil Thug"}
local BossesList = {"Cutie Boss", "King Noob", "Nooby", "Unknown Boss", "King Slime", "Duck Boss", "Kyo", "Sans", "Shinoa", "Sword Master"}
local ShopList = {"Awakening Book", "Black Leg", "Limitless", "OFA [Deku]", "Busoshoku", "Observation", "Random Fruity", "Reset Fruity", "Reset Stats", "Dual Sword", "Geppo", "Soru", "Epic Sword", "Saber", "Triple Katana"}
local SkillKeys = {"Q", "E", "R", "T", "F", "Z", "X", "C", "V"}

_G.AutoAttack = false
_G.EquipAllWeapons = false
_G.AutoFarmAll = false
_G.AutoFarmSelected = false
_G.SelectedMob = "Slime"
_G.AutoBoss = false
_G.SelectedBoss = "Cutie Boss"
_G.AutoSkill = false
_G.SelectedSkills = {}
_G.AutoSetSpawn = false
_G.SelectedSpawn = "Eight Island [Spawn Manager]"

-- TAB 1: AUTO FARM & TẤN CÔNG
local FarmTab = Window:CreateTab("Tấn Công & Farm", 4483345998)

FarmTab:CreateSection("Vũ Khí & Tấn Công")
FarmTab:CreateToggle({
    Name = "Tự Động Đánh (Auto Attack)",
    CurrentValue = false,
    Flag = "AutoAttack",
    Callback = function(Value) _G.AutoAttack = Value end,
})

FarmTab:CreateToggle({
    Name = "Cầm TẤT CẢ Vũ Khí Cùng Lúc",
    CurrentValue = false,
    Flag = "EquipAll",
    Callback = function(Value)
        _G.EquipAllWeapons = Value
        if not Value then
            for _, tool in pairs(LocalPlayer.Character:GetChildren()) do
                if tool:IsA("Tool") then tool.Parent = LocalPlayer.Backpack end
            end
        end
    end,
})

FarmTab:CreateSection("Quét Quái Thường")
FarmTab:CreateToggle({
    Name = "Auto Farm TẤT CẢ Quái",
    CurrentValue = false,
    Flag = "FarmAll",
    Callback = function(Value) _G.AutoFarmAll = Value end,
})

FarmTab:CreateDropdown({
    Name = "Chọn Quái Để Farm",
    Options = MobsList,
    CurrentOption = {"Slime"},
    MultipleOptions = false,
    Flag = "SelectMob",
    Callback = function(Option) _G.SelectedMob = Option[1] end,
})

FarmTab:CreateToggle({
    Name = "Auto Farm Quái Đã Chọn",
    CurrentValue = false,
    Flag = "FarmSelected",
    Callback = function(Value) _G.AutoFarmSelected = Value end,
})

-- TAB 2: AUTO BOSS
local BossTab = Window:CreateTab("Săn Boss", 4483345998)
BossTab:CreateDropdown({
    Name = "Chọn Boss",
    Options = BossesList,
    CurrentOption = {"Cutie Boss"},
    MultipleOptions = false,
    Flag = "SelectBoss",
    Callback = function(Option) _G.SelectedBoss = Option[1] end,
})

BossTab:CreateToggle({
    Name = "Bật Auto Săn Boss (Ưu tiên)",
    CurrentValue = false,
    Flag = "AutoBoss",
    Callback = function(Value) _G.AutoBoss = Value end,
})

-- TAB 3: AUTO SKILL
local SkillTab = Window:CreateTab("Auto Skill", 4483345998)
SkillTab:CreateDropdown({
    Name = "Chọn Kỹ Năng (Có thể chọn nhiều)",
    Options = SkillKeys,
    CurrentOption = {},
    MultipleOptions = true,
    Flag = "SelectSkills",
    Callback = function(Options) _G.SelectedSkills = Options end,
})

SkillTab:CreateToggle({
    Name = "Bật Tự Động Xả Skill",
    CurrentValue = false,
    Flag = "AutoSkill",
    Callback = function(Value) _G.AutoSkill = Value end,
})

-- TAB 4: ESP & TÌM TRÁI ÁC QUỶ
local ESPTab = Window:CreateTab("Tìm Đồ & ESP", 4483345998)
local ESPDropdown = ESPTab:CreateDropdown({
    Name = "Danh sách Vật Phẩm / Trái Cây",
    Options = {"Chưa tải dữ liệu"},
    CurrentOption = {"Chưa tải dữ liệu"},
    MultipleOptions = false,
    Flag = "DropList",
    Callback = function(Option) print("Đã xem:", Option[1]) end,
})

ESPTab:CreateButton({
    Name = "Làm Mới Danh Sách & Bật ESP",
    Callback = function()
        local dropItems = {}
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Tool") and obj.Parent ~= LocalPlayer.Character and obj.Parent ~= LocalPlayer.Backpack then
                table.insert(dropItems, obj.Name)
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
                    txt.TextColor3 = Color3.fromRGB(0, 255, 0)
                    txt.TextScaled = true
                end
            end
        end
        if #dropItems == 0 then table.insert(dropItems, "Không có đồ nào rơi") end
        ESPDropdown:Refresh(dropItems)
    end,
})

-- TAB 5: SPAWN & SHOP
local ExtraTab = Window:CreateTab("Extra", 4483345998)
ExtraTab:CreateSection("Auto Mua Đồ")
local ShopDrop = ExtraTab:CreateDropdown({
    Name = "Chọn Vật Phẩm",
    Options = ShopList,
    CurrentOption = {"Epic Sword"},
    MultipleOptions = false,
    Flag = "SelectShop",
    Callback = function(Option) _G.SelectedShopItem = Option[1] end,
})

ExtraTab:CreateButton({
    Name = "Mua Bằng Tiền Game",
    Callback = function()
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj.Name == _G.SelectedShopItem then
                local click = obj:FindFirstChildWhichIsA("ClickDetector", true)
                if click then fireclickdetector(click) return end
            end
        end
        Rayfield:Notify({Title = "Lỗi", Content = "Không tìm thấy nút mua!", Duration = 3})
    end,
})

ExtraTab:CreateSection("Auto Set Spawn")
ExtraTab:CreateDropdown({
    Name = "Chọn Đảo Để Hồi Sinh",
    Options = {"Eight Island [Spawn Manager]"},
    CurrentOption = {"Eight Island [Spawn Manager]"},
    MultipleOptions = false,
    Flag = "SelectSpawn",
    Callback = function(Option) _G.SelectedSpawn = Option[1] end,
})

ExtraTab:CreateToggle({
    Name = "Bật Auto Set Spawn",
    CurrentValue = false,
    Flag = "AutoSpawn",
    Callback = function(Value)
        _G.AutoSetSpawn = Value
        if Value then
            task.spawn(function()
                while _G.AutoSetSpawn do
                    local sm = workspace:FindFirstChild("Spawn Manager")
                    if sm then
                        local isl = sm:FindFirstChild(_G.SelectedSpawn)
                        if isl then
                            local click = isl:FindFirstChildWhichIsA("ClickDetector", true)
                            if click then fireclickdetector(click) end
                        end
                    end
                    task.wait(5)
                end
            end)
        end
    end,
})

-- ==========================================
-- LOGIC AUTO FARM CHÍNH
-- ==========================================
local VirtualUser = game:GetService("VirtualUser")
local VirtualInputManager = game:GetService("VirtualInputManager")

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

-- Vòng lặp chiến đấu
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

-- Vòng lặp sử dụng kỹ năng
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
