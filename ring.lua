-- ==========================================
-- HỆ THỐNG GIAO DIỆN (ROCK FRUIT - V9 FINAL PRO)
-- ==========================================
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local TeleportService = game:GetService("TeleportService")

local existingUI = CoreGui:FindFirstChild("YuiMobileHub") or Player:WaitForChild("PlayerGui"):FindFirstChild("YuiMobileHub")
if existingUI then existingUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "YuiMobileHub"
ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = Player:WaitForChild("PlayerGui") end

-- LỚP OVERLAY CHỐNG KẸT
local CloseOverlay = Instance.new("TextButton", ScreenGui)
CloseOverlay.Size = UDim2.new(1, 0, 1, 0); CloseOverlay.BackgroundTransparency = 1; CloseOverlay.Text = ""; CloseOverlay.ZIndex = 9; CloseOverlay.Visible = false

-- KHUNG CHÍNH
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 520, 0, 300)
MainFrame.Position = UDim2.new(0.5, -260, 0.5, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 150, 255)
Instance.new("UIStroke", MainFrame).Thickness = 1.5

-- TIÊU ĐỀ
local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 30); TopBar.BackgroundTransparency = 1
local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -30, 1, 0); Title.Position = UDim2.new(0, 10, 0, 0); Title.BackgroundTransparency = 1; Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "Yui HUB - ROCK FRUIT v9 (Final Pro)"
Title.Font = Enum.Font.GothamBold; Title.TextSize = 12; Title.TextXAlignment = Enum.TextXAlignment.Left
local TitleLine = Instance.new("Frame", TopBar)
TitleLine.Size = UDim2.new(0, 2, 0, 14); TitleLine.Position = UDim2.new(0, 4, 0.5, -7); TitleLine.BackgroundColor3 = Color3.fromRGB(0, 150, 255); TitleLine.BorderSizePixel = 0
local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(1, -30, 0, 0); CloseBtn.BackgroundTransparency = 1; CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50); CloseBtn.Text = "X"; CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 14
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

-- CỘT TAB VÀ NỘI DUNG
local TabContainer = Instance.new("ScrollingFrame", MainFrame)
TabContainer.Size = UDim2.new(0, 110, 1, -35); TabContainer.Position = UDim2.new(0, 5, 0, 30); TabContainer.BackgroundTransparency = 1; TabContainer.ScrollBarThickness = 2
local TabLayout = Instance.new("UIListLayout", TabContainer); TabLayout.Padding = UDim.new(0, 3)
local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Size = UDim2.new(1, -125, 1, -35); ContentContainer.Position = UDim2.new(0, 120, 0, 30); ContentContainer.BackgroundTransparency = 1

-- ==========================================
-- THƯ VIỆN GIAO DIỆN
-- ==========================================
local Tabs = {}
local function CreateTab(name, isFirst)
    local btn = Instance.new("TextButton", TabContainer)
    btn.Size = UDim2.new(1, -5, 0, 30); btn.BackgroundColor3 = isFirst and Color3.fromRGB(30, 30, 30) or Color3.fromRGB(15, 15, 15); btn.TextColor3 = isFirst and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150); btn.Text = "  " .. name; btn.Font = Enum.Font.GothamSemibold; btn.TextSize = 11; btn.TextXAlignment = Enum.TextXAlignment.Left
    Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    local Indicator = Instance.new("Frame", btn); Indicator.Size = UDim2.new(0, 3, 1, -10); Indicator.Position = UDim2.new(0, 0, 0, 5); Indicator.BackgroundColor3 = Color3.fromRGB(0, 150, 255); Indicator.BorderSizePixel = 0; Indicator.Visible = isFirst
    local page = Instance.new("Frame", ContentContainer); page.Size = UDim2.new(1, 0, 1, 0); page.BackgroundTransparency = 1; page.Visible = isFirst
    local LeftCol = Instance.new("ScrollingFrame", page); LeftCol.Size = UDim2.new(0.5, -4, 1, 0); LeftCol.BackgroundTransparency = 1; LeftCol.ScrollBarThickness = 2
    local LeftLayout = Instance.new("UIListLayout", LeftCol); LeftLayout.Padding = UDim.new(0, 5)
    local RightCol = Instance.new("ScrollingFrame", page); RightCol.Size = UDim2.new(0.5, -4, 1, 0); RightCol.Position = UDim2.new(0.5, 4, 0, 0); RightCol.BackgroundTransparency = 1; RightCol.ScrollBarThickness = 2
    local RightLayout = Instance.new("UIListLayout", RightCol); RightLayout.Padding = UDim.new(0, 5)
    
    LeftLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() LeftCol.CanvasSize = UDim2.new(0,0,0,LeftLayout.AbsoluteContentSize.Y + 10) end)
    RightLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() RightCol.CanvasSize = UDim2.new(0,0,0,RightLayout.AbsoluteContentSize.Y + 10) end)
    
    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do t.Btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15); t.Btn.TextColor3 = Color3.fromRGB(150, 150, 150); t.Ind.Visible = false; t.Page.Visible = false end
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30); btn.TextColor3 = Color3.fromRGB(255, 255, 255); Indicator.Visible = true; page.Visible = true
    end)
    table.insert(Tabs, {Btn = btn, Page = page, Ind = Indicator})
    TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() TabContainer.CanvasSize = UDim2.new(0,0,0,TabLayout.AbsoluteContentSize.Y + 10) end)
    return LeftCol, RightCol
end

local function CreateSection(parentCol, titleText)
    local sec = Instance.new("Frame", parentCol); sec.Size = UDim2.new(1, 0, 0, 0); sec.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    Instance.new("UICorner", sec).CornerRadius = UDim.new(0, 4); Instance.new("UIStroke", sec).Color = Color3.fromRGB(40, 40, 40)
    local title = Instance.new("TextLabel", sec); title.Size = UDim2.new(1, -10, 0, 22); title.Position = UDim2.new(0, 5, 0, 0); title.BackgroundTransparency = 1; title.TextColor3 = Color3.fromRGB(0, 150, 255); title.Text = titleText; title.Font = Enum.Font.GothamBold; title.TextSize = 11; title.TextXAlignment = Enum.TextXAlignment.Left
    local layout = Instance.new("UIListLayout", sec); layout.Padding = UDim.new(0, 3); layout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    local pad = Instance.new("Frame", sec); pad.Size = UDim2.new(1, 0, 0, 22); pad.BackgroundTransparency = 1
    layout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() sec.Size = UDim2.new(1, 0, 0, layout.AbsoluteContentSize.Y + 5) end)
    return sec
end

local function CreateButton(parentSec, text, callback)
    local btn = Instance.new("TextButton", parentSec); btn.Size = UDim2.new(1, -10, 0, 26); btn.BackgroundColor3 = Color3.fromRGB(35, 35, 35); btn.TextColor3 = Color3.fromRGB(255, 255, 255); btn.Text = text; btn.Font = Enum.Font.Gotham; btn.TextSize = 11; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    btn.MouseButton1Click:Connect(callback); return btn
end

local function CreateToggle(parentSec, text, varName)
    local frame = Instance.new("Frame", parentSec); frame.Size = UDim2.new(1, -10, 0, 26); frame.BackgroundTransparency = 1
    local label = Instance.new("TextLabel", frame); label.Size = UDim2.new(1, -40, 1, 0); label.BackgroundTransparency = 1; label.TextColor3 = Color3.fromRGB(200, 200, 200); label.Text = text; label.Font = Enum.Font.Gotham; label.TextSize = 11; label.TextXAlignment = Enum.TextXAlignment.Left
    local btn = Instance.new("TextButton", frame); btn.Size = UDim2.new(1, 0, 1, 0); btn.BackgroundTransparency = 1; btn.Text = ""
    local switchBg = Instance.new("Frame", frame); switchBg.Size = UDim2.new(0, 32, 0, 16); switchBg.Position = UDim2.new(1, -32, 0.5, -8); switchBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50); Instance.new("UICorner", switchBg).CornerRadius = UDim.new(1, 0)
    local circle = Instance.new("Frame", switchBg); circle.Size = UDim2.new(0, 12, 0, 12); circle.Position = UDim2.new(0, 2, 0.5, -6); circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255); Instance.new("UICorner", circle).CornerRadius = UDim.new(1, 0)
    local state = false
    btn.MouseButton1Click:Connect(function()
        state = not state; _G[varName] = state
        TweenService:Create(circle, TweenInfo.new(0.2), {Position = state and UDim2.new(1, -14, 0.5, -6) or UDim2.new(0, 2, 0.5, -6)}):Play()
        TweenService:Create(switchBg, TweenInfo.new(0.2), {BackgroundColor3 = state and Color3.fromRGB(0, 150, 255) or Color3.fromRGB(50, 50, 50)}):Play()
    end)
end

local function CreateSlider(parentSec, text, min, max, varName)
    local frame = Instance.new("Frame", parentSec); frame.Size = UDim2.new(1, -10, 0, 40); frame.BackgroundTransparency = 1
    local label = Instance.new("TextLabel", frame); label.Size = UDim2.new(1, 0, 0, 15); label.BackgroundTransparency = 1; label.TextColor3 = Color3.fromRGB(200, 200, 200); label.Text = text .. ": " .. min; label.Font = Enum.Font.Gotham; label.TextSize = 11; label.TextXAlignment = Enum.TextXAlignment.Left
    local sliderBg = Instance.new("Frame", frame); sliderBg.Size = UDim2.new(1, 0, 0, 6); sliderBg.Position = UDim2.new(0, 0, 1, -10); sliderBg.BackgroundColor3 = Color3.fromRGB(50, 50, 50); Instance.new("UICorner", sliderBg).CornerRadius = UDim.new(1, 0)
    local fill = Instance.new("Frame", sliderBg); fill.Size = UDim2.new(0, 0, 1, 0); fill.BackgroundColor3 = Color3.fromRGB(0, 150, 255); Instance.new("UICorner", fill).CornerRadius = UDim.new(1, 0)
    local btn = Instance.new("TextButton", sliderBg); btn.Size = UDim2.new(1, 0, 1, 14); btn.Position = UDim2.new(0, 0, 0.5, -7); btn.BackgroundTransparency = 1; btn.Text = ""
    local isDragging = false
    local function update(input)
        local pos = math.clamp((input.Position.X - sliderBg.AbsolutePosition.X) / sliderBg.AbsoluteSize.X, 0, 1)
        local val = math.floor(min + (max - min) * pos); fill.Size = UDim2.new(pos, 0, 1, 0); label.Text = text .. ": " .. val; _G[varName] = val
    end
    btn.InputBegan:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isDragging = true; update(input) end end)
    UserInputService.InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isDragging = false end end)
    UserInputService.InputChanged:Connect(function(input) if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then update(input) end end)
end

-- ==========================================
-- HỆ THỐNG DROPDOWN TỰ ĐÓNG VÀ LƯU TRẠNG THÁI (FIXED)
-- ==========================================
local ActiveDropdowns = {}
CloseOverlay.MouseButton1Click:Connect(function()
    CloseOverlay.Visible = false
    for _, drop in pairs(ActiveDropdowns) do drop.Visible = false end
end)

local function CreateFloatingDropdown(parentBtn, titleText, getItemsFunc, globalTable, onSelectFunc)
    local DropFrame = Instance.new("ScrollingFrame", ScreenGui)
    DropFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25); DropFrame.BorderSizePixel = 1; DropFrame.BorderColor3 = Color3.fromRGB(0, 150, 255); DropFrame.ZIndex = 10; DropFrame.Visible = false; DropFrame.ScrollBarThickness = 4
    local Layout = Instance.new("UIListLayout", DropFrame)
    table.insert(ActiveDropdowns, DropFrame)
    
    parentBtn.MouseButton1Click:Connect(function()
        for _, drop in pairs(ActiveDropdowns) do drop.Visible = false end
        for _, c in ipairs(DropFrame:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
        
        local items = getItemsFunc()
        for _, item in ipairs(items) do
            local b = Instance.new("TextButton", DropFrame)
            b.Size = UDim2.new(1, 0, 0, 26); b.BackgroundColor3 = Color3.fromRGB(30, 30, 30); b.Font = Enum.Font.Gotham; b.TextSize = 11; b.TextXAlignment = Enum.TextXAlignment.Left; b.ZIndex = 11
            
            -- FIX LỖI Ở ĐÂY: Kiểm tra xem item đã có trong _G.SelectedMobs chưa để tick xanh lại
            local isSel = false
            for _, v in pairs(globalTable) do if v == item then isSel = true break end end
            
            b.TextColor3 = isSel and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(200, 200, 200)
            b.Text = isSel and "  ☑ " .. item or "  ☐ " .. item
            
            b.MouseButton1Click:Connect(function()
                isSel = not isSel
                b.TextColor3 = isSel and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(200, 200, 200)
                b.Text = isSel and "  ☑ " .. item or "  ☐ " .. item
                onSelectFunc(item, isSel)
            end)
        end
        local btnPos = parentBtn.AbsolutePosition; local btnSize = parentBtn.AbsoluteSize
        DropFrame.Size = UDim2.new(0, btnSize.X, 0, math.min(#items * 26, 150))
        DropFrame.Position = UDim2.new(0, btnPos.X, 0, btnPos.Y + btnSize.Y + 2)
        DropFrame.CanvasSize = UDim2.new(0, 0, 0, #items * 26)
        DropFrame.Visible = true; CloseOverlay.Visible = true
    end)
end

-- ==========================================
-- BỘ DATA QUEST & HÀM TELEPORT NPC CỐT LÕI (FIXED)
-- ==========================================
local QuestData = {
    {Lv = 1, NPC = "Npc_Quest1", Mob = "Bacon"}, {Lv = 1000, NPC = "Npc_Quest2", Mob = "Bacon Strong"},
    {Lv = 2000, NPC = "Npc_Quest3", Mob = "Bacon Traveler"}, {Lv = 3000, NPC = "Npc_Quest4", Mob = "Bacon Fawkes"},
    {Lv = 4000, NPC = "Npc_Quest5", Mob = "Bacon Pirate"}, {Lv = 5000, NPC = "Npc_Quest6", Mob = "Bacon Clown"},
    {Lv = 6000, NPC = "Npc_Quest7", Mob = "Bacon Tarzan"}, {Lv = 7000, NPC = "Npc_Quest8", Mob = "Gorilla"},
    {Lv = 8000, NPC = "Npc_Quest9", Mob = "Bacon Fisherman"}, {Lv = 9000, NPC = "Npc_Quest10", Mob = "Bacon The Deep"},
    {Lv = 10000, NPC = "Npc_Quest11", Mob = "Bacon Marine"}, {Lv = 11000, NPC = "Npc_Quest12", Mob = "Bacon Marine Captain"},
    {Lv = 12000, NPC = "Npc_Quest13", Mob = "Bacon Rock"}, {Lv = 13000, NPC = "Npc_Quest14", Mob = "Bacon Iron"},
    {Lv = 14000, NPC = "Npc_Quest15", Mob = "Bacon Minerals"}, {Lv = 15000, NPC = "Npc_Quest16", Mob = "Bacon Kryptonite"},
    {Lv = 16000, NPC = "Npc_Quest17", Mob = "Bacon Snow"}, {Lv = 17000, NPC = "Npc_Quest18", Mob = "Bacon Ice"},
    {Lv = 18000, NPC = "Npc_Quest19", Mob = "Bacon Lava"}, {Lv = 19000, NPC = "Npc_Quest20", Mob = "Bacon Hellfire"}
}

local function FirePrompt(prompt)
    if fireproximityprompt then fireproximityprompt(prompt, 1, true)
    else prompt.HoldDuration = 0; prompt:InputHoldBegin(); task.wait(0.1); prompt:InputHoldEnd() end
end

-- HÀM TELEPORT MẠNH NHẤT (Tìm RootPart/Head để tránh lỗi đứng im)
local function TP(targetObj)
    if not targetObj then return end
    local char = Player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local targetCFrame
        if targetObj:IsA("Model") then
            local part = targetObj:FindFirstChild("HumanoidRootPart") or targetObj:FindFirstChild("Head") or targetObj.PrimaryPart
            if part then targetCFrame = part.CFrame else targetCFrame = targetObj:GetPivot() end
        elseif targetObj:IsA("BasePart") then
            targetCFrame = targetObj.CFrame
        end
        
        if targetCFrame then
            char.HumanoidRootPart.CFrame = targetCFrame * CFrame.new(0, 3, 0)
        end
    end
end

local function FindAndTP(name)
    local lName = string.lower(name)
    for _, v in pairs(workspace:GetDescendants()) do
        if string.find(string.lower(v.Name), lName) and (v:IsA("Model") or v:IsA("BasePart")) then TP(v); return true end
    end
    return false
end

local function HasQuest()
    for _, v in pairs(Player.PlayerGui:GetDescendants()) do
        if v:IsA("TextLabel") and (string.find(v.Text, "/") or string.find(string.lower(v.Text), "defeat") or string.find(string.lower(v.Text), "kill")) and v.Visible then
            return true
        end
    end
    return false
end

-- ==========================================
-- BIẾN TOÀN CỤC CHÍNH
-- ==========================================
_G.SelectedMobs, _G.SelectedWeapons = {}, {}
_G.AutoFarm, _G.AutoAttack, _G.AutoEquip = false, false, false
_G.AutoFarmLevel, _G.AutoBuyChest, _G.ChestAmount, _G.AutoRandomFruit = false, false, 5, false
_G.AttackPos, _G.AttackDist = "Trên đầu", 5
_G.AutoZ, _G.AutoX, _G.AutoC, _G.AutoV = false, false, false, false
_G.WalkSpeed, _G.JumpPower, _G.Noclip, _G.Fly, _G.FlySpeed = 16, 50, false, false, 50

-- ==========================================
-- XÂY DỰNG 6 TABS CHÍNH THỨC
-- ==========================================

-- [1] TAB MAIN
local MainLeft, MainRight = CreateTab("Main", true)

local SecAutoLv = CreateSection(MainLeft, "Auto Progression")
CreateToggle(SecAutoLv, "Tự Động Cày Cấp (Level)", "AutoFarmLevel")

local SecMob = CreateSection(MainLeft, "Mob Selection")
local MobDropBtn = CreateButton(SecMob, "Chọn Quái (▼)", function() end)
CreateFloatingDropdown(MobDropBtn, "Mobs", function()
    local mobs = {}; local folder = workspace:FindFirstChild("mod") or workspace:FindFirstChild("Mob") or workspace
    for _, v in pairs(folder:GetChildren()) do if v:FindFirstChild("Humanoid") and v.Name ~= Player.Name and not table.find(mobs, v.Name) then table.insert(mobs, v.Name) end end
    return mobs
end, _G.SelectedMobs, function(itemName, isAdded) -- Truyền _G.SelectedMobs vào để lưu trạng thái
    if isAdded then table.insert(_G.SelectedMobs, itemName) else for i, v in ipairs(_G.SelectedMobs) do if v == itemName then table.remove(_G.SelectedMobs, i) break end end end
end)

local SecWep = CreateSection(MainLeft, "Auto Equip Weapon")
local WepDropBtn = CreateButton(SecWep, "Chọn Vũ Khí (▼)", function() end)
CreateFloatingDropdown(WepDropBtn, "Weapons", function()
    local weps = {}; for _, v in pairs(Player.Backpack:GetChildren()) do if v:IsA("Tool") then table.insert(weps, v.Name) end end; for _, v in pairs(Player.Character:GetChildren()) do if v:IsA("Tool") then table.insert(weps, v.Name) end end
    return weps
end, _G.SelectedWeapons, function(itemName, isAdded)
    if isAdded then table.insert(_G.SelectedWeapons, itemName) else for i, v in ipairs(_G.SelectedWeapons) do if v == itemName then table.remove(_G.SelectedWeapons, i) break end end end
end)

local SecFarm = CreateSection(MainRight, "Farming Config")
CreateToggle(SecFarm, "Tự Cầm Vũ Khí", "AutoEquip")
CreateToggle(SecFarm, "Auto Attack", "AutoAttack")
CreateToggle(SecFarm, "Auto Farm", "AutoFarm")

-- [2] TAB SETTING
local SetLeft, SetRight = CreateTab("Setting", false)
local SecPos = CreateSection(SetLeft, "Attack Position")
local PosList = {"Trên đầu", "Dưới chân", "Sau lưng", "Trước mặt"}; local PosIdx = 1
local PosBtn = CreateButton(SecPos, "Vị Trí: Trên đầu", function() end)
PosBtn.MouseButton1Click:Connect(function() PosIdx = PosIdx + 1; if PosIdx > #PosList then PosIdx = 1 end; _G.AttackPos = PosList[PosIdx]; PosBtn.Text = "Vị Trí: " .. _G.AttackPos end)
CreateSlider(SecPos, "Khoảng Cách", 0, 20, "AttackDist")

local SecSkill = CreateSection(SetRight, "Auto Skills")
CreateToggle(SecSkill, "Dùng Skill Z", "AutoZ")
CreateToggle(SecSkill, "Dùng Skill X", "AutoX")
CreateToggle(SecSkill, "Dùng Skill C", "AutoC")
CreateToggle(SecSkill, "Dùng Skill V", "AutoV")

-- [3] TAB TELEPORT
local TpLeft, TpRight = CreateTab("Teleport", false)
local SecMap = CreateSection(TpLeft, "Map & Island")
local MapList = {"Starter Island", "Jungle", "Desert", "Snow"}; local MapBtn = CreateButton(SecMap, "Đích: Starter Island", function() end); local MapIdx = 1
MapBtn.MouseButton1Click:Connect(function() MapIdx = MapIdx + 1; if MapIdx > #MapList then MapIdx = 1 end; MapBtn.Text = "Đích: " .. MapList[MapIdx] end)
CreateButton(SecMap, "✈️ Bay Tới Đảo", function() FindAndTP(MapList[MapIdx]) end)

local SecNpc = CreateSection(TpRight, "Quest & NPC")
local NpcList = {"Quest1", "Sword Dealer", "Fruit Dealer", "Blacksmith"}; local NpcBtn = CreateButton(SecNpc, "Đích: Quest1", function() end); local NpcIdx = 1
NpcBtn.MouseButton1Click:Connect(function() NpcIdx = NpcIdx + 1; if NpcIdx > #NpcList then NpcIdx = 1 end; NpcBtn.Text = "Đích: " .. NpcList[NpcIdx] end)
CreateButton(SecNpc, "✈️ Bay Tới NPC", function() FindAndTP(NpcList[NpcIdx]) end)

-- [4] TAB SHOP & GACHA
local ShopLeft, ShopRight = CreateTab("Shop & Chest", false)
local SecChest = CreateSection(ShopLeft, "Auto Buy Chest (Gacha)")
local ChestRow = Instance.new("Frame", SecChest); ChestRow.Size = UDim2.new(1, -10, 0, 26); ChestRow.BackgroundTransparency = 1
local LayoutChestRow = Instance.new("UIListLayout", ChestRow); LayoutChestRow.FillDirection = Enum.FillDirection.Horizontal; LayoutChestRow.Padding = UDim.new(0, 5)

local btnX5 = Instance.new("TextButton", ChestRow); btnX5.Size = UDim2.new(0.31, 0, 1, 0); btnX5.Text = "x5"; btnX5.BackgroundColor3 = Color3.fromRGB(0, 150, 255); btnX5.TextColor3 = Color3.fromRGB(255,255,255)
local btnX10 = Instance.new("TextButton", ChestRow); btnX10.Size = UDim2.new(0.31, 0, 1, 0); btnX10.Text = "x10"; btnX10.BackgroundColor3 = Color3.fromRGB(35, 35, 35); btnX10.TextColor3 = Color3.fromRGB(255,255,255)
local btnX15 = Instance.new("TextButton", ChestRow); btnX15.Size = UDim2.new(0.31, 0, 1, 0); btnX15.Text = "x15"; btnX15.BackgroundColor3 = Color3.fromRGB(35, 35, 35); btnX15.TextColor3 = Color3.fromRGB(255,255,255)

local function ResetChestBtns() btnX5.BackgroundColor3 = Color3.fromRGB(35,35,35); btnX10.BackgroundColor3 = Color3.fromRGB(35,35,35); btnX15.BackgroundColor3 = Color3.fromRGB(35,35,35) end
btnX5.MouseButton1Click:Connect(function() ResetChestBtns(); btnX5.BackgroundColor3 = Color3.fromRGB(0, 150, 255); _G.ChestAmount = 5 end)
btnX10.MouseButton1Click:Connect(function() ResetChestBtns(); btnX10.BackgroundColor3 = Color3.fromRGB(0, 150, 255); _G.ChestAmount = 10 end)
btnX15.MouseButton1Click:Connect(function() ResetChestBtns(); btnX15.BackgroundColor3 = Color3.fromRGB(0, 150, 255); _G.ChestAmount = 15 end)
CreateToggle(SecChest, "Mở Rương Tự Động", "AutoBuyChest")

local SecFruit = CreateSection(ShopRight, "Random Fruit")
CreateToggle(SecFruit, "Auto Random Trái", "AutoRandomFruit")

-- [5] TAB PLAYER
local PlLeft, PlRight = CreateTab("Player", false)
local SecPlMove = CreateSection(PlLeft, "Movement")
CreateSlider(SecPlMove, "Tốc Độ Chạy", 16, 250, "WalkSpeed")
CreateSlider(SecPlMove, "Nhảy Cao", 50, 300, "JumpPower")

local SecPlMisc = CreateSection(PlRight, "Abilities")
CreateToggle(SecPlMisc, "Xuyên Tường", "Noclip")
CreateToggle(SecPlMisc, "Bật Bay (Fly)", "Fly")
CreateSlider(SecPlMisc, "Tốc Độ Bay", 10, 150, "FlySpeed")

-- [6] TAB SERVER
local SvLeft, SvRight = CreateTab("Server", false)
local SecSvMan = CreateSection(SvLeft, "Server Manager")
CreateButton(SecSvMan, "Vào Lại Server", function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Player) end)
local SecPerf = CreateSection(SvRight, "Performance")
CreateButton(SecPerf, "Xóa Hiệu Ứng (Đỡ lag)", function() for _, v in pairs(workspace:GetDescendants()) do if v:IsA("ParticleEmitter") or v:IsA("Trail") then v:Destroy() end end end)


-- ==========================================
-- VÒNG LẶP XỬ LÝ CHÍNH
-- ==========================================
local FlyBV, FlyBG
RunService.RenderStepped:Connect(function()
    if _G.Fly and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = Player.Character.HumanoidRootPart; local hum = Player.Character:FindFirstChild("Humanoid"); local cam = workspace.CurrentCamera
        workspace.Gravity = 0
        if not FlyBV then FlyBV = Instance.new("BodyVelocity", hrp); FlyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9); FlyBG = Instance.new("BodyGyro", hrp); FlyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9); FlyBG.P = 9e4 end
        local moveDir = hum.MoveDirection
        if moveDir.Magnitude > 0 then
            local pitch = cam.CFrame.LookVector.Y
            local velocity = moveDir * _G.FlySpeed
            local forwardness = moveDir:Dot(Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z).Unit)
            if forwardness == forwardness then velocity = Vector3.new(velocity.X, forwardness * pitch * _G.FlySpeed, velocity.Z) end
            FlyBV.Velocity = velocity
        else FlyBV.Velocity = Vector3.new(0,0,0) end
        FlyBG.CFrame = cam.CFrame
    else
        workspace.Gravity = 196.2
        if FlyBV then FlyBV:Destroy(); FlyBV = nil end
        if FlyBG then FlyBG:Destroy(); FlyBG = nil end
    end
    
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then
        Player.Character.Humanoid.WalkSpeed = _G.WalkSpeed; Player.Character.Humanoid.JumpPower = _G.JumpPower
    end
    if _G.Noclip and Player.Character then for _, v in pairs(Player.Character:GetChildren()) do if v:IsA("BasePart") then v.CanCollide = false end end end
end)

task.spawn(function()
    while task.wait(0.1) do
        local hrp = Player.Character and Player.Character:FindFirstChild("HumanoidRootPart")
        
        -- LOGIC AUTO FARM LEVEL CHUẨN MỰC
        if _G.AutoFarmLevel and Player:FindFirstChild("leaderstats") and Player.leaderstats:FindFirstChild("Level") then
            local myLevel = Player.leaderstats.Level.Value
            
            local currentQ = QuestData[1]
            for i = #QuestData, 1, -1 do
                if myLevel >= QuestData[i].Lv then currentQ = QuestData[i]; break end
            end
            
            _G.SelectedMobs = {currentQ.Mob}
            _G.AutoFarm = true
            
            if not HasQuest() and hrp then
                local npc = workspace:FindFirstChild(currentQ.NPC, true)
                if npc then
                    local prompt = npc:FindFirstChildWhichIsA("ProximityPrompt", true)
                    if prompt then
                        TP(npc)
                        task.wait(0.3)
                        FirePrompt(prompt)
                        task.wait(0.5)
                    end
                end
            end
        end
        
        -- LOGIC AUTO MUA RƯƠNG
        if _G.AutoBuyChest and hrp then
            for _, v in pairs(workspace:GetDescendants()) do
                if string.match(string.lower(v.Name), "chest") then
                    local prompt = v:FindFirstChildWhichIsA("ProximityPrompt", true)
                    if prompt then
                        TP(v)
                        task.wait(0.2)
                        FirePrompt(prompt)
                        task.wait(0.5)
                        break
                    end
                end
            end
        end

        -- LOGIC AUTO RANDOM TRÁI
        if _G.AutoRandomFruit and hrp then
             local npc = workspace:FindFirstChild("NpcRandomfruit", true)
             if npc then
                 local prompt = npc:FindFirstChildWhichIsA("ProximityPrompt", true)
                 if prompt then
                     TP(npc)
                     task.wait(0.2)
                     FirePrompt(prompt)
                 end
             end
        end

        -- LOGIC AUTO FARM QUÁI & ANTI-FLING
        if hrp then
            local bv = hrp:FindFirstChild("AntiFlingBV")
            if _G.AutoFarm then
                for _, v in pairs(Player.Character:GetChildren()) do if v:IsA("BasePart") then v.CanCollide = false end end
                if not bv then bv = Instance.new("BodyVelocity"); bv.Name = "AntiFlingBV"; bv.MaxForce = Vector3.new(9e9, 9e9, 9e9); bv.Velocity = Vector3.new(0, 0, 0); bv.Parent = hrp end
            else
                if bv then bv:Destroy() end
            end
        end

        if _G.AutoEquip and Player.Character then
            for _, wepName in pairs(_G.SelectedWeapons) do
                local tool = Player.Backpack:FindFirstChild(wepName)
                if tool then Player.Character.Humanoid:EquipTool(tool) end
            end
        end

        if _G.AutoAttack and Player.Character then
            for _, tool in pairs(Player.Character:GetChildren()) do if tool:IsA("Tool") then tool:Activate() end end
        end

        if _G.AutoFarm or _G.AutoAttack then
            if _G.AutoZ then VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.Z, false, game) end
            if _G.AutoX then VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.X, false, game) end
            if _G.AutoC then VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.C, false, game) end
            if _G.AutoV then VirtualInputManager:SendKeyEvent(true, Enum.KeyCode.V, false, game) end
        end

        if _G.AutoFarm and hrp and #_G.SelectedMobs > 0 then
            local folder = workspace:FindFirstChild("mod") or workspace:FindFirstChild("Mob") or workspace
            for _, mobName in pairs(_G.SelectedMobs) do
                local target = folder:FindFirstChild(mobName)
                if target and target:FindFirstChild("HumanoidRootPart") and target:FindFirstChild("Humanoid") and target.Humanoid.Health > 0 then
                    local offset = CFrame.new(0, 0, 0)
                    local dist = _G.AttackDist
                    if _G.AttackPos == "Trên đầu" then offset = CFrame.new(0, dist, 0) * CFrame.Angles(math.rad(-90), 0, 0)
                    elseif _G.AttackPos == "Dưới chân" then offset = CFrame.new(0, -dist, 0) * CFrame.Angles(math.rad(90), 0, 0)
                    elseif _G.AttackPos == "Sau lưng" then offset = CFrame.new(0, 0, dist)
                    elseif _G.AttackPos == "Trước mặt" then offset = CFrame.new(0, 0, -dist) * CFrame.Angles(0, math.rad(180), 0) end
                    
                    hrp.CFrame = target.HumanoidRootPart.CFrame * offset
                    break
                end
            end
        end
    end
end)
