local screenGui = Instance.new("ScreenGui")
screenGui.Name = "MainGui"
screenGui.Parent = game.Players.LocalPlayer:WaitForChild("PlayerGui")

local mainFrame = Instance.new("Frame")
mainFrame.Name = "MainFrame"
mainFrame.Size = UDim2.new(0, 300, 0, 160)
mainFrame.Position = UDim2.new(0.5, -150, 0.5, -80)
mainFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
mainFrame.BackgroundTransparency = 0.2
mainFrame.BorderSizePixel = 0
mainFrame.Parent = screenGui

local uiCorner = Instance.new("UICorner")
uiCorner.CornerRadius = UDim.new(0, 12)
uiCorner.Parent = mainFrame

local title = Instance.new("TextLabel")
title.Name = "Title"
title.Size = UDim2.new(1, 0, 0, 40)
title.Position = UDim2.new(0, 0, 0, 0)
title.BackgroundColor3 = Color3.fromRGB(70, 70, 70)
title.BackgroundTransparency = 0.3
title.BorderSizePixel = 0
title.Text = "🎭 TestESP GUI 🎭"
title.TextColor3 = Color3.fromRGB(255, 255, 255)
title.TextSize = 20
title.Font = Enum.Font.GothamBold
title.Parent = mainFrame

local titleCorner = Instance.new("UICorner")
titleCorner.CornerRadius = UDim.new(0, 12)
titleCorner.Parent = title

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

	wait(duration - 0.3)
	local disappearTween = tweenService:Create(notification, 
		TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.In),
		{BackgroundTransparency = 1, Position = UDim2.new(0.5, -150, 0.85, 0)}
	)
	disappearTween:Play()
end

local activeHighlights = {}

local function highlightAllPlayers()
	for _, highlight in pairs(activeHighlights) do
		if highlight and highlight.Parent then
			highlight:Destroy()
		end
	end
	activeHighlights = {}

	local localPlayer = game.Players.LocalPlayer
	local character = localPlayer.Character
	if not character or not character.Parent then return end

	local playersFound = 0

	for _, player in pairs(game.Players:GetPlayers()) do
		if player ~= localPlayer then
			local playerChar = player.Character
			if playerChar and playerChar:FindFirstChild("HumanoidRootPart") then
				local highlight = Instance.new("Highlight")
				highlight.Name = "PlayerHighlight_" .. player.Name
				highlight.Parent = playerChar
				highlight.FillColor = Color3.fromRGB(255, 0, 0)
				highlight.FillTransparency = 0.5
				highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
				highlight.OutlineTransparency = 0.3
				highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

				activeHighlights[player] = highlight
				playersFound = playersFound + 1

				spawn(function()
					local t = 0
					while highlight and highlight.Parent do
						t = t + 0.05
						local intensity = (math.sin(t * 8) + 1) / 2
						highlight.FillTransparency = 0.3 + (intensity * 0.3)
						highlight.OutlineTransparency = 0.2 + (intensity * 0.3)
						wait(0.05)
					end
				end)
			end
		end
	end

	if playersFound > 0 then
		showNotification("🔍 Найдено игроков: " .. playersFound .. "!\nПодсветка активирована", 
			Color3.fromRGB(100, 255, 100), "highlight", 3)
	else
		showNotification("⚠️ Других игроков не найдено!", 
			Color3.fromRGB(255, 200, 100), "error", 2)
	end
end

local function clearHighlights()
	local count = 0
	for player, highlight in pairs(activeHighlights) do
		if highlight and highlight.Parent then
			highlight:Destroy()
			count = count + 1
		end
	end
	activeHighlights = {}

	if count > 0 then
		showNotification("❌ Подсветка отключена\n(было подсвечено " .. count .. " игроков)", 
			Color3.fromRGB(255, 255, 255), "disable", 2)
	end
end

local function createButton(name, text, yPosition, clickColor)
	local button = Instance.new("TextButton")
	button.Name = name
	button.Size = UDim2.new(0.8, 0, 0, 40)
	button.Position = UDim2.new(0.1, 0, 0, yPosition)
	button.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
	button.Text = text
	button.TextColor3 = Color3.fromRGB(255, 255, 255)
	button.TextSize = 18
	button.Font = Enum.Font.Gotham
	button.BorderSizePixel = 0
	button.Parent = mainFrame

	local buttonCorner = Instance.new("UICorner")
	buttonCorner.CornerRadius = UDim.new(0, 8)
	buttonCorner.Parent = button

	button.MouseEnter:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
	end)

	button.MouseLeave:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
	end)

	button.MouseButton1Down:Connect(function()
		button.BackgroundColor3 = clickColor
		playSound("click")
	end)

	button.MouseButton1Up:Connect(function()
		button.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
	end)

	return button
end

local button1 = createButton("Button1", "🔍 Подсветка игроков", 55, Color3.fromRGB(80, 120, 80))
local button2 = createButton("Button2", "❌ Отключить подсветку", 105, Color3.fromRGB(80, 80, 120))


local isHighlightActive = false

button1.MouseButton1Click:Connect(function()
	print("Активирована подсветка игроков!")

	if not isHighlightActive then
		highlightAllPlayers()
		isHighlightActive = true
		button1.BackgroundColor3 = Color3.fromRGB(80, 150, 80)
		button1.Text = "✅ Подсветка активна"
	else
		showNotification("⚠️ Подсветка уже активна!\nИспользуйте 2-ю кнопку для отключения", 
			Color3.fromRGB(255, 200, 100), "error", 2)
	end
end)

button2.MouseButton1Click:Connect(function()
	print("Подсветка отключена!")
	clearHighlights()
	isHighlightActive = false
	button1.BackgroundColor3 = Color3.fromRGB(100, 100, 100)
	button1.Text = "🔍 Подсветка игроков"
end)

game.Players.PlayerAdded:Connect(function(player)
	if isHighlightActive then
		wait(1)
		if player.Character then
			local highlight = Instance.new("Highlight")
			highlight.Name = "PlayerHighlight_" .. player.Name
			highlight.Parent = player.Character
			highlight.FillColor = Color3.fromRGB(255, 0, 0)
			highlight.FillTransparency = 0.5
			highlight.OutlineColor = Color3.fromRGB(255, 255, 255)
			highlight.OutlineTransparency = 0.3
			highlight.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop

			activeHighlights[player] = highlight

			showNotification("✨ Новый игрок присоединился!\nАвтоматически подсвечен", 
				Color3.fromRGB(100, 255, 100), "highlight", 2)
		end
	end
end)

game.Players.PlayerRemoving:Connect(function(player)
	if activeHighlights[player] then
		activeHighlights[player]:Destroy()
		activeHighlights[player] = nil
	end
end)

local dragging = false
local dragStart
local startPos

title.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
	end
end)

title.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

game:GetService("UserInputService").InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, 
			startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)
