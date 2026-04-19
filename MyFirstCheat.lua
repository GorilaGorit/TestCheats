local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MainGui"
screenGui.Parent = game:GetService("CoreGui")

for _, child in pairs(screenGui:GetChildren()) do
	if child.Name == "MainFrame" then
		child:Destroy()
	end
end

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 561, 0, 292)
mainFrame.Position = UDim2.new(0.5, -280, 0.5, -146)
mainFrame.BackgroundColor3 = Color3.fromHex("#000000")
mainFrame.BackgroundTransparency = 0.1
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui
mainFrame.Visible = true

local mainCorner = Instance.new("UICorner")
mainCorner.CornerRadius = UDim.new(0.10, 0)
mainCorner.Parent = mainFrame

local uiDragDetector = Instance.new("UIDragDetector")
uiDragDetector.Parent = mainFrame

local titleLabel = Instance.new("TextLabel")
titleLabel.Name = "Title"
titleLabel.Size = UDim2.new(1, 0, 0, 30)
titleLabel.Position = UDim2.new(0, 0, 0, 10)
titleLabel.BackgroundTransparency = 1
titleLabel.Text = "MyFirstCheat"
titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
titleLabel.TextSize = 20
titleLabel.Font = Enum.Font.Montserrat
titleLabel.Parent = mainFrame

local function playSound(soundType)
	local sound = Instance.new("Sound")
	sound.Volume = 0.5

	if soundType == "success" then
		sound.SoundId = "rbxassetid://139009780109934"
		sound.PlayOnRemove = true
	elseif soundType == "error" then
		sound.SoundId = "rbxassetid://140650754692075"
		sound.Volume = 0.2
		sound.PlayOnRemove = true
	elseif soundType == "click" then
		sound.SoundId = "rbxassetid://139719503904449"
		sound.Volume = 1.2
		sound.PlayOnRemove = true
	elseif soundType == "highlight" then
		sound.SoundId = "rbxassetid://138498992667102"
		sound.Volume = 0.6
		sound.PlayOnRemove = true
	elseif soundType == "disable" then
		sound.SoundId = "rbxassetid://129733619657122"
		sound.Volume = 1.5
		sound.PlayOnRemove = true
	end

	sound.Parent = game.Workspace
	sound:Play()

	game:GetService("Debris"):AddItem(sound, sound.TimeLength + 0.5)
end

local function showNotification(text, textColor, soundType, duration)
	duration = duration or 3

	local notification = Instance.new("Frame")
	notification.Size = UDim2.new(0, 300, 0, 50)
	notification.Position = UDim2.new(0.5, -150, 0.8, 0)
	notification.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
	notification.BackgroundTransparency = 0.2
	notification.BorderSizePixel = 0
	notification.Parent = screenGui

	notification.BackgroundTransparency = 1
	notification.Position = UDim2.new(0.5, -150, 0.85, 0)

	local corner = Instance.new("UICorner")
	corner.CornerRadius = UDim.new(0, 12)
	corner.Parent = notification

	local textLabel = Instance.new("TextLabel")
	textLabel.Size = UDim2.new(1, 0, 1, 0)
	textLabel.BackgroundTransparency = 1
	textLabel.Text = text
	textLabel.TextColor3 = textColor
	textLabel.TextSize = 16
	textLabel.Font = Enum.Font.GothamBold
	textLabel.TextWrapped = true
	textLabel.Parent = notification

	local icon = Instance.new("TextLabel")
	icon.Size = UDim2.new(0, 30, 1, 0)
	icon.Position = UDim2.new(0, 10, 0, 0)
	icon.BackgroundTransparency = 1
	icon.TextSize = 20
	icon.TextColor3 = textColor

	if soundType == "success" then
		icon.Text = "✓"
	elseif soundType == "error" then
		icon.Text = "⚠"
	elseif soundType == "highlight" then
		icon.Text = "✨"
	elseif soundType == "disable" then
		icon.Text = "❌"
	else
		icon.Text = "🔔"
	end

	icon.Parent = notification
	textLabel.Position = UDim2.new(0, 50, 0, 0)
	textLabel.Size = UDim2.new(1, -60, 1, 0)

	if soundType then
		playSound(soundType)
	end

	local tweenService = game:GetService("TweenService")
	local appearTween = tweenService:Create(notification, 
		TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out),
		{BackgroundTransparency = 0.2, Position = UDim2.new(0.5, -150, 0.8, 0)}
	)
	appearTween:Play()

	game:GetService("Debris"):AddItem(notification, duration)

	task.wait(duration - 0.3)
	local disappearTween = tweenService:Create(notification, 
		TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
		{BackgroundTransparency = 1, Position = UDim2.new(0.5, -150, 0.85, 0)}
	)
	disappearTween:Play()
end

local menuVisible = true

game:GetService("UserInputService").InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	
	if input.KeyCode == Enum.KeyCode.K then
		menuVisible = not menuVisible
		mainFrame.Visible = menuVisible
	end
end)

local originalWalkSpeed = 16
local speedMultiplier = 1
local speedConnection = nil

local function updatePlayerSpeed()
	local player = game.Players.LocalPlayer
	local character = player.Character
	if character then
		local humanoid = character:FindFirstChild("Humanoid")
		if humanoid then
			humanoid.WalkSpeed = originalWalkSpeed * speedMultiplier
		end
	end
end

local function setupSpeedConnection()
	if speedConnection then
		speedConnection:Disconnect()
	end
	
	local player = game.Players.LocalPlayer
	speedConnection = player.CharacterAdded:Connect(function(character)
		local humanoid = character:WaitForChild("Humanoid")
		task.wait(0.1)
		humanoid.WalkSpeed = originalWalkSpeed * speedMultiplier
	end)
end

local speedFrame = Instance.new("Frame")
speedFrame.Name = "SpeedFrame"
speedFrame.Size = UDim2.new(0.8, 0, 0, 50)
speedFrame.Position = UDim2.new(0.1, 0, 0, 200)
speedFrame.BackgroundTransparency = 1
speedFrame.Parent = mainFrame

local speedLabel = Instance.new("TextLabel")
speedLabel.Size = UDim2.new(1, 0, 0, 20)
speedLabel.Position = UDim2.new(0, 0, 0, 0)
speedLabel.BackgroundTransparency = 1
speedLabel.Text = "⚡ Скорость: 1x"
speedLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
speedLabel.TextSize = 14
speedLabel.Font = Enum.Font.Gotham
speedLabel.TextXAlignment = Enum.TextXAlignment.Left
speedLabel.Parent = speedFrame

local sliderBg = Instance.new("Frame")
sliderBg.Size = UDim2.new(1, 0, 0, 4)
sliderBg.Position = UDim2.new(0, 0, 0, 25)
sliderBg.BackgroundColor3 = Color3.fromRGB(80, 80, 80)
sliderBg.BorderSizePixel = 0
sliderBg.Parent = speedFrame

local sliderCorner = Instance.new("UICorner")
sliderCorner.CornerRadius = UDim.new(0, 2)
sliderCorner.Parent = sliderBg

local sliderFill = Instance.new("Frame")
sliderFill.Size = UDim2.new(0.2, 0, 1, 0)
sliderFill.BackgroundColor3 = Color3.fromRGB(100, 200, 100)
sliderFill.BorderSizePixel = 0
sliderFill.Parent = sliderBg

local fillCorner = Instance.new("UICorner")
fillCorner.CornerRadius = UDim.new(0, 2)
fillCorner.Parent = sliderFill

local sliderButton = Instance.new("TextButton")
sliderButton.Size = UDim2.new(0, 16, 0, 16)
sliderButton.Position = UDim2.new(0.2, -8, 0, -6)
sliderButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
sliderButton.Text = ""
sliderButton.BorderSizePixel = 0
sliderButton.Parent = sliderBg

local buttonCorner = Instance.new("UICorner")
buttonCorner.CornerRadius = UDim.new(1, 0)
buttonCorner.Parent = sliderButton

local speedValue = 1
local draggingSpeed = false

local function updateSpeed(value)
	speedValue = math.clamp(value, 1, 5)
	local percent = (speedValue - 1) / 4
	sliderFill.Size = UDim2.new(percent, 0, 1, 0)
	sliderButton.Position = UDim2.new(percent, -8, 0, -6)
	speedLabel.Text = string.format("⚡ Скорость: %.1fx", speedValue)
	
	speedMultiplier = speedValue
	updatePlayerSpeed()
end

sliderButton.MouseButton1Down:Connect(function()
	draggingSpeed = true
	playSound("click")
end)

game:GetService("UserInputService").InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		draggingSpeed = false
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if draggingSpeed and input.UserInputType == Enum.UserInputType.MouseMovement then
		local mousePos = input.Position.X
		local sliderAbsPos = sliderBg.AbsolutePosition.X
		local sliderWidth = sliderBg.AbsoluteSize.X
		
		local relativePos = math.clamp((mousePos - sliderAbsPos) / sliderWidth, 0, 1)
		local newSpeed = 1 + (relativePos * 4)
		updateSpeed(newSpeed)
	end
end)

local activeHighlights = {}
local isHighlightActive = false
local updateLoop = nil

local function addHighlightToPlayer(player)
	if not isHighlightActive then return end
	if player == game.Players.LocalPlayer then return end
	
	local character = player.Character
	if character and character:FindFirstChild("HumanoidRootPart") then
		if activeHighlights[player] then
			activeHighlights[player]:Destroy()
		end
		
		local highlight = Instance.new("Highlight")
		highlight.Parent = character
		highlight.FillColor = Color3.fromRGB(255, 0, 0)
		highlight.FillTransparency = 0.5
		highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
		highlight.OutlineTransparency = 0.3
		highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
		
		activeHighlights[player] = highlight
	end
end

local function refreshAllHighlights()
	if not isHighlightActive then return end
	
	local localPlayer = game.Players.LocalPlayer
	
	for _, player in pairs(game.Players:GetPlayers()) do
		if player ~= localPlayer then
			addHighlightToPlayer(player)
		end
	end
end

local function highlightAllPlayers()
	if isHighlightActive then return end
	
	isHighlightActive = true
	refreshAllHighlights()
	
	if updateLoop then return end
	
	updateLoop = task.spawn(function()
		while isHighlightActive do
			task.wait(0.5)
			refreshAllHighlights()
		end
		updateLoop = nil
	end)
end

local function clearHighlights()
	isHighlightActive = false
	
	for player, highlight in pairs(activeHighlights) do
		if highlight and highlight.Parent then
			highlight:Destroy()
		end
	end
	activeHighlights = {}
end

local toggleButton = Instance.new("TextButton")
toggleButton.Name = "ToggleButton"
toggleButton.Size = UDim2.new(0.8, 0, 0, 40)
toggleButton.Position = UDim2.new(0.1, 0, 0, 80)
toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
toggleButton.Text = "🔍 Подсветка игроков"
toggleButton.TextColor3 = Color3.fromRGB(255, 255, 255)
toggleButton.TextSize = 18
toggleButton.Font = Enum.Font.Gotham
toggleButton.BorderSizePixel = 0
toggleButton.Parent = mainFrame

local toggleButtonCorner = Instance.new("UICorner")
toggleButtonCorner.CornerRadius = UDim.new(0, 8)
toggleButtonCorner.Parent = toggleButton

toggleButton.MouseEnter:Connect(function()
	toggleButton.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
end)

toggleButton.MouseLeave:Connect(function()
	if isHighlightActive then
		toggleButton.BackgroundColor3 = Color3.fromRGB(80, 150, 80)
	else
		toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
	end
end)

toggleButton.MouseButton1Down:Connect(function()
	if isHighlightActive then
		toggleButton.BackgroundColor3 = Color3.fromRGB(80, 120, 80)
	else
		toggleButton.BackgroundColor3 = Color3.fromRGB(80, 80, 120)
	end
	playSound("click")
end)

toggleButton.MouseButton1Up:Connect(function()
	if isHighlightActive then
		toggleButton.BackgroundColor3 = Color3.fromRGB(80, 150, 80)
	else
		toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
	end
end)

toggleButton.MouseButton1Click:Connect(function()
	if not isHighlightActive then
		highlightAllPlayers()
		toggleButton.BackgroundColor3 = Color3.fromRGB(80, 150, 80)
		toggleButton.Text = "✅ Подсветка активна"
		showNotification("✨ Подсветка игроков включена!", Color3.fromRGB(100, 255, 100), "highlight", 2)
	else
		clearHighlights()
		toggleButton.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
		toggleButton.Text = "🔍 Подсветка игроков"
		showNotification("❌ Подсветка игроков отключена", Color3.fromRGB(255, 100, 100), "disable", 2)
	end
end)

game.Players.PlayerAdded:Connect(function(player)
	if isHighlightActive then
		task.wait(1)
		addHighlightToPlayer(player)
	end
end)


setupSpeedConnection()
updatePlayerSpeed()
