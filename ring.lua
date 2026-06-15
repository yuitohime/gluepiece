-- =========================================================================
-- AUTO COLLECT SAFE BOX - MENU TÁCH BIỆT
-- =========================================================================

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local UserInputService = game:GetService("UserInputService")
local CoreGui = (gethui and pcall(gethui) and gethui()) or game:GetService("CoreGui")
local player = Players.LocalPlayer

-- Xóa GUI cũ nếu có để không bị đè lên nhau
if not pcall(function() local _ = CoreGui.Name end) then CoreGui = player:WaitForChild("PlayerGui") end
for _, gui in pairs(CoreGui:GetChildren()) do 
    if gui.Name == "AutoBox_Menu" then gui:Destroy() end 
end

-- Biến Global
_G.AutoBox = false
_G.BoxDelay = 0.3 -- Thời gian trễ giữa mỗi lần bay đến Box (0.3s là an toàn)

-- ============================
-- 1. HÀM CẢM ỨNG CHUẨN MOBILE
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
-- 2. TẠO MENU UI
-- ============================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "AutoBox_Menu"
ScreenGui.Parent = CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 220, 0, 120)
MainFrame.Position = UDim2.new(0.5, -110, 0.2, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
MainFrame.Active = true
MainFrame.BorderSizePixel = 0
Instance.new("UICorner", MainFrame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", MainFrame).Color = Color3.fromRGB(255, 170, 0)

-- HEADER
local Header = Instance.new("Frame", MainFrame)
Header.Size = UDim2.new(1, 0, 0, 30)
Header.BackgroundColor3 = Color3.fromRGB(30, 30, 30) 
Header.Active = true
Instance.new("UICorner", Header).CornerRadius = UDim.new(0, 8)

local Title = Instance.new("TextLabel", Header)
Title.Size = UDim2.new(1, -30, 1, 0)
Title.Position = UDim2.new(0, 10, 0, 0)
Title.BackgroundTransparency = 1
Title.Text = "AUTO NHẶT BOX"
Title.TextColor3 = Color3.fromRGB(255, 170, 0)
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

-- Đóng GUI
BindTap(CloseBtn, function()
    _G.AutoBox = false
    ScreenGui:Destroy()
end)

-- THUẬT TOÁN KÉO THẢ MƯỢT MÀ
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

-- NÚT BẬT/TẮT AUTO
local ToggleBtn = Instance.new("TextButton", MainFrame)
ToggleBtn.Size = UDim2.new(0.9, 0, 0, 35)
ToggleBtn.Position = UDim2.new(0.05, 0, 0, 55)
ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ToggleBtn.Text = "Auto SafeBox [OFF]"
ToggleBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
ToggleBtn.Font = Enum.Font.GothamBold
ToggleBtn.TextSize = 12
Instance.new("UICorner", ToggleBtn).CornerRadius = UDim.new(0, 6)

BindTap(ToggleBtn, function()
    _G.AutoBox = not _G.AutoBox
    if _G.AutoBox then
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(255, 170, 0)
        ToggleBtn.Text = "Auto SafeBox [ON]"
    else
        ToggleBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        ToggleBtn.Text = "Auto SafeBox [OFF]"
    end
end)

-- ============================
-- 3. HÀM TÌM BOX
-- ============================
local function GetSafeBoxes()
    local boxes = {}
    -- Quét toàn bộ map tìm "SpawnBox"
    for _, obj in pairs(Workspace:GetDescendants()) do
        if obj.Name == "SpawnBox" then
            -- Lấy tất cả "SafeBoxWall" bên trong SpawnBox
            for _, child in pairs(obj:GetChildren()) do
                if child.Name == "SafeBoxWall" and child:IsA("BasePart") then
                    table.insert(boxes, child)
                end
            end
        end
    end
    return boxes
end

-- ============================
-- 4. VÒNG LẶP AUTO NHẶT BOX
-- ============================
task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoBox then
            local rootPart = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
            if not rootPart then continue end

            local boxes = GetSafeBoxes()
            
            -- Nếu có Box trên bản đồ, bắt đầu đi nhặt
            if #boxes > 0 then
                for i, box in ipairs(boxes) do
                    -- Nếu người dùng tắt Auto hoặc nhân vật chết thì dừng lại ngay
                    if not _G.AutoBox or not player.Character:FindFirstChild("HumanoidRootPart") then 
                        break 
                    end
                    
                    -- Kiểm tra xem box còn tồn tại trong game không (tránh lỗi khi box vừa bị người khác ăn)
                    if box and box.Parent then
                        -- Bay thẳng tới tọa độ của Box
                        rootPart.CFrame = box.CFrame
                        
                        -- Chờ một khoảng nhỏ để server xác nhận nhân vật đã chạm vào box
                        task.wait(_G.BoxDelay)
                    end
                end
            end
        end
    end
end)
