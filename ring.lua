-- 1. TẠO GIAO DIỆN CƠ BẢN TỪ SỐ 0
local CoreGui = game:GetService("CoreGui")
local Player = game.Players.LocalPlayer

-- Xóa menu cũ nếu bấm chạy nhiều lần
local existingUI = CoreGui:FindFirstChild("BasicRockFruitUI") or Player:WaitForChild("PlayerGui"):FindFirstChild("BasicRockFruitUI")
if existingUI then existingUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BasicRockFruitUI"
-- Tự động tương thích với mọi Executor
local success = pcall(function() ScreenGui.Parent = CoreGui end)
if not success then ScreenGui.Parent = Player:WaitForChild("PlayerGui") end

-- Khung Menu Chính
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 300, 0, 380)
MainFrame.Position = UDim2.new(0.5, -150, 0.4, -150)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true -- Có thể kéo thả menu

-- Tiêu đề
local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = " Rock Fruit | Bản Cơ Bản"
Title.Font = Enum.Font.Code
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

-- Nút Quét Quái
local RefreshBtn = Instance.new("TextButton", MainFrame)
RefreshBtn.Size = UDim2.new(0.9, 0, 0, 35)
RefreshBtn.Position = UDim2.new(0.05, 0, 0, 45)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshBtn.Text = "🔄 Quét Lại Quái Trong Map"
RefreshBtn.Font = Enum.Font.SourceSansBold
RefreshBtn.TextSize = 16

-- Ô vuông chứa danh sách quái (Có thể cuộn)
local ScrollFrame = Instance.new("ScrollingFrame", MainFrame)
ScrollFrame.Size = UDim2.new(0.9, 0, 0, 180)
ScrollFrame.Position = UDim2.new(0.05, 0, 0, 90)
ScrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ScrollFrame.ScrollBarThickness = 5

local UIListLayout = Instance.new("UIListLayout", ScrollFrame)
UIListLayout.Padding = UDim.new(0, 2)

-- Nút Bật/Tắt Auto Farm
local FarmBtn = Instance.new("TextButton", MainFrame)
FarmBtn.Size = UDim2.new(0.9, 0, 0, 45)
FarmBtn.Position = UDim2.new(0.05, 0, 0, 285)
FarmBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
FarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FarmBtn.Text = "Auto Farm: TẮT"
FarmBtn.Font = Enum.Font.SourceSansBold
FarmBtn.TextSize = 18

-- Nút thu gọn UI (Dấu X)
local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextSize = 20
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

---------------------------------------------------------
-- 2. BIẾN LƯU TRỮ VÀ LOGIC HOẠT ĐỘNG
---------------------------------------------------------
_G.SelectedMobs = {}
_G.AutoFarm = false

-- Hàm tạo một ô chọn quái (Checkbox)
local function AddMobToggle(mobName)
    local btn = Instance.new("TextButton", ScrollFrame)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Text = "☐ " .. mobName -- Mặc định là ô trống
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16

    local isSelected = false
    btn.MouseButton1Click:Connect(function()
        isSelected = not isSelected
        if isSelected then
            btn.Text = "☑ " .. mobName
            btn.TextColor3 = Color3.fromRGB(50, 255, 50) -- Đổi màu xanh
            table.insert(_G.SelectedMobs, mobName)
        else
            btn.Text = "☐ " .. mobName
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            -- Xóa quái khỏi danh sách đã chọn
            for i, v in ipairs(_G.SelectedMobs) do
                if v == mobName then table.remove(_G.SelectedMobs, i) break end
            end
        end
    end)
end

-- Chức năng Nút Quét Quái
RefreshBtn.MouseButton1Click:Connect(function()
    -- Xóa list cũ
    for _, child in ipairs(ScrollFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    _G.SelectedMobs = {}
    
    -- Lấy quái trong workspace
    local foundMobs = {}
    for _, v in pairs(workspace:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Name ~= Player.Name then
            if not table.find(foundMobs, v.Name) then
                table.insert(foundMobs, v.Name)
            end
        end
    end
    
    -- Nếu map chưa load kịp, tạo quái mẫu để test
    if #foundMobs == 0 then foundMobs = {"Monkey", "Bandit", "Boss"} end
    
    for _, mob in ipairs(foundMobs) do AddMobToggle(mob) end
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, #foundMobs * 32)
end)

-- Chức năng Bật/Tắt Farm
FarmBtn.MouseButton1Click:Connect(function()
    _G.AutoFarm = not _G.AutoFarm
    if _G.AutoFarm then
        FarmBtn.Text = "Auto Farm: ĐANG BẬT"
        FarmBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
    else
        FarmBtn.Text = "Auto Farm: TẮT"
        FarmBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    end
end)

-- Tạo sẵn danh sách quái ban đầu
RefreshBtn:     -- Kích hoạt click giả để load quái lần đầu

---------------------------------------------------------
-- 3. VÒNG LẶP AUTO FARM (MAIN LOOP)
---------------------------------------------------------
task.spawn(function()
    while task.wait(0.1) do
        if _G.AutoFarm and #_G.SelectedMobs > 0 then
            -- Ở đây bạn nhúng code CFrame Teleport tới quái
            -- và dùng VirtualInputManager để tự động Click / xả Skill
        end
    end
end)
