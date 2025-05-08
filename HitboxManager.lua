-- Script para injetar via executor (usando _G)
local player = game:GetService("Players").LocalPlayer

-- Cria/atualiza a tabela global se não existir
_G.HitboxManager = _G.HitboxManager or {
    enabled = true,
    transparency = 0.5,
    size = 24,
    sphere = nil,
    connection = nil
}

-- Função para criar/atualizar a esfera
_G.HitboxManager.updateSphere = function(character)
    -- Remove a esfera existente se houver
    if _G.HitboxManager.sphere then
        _G.HitboxManager.sphere:Destroy()
    end
    if _G.HitboxManager.connection then
        _G.HitboxManager.connection:Disconnect()
    end

    -- Espera pelo HumanoidRootPart
    local hrp = character:WaitForChild("HumanoidRootPart")

    -- Cria nova esfera
    _G.HitboxManager.sphere = Instance.new("Part")
    _G.HitboxManager.sphere.Shape = Enum.PartType.Ball
    _G.HitboxManager.sphere.Anchored = true
    _G.HitboxManager.sphere.CanCollide = false
    _G.HitboxManager.sphere.CastShadow = false
    _G.HitboxManager.sphere.Size = Vector3.new(_G.HitboxManager.size, _G.HitboxManager.size, _G.HitboxManager.size)
    _G.HitboxManager.sphere.Transparency = _G.HitboxManager.enabled and _G.HitboxManager.transparency or 1
    _G.HitboxManager.sphere.Color = Color3.fromRGB(0, 170, 255)
    _G.HitboxManager.sphere.Material = Enum.Material.ForceField
    _G.HitboxManager.sphere.Name = "DetectionSphere"
    _G.HitboxManager.sphere.Parent = workspace

    -- Atualização contínua da posição
    _G.HitboxManager.connection = game:GetService("RunService").RenderStepped:Connect(function()
        if hrp and _G.HitboxManager.sphere then
            _G.HitboxManager.sphere.Position = hrp.Position
        end
    end)

    print("[HitboxManager] Esfera criada com sucesso!")
end

-- Funções de controle
_G.HitboxManager.setTransparency = function(value)
    _G.HitboxManager.transparency = value / 100
    if _G.HitboxManager.sphere then
        _G.HitboxManager.sphere.Transparency = _G.HitboxManager.enabled and _G.HitboxManager.transparency or 1
    end
    print("[HitboxManager] Transparência alterada para:", _G.HitboxManager.transparency)
end

_G.HitboxManager.setSize = function(value)
    _G.HitboxManager.size = 10 + (value * 1.6)
    if _G.HitboxManager.sphere then
        _G.HitboxManager.sphere.Size = Vector3.new(_G.HitboxManager.size, _G.HitboxManager.size, _G.HitboxManager.size)
    end
    print("[HitboxManager] Tamanho alterado para:", _G.HitboxManager.size)
end

_G.HitboxManager.toggle = function(enable)
    _G.HitboxManager.enabled = enable
    if _G.HitboxManager.sphere then
        _G.HitboxManager.sphere.Transparency = enable and _G.HitboxManager.transparency or 1
    end
    print("[HitboxManager] Hitbox", enable and "ativada" or "desativada")
end

-- Inicialização automática
local function init()
    -- Carregar para o personagem atual (se existir)
    if player.Character then
        _G.HitboxManager.updateSphere(player.Character)
    end

    -- Conectar para futuros personagens (respawns)
    player.CharacterAdded:Connect(function(character)
        _G.HitboxManager.updateSphere(character)
    end)
end

-- Configurações iniciais
init()
_G.HitboxManager.setTransparency(30)  -- 30% de transparência
_G.HitboxManager.setSize(12)         -- Tamanho médio (~30 studs)

print("[HitboxManager] Carregado com sucesso!")