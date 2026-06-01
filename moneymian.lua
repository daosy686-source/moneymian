
-- ==================== KEY CONFIG ====================
local GIST_KEY_URL = "https://gist.githubusercontent.com/daosy686-source/866258df…0/raw/fc9cb1f08cdaf617a435796293e6612db57e26e4/gistfile1.txt
"  -- 👈 Thay link raw Gist
local FALLBACK_KEY = "FREEMIUM"

-- ==================== KEY SYSTEM ====================
local function fetchKeyFromGist()
    local success, result = pcall(function() return game:HttpGet(https://gist.githubusercontent.com/daosy686-source/866258df…0/raw/fc9cb1f08cdaf617a435796293e6612db57e26e4/gistfile1.txt
) end)
    if success and result then
        local firstLine = result:match("^[^\r\n]+")
        if firstLine then return firstLine:match("^%s*(.-)%s*$") end
    end
    return nil
end

local function isValidKey(input)
    local serverKey = fetchKeyFromGist() or FALLBACK_KEY
    return input == serverKey
end

local inputKey = getgenv().Key
local isAutoKey = (inputKey ~= nil and inputKey ~= "")

if not isAutoKey then
    local KeyGui = Instance.new("ScreenGui")
    KeyGui.Name = "KeySystem"
    KeyGui.Parent = game.CoreGui

    local KeyFrame = Instance.new("Frame")
    KeyFrame.Size = UDim2.new(0, 300, 0, 160)
    KeyFrame.Position = UDim2.new(0.5, -150, 0.4, 0)
    KeyFrame.BackgroundColor3 = Color3.fromRGB(20, 20, 20)
    KeyFrame.BorderSizePixel = 0
    KeyFrame.Active = true
    KeyFrame.Draggable = true
    KeyFrame.Parent = KeyGui

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Size = UDim2.new(1, 0, 0, 30)
    TitleLabel.BackgroundColor3 = Color3.fromRGB(255, 100, 0)
    TitleLabel.Text = "NHẬP KEY ĐỂ SỬ DỤNG"
    TitleLabel.TextColor3 = Color3.new(1,1,1)
    TitleLabel.Font = Enum.Font.SourceSansBold
    TitleLabel.TextSize = 16
    TitleLabel.Parent = KeyFrame

    local TextBox = Instance.new("TextBox")
    TextBox.Size = UDim2.new(1, -20, 0, 40)
    TextBox.Position = UDim2.new(0, 10, 0, 40)
    TextBox.BackgroundColor3 = Color3.fromRGB(40,40,40)
    TextBox.Text = ""
    TextBox.PlaceholderText = "Nhập key..."
    TextBox.TextColor3 = Color3.new(1,1,1)
    TextBox.Font = Enum.Font.SourceSans
    TextBox.TextSize = 18
    TextBox.Parent = KeyFrame

    local SubmitButton = Instance.new("TextButton")
    SubmitButton.Size = UDim2.new(0, 100, 0, 30)
    SubmitButton.Position = UDim2.new(0.5, -50, 0, 90)
    SubmitButton.BackgroundColor3 = Color3.fromRGB(0, 170, 0)
    SubmitButton.Text = "XÁC NHẬN"
    SubmitButton.TextColor3 = Color3.new(1,1,1)
    SubmitButton.Font = Enum.Font.SourceSansBold
    SubmitButton.TextSize = 16
    SubmitButton.Parent = KeyFrame

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Size = UDim2.new(1, -20, 0, 20)
    StatusLabel.Position = UDim2.new(0, 10, 0, 130)
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Text = ""
    StatusLabel.TextColor3 = Color3.new(1,0,0)
    StatusLabel.Font = Enum.Font.SourceSans
    StatusLabel.TextSize = 13
    StatusLabel.Parent = KeyFrame

    local function submitKey()
        local input = TextBox.Text
        if isValidKey(input) then
            getgenv().Key = input
            KeyGui:Destroy()
            loadMainGUI()
        else
            StatusLabel.Text = "Key không hợp lệ!"
            TextBox.Text = ""
        end
    end
    SubmitButton.MouseButton1Click:Connect(submitKey)
    TextBox.FocusLost:Connect(function(enterPressed)
        if enterPressed then submitKey() end
    end)
else
    if isValidKey(inputKey) then
        loadMainGUI()
    else
        game.Players.LocalPlayer:Kick("Key không hợp lệ! Kiểm tra getgenv().Key")
    end
end

-- ==================== BLOX FRUITS HUB ====================
function loadMainGUI()
    local Player = game.Players.LocalPlayer
    local ReplicatedStorage = game:GetService("ReplicatedStorage")
    local Remotes = ReplicatedStorage:WaitForChild("Remotes")
    local CommF = Remotes:WaitForChild("CommF_")
    local VIM = game:GetService("VirtualInputManager")
    local RunService = game:GetService("RunService")
    local VirtualUser = game:GetService("VirtualUser")
    local Workspace = game:GetService("Workspace")

    local Character = Player.Character or Player.CharacterAdded:Wait()
    local HRP = Character:WaitForChild("HumanoidRootPart")
    local Humanoid = Character:WaitForChild("Humanoid")

    _G.Settings = {
        AutoFarm = false,
        FarmZone = "Bandit",
        AutoStats = false,
        StatPriority = "Melee",
        ESP = false,
        AutoRaid = false,
        AutoAwaken = false,
        AutoBuy = false,
        BuyItem = "Sword",
        AutoChest = false,
        AutoSeaBeast = false,
        AutoNextSea = false,
        AutoV4 = false,
        FastAttack = true,
        AutoElite = false,
        AutoSaber = false,
        AutoKenV2 = false,
        AutoServerHop = false
    }

    local FarmZones = {
        ["Bandit"] = {CFrame = CFrame.new(1050, 16, 1550), EnemyFolder = "Enemies"},
        ["Monkey"] = {CFrame = CFrame.new(-1240, 12, 560), EnemyFolder = "Enemies"},
        ["Pirate"] = {CFrame = CFrame.new(-1120, 15, 4350), EnemyFolder = "Enemies"},
        ["Marine"] = {CFrame = CFrame.new(-5500, 100, -3000), EnemyFolder = "Marines"},
        ["Sky Bandit"] = {CFrame = CFrame.new(-4950, 720, -2650), EnemyFolder = "Enemies"},
        ["Prisoner"] = {CFrame = CFrame.new(4800, 30, 2200), EnemyFolder = "Enemies"},
        ["Gladiator"] = {CFrame = CFrame.new(-1600, 30, -3000), EnemyFolder = "Enemies"},
        ["Magma Ninja"] = {CFrame = CFrame.new(-5300, 40, 8400), EnemyFolder = "Enemies"},
        ["Fishman Warrior"] = {CFrame = CFrame.new(5500, 20, -800), EnemyFolder = "Enemies"},
    }

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

    local Bosses = {
        ["Bobby"] = CFrame.new(1050, 16, 1550),
        ["Saw Boss"] = CFrame.new(-1240, 12, 560),
        ["Vice Admiral"] = CFrame.new(-1120, 15, 4350),
    }

    -- ==================== GIAO DIỆN ====================
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "BF_FullHub"
    ScreenGui.Parent = game.CoreGui
    ScreenGui.ResetOnSpawn = false

    local MainFrame = Instance.new("Frame")
    MainFrame.Size = UDim2.new(0, 360, 0, 360)
    MainFrame.Position = UDim2.new(0.4, 0, 0.3, 0)
    MainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    MainFrame.BorderSizePixel = 0
    MainFrame.Active = true
    MainFrame.Draggable = true
    MainFrame.Parent = ScreenGui

    local TabBar = Instance.new("Frame")
    TabBar.Size = UDim2.new(1, 0, 0, 30)
    TabBar.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
    TabBar.BorderSizePixel = 0
    TabBar.Parent = MainFrame

    local ContentFrame = Instance.new("Frame")
    ContentFrame.Size = UDim2.new(1, 0, 1, -30)
    ContentFrame.Position = UDim2.new(0, 0, 0, 30)
    ContentFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    ContentFrame.BorderSizePixel = 0
    ContentFrame.Parent = MainFrame

    local Tabs = {}
    local function CreateTab(name)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 50, 0, 30)
        btn.Position = UDim2.new(0, #Tabs * 50, 0, 0)
        btn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
        btn.Text = name
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.SourceSansBold
        btn.TextSize = 11
        btn.Parent = TabBar

        local page = Instance.new("Frame")
        page.Size = UDim2.new(1, 0, 1, 0)
        page.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
        page.BorderSizePixel = 0
        page.Visible = false
        page.Parent = ContentFrame

        table.insert(Tabs, {Button = btn, Page = page})
        btn.MouseButton1Click:Connect(function()
            for _, t in ipairs(Tabs) do t.Page.Visible = false end
            page.Visible = true
        end)
        if #Tabs == 1 then page.Visible = true end
        return page
    end

    local function CreateToggle(parent, text, position, default, callback)
        local state = default
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 150, 0, 30)
        btn.Position = position
        btn.BackgroundColor3 = default and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
        btn.Text = text .. ": " .. (default and "ON" or "OFF")
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.SourceSans
        btn.TextSize = 13
        btn.Parent = parent
        btn.MouseButton1Click:Connect(function()
            state = not state
            btn.BackgroundColor3 = state and Color3.fromRGB(0, 170, 0) or Color3.fromRGB(170, 0, 0)
            btn.Text = text .. ": " .. (state and "ON" or "OFF")
            callback(state)
        end)
        return btn
    end

    local function CreateDropdown(parent, label, position, options, default, callback)
        local idx = table.find(options, default) or 1
        local display = Instance.new("TextLabel")
        display.Size = UDim2.new(0, 150, 0, 20)
        display.Position = position
        display.BackgroundTransparency = 1
        display.Text = label .. ": " .. options[idx]
        display.TextColor3 = Color3.new(1, 1, 1)
        display.Font = Enum.Font.SourceSans
        display.TextSize = 13
        display.Parent = parent

        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 150, 0, 20)
        btn.Position = position + UDim2.new(0, 0, 0, 22)
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        btn.Text = ">"
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.SourceSans
        btn.TextSize = 14
        btn.Parent = parent
        btn.MouseButton1Click:Connect(function()
            idx = idx % #options + 1
            display.Text = label .. ": " .. options[idx]
            callback(options[idx])
        end)
    end

    local function CreateButton(parent, text, position, callback)
        local btn = Instance.new("TextButton")
        btn.Size = UDim2.new(0, 150, 0, 30)
        btn.Position = position
        btn.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
        btn.Text = text
        btn.TextColor3 = Color3.new(1, 1, 1)
        btn.Font = Enum.Font.SourceSans
        btn.TextSize = 13
        btn.Parent = parent
        btn.MouseButton1Click:Connect(callback)
        return btn
    end

    -- ==================== TẤT CẢ TAB ====================
    local FarmTab = CreateTab("Farm")
    CreateToggle(FarmTab, "Auto Farm", UDim2.new(0, 10, 0, 10), false, function(v) _G.Settings.AutoFarm = v end)
    CreateDropdown(FarmTab, "Vùng", UDim2.new(0, 170, 0, 10), {"Bandit","Monkey","Pirate","Marine","Sky Bandit","Prisoner","Gladiator","Magma Ninja","Fishman Warrior"}, "Bandit", function(v) _G.Settings.FarmZone = v end)
    CreateToggle(FarmTab, "Auto Stats", UDim2.new(0, 10, 0, 60), false, function(v) _G.Settings.AutoStats = v end)
    CreateDropdown(FarmTab, "Chỉ số", UDim2.new(0, 170, 0, 60), {"Melee","Defense","Sword","Gun","Demon Fruit"}, "Melee", function(v) _G.Settings.StatPriority = v end)
    CreateToggle(FarmTab, "Tấn công nhanh", UDim2.new(0, 10, 0, 110), true, function(v) _G.Settings.FastAttack = v end)

    local TeleTab = CreateTab("Tele")
    CreateDropdown(TeleTab, "Đảo", UDim2.new(0, 10, 0, 10), {"Start","Jungle","Pirate Village","Desert","Snow","Marine Fortress","Skylands","Prison","Colosseum","Magma Village","Underwater City","Fountain City","Shank's Room","Mob Island"}, "Start", function(v)
        if Islands[v] and HRP then HRP.CFrame = Islands[v] end
    end)
    CreateDropdown(TeleTab, "Boss", UDim2.new(0, 10, 0, 60), {"Bobby","Saw Boss","Vice Admiral"}, "Bobby", function(v)
        if Bosses[v] and HRP then HRP.CFrame = Bosses[v] end
    end)
    CreateButton(TeleTab, "NPC Sea 2", UDim2.new(0, 10, 0, 120), function() HRP.CFrame = CFrame.new(-5500, 100, -3000) end)
    CreateButton(TeleTab, "NPC Sea 3", UDim2.new(0, 10, 0, 160), function() HRP.CFrame = CFrame.new(4800, 30, 2200) end)

    local ESPTab = CreateTab("ESP")
    CreateToggle(ESPTab, "ESP (Quái/Player)", UDim2.new(0, 10, 0, 10), false, function(v) _G.Settings.ESP = v end)

    local RaidTab = CreateTab("Raid")
    CreateToggle(RaidTab, "Auto Raid", UDim2.new(0, 10, 0, 10), false, function(v) _G.Settings.AutoRaid = v end)
    CreateToggle(RaidTab, "Auto Awaken", UDim2.new(0, 10, 0, 50), false, function(v) _G.Settings.AutoAwaken = v end)

    local BuyTab = CreateTab("Mua")
    CreateToggle(BuyTab, "Auto Buy", UDim2.new(0, 10, 0, 10), false, function(v) _G.Settings.AutoBuy = v end)
    CreateDropdown(BuyTab, "Mặt hàng", UDim2.new(0, 170, 0, 10), {"Sword","Gun","Blox Fruit"}, "Sword", function(v) _G.Settings.BuyItem = v end)

    local QuestTab = CreateTab("N.Vụ")
    CreateToggle(QuestTab, "Auto Elite Hunter", UDim2.new(0, 10, 0, 10), false, function(v) _G.Settings.AutoElite = v end)
    CreateToggle(QuestTab, "Auto Saber Quest", UDim2.new(0, 10, 0, 50), false, function(v) _G.Settings.AutoSaber = v end)
    CreateToggle(QuestTab, "Auto Ken V2", UDim2.new(0, 10, 0, 90), false, function(v) _G.Settings.AutoKenV2 = v end)
    CreateToggle(QuestTab, "Auto Server Hop", UDim2.new(0, 10, 0, 130), false, function(v) _G.Settings.AutoServerHop = v end)
    CreateButton(QuestTab, "Hop Server", UDim2.new(0, 10, 0, 170), function() hopServer() end)

    local MiscTab = CreateTab("Khác")
    CreateToggle(MiscTab, "Auto Chest", UDim2.new(0, 10, 0, 10), false, function(v) _G.Settings.AutoChest = v end)
    CreateToggle(MiscTab, "Auto Sea Beast", UDim2.new(0, 10, 0, 50), false, function(v) _G.Settings.AutoSeaBeast = v end)
    CreateToggle(MiscTab, "Tự động lên Sea", UDim2.new(0, 10, 0, 90), false, function(v) _G.Settings.AutoNextSea = v end)
    CreateButton(MiscTab, "Reset Character", UDim2.new(0, 10, 0, 140), function() if Character then Character:BreakJoints() end end)

    local V4Tab = CreateTab("V4")
    CreateToggle(V4Tab, "Auto Up V4", UDim2.new(0, 10, 0, 10), false, function(v) _G.Settings.AutoV4 = v end)
    local v4Info = Instance.new("TextLabel")
    v4Info.Size = UDim2.new(1, -20, 0, 80)
    v4Info.Position = UDim2.new(0, 10, 0, 50)
    v4Info.BackgroundTransparency = 1
    v4Info.Text = "Cần: Level 1500+, V3.\nTự động đến Đền Thời Gian."
    v4Info.TextColor3 = Color3.new(1, 1, 0.5)
    v4Info.Font = Enum.Font.SourceSans
    v4Info.TextSize = 13
    v4Info.TextWrapped = true
    v4Info.Parent = V4Tab

    -- Cập nhật nhân vật
    Player.CharacterAdded:Connect(function(char)
        Character = char
        HRP = char:WaitForChild("HumanoidRootPart")
        Humanoid = char:WaitForChild("Humanoid")
    end)

    -- Hàm trang bị vũ khí mạnh nhất
    local function equipBestWeapon()
        local best, maxDmg = nil, 0
        for _, tool in pairs(Character:GetChildren()) do
            if tool:IsA("Tool") and tool:FindFirstChild("BaseDamage") then
                local dmg = tool.BaseDamage.Value
                if dmg > maxDmg then maxDmg = dmg; best = tool end
            end
        end
        if best and Humanoid then Humanoid:EquipTool(best) end
    end

    -- Hàm tìm NPC theo tên
    local function findNPC(npcName)
        for _, obj in pairs(workspace:GetDescendants()) do
            if obj:IsA("Model") and obj.Name == npcName and obj:FindFirstChild("Humanoid") then
                return obj
            end
        end
        return nil
    end

    -- Hàm tương tác NPC
    local function interactNPC(npc)
        if npc then
            local prompt = npc:FindFirstChildWhichIsA("ProximityPrompt")
            if prompt then
                fireproximityprompt(prompt)
                return true
            end
        end
        return false
    end

    -- Hàm hop server
    function hopServer()
        local ts = game:GetService("TeleportService")
        pcall(function()
            ts:Teleport(game.PlaceId, nil, nil, nil, true)
        end)
    end

    -- ==================== LOGIC CHÍNH ====================

    -- Auto Farm
    RunService.Heartbeat:Connect(function()
        if _G.Settings.AutoFarm and Character and HRP then
            pcall(function()
                local zone = FarmZones[_G.Settings.FarmZone]
                if not zone then return end
                local enemies = Workspace:FindFirstChild(zone.EnemyFolder)
                if not enemies then HRP.CFrame = zone.CFrame return end
                local target, minDist = nil, math.huge
                for _, enemy in pairs(enemies:GetChildren()) do
                    if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                        local dist = (enemy.HumanoidRootPart.Position - HRP.Position).Magnitude
                        if dist < minDist then minDist = dist; target = enemy end
                    end
                end
                if target then
                    Humanoid.AutoRotate = false
                    HRP.CFrame = target.HumanoidRootPart.CFrame * CFrame.new(0, 0, 2.5)
                    HRP.CFrame = CFrame.lookAt(HRP.Position, target.HumanoidRootPart.Position)
                    equipBestWeapon()
                    if _G.Settings.FastAttack then
                        for _ = 1, 3 do
                            VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                            VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                            task.wait(0.03)
                        end
                    else
                        VIM:SendMouseButtonEvent(0, 0, 0, true, game, 0)
                        task.wait(0.1)
                        VIM:SendMouseButtonEvent(0, 0, 0, false, game, 0)
                    end
                else
                    HRP.CFrame = zone.CFrame
                end
            end)
        end
    end)

    -- Auto Stats
    RunService.Heartbeat:Connect(function()
        if _G.Settings.AutoStats then
            pcall(function() CommF:InvokeServer("AddPoint", _G.Settings.StatPriority, 1); task.wait(0.5) end)
        end
    end)

    -- ESP
    RunService.Heartbeat:Connect(function()
        if _G.Settings.ESP then
            for _, obj in pairs(Workspace:GetDescendants()) do
                if obj:IsA("Model") and obj:FindFirstChild("Humanoid") and obj ~= Character and not obj:FindFirstChild("ESP_Highlight") then
                    local hl = Instance.new("Highlight"); hl.Name = "ESP_Highlight"; hl.Parent = obj
                    hl.FillTransparency = 0.5; hl.OutlineColor = Color3.fromRGB(255,0,0)
                end
            end
        else
            for _, v in pairs(Workspace:GetDescendants()) do if v.Name == "ESP_Highlight" then v:Destroy() end end
        end
    end)

    -- Auto Raid
    RunService.Heartbeat:Connect(function()
        if _G.Settings.AutoRaid then pcall(function() CommF:InvokeServer("Raids", "Buy"); task.wait(30) end) end
    end)

    -- Auto Awaken
    RunService.Heartbeat:Connect(function()
        if _G.Settings.AutoAwaken then pcall(function() CommF:InvokeServer("AwakenFruit", "Flame"); task.wait(10) end) end
    end)

    -- Auto Buy
    RunService.Heartbeat:Connect(function()
        if _G.Settings.AutoBuy then
            pcall(function()
                local item = _G.Settings.BuyItem
                if item == "Sword" then CommF:InvokeServer("BuyItem", "Sword")
                elseif item == "Gun" then CommF:InvokeServer("BuyItem", "Gun")
                elseif item == "Blox Fruit" then CommF:InvokeServer("BuyFruit", "Flame-Fruit") end
                task.wait(2)
            end)
        end
    end)

    -- Auto Chest
    RunService.Heartbeat:Connect(function()
        if _G.Settings.AutoChest then
            pcall(function()
                for _, v in pairs(Workspace:GetDescendants()) do
                    if v.Name == "Chest" and v:IsA("Model") and v:FindFirstChild("TouchInterest") then
                        HRP.CFrame = v:GetPivot(); task.wait(0.5)
                        firetouchinterest(HRP, v, 0); firetouchinterest(HRP, v, 1)
                        break
                    end
                end
            end)
        end
    end)

    -- Auto Sea Beast
    RunService.Heartbeat:Connect(function()
        if _G.Settings.AutoSeaBeast then
            pcall(function()
                local sb = Workspace:FindFirstChild("SeaBeasts")
                if sb then for _, beast in pairs(sb:GetChildren()) do
                    if beast:IsA("Model") and beast:FindFirstChild("Humanoid") and beast.Humanoid.Health > 0 then
                        HRP.CFrame = beast.HumanoidRootPart.CFrame * CFrame.new(0,10,0)
                        VIM:SendMouseButtonEvent(0,0,0,true,game,0); task.wait(0.5)
                        VIM:SendMouseButtonEvent(0,0,0,false,game,0)
                        break
                    end
                end end
            end)
        end
    end)

    -- Auto Next Sea
    RunService.Heartbeat:Connect(function()
        if _G.Settings.AutoNextSea then
            pcall(function()
                local lvl = Player.Data and Player.Data.Level and Player.Data.Level.Value
                if lvl and lvl >= 150 and lvl < 300 then
                    HRP.CFrame = CFrame.new(-5500, 100, -3000); wait(2)
                    CommF:InvokeServer("SetSpawnPoint", "2")
                elseif lvl and lvl >= 300 then
                    HRP.CFrame = CFrame.new(4800, 30, 2200); wait(2)
                    CommF:InvokeServer("SetSpawnPoint", "3")
                end
            end)
        end
    end)

    -- Auto V4
    RunService.Heartbeat:Connect(function()
        if _G.Settings.AutoV4 then
            pcall(function()
                HRP.CFrame = CFrame.new(5200, 30, -7800); wait(1)
                CommF:InvokeServer("StartTrial", "V4"); wait(2)
                local enemies = Workspace:FindFirstChild("TempleEnemies") or Workspace:FindFirstChild("Enemies")
                if enemies then for _, enemy in pairs(enemies:GetChildren()) do
                    if enemy:IsA("Model") and enemy:FindFirstChild("Humanoid") and enemy.Humanoid.Health > 0 then
                        repeat
                            HRP.CFrame = enemy.HumanoidRootPart.CFrame * CFrame.new(0,0,3)
                            VIM:SendMouseButtonEvent(0,0,0,true,game,0); task.wait(0.05)
                            VIM:SendMouseButtonEvent(0,0,0,false,game,0); task.wait(0.1)
                        until not enemy:FindFirstChild("Humanoid") or enemy.Humanoid.Health <= 0
                    end
                end end
                CommF:InvokeServer("CompleteTrial", "V4")
            end)
        end
    end)

    -- ==================== TÍNH NĂNG MỚI ====================
    -- Auto Elite Hunter
    RunService.Heartbeat:Connect(function()
        if _G.Settings.AutoElite and Character and HRP then
            pcall(function()
                local oldFarm = _G.Settings.AutoFarm; _G.Settings.AutoFarm = false
                local eliteNPC = findNPC("Elite Hunter") or findNPC("Setn")
                if eliteNPC then
                    HRP.CFrame = eliteNPC.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
                    task.wait(0.5); interactNPC(eliteNPC); task.wait(1)
                    CommF:InvokeServer("EliteHunter", "Start"); task.wait(1)
                else
                    if _G.Settings.AutoServerHop then hopServer() end
                    return
                end
                local elite = nil
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("Model") and obj.Name:lower():find("elite") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then
                        elite = obj; break
                    end
                end
                if elite then
                    repeat
                        HRP.CFrame = elite.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                        VIM:SendMouseButtonEvent(0,0,0,true,game,0); task.wait(0.05)
                        VIM:SendMouseButtonEvent(0,0,0,false,game,0); task.wait(0.1)
                    until not elite:FindFirstChild("Humanoid") or elite.Humanoid.Health <= 0
                    if eliteNPC then
                        HRP.CFrame = eliteNPC.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5)
                        task.wait(0.5); CommF:InvokeServer("EliteHunter", "ClaimReward"); task.wait(2)
                    end
                else
                    if _G.Settings.AutoServerHop then hopServer() end
                end
                _G.Settings.AutoFarm = oldFarm
            end)
        end
    end)

    -- Auto Saber Quest
    RunService.Heartbeat:Connect(function()
        if _G.Settings.AutoSaber and Character and HRP then
            pcall(function()
                local oldFarm = _G.Settings.AutoFarm; _G.Settings.AutoFarm = false
                local saberNPC = findNPC("Saber Expert")
                if not saberNPC then HRP.CFrame = CFrame.new(-1240, 12, 560); task.wait(1)
                else HRP.CFrame = saberNPC.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5); task.wait(0.5); interactNPC(saberNPC) end
                CommF:InvokeServer("Saber", "Start"); task.wait(2)
                local locations = {CFrame.new(1050, 16, 1550), CFrame.new(-1120, 15, 4350), CFrame.new(1090, 16, 4350)}
                for _, pos in ipairs(locations) do HRP.CFrame = pos; task.wait(1) end
                local boss = findNPC("Saber Expert") or findNPC("Saber Boss")
                if boss and boss:FindFirstChild("Humanoid") and boss.Humanoid.Health > 0 then
                    repeat
                        HRP.CFrame = boss.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                        VIM:SendMouseButtonEvent(0,0,0,true,game,0); task.wait(0.05)
                        VIM:SendMouseButtonEvent(0,0,0,false,game,0); task.wait(0.1)
                    until not boss:FindFirstChild("Humanoid") or boss.Humanoid.Health <= 0
                end
                CommF:InvokeServer("Saber", "Complete")
                _G.Settings.AutoFarm = oldFarm
            end)
        end
    end)

    -- Auto Ken V2
    RunService.Heartbeat:Connect(function()
        if _G.Settings.AutoKenV2 and Character and HRP then
            pcall(function()
                local oldFarm = _G.Settings.AutoFarm; _G.Settings.AutoFarm = false
                local robert = findNPC("Robert")
                if not robert then HRP.CFrame = CFrame.new(-4950, 720, -2650); task.wait(1)
                else HRP.CFrame = robert.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5); task.wait(0.5); interactNPC(robert) end
                CommF:InvokeServer("KenHaki", "Start"); task.wait(2)
                HRP.CFrame = CFrame.new(5200, 30, -7800); task.wait(1)
                local boss = nil
                for _, obj in pairs(Workspace:GetDescendants()) do
                    if obj:IsA("Model") and obj.Name:lower():find("soul") and obj:FindFirstChild("Humanoid") and obj.Humanoid.Health > 0 then
                        boss = obj; break
                    end
                end
                if boss then
                    repeat
                        HRP.CFrame = boss.HumanoidRootPart.CFrame * CFrame.new(0, 0, 3)
                        VIM:SendMouseButtonEvent(0,0,0,true,game,0); task.wait(0.05)
                        VIM:SendMouseButtonEvent(0,0,0,false,game,0); task.wait(0.1)
                    until not boss:FindFirstChild("Humanoid") or boss.Humanoid.Health <= 0
                end
                if robert then
                    HRP.CFrame = robert.HumanoidRootPart.CFrame * CFrame.new(0, 0, 5); task.wait(0.5)
                    CommF:InvokeServer("KenHaki", "Complete")
                end
                _G.Settings.AutoFarm = oldFarm
            end)
        end
    end)

    -- Chống AFK
    Player.Idled:Connect(function()
        VirtualUser:Button2Down(Vector2.new(0,0), Workspace.CurrentCamera.CFrame); task.wait(1)
        VirtualUser:Button2Up(Vector2.new(0,0), Workspace.CurrentCamera.CFrame)
    end)

    if game.StarterGui then game.StarterGui:SetCore("SendNotification", {Title="BananaHub", Text="Tất cả tính năng đã sẵn sàng!"}) end
end
loadstring(game:HttpGet("https://raw.githubusercontent.com/daosy686-source/moneymian/refs/heads/main/moneymian.lua"))()
