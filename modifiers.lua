local modifiers

if game.PlaceId == 18186775539 then

modifiers = {
    {Name = "Absolute Chaos", Description = "Glitches out the whole map."},
    {Name = "Never too fast", Description = "Randomizes your speed every 10 seconds."},
	{Name = "GOTTA GO FAST", Description = "Be fast as lightning."},
	{Name = "Hopping Time", Description = "Be able to jump."},
	{Name = "Orbit", Description = "Enables low gravity."},
	{Name = "Slow as a turtle", Description = "Your speed is nearly 2x slower."},
	{Name = "Blackout", Description = "Delete's all lights from the map."},
	{Name = "Out of pockets", Description = "You can't equip any items."},
	{Name = "Slippery Situation", Description = "Everything's slippery now"},
	{Name = "Brain Damage", Description = "Everything one shots you."},
}

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local selected = {}

local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "ModifiersUI"

local openButton = Instance.new("TextButton", screenGui)
openButton.Size = UDim2.new(0, 120, 0, 40)
openButton.Position = UDim2.new(0, 20, 0, 20)
openButton.Text = "Modifiers"
openButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
openButton.TextColor3 = Color3.new(1, 1, 1)
openButton.Font = Enum.Font.SourceSansBold
openButton.TextSize = 20

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 600, 0, 400)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Visible = false

local scrollFrame = Instance.new("ScrollingFrame", mainFrame)
scrollFrame.Size = UDim2.new(0.5, -10, 1, -20)
scrollFrame.Position = UDim2.new(0, 10, 0, 10)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #modifiers * 35)
scrollFrame.ScrollBarThickness = 8
scrollFrame.BackgroundTransparency = 1

local detailFrame = Instance.new("Frame", mainFrame)
detailFrame.Size = UDim2.new(0.5, -20, 1, -20)
detailFrame.Position = UDim2.new(0.5, 10, 0, 10)
detailFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local nameLabel = Instance.new("TextLabel", detailFrame)
nameLabel.Size = UDim2.new(1, -20, 0, 40)
nameLabel.Position = UDim2.new(0, 10, 0, 10)
nameLabel.Text = "Modifier Name"
nameLabel.Font = Enum.Font.SourceSansBold
nameLabel.TextColor3 = Color3.new(1, 1, 1)
nameLabel.TextSize = 22
nameLabel.BackgroundTransparency = 1
nameLabel.TextXAlignment = Enum.TextXAlignment.Left

local descLabel = Instance.new("TextLabel", detailFrame)
descLabel.Size = UDim2.new(1, -20, 0, 100)
descLabel.Position = UDim2.new(0, 10, 0, 60)
descLabel.Text = "Modifier Description"
descLabel.Font = Enum.Font.SourceSans
descLabel.TextColor3 = Color3.new(1, 1, 1)
descLabel.TextSize = 18
descLabel.TextWrapped = true
descLabel.TextYAlignment = Enum.TextYAlignment.Top
descLabel.BackgroundTransparency = 1
descLabel.TextXAlignment = Enum.TextXAlignment.Left

local toggleButton = Instance.new("TextButton", detailFrame)
toggleButton.Size = UDim2.new(0, 100, 0, 30)
toggleButton.Position = UDim2.new(0, 10, 0, 170)
toggleButton.Text = "Toggle"
toggleButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 18

local function saveModifiers()
    local toSave = {}
    for name, state in pairs(selected) do
        if state then
            table.insert(toSave, name)
        end
    end
    writefile("modifiers.txt", table.concat(toSave, "\n"))
end

local function loadModifiers()
    if isfile("modifiers.txt") then
        local contents = readfile("modifiers.txt")
        for line in contents:gmatch("[^\r\n]+") do
            selected[line] = true
        end
    end
end

loadModifiers()

local currentMod = nil

for i, modData in ipairs(modifiers) do
    local button = Instance.new("TextButton", scrollFrame)
    button.Size = UDim2.new(1, -10, 0, 30)
    button.Position = UDim2.new(0, 5, 0, (i - 1) * 35)
    button.Text = modData.Name
    button.Name = modData.Name
    button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
    button.TextColor3 = Color3.new(1, 1, 1)
    button.Font = Enum.Font.SourceSans
    button.TextSize = 18

    if selected[modData.Name] then
        button.Text = modData.Name .. " ✓"
    end

    button.MouseButton1Click:Connect(function()
        currentMod = modData
        nameLabel.Text = modData.Name
        descLabel.Text = modData.Description
        local isOn = selected[modData.Name]
        toggleButton.Text = isOn and "Turn Off" or "Turn On"
    end)
end

toggleButton.MouseButton1Click:Connect(function()
    if currentMod then
        local name = currentMod.Name
        selected[name] = not selected[name]
        toggleButton.Text = selected[name] and "Turn Off" or "Turn On"
        local btn = scrollFrame:FindFirstChild(name)
        if btn then
            btn.Text = selected[name] and (name .. " ✓") or name
        end
        saveModifiers()
    end
end)

openButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

end

if game.PlaceId == 77614252294790 then
	local modifiers = readfile("modifiers.txt")
	if modifiers then
		if modifiers:match("Out of pockets") then
			spawn(function()
				game.Players.LocalPlayer.Backpack.ChildAdded:Connect(function(child)
					child:Destroy()
				end)
			end)
		end
		if modifiers:match("GOTTA GO FAST") then
			spawn(function()
				game["Run Service"].RenderStepped:Connect(function()
					game.Players.LocalPlayer.Character.Humanoid.WalkSpeed=64
				end)
			end)
		end
		if modifiers:match("Never too fast") then
			spawn(function()
				local speed = 16
				spawn(function()
					game["Run Service"].RenderStepped:Connect(function()
						game.Players.LocalPlayer.Character.Humanoid.WalkSpeed=speed
					end)
				end)
				while wait(10) do
					if game.Players.LocalPlayer.Character then
						speed=math.random(0,50)
					end
				end
			end)
		end
		if modifiers:match("Hopping Time") then
			spawn(function()
				game.UserInputService.InputBegan:Connect(function(key,gpc)
	if gpc then return end
	if key.KeyCode==Enum.KeyCode.Space then
		game.Players.LocalPlayer.Character.Humanoid.Jump=true
	end
end)

game.UserInputService.InputEnded:Connect(function(key,gpc)
	if gpc then return end
	if key.KeyCode==Enum.KeyCode.Space then
		game.Players.LocalPlayer.Character.Humanoid.Jump=false
	end
end)

game["Run Service"].RenderStepped:Connect(function()
	game.Players.LocalPlayer.Character.Humanoid.JumpHeight=8
	game.Players.LocalPlayer.Character.Humanoid.JumpPower=65
end)
			end)
		end
		if modifiers:match("Orbit") then
			spawn(function()
				game.Workspace.Gravity=32
			end)
		end
		if modifiers:match("Slow as a turtle") then
			spawn(function()
				game["Run Service"].RenderStepped:Connect(function()
					game.Players.LocalPlayer.Character.Humanoid.WalkSpeed=10
				end)
			end)
		end
		if modifiers:match("Blackout") then
			spawn(function()
				game.DescendantAdded:Connect(function(child)
					if child:IsA("PointLight") or child:IsA("SpotLight") then
						child:Destroy()
					end
				end)
				for i,child in game:GetDescendants() do
					if child:IsA("PointLight") or child:IsA("SpotLight") then
						child:Destroy()
					end
				end
			end)
		end
		if modifiers:match("Slippery Situation") then
			spawn(function()
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local player = Players.LocalPlayer

local character = player.Character or player.CharacterAdded:Wait()
local humanoidRootPart = character:WaitForChild("HumanoidRootPart")
local humanoid = character:WaitForChild("Humanoid")

local velocity = Vector3.zero
local slipFactor = 0.96
local controlForce = 60
local maxSpeed = 40

RunService.RenderStepped:Connect(function(dt)
	character = player.Character
	if not character then return end
	humanoidRootPart = character:FindFirstChild("HumanoidRootPart")
	humanoid = character:FindFirstChildOfClass("Humanoid")
	if not humanoidRootPart or not humanoid then return end
	
	local moveDir = humanoid.MoveDirection
	if moveDir.Magnitude > 0 then
		velocity += moveDir.Unit * controlForce * dt
	end
	
	if velocity.Magnitude > maxSpeed then
		velocity = velocity.Unit * maxSpeed
	end
	
	velocity *= slipFactor
	humanoidRootPart.Velocity = Vector3.new(velocity.X, humanoidRootPart.Velocity.Y, velocity.Z)
end)
		end)
		end
		if modifiers:match("Brain Damage") then
			game.Players.LocalPlayer.Character.Humanoid.HealthChanged:Connect(function()
				if game.Players.LocalPlayer.Character.Humanoid.Health <= 99 then
					game.Players.LocalPlayer.Character.Humanoid.Health=0
				end		
			end)
		end
		if modifiers:match("Absolute Chaos") then
			spawn(function()
				local multiplier = 1

local materials = {
	Enum.Material.Plastic,
	Enum.Material.SmoothPlastic,
	Enum.Material.Metal,
	Enum.Material.Wood,
	Enum.Material.Concrete,
	Enum.Material.Glass,
	Enum.Material.Neon,
	Enum.Material.Granite,
	Enum.Material.Slate,
	Enum.Material.Cobblestone,
	Enum.Material.Brick,
	Enum.Material.DiamondPlate,
	Enum.Material.Fabric,
	Enum.Material.Foil,
	Enum.Material.Marble,
	Enum.Material.Pebble,
	Enum.Material.Sand,
	Enum.Material.WoodPlanks
}

local function randomColor(part)
	if part.Parent and part.Parent:FindFirstChildOfClass("Humanoid") then
		if game.Players:FindFirstChild(part.Parent.Name) then return end
	end
	if part:IsA("BasePart") then
		local offset = Vector3.new(
			math.random(-100,100)/100,
			math.random(-100,100)/100,
			math.random(-100,100)/100
	 ) * multiplier
		part.Position += offset
		for i,desc in part:GetChildren() do
			if desc:IsA("Decal") or desc:IsA("Texture") or desc:IsA("SurfaceAppearance") then
				desc:Destroy()
			end
		end
		part.BrickColor = BrickColor.Random()
		part.Material = materials[math.random(1, #materials)]
	end
	if part:IsA("MeshPart") then
		part.TextureID = ""
	end
	if part:IsA("GuiObject") then
		local pos = part.Position
		local newX = pos.X.Offset + math.random(-100,100) * multiplier
		local newY = pos.Y.Offset + math.random(-100,100) * multiplier
		part.Position = UDim2.new(pos.X.Scale, newX, pos.Y.Scale, newY)
		if part:IsA("ImageLabel") or part:IsA("ImageButton") then
			part.ImageColor3 = Color3.new(math.random()* multiplier, math.random()* multiplier, math.random()* multiplier)
		else
			part.BackgroundColor3 = Color3.new(math.random()* multiplier, math.random()* multiplier, math.random()* multiplier)
		end
	end
	if part:IsA("PointLight") then
		part.Range = math.random(5, 30) * multiplier
		part.Brightness = math.random() * 5 * multiplier
		part.Color = Color3.new(math.random()* multiplier, math.random()* multiplier, math.random()* multiplier)
	end
end

game.DescendantAdded:Connect(function(child)
	randomColor(child)
end)

for i,v in game:GetDescendants() do
	randomColor(v)
end
			end)
		end
	end
end
