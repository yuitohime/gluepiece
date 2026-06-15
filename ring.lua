-- =========================================================================
-- FAST ATTACK (ĐÁNH NHANH) - MENU TÁCH BIỆT
-- =========================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local CoreGui = (gethui and pcall(gethui) and gethui()) or game:GetService("CoreGui")
local player = Players.LocalPlayer

-- Xóa GUI cũ nếu có
if not pcall(function() local _ = CoreGui.Name end) then CoreGui = player:WaitForChild("PlayerGui") end
for _, gui in pairs(CoreGui:GetChildren()) do 
    if gui.Name == "AutoAttack_Menu" then gui:Destroy() end 
end

-- ============================
-- BIẾN GLOBAL
-- ============================
_G.AutoAttack = false
_G.AutoEquip = true  -- Mặc định tự động cầm vũ khí
_G.AttackDelay = 10  -- Đơn vị mili-giây (ms). 10ms = 0.01 giây (Cực nhanh)

-- ============================
-- HÀM CẢM ỨNG
-- ============================
local function BindTap(element, callback)
    local debounce = false
    element.Activated:Connect(function()
        if not debounce then
            debounce = true callback() task.wait(0.1) debounce = false
        end
    end)
end

-- ============================
-- TẠO MENU UI
-- ============================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoAttack_Menu"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 220, 0, 160)
MainFrame.Position = UDim2.new(0.5, 120, 0.2, 0) -- Đặt lệch sang phải một chút để không đè lên menu khác
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Active = true
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(255, 50, 50)

-- HEADER
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 30)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 30) 
Header.Active = true
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 8)

local HeaderCover = Instance.new("Frame", Header)
HeaderCover.Size = UDim2.new(1, 0, 0, 5)
HeaderCover.Position = UDim2.new(0, 0, 1, -5)
HeaderCover.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
HeaderCover.BorderSizePixel = 0

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -30, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "FAST ATTACK PRO"
Title.TextColor3 = Color3.fromRGB(255, 50, 50)
Title.Font = Enum.Font.GothamBold
Title.TextSize = 12
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", Header)
CloseBtn.Size = UDim2.new(0, 30, 0, 30)
CloseBtn.Position = UDim2.new(1, -30, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.Text = "X"
CloseBtn.TextColor3 = Color3.fromRGB(255, 75, 75)
CloseBtn.Font = Enum.Font.GothamBold
CloseBtn.TextSize = 13

BindTap(CloseBtn, function()
    _G.AutoAttack = false
    ScreenGui:Destroy()
end)

-- KÉO THẢ
local dragging, dragInput, dragStart, startPos
Header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true dragStart = input.Position startPos = MainFrame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
Header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
UserInputService.InputChanged:Connect(function(input)
    if input == dragInput and dragging then 
        local delta = input.Position - dragStart
        MainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

local ContentFrame = Instance.new("Frame", MainFrame)
ContentFrame.Size = UDim2.new(1, 0, 1, -30)
ContentFrame.Position = UDim2.new(0, 0, 0, 30)
ContentFrame.BackgroundTransparency = 1

local Layout = Instance.new("UIListLayout", ContentFrame)
Layout.Padding = UDim.new(0, 6)
Layout.HorizontalAlignment = Enum.HorizontalAlignment.Center

local spacer = Instance.new("Frame", ContentFrame) spacer.Size = UDim2.new(1,0,0,1) spacer.BackgroundTransparency = 1

-- ============================
-- THANH KÉO TỐC ĐỘ (SLIDER)
-- ============================
local SliderFrame = Instance.new("Frame", ContentFrame)
SliderFrame.Size = UDim2.new(0.9, 0, 0, 35)
SliderFrame.BackgroundTransparency = 1

local DelayLabel = Instance.new("TextLabel", SliderFrame)
DelayLabel.Size = UDim2.new(1, 0, 0, 15)
DelayLabel.BackgroundTransparency = 1
DelayLabel.Text = "Tốc độ chém: " .. _G.AttackDelay .. " ms"
DelayLabel.TextColor3 = Color3.fromRGB(200, 200, 200)
DelayLabel.Font = Enum.Font.GothamBold
DelayLabel.TextSize = 10
DelayLabel.TextXAlignment = Enum.TextXAlignment.Left

local SliderBg = Instance.new("Frame", SliderFrame)
SliderBg.Size = UDim2.new(1, 0, 0, 14)
SliderBg.Position = UDim2.new(0, 0, 0, 18)
SliderBg.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Instance.new("UICorner", SliderBg).CornerRadius = UDim.new(0, 4)

local SliderFill = Instance.new("Frame", SliderBg)
local maxMs = 500
local pct = _G.AttackDelay / maxMs
SliderFill.Size = UDim2.new(pct, 0, 1, 0)
SliderFill.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
Instance.new("UICorner", SliderFill).CornerRadius = UDim.new(0, 4)

local isDragging = false
SliderBg.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = true
    end
end)

local function UpdateSlider(input)
    local posX = math.clamp(input.Position.X - SliderBg.AbsolutePosition.X, 0, SliderBg.AbsoluteSize.X)
    local percent = posX / SliderBg.AbsoluteSize.X
    -- Căn chỉnh từ 0 ms (nhanh nhất) đến 500 ms (chậm)
    _G.AttackDelay = math.floor(percent * maxMs)
    SliderFill.Size = UDim2.new(percent, 0, 1, 0)
    DelayLabel.Text = "Tốc độ chém: " .. _G.AttackDelay .. " ms"
end

UserInputService.InputChanged:Connect(function(input)
    if isDragging and (input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch) then
        UpdateSlider(input)
    end
end)
UserInputService.InputEnded:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        isDragging = false
    end
end)

-- ============================
-- NÚT TỰ ĐỘNG CẦM VŨ KHÍ
-- ============================
local EquipToggle = Instance.new("TextButton", ContentFrame)
EquipToggle.Size = UDim2.new(0.9, 0, 0, 25)
EquipToggle.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
EquipToggle.Text = "Tự động rút vũ khí [ON]"
EquipToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
EquipToggle.Font = Enum.Font.GothamBold
EquipToggle.TextSize = 11
Instance.new("UICorner", EquipToggle).CornerRadius = UDim.new(0, 4)

BindTap(EquipToggle, function()
    _G.AutoEquip = not _G.AutoEquip
    if _G.AutoEquip then
        EquipToggle.BackgroundColor3 = Color3.fromRGB(255, 120, 0)
        EquipToggle.Text = "Tự động rút vũ khí [ON]"
    else
        EquipToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        EquipToggle.Text = "Tự động rút vũ khí [OFF]"
    end
end)

-- ============================
-- NÚT BẬT/TẮT AUTO ĐÁNH
-- ============================
local AttackToggle = Instance.new("TextButton", ContentFrame)
AttackToggle.Size = UDim2.new(0.9, 0, 0, 30)
AttackToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
AttackToggle.Text = "AUTO ATTACK [OFF]"
AttackToggle.TextColor3 = Color3.fromRGB(255, 255, 255)
AttackToggle.Font = Enum.Font.GothamBold
AttackToggle.TextSize = 12
Instance.new("UICorner", AttackToggle).CornerRadius = UDim.new(0, 4)
local AttackStroke = Instance.new("UIStroke", AttackToggle)
AttackStroke.Color = Color3.fromRGB(255, 50, 50)
AttackStroke.Thickness = 1

BindTap(AttackToggle, function()
    _G.AutoAttack = not _G.AutoAttack
    if _G.AutoAttack then
        AttackToggle.BackgroundColor3 = Color3.fromRGB(255, 50, 50)
        AttackToggle.Text = "AUTO ATTACK [ON]"
    else
        AttackToggle.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        AttackToggle.Text = "AUTO ATTACK [OFF]"
    end
end)

-- ============================
-- VÒNG LẶP XỬ LÝ AUTO ATTACK
-- ============================
task.spawn(function()
    while true do
        -- Đợi theo mili-giây (chia cho 1000 để ra giây)
        -- Dùng RunService.Heartbeat:Wait() nếu delay = 0 để đạt tốc độ khung hình
        if _G.AttackDelay <= 0 then
            game:GetService("RunService").Heartbeat:Wait()
        else
            task.wait(_G.AttackDelay / 1000)
        end

        if _G.AutoAttack and player.Character then
            local humanoid = player.Character:FindFirstChild("Humanoid")
            if humanoid and humanoid.Health > 0 then
                
                -- Tìm xem nhân vật đang cầm Tool (vũ khí) nào không
                local equippedTool = player.Character:FindFirstChildOfClass("Tool")
                
                -- Nếu tính năng tự rút vũ khí bật và chưa cầm gì
                if not equippedTool and _G.AutoEquip then
                    local backpack = player:FindFirstChild("Backpack")
                    if backpack then
                        local tool = backpack:FindFirstChildOfClass("Tool")
                        if tool then
                            humanoid:EquipTool(tool)
                            equippedTool = tool
                        end
                    end
                end

                -- Thực hiện hành động chém
                if equippedTool then
                    equippedTool:Activate()
                end
            end
        end
    end
end)
