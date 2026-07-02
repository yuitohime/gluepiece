-- ==========================================
-- HỆ THỐNG GIAO DIỆN (ROCK FRUIT - V15 UNBREAKABLE)
-- ==========================================
local CoreGui = game:GetService("CoreGui")
local TweenService = game:GetService("TweenService")
local Player = game.Players.LocalPlayer
local RunService = game:GetService("RunService")
local VirtualInputManager = game:GetService("VirtualInputManager")
local UserInputService = game:GetService("UserInputService")
local TeleportService = game:GetService("TeleportService")
local HttpService = game:GetService("HttpService")

local existingUI = CoreGui:FindFirstChild("YuiMobileHub") or Player:WaitForChild("PlayerGui"):FindFirstChild("YuiMobileHub")
if existingUI then existingUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui"); ScreenGui.Name = "YuiMobileHub"; ScreenGui.ResetOnSpawn = false
pcall(function() ScreenGui.Parent = CoreGui end)
if not ScreenGui.Parent then ScreenGui.Parent = Player:WaitForChild("PlayerGui") end

local CloseOverlay = Instance.new("TextButton", ScreenGui)
CloseOverlay.Size = UDim2.new(1, 0, 1, 0); CloseOverlay.BackgroundTransparency = 1; CloseOverlay.Text = ""; CloseOverlay.ZIndex = 9; CloseOverlay.Visible = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 530, 0, 310); MainFrame.Position = UDim2.new(0.5, -265, 0.5, -155); MainFrame.BackgroundColor3 = Color3.fromRGB(15, 15, 15); MainFrame.Active = true; MainFrame.Draggable = true
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 6); Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(0, 150, 255); Instance.new("UIStroke", MainFrame).Thickness = 1.5

local TopBar = Instance.new("Frame", MainFrame)
TopBar.Size = UDim2.new(1, 0, 0, 30); TopBar.BackgroundTransparency = 1
local Title = Instance.new("TextLabel", TopBar)
Title.Size = UDim2.new(1, -30, 1, 0); Title.Position = UDim2.new(0, 10, 0, 0); Title.BackgroundTransparency = 1; Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = "Yui HUB - ROCK FRUIT v15 (Unbreakable)"; Title.Font = Enum.Font.GothamBold; Title.TextSize = 12; Title.TextXAlignment = Enum.TextXAlignment.Left
local TitleLine = Instance.new("Frame", TopBar); TitleLine.Size = UDim2.new(0, 2, 0, 14); TitleLine.Position = UDim2.new(0, 4, 0.5, -7); TitleLine.BackgroundColor3 = Color3.fromRGB(0, 150, 255)
local CloseBtn = Instance.new("TextButton", TopBar)
CloseBtn.Size = UDim2.new(0, 30, 0, 30); CloseBtn.Position = UDim2.new(1, -30, 0, 0); CloseBtn.BackgroundTransparency = 1; CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50); CloseBtn.Text = "X"; CloseBtn.Font = Enum.Font.GothamBold; CloseBtn.TextSize = 14
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local TabContainer = Instance.new("ScrollingFrame", MainFrame)
TabContainer.Size = UDim2.new(0, 110, 1, -35); TabContainer.Position = UDim2.new(0, 5, 0, 30); TabContainer.BackgroundTransparency = 1; TabContainer.ScrollBarThickness = 2
local TabLayout = Instance.new("UIListLayout", TabContainer); TabLayout.Padding = UDim.new(0, 3)
local ContentContainer = Instance.new("Frame", MainFrame)
ContentContainer.Size = UDim2.new(1, -125, 1, -35); ContentContainer.Position = UDim2.new(0, 120, 0, 30); ContentContainer.BackgroundTransparency = 1

-- ==========================================
-- THƯ VIỆN GIAO DIỆN CHUẨN
-- ==========================================
local Tabs, ActiveDropdowns = {}, {}
CloseOverlay.MouseButton1Click:Connect(function() CloseOverlay.Visible = false; for _, drop in pairs(ActiveDropdowns) do drop.Visible = false end end)

local function CreateTab(name, isFirst)
    local btn = Instance.new("TextButton", TabContainer)
    btn.Size = UDim2.new(1, -5, 0, 30); btn.BackgroundColor3 = isFirst and Color3.fromRGB(30, 30, 30) or Color3.fromRGB(15, 15, 15); btn.TextColor3 = isFirst and Color3.fromRGB(255, 255, 255) or Color3.fromRGB(150, 150, 150); btn.Text = "  " .. name; btn.Font = Enum.Font.GothamSemibold; btn.TextSize = 11; btn.TextXAlignment = Enum.TextXAlignment.Left; Instance.new("UICorner", btn).CornerRadius = UDim.new(0, 4)
    local Indicator = Instance.new("Frame", btn); Indicator.Size = UDim2.new(0, 3, 1, -10); Indicator.Position = UDim2.new(0, 0, 0, 5); Indicator.BackgroundColor3 = Color3.fromRGB(0, 150, 255); Indicator.BorderSizePixel = 0; Indicator.Visible = isFirst
    local page = Instance.new("Frame", ContentContainer); page.Size = UDim2.new(1, 0, 1, 0); page.BackgroundTransparency = 1; page.Visible = isFirst
    local LeftCol = Instance.new("ScrollingFrame", page); LeftCol.Size = UDim2.new(0.5, -4, 1, 0); LeftCol.BackgroundTransparency = 1; LeftCol.ScrollBarThickness = 2; local LeftLayout = Instance.new("UIListLayout", LeftCol); LeftLayout.Padding = UDim.new(0, 5)
    local RightCol = Instance.new("ScrollingFrame", page); RightCol.Size = UDim2.new(0.5, -4, 1, 0); RightCol.Position = UDim2.new(0.5, 4, 0, 0); RightCol.BackgroundTransparency = 1; RightCol.ScrollBarThickness = 2; local RightLayout = Instance.new("UIListLayout", RightCol); RightLayout.Padding = UDim.new(0, 5)
    LeftLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() LeftCol.CanvasSize = UDim2.new(0,0,0,LeftLayout.AbsoluteContentSize.Y + 10) end)
    RightLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() RightCol.CanvasSize = UDim2.new(0,0,0,RightLayout.AbsoluteContentSize.Y + 10) end)
    btn.MouseButton1Click:Connect(function()
        for _, t in pairs(Tabs) do t.Btn.BackgroundColor3 = Color3.fromRGB(15, 15, 15); t.Btn.TextColor3 = Color3.fromRGB(150, 150, 150); t.Ind.Visible = false; t.Page.Visible = false end
        btn.BackgroundColor3 = Color3.fromRGB(30, 30, 30); btn.TextColor3 = Color3.fromRGB(255, 255, 255); Indicator.Visible = true; page.Visible = true
    end)
    table.insert(Tabs, {Btn = btn, Page = page, Ind = Indicator}); TabLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function() TabContainer.CanvasSize = UDim2.new(0,0,0,TabLayout.AbsoluteContentSize.Y + 10) end)
    return LeftCol, RightCol
end

local function CreateSection(parentCol, titleText)
    local sec = Instance.new("Frame", parentCol); sec.Size = UDim2.new(1, 0, 0, 0); sec.BackgroundColor3 = Color3.fromRGB(20, 20, 20); Instance.new("UICorner", sec).CornerRadius = UDim.new(0, 4); Instance.new("UIStroke", sec).Color = Color3.fromRGB(40, 40, 40)
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
    btn.MouseButton1Click:Connect(function()
        _G[varName] = not _G[varName]; local state = _G[varName]
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
    game:GetService("UserInputService").InputEnded:Connect(function(input) if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then isDragging = false end end)
    game:GetService("UserInputService").InputChanged:Connect(function(input) if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then update(input) end end)
end

local function CreateSmartDropdown(parentBtn, getItemsFunc, globalVarName)
    local DropFrame = Instance.new("ScrollingFrame", ScreenGui)
    DropFrame.BackgroundColor3 = Color3.fromRGB(25, 25, 25); DropFrame.BorderSizePixel = 1; DropFrame.BorderColor3 = Color3.fromRGB(0, 150, 255); DropFrame.ZIndex = 10; DropFrame.Visible = false; DropFrame.ScrollBarThickness = 4
    local Layout = Instance.new("UIListLayout", DropFrame); table.insert(ActiveDropdowns, DropFrame)
    
    parentBtn.MouseButton1Click:Connect(function()
        for _, drop in pairs(ActiveDropdowns) do drop.Visible = false end
        for _, c in ipairs(DropFrame:GetChildren()) do if c:IsA("TextButton") then c:Destroy() end end
        
        local items = getItemsFunc()
        for _, item in ipairs(items) do
            local b = Instance.new("TextButton", DropFrame)
            b.Size = UDim2.new(1, 0, 0, 26); b.BackgroundColor3 = Color3.fromRGB(30, 30, 30); b.Font = Enum.Font.Gotham; b.TextSize = 11; b.TextXAlignment = Enum.TextXAlignment.Left; b.ZIndex = 11
            
            local isSel = table.find(_G[globalVarName], item.Value) ~= nil
            b.TextColor3 = isSel and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(200, 200, 200)
            b.Text = isSel and "  ☑ " .. item.Text or "  ☐ " .. item.Text
            
            b.MouseButton1Click:Connect(function()
                isSel = not isSel
                if isSel then table.insert(_G[globalVarName], item.Value) else
                    local idx = table.find(_G[globalVarName], item.Value); if idx then table.remove(_G[globalVarName], idx) end
                end
                b.TextColor3 = isSel and Color3.fromRGB(0, 255, 100) or Color3.fromRGB(200, 200, 200)
                b.Text = isSel and "  ☑ " .. item.Text or "  ☐ " .. item.Text
            end)
        end
        local btnPos = parentBtn.AbsolutePosition; local btnSize = parentBtn.AbsoluteSize
        DropFrame.Size = UDim2.new(0, btnSize.X, 0, math.min(#items * 26, 150)); DropFrame.Position = UDim2.new(0, btnPos.X, 0, btnPos.Y + btnSize.Y + 2)
        DropFrame.CanvasSize = UDim2.new(0, 0, 0, #items * 26); DropFrame.Visible = true; CloseOverlay.Visible = true
    end)
end

-- ==========================================
-- BỘ DATA QUEST & HÀM CHỨC NĂNG LÕI
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

local function GetPlayerLevel()
    local lvl = 0
    pcall(function() lvl = tonumber(string.match(Player.PlayerGui.HUD.Main.Frame_Display.LevelText.Text, "%d+")) or 0 end)
    if lvl == 0 then pcall(function() lvl = tonumber(Player.leaderstats.Level.Value) or 0 end) end
    return lvl == 0 and 1 or lvl
end

-- TP CHỐNG KẸT VẬT LÝ (Tắt AntiFling trước khi bay)
local function TP(targetObj)
    if not targetObj then return end
    local char = Player.Character
    if char and char:FindFirstChild("HumanoidRootPart") then
        local pos
        if targetObj:IsA("Model") then
            local p = targetObj:FindFirstChild("HumanoidRootPart") or targetObj:FindFirstChild("Head") or targetObj.PrimaryPart
            pos = p and p.CFrame or targetObj:GetPivot()
        elseif targetObj:IsA("BasePart") then pos = targetObj.CFrame end
        
        if pos then 
            local bv = char.HumanoidRootPart:FindFirstChild("AntiFlingBV")
            if bv then bv:Destroy() end
            char.HumanoidRootPart.CFrame = pos * CFrame.new(0, 3, 0) 
        end
    end
end

local function FirePrompt(prompt)
    if fireproximityprompt then fireproximityprompt(prompt, 1, true)
    else prompt.HoldDuration = 0; prompt:InputHoldBegin(); task.wait(0.1); prompt:InputHoldEnd() end
end

local function FastSkill(key)
    task.spawn(function()
        VirtualInputManager:SendKeyEvent(true, key, false, game); task.wait(0.01); VirtualInputManager:SendKeyEvent(false, key, false, game)
    end)
end

-- HÀM LÀM SẠCH CHUỖI TÌM QUÁI
local function cleanStr(s) return string.gsub(string.lower(s), "[^%w]", "") end

-- ==========================================
-- BIẾN TOÀN CỤC CHÍNH
-- ==========================================
_G.SelectedMobs, _G.SelectedWeapons = {}, {}
_G.AutoFarm, _G.AutoAttack, _G.AutoEquip = false, false, false
_G.AutoQuestLevel, _G.AutoFarmLevel = false, false
_G.AutoSummonBoss, _G.AutoFarmBoss, _G.SelectedBoss = false, false, "Dark Bacon"
_G.WepDelay, _G.LastWepTick, _G.WepIdx = 1, 0, 1
_G.AutoBuyChest, _G.ChestAmount, _G.AutoRandomFruit = false, 5, false
_G.AttackPos, _G.AttackDist = "Trên đầu", 5
_G.AutoZ, _G.AutoX, _G.AutoC, _G.AutoV = false, false, false, false
_G.WalkSpeed, _G.JumpPower, _G.Noclip, _G.Fly, _G.FlySpeed = 16, 50, false, false, 50

-- ==========================================
-- XÂY DỰNG TABS
-- ==========================================

-- [1] TAB MAIN
local MainLeft, MainRight = CreateTab("Main", true)

local SecAutoLv = CreateSection(MainLeft, "Auto Level Progression")
CreateToggle(SecAutoLv, "Tự Động Nhận Quest (Theo Lv)", "AutoQuestLevel")
CreateToggle(SecAutoLv, "Tự Động Farm Quái (Theo Lv)", "AutoFarmLevel")

local SecMob = CreateSection(MainLeft, "Mob Selection (Thủ công)")
local MobDropBtn = CreateButton(SecMob, "Chọn Quái ▼", function() end)
CreateSmartDropdown(MobDropBtn, function()
    local mobs = {}
    for _, q in ipairs(QuestData) do
        local maxLv = q.Lv + 999; if q.Lv >= 19000 then maxLv = "Max" end
        table.insert(mobs, {Text = q.Mob .. " [Lv " .. q.Lv .. "-" .. maxLv .. "]", Value = q.Mob})
    end
    return mobs
end, "SelectedMobs")

local SecWep = CreateSection(MainLeft, "Auto Equip Weapon")
local WepDropBtn = CreateButton(SecWep, "Chọn Nhiều Vũ Khí ▼", function() end)
CreateSmartDropdown(WepDropBtn, function()
    local weps = {}; for _, v in pairs(Player.Backpack:GetChildren()) do if v:IsA("Tool") then table.insert(weps, {Text = v.Name, Value = v.Name}) end end; return weps
end, "SelectedWeapons")
CreateSlider(SecWep, "Delay Đổi Vũ Khí (s)", 0, 10, "WepDelay")

local SecFarm = CreateSection(MainRight, "Farming Config")
CreateToggle(SecFarm, "Tự Đổi Cầm Vũ Khí (Cycle)", "AutoEquip")
CreateToggle(SecFarm, "Auto Attack", "AutoAttack")
CreateToggle(SecFarm, "Auto Farm", "AutoFarm")

-- [2] TAB BOSS
local BossLeft, BossRight = CreateTab("Boss", false)

local SecBoss = CreateSection(BossLeft, "Summon Boss")
_G.TempBossList = {"SelectedBoss"}
local BossDropBtn = CreateButton(SecBoss, "Boss: Dark Bacon", function() end)
CreateSmartDropdown(BossDropBtn, function() return {{Text = "Dark Bacon", Value = "Dark Bacon"}, {Text = "GooGooGaaGaa", Value = "GooGooGaaGaa"}} end, "TempBossList")
BossDropBtn.MouseButton1Click:Connect(function() task.wait(0.2); if #_G.TempBossList > 0 then _G.SelectedBoss = _G.TempBossList[#_G.TempBossList]; BossDropBtn.Text = "Boss: " .. _G.SelectedBoss end end)
CreateToggle(SecBoss, "Auto Summon Boss", "AutoSummonBoss")

local SecBossFarm = CreateSection(BossRight, "Boss Farm")
CreateToggle(SecBossFarm, "Auto Farm Boss", "AutoFarmBoss")

-- [3] TAB SETTING & SKILLS
local SetLeft, SetRight = CreateTab("Setting", false)
local SecPos = CreateSection(SetLeft, "Attack Position")
local PosList = {"Trên đầu", "Dưới chân", "Sau lưng", "Trước mặt"}; local PosIdx = 1
local PosBtn = CreateButton(SecPos, "Vị Trí: Trên đầu", function() end)
PosBtn.MouseButton1Click:Connect(function() PosIdx = PosIdx + 1; if PosIdx > #PosList then PosIdx = 1 end; _G.AttackPos = PosList[PosIdx]; PosBtn.Text = "Vị Trí: " .. _G.AttackPos end)
CreateSlider(SecPos, "Khoảng Cách", 0, 20, "AttackDist")

local SecSkill = CreateSection(SetRight, "Auto Skills")
CreateToggle(SecSkill, "Dùng Skill Z", "AutoZ"); CreateToggle(SecSkill, "Dùng Skill X", "AutoX")
CreateToggle(SecSkill, "Dùng Skill C", "AutoC"); CreateToggle(SecSkill, "Dùng Skill V", "AutoV")

-- [4] TAB TELEPORT & SHOP NPC
local TpLeft, TpRight = CreateTab("Teleport", false)
local SecMap = CreateSection(TpLeft, "Island Teleport (Qua Cổng)")
local MapList = {"Starter Island", "Jungle", "Desert", "Snow"}; local MapBtn = CreateButton(SecMap, "Đích: Starter Island", function() end); local MapIdx = 1
MapBtn.MouseButton1Click:Connect(function() MapIdx = MapIdx + 1; if MapIdx > #MapList then MapIdx = 1 end; MapBtn.Text = "Đích: " .. MapList[MapIdx] end)
CreateButton(SecMap, "✈️ Bay Qua Đảo", function()
    local gates = workspace:FindFirstChild("Gates")
    if gates and gates:FindFirstChild("TeleportPart") then
        local p = gates.TeleportPart:FindFirstChild(MapList[MapIdx])
        if p then TP(p) return end
    end
end)

local SecShopNPC = CreateSection(TpRight, "NPC Shops (Cố định)")
local FixedShops = {"Sword Dealer", "Fruit Dealer", "Blacksmith", "Haki Color", "Haki Dealer"}
_G.TempShopList = {}
local ShopDropBtn = CreateButton(SecShopNPC, "Chọn NPC Shop ▼", function() end)
CreateSmartDropdown(ShopDropBtn, function() 
    local t = {}; for _, v in ipairs(FixedShops) do table.insert(t, {Text = v, Value = v}) end; return t 
end, "TempShopList")
CreateButton(SecShopNPC, "✈️ Bay Tới NPC Shop", function()
    local targetShop = _G.TempShopList[#_G.TempShopList]
    if targetShop then
        for _, fn in ipairs({"NpcWeapon", "NpcRandomFruit", "npcprompt", "NPCs"}) do
            local folder = workspace:FindFirstChild(fn)
            if folder then 
                for _, v in pairs(folder:GetChildren()) do if string.find(string.lower(v.Name), string.lower(targetShop)) then TP(v); return end end
            end
        end
    end
end)

-- [5] TAB GACHA & PLAYER
local ShopLeft, PlRight = CreateTab("Gacha & Player", false)
local SecChest = CreateSection(ShopLeft, "Auto Buy Chest")
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
CreateToggle(SecChest, "Auto Random Trái", "AutoRandomFruit")

local SecPlMisc = CreateSection(PlRight, "Abilities (Player)")
CreateToggle(SecPlMisc, "Xuyên Tường", "Noclip")
CreateToggle(SecPlMisc, "Bật Bay (Fly)", "Fly")
CreateSlider(SecPlMisc, "Tốc Độ Bay", 10, 150, "FlySpeed")

-- [6] TAB SERVER
local SvLeft, SvRight = CreateTab("Server", false)
local SecSvMan = CreateSection(SvLeft, "Server Manager")
CreateButton(SecSvMan, "Vào Lại Server (Rejoin)", function() TeleportService:TeleportToPlaceInstance(game.PlaceId, game.JobId, Player) end)
local SecPerf = CreateSection(SvRight, "Performance")
CreateButton(SecPerf, "Xóa Hiệu Ứng (Giảm Lag)", function() for _, v in pairs(workspace:GetDescendants()) do if v:IsA("ParticleEmitter") or v:IsA("Trail") then v:Destroy() end end end)


-- ==========================================
-- VÒNG LẶP XỬ LÝ CHÍNH (LOGIC CHỐNG KẸT)
-- ==========================================
local FlyBV, FlyBG
RunService.RenderStepped:Connect(function()
    if _G.Fly and Player.Character and Player.Character:FindFirstChild("HumanoidRootPart") then
        local hrp = Player.Character.HumanoidRootPart; local hum = Player.Character:FindFirstChild("Humanoid"); local cam = workspace.CurrentCamera
        workspace.Gravity = 0
        if not FlyBV then FlyBV = Instance.new("BodyVelocity", hrp); FlyBV.MaxForce = Vector3.new(9e9, 9e9, 9e9); FlyBG = Instance.new("BodyGyro", hrp); FlyBG.MaxTorque = Vector3.new(9e9, 9e9, 9e9); FlyBG.P = 9e4 end
        local moveDir = hum.MoveDirection
        if moveDir.Magnitude > 0 then
            local pitch = cam.CFrame.LookVector.Y; local velocity = moveDir * _G.FlySpeed
            local forwardness = moveDir:Dot(Vector3.new(cam.CFrame.LookVector.X, 0, cam.CFrame.LookVector.Z).Unit)
            if forwardness == forwardness then velocity = Vector3.new(velocity.X, forwardness * pitch * _G.FlySpeed, velocity.Z) end
            FlyBV.Velocity = velocity
        else FlyBV.Velocity = Vector3.new(0,0,0) end
        FlyBG.CFrame = cam.CFrame
    else
        workspace.Gravity = 196.2
        if FlyBV then FlyBV:Destroy(); FlyBV = nil end; if FlyBG then FlyBG:Destroy(); FlyBG = nil end
    end
    if Player.Character and Player.Character:FindFirstChild("Humanoid") then Player.Character.Humanoid.WalkSpeed = _G.WalkSpeed; Player.Character.Humanoid.JumpPower = _G.JumpPower end
    if _G.Noclip and Player.Character then for _, v in pairs(Player.Character:GetChildren()) do if v:IsA("BasePart") then v.CanCollide = false end end end
end)

local LastQuestTick, LastSummonTick = 0, 0
task.spawn(function()
    while task.wait(0.01) do
        local char = Player.Character
        local hrp = char and char:FindFirstChild("HumanoidRootPart")
        if not hrp then continue end

        local currentQ = QuestData[1]
        local myLevel = GetPlayerLevel()
        for i = #QuestData, 1, -1 do if myLevel >= QuestData[i].Lv then currentQ = QuestData[i]; break end end

        -- AUTO NHẬN QUEST
        if _G.AutoQuestLevel then
            local hasQuest = false
            for _, v in pairs(Player.PlayerGui:GetDescendants()) do if v:IsA("TextLabel") and (string.find(string.lower(v.Text), "defeat") or string.find(string.lower(v.Text), "0/")) and v.Visible then hasQuest = true; break end end
            
            if not hasQuest and tick() - LastQuestTick > 3 then
                LastQuestTick = tick()
                task.spawn(function()
                    local npc = workspace:FindFirstChild(currentQ.NPC, true)
                    if npc then
                        local prompt = npc:FindFirstChildWhichIsA("ProximityPrompt", true)
                        if prompt then TP(npc); task.wait(0.3); FirePrompt(prompt) end
                    end
                end)
            end
        end

        -- AUTO SUMMON BOSS
        if _G.AutoSummonBoss then
            local bossAlive = false
            for _, v in pairs(workspace:GetDescendants()) do if v:IsA("Model") and string.find(string.lower(v.Name), string.lower(cleanStr(_G.SelectedBoss))) and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then bossAlive = true; break end end
            
            if not bossAlive and tick() - LastSummonTick > 5 then
                LastSummonTick = tick()
                task.spawn(function()
                    local summonNpc = workspace:FindFirstChild("Npc_SummonBoss", true)
                    if summonNpc then
                        TP(summonNpc); task.wait(0.3)
                        local prompt = summonNpc:FindFirstChildWhichIsA("ProximityPrompt", true)
                        if prompt then FirePrompt(prompt) end
                        task.wait(0.5)
                        pcall(function()
                            local gui = Player.PlayerGui:FindFirstChild("HUB")
                            if gui and gui.Main.Frame_SummonBoss.Visible then
                                local btn = gui.Main.Frame_SummonBoss.ScrollingFrame[_G.SelectedBoss].Main.TextButton
                                if getconnections then for _, c in pairs(getconnections(btn.MouseButton1Click)) do c:Fire() end; for _, c in pairs(getconnections(btn.Activated)) do c:Fire() end end
                                gui.Main.Frame_SummonBoss.Visible = false
                            end
                        end)
                    end
                end)
            end
        end

        -- AUTO BUY CHEST
        if _G.AutoBuyChest then
            task.spawn(function()
                for _, v in pairs(workspace:GetDescendants()) do
                    if string.match(string.lower(v.Name), "chest") then
                        local prompt = v:FindFirstChildWhichIsA("ProximityPrompt", true)
                        if prompt then TP(v); task.wait(0.2); for i=1, _G.ChestAmount do FirePrompt(prompt); task.wait(0.05) end; break end
                    end
                end
            end)
            task.wait(1) 
        end

        -- AUTO RANDOM FRUIT
        if _G.AutoRandomFruit then
            task.spawn(function()
                local npc = workspace:FindFirstChild("NpcRandomFruit", true)
                if npc then
                    local prompt = npc:FindFirstChildWhichIsA("ProximityPrompt", true)
                    if prompt then TP(npc); task.wait(0.2); FirePrompt(prompt) end
                end
            end)
            task.wait(1)
        end

        -- TÌM MỤC TIÊU CỰC NHANH (MỜ & CHỐNG KẸT)
        local target = nil
        local isFarming = _G.AutoFarm or _G.AutoFarmBoss or _G.AutoFarmLevel
        
        if isFarming then
            if _G.AutoFarmLevel then _G.SelectedMobs = {currentQ.Mob} end 
            
            if _G.AutoFarmBoss then
                for _, v in pairs(workspace:GetDescendants()) do if v:IsA("Model") and string.find(string.lower(v.Name), string.lower(cleanStr(_G.SelectedBoss))) and v:FindFirstChild("HumanoidRootPart") and v:FindFirstChild("Humanoid") and v.Humanoid.Health > 0 then target = v; break end end
            end
            
            if not target and (_G.AutoFarm or _G.AutoFarmLevel) then
                local folders = {workspace:FindFirstChild("mod"), workspace:FindFirstChild("Mob"), workspace:FindFirstChild("Enemies"), workspace}
                for _, mobName in pairs(_G.SelectedMobs) do
                    local cleanMob = cleanStr(mobName)
                    for _, f in ipairs(folders) do
                        if f then
                            for _, v in ipairs(f:GetChildren()) do
                                if v:IsA("Model") and v.Name ~= Player.Name and v:FindFirstChild("HumanoidRootPart") then
                                    local hum = v:FindFirstChild("Humanoid")
                                    if hum and hum.Health > 0 then
                                        local cleanV = cleanStr(v.Name)
                                        if cleanV == cleanMob or string.find(cleanV, cleanMob, 1, true) then 
                                            if not game.Players:GetPlayerFromCharacter(v) then target = v; break end
                                        end
                                    end
                                end
                            end
                        end
                        if target then break end
                    end
                    if target then break end
                end
            end
        end
        
        -- KÍCH HOẠT ANTI-FLING VÀ DI CHUYỂN
        local bv = hrp:FindFirstChild("AntiFlingBV")
        if target then
            for _, v in pairs(char:GetChildren()) do if v:IsA("BasePart") then v.CanCollide = false end end
            if not bv then bv = Instance.new("BodyVelocity", hrp); bv.Name = "AntiFlingBV"; bv.MaxForce = Vector3.new(9e9, 9e9, 9e9); bv.Velocity = Vector3.new(0, 0, 0) end
            
            local offset = CFrame.new(0, 0, 0)
            if _G.AttackPos == "Trên đầu" then offset = CFrame.new(0, _G.AttackDist, 0) * CFrame.Angles(math.rad(-90), 0, 0)
            elseif _G.AttackPos == "Dưới chân" then offset = CFrame.new(0, -_G.AttackDist, 0) * CFrame.Angles(math.rad(90), 0, 0)
            elseif _G.AttackPos == "Sau lưng" then offset = CFrame.new(0, 0, _G.AttackDist)
            elseif _G.AttackPos == "Trước mặt" then offset = CFrame.new(0, 0, -_G.AttackDist) * CFrame.Angles(0, math.rad(180), 0) end
            hrp.CFrame = target.HumanoidRootPart.CFrame * offset
        else
            if bv then bv:Destroy() end
        end

        -- AUTO ĐỔI VŨ KHÍ & ĐÁNH
        if _G.AutoEquip and char and #_G.SelectedWeapons > 0 then
            if #_G.SelectedWeapons == 1 then
                local curW = char:FindFirstChild(_G.SelectedWeapons[1])
                if not curW then local t = Player.Backpack:FindFirstChild(_G.SelectedWeapons[1]); if t then char.Humanoid:EquipTool(t) end end
            else
                if tick() - _G.LastWepTick >= _G.WepDelay then
                    _G.LastWepTick = tick()
                    _G.WepIdx = _G.WepIdx + 1; if _G.WepIdx > #_G.SelectedWeapons then _G.WepIdx = 1 end
                    char.Humanoid:UnequipTools()
                    local t = Player.Backpack:FindFirstChild(_G.SelectedWeapons[_G.WepIdx]); if t then char.Humanoid:EquipTool(t) end
                end
            end
        end

        if _G.AutoAttack and char then local t = char:FindFirstChildOfClass("Tool"); if t then t:Activate() end end
        if isFarming or _G.AutoAttack then
            if _G.AutoZ then FastSkill(Enum.KeyCode.Z) end; if _G.AutoX then FastSkill(Enum.KeyCode.X) end
            if _G.AutoC then FastSkill(Enum.KeyCode.C) end; if _G.AutoV then FastSkill(Enum.KeyCode.V) end
        end
    end
end)
