-- Gọi thư viện UI Rayfield (Giao diện giống ảnh nhất, đã tối ưu không lỗi mạng)
local Rayfield = loadstring(game:HttpGet('https://raw.githubusercontent.com/sirius-hub/rayfield/main/source'))()

local Window = Rayfield:CreateWindow({
   Name = "Rock Fruit HUB | Full Chức Năng",
   LoadingTitle = "Đang tải giao diện...",
   LoadingSubtitle = "Vui lòng chờ",
   ConfigurationSaving = {
      Enabled = false -- TẮT để tránh lỗi crash trên các Executor di động
   },
   Discord = { Enabled = false },
   KeySystem = false
})

---------------------------------------------------------
-- [ BIẾN TOÀN CỤC - LƯU TRẠNG THÁI ]
---------------------------------------------------------
_G.AutoFarm = false
_G.AutoAttack = false
_G.SelectedMobs = {}
_G.WeaponType = "Melee" -- Mặc định
_G.AutoEquip = false

-- Biến Auto Skill
_G.AutoZ = false
_G.AutoX = false
_G.AutoC = false
_G.AutoV = false
_G.AutoB = false

-- Biến Teleport
_G.SelectedIsland = nil
_G.AutoTeleport = false

local Player = game.Players.LocalPlayer
local VirtualInputManager = game:GetService("VirtualInputManager")
local VirtualUser = game:GetService("VirtualUser")

---------------------------------------------------------
-- [ TAB 1: FARM MOBS (Sắp xếp chuẩn theo ảnh) ]
---------------------------------------------------------
local TabFarm = Window:CreateTab("Farm Mobs", 4483362458)

-- === CỘT 1: AUTO EQUIP WEAPON ===
local SectionEquip = TabFarm:CreateSection("Auto Equip Weapon")

TabFarm:CreateDropdown({
   Name = "Select Weapon (Chọn loại sức mạnh)",
   Options = {"Melee", "Sword", "Fruit", "Gun"},
   CurrentOption = {"Melee"},
   MultipleOptions = false,
   Flag = "WeaponSelect",
   Callback = function(Option)
      _G.WeaponType = Option[1]
   end,
})

TabFarm:CreateToggle({
   Name = "Auto Equip",
   CurrentValue = false,
   Flag = "ToggleEquip",
   Callback = function(Value)
      _G.AutoEquip = Value
   end,
})

-- === CỘT 2: FARMING CONFIG & LIST QUÁI ===
local SectionFarm = TabFarm:CreateSection("Farming Config")

-- Hàm quét quái thực tế trong Map
local function ScanMobs()
    local mobs = {}
    for _, v in pairs(workspace:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Name ~= Player.Name then
            if not table.find(mobs, v.Name) then
                table.insert(mobs, v.Name)
            end
        end
    end
    if #mobs == 0 then mobs = {"Chưa load quái, hãy bấm Refresh"} end
    return mobs
end

-- TÍNH NĂNG CHÍNH: Ô list quái mũi tên, chọn nhiều không tắt
local MobDropdown = TabFarm:CreateDropdown({
   Name = "Danh Sách Quái (Chọn Nhiều)",
   Options = ScanMobs(),
   CurrentOption = {},
   MultipleOptions = true, -- Cho phép tick nhiều ô, KHÔNG tự động đóng menu
   Flag = "MobSelect",
   Callback = function(Options)
      _G.SelectedMobs = Options
   end,
})

TabFarm:CreateButton({
   Name = "🔄 Quét Lại List Quái Xung Quanh",
   Callback = function()
      MobDropdown:Refresh(ScanMobs())
   end,
})

TabFarm:CreateToggle({
   Name = "Auto Farm (Tự động TP & Đánh)",
   CurrentValue = false,
   Flag = "ToggleFarm",
   Callback = function(Value)
      _G.AutoFarm = Value
   end,
})

TabFarm:CreateToggle({
   Name = "Auto Attack (Đánh thường)",
   CurrentValue = false,
   Flag = "ToggleAttack",
   Callback = function(Value)
      _G.AutoAttack = Value
   end,
})

---------------------------------------------------------
-- [ TAB 2: TELEPORT & ISLAND ]
---------------------------------------------------------
local TabTeleport = Window:CreateTab("Teleport", 4483362458)
local SectionTeleport = TabTeleport:CreateSection("Island Waypoint System")

TabTeleport:CreateDropdown({
   Name = "Saved Islands / Maps",
   Options = {"Starter Island", "Jungle", "Desert", "Snow", "Magma"},
   CurrentOption = {"Starter Island"},
   MultipleOptions = false,
   Flag = "IslandSelect",
   Callback = function(Option)
      _G.SelectedIsland = Option[1]
   end,
})

TabTeleport:CreateButton({
   Name = "Teleport Tới Đảo",
   Callback = function()
      -- Thêm tọa độ (CFrame) các đảo của Rock Fruit vào đây
      print("Đang bay tới: " .. tostring(_G.SelectedIsland))
   end,
})

---------------------------------------------------------
-- [ TAB 3: AUTO SKILLS ]
---------------------------------------------------------
local TabSkills = Window:CreateTab("Auto Skills", 4483362458)
local SectionSkills = TabSkills:CreateSection("Skill Settings")

TabSkills:CreateToggle({Name = "Auto Skill [Z]", CurrentValue = false, Callback = function(V) _G.AutoZ = V end})
TabSkills:CreateToggle({Name = "Auto Skill [X]", CurrentValue = false, Callback = function(V) _G.AutoX = V end})
TabSkills:CreateToggle({Name = "Auto Skill [C]", CurrentValue = false, Callback = function(V) _G.AutoC = V end})
TabSkills:CreateToggle({Name = "Auto Skill [V]", CurrentValue = false, Callback = function(V) _G.AutoV = V end})
TabSkills:CreateToggle({Name = "Auto Skill [B]", CurrentValue = false, Callback = function(V) _G.AutoB = V end})

---------------------------------------------------------
-- [ VÒNG LẶP XỬ LÝ LOGIC (MAIN LOOP) ]
---------------------------------------------------------
task.spawn(function()
    while task.wait() do
        
        -- 1. XỬ LÝ AUTO EQUIP (Cầm vũ khí)
        if _G.AutoEquip and Player.Character then
            for _, tool in pairs(Player.Backpack:GetChildren()) do
                if tool:IsA("Tool") then
                    -- Kiểm tra loại vũ khí dựa trên ToolTip hoặc tên (Tùy chỉnh theo game)
                    if tool.ToolTip == _G.WeaponType or string.match(tool.Name, _G.WeaponType) then
                        Player.Character.Humanoid:EquipTool(tool)
                    end
                end
            end
        end

        -- 2. XỬ LÝ AUTO ATTACK
        if _G.AutoAttack then
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(0, 0))
            
            -- Ép vũ khí đang cầm trên tay tung đòn
            local char = Player.Character
            if char then
                local equippedTool = char:FindFirstChildOfClass("Tool")
                if equippedTool then equippedTool:Activate() end
            end
        end

        -- 3. XỬ LÝ AUTO FARM (Teleport tới quái)
        if _G.AutoFarm and #_G.SelectedMobs > 0 then
            for _, mobName in pairs(_G.SelectedMobs) do
                local targetMob = workspace:FindFirstChild(mobName)
                if targetMob and targetMob:FindFirstChild("HumanoidRootPart") and targetMob.Humanoid.Health > 0 then
                    -- Dịch chuyển ra sau lưng quái (ở trên cao một chút để tránh bị đánh trúng)
                    Player.Character.HumanoidRootPart.CFrame = targetMob.HumanoidRootPart.CFrame * CFrame.new(0, 5, 3)
                    break -- Đánh xong con này mới sang con khác
                end
            end
        end

        -- 4. XỬ LÝ AUTO SKILL
        if _G.AutoFarm or _G.AutoAttack then
            if _G.AutoZ then VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game) task.wait(0.1) end
            if _G.AutoX then VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game) task.wait(0.1) end
            if _G.AutoC then VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game) task.wait(0.1) end
            if _G.AutoV then VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.V, false, game) task.wait(0.1) end
            if _G.AutoB then VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.B, false, game) task.wait(0.1) end
        end

    end
end)
