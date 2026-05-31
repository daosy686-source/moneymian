--[[
    Blox Fruits GUI Script - Potassium Edition
    Mô phỏng đầy đủ chức năng của BF-Beta.lua
    Chạy trực tiếp trên Potassium (không cần loadstring)
]]

local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local CommF = Remotes:WaitForChild("CommF_")
local VIM = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")

-- ==================== CÀI ĐẶT ====================
local Settings = {
    AutoFarm = false,
    AutoStats = false,
    FarmZone = "Bandit",        -- Mặc định
    StatPriority = "Melee",     -- Chỉ số ưu tiên cộng
    ESP = false,
    AutoRaid = false,
    AutoBuy = false,
    BuyItem = "Sword"           -- Vũ khí hoặc trái
}

-- Danh sách vùng farm
local FarmZones = {
    ["Bandit"] = {CFrame = CFrame.new(1050, 16, 1550), Enemies = workspace.Enemies},
    ["Monkey"] = {CFrame = CFrame.new(-1240, 12, 560), Enemies = workspace.Enemies},
    ["Pirate"] = {CFrame = CFrame.new(-1120, 15, 4350), Enemies = workspace.Enemies},
    -- Thêm các vùng khác tương tự
}

-- Danh sách đảo teleport
local Islands = {
    ["Start"] = CFrame.new(1070, 16, 1450),
    ["Jungle"] = CFrame.new(-1240, 12, 560),
    ["Pirate Village"] = CFrame.new(-1120, 15, 4350),
    ["Desert"] = CFrame.new(1090, 16, 4350),
    ["Snow"] = CFrame.new(-1300, 16, -13000),
    ["Marine Fortress"] = CFrame.new(-5500, 100, -3000),
    ["Skylands"] = CFrame.new(-4950, 720, -2650),
    ["Prison"] = CFrame.new(4800, 30, 2200),
    ["Colosseum"] = CFrame.new(-1600, 30, -3000),
    ["Magma Village"] = CFrame.new(-5300, 40, 8400),
    ["Underwater City"] = CFrame.new(5500, 20, -800),
    ["Fountain City"] = CFrame.new(5000, 30, 4000),
    ["Shank's Room"] = CFrame.new(-1450, 30, -5000),
    ["Mob Island"] = CFrame.new(-12000, 30, -7000)
}

-- ==================== GIAO DIỆN ====================
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BF_Hub"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 250, 0, 350)
MainFrame.Position = UDim2.new(0.5, -125, 0.3, 0)
MainFrame.BackgroundColor3 = Color3.fromRGB(30,30,30)
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Parent = ScreenGui

local Title = Instance.new("TextLabel")
Title.Size = UDim2.new(1,0,0,30)
Title.BackgroundColor3 = Color3.fromRGB(255,100,0)
Title.Text = "Blox Fruits Hub"
Title.TextColor3 = Color3.new(1,1,1)
Title.Font = Enum.Font.SourceSansBold
Title.TextSize = 16
Title.Parent = MainFrame

-- Hàm tạo nút
local function CreateButton(parent, text, position, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 110, 0, 25)
    btn.Position = position
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.Parent = parent
    btn.MouseButton1Click:Connect(callback)
    return btn
end

-- Toggle nút
local function CreateToggle(parent, text, position, default, callback)
    local toggle = Instance.new("TextButton")
    toggle.Size = UDim2.new(0, 110, 0, 25)
    toggle.Position = position
    toggle.BackgroundColor3 = default and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)
    toggle.Text = text .. " " .. (default and "ON" or "OFF")
    toggle.TextColor3 = Color3.new(1,1,1)
    toggle.Font = Enum.Font.SourceSans
    toggle.TextSize = 14
    toggle.Parent = parent
    local state = default
    toggle.MouseButton1Click:Connect(function()
        state = not state
        toggle.BackgroundColor3 = state and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)
        toggle.Text = text .. " " .. (state and "ON" or "OFF")
        callback(state)
    end)
    return toggle
end

-- Dropdown đơn giản (dùng TextButton chuyển đổi)
local function CreateDropdown(parent, text, position, options, default, callback)
    local frame = Instance.new("Frame")
    frame.Size = UDim2.new(0, 110, 0, 25)
    frame.Position = position
    frame.BackgroundColor3 = Color3.fromRGB(50,50,50)
    frame.Parent = parent

    local label = Instance.new("TextLabel")
    label.Size = UDim2.new(1,0,1,0)
    label.BackgroundTransparency = 1
    label.Text = text .. ": " .. default
    label.TextColor3 = Color3.new(1,1,1)
    label.Font = Enum.Font.SourceSans
    label.TextSize = 14
    label.Parent = frame

    local idx = table.find(options, default) or 1
    frame.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 then
            idx = idx % #options + 1
            local val = options[idx]
            label.Text = text .. ": " .. val
            callback(val)
        end
    end)
end

-- Bố trí các nút
CreateToggle(MainFrame, "Auto Farm", UDim2.new(0,10,0,35), false, function(v) Settings.AutoFarm = v end)
CreateDropdown(MainFrame, "Farm Zone", UDim2.new(0,130,0,35), {"Bandit","Monkey","Pirate"}, "Bandit", function(v) Settings.FarmZone = v end)

CreateToggle(MainFrame, "Auto Stats", UDim2.new(0,10,0,70), false, function(v) Settings.AutoStats = v end)
CreateDropdown(MainFrame, "Stat Prio", UDim2.new(0,130,0,70), {"Melee","Defense","Sword","Gun","Demon Fruit"}, "Melee", function(v) Settings.StatPriority = v end)

CreateToggle(MainFrame, "ESP", UDim2.new(0,10,0,105), false, function(v) Settings.ESP = v end)
CreateToggle(MainFrame, "Auto Raid", UDim2.new(0,130,0,105), false, function(v) Settings.AutoRaid = v end)

CreateDropdown(MainFrame, "Teleport", UDim2.new(0,10,0,140), {"Start","Jungle","Pirate Village","Desert","Snow","Marine Fortress","Skylands","Prison","Colosseum","Magma Village","Underwater City","Fountain City","Shank's Room","Mob Island"}, "Start", function(v)
    if Islands[v] and Player.Character then
        HRP.CFrame = Islands[v]
    end
end)

CreateButton(MainFrame, "Reset", UDim2.new(0,10,0,180), function()
    if Player.Character then Player.Character:BreakJoints() end
end)

CreateToggle(MainFrame, "Auto Buy", UDim2.new(0,10,0,215), false, function(v) Settings.AutoBuy = v end)
CreateDropdown(MainFrame, "Buy Item", UDim2.new(0,130,0,215), {"Sword","Gun","Blox Fruit"}, "Sword", function(v) Settings.BuyItem = v end)

-- ==================== CHỨC NĂNG ====================
-- Auto Farm
RunService.Heartbeat:Connect(function()
    if Settings.AutoFarm and Player.Character then
        pcall(function()
            local zone = FarmZones[Settings.FarmZone]
            if not zone then return end
            local enemies = zone.Enemies:GetChildren()
            local target = nil
            local minDist = math.huge
            for _, enemy in pairs(enemies) do
                if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                    local dist = (enemy.HumanoidRootPart.Position - HRP.Position).Magnitude
                    if dist < minDist then
                        minDist = dist
                        target = enemy
                    end
                end
            end
            if target then
                HRP.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0,0,3)
                VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                task.wait(0.1)
                VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
            else
                -- Nếu không có quái, dịch về vị trí trung tâm vùng
                HRP.CFrame = zone.CFrame
            end
        end)
    end
end)

-- Auto Stats
RunService.Heartbeat:Connect(function()
    if Settings.AutoStats then
        pcall(function()
            CommF:InvokeServer("AddPoint", Settings.StatPriority, 1)
            task.wait(0.5)
        end)
    end
end)

-- ESP
RunService.Heartbeat:Connect(function()
    if Settings.ESP then
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj ~= Player.Character then
                if not obj:FindFirstChild("ESP_Highlight") then
                    local hl = Instance.new("Highlight")
                    hl.Name = "ESP_Highlight"
                    hl.Parent = obj
                    hl.FillTransparency = 0.5
                    hl.OutlineColor = Color3.fromRGB(255,0,0)
                end
            end
        end
    else
        for _, v in pairs(workspace:GetDescendants()) do
            if v.Name == "ESP_Highlight" then v:Destroy() end
        end
    end
end)

-- Auto Raid (cần level >= 1100, có thể dùng remote để mua raid)
RunService.Heartbeat:Connect(function()
    if Settings.AutoRaid then
        pcall(function()
            -- Tùy chỉnh theo remote thực tế (ví dụ: mua raid Flame)
            local args = {[1] = "Raids", [2] = "Buy"}
            CommF:InvokeServer(unpack(args))
            task.wait(30)
        end)
    end
end)

-- Auto Buy (ví dụ mua kiếm từ Shop)
RunService.Heartbeat:Connect(function()
    if Settings.AutoBuy then
        pcall(function()
            if Settings.BuyItem == "Sword" then
                CommF:InvokeServer("BuyItem", "Sword")
            elseif Settings.BuyItem == "Gun" then
                CommF:InvokeServer("BuyItem", "Gun")
            elseif Settings.BuyItem == "Blox Fruit" then
                CommF:InvokeServer("BuyFruit", "Flame-Fruit")
            end
            task.wait(2)
        end)
    end
end)

-- Chống AFK
Player.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), workspace.CurrentCamera.CFrame)
end)

-- Cập nhật nhân vật khi respawn
Player.CharacterAdded:Connect(function(char)
    Character = char
    HRP = char:WaitForChild("HumanoidRootPart")
end)