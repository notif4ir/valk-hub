local skins

if game.PlaceId == 18186775539 then

skins = {
    Rush = {
        {Name = "none", Description = "literally just nothing."},
	{Name = "trollface", Description = "GET TROLLOLOLOLOLLED!"},
    },
    Stare = {
        {Name = "none", Description = "literally just nothing."},
	{Name = "chomik", Description = "find the rushes [613761346]"},
    },
}

local Players = game:GetService("Players")
local player = Players.LocalPlayer

local selected = {}

local screenGui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
screenGui.Name = "SkinsUI"

local openButton = Instance.new("TextButton", screenGui)
openButton.Size = UDim2.new(0, 120, 0, 40)
openButton.Position = UDim2.new(0, 160, 0, 20)
openButton.Text = "Skins"
openButton.BackgroundColor3 = Color3.fromRGB(50, 50, 50)
openButton.TextColor3 = Color3.new(1, 1, 1)
openButton.Font = Enum.Font.SourceSansBold
openButton.TextSize = 20

local mainFrame = Instance.new("Frame", screenGui)
mainFrame.Size = UDim2.new(0, 700, 0, 500)
mainFrame.Position = UDim2.new(0.5, -350, 0.5, -250)
mainFrame.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
mainFrame.Visible = false

local categoryFrame = Instance.new("Frame", mainFrame)
categoryFrame.Size = UDim2.new(0, 150, 1, -20)
categoryFrame.Position = UDim2.new(0, 10, 0, 10)
categoryFrame.BackgroundColor3 = Color3.fromRGB(35, 35, 35)

local scrollFrame = Instance.new("ScrollingFrame", mainFrame)
scrollFrame.Size = UDim2.new(0, 250, 1, -20)
scrollFrame.Position = UDim2.new(0, 170, 0, 10)
scrollFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
scrollFrame.ScrollBarThickness = 8
scrollFrame.BackgroundTransparency = 1

local detailFrame = Instance.new("Frame", mainFrame)
detailFrame.Size = UDim2.new(1, -440, 1, -20)
detailFrame.Position = UDim2.new(0, 430, 0, 10)
detailFrame.BackgroundColor3 = Color3.fromRGB(40, 40, 40)

local nameLabel = Instance.new("TextLabel", detailFrame)
nameLabel.Size = UDim2.new(1, -20, 0, 40)
nameLabel.Position = UDim2.new(0, 10, 0, 10)
nameLabel.Text = "Skin Name"
nameLabel.Font = Enum.Font.SourceSansBold
nameLabel.TextColor3 = Color3.new(1, 1, 1)
nameLabel.TextSize = 22
nameLabel.BackgroundTransparency = 1
nameLabel.TextXAlignment = Enum.TextXAlignment.Left

local descLabel = Instance.new("TextLabel", detailFrame)
descLabel.Size = UDim2.new(1, -20, 0, 100)
descLabel.Position = UDim2.new(0, 10, 0, 60)
descLabel.Text = "Skin Description"
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
toggleButton.Text = "Equip"
toggleButton.BackgroundColor3 = Color3.fromRGB(70, 130, 180)
toggleButton.TextColor3 = Color3.new(1, 1, 1)
toggleButton.Font = Enum.Font.SourceSansBold
toggleButton.TextSize = 18

local function saveSkins()
    local lines = {}
    for category, skin in pairs(skins) do
        local selectedSkin = selected[category] or "none"
        table.insert(lines, category .. ":" .. selectedSkin)
    end
    writefile("skins.txt", table.concat(lines, "\n"))
end

local function loadSkins()
    if isfile("skins.txt") then
        local contents = readfile("skins.txt")
        for line in contents:gmatch("[^\r\n]+") do
            local cat, skin = line:match("([^:]+):(.+)")
            if cat then
                selected[cat] = skin ~= "none" and skin or nil
            end
        end
    end
end

loadSkins()

local currentCategory = nil
local currentSkin = nil
local skinButtons = {}

local function updateScroll(category)
    scrollFrame:ClearAllChildren()
    skinButtons = {}
    local skinList = skins[category]
    scrollFrame.CanvasSize = UDim2.new(0, 0, 0, #skinList * 35)
    for i, skinData in ipairs(skinList) do
        local button = Instance.new("TextButton", scrollFrame)
        button.Size = UDim2.new(1, -10, 0, 30)
        button.Position = UDim2.new(0, 5, 0, (i - 1) * 35)
        button.Text = skinData.Name
        button.Name = skinData.Name
        button.BackgroundColor3 = Color3.fromRGB(45, 45, 45)
        button.TextColor3 = Color3.new(1, 1, 1)
        button.Font = Enum.Font.SourceSans
        button.TextSize = 18

        if selected[category] == skinData.Name then
            button.Text = skinData.Name .. " ✓"
        end

        button.MouseButton1Click:Connect(function()
            currentSkin = skinData
            currentCategory = category
            nameLabel.Text = skinData.Name
            descLabel.Text = skinData.Description
            toggleButton.Text = selected[category] == skinData.Name and "Unequip" or "Equip"
        end)

        skinButtons[skinData.Name] = button
    end
end

local categories = {}
for k in pairs(skins) do
    table.insert(categories, k)
end
table.sort(categories)

for i, category in ipairs(categories) do
    local catBtn = Instance.new("TextButton", categoryFrame)
    catBtn.Size = UDim2.new(1, -10, 0, 35)
    catBtn.Position = UDim2.new(0, 5, 0, (i - 1) * 40)
    catBtn.Text = category
    catBtn.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
    catBtn.TextColor3 = Color3.new(1, 1, 1)
    catBtn.Font = Enum.Font.SourceSansBold
    catBtn.TextSize = 18
    catBtn.MouseButton1Click:Connect(function()
        currentCategory = category
        currentSkin = nil
        nameLabel.Text = "Skin Name"
        descLabel.Text = "Skin Description"
        toggleButton.Text = "Equip"
        updateScroll(category)
    end)
end

toggleButton.MouseButton1Click:Connect(function()
    if currentCategory and currentSkin then
        local name = currentSkin.Name
        if selected[currentCategory] == name then
            selected[currentCategory] = nil
        else
            selected[currentCategory] = name
        end
        updateScroll(currentCategory)
        toggleButton.Text = selected[currentCategory] == name and "Unequip" or "Equip"
        saveSkins()
    end
end)

openButton.MouseButton1Click:Connect(function()
    mainFrame.Visible = not mainFrame.Visible
end)

end

if game.PlaceId == 77614252294790 then
	local skins = readfile("skins.txt")
	if skins then
		if skins:match("Rush") then
			if skins:match("trollface") then
				game["Run Service"].RenderStepped:Connect(function()
					if game.Workspace:FindFirstChild("Rush") then
						for i,v in game.Workspace.Rush:GetDescendants() do
							if v:IsA("ParticleEmitter") then
								if v.Name == "Face" then
									v.Texture="rbxassetid://" .. 14916455401
								else
									v:Destroy()
								end
							end
							if v:IsA("ImageLabel") then v:Destroy() end
						end
					end
				end)
			end
		end
		if skins:match("Stare") then
			if skins:match("chomik") then
				game["Run Service"].RenderStepped:Connect(function()
					if game.Workspace:FindFirstChild("Stare") then
						for i,v in game.Workspace.Rush:GetDescendants() do
							if v:IsA("ParticleEmitter") then
								if v.Name == "Face" then
									v.Texture="rbxassetid://" .. 18939510828
								else
									v:Destroy()
								end
							end
							if v:IsA("ImageLabel") then v:Destroy() end
						end
					end
				end)
			end
		end
	end
end
