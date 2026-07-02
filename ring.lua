-- ==========================================
-- 1. TẠO GIAO DIỆN (ĐẢM BẢO KHÔNG LỖI)
-- ==========================================
local CoreGui = game:GetService("CoreGui")
local Player = game.Players.LocalPlayer

-- Xóa UI cũ nếu bấm chạy nhiều lần để tránh đè lên nhau
local existingUI = CoreGui:FindFirstChild("BasicRockFruitUI") or Player:WaitForChild("PlayerGui"):FindFirstChild("BasicRockFruitUI")
if existingUI then existingUI:Destroy() end

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BasicRockFruitUI"
ScreenGui.ResetOnSpawn = false

-- Tự động tương thích: Nếu Executor chặn CoreGui thì đẩy vào PlayerGui
local success = pcall(function() ScreenGui.Parent = CoreGui end)
if not success then ScreenGui.Parent = Player:WaitForChild("PlayerGui") end

-- ==========================================
-- 2. THIẾT KẾ KHUNG MENU
-- ==========================================
local MainFrame = Instance.new("Frame", ScreenGui)
MainFrame.Size = UDim2.new(0, 300, 0, 440) -- Kéo dài ra một chút để chứa nút Auto Attack
MainFrame.Position = UDim2.new(0.5, -150, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
MainFrame.Active = true
MainFrame.Draggable = true

local Title = Instance.new("TextLabel", MainFrame)
Title.Size = UDim2.new(1, 0, 0, 35)
Title.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
Title.TextColor3 = Color3.fromRGB(255, 255, 255)
Title.Text = " Rock Fruit | Bản Fix Hoàn Chỉnh"
Title.Font = Enum.Font.Code
Title.TextSize = 16
Title.TextXAlignment = Enum.TextXAlignment.Left

local CloseBtn = Instance.new("TextButton", MainFrame)
CloseBtn.Size = UDim2.new(0, 35, 0, 35)
CloseBtn.Position = UDim2.new(1, -35, 0, 0)
CloseBtn.BackgroundTransparency = 1
CloseBtn.TextColor3 = Color3.fromRGB(255, 50, 50)
CloseBtn.Text = "X"
CloseBtn.TextSize = 20
CloseBtn.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)

local RefreshBtn = Instance.new("TextButton", MainFrame)
RefreshBtn.Size = UDim2.new(0.9, 0, 0, 35)
RefreshBtn.Position = UDim2.new(0.05, 0, 0, 45)
RefreshBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 215)
RefreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
RefreshBtn.Text = "🔄 Quét Lại Quái Trong Map"
RefreshBtn.Font = Enum.Font.SourceSansBold
RefreshBtn.TextSize = 16

local ScrollFrame = Instance.new("ScrollingFrame", MainFrame)
ScrollFrame.Size = UDim2.new(0.9, 0, 0, 180)
ScrollFrame.Position = UDim2.new(0.05, 0, 0, 90)
ScrollFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
ScrollFrame.ScrollBarThickness = 5

local UIListLayout = Instance.new("UIListLayout", ScrollFrame)
UIListLayout.Padding = UDim.new(0, 2)

local FarmBtn = Instance.new("TextButton", MainFrame)
FarmBtn.Size = UDim2.new(0.9, 0, 0, 45)
FarmBtn.Position = UDim2.new(0.05, 0, 0, 285)
FarmBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
FarmBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
FarmBtn.Text = "Auto Farm: TẮT"
FarmBtn.Font = Enum.Font.SourceSansBold
FarmBtn.TextSize = 18

-- Nút Bật/Tắt Auto Attack mới
local AttackBtn = Instance.new("TextButton", MainFrame)
AttackBtn.Size = UDim2.new(0.9, 0, 0, 45)
AttackBtn.Position = UDim2.new(0.05, 0, 0, 340)
AttackBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
AttackBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
AttackBtn.Text = "Auto Attack: TẮT"
AttackBtn.Font = Enum.Font.SourceSansBold
AttackBtn.TextSize = 18

-- ==========================================
-- 3. LOGIC HOẠT ĐỘNG CHÍNH
-- ==========================================
_G.SelectedMobs = {}
_G.AutoFarm = false
_G.AutoAttack = false

-- Hàm tạo ô tick chọn quái
local function AddMobToggle(mobName)
    local btn = Instance.new("TextButton", ScrollFrame)
    btn.Size = UDim2.new(1, 0, 0, 30)
    btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
    btn.TextColor3 = Color3.fromRGB(200, 200, 200)
    btn.Text = "☐ " .. mobName
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 16

    local isSelected = false
    btn.MouseButton1Click:Connect(function()
        isSelected = not isSelected
        if isSelected then
            btn.Text = "☑ " .. mobName
            btn.TextColor3 = Color3.fromRGB(50, 255, 50)
            table.insert(_G.SelectedMobs, mobName)
        else
            btn.Text = "☐ " .. mobName
            btn.TextColor3 = Color3.fromRGB(200, 200, 200)
            for i, v in ipairs(_G.SelectedMobs) do
                if v == mobName then table.remove(_G.SelectedMobs, i) break end
            end
        end
    end)
end

-- Hàm thực thi Quét Quái
local function LoadMobs()
    -- Xóa list cũ trên UI
    for _, child in ipairs(ScrollFrame:GetChildren()) do
        if child:IsA("TextButton") then child:Destroy() end
    end
    _G.SelectedMobs = {}
    
    local foundMobs = {}
    for _, v in pairs(workspace:GetChildren()) do
        if v:FindFirstChild("Humanoid") and v.Name ~= Player.Name then
            if not table.find(foundMobs, v.Name) then
                table.insert(foundMobs, v.Name)
            end
        end
    end
    
    -- Dữ liệu mẫu test nếu map chưa kịp load
    if #foundMobs == 0 then foundMobs = {"Monkey", "Bandit", "Boss"} end
    
    for _, mob in ipairs(foundMobs) do AddMobToggle(mob) end
    ScrollFrame.CanvasSize = UDim2.new(0, 0, 0, #foundMobs * 32)
end

-- Gán sự kiện Click
RefreshBtn.MouseButton1Click:Connect(LoadMobs)

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

AttackBtn.MouseButton1Click:Connect(function()
    _G.AutoAttack = not _G.AutoAttack
    if _G.AutoAttack then
        AttackBtn.Text = "Auto Attack: ĐANG BẬT"
        AttackBtn.BackgroundColor3 = Color3.fromRGB(40, 180, 40)
    else
        AttackBtn.Text = "Auto Attack: TẮT"
        AttackBtn.BackgroundColor3 = Color3.fromRGB(180, 40, 40)
    end
end)

-- Chạy quét quái ngay khi vừa mở Menu
LoadMobs()

-- ==========================================
-- 4. VÒNG LẶP AUTO (FARM & ATTACK)
-- ==========================================
local VirtualUser = game:GetService("VirtualUser")

task.spawn(function()
    while task.wait() do
        
        -- Tính năng Auto Attack (Tự động chém/click)
        if _G.AutoAttack then
            -- Tự động giả lập click chuột trái để chém
            VirtualUser:CaptureController()
            VirtualUser:ClickButton1(Vector2.new(0, 0))
            
            -- Code phụ: Tự động kích hoạt skill của vũ khí đang cầm (nếu có)
            local char = Player.Character
            if char then
                local equippedTool = char:FindFirstChildOfClass("Tool")
                if equippedTool then
                    equippedTool:Activate()
                end
            end
            task.wait(0.1) -- Delay nhỏ để không bị lag/kick
        end

        -- Tính năng Auto Farm (Bạn sẽ chèn code CFrame vào đây)
        if _G.AutoFarm and #_G.SelectedMobs > 0 then
            -- Code lấy vị trí quái trong _G.SelectedMobs và dịch chuyển (CFrame)
            -- ...
        end
        
    end
end)
