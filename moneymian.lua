 Dịch vụ cần thiết
local Player = game.Players.LocalPlayer
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local CommF = Remotes:WaitForChild("CommF_")
local VIM = game:GetService("VirtualInputManager")
local RunService = game:GetService("RunService")
local VirtualUser = game:GetService("VirtualUser")
local TweenService = game:GetService("TweenService")
local Workspace = game:GetService("Workspace")
local Players = game:GetService("Players")
local TeleportService = game:GetService("TeleportService")

-- Biến môi trường
local LocalPlayer = Player
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()
local HRP = Character:WaitForChild("HumanoidRootPart")
local Humanoid = Character:WaitForChild("Humanoid")
local Camera = Workspace.CurrentCamera

-- Cấu hình global
_G.Settings = {
    AutoFarm = false,
    FarmZone = "Bandit",    -- Bandit, Monkey, Pirate, ...
    AutoStats = false,
    StatPriority = "Melee", -- Melee, Defense, Sword, Gun, Demon Fruit
    ESP = false,
    AutoRaid = false,
    AutoMastery = false,
    AutoAwaken = false,
    AutoBuy = false,
    BuyItem = "Sword",      -- Sword, Gun, Blox Fruit
    AutoChest = false,
    AutoSeaBeast = false,
    AutoNextSea = false     -- Tự động lên biển tiếp theo
}

-- Danh sách vùng farm (tuỳ chỉnh thêm)
local FarmZones = {
    ["Bandit"] = {CFrame = CFrame.new(1050, 16, 1550), Enemies = "Enemies"},
    ["Monkey"] = {CFrame = CFrame.new(-1240, 12, 560), Enemies = "Enemies"},
    ["Pirate"] = {CFrame = CFrame.new(-1120, 15, 4350), Enemies = "Enemies"},
    ["Marine"] = {CFrame = CFrame.new(-5500, 100, -3000), Enemies = "Marines"},
    ["Sky Bandit"] = {CFrame = CFrame.new(-4950, 720, -2650), Enemies = "Enemies"},
    ["Prisoner"] = {CFrame = CFrame.new(4800, 30, 2200), Enemies = "Enemies"},
    ["Gladiator"] = {CFrame = CFrame.new(-1600, 30, -3000), Enemies = "Enemies"},
    ["Magma Ninja"] = {CFrame = CFrame.new(-5300, 40, 8400), Enemies = "Enemies"},
    ["Fishman Warrior"] = {CFrame = CFrame.new(5500, 20, -800), Enemies = "Enemies"},
}

-- Danh sách đảo
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

-- Danh sách boss
local Bosses = {
    ["Bobby"] = CFrame.new(1050, 16, 1550),
    ["Saw Boss"] = CFrame.new(-1240, 12, 560),
    ["Vice Admiral"] = CFrame.new(-1120, 15, 4350),
    -- Thêm các boss khác
}

-- Tạo GUI
local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "BF_FullHub"
ScreenGui.Parent = game.CoreGui
ScreenGui.ResetOnSpawn = false

-- Hàm tiện ích tạo phần tử
local function CreateFrame(size, position, parent, bg)
    local f = Instance.new("Frame")
    f.Size = size
    f.Position = position
    f.BackgroundColor3 = bg or Color3.fromRGB(30,30,30)
    f.BorderSizePixel = 0
    f.Parent = parent
    return f
end

local function CreateButton(parent, text, position, callback)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 0, 25)
    btn.Position = position
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.Text = text
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 13
    btn.Parent = parent
    btn.MouseButton1Click:Connect(callback)
    return btn
end

local function CreateToggle(parent, text, position, default, callback)
    local state = default
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 0, 25)
    btn.Position = position
    btn.BackgroundColor3 = default and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)
    btn.Text = text .. ": " .. (default and "ON" or "OFF")
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 13
    btn.Parent = parent
    btn.MouseButton1Click:Connect(function()
        state = not state
        btn.BackgroundColor3 = state and Color3.fromRGB(0,170,0) or Color3.fromRGB(170,0,0)
        btn.Text = text .. ": " .. (state and "ON" or "OFF")
        callback(state)
    end)
    return btn
end

local function CreateDropdown(parent, text, position, options, default, callback)
    local idx = table.find(options, default) or 1
    local lbl = Instance.new("TextLabel")
    lbl.Size = UDim2.new(0, 100, 0, 20)
    lbl.Position = position + UDim2.new(0, 0, 0, 0)
    lbl.BackgroundTransparency = 1
    lbl.Text = text .. ": " .. options[idx]
    lbl.TextColor3 = Color3.new(1,1,1)
    lbl.Font = Enum.Font.SourceSans
    lbl.TextSize = 13
    lbl.Parent = parent

    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 100, 0, 20)
    btn.Position = position + UDim2.new(0, 0, 0, 20)
    btn.BackgroundColor3 = Color3.fromRGB(50,50,50)
    btn.Text = ">"
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 14
    btn.Parent = parent

    btn.MouseButton1Click:Connect(function()
        idx = idx % #options + 1
        lbl.Text = text .. ": " .. options[idx]
        callback(options[idx])
    end)
end

-- Tabs
local MainFrame = CreateFrame(UDim2.new(0, 350, 0, 300), UDim2.new(0.4, 0, 0.3, 0), ScreenGui)
MainFrame.Active = true
MainFrame.Draggable = true

local TabButtons = CreateFrame(UDim2.new(1, 0, 0, 25), UDim2.new(0,0,0,0), MainFrame, Color3.fromRGB(40,40,40))
local Tabs = {}

local function CreateTab(name)
    local btn = Instance.new("TextButton")
    btn.Size = UDim2.new(0, 70, 0, 25)
    btn.Position = UDim2.new(0, (#Tabs * 70), 0, 0)
    btn.BackgroundColor3 = Color3.fromRGB(60,60,60)
    btn.Text = name
    btn.TextColor3 = Color3.new(1,1,1)
    btn.Font = Enum.Font.SourceSans
    btn.TextSize = 12
    btn.Parent = TabButtons
    local tabContent = CreateFrame(UDim2.new(1, 0, 1, -25), UDim2.new(0,0,0,25), MainFrame, Color3.fromRGB(30,30,30))
    tabContent.Visible = false
    table.insert(Tabs, {Button = btn, Content = tabContent})
    btn.MouseButton1Click:Connect(function()
        for _, t in ipairs(Tabs) do
            t.Content.Visible = false
        end
        tabContent.Visible = true
    end)
    if #Tabs == 1 then
        tabContent.Visible = true
    end
    return tabContent
end

-- Tab: Farm
local FarmTab = CreateTab("Farm")
CreateToggle(FarmTab, "Auto Farm", UDim2.new(0,5,0,5), false, function(v) _G.Settings.AutoFarm = v end)
CreateDropdown(FarmTab, "Zone", UDim2.new(0,120,0,5), {"Bandit","Monkey","Pirate","Marine","Sky Bandit","Prisoner","Gladiator","Magma Ninja","Fishman Warrior"}, "Bandit", function(v) _G.Settings.FarmZone = v end)
CreateToggle(FarmTab, "Auto Stats", UDim2.new(0,5,0,60), false, function(v) _G.Settings.AutoStats = v end)
CreateDropdown(FarmTab, "Stat", UDim2.new(0,120,0,60), {"Melee","Defense","Sword","Gun","Demon Fruit"}, "Melee", function(v) _G.Settings.StatPriority = v end)

-- Tab: Teleport
local TeleTab = CreateTab("Teleport")
CreateDropdown(TeleTab, "Island", UDim2.new(0,5,0,5), {"Start","Jungle","Pirate Village","Desert","Snow","Marine Fortress","Skylands","Prison","Colosseum","Magma Village","Underwater City","Fountain City","Shank's Room","Mob Island"}, "Start", function(v)
    if Islands[v] and HRP then
        HRP.CFrame = Islands[v]
    end
end)
CreateDropdown(TeleTab, "Boss", UDim2.new(0,5,0,60), {"Bobby","Saw Boss","Vice Admiral"}, "Bobby", function(v)
    if Bosses[v] and HRP then
        HRP.CFrame = Bosses[v]
    end
end)
CreateButton(TeleTab, "Sea 2 (Marine)", UDim2.new(0,5,0,105), function()
    -- Tự động đến NPC để bắt đầu quest Sea 2
    HRP.CFrame = CFrame.new(-5500, 100, -3000) -- Marine Fortress
    wait(1)
    CommF:InvokeServer("SetSpawnPoint", "2") -- Remote thường dùng để đổi spawn point
end)
CreateButton(TeleTab, "Sea 3 (Prison)", UDim2.new(0,120,0,105), function()
    HRP.CFrame = CFrame.new(4800, 30, 2200)
    wait(1)
    CommF:InvokeServer("SetSpawnPoint", "3")
end)

-- Tab: ESP
local ESPTab = CreateTab("ESP")
CreateToggle(ESPTab, "ESP Quái/Player", UDim2.new(0,5,0,5), false, function(v) _G.Settings.ESP = v end)

-- Tab: Raid & Mastery
local AdvTab = CreateTab("Raid/Thức Tỉnh")
CreateToggle(AdvTab, "Auto Raid", UDim2.new(0,5,0,5), false, function(v) _G.Settings.AutoRaid = v end)
CreateToggle(AdvTab, "Auto Mastery", UDim2.new(0,5,0,40), false, function(v) _G.Settings.AutoMastery = v end)
CreateToggle(AdvTab, "Auto Awaken", UDim2.new(0,5,0,75), false, function(v) _G.Settings.AutoAwaken = v end)

-- Tab: Mua vật phẩm
local BuyTab = CreateTab("Mua Hàng")
CreateToggle(BuyTab, "Auto Buy", UDim2.new(0,5,0,5), false, function(v) _G.Settings.AutoBuy = v end)
CreateDropdown(BuyTab, "Item", UDim2.new(0,120,0,5), {"Sword","Gun","Blox Fruit"}, "Sword", function(v) _G.Settings.BuyItem = v end)

-- Tab: Khác
local MiscTab = CreateTab("Khác")
CreateToggle(MiscTab, "Auto Chest Farm", UDim2.new(0,5,0,5), false, function(v) _G.Settings.AutoChest = v end)
CreateToggle(MiscTab, "Auto Sea Beast", UDim2.new(0,5,0,40), false, function(v) _G.Settings.AutoSeaBeast = v end)
CreateToggle(MiscTab, "Tự động lên Sea", UDim2.new(0,5,0,75), false, function(v) _G.Settings.AutoNextSea = v end)
CreateButton(MiscTab, "Reset Character", UDim2.new(0,5,0,115), function()
    if Character then Character:BreakJoints() end
end)

-- ==================== LOGIC CHÍNH ====================
-- Cập nhật nhân vật
LocalPlayer.CharacterAdded:Connect(function(char)
    Character = char
    HRP = char:WaitForChild("HumanoidRootPart")
    Humanoid = char:WaitForChild("Humanoid")
end)

-- Auto Farm
RunService.Heartbeat:Connect(function()
    if _G.Settings.AutoFarm and Character and HRP then
        pcall(function()
            local zone = FarmZones[_G.Settings.FarmZone]
            if not zone then return end
            local enemies = Workspace:FindFirstChild(zone.Enemies)
            if not enemies then
                HRP.CFrame = zone.CFrame
                return
            end
            local target = nil
            local minDist = math.huge
            for _, enemy in pairs(enemies:GetChildren()) do
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
                HRP.CFrame = zone.CFrame
            end
        end)
    end
end)

-- Auto Stats
RunService.Heartbeat:Connect(function()
    if _G.Settings.AutoStats then
        pcall(function()
            CommF:InvokeServer("AddPoint", _G.Settings.StatPriority, 1)
            task.wait(0.5)
        end)
    end
end)

-- ESP
RunService.Heartbeat:Connect(function()
    if _G.Settings.ESP then
        for _, obj in pairs(Workspace:GetDescendants()) do
            if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj ~= Character then
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
        for _, v in pairs(Workspace:GetDescendants()) do
            if v.Name == "ESP_Highlight" then v:Destroy() end
        end
    end
end)

-- Auto Raid (mua raid Flame và tự động vào)
RunService.Heartbeat:Connect(function()
    if _G.Settings.AutoRaid then
        pcall(function()
            CommF:InvokeServer("Raids", "Buy") -- Remote mua raid (có thể cần chỉnh sửa)
            task.wait(30)
        end)
    end
end)

-- Auto Mastery (đánh quái liên tục để tăng mastery)
-- Sử dụng chung vòng lặp farm, nhưng bổ sung thêm logic chọn vũ khí phù hợp
-- Ở đây chỉ đơn giản là giữ Auto Farm bật

-- Auto Awaken: Yêu cầu trong raid, sử dụng remote "AwakenFruit"
RunService.Heartbeat:Connect(function()
    if _G.Settings.AutoAwaken then
        pcall(function()
            CommF:InvokeServer("AwakenFruit", "Flame") -- Ví dụ
            task.wait(10)
        end)
    end
end)

-- Auto Buy
RunService.Heartbeat:Connect(function()
    if _G.Settings.AutoBuy then
        pcall(function()
            local item = _G.Settings.BuyItem
            if item == "Sword" then
                CommF:InvokeServer("BuyItem", "Sword")
            elseif item == "Gun" then
                CommF:InvokeServer("BuyItem", "Gun")
            elseif item == "Blox Fruit" then
                CommF:InvokeServer("BuyFruit", "Flame-Fruit")
            end
            task.wait(2)
        end)
    end
end)

-- Auto Chest Farm (quét toàn bộ rương gần nhất và mở)
RunService.Heartbeat:Connect(function()
    if _G.Settings.AutoChest then
        pcall(function()
            for _, v in pairs(Workspace:GetDescendants()) do
                if v.Name == "Chest" and v:IsA("Model") and v:FindFirstChild("TouchInterest") then
                    HRP.CFrame = v:GetPivot()
                    task.wait(0.5)
                    firetouchinterest(HRP, v, 0) -- touch để mở rương
                    firetouchinterest(HRP, v, 1)
                    break
                end
            end
        end)
    end
end)

-- Auto Sea Beast (săn Sea Beast khi ở Sea)
RunService.Heartbeat:Connect(function()
    if _G.Settings.AutoSeaBeast then
        pcall(function()
            local seaBeasts = Workspace:FindFirstChild("SeaBeasts")
            if seaBeasts then
                for _, beast in pairs(seaBeasts:GetChildren()) do
                    if beast:IsA("Model") and beast:FindFirstChild("Humanoid") and beast.Humanoid.Health > 0 then
                        HRP.CFrame = beast.HumanoidRootPart.CFrame * CFrame.new(0,10,0)
                        VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                        task.wait(0.5)
                        VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                        break
                    end
                end
            end
        end)
    end
end)

-- Tự động lên Sea tiếp theo
RunService.Heartbeat:Connect(function()
    if _G.Settings.AutoNextSea then
        pcall(function()
            local level = LocalPlayer.Data and LocalPlayer.Data.Level and LocalPlayer.Data.Level.Value
            if not level then return end
            if level >= 150 and level < 300 then
                -- Lên Sea 2: Teleport đến Marine Fortress, hoàn thành quest
                HRP.CFrame = CFrame.new(-5500, 100, -3000)
                wait(2)
                CommF:InvokeServer("SetSpawnPoint", "2")
                wait(1)
                CommF:InvokeServer("CompleteQuest", "MarineQuest") -- Remote giả định
            elseif level >= 300 then
                -- Lên Sea 3: Teleport đến Prison
                HRP.CFrame = CFrame.new(4800, 30, 2200)
                wait(2)
                CommF:InvokeServer("SetSpawnPoint", "3")
            end
        end)
    end
end)

-- Chống AFK
LocalPlayer.Idled:Connect(function()
    VirtualUser:Button2Down(Vector2.new(0,0), Camera.CFrame)
    task.wait(1)
    VirtualUser:Button2Up(Vector2.new(0,0), Camera.CFrame)
end)

-- Thông báo hoàn tất
if game.StarterGui then
    game.StarterGui:SetCore("SendNotification", {
        Title = "Blox Fruits Hub",
        Text = "Script đã tải! Sử dụng tab để bật chức năng."
    })
end
