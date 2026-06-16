-- =======================================================
-- MÀN HÌNH BẮT ATTACK ĐỘC LẬP (CHỐNG SPAM LOG)
-- =======================================================
local CoreGui = (gethui and pcall(gethui) and gethui()) or game:GetService("CoreGui")
if CoreGui:FindFirstChild("AttackSpyGUI") then CoreGui.AttackSpyGUI:Destroy() end

local sg = Instance.new("ScreenGui", CoreGui)
sg.Name = "AttackSpyGUI"
sg.ResetOnSpawn = false

local frame = Instance.new("Frame", sg)
frame.Size = UDim2.new(0, 320, 0, 250)
frame.Position = UDim2.new(0.5, -160, 0.3, 0)
frame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
frame.BorderSizePixel = 0
frame.Active = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0, 8)
Instance.new("UIStroke", frame).Color = Color3.fromRGB(255, 50, 50)

-- Tiêu đề & Kéo thả
local header = Instance.new("Frame", frame)
header.Size = UDim2.new(1, 0, 0, 30)
header.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
Instance.new("UICorner", header).CornerRadius = UDim.new(0, 8)

local headerCover = Instance.new("Frame", header)
headerCover.Size = UDim2.new(1, 0, 0, 5)
headerCover.Position = UDim2.new(0, 0, 1, -5)
headerCover.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
headerCover.BorderSizePixel = 0

local title = Instance.new("TextLabel", header)
title.Size = UDim2.new(1, 0, 1, 0)
title.BackgroundTransparency = 1
title.Text = " 🎯 BẢNG BẮT ATTACK (KÉO ĐỂ DI CHUYỂN)"
title.TextColor3 = Color3.fromRGB(255, 100, 100)
title.Font = Enum.Font.GothamBold
title.TextSize = 12

-- Logic Kéo thả
local dragging, dragInput, dragStart, startPos
header.InputBegan:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
        dragging = true dragStart = input.Position startPos = frame.Position
        input.Changed:Connect(function() if input.UserInputState == Enum.UserInputState.End then dragging = false end end)
    end
end)
header.InputChanged:Connect(function(input)
    if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then dragInput = input end
end)
game:GetService("UserInputService").InputChanged:Connect(function(input)
    if input == dragInput and dragging then 
        local delta = input.Position - dragStart
        frame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
    end
end)

-- Khung chứa văn bản
local scroll = Instance.new("ScrollingFrame", frame)
scroll.Size = UDim2.new(1, -10, 1, -40)
scroll.Position = UDim2.new(0, 5, 0, 35)
scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
scroll.AutomaticCanvasSize = Enum.AutomaticSize.Y
scroll.BackgroundColor3 = Color3.fromRGB(15, 15, 15)
scroll.ScrollBarThickness = 4
scroll.BorderSizePixel = 0

local list = Instance.new("UIListLayout", scroll)
list.Padding = UDim.new(0, 8)

-- Hàm in chữ ra màn hình mini
local function logMsg(txt)
    local l = Instance.new("TextLabel", scroll)
    l.Size = UDim2.new(1, -5, 0, 0)
    l.AutomaticSize = Enum.AutomaticSize.Y
    l.TextWrapped = true
    l.TextXAlignment = Enum.TextXAlignment.Left
    l.Text = txt
    l.TextColor3 = Color3.fromRGB(0, 255, 150)
    l.Font = Enum.Font.Code
    l.TextSize = 11
    l.BackgroundTransparency = 1
end

logMsg("Đang chờ bạn bấm chém/dùng chiêu...")

-- BỘ LỌC BẮT SÓNG LỆNH CHÉM
local mt = getrawmetatable(game)
local oldNamecall = mt.__namecall
setreadonly(mt, false)

mt.__namecall = newcclosure(function(self, ...)
    local method = getnamecallmethod()
    if method == "FireServer" or method == "InvokeServer" then
        local name = string.lower(tostring(self.Name))
        -- Chỉ bắt đúng các từ khóa liên quan tới tấn công
        if name:match("attack") or name:match("combat") or name:match("hit") or name:match("damage") or name:match("melee") then
            local path = self:GetFullName()
            local args = {...}
            local argStr = ""
            for i, v in ipairs(args) do
                argStr = argStr .. "   ["..i.."] = " .. tostring(v) .. "\n"
            end
            
            local finalTxt = "🔥 TÊN: " .. self.Name .. "\n📂 ĐƯỜNG DẪN:\n" .. path .. "\n⚙️ THAM SỐ (ARGS):\n" .. (argStr == "" and "   (Không có tham số)" or argStr) .. "-----------------------"
            
            -- Đẩy lên màn hình mini
            task.spawn(function() logMsg(finalTxt) end)
        end
    end
    return oldNamecall(self, ...)
end)
setreadonly(mt, true)
