local Rayfield = loadstring(game:HttpGet('https://sirius.menu'))()

local Window = Rayfield:CreateWindow({
   Name = "Delta Script: Fly & Noclip",
   LoadingTitle = "Загрузка функционала...",
   LoadingSubtitle = "by Assistant",
   ConfigurationSaving = {
      Enabled = true,
      FolderName = "DeltaFlyConfig",
      FileName = "MainConfig"
   }
})

local Tab = Window:CreateTab("Главная", 4483362458)

local Flying = false
local Noclipping = false
local Speed = 50
local Player = game.Players.LocalPlayer
local Character = Player.Character or Player.CharacterAdded:Wait()

-- Обновление персонажа при респавне
Player.CharacterAdded:Connect(function(char)
    Character = char
end)

-- Функция полета
local function ToggleFly(state)
    Flying = state
    local HumanoidRootPart = Character:WaitForChild("HumanoidRootPart")
    
    if Flying then
        local BodyVelocity = Instance.new("BodyVelocity")
        BodyVelocity.Name = "FlyVelocity"
        BodyVelocity.Velocity = Vector3.new(0, 0, 0)
        BodyVelocity.MaxForce = Vector3.new(math.huge, math.huge, math.huge)
        BodyVelocity.Parent = HumanoidRootPart
        
        local BodyGyro = Instance.new("BodyGyro")
        BodyGyro.Name = "FlyGyro"
        BodyGyro.P = 9e4
        BodyGyro.MaxTorque = Vector3.new(math.huge, math.huge, math.huge)
        BodyGyro.CFrame = HumanoidRootPart.CFrame
        BodyGyro.Parent = HumanoidRootPart
        
        task.spawn(function()
            while Flying do
                local Camera = workspace.CurrentCamera
                -- Управление направлением полета через камеру
                BodyVelocity.Velocity = Camera.CFrame.LookVector * Speed
                BodyGyro.CFrame = Camera.CFrame
                task.wait()
            end
            -- Очистка при выключении
            if HumanoidRootPart:FindFirstChild("FlyVelocity") then HumanoidRootPart.FlyVelocity:Destroy() end
            if HumanoidRootPart:FindFirstChild("FlyGyro") then HumanoidRootPart.FlyGyro:Destroy() end
        end)
    end
end

-- Постоянная проверка Noclip (сквозь стены)
game:GetService("RunService").Stepped:Connect(function()
    if Noclipping then
        for _, part in pairs(Character:GetDescendants()) do
            if part:IsA("BasePart") then
                part.CanCollide = false
            end
        end
    end
end)

-- Создание элементов управления в меню
Tab:CreateToggle({
   Name = "Fly + Noclip (Полет сквозь стены)",
   CurrentValue = false,
   Callback = function(Value) 
       Noclipping = Value -- Включает проход сквозь стены
       ToggleFly(Value)   -- Включает сам полет
   end,
})

Tab:CreateSlider({
   Name = "Скорость полета",
   Range = {10, 500},
   Increment = 10,
   Suffix = "Speed",
   CurrentValue = 50,
   Callback = function(Value) 
       Speed = Value 
   end,
})

Tab:CreateButton({
   Name = "Reset Character (Ресет)",
   Callback = function()
       Character:BreakJoints()
   end,
})

Rayfield:Notify({
   Title = "Готово!",
   Content = "Скрипт успешно загружен",
   Duration = 5,
   Image = 4483362458,
})
