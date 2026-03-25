if not game:IsLoaded() then
    game.Loaded:Wait()
end

-- SERVICES
local Players = game:GetService("Players")
local MarketplaceService = game:GetService("MarketplaceService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local TeleportService = game:GetService("TeleportService")
local UIS = game:GetService("UserInputService")

local player = Players.LocalPlayer

-- CONFIG
local Config = _G.AutoRebirthConfig or {}

Config.AutoStart = Config.AutoStart ~= false
Config.QueueOnTeleport = Config.QueueOnTeleport ~= false
Config.CountRebirths = Config.CountRebirths ~= false
Config.TeleportDelay = Config.TeleportDelay or 1

-- GLOBAL STATS
_G.Rebirths = _G.Rebirths or 0
_G.StartTime = _G.StartTime or os.time()
_G.AutoRebirth = _G.AutoRebirth or false

-- DEV PRODUCTS
local GOLD_PRODUCT = 3552791996
local TIME_PRODUCT = 3552860266

-- QUEUE SCRIPT
local function queueScript()

    if not Config.QueueOnTeleport then return end

    local queue = queue_on_teleport or queueonteleport

    if queue then

        queue([[
            _G.Rebirths = (_G.Rebirths or 0) + 1
            loadstring(game:HttpGet("https://raw.githubusercontent.com/charlessir/RAF2AutoRebirth/refs/heads/main/source.lua"))()
        ]])

    end

end

-- CHARACTER
local function getChar()

    local char = player.Character or player.CharacterAdded:Wait()
    local hrp = char:WaitForChild("HumanoidRootPart")
    local hum = char:WaitForChild("Humanoid")

    return char, hrp, hum

end

-- COLOR FILTER
local function isTargetColor(c)

    local r = math.floor(c.R * 255)
    local g = math.floor(c.G * 255)
    local b = math.floor(c.B * 255)

    return (r == 0 and g == 255 and b == 0)
        or (r == 255 and g == 170 and b == 0)

end

-- MAIN FARM
local function runRebirth()

while _G.AutoRebirth do

-- BUY GOLD
for i=1,5 do
MarketplaceService:SignalPromptProductPurchaseFinished(player.UserId,GOLD_PRODUCT,true)
task.wait(.1)
end

-- BUY TIME CUBE
for i=1,5 do
MarketplaceService:SignalPromptProductPurchaseFinished(player.UserId,TIME_PRODUCT,true)
task.wait(.1)
end

pcall(function()
ReplicatedStorage.Functions["Rebirth Check"]:InvokeServer()
end)

task.wait(.5)

pcall(function()
ReplicatedStorage.Events.Unlock:FireServer("Time Cube","the_interwebs")
end)

local char,hrp,hum=getChar()

local cube

repeat
cube = player.Backpack:FindFirstChild("Time Cube") or char:FindFirstChild("Time Cube")
task.wait(.1)
until cube

hum:EquipTool(cube)

hrp.CFrame = workspace.Floppa.HumanoidRootPart.CFrame
task.wait(.4)

fireproximityprompt(workspace.Floppa.HumanoidRootPart.ProximityPrompt)

-- WAIT FOR ZONE
local zone

repeat
if workspace:FindFirstChild("Void") then
zone = workspace.Void:FindFirstChild("JudgementZone")
end
task.wait(.2)
until zone

-- TELEPORT LOOP
task.spawn(function()

while zone and zone.Parent and _G.AutoRebirth do

local _,hrp=getChar()
hrp.CFrame=zone.CFrame

task.wait(.1)

end

end)

-- BUTTON SPAM
task.spawn(function()

while _G.AutoRebirth do

local dialog = player.PlayerGui:FindFirstChild("DialogUI")

if dialog then

local options = dialog:FindFirstChild("Options")

if options then

for _,btn in ipairs(options:GetChildren()) do

if btn:IsA("TextButton") and isTargetColor(btn.BackgroundColor3) then

pcall(function()
firesignal(btn.MouseButton1Click)
end)

pcall(function()
btn:Activate()
end)

end

end

end

end

task.wait()

end

end)

task.wait(3)

end

end

-- UI
local gui = Instance.new("ScreenGui")
gui.ResetOnSpawn = false
gui.Parent = player.PlayerGui

local frame = Instance.new("Frame")
frame.Size = UDim2.new(0,240,0,140)
frame.Position = UDim2.new(.5,-120,.5,-70)
frame.BackgroundColor3 = Color3.fromRGB(25,25,25)
frame.Parent = gui
Instance.new("UICorner",frame)

local toggle = Instance.new("TextButton")
toggle.Size = UDim2.new(1,-20,0,40)
toggle.Position = UDim2.new(0,10,0,10)
toggle.Text = "Toggle Auto Rebirth"
toggle.Parent = frame

toggle.MouseButton1Click:Connect(function()

_G.AutoRebirth = not _G.AutoRebirth

if _G.AutoRebirth then
task.spawn(runRebirth)
end

end)

-- AUTO START
if Config.AutoStart then
_G.AutoRebirth = true
task.spawn(runRebirth)
end
