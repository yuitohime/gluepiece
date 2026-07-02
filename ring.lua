
-- Gọi thư viện Rayfield UI
local Rayfield = loadstring(game:HttpGet('https://sirius.menu/rayfield'))()

-- Tạo Cửa sổ (Window) với phong cách Dark Theme, Blue Accent (giống ảnh)
local Window = Rayfield:CreateWindow({
   Name = "Rock Fruit Hub | Auto Farm",
   LoadingTitle = "Đang tải Script...",
   LoadingSubtitle = "By You",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "RockFruitConfig",
      FileName = "RockFruitHub"
   },
   KeySystem = false -- Tắt Key System cho nhanh, bạn có thể bật lại nếu cần
})

-- Tạo các Tab bên trái (Giống ảnh image_6e921b.png)
local TabFarm = Window:CreateTab("Farm Mobs", 4483362458) 
local TabTeleport = Window:CreateTab("Island Waypoint", 4483362458)
local TabSkills = Window:CreateTab("Auto Skills", 4483362458)

---------------------------------------------------------
-- [ BIẾN GLOBAL LƯU TRẠNG THÁI ]
---------------------------------------------------------
_G.AutoFarm = false
_G.SelectedMobs = {} -- Lưu danh sách quái đã chọn (hỗ trợ nhiều quái)
_G.WeaponToEquip = "Melee"
_G.AutoEquip = false

_G.AutoZ = false
_G.AutoX = false
_G.AutoC = false
_G.AutoV = false
_G.AutoB = false

---------------------------------------------------------
-- [ TAB 1: FARM MOBS ]
---------------------------------------------------------
local SectionWeapon = TabFarm:CreateSection("Auto Equip Weapon")

TabFarm:CreateDropdown({
   Name = "Select Weapon",
   Options = {"Melee", "Sword", "Fruit", "Gun"},
   CurrentOption = {"Melee"},
   MultipleOptions = false,
   Flag = "WeaponDropdown",
   Callback = function(Option)
      _G.WeaponToEquip = Option[1]
   end,
})

TabFarm:CreateToggle({
   Name = "Auto Equip Weapon",
   CurrentValue = false,
   Flag = "ToggleAutoEquip",
   Callback = function(Value)
      _G.AutoEquip = Value
   end,
})

local SectionFarm = TabFarm:CreateSection("Farming Config")

-- Nút quét quái
local function GetMobsInMap()
    local mobs = {}
    -- Sửa "Workspace.Enemies" thành thư mục chứa quái thực tế trong game Rock Fruit
    for i, v in pairs(workspace:GetChildren()) do 
        if v:FindFirstChild("Humanoid") and v.Name ~= game.Players.LocalPlayer.Name then
            if not table.find(mobs, v.Name) then
                table.insert(mobs, v.Name)
            end
        end
    end
    -- Dữ liệu mẫu nếu map chưa load quái
    if #mobs == 0 then mobs = {"Bandit", "Monkey", "Boss"} end
    return mobs
end

local MobDropdown = TabFarm:CreateDropdown({
   Name = "Select Mobs (Chọn nhiều không bị tắt)",
   Options = GetMobsInMap(),
   CurrentOption = {},
   MultipleOptions = true, -- TÍNH NĂNG QUAN TRỌNG: Cho phép chọn nhiều, không tự đóng list
   Flag = "MobDropdown",
   Callback = function(Options)
       -- Options trả về là một table chứa các quái bạn đã chọn
      _G.SelectedMobs = Options 
   end,
})

TabFarm:CreateButton({
   Name = "🔄 Refresh / Quét lại Quái",
   Callback = function()
      MobDropdown:Refresh(GetMobsInMap())
      Rayfield:Notify({Title = "Thành công", Content = "Đã cập nhật danh sách quái!", Duration = 3})
   end,
})

TabFarm:CreateToggle({
   Name = "Auto Farm Selected Mobs",
   CurrentValue = false,
   Flag = "ToggleAutoFarm",
   Callback = function(Value)
      _G.AutoFarm = Value
   end,
})

---------------------------------------------------------
-- [ TAB 2: TELEPORT ]
---------------------------------------------------------
local SectionTeleport = TabTeleport:CreateSection("Teleport System")

TabTeleport:CreateDropdown({
   Name = "Select Island",
   Options = {"Starter Island", "Jungle", "Desert", "Snow Island"},
   CurrentOption = {"Starter Island"},
   MultipleOptions = false,
   Flag = "TeleportDropdown",
   Callback = function(Option)
       -- Code teleport tới đảo tương ứng tại đây
       print("Chuẩn bị bay tới: " .. Option[1])
   end,
})

TabTeleport:CreateButton({
   Name = "Teleport Now",
   Callback = function()
       -- Code CFrame Teleport
   end,
})

---------------------------------------------------------
-- [ TAB 3: AUTO SKILLS ]
---------------------------------------------------------
local SectionSkills = TabSkills:CreateSection("Auto Use Skills")

TabSkills:CreateToggle({Name = "Auto Skill [Z]", CurrentValue = false, Callback = function(V) _G.AutoZ = V end})
TabSkills:CreateToggle({Name = "Auto Skill [X]", CurrentValue = false, Callback = function(V) _G.AutoX = V end})
TabSkills:CreateToggle({Name = "Auto Skill [C]", CurrentValue = false, Callback = function(V) _G.AutoC = V end})
TabSkills:CreateToggle({Name = "Auto Skill [V]", CurrentValue = false, Callback = function(V) _G.AutoV = V end})
TabSkills:CreateToggle({Name = "Auto Skill [B]", CurrentValue = false, Callback = function(V) _G.AutoB = V end})

---------------------------------------------------------
-- [ VÒNG LẶP CHẠY AUTO (MAIN LOGIC) ]
---------------------------------------------------------
task.spawn(function()
    while task.wait() do
        -- 1. Tự động cầm vũ khí
        if _G.AutoEquip then
            -- Logic tìm và equip tool từ Backpack vào Character
            local player = game.Players.LocalPlayer
            if player.Character then
                for _, tool in pairs(player.Backpack:GetChildren()) do
                    -- Chú ý: Bạn cần sửa logic nhận diện Melee/Sword tùy theo game
                    if tool:IsA("Tool") and tool.ToolTip == _G.WeaponToEquip then
                        player.Character.Humanoid:EquipTool(tool)
                    end
                end
            end
        end

        -- 2. Tự động Farm & Tự động xả Skill
        if _G.AutoFarm and #_G.SelectedMobs > 0 then
            -- Logic tìm quái có tên nằm trong list _G.SelectedMobs và TP tới chém
            -- ...
            
            -- Tự động bấm phím skill bằng VirtualInputManager khi đang đấm quái
            local vim = game:GetService("VirtualInputManager")
            if _G.AutoZ then vim:SendKeyEvent(true, Enum.KeyCode.Z, false, game) vim:SendKeyEvent(false, Enum.KeyCode.Z, false, game) end
            if _G.AutoX then vim:SendKeyEvent(true, Enum.KeyCode.X, false, game) vim:SendKeyEvent(false, Enum.KeyCode.X, false, game) end
            if _G.AutoC then vim:SendKeyEvent(true, Enum.KeyCode.C, false, game) vim:SendKeyEvent(false, Enum.KeyCode.C, false, game) end
            if _G.AutoV then vim:SendKeyEvent(true, Enum.KeyCode.V, false, game) vim:SendKeyEvent(false, Enum.KeyCode.V, false, game) end
            if _G.AutoB then vim:SendKeyEvent(true, Enum.KeyCode.B, false, game) vim:SendKeyEvent(false, Enum.KeyCode.B, false, game) end
            
            task.wait(0.5) -- Delay xả skill tránh bị lag hoặc kick
        end
    end
end)
