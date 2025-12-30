-- SERVICES
local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local LocalPlayer = Players.LocalPlayer
local PlayerGui = LocalPlayer:WaitForChild("PlayerGui")

-- ADMIN REMOTE
local ExecuteCommand = nil
task.spawn(function()
	while not ExecuteCommand do
		pcall(function()
			local pkg = ReplicatedStorage:WaitForChild("Packages",3)
			if not pkg then return end
			local net = pkg:WaitForChild("Net",3)
			if not net then return end
			local r = net:FindFirstChild("RE/AdminPanelService/ExecuteCommand", true)
			if r then ExecuteCommand = r end
		end)
		task.wait(1)
	end
end)

-- SETTINGS
local ENABLED = false
local COOLDOWN = 4
local lastTrigger = 0
local DETECT_PHRASES = {
	"someone is stealing your",
	"someone is stealing"
}
local COMMANDS = {"rocket","balloon","tiny"}
local ESP_ENABLED = false
local ESP_HIGHLIGHTS = {}

-- UI
local gui = Instance.new("ScreenGui", PlayerGui)
gui.ResetOnSpawn = false

local frame = Instance.new("Frame", gui)
frame.Size = UDim2.new(0,380,0,520)
frame.Position = UDim2.new(0.5,-190,0.5,-260)
frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
frame.Active = true
frame.Draggable = true
Instance.new("UICorner", frame).CornerRadius = UDim.new(0,20)

-- Octo decoration
local function addOcto(pos)
	local img = Instance.new("ImageLabel", frame)
	img.Size = UDim2.new(0,60,0,60)
	img.Position = pos
	img.BackgroundTransparency = 1
	img.Image = "rbxassetid://1371068260"
	img.ImageTransparency = 0.3
end
addOcto(UDim2.new(0,-20,0,-20))
addOcto(UDim2.new(1,-50,0,-20))
addOcto(UDim2.new(0,-20,1,-50))
addOcto(UDim2.new(1,-50,1,-50))

-- Title
local title = Instance.new("TextLabel", frame)
title.Size = UDim2.new(1,0,0,34)
title.BackgroundTransparency = 1
title.Text = "Octo Base Protector"
title.Font = Enum.Font.GothamBlack
title.TextSize = 22
title.TextColor3 = Color3.new(1,1,1)

-- Subtitle
local sub = Instance.new("TextLabel", frame)
sub.Position = UDim2.new(0,0,0,30)
sub.Size = UDim2.new(1,0,0,18)
sub.BackgroundTransparency = 1
sub.Text = ".gg/xtXPAbZ4sG"
sub.Font = Enum.Font.GothamBold
sub.TextSize = 14
sub.TextColor3 = Color3.fromRGB(170,170,170)

-- Toggle Protector
local toggle = Instance.new("TextButton", frame)
toggle.Position = UDim2.new(0,18,0,70)
toggle.Size = UDim2.new(1,-36,0,48)
toggle.Text = "PROTECTOR: OFF"
toggle.Font = Enum.Font.GothamBold
toggle.TextSize = 18
toggle.TextColor3 = Color3.new(1,1,1)
toggle.BackgroundColor3 = Color3.fromRGB(15,15,15)
toggle.AutoButtonColor = false
Instance.new("UICorner", toggle).CornerRadius = UDim.new(0,14)
toggle.MouseButton1Click:Connect(function()
	ENABLED = not ENABLED
	toggle.Text = ENABLED and "PROTECTOR: ON" or "PROTECTOR: OFF"
end)

-- ESP Toggle
local espBtn = Instance.new("TextButton", frame)
espBtn.Position = UDim2.new(0,18,0,130)
espBtn.Size = UDim2.new(1,-36,0,48)
espBtn.Text = "ESP: OFF"
espBtn.Font = Enum.Font.GothamBold
espBtn.TextSize = 18
espBtn.TextColor3 = Color3.new(1,1,1)
espBtn.BackgroundColor3 = Color3.fromRGB(15,15,15)
espBtn.AutoButtonColor = false
Instance.new("UICorner", espBtn).CornerRadius = UDim.new(0,14)

-- Desync Button
local desBtn = Instance.new("TextButton", frame)
desBtn.Position = UDim2.new(0,18,0,185)
desBtn.Size = UDim2.new(1,-36,0,48)
desBtn.Text = "DESYNC: ON"
desBtn.Font = Enum.Font.GothamBold
desBtn.TextSize = 18
desBtn.TextColor3 = Color3.new(1,1,1)
desBtn.BackgroundColor3 = Color3.fromRGB(15,15,15)
desBtn.AutoButtonColor = false
Instance.new("UICorner", desBtn).CornerRadius = UDim.new(0,14)

-- Logs container
local logFrame = Instance.new("Frame", frame)
logFrame.Position = UDim2.new(0,10,0,240)
logFrame.Size = UDim2.new(1,-20,0,260)
logFrame.BackgroundTransparency = 0.1
logFrame.BackgroundColor3 = Color3.fromRGB(20,20,20)

local function addLog(text)
	local lbl = Instance.new("TextLabel", logFrame)
	lbl.Size = UDim2.new(1,0,0,20)
	lbl.BackgroundTransparency = 1
	lbl.TextColor3 = Color3.fromRGB(0,255,0)
	lbl.Font = Enum.Font.Gotham
	lbl.TextSize = 14
	lbl.Text = text
end

-- Footer
local footer = Instance.new("TextLabel", frame)
footer.Position = UDim2.new(0,0,1,-24)
footer.Size = UDim2.new(1,0,0,20)
footer.BackgroundTransparency = 1
footer.Text = "(Requires Admin Panel)"
footer.Font = Enum.Font.Gotham
footer.TextSize = 12
footer.TextColor3 = Color3.fromRGB(120,120,120)

-- Sound alert
local sound = Instance.new("Sound", frame)
sound.SoundId = "rbxassetid://9118822037"
sound.Volume = 0.5

-- FUNCTIONS
local function punishAll(triggeringPlayer)
	if not ExecuteCommand then return end
	for _,plr in ipairs(Players:GetPlayers()) do
		if plr ~= LocalPlayer then
			for _,cmd in ipairs(COMMANDS) do
				pcall(function()
					ExecuteCommand:FireServer(plr, cmd)
				end)
			end
		end
	end
	addLog("Triggered by: "..triggeringPlayer.Name.." | Commands Fired")
	sound:Play()
	local tween = TweenService:Create(frame, TweenInfo.new(0.3), {BackgroundColor3 = Color3.fromRGB(30,0,0)})
	tween:Play()
	tween.Completed:Connect(function()
		frame.BackgroundColor3 = Color3.fromRGB(0,0,0)
	end)
end

-- DETECTION LOOP
RunService.Heartbeat:Connect(function()
	if ENABLED and tick()-lastTrigger >= COOLDOWN then
		for _,obj in ipairs(PlayerGui:GetDescendants()) do
			if (obj:IsA("TextLabel") or obj:IsA("TextButton")) and obj.Text ~= "" then
				local txt = obj.Text:lower()
				for _,phrase in ipairs(DETECT_PHRASES) do
					if txt:find(phrase) then
						lastTrigger = tick()
						local triggeringPlayer = nil
						for _,plr in ipairs(Players:GetPlayers()) do
							if plr ~= LocalPlayer then
								triggeringPlayer = plr
								break
							end
						end
						if triggeringPlayer then punishAll(triggeringPlayer) end
						break
					end
				end
			end
		end
	end
end)

-- ESP Functions
local function ClearESP(char)
	for _,v in ipairs(char:GetChildren()) do
		if v.Name == "RUBEN_ESP" then v:Destroy() end
	end
end

local function CreateHighlight(char)
	local h = Instance.new("BoxHandleAdornment")
	h.Name = "RUBEN_ESP"
	h.Adornee = char:FindFirstChild("HumanoidRootPart")
	if not h.Adornee then return end
	h.AlwaysOnTop = true
	h.ZIndex = 10
	h.Size = Vector3.new(4,6,2)
	h.Color3 = Color3.fromRGB(0,255,0)
	h.Transparency = 0.5
	h.Parent = char
end

local function CreateName(char,player)
	local head = char:FindFirstChild("Head")
	if not head then return end
	local b = Instance.new("BillboardGui", char)
	b.Name = "RUBEN_ESP"
	b.Size = UDim2.new(0,200,0,50)
	b.AlwaysOnTop = true
	b.Adornee = head
	local t = Instance.new("TextLabel", b)
	t.Size = UDim2.new(1,0,1,0)
	t.BackgroundTransparency = 1
	t.Text = player.Name
	t.TextColor3 = Color3.fromRGB(255,0,0)
	t.Font = Enum.Font.GothamBold
	t.TextSize = 28
end

local function ApplyESP(pl)
	if pl == LocalPlayer then return end
	local function setup(char)
		char:WaitForChild("HumanoidRootPart",5)
		if not ESP_ENABLED then return end
		ClearESP(char)
		CreateHighlight(char)
		CreateName(char, pl)
	end
	pl.CharacterAdded:Connect(setup)
	if pl.Character then setup(pl.Character) end
end

for _,pl in ipairs(Players:GetPlayers()) do
	ApplyESP(pl)
end
Players.PlayerAdded:Connect(ApplyESP)

espBtn.MouseButton1Click:Connect(function()
	ESP_ENABLED = not ESP_ENABLED
	espBtn.Text = ESP_ENABLED and "ESP: ON" or "ESP: OFF"
	for _,pl in ipairs(Players:GetPlayers()) do
		if pl.Character then
			if not ESP_ENABLED then
				ClearESP(pl.Character)
			else
				ApplyESP(pl)
			end
		end
	end
end)

-- DESYNC
local DESYNCFLAGS = {
	{"S2PhysicsSenderRate","15000"},
	{"GameNetPVHeaderRotationalVelocityZeroCutoffExponent","-5000"},
	{"GameNetPVHeaderLinearVelocityZeroCutoffExponent","-5000"},
	{"AngularVelociryLimit","360"},
	{"PhysicsSenderMaxBandwidthBps","20000"},
	{"MaxDataPacketPerSend","2147483647"},
	{"ServerMaxBandwith","52"},
	{"SimExplicitlyCappedTimestepMultiplier","2147483646"},
	{"TimestepArbiterVelocityCriteriaThresholdTwoDt","2147483646"},
	{"MaxTimestepMultiplierBuoyancy","2147483647"},
	{"MaxTimestepMultiplierAcceleration","2147483647"},
	{"MaxTimestepMultiplierContstraint","2147483647"},
	{"LargeReplicatorWrite5","true"},
	{"LargeReplicatorRead5","true"},
	{"LargeReplicatorEnabled9","true"},
	{"NextGenReplicatorEnabledWrite4","true"}
}

for _,flag in ipairs(DESYNCFLAGS) do
	pcall(function() setfflag(flag[1],flag[2]) end)
end

print("Octo Base Protector + ESP + Desync Loaded | .gg/xtXPAbZ4sG")
