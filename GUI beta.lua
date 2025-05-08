-- LocalScript em StarterGui
if not _G.HitboxManager then
    warn("HitboxManager não encontrado! Certifique-se de carregá-lo antes da GUI.")
    return
end

local player = game.Players.LocalPlayer
local gui = Instance.new("ScreenGui", player:WaitForChild("PlayerGui"))
gui.Name = "AutoParryUI"
gui.ResetOnSpawn = false

-- Variáveis de estado (persistentes entre abas)
local autoParryEnabled = true
local hitboxRange = 25
local hitboxTransparency = 30
local autoFarmEnabled = false
local currentTab = "home"

-- Funções auxiliares
local function applyRoundedCorners(guiObject, radius)
	local corner = Instance.new("UICorner")
	corner.CornerRadius = radius or UDim.new(0, 8)
	corner.Parent = guiObject
end

local function createButton(text, parent, pos, size, bgColor, textColor)
	local btn = Instance.new("TextButton")
	btn.Text = text
	btn.Font = Enum.Font.Highway
	btn.TextSize = 20
	btn.TextColor3 = textColor or Color3.new(0, 0, 0)
	btn.Size = size
	btn.Position = pos
	btn.BackgroundColor3 = bgColor
	btn.BorderSizePixel = 4
	btn.Parent = parent
	applyRoundedCorners(btn)
	return btn
end

local function createLabel(text, parent, pos, size, bgColor, textColor)
	local label = Instance.new("TextLabel")
	label.Text = text
	label.Font = Enum.Font.Highway
	label.TextSize = 18
	label.TextColor3 = textColor or Color3.new(0, 0, 0)
	label.Size = size
	label.Position = pos
	label.BackgroundColor3 = bgColor
	label.BackgroundTransparency = 0.5
	label.Parent = parent
	applyRoundedCorners(label)
	return label
end

-- Frame principal
local mainFrame = Instance.new("Frame", gui)
mainFrame.Size = UDim2.new(0, 500, 0, 300)
mainFrame.Position = UDim2.new(0.5, -300, 0.5, -200)
mainFrame.BackgroundColor3 = Color3.fromRGB(104, 41, 168)
mainFrame.ClipsDescendants = true
applyRoundedCorners(mainFrame)

-- TopBar
local topBar = Instance.new("Frame", mainFrame)
topBar.Size = UDim2.new(1, 0, 0, 40)
topBar.BackgroundColor3 = Color3.fromRGB(153, 86, 145)
applyRoundedCorners(topBar)

local topBarTitle = createLabel("Inicio", topBar, UDim2.new(0, 200, 0, 0), UDim2.new(0, 100, 1, 0), Color3.fromRGB(0, 0, 0), Color3.fromRGB(255, 229, 73))
applyRoundedCorners(topBarTitle)

local icon = Instance.new("TextLabel")
icon.Text = "v"
icon.Font = Enum.Font.Fondamento
icon.TextSize = 40
icon.TextColor3 = Color3.new(0, 0, 0)
icon.Size = UDim2.new(0, 50, 1, 0)
icon.Position = UDim2.new(0, 0, 0, 0)
icon.BackgroundColor3 = Color3.fromRGB(255, 74, 240)
icon.BackgroundTransparency = 0.5
icon.Parent = topBar
applyRoundedCorners(icon)

local closeButton = createButton("X", topBar, UDim2.new(1, -30, 0, 0), UDim2.new(0, 30, 1, 0), Color3.fromRGB(255, 50, 50), Color3.new(1, 1, 1))
local minimizeButton = createButton("-", topBar, UDim2.new(1, -60, 0, 0), UDim2.new(0, 30, 1, 0), Color3.fromRGB(200, 200, 50), Color3.new(0, 0, 0))

-- Menu lateral
local sidebar = Instance.new("Frame", mainFrame)
sidebar.Size = UDim2.new(0, 120, 1, -40)
sidebar.Position = UDim2.new(0, 0, 0, 40)
sidebar.BackgroundColor3 = Color3.fromRGB(152, 114, 177)
applyRoundedCorners(sidebar)

-- Conteúdo principal (container para todas as abas)
local contentFrame = Instance.new("Frame", mainFrame)
contentFrame.Size = UDim2.new(1, -120, 1, -40)
contentFrame.Position = UDim2.new(0, 120, 0, 40)
contentFrame.BackgroundTransparency = 1
contentFrame.ClipsDescendants = true

-- Criar containers para cada aba
local tabFrames = {
	home = Instance.new("Frame", contentFrame),
	farm = Instance.new("Frame", contentFrame),
	settings = Instance.new("Frame", contentFrame)
}

-- Configurar todos os frames de aba
for name, frame in pairs(tabFrames) do
	frame.Size = UDim2.new(1, 0, 1, 0)
	frame.Position = UDim2.new(0, 0, 0, 0)
	frame.BackgroundTransparency = 1
	frame.Visible = false
end

-- Mostrar a aba inicial
tabFrames.home.Visible = true

-- Função para trocar de abas
local function switchTab(tabName)
	-- Esconder todas as abas
	for name, frame in pairs(tabFrames) do
		frame.Visible = false
	end

	-- Mostrar a aba selecionada
	if tabFrames[tabName] then
		tabFrames[tabName].Visible = true
		currentTab = tabName
	end

	-- Atualizar o título na topBar
	topBarTitle.Text = string.upper(string.sub(tabName, 1, 1)) .. string.sub(tabName, 2)
end

-- Criar botões da sidebar
local homeBtn = createButton("Inicio", sidebar, UDim2.new(0, 5, 0, 5), UDim2.new(1, -10, 0, 30), Color3.fromRGB(255, 229, 73))
local farmBtn = createButton("Farm", sidebar, UDim2.new(0, 5, 0, 40), UDim2.new(1, -10, 0, 30), Color3.fromRGB(201, 170, 129))
local settingsBtn = createButton("Settings", sidebar, UDim2.new(0, 5, 0, 75), UDim2.new(1, -10, 0, 30), Color3.fromRGB(201, 170, 129))

-- Dicionário para controle dos botões da sidebar
local tabButtons = {
	home = homeBtn,
	farm = farmBtn,
	settings = settingsBtn
}

-- Função para atualizar a aparência dos botões da sidebar
local function updateTabButtons()
	for name, btn in pairs(tabButtons) do
		if name == currentTab then
			btn.BackgroundColor3 = Color3.fromRGB(255, 229, 73) -- Amarelo para aba ativa
			btn.TextColor3 = Color3.new(0, 0, 0) -- Texto preto
		else
			btn.BackgroundColor3 = Color3.fromRGB(201, 170, 129) -- Cor normal
			btn.TextColor3 = Color3.new(0, 0, 0) -- Texto preto
		end
	end
end

-- Conectar eventos dos botões da sidebar
homeBtn.MouseButton1Click:Connect(function() 
	switchTab("home")
	updateTabButtons()
end)

farmBtn.MouseButton1Click:Connect(function() 
	switchTab("farm")
	updateTabButtons()
end)

settingsBtn.MouseButton1Click:Connect(function() 
	switchTab("settings")
	updateTabButtons()
end)

-- Conteúdo da aba Início
do
	local homeTab = tabFrames.home

	-- Auto-Parry Status
	local autoParryLabel = createLabel("Auto-Parry Status:", homeTab, UDim2.new(0, 10, 0, 10), UDim2.new(0, 200, 0, 30), Color3.fromRGB(255, 229, 73))
	local onButton = createButton("On", homeTab, UDim2.new(0, 220, 0, 10), UDim2.new(0, 60, 0, 30), Color3.fromRGB(200, 120, 180))
	local offButton = createButton("Off", homeTab, UDim2.new(0, 290, 0, 10), UDim2.new(0, 60, 0, 30), Color3.fromRGB(255, 229, 73))

	-- Hitbox Range
	local hitboxRangeLabel = createLabel("Hitbox range:", homeTab, UDim2.new(0, 10, 0, 50), UDim2.new(0, 200, 0, 30), Color3.fromRGB(255, 229, 73))
	local hitboxRangeValue = createLabel("25/25 studs", homeTab, UDim2.new(0, 220, 0, 50), UDim2.new(0, 100, 0, 30), Color3.fromRGB(255, 229, 73))

	local rangeSlider = Instance.new("TextButton", homeTab)
	rangeSlider.Size = UDim2.new(0, 250, 0, 15)
	rangeSlider.Position = UDim2.new(0, 10, 0, 85)
	rangeSlider.BackgroundColor3 = Color3.fromRGB(153, 86, 145)
	rangeSlider.Text = ""
	rangeSlider.AutoButtonColor = false
	applyRoundedCorners(rangeSlider)

	local rangeFill = Instance.new("Frame", rangeSlider)
	rangeFill.BackgroundColor3 = Color3.fromRGB(255, 229, 73)
	rangeFill.Size = UDim2.new(hitboxRange / 25, 0, 1, 0)
	rangeFill.Position = UDim2.new(0, 0, 0, 0)
	rangeFill.BorderSizePixel = 0
	applyRoundedCorners(rangeFill)

	-- Hitbox Transparency
	local transLabel = createLabel("Hitbox Transparency:", homeTab, UDim2.new(0, 10, 0, 110), UDim2.new(0, 200, 0, 30), Color3.fromRGB(255, 229, 73))
	local transValue = createLabel("30%", homeTab, UDim2.new(0, 220, 0, 110), UDim2.new(0, 60, 0, 30), Color3.fromRGB(255, 229, 73))

	local transSlider = Instance.new("TextButton", homeTab)
	transSlider.Size = UDim2.new(0, 250, 0, 15)
	transSlider.Position = UDim2.new(0, 10, 0, 145)
	transSlider.BackgroundColor3 = Color3.fromRGB(153, 86, 145)
	transSlider.Text = ""
	transSlider.AutoButtonColor = false
	applyRoundedCorners(transSlider)

	local transFill = Instance.new("Frame", transSlider)
	transFill.BackgroundColor3 = Color3.fromRGB(255, 229, 73)
	transFill.Size = UDim2.new(hitboxTransparency / 100, 0, 1, 0)
	transFill.BorderSizePixel = 0
	applyRoundedCorners(transFill)

	-- Sliders
	local function updateRangeSlider(input)
    	local xOffset = input.Position.X - rangeSlider.AbsolutePosition.X
    	local percent = math.clamp(xOffset / rangeSlider.AbsoluteSize.X, 0, 1)
    	local value = math.floor(percent * 25)
    	hitboxRange = value
    	rangeFill.Size = UDim2.new(percent, 0, 1, 0)
    	hitboxRangeValue.Text = value .. "/25 studs"
    
    	-- Chamar a função de atualização do HitboxManager
    	_G.HitboxManager.setSize(value)
	end

	local function updateTransparencySlider(input)
    	local xOffset = input.Position.X - transSlider.AbsolutePosition.X
    	local percent = math.clamp(xOffset / transSlider.AbsoluteSize.X, 0, 1)
    	local value = math.floor(percent * 100)
    	hitboxTransparency = value
    	transFill.Size = UDim2.new(percent, 0, 1, 0)
    	transValue.Text = value .. "%"
    
    	-- Chamar a função de atualização do HitboxManager
    	_G.HitboxManager.setTransparency(value)
	end

	local draggingRange = false
	local draggingTransparency = false

	rangeSlider.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			draggingRange = true
			updateRangeSlider(input)
		end
	end)

	rangeSlider.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			draggingRange = false
		end
	end)

	transSlider.InputBegan:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			draggingTransparency = true
			updateTransparencySlider(input)
		end
	end)

	transSlider.InputEnded:Connect(function(input)
		if input.UserInputType == Enum.UserInputType.MouseButton1 then
			draggingTransparency = false
		end
	end)

	game:GetService("UserInputService").InputChanged:Connect(function(input)
		if draggingRange and input.UserInputType == Enum.UserInputType.MouseMovement then
			updateRangeSlider(input)
		elseif draggingTransparency and input.UserInputType == Enum.UserInputType.MouseMovement then
			updateTransparencySlider(input)
		end
	end)

	-- Botões On/Off
	onButton.MouseButton1Click:Connect(function()
    	if not autoParryEnabled then
        	autoParryEnabled = true
        	onButton.BackgroundColor3 = Color3.fromRGB(255, 229, 73)
        	offButton.BackgroundColor3 = Color3.fromRGB(200, 120, 180)
        	-- Ativar a hitbox
        	_G.HitboxManager.toggle(true)
    	end
	end)

	offButton.MouseButton1Click:Connect(function()
    	if autoParryEnabled then
        	autoParryEnabled = false
        	offButton.BackgroundColor3 = Color3.fromRGB(255, 229, 73)
        	onButton.BackgroundColor3 = Color3.fromRGB(200, 120, 180)
        	-- Desativar a hitbox
        	_G.HitboxManager.toggle(false)
    	end
	end)

	-- Configurar estado inicial dos botões
	offButton.BackgroundColor3 = Color3.fromRGB(200, 120, 180) 
	onButton.BackgroundColor3 = Color3.fromRGB(255, 229, 73)
end

-- Conteúdo da aba Farm
do
	local farmTab = tabFrames.farm

	local farmTitle = createLabel("Configurações de Farm", farmTab, UDim2.new(0.5, -100, 0, 20), UDim2.new(0, 200, 0, 30), Color3.fromRGB(255, 229, 73))

	-- Controles de Farm
	local farmStatusLabel = createLabel("Auto-Farm Status:", farmTab, UDim2.new(0, 10, 0, 60), UDim2.new(0, 200, 0, 30), Color3.fromRGB(255, 229, 73))
	local farmOnBtn = createButton("On", farmTab, UDim2.new(0, 220, 0, 60), UDim2.new(0, 60, 0, 30), Color3.fromRGB(200, 120, 180))
	local farmOffBtn = createButton("Off", farmTab, UDim2.new(0, 290, 0, 60), UDim2.new(0, 60, 0, 30), Color3.fromRGB(255, 229, 73))

	-- Configurar estado inicial
	farmOffBtn.BackgroundColor3 = Color3.fromRGB(200, 120, 180)
	farmOnBtn.BackgroundColor3 = Color3.fromRGB(255, 229, 73)

	-- Conectar eventos
	farmOnBtn.MouseButton1Click:Connect(function()
		if not autoFarmEnabled then
			autoFarmEnabled = true
			farmOnBtn.BackgroundColor3 = Color3.fromRGB(255, 229, 73)
			farmOffBtn.BackgroundColor3 = Color3.fromRGB(200, 120, 180)
		end
	end)

	farmOffBtn.MouseButton1Click:Connect(function()
		if autoFarmEnabled then
			autoFarmEnabled = false
			farmOffBtn.BackgroundColor3 = Color3.fromRGB(255, 229, 73)
			farmOnBtn.BackgroundColor3 = Color3.fromRGB(200, 120, 180)
		end
	end)
end

-- Conteúdo da aba Settings
do
	local settingsTab = tabFrames.settings

	local settingsTitle = createLabel("Configurações Gerais", settingsTab, UDim2.new(0.5, -100, 0, 20), UDim2.new(0, 200, 0, 30), Color3.fromRGB(255, 229, 73))

	-- Exemplo de configuração
	local uiScaleLabel = createLabel("UI Scale:", settingsTab, UDim2.new(0, 10, 0, 60), UDim2.new(0, 200, 0, 30), Color3.fromRGB(255, 229, 73))
	local uiScaleValue = createLabel("100%", settingsTab, UDim2.new(0, 220, 0, 60), UDim2.new(0, 60, 0, 30), Color3.fromRGB(255, 229, 73))

	local uiScaleSlider = Instance.new("TextButton", settingsTab)
	uiScaleSlider.Size = UDim2.new(0, 250, 0, 15)
	uiScaleSlider.Position = UDim2.new(0, 10, 0, 95)
	uiScaleSlider.BackgroundColor3 = Color3.fromRGB(153, 86, 145)
	uiScaleSlider.Text = ""
	uiScaleSlider.AutoButtonColor = false
	applyRoundedCorners(uiScaleSlider)

	local uiScaleFill = Instance.new("Frame", uiScaleSlider)
	uiScaleFill.BackgroundColor3 = Color3.fromRGB(255, 229, 73)
	uiScaleFill.Size = UDim2.new(1, 0, 1, 0)
	uiScaleFill.BorderSizePixel = 0
	applyRoundedCorners(uiScaleFill)
end

-- Botões da TopBar
closeButton.MouseButton1Click:Connect(function()
	gui:Destroy()
end)

minimizeButton.MouseButton1Click:Connect(function()
	mainFrame.Visible = false
end)

-- Toggle via tecla RightShift
local UserInputService = game:GetService("UserInputService")

UserInputService.InputBegan:Connect(function(input, gameProcessed)
	if gameProcessed then return end
	if input.KeyCode == Enum.KeyCode.RightShift then
		if gui and gui.Parent then
			mainFrame.Visible = not mainFrame.Visible
		end
	end
end)

-- Sistema de arrastar a janela
local dragging = false
local dragStart, startPos

topBar.InputBegan:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = true
		dragStart = input.Position
		startPos = mainFrame.Position
	end
end)

topBar.InputEnded:Connect(function(input)
	if input.UserInputType == Enum.UserInputType.MouseButton1 then
		dragging = false
	end
end)

UserInputService.InputChanged:Connect(function(input)
	if dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
		local delta = input.Position - dragStart
		mainFrame.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
	end
end)

-- Atualizar botões da sidebar inicialmente
updateTabButtons()