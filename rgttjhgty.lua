--[[
    MegolaHub | MM2 Script - PREMIUM VERSION
    GUI: RightShift or On-screen Button
]]

local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Camera = workspace.CurrentCamera
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local Lighting = game:GetService("Lighting")

local SCRIPT_VERSION = "Premium"
local IS_ADMIN = (SCRIPT_VERSION == "Admin")
local IS_PREMIUM = (SCRIPT_VERSION == "Premium") or IS_ADMIN

local MM2_PLACE_ID = 142823291
local MMV_PLACE_ID = 116924926476457
local IS_MM_GAME = (game.PlaceId == MM2_PLACE_ID) or (game.PlaceId == MMV_PLACE_ID)

local function HasAccess(level)
    if level == nil or level == "user" then return true end
    if level == "premium" then return IS_PREMIUM end
    if level == "admin" then return IS_ADMIN end
    return false
end

local Settings = {
    AutoGunLooter = false,
    KillAll = false,
    ChooseMap100 = false,
    SelectedMap = nil,
    PlayerESP = false,
    NameTags = false,
    SeeInvisibles = false,
    Fly = false,
    NoClip = false,
    AimBot = false,
    AimBotFOV = 100,
    AimBotPrediction = 50,
    AimBotOnlyMurderer = false,
    AimBotWallCheck = true,
    LockMouse = false,
    MurderNotification = false,
    SheriffNotification = false,
    Ambience = false,
    AmbienceType = "Day",
    Shaders = false,
    ShaderMode = 1,
    Aura = false,
    AuraType = 1,
    Particles = false,
    FlyKey = nil,
    AimBotKey = nil,
    LockMouseKey = nil,
    NoClipKey = nil,
    OpenMode = "Key",
    GradientColor1 = 7,
    GradientColor2 = 9,
}

local Colors = {
    Background = Color3.fromRGB(20, 20, 22),
    BackgroundTransparency = 0.15,
    Sidebar = Color3.fromRGB(15, 15, 17),
    SidebarTransparency = 0.2,
    CardBackground = Color3.fromRGB(35, 35, 40),
    CardTransparency = 0.1,
    Text = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(160, 160, 170),
    AccentBlue = Color3.fromRGB(90, 130, 255),
    AccentPurple = Color3.fromRGB(160, 90, 255),
    Border = Color3.fromRGB(60, 60, 70),
    SearchBar = Color3.fromRGB(30, 30, 35),
}

local RankName = "Premium"
local RankColor1 = Color3.fromRGB(255, 215, 0)
local RankColor2 = Color3.fromRGB(255, 215, 0)

local ScreenGui = Instance.new("ScreenGui")
ScreenGui.Name = "MegolaHub"
ScreenGui.ResetOnSpawn = false
ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
ScreenGui.IgnoreGuiInset = true
ScreenGui.Parent = game.CoreGui

local NotifContainer = Instance.new("Frame")
NotifContainer.Size = UDim2.new(0, 320, 1, -40)
NotifContainer.Position = UDim2.new(1, -340, 0, 20)
NotifContainer.BackgroundTransparency = 1
NotifContainer.Parent = ScreenGui

local NotifList = Instance.new("UIListLayout")
NotifList.SortOrder = Enum.SortOrder.LayoutOrder
NotifList.VerticalAlignment = Enum.VerticalAlignment.Bottom
NotifList.HorizontalAlignment = Enum.HorizontalAlignment.Right
NotifList.Padding = UDim.new(0, 8)
NotifList.Parent = NotifContainer

local function ShowNotification(title, text, iconColor)
    local notif = Instance.new("Frame")
    notif.Size = UDim2.new(0, 320, 0, 78)
    notif.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    notif.BackgroundTransparency = 0.05
    notif.BorderSizePixel = 0
    notif.Position = UDim2.new(1, 400, 0, 0)
    notif.Parent = NotifContainer
    local nCorner = Instance.new("UICorner")
    nCorner.CornerRadius = UDim.new(0, 12)
    nCorner.Parent = notif
    local nStroke = Instance.new("UIStroke")
    nStroke.Color = iconColor or Color3.fromRGB(90, 130, 255)
    nStroke.Thickness = 1.5
    nStroke.Transparency = 0.4
    nStroke.Parent = notif
    local titleLabel = Instance.new("TextLabel")
    titleLabel.Size = UDim2.new(1, -70, 0, 20)
    titleLabel.Position = UDim2.new(0, 60, 0, 12)
    titleLabel.BackgroundTransparency = 1
    titleLabel.Text = title
    titleLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    titleLabel.Font = Enum.Font.GothamBold
    titleLabel.TextSize = 13
    titleLabel.TextXAlignment = Enum.TextXAlignment.Left
    titleLabel.Parent = notif
    local textLabel = Instance.new("TextLabel")
    textLabel.Size = UDim2.new(1, -70, 0, 22)
    textLabel.Position = UDim2.new(0, 60, 0, 32)
    textLabel.BackgroundTransparency = 1
    textLabel.Text = text
    textLabel.TextColor3 = iconColor or Color3.fromRGB(220, 220, 230)
    textLabel.Font = Enum.Font.GothamSemibold
    textLabel.TextSize = 14
    textLabel.TextXAlignment = Enum.TextXAlignment.Left
    textLabel.Parent = notif
    notif.Position = UDim2.new(1, 400, 0, 0)
    TweenService:Create(notif, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -340, 0, 0),
    }):Play()
    task.delay(4, function()
        if notif and notif.Parent then
            local outTween = TweenService:Create(notif, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                Position = UDim2.new(1, 400, 0, 0),
                BackgroundTransparency = 1,
            })
            outTween:Play()
            outTween.Completed:Connect(function()
                notif:Destroy()
            end)
        end
    end)
end

local MainFrame = Instance.new("Frame")
MainFrame.Size = UDim2.new(0, 700, 0, 450)
MainFrame.Position = UDim2.new(0.5, -350, 0.5, -225)
MainFrame.BackgroundColor3 = Colors.Background
MainFrame.BackgroundTransparency = Colors.BackgroundTransparency
MainFrame.BorderSizePixel = 0
MainFrame.Active = true
MainFrame.Draggable = true
MainFrame.Visible = false
MainFrame.ClipsDescendants = true
MainFrame.Parent = ScreenGui

local MainCorner = Instance.new("UICorner")
MainCorner.CornerRadius = UDim.new(0, 10)
MainCorner.Parent = MainFrame

local MainStroke = Instance.new("UIStroke")
MainStroke.Color = Colors.Border
MainStroke.Thickness = 1
MainStroke.Transparency = 0.5
MainStroke.Parent = MainFrame

local Sidebar = Instance.new("Frame")
Sidebar.Size = UDim2.new(0, 200, 1, 0)
Sidebar.BackgroundColor3 = Colors.Sidebar
Sidebar.BackgroundTransparency = Colors.SidebarTransparency
Sidebar.BorderSizePixel = 0
Sidebar.Parent = MainFrame

local SidebarCorner = Instance.new("UICorner")
SidebarCorner.CornerRadius = UDim.new(0, 10)
SidebarCorner.Parent = Sidebar

local SidebarMask = Instance.new("Frame")
SidebarMask.Size = UDim2.new(0, 10, 1, 0)
SidebarMask.Position = UDim2.new(1, -10, 0, 0)
SidebarMask.BackgroundColor3 = Colors.Sidebar
SidebarMask.BackgroundTransparency = Colors.SidebarTransparency
SidebarMask.BorderSizePixel = 0
SidebarMask.Parent = Sidebar

local HubTitleLabel = Instance.new("TextLabel")
HubTitleLabel.Size = UDim2.new(1, -20, 0, 25)
HubTitleLabel.Position = UDim2.new(0, 10, 0, 8)
HubTitleLabel.BackgroundTransparency = 1
if IS_ADMIN then
    HubTitleLabel.Text = "MegolaHub DEV"
elseif IS_PREMIUM then
    HubTitleLabel.Text = "MegolaHub PREMIUM"
else
    HubTitleLabel.Text = "MegolaHub"
end
HubTitleLabel.TextColor3 = Colors.Text
HubTitleLabel.Font = Enum.Font.GothamBlack
HubTitleLabel.TextSize = 18
HubTitleLabel.TextXAlignment = Enum.TextXAlignment.Left
HubTitleLabel.Parent = Sidebar

local HubTitleGradient = Instance.new("UIGradient")
if IS_ADMIN then
    HubTitleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 80)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 20, 20)),
    })
elseif IS_PREMIUM then
    HubTitleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 215, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 215, 0)),
    })
else
    HubTitleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(160, 160, 170)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 100, 110)),
    })
end
HubTitleGradient.Parent = HubTitleLabel

task.spawn(function()
    while HubTitleLabel.Parent do
        for i = 0, 1, 0.02 do HubTitleGradient.Offset = Vector2.new(i, 0) task.wait(0.03) end
        for i = 1, 0, -0.02 do HubTitleGradient.Offset = Vector2.new(i, 0) task.wait(0.03) end
    end
end)

local ProfileFrame = Instance.new("Frame")
ProfileFrame.Size = UDim2.new(1, -20, 0, 40)
ProfileFrame.Position = UDim2.new(0, 10, 0, 38)
ProfileFrame.BackgroundTransparency = 1
ProfileFrame.Parent = Sidebar

local AvatarFrame = Instance.new("Frame")
AvatarFrame.Size = UDim2.new(0, 35, 0, 35)
AvatarFrame.Position = UDim2.new(0, 0, 0.5, -17.5)
AvatarFrame.BackgroundColor3 = Color3.fromRGB(50, 50, 60)
AvatarFrame.BorderSizePixel = 0
AvatarFrame.Parent = ProfileFrame

local AvatarCorner = Instance.new("UICorner")
AvatarCorner.CornerRadius = UDim.new(1, 0)
AvatarCorner.Parent = AvatarFrame

local AvatarStroke = Instance.new("UIStroke")
AvatarStroke.Color = Colors.AccentBlue
AvatarStroke.Thickness = 2
AvatarStroke.Parent = AvatarFrame

local AvatarImage = Instance.new("ImageLabel")
AvatarImage.Size = UDim2.new(1, -4, 1, -4)
AvatarImage.Position = UDim2.new(0, 2, 0, 2)
AvatarImage.BackgroundTransparency = 1
AvatarImage.Image = ""
AvatarImage.Parent = AvatarFrame

local AvatarImageCorner = Instance.new("UICorner")
AvatarImageCorner.CornerRadius = UDim.new(1, 0)
AvatarImageCorner.Parent = AvatarImage

task.spawn(function()
    local ok, thumb = pcall(function()
        return Players:GetUserThumbnailAsync(LocalPlayer.UserId, Enum.ThumbnailType.HeadShot, Enum.ThumbnailSize.Size100x100)
    end)
    if ok and thumb then AvatarImage.Image = thumb end
end)

local ProfileName = Instance.new("TextLabel")
ProfileName.Size = UDim2.new(1, -80, 1, 0)
ProfileName.Position = UDim2.new(0, 45, 0, 0)
ProfileName.BackgroundTransparency = 1
ProfileName.Text = LocalPlayer.DisplayName or LocalPlayer.Name
ProfileName.TextColor3 = Colors.Text
ProfileName.Font = Enum.Font.GothamBold
ProfileName.TextSize = 13
ProfileName.TextXAlignment = Enum.TextXAlignment.Left
ProfileName.Parent = ProfileFrame

local BadgeFrame = Instance.new("Frame")
BadgeFrame.Size = UDim2.new(0, 55, 0, 18)
BadgeFrame.Position = UDim2.new(1, -60, 0.5, -9)
BadgeFrame.BorderSizePixel = 0
BadgeFrame.Parent = ProfileFrame

local BadgeCorner = Instance.new("UICorner")
BadgeCorner.CornerRadius = UDim.new(0, 4)
BadgeCorner.Parent = BadgeFrame

local BadgeGradient = Instance.new("UIGradient")
if IS_ADMIN then
    BadgeFrame.BackgroundColor3 = Color3.fromRGB(220, 60, 60)
    BadgeGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 80, 80)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 20, 20)),
    })
elseif IS_PREMIUM then
    BadgeFrame.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    BadgeGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 215, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 215, 0)),
    })
else
    BadgeFrame.BackgroundColor3 = Color3.fromRGB(70, 130, 240)
    BadgeGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(160, 160, 170)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 100, 110)),
    })
end
BadgeGradient.Parent = BadgeFrame

local BadgeText = Instance.new("TextLabel")
BadgeText.Size = UDim2.new(1, 0, 1, 0)
BadgeText.BackgroundTransparency = 1
if IS_ADMIN then BadgeText.Text = "DEV"
elseif IS_PREMIUM then BadgeText.Text = "PREMIUM"
else BadgeText.Text = "USER" end
BadgeText.TextColor3 = Color3.fromRGB(255, 255, 255)
BadgeText.Font = Enum.Font.GothamBlack
BadgeText.TextSize = 9
BadgeText.Parent = BadgeFrame

local CategoryContainer = Instance.new("Frame")
CategoryContainer.Size = UDim2.new(1, -20, 1, -190)
CategoryContainer.Position = UDim2.new(0, 10, 0, 88)
CategoryContainer.BackgroundTransparency = 1
CategoryContainer.Parent = Sidebar

local CategoryList = Instance.new("UIListLayout")
CategoryList.SortOrder = Enum.SortOrder.LayoutOrder
CategoryList.Padding = UDim.new(0, 5)
CategoryList.Parent = CategoryContainer

local ExitButton = Instance.new("TextButton")
ExitButton.Size = UDim2.new(1, -20, 0, 35)
ExitButton.Position = UDim2.new(0, 10, 1, -45)
ExitButton.BackgroundColor3 = Color3.fromRGB(40, 40, 48)
ExitButton.BackgroundTransparency = 0.2
ExitButton.BorderSizePixel = 0
ExitButton.Text = "Выйти"
ExitButton.TextColor3 = Colors.Text
ExitButton.Font = Enum.Font.GothamSemibold
ExitButton.TextSize = 13
ExitButton.Parent = Sidebar

local ExitCorner = Instance.new("UICorner")
ExitCorner.CornerRadius = UDim.new(0, 6)
ExitCorner.Parent = ExitButton

local ContentArea = Instance.new("Frame")
ContentArea.Size = UDim2.new(1, -200, 1, 0)
ContentArea.Position = UDim2.new(0, 200, 0, 0)
ContentArea.BackgroundTransparency = 1
ContentArea.Parent = MainFrame

local TopBar = Instance.new("Frame")
TopBar.Size = UDim2.new(1, -20, 0, 40)
TopBar.Position = UDim2.new(0, 10, 0, 15)
TopBar.BackgroundTransparency = 1
TopBar.Parent = ContentArea

local SearchFrame = Instance.new("Frame")
SearchFrame.Size = UDim2.new(1, -45, 1, 0)
SearchFrame.BackgroundColor3 = Colors.SearchBar
SearchFrame.BackgroundTransparency = 0.2
SearchFrame.BorderSizePixel = 0
SearchFrame.Parent = TopBar

local SearchCorner = Instance.new("UICorner")
SearchCorner.CornerRadius = UDim.new(0, 6)
SearchCorner.Parent = SearchFrame

local SearchIcon = Instance.new("TextLabel")
SearchIcon.Size = UDim2.new(0, 30, 1, 0)
SearchIcon.Position = UDim2.new(0, 5, 0, 0)
SearchIcon.BackgroundTransparency = 1
SearchIcon.Text = "Q"
SearchIcon.TextColor3 = Colors.TextDim
SearchIcon.Font = Enum.Font.GothamBold
SearchIcon.TextSize = 14
SearchIcon.Parent = SearchFrame

local SearchBox = Instance.new("TextBox")
SearchBox.Size = UDim2.new(1, -40, 1, 0)
SearchBox.Position = UDim2.new(0, 35, 0, 0)
SearchBox.BackgroundTransparency = 1
SearchBox.Text = ""
SearchBox.PlaceholderText = "Поиск"
SearchBox.PlaceholderColor3 = Colors.TextDim
SearchBox.TextColor3 = Colors.Text
SearchBox.Font = Enum.Font.Gotham
SearchBox.TextSize = 13
SearchBox.TextXAlignment = Enum.TextXAlignment.Left
SearchBox.ClearTextOnFocus = false
SearchBox.Parent = SearchFrame

local CardsScroll = Instance.new("ScrollingFrame")
CardsScroll.Size = UDim2.new(1, -20, 1, -75)
CardsScroll.Position = UDim2.new(0, 10, 0, 65)
CardsScroll.BackgroundTransparency = 1
CardsScroll.BorderSizePixel = 0
CardsScroll.ScrollBarThickness = 4
CardsScroll.ScrollBarImageColor3 = Colors.AccentBlue
CardsScroll.CanvasSize = UDim2.new(0, 0, 0, 0)
CardsScroll.Parent = ContentArea

local CardsGrid = Instance.new("UIGridLayout")
CardsGrid.CellSize = UDim2.new(0, 230, 0, 65)
CardsGrid.CellPadding = UDim2.new(0, 10, 0, 10)
CardsGrid.SortOrder = Enum.SortOrder.LayoutOrder
CardsGrid.Parent = CardsScroll

CardsGrid:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
    CardsScroll.CanvasSize = UDim2.new(0, 0, 0, CardsGrid.AbsoluteContentSize.Y + 10)
end)

-- REMOTES
local PlayerData = {}
local GameplayRemotes, GetCurrentPlayerData, PlayerDataChanged = nil, nil, nil

if IS_MM_GAME then
    local ok, remotes = pcall(function() return ReplicatedStorage:WaitForChild("Remotes", 10) end)
    if ok and remotes then
        local ok2, gameplay = pcall(function() return remotes:WaitForChild("Gameplay", 10) end)
        if ok2 and gameplay then
            GameplayRemotes = gameplay
            GetCurrentPlayerData = gameplay:WaitForChild("GetCurrentPlayerData", 10)
            PlayerDataChanged = gameplay:WaitForChild("PlayerDataChanged", 10)
        end
    end
end

local function GetRoleFromInfo(info)
    if not info then return nil end
    local role = tostring(info.Role or ""):lower()
    if role:find("murder") or role:find("killer") then return "Murderer" end
    if role:find("sheriff") or role:find("police") then return "Sheriff" end
    if role:find("hero") then return "Hero" end
    if role:find("innocent") or role:find("civilian") then return "Innocent" end
    return nil
end

local function UpdatePlayerData(newData)
    if type(newData) ~= "table" then return end
    PlayerData = newData
end

local function FetchPlayerData()
    if not GetCurrentPlayerData then return end
    task.spawn(function()
        local ok, data = pcall(function() return GetCurrentPlayerData:InvokeServer() end)
        if ok and type(data) == "table" then UpdatePlayerData(data) end
    end)
end

if IS_MM_GAME and GetCurrentPlayerData then FetchPlayerData() end

if IS_MM_GAME and PlayerDataChanged then
    PlayerDataChanged.OnClientEvent:Connect(function(newData)
        if type(newData) == "table" then UpdatePlayerData(newData) else FetchPlayerData() end
    end)
end

if IS_MM_GAME and GameplayRemotes then
    for _, remoteName in ipairs({"RoleSelect", "ShowRoleSelect", "ShowRoleSelectNew", "RoundStart"}) do
        local remote = GameplayRemotes:FindFirstChild(remoteName)
        if remote then
            remote.OnClientEvent:Connect(function() task.wait(0.05) FetchPlayerData() end)
        end
    end
    local RoundEndFade = GameplayRemotes:FindFirstChild("RoundEndFade")
    if RoundEndFade then
        RoundEndFade.OnClientEvent:Connect(function() PlayerData = {} end)
    end
end

local function GetPlayerRole(player)
    if not player then return "Lobby" end
    if not IS_MM_GAME then return "Innocent" end
    local info = PlayerData[player.Name]
    if not info or type(info) ~= "table" then return "Lobby" end
    if info.Dead == true then return "Lobby" end
    local role = info.Role
    if not role or role == "" then return "Lobby" end
    return GetRoleFromInfo(info) or "Innocent"
end

local function GetRoleColor(role)
    if not IS_MM_GAME then return Color3.fromRGB(160, 90, 255) end
    if role == "Murderer" then return Color3.fromRGB(230, 40, 40) end
    if role == "Sheriff" then return Color3.fromRGB(40, 120, 255) end
    if role == "Hero" then return Color3.fromRGB(255, 215, 0) end
    if role == "Innocent" then return Color3.fromRGB(0, 220, 40) end
    return Color3.fromRGB(200, 200, 210)
end

local function IsSheriffDead()
    if not IS_MM_GAME then return false end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local info = PlayerData[player.Name]
            if info and type(info) == "table" then
                local role = tostring(info.Role or ""):lower()
                if role:find("sheriff") or role:find("police") then
                    if info.Dead ~= true then return false end
                end
            end
        end
    end
    return true
end

local function PlayerHasGun(player)
    local char = player.Character
    if not char then return false end
    local bp = player:FindFirstChild("Backpack")
    local function check(c)
        if not c then return false end
        for _, t in pairs(c:GetChildren()) do
            if t:IsA("Tool") then
                local n = t.Name:lower()
                if n:find("gun") or n:find("revolver") or n:find("pistol") or n:find("sheriff") then return true end
            end
        end
        return false
    end
    return check(char) or check(bp)
end

local function IsHero(player)
    if not IS_MM_GAME then return false end
    local role = GetPlayerRole(player)
    if role == "Sheriff" or role == "Murderer" then return false end
    if not IsSheriffDead() then return false end
    if not PlayerHasGun(player) then return false end
    return true
end

local InvisibleHighlights = {}

local function IsCharacterInvisible(player)
    local char = player.Character
    if not char then return false end
    local h = char:FindFirstChildOfClass("Humanoid")
    if not h or h.Health <= 0 then return false end
    local total, invis = 0, 0
    for _, part in pairs(char:GetDescendants()) do
        if part:IsA("BasePart") then
            total = total + 1
            if part.Transparency >= 0.9 or part.LocalTransparencyModifier >= 0.9 then invis = invis + 1 end
        end
    end
    return total > 0 and invis / total >= 0.8
end

local function UpdateInvisibleESP()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local invis = IsCharacterInvisible(player)
            local existing = InvisibleHighlights[player]
            if invis then
                if not existing or not existing.Parent then
                    local h = Instance.new("Highlight")
                    h.FillColor = Color3.fromRGB(255,255,255) h.FillTransparency = 0.6
                    h.OutlineColor = Color3.fromRGB(255,255,255) h.OutlineTransparency = 0
                    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
                    h.Adornee = player.Character h.Parent = player.Character
                    InvisibleHighlights[player] = h
                end
            else
                if existing then existing:Destroy() InvisibleHighlights[player] = nil end
            end
        end
    end
end

local function ClearAllInvisibleESP()
    for _, h in pairs(InvisibleHighlights) do if h then h:Destroy() end end
    InvisibleHighlights = {}
end

local ESPHighlights = {}
local NameTagGuis = {}

local function CreateESP(player)
    if ESPHighlights[player] then ESPHighlights[player]:Destroy() ESPHighlights[player] = nil end
    if Settings.SeeInvisibles and IsCharacterInvisible(player) then return end
    local role = GetPlayerRole(player)
    if IS_MM_GAME and role == "Lobby" then return end
    local character = player.Character
    if not character then return end
    local color = GetRoleColor(role)
    if IS_MM_GAME and IsHero(player) then color = GetRoleColor("Hero") end
    local h = Instance.new("Highlight")
    h.FillColor = color h.FillTransparency = 0.7
    h.OutlineColor = color h.OutlineTransparency = 0
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Adornee = character h.Parent = character
    ESPHighlights[player] = h
end

local function ClearAllESP()
    for _, h in pairs(ESPHighlights) do if h then h:Destroy() end end
    ESPHighlights = {}
end

local function CreateNameTag(player)
    if NameTagGuis[player] then NameTagGuis[player]:Destroy() end
    local character = player.Character
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local b = Instance.new("BillboardGui")
    b.Size = UDim2.new(0, 200, 0, 50) b.StudsOffset = Vector3.new(0, 3.5, 0)
    b.AlwaysOnTop = true b.MaxDistance = 300 b.Adornee = root b.Parent = root

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 18) nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name nameLabel.TextColor3 = Color3.fromRGB(255,255,255)
    nameLabel.TextStrokeTransparency = 0 nameLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    nameLabel.Font = Enum.Font.GothamBold nameLabel.TextSize = 14 nameLabel.Parent = b

    local role = GetPlayerRole(player)
    local roleColor = GetRoleColor(role)
    local roleText = role
    if IS_MM_GAME and IsHero(player) then roleText = "Hero" roleColor = GetRoleColor("Hero") end

    local roleLabel = Instance.new("TextLabel")
    roleLabel.Name = "RoleLabel" roleLabel.Size = UDim2.new(1, 0, 0, 14)
    roleLabel.Position = UDim2.new(0, 0, 0, 17) roleLabel.BackgroundTransparency = 1
    roleLabel.Text = roleText roleLabel.TextColor3 = roleColor
    roleLabel.TextStrokeTransparency = 0 roleLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    roleLabel.Font = Enum.Font.GothamSemibold roleLabel.TextSize = 12 roleLabel.Parent = b

    local invisLabel = Instance.new("TextLabel")
    invisLabel.Name = "InvisLabel" invisLabel.Size = UDim2.new(1, 0, 0, 14)
    invisLabel.Position = UDim2.new(0, 0, 0, 31) invisLabel.BackgroundTransparency = 1
    invisLabel.Text = "Invisible" invisLabel.TextColor3 = Color3.fromRGB(255,255,255)
    invisLabel.TextStrokeTransparency = 0 invisLabel.TextStrokeColor3 = Color3.fromRGB(0,0,0)
    invisLabel.Font = Enum.Font.GothamBold invisLabel.TextSize = 12 invisLabel.Visible = false invisLabel.Parent = b

    NameTagGuis[player] = b
end

local function ClearAllNameTags()
    for _, g in pairs(NameTagGuis) do if g then g:Destroy() end end
    NameTagGuis = {}
end

local function UpdateAllVisuals()
    ClearAllESP() ClearAllNameTags()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if Settings.PlayerESP then CreateESP(player) end
            if Settings.NameTags then CreateNameTag(player) end
        end
    end
end

local lastRoleCheck = 0
RunService.Heartbeat:Connect(function()
    if not Settings.PlayerESP and not Settings.NameTags and not Settings.SeeInvisibles then return end
    local now = tick()
    if now - lastRoleCheck < 0.1 then return end
    lastRoleCheck = now
    if Settings.SeeInvisibles then UpdateInvisibleESP() end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local role = GetPlayerRole(player)
            local hero = IS_MM_GAME and IsHero(player)
            local invisible = Settings.SeeInvisibles and IsCharacterInvisible(player)
            if Settings.PlayerESP then
                local existing = ESPHighlights[player]
                if (IS_MM_GAME and role == "Lobby") and not invisible then
                    if existing then existing:Destroy() ESPHighlights[player] = nil end
                elseif invisible then
                    if existing then existing:Destroy() ESPHighlights[player] = nil end
                else
                    local color = hero and GetRoleColor("Hero") or GetRoleColor(role)
                    if existing then
                        if existing.FillColor ~= color then existing.FillColor = color existing.OutlineColor = color end
                    else CreateESP(player) end
                end
            end
            if Settings.NameTags then
                local gui = NameTagGuis[player]
                if not gui or not gui.Parent then CreateNameTag(player) gui = NameTagGuis[player] end
                if gui then
                    local roleLabel = gui:FindFirstChild("RoleLabel")
                    local invisLabel = gui:FindFirstChild("InvisLabel")
                    if roleLabel then
                        local roleText = hero and "Hero" or role
                        local roleColor = hero and GetRoleColor("Hero") or GetRoleColor(role)
                        if roleLabel.Text ~= roleText then roleLabel.Text = roleText end
                        if roleLabel.TextColor3 ~= roleColor then roleLabel.TextColor3 = roleColor end
                    end
                    if invisLabel then invisLabel.Visible = invisible end
                end
            end
        end
    end
end)

local function OnCharacterAdded(player, character)
    task.wait(0.2)
    if player ~= LocalPlayer then
        if Settings.PlayerESP then CreateESP(player) end
        if Settings.NameTags then CreateNameTag(player) end
    end
end

for _, player in pairs(Players:GetPlayers()) do
    player.CharacterAdded:Connect(function(c) OnCharacterAdded(player, c) end)
end
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function(c) OnCharacterAdded(player, c) end)
end)

-- SKYBOXES
local Skyboxes = {
    Day = {SkyboxBk="rbxassetid://159454299",SkyboxDn="rbxassetid://159454296",SkyboxFt="rbxassetid://159454293",SkyboxLf="rbxassetid://159454286",SkyboxRt="rbxassetid://159454300",SkyboxUp="rbxassetid://159454288",Brightness=2,ClockTime=14,Ambient=Color3.fromRGB(130,130,130),OutdoorAmbient=Color3.fromRGB(128,128,128),FogEnd=100000,FogColor=Color3.fromRGB(200,200,200)},
    Night = {SkyboxBk="rbxassetid://12064107",SkyboxDn="rbxassetid://12064152",SkyboxFt="rbxassetid://12064121",SkyboxLf="rbxassetid://12063984",SkyboxRt="rbxassetid://12064115",SkyboxUp="rbxassetid://12064130",Brightness=1,ClockTime=0,Ambient=Color3.fromRGB(30,30,50),OutdoorAmbient=Color3.fromRGB(25,25,40),FogEnd=500,FogColor=Color3.fromRGB(20,20,40)},
    Evening = {SkyboxBk="rbxassetid://271042516",SkyboxDn="rbxassetid://271077243",SkyboxFt="rbxassetid://271042556",SkyboxLf="rbxassetid://271042310",SkyboxRt="rbxassetid://271042467",SkyboxUp="rbxassetid://271077958",Brightness=1.5,ClockTime=18,Ambient=Color3.fromRGB(100,80,80),OutdoorAmbient=Color3.fromRGB(90,70,70),FogEnd=1000,FogColor=Color3.fromRGB(150,100,80)},
    Sunset = {SkyboxBk="rbxassetid://105092364",SkyboxDn="rbxassetid://105092385",SkyboxFt="rbxassetid://105092306",SkyboxLf="rbxassetid://105092413",SkyboxRt="rbxassetid://105092351",SkyboxUp="rbxassetid://105092442",Brightness=2,ClockTime=17,Ambient=Color3.fromRGB(180,120,80),OutdoorAmbient=Color3.fromRGB(160,100,60),FogEnd=2000,FogColor=Color3.fromRGB(255,140,80)},
    Anime = {SkyboxBk="rbxassetid://6444884337",SkyboxDn="rbxassetid://6444884951",SkyboxFt="rbxassetid://6444884415",SkyboxLf="rbxassetid://6444883914",SkyboxRt="rbxassetid://6444883684",SkyboxUp="rbxassetid://6444885256",Brightness=3,ClockTime=12,Ambient=Color3.fromRGB(200,200,255),OutdoorAmbient=Color3.fromRGB(180,180,255),FogEnd=5000,FogColor=Color3.fromRGB(220,220,255)},
}

local CurrentSky, SavedLighting = nil, nil

local function SaveLighting()
    if SavedLighting then return end
    SavedLighting = {Brightness=Lighting.Brightness,ClockTime=Lighting.ClockTime,Ambient=Lighting.Ambient,OutdoorAmbient=Lighting.OutdoorAmbient,FogEnd=Lighting.FogEnd,FogColor=Lighting.FogColor,EnvironmentDiffuseScale=Lighting.EnvironmentDiffuseScale,EnvironmentSpecularScale=Lighting.EnvironmentSpecularScale}
end

local function ApplySkybox(name)
    local d = Skyboxes[name]
    if not d then return end
    SaveLighting()
    if CurrentSky then CurrentSky:Destroy() end
    CurrentSky = Instance.new("Sky")
    CurrentSky.SkyboxBk = d.SkyboxBk CurrentSky.SkyboxDn = d.SkyboxDn CurrentSky.SkyboxFt = d.SkyboxFt
    CurrentSky.SkyboxLf = d.SkyboxLf CurrentSky.SkyboxRt = d.SkyboxRt CurrentSky.SkyboxUp = d.SkyboxUp
    CurrentSky.Parent = Lighting
    Lighting.Brightness = d.Brightness Lighting.ClockTime = d.ClockTime
    Lighting.Ambient = d.Ambient Lighting.OutdoorAmbient = d.OutdoorAmbient
    Lighting.FogEnd = d.FogEnd Lighting.FogColor = d.FogColor
end

local function RemoveSkybox()
    if CurrentSky then CurrentSky:Destroy() CurrentSky = nil end
    if SavedLighting then
        Lighting.Brightness = SavedLighting.Brightness
        Lighting.ClockTime = SavedLighting.ClockTime
        Lighting.Ambient = SavedLighting.Ambient
        Lighting.OutdoorAmbient = SavedLighting.OutdoorAmbient
        Lighting.FogEnd = SavedLighting.FogEnd
        Lighting.FogColor = SavedLighting.FogColor
        Lighting.EnvironmentDiffuseScale = SavedLighting.EnvironmentDiffuseScale or 1
        Lighting.EnvironmentSpecularScale = SavedLighting.EnvironmentSpecularScale or 1
        SavedLighting = nil
    end
end

-- SHADERS
local ShaderDOF = Instance.new("DepthOfFieldEffect")
ShaderDOF.FocusDistance = 5 ShaderDOF.InFocusRadius = 20 ShaderDOF.NearIntensity = 0 ShaderDOF.FarIntensity = 0
ShaderDOF.Parent = Lighting
local UltraBloom = Instance.new("BloomEffect")
UltraBloom.Intensity = 0 UltraBloom.Size = 24 UltraBloom.Threshold = 0.9 UltraBloom.Parent = Lighting
local UltraCC = Instance.new("ColorCorrectionEffect")
UltraCC.Brightness = 0 UltraCC.Contrast = 0 UltraCC.Saturation = 0 UltraCC.TintColor = Color3.fromRGB(255,255,255)
UltraCC.Parent = Lighting
local UltraSun = Instance.new("SunRaysEffect")
UltraSun.Intensity = 0 UltraSun.Spread = 1 UltraSun.Parent = Lighting
local UltraAtmo = Instance.new("Atmosphere")
UltraAtmo.Density = 0 UltraAtmo.Offset = 0 UltraAtmo.Color = Color3.fromRGB(199,199,199)
UltraAtmo.Decay = Color3.fromRGB(106,112,125) UltraAtmo.Glare = 0 UltraAtmo.Haze = 0 UltraAtmo.Parent = Lighting

local function ApplyBlurShader(enabled)
    if enabled then
        TweenService:Create(ShaderDOF, TweenInfo.new(0.4), {FarIntensity = 1}):Play()
        TweenService:Create(UltraBloom, TweenInfo.new(0.4), {Intensity = 0}):Play()
        TweenService:Create(UltraCC, TweenInfo.new(0.4), {Saturation = 0, Contrast = 0, Brightness = 0}):Play()
        TweenService:Create(UltraSun, TweenInfo.new(0.4), {Intensity = 0}):Play()
        TweenService:Create(UltraAtmo, TweenInfo.new(0.4), {Density = 0, Haze = 0}):Play()
    else TweenService:Create(ShaderDOF, TweenInfo.new(0.4), {FarIntensity = 0}):Play() end
end

local function ApplyUltraRealismShader(enabled)
    if enabled then
        ShaderDOF.FocusDistance = 12 ShaderDOF.InFocusRadius = 40 ShaderDOF.NearIntensity = 0.15
        TweenService:Create(ShaderDOF, TweenInfo.new(0.6), {FarIntensity = 0.7}):Play()
        TweenService:Create(UltraBloom, TweenInfo.new(0.6), {Intensity = 0.6, Size = 28, Threshold = 0.85}):Play()
        TweenService:Create(UltraCC, TweenInfo.new(0.6), {Brightness = 0.05, Contrast = 0.15, Saturation = 0.25, TintColor = Color3.fromRGB(255,250,245)}):Play()
        TweenService:Create(UltraSun, TweenInfo.new(0.6), {Intensity = 0.12, Spread = 0.9}):Play()
        TweenService:Create(UltraAtmo, TweenInfo.new(0.6), {Density = 0.35, Haze = 1.5, Glare = 0.15, Color = Color3.fromRGB(190,195,205), Decay = Color3.fromRGB(115,120,135)}):Play()
    else
        TweenService:Create(ShaderDOF, TweenInfo.new(0.6), {FarIntensity = 0, NearIntensity = 0}):Play()
        TweenService:Create(UltraBloom, TweenInfo.new(0.6), {Intensity = 0}):Play()
        TweenService:Create(UltraCC, TweenInfo.new(0.6), {Brightness = 0, Contrast = 0, Saturation = 0, TintColor = Color3.fromRGB(255,255,255)}):Play()
        TweenService:Create(UltraSun, TweenInfo.new(0.6), {Intensity = 0}):Play()
        TweenService:Create(UltraAtmo, TweenInfo.new(0.6), {Density = 0, Haze = 0, Glare = 0}):Play()
    end
end

local ShaderModeName = "None"

local function SetShaderMode(mode)
    if ShaderModeName == mode then return end
    ShaderModeName = mode
    if mode == "None" then ApplyBlurShader(false) ApplyUltraRealismShader(false)
    elseif mode == "Blur" then ApplyUltraRealismShader(false) ApplyBlurShader(true)
    elseif mode == "Ultra" then ApplyBlurShader(false) ApplyUltraRealismShader(true) end
end

local function ToggleShaders(enabled)
    Settings.Shaders = enabled
    if enabled then
        if ShaderModeName == "None" then SetShaderMode("Blur") else SetShaderMode(ShaderModeName) end
    else SetShaderMode("None") end
end

local function SetShaderModeByNumber(num)
    if not Settings.Shaders then return end
    if num == 1 then SetShaderMode("Blur")
    elseif num == 2 then SetShaderMode("Ultra") end
end

-- AURA (сокращённо, как в user)
local AuraParts = {}
local AuraConnection, AuraLoopConnection = nil, nil
local AuraTypes = {[1]={Mode="Fire"},[2]={Mode="Ice"},[3]={Mode="Lightning"}}

local function ClearAura()
    for _, p in pairs(AuraParts) do if p and p.Parent then p:Destroy() end end
    AuraParts = {}
    if AuraLoopConnection then AuraLoopConnection:Disconnect() AuraLoopConnection = nil end
end

local function ApplyFireAura(char)
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local att = Instance.new("Attachment") att.Position = Vector3.new(0,-2,0) att.Parent = root
    table.insert(AuraParts, att)
    local em = Instance.new("ParticleEmitter")
    em.Texture = "rbxassetid://243660364"
    em.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(255,200,50)),ColorSequenceKeypoint.new(0.5,Color3.fromRGB(255,100,20)),ColorSequenceKeypoint.new(1,Color3.fromRGB(150,20,0))})
    em.Size = NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.5,2),NumberSequenceKeypoint.new(1,0)})
    em.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.2,0.3),NumberSequenceKeypoint.new(1,1)})
    em.Lifetime = NumberRange.new(0.8,1.3) em.Rate = 60 em.Speed = NumberRange.new(4,8)
    em.SpreadAngle = Vector2.new(30,30) em.Rotation = NumberRange.new(0,360) em.RotSpeed = NumberRange.new(-30,30)
    em.LightEmission = 1 em.LightInfluence = 0 em.Acceleration = Vector3.new(0,8,0)
    em.Parent = att table.insert(AuraParts, em)
    local l = Instance.new("PointLight") l.Color = Color3.fromRGB(255,120,30) l.Range = 12 l.Brightness = 2 l.Parent = root
    table.insert(AuraParts, l)
end

local function ApplyIceAura(char)
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local orbCount = 8 local iceParts = {}
    for i = 1, orbCount do
        local c = Instance.new("Part")
        c.Size = Vector3.new(0.4,1.2,0.4) c.Material = Enum.Material.Glass c.Color = Color3.fromRGB(150,220,255)
        c.Transparency = 0.3 c.Anchored = true c.CanCollide = false c.CanQuery = false c.CanTouch = false c.CastShadow = false
        c.Parent = workspace
        table.insert(AuraParts, c) table.insert(iceParts, c)
    end
    local t = tick()
    AuraLoopConnection = RunService.Heartbeat:Connect(function()
        if not Settings.Aura or Settings.AuraType ~= 2 then return end
        local ch = LocalPlayer.Character
        if not ch or not ch:FindFirstChild("HumanoidRootPart") then return end
        local rp = ch.HumanoidRootPart local e = tick() - t
        for i, c in ipairs(iceParts) do
            if c and c.Parent then
                local a = e*1.5 + (i/orbCount)*math.pi*2
                c.CFrame = CFrame.new(rp.Position + Vector3.new(math.cos(a)*4, math.sin(e*2+i)*1.5, math.sin(a)*4)) * CFrame.Angles(e*2, e*3, e*2)
            end
        end
    end)
    local att = Instance.new("Attachment") att.Parent = root table.insert(AuraParts, att)
    local em = Instance.new("ParticleEmitter")
    em.Texture = "rbxassetid://243660364"
    em.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(200,240,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(100,180,255))})
    em.Size = NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(0.5,1.5),NumberSequenceKeypoint.new(1,0)})
    em.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.3,0.4),NumberSequenceKeypoint.new(1,1)})
    em.Lifetime = NumberRange.new(1,1.8) em.Rate = 30 em.Speed = NumberRange.new(1,3)
    em.SpreadAngle = Vector2.new(180,180) em.Rotation = NumberRange.new(0,360) em.RotSpeed = NumberRange.new(-60,60)
    em.LightEmission = 1 em.LightInfluence = 0
    em.Parent = att table.insert(AuraParts, em)
    local l = Instance.new("PointLight") l.Color = Color3.fromRGB(150,220,255) l.Range = 14 l.Brightness = 2 l.Parent = root
    table.insert(AuraParts, l)
end

local function ApplyLightningAura(char)
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    AuraLoopConnection = RunService.Heartbeat:Connect(function()
        if not Settings.Aura or Settings.AuraType ~= 3 then return end
        local ch = LocalPlayer.Character
        if not ch or not ch:FindFirstChild("HumanoidRootPart") then return end
        local rp = ch.HumanoidRootPart
        if math.random() < 0.3 then
            local b = Instance.new("Part")
            b.Size = Vector3.new(0.3,0.3,math.random(3,8)) b.Material = Enum.Material.Neon
            b.Color = Color3.fromRGB(150,200,255) b.Transparency = 0.3 b.Anchored = true
            b.CanCollide = false b.CanQuery = false b.CanTouch = false b.CastShadow = false b.Parent = workspace
            local l = Instance.new("PointLight") l.Color = Color3.fromRGB(150,200,255) l.Range = 8 l.Brightness = 3 l.Parent = b
            local a = math.random()*math.pi*2 local d = math.random(20,50)/10
            b.CFrame = CFrame.new(rp.Position + Vector3.new(math.cos(a)*d, math.random(-2,4), math.sin(a)*d)) * CFrame.Angles(math.random()*math.pi*2,math.random()*math.pi*2,math.random()*math.pi*2)
            task.spawn(function()
                for i = 1, 3 do
                    if b and b.Parent then b.Transparency = 0.8 task.wait(0.03) b.Transparency = 0.2 task.wait(0.03) end
                end
                if b then
                    TweenService:Create(b, TweenInfo.new(0.2), {Transparency = 1}):Play()
                    task.wait(0.2)
                    if b and b.Parent then b:Destroy() end
                end
            end)
        end
    end)
    local att = Instance.new("Attachment") att.Parent = root table.insert(AuraParts, att)
    local em = Instance.new("ParticleEmitter")
    em.Texture = "rbxassetid://243660364"
    em.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,Color3.fromRGB(200,220,255)),ColorSequenceKeypoint.new(1,Color3.fromRGB(100,150,255))})
    em.Size = NumberSequence.new({NumberSequenceKeypoint.new(0,0),NumberSequenceKeypoint.new(0.5,1.2),NumberSequenceKeypoint.new(1,0)})
    em.Transparency = NumberSequence.new({NumberSequenceKeypoint.new(0,1),NumberSequenceKeypoint.new(0.3,0.3),NumberSequenceKeypoint.new(1,1)})
    em.Lifetime = NumberRange.new(0.5,1) em.Rate = 40 em.Speed = NumberRange.new(3,8)
    em.SpreadAngle = Vector2.new(180,180) em.Rotation = NumberRange.new(0,360) em.RotSpeed = NumberRange.new(-180,180)
    em.LightEmission = 1 em.LightInfluence = 0
    em.Parent = att table.insert(AuraParts, em)
    local l = Instance.new("PointLight") l.Color = Color3.fromRGB(150,200,255) l.Range = 14 l.Brightness = 2.5 l.Parent = root
    table.insert(AuraParts, l)
end

local function ApplyAura()
    ClearAura()
    local char = LocalPlayer.Character
    if not char then return end
    local d = AuraTypes[Settings.AuraType] or AuraTypes[1]
    if d.Mode == "Fire" then ApplyFireAura(char)
    elseif d.Mode == "Ice" then ApplyIceAura(char)
    elseif d.Mode == "Lightning" then ApplyLightningAura(char) end
end

local function ToggleAura(enabled)
    Settings.Aura = enabled
    if enabled then
        ApplyAura()
        if AuraConnection then AuraConnection:Disconnect() end
        AuraConnection = LocalPlayer.CharacterAdded:Connect(function()
            task.wait(0.5)
            if Settings.Aura then ApplyAura() end
        end)
    else
        if AuraConnection then AuraConnection:Disconnect() AuraConnection = nil end
        ClearAura()
    end
end

local function RefreshAura()
    if Settings.Aura then ApplyAura() end
end

-- PARTICLES
local ParticleParts = {}
local ParticleConnection = nil
local PARTICLE_COUNT = 60

local function CreateSnowflake()
    local p = Instance.new("Part")
    p.Size = Vector3.new(0.25,0.25,0.25) p.Shape = Enum.PartType.Ball p.Material = Enum.Material.Neon
    p.Color = Color3.fromRGB(220,240,255) p.Transparency = 0.2 p.Anchored = true
    p.CanCollide = false p.CanQuery = false p.CanTouch = false p.CastShadow = false p.Locked = true
    p.Parent = workspace
    local l = Instance.new("PointLight") l.Color = Color3.fromRGB(220,240,255) l.Range = 3 l.Brightness = 1 l.Parent = p
    return p
end

local function GetRandomParticlePosition()
    local char = LocalPlayer.Character
    local cp = Vector3.new(0,50,0)
    if char and char:FindFirstChild("HumanoidRootPart") then cp = char.HumanoidRootPart.Position end
    local a = math.random()*math.pi*2 local d = math.random(150,600)/10
    return cp + Vector3.new(math.cos(a)*d, math.random(-40,40), math.sin(a)*d)
end

local function ClearParticles()
    for _, p in pairs(ParticleParts) do if p and p.Parent then p:Destroy() end end
    ParticleParts = {}
    if ParticleConnection then ParticleConnection:Disconnect() ParticleConnection = nil end
end

local function SpawnParticles()
    ClearParticles()
    for i = 1, PARTICLE_COUNT do
        local s = CreateSnowflake() s.Position = GetRandomParticlePosition()
        table.insert(ParticleParts, s)
    end
end

local function StartParticleAnimation()
    if ParticleConnection then ParticleConnection:Disconnect() ParticleConnection = nil end
    local pd = {}
    for i, p in ipairs(ParticleParts) do
        pd[p] = {basePos=p.Position,phaseX=math.random()*math.pi*2,phaseY=math.random()*math.pi*2,phaseZ=math.random()*math.pi*2,speedX=math.random(5,15)/10,speedY=math.random(8,20)/10,speedZ=math.random(5,15)/10,ampX=math.random(15,40)/10,ampY=math.random(20,50)/10,ampZ=math.random(15,40)/10,rotSpeed=math.random(-30,30)/10}
    end
    local t = tick()
    ParticleConnection = RunService.Heartbeat:Connect(function()
        if not Settings.Particles then return end
        local e = tick() - t
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local pp = char.HumanoidRootPart.Position
        for i, p in ipairs(ParticleParts) do
            if not p or not p.Parent then continue end
            local d = pd[p]
            if not d then continue end
            local ox = math.sin(e*d.speedX+d.phaseX)*d.ampX
            local oy = math.cos(e*d.speedY+d.phaseY)*d.ampY
            local oz = math.sin(e*d.speedZ+d.phaseZ)*d.ampZ
            local tp = d.basePos + Vector3.new(ox,oy,oz)
            if (tp-pp).Magnitude > 120 then
                d.basePos = GetRandomParticlePosition()
                d.phaseX = math.random()*math.pi*2 d.phaseY = math.random()*math.pi*2 d.phaseZ = math.random()*math.pi*2
                tp = d.basePos
            end
            p.Position = tp
            p.CFrame = CFrame.new(p.Position) * CFrame.Angles(e*d.rotSpeed, e*d.rotSpeed*0.7, e*d.rotSpeed*0.5)
            local l = p:FindFirstChildOfClass("PointLight")
            if l then l.Brightness = 0.8 + math.sin(e*2+d.phaseX)*0.4 end
        end
    end)
end

local function ToggleParticles(enabled)
    Settings.Particles = enabled
    if enabled then SpawnParticles() StartParticleAnimation() else ClearParticles() end
end

-- AUTO GUN LOOTER
local GunLooterConnection = nil
local LastLootTime = 0
local LOOT_COOLDOWN = 0.15
local CachedGunDrops = {}
local LastCacheUpdate = 0
local CACHE_UPDATE_INTERVAL = 0.5

local function IsGunDrop(obj)
    if not obj then return false end
    if not (obj:IsA("Model") or obj:IsA("BasePart") or obj:IsA("Tool")) then return false end
    local n = obj.Name:lower()
    return n == "gundrop" or n:find("gundrop") or n == "knifedrop" or n:find("knifedrop") or n == "droppedgun"
end

local function IsMineOrInHands(obj, myChar)
    if myChar and obj:IsDescendantOf(myChar) then return true end
    for _, plr in pairs(Players:GetPlayers()) do
        if plr.Character and obj:IsDescendantOf(plr.Character) then return true end
        local bp = plr:FindFirstChild("Backpack")
        if bp and obj:IsDescendantOf(bp) then return true end
    end
    return false
end

local function UpdateGunDropCache()
    local myChar = LocalPlayer.Character
    local newCache, seen = {}, {}
    for _, obj in pairs(workspace:GetChildren()) do
        if IsGunDrop(obj) and not seen[obj] then
            seen[obj] = true
            if not IsMineOrInHands(obj, myChar) then table.insert(newCache, obj) end
        end
    end
    local foldersToCheck = {"DroppedItems","Items","Drops","Weapons","Objects","Map","ItemsFolder","ToolDrops"}
    for _, fn in ipairs(foldersToCheck) do
        local folder = workspace:FindFirstChild(fn)
        if folder then
            for _, obj in pairs(folder:GetDescendants()) do
                if IsGunDrop(obj) and not seen[obj] then
                    seen[obj] = true
                    if not IsMineOrInHands(obj, myChar) then table.insert(newCache, obj) end
                end
            end
        end
    end
    CachedGunDrops = newCache
    LastCacheUpdate = tick()
end

local function TeleportGunToMe(gunDrop, myRoot)
    if not gunDrop or not myRoot then return false end
    local target = CFrame.new(myRoot.Position + Vector3.new(0,-2.5,0))
    if gunDrop:IsA("Model") then
        for _, part in pairs(gunDrop:GetDescendants()) do
            if part:IsA("BasePart") then
                if part.Anchored then pcall(function() part.Anchored = false end) end
            end
        end
        pcall(function() gunDrop:PivotTo(target) end)
    elseif gunDrop:IsA("BasePart") then
        if gunDrop.Anchored then pcall(function() gunDrop.Anchored = false end) end
        pcall(function() gunDrop.CFrame = target gunDrop.Velocity = Vector3.zero end)
    end
end

local function FindNearestGunFromCache()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = char.HumanoidRootPart.Position
    local nearest, nearestDist = nil, math.huge
    for _, obj in ipairs(CachedGunDrops) do
        if obj and obj.Parent then
            local pos
            if obj:IsA("Model") then
                local primary = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                if primary then pos = primary.Position end
            elseif obj:IsA("BasePart") then pos = obj.Position end
            if pos then
                local dist = (pos-myPos).Magnitude
                if dist < nearestDist then nearestDist = dist nearest = obj end
            end
        end
    end
    return nearest
end

local function ToggleAutoGunLooter(enabled)
    if not IS_MM_GAME then return end
    Settings.AutoGunLooter = enabled
    if enabled then
        UpdateGunDropCache()
        GunLooterConnection = RunService.Heartbeat:Connect(function()
            if not Settings.AutoGunLooter then return end
            local now = tick()
            if now - LastLootTime < LOOT_COOLDOWN then return end
            local char = LocalPlayer.Character
            if not char then return end
            if char:FindFirstChildOfClass("Tool") then return end
            local myRoot = char:FindFirstChild("HumanoidRootPart")
            if not myRoot then return end
            if now - LastCacheUpdate > CACHE_UPDATE_INTERVAL then UpdateGunDropCache() end
            local gun = FindNearestGunFromCache()
            if gun then
                LastLootTime = now
                TeleportGunToMe(gun, myRoot)
            end
        end)
    else
        if GunLooterConnection then GunLooterConnection:Disconnect() GunLooterConnection = nil end
        CachedGunDrops = {}
    end
end

-- KILL ALL (заблокировано)
-- CHOOSE MAP (заблокировано)

local function ToggleKillAll() end
local function Toggle100ChooseMap() end

-- FLY / NOCLIP / LOCK MOUSE / AIMBOT
local FlyBV, FlyBG, FlyConnection = nil, nil, nil
local function ToggleFly(enabled)
    Settings.Fly = enabled
    local char = LocalPlayer.Character
    if not char then return end
    local humanoid = char:FindFirstChild("Humanoid")
    local root = char:FindFirstChild("HumanoidRootPart")
    if not humanoid or not root then return end
    if enabled then
        humanoid.PlatformStand = true
        humanoid:ChangeState(Enum.HumanoidStateType.Physics)
        FlyBV = Instance.new("BodyVelocity")
        FlyBV.MaxForce = Vector3.new(1e5,1e5,1e5) FlyBV.P = 1250 FlyBV.Velocity = Vector3.zero FlyBV.Parent = root
        FlyBG = Instance.new("BodyGyro")
        FlyBG.MaxTorque = Vector3.new(1e6,1e6,1e6) FlyBG.P = 3000 FlyBG.D = 500 FlyBG.CFrame = root.CFrame FlyBG.Parent = root
        FlyConnection = RunService.RenderStepped:Connect(function()
            if not Settings.Fly or not root or not root.Parent or not FlyBV or not FlyBG then return end
            local v = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then v += Vector3.new(0,50,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then v += Vector3.new(0,-50,0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then v += Camera.CFrame.LookVector*50 end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then v -= Camera.CFrame.LookVector*50 end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then v -= Camera.CFrame.RightVector*50 end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then v += Camera.CFrame.RightVector*50 end
            FlyBV.Velocity = v
            local ld = Camera.CFrame.LookVector
            local fl = Vector3.new(ld.X,0,ld.Z)
            if fl.Magnitude > 0.01 then FlyBG.CFrame = CFrame.lookAt(root.Position, root.Position+fl.Unit) end
            root.AssemblyAngularVelocity = Vector3.zero root.RotVelocity = Vector3.zero
        end)
    else
        if FlyConnection then FlyConnection:Disconnect() FlyConnection = nil end
        if FlyBV then FlyBV:Destroy() FlyBV = nil end
        if FlyBG then FlyBG:Destroy() FlyBG = nil end
        if humanoid then humanoid.PlatformStand = false humanoid:ChangeState(Enum.HumanoidStateType.GettingUp) end
    end
end

local NoClipConnection = nil
local function ToggleNoClip(enabled)
    Settings.NoClip = enabled
    if enabled then
        NoClipConnection = RunService.Stepped:Connect(function()
            if not Settings.NoClip then return end
            local char = LocalPlayer.Character
            if not char then return end
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") and part.CanCollide then part.CanCollide = false end
            end
        end)
    else
        if NoClipConnection then NoClipConnection:Disconnect() NoClipConnection = nil end
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then part.CanCollide = true end
            end
        end
    end
end

local function ToggleLockMouse(enabled)
    Settings.LockMouse = enabled
    UserInputService.MouseBehavior = enabled and Enum.MouseBehavior.LockCenter or Enum.MouseBehavior.Default
end

local AimBotConnection
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2 FOVCircle.Radius = 100 FOVCircle.Color = Color3.fromRGB(150,100,255)
FOVCircle.Transparency = 0.8 FOVCircle.Visible = false FOVCircle.Filled = false

local function ToggleAimBot(enabled)
    Settings.AimBot = enabled
    FOVCircle.Visible = enabled
    FOVCircle.Radius = Settings.AimBotFOV
    if enabled then
        AimBotConnection = RunService.RenderStepped:Connect(function()
            if not Settings.AimBot then return end
            local target, closest = nil, Settings.AimBotFOV
            for _, player in pairs(Players:GetPlayers()) do
                if player ~= LocalPlayer and player.Character then
                    local h = player.Character:FindFirstChildOfClass("Humanoid")
                    local rp = player.Character:FindFirstChild("HumanoidRootPart")
                    if h and rp and h.Health > 0 then
                        local skip = false
                        if IS_MM_GAME and Settings.AimBotOnlyMurderer then
                            if GetPlayerRole(player) ~= "Murderer" then skip = true end
                        end
                        if not skip then
                            local sp, onScreen = Camera:WorldToScreenPoint(rp.Position)
                            if onScreen then
                                local d = (Vector2.new(sp.X,sp.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                                if d < closest then closest = d target = rp end
                            end
                        end
                    end
                end
            end
            if target then
                local pred = target.Velocity * (Settings.AimBotPrediction/100)
                Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, target.Position + pred)
            end
        end)
    else
        if AimBotConnection then AimBotConnection:Disconnect() AimBotConnection = nil end
    end
end

RunService.RenderStepped:Connect(function()
    if FOVCircle.Visible then FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2) end
end)

-- CARD SYSTEM
local AllCards = {}

local function ApplyLockOverlay(card)
    local o = Instance.new("Frame")
    o.Size = UDim2.new(1,0,1,0) o.BackgroundColor3 = Color3.fromRGB(0,0,0) o.BackgroundTransparency = 0.5
    o.BorderSizePixel = 0 o.ZIndex = 5 o.Parent = card
    local oc = Instance.new("UICorner") oc.CornerRadius = UDim.new(0,8) oc.Parent = o
    local b = Instance.new("Frame")
    b.Size = UDim2.new(1,0,0,26) b.Position = UDim2.new(0,0,0.5,-13)
    b.BackgroundColor3 = Color3.fromRGB(200,30,30) b.BackgroundTransparency = 0.1 b.BorderSizePixel = 0 b.ZIndex = 6 b.Parent = card
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1,0,1,0) t.BackgroundTransparency = 1
    t.Text = "🔒 НЕТ ДОСТУПА" t.TextColor3 = Color3.fromRGB(255,255,255)
    t.Font = Enum.Font.GothamBlack t.TextSize = 11 t.ZIndex = 7 t.Parent = b
end

local function CreateCard(category, name, defaultState, callback, accessLevel)
    local isLocked = not HasAccess(accessLevel)
    local card = Instance.new("Frame")
    card.Name = name.."_Card" card.BackgroundColor3 = Colors.CardBackground card.BackgroundTransparency = Colors.CardTransparency
    card.BorderSizePixel = 0 card.Visible = false card.Parent = CardsScroll
    local cc = Instance.new("UICorner") cc.CornerRadius = UDim.new(0,8) cc.Parent = card
    local n = Instance.new("TextLabel")
    n.Size = UDim2.new(1,-70,0,25) n.Position = UDim2.new(0,12,0,8) n.BackgroundTransparency = 1
    n.Text = name n.TextColor3 = Colors.Text n.Font = Enum.Font.GothamBold n.TextSize = 12 n.TextXAlignment = Enum.TextXAlignment.Left n.Parent = card
    local s = Instance.new("TextButton")
    s.Size = UDim2.new(0,40,0,20) s.Position = UDim2.new(1,-52,0,10)
    s.BackgroundColor3 = Color3.fromRGB(50,50,55) s.BorderSizePixel = 0 s.Text = "" s.AutoButtonColor = false s.Parent = card
    local sc = Instance.new("UICorner") sc.CornerRadius = UDim.new(1,0) sc.Parent = s
    local k = Instance.new("Frame")
    k.Size = UDim2.new(0,16,0,16) k.Position = UDim2.new(0,2,0.5,-8)
    k.BackgroundColor3 = Color3.fromRGB(255,255,255) k.BorderSizePixel = 0 k.Parent = s
    local kc = Instance.new("UICorner") kc.CornerRadius = UDim.new(1,0) kc.Parent = k
    local state = defaultState or false
    local function uv()
        local gp = state and UDim2.new(1,-18,0.5,-8) or UDim2.new(0,2,0.5,-8)
        local gc = state and Colors.AccentBlue or Color3.fromRGB(50,50,55)
        TweenService:Create(k, TweenInfo.new(0.2), {Position = gp}):Play()
        TweenService:Create(s, TweenInfo.new(0.2), {BackgroundColor3 = gc}):Play()
    end
    uv()
    if isLocked then
        ApplyLockOverlay(card)
        s.BackgroundColor3 = Color3.fromRGB(40,40,40) k.BackgroundColor3 = Color3.fromRGB(120,120,120)
    else
        s.MouseButton1Click:Connect(function() state = not state uv() callback(state) end)
    end
    table.insert(AllCards, {category=category, frame=card, name=name})
    return card
end

local function CreateSliderCard(category, name, min, max, default, callback, accessLevel)
    local isLocked = not HasAccess(accessLevel)
    local card = Instance.new("Frame")
    card.Name = name.."_Card" card.BackgroundColor3 = Colors.CardBackground card.BackgroundTransparency = Colors.CardTransparency
    card.BorderSizePixel = 0 card.Visible = false card.Parent = CardsScroll
    local cc = Instance.new("UICorner") cc.CornerRadius = UDim.new(0,8) cc.Parent = card
    local n = Instance.new("TextLabel")
    n.Size = UDim2.new(1,-20,0,20) n.Position = UDim2.new(0,12,0,5) n.BackgroundTransparency = 1
    n.Text = name..": "..default n.TextColor3 = Colors.Text n.Font = Enum.Font.GothamBold n.TextSize = 12 n.TextXAlignment = Enum.TextXAlignment.Left n.Parent = card
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,-24,0,8) b.Position = UDim2.new(0,12,0,38)
    b.BackgroundColor3 = Color3.fromRGB(50,50,55) b.BorderSizePixel = 0 b.Text = "" b.AutoButtonColor = false b.Parent = card
    local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(1,0) bc.Parent = b
    local f = Instance.new("Frame")
    f.Size = UDim2.new((default-min)/(max-min),0,1,0) f.BackgroundColor3 = Colors.AccentBlue f.BorderSizePixel = 0 f.Parent = b
    local fc = Instance.new("UICorner") fc.CornerRadius = UDim.new(1,0) fc.Parent = f
    local val = default local dragging = false
    local function u(input)
        local p = math.clamp((input.Position.X - b.AbsolutePosition.X)/b.AbsoluteSize.X, 0, 1)
        val = min + (max-min)*p
        f.Size = UDim2.new(p,0,1,0)
        n.Text = name..": "..math.floor(val)
        callback(val)
    end
    if isLocked then ApplyLockOverlay(card)
    else
        b.MouseButton1Down:Connect(function() dragging = true end)
        UserInputService.InputEnded:Connect(function(i) if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end end)
        UserInputService.InputChanged:Connect(function(i) if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then u(i) end end)
    end
    table.insert(AllCards, {category=category, frame=card, name=name})
    return card
end

local function CreateBindCard(category, name, callback, accessLevel)
    local isLocked = not HasAccess(accessLevel)
    local card = Instance.new("Frame")
    card.Name = name.."_Card" card.BackgroundColor3 = Colors.CardBackground card.BackgroundTransparency = Colors.CardTransparency
    card.BorderSizePixel = 0 card.Visible = false card.Parent = CardsScroll
    local cc = Instance.new("UICorner") cc.CornerRadius = UDim.new(0,8) cc.Parent = card
    local n = Instance.new("TextLabel")
    n.Size = UDim2.new(1,-100,1,0) n.Position = UDim2.new(0,12,0,0) n.BackgroundTransparency = 1
    n.Text = name n.TextColor3 = Colors.Text n.Font = Enum.Font.GothamBold n.TextSize = 12 n.TextXAlignment = Enum.TextXAlignment.Left n.Parent = card
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(0,70,0,22) b.Position = UDim2.new(1,-82,0.5,-11)
    b.BackgroundColor3 = Colors.AccentBlue b.BorderSizePixel = 0 b.Text = "NONE"
    b.TextColor3 = Color3.fromRGB(255,255,255) b.Font = Enum.Font.GothamBold b.TextSize = 11 b.AutoButtonColor = false b.Parent = card
    local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0,5) bc.Parent = b
    if isLocked then ApplyLockOverlay(card)
    else
        local l = false
        b.MouseButton1Click:Connect(function() l = true b.Text = "..." b.BackgroundColor3 = Color3.fromRGB(255,200,60) end)
        UserInputService.InputBegan:Connect(function(input, gp)
            if l and not gp and input.UserInputType == Enum.UserInputType.Keyboard then
                b.Text = tostring(input.KeyCode):gsub("Enum.KeyCode.","")
                b.BackgroundColor3 = Colors.AccentBlue
                l = false
                callback(input.KeyCode)
            end
        end)
    end
    table.insert(AllCards, {category=category, frame=card, name=name})
    return card
end

-- КАРТОЧКИ (Premium: KillAll/ChooseMap с замком)
if IS_MM_GAME then
    CreateCard("Main", "AutoGunLooter", false, ToggleAutoGunLooter)
    CreateCard("Main", "KillAll", false, function() end, "admin")
    CreateCard("ChooseMap", "100 Choose Map", false, function() end, "admin")
end

CreateCard("Legit", "AimBot", false, ToggleAimBot)
if IS_MM_GAME then
    CreateCard("Legit", "AimBot Only Murderer", false, function(s) Settings.AimBotOnlyMurderer = s end)
end
CreateCard("Legit", "AimBot Wall Check", true, function(s) Settings.AimBotWallCheck = s end)
CreateSliderCard("Legit", "AimBot FOV", 50, 300, 100, function(v) Settings.AimBotFOV = v FOVCircle.Radius = v end)
CreateSliderCard("Legit", "AimBot Prediction", 0, 100, 50, function(v) Settings.AimBotPrediction = v end)
CreateCard("Legit", "Lock Mouse", false, ToggleLockMouse)
CreateCard("Rage", "Fly", false, ToggleFly)
CreateCard("Rage", "NoClip", false, ToggleNoClip)

CreateCard("Visuals", "Player ESP", false, function(s)
    Settings.PlayerESP = s
    if s then UpdateAllVisuals() else ClearAllESP() end
end)
CreateCard("Visuals", "NameTags", false, function(s)
    Settings.NameTags = s
    if s then UpdateAllVisuals() else ClearAllNameTags() end
end)
if IS_MM_GAME then
    CreateCard("Visuals", "SeeInvisibles", false, function(s)
        Settings.SeeInvisibles = s
        if not s then ClearAllInvisibleESP() end
    end)
end
CreateCard("Visuals", "Ambience", false, function(s)
    Settings.Ambience = s
    if s then ApplySkybox(Settings.AmbienceType) else RemoveSkybox() end
end)
CreateSliderCard("Visuals", "Ambience Type (1-5)", 1, 5, 1, function(v)
    local types = {"Day","Night","Evening","Sunset","Anime"}
    Settings.AmbienceType = types[math.clamp(math.floor(v),1,5)]
    if Settings.Ambience then ApplySkybox(Settings.AmbienceType) end
end)
CreateCard("Visuals", "Shaders", false, ToggleShaders)
CreateSliderCard("Visuals", "Shader Mode (1=Blur 2=Ultra)", 1, 2, 1, function(v)
    Settings.ShaderMode = math.clamp(math.floor(v),1,2)
    SetShaderModeByNumber(Settings.ShaderMode)
end)
CreateCard("Visuals", "Aura", false, ToggleAura)
CreateSliderCard("Visuals", "Aura Type (1=Fire 2=Ice 3=Bolt)", 1, 3, 1, function(v)
    Settings.AuraType = math.clamp(math.floor(v),1,3)
    if Settings.Aura then RefreshAura() end
end)
CreateCard("Visuals", "Particles", false, ToggleParticles)

if IS_MM_GAME then
    CreateCard("WebHook", "MurderNotification", false, function(s)
        Settings.MurderNotification = s
        if not s then NotifiedPlayers.Murderer = {} end
    end)
    CreateCard("WebHook", "SheriffNotification", false, function(s)
        Settings.SheriffNotification = s
        if not s then NotifiedPlayers.Sheriff = {} end
    end)
end

CreateBindCard("Binds", "Fly Key", function(key) Settings.FlyKey = key end)
CreateBindCard("Binds", "NoClip Key", function(key) Settings.NoClipKey = key end)
CreateBindCard("Binds", "AimBot Key", function(key) Settings.AimBotKey = key end)
CreateBindCard("Binds", "Lock Mouse Key", function(key) Settings.LockMouseKey = key end)

-- CATEGORIES
local CurrentCategory = "Main"
local CategoryButtons = {}

local function SetCategoryVisibility(cat, q)
    q = (q or ""):lower()
    for _, card in pairs(AllCards) do
        if card.category == cat then
            card.frame.Visible = q == "" or card.name:lower():find(q,1,true)
        else
            card.frame.Visible = false
        end
    end
end

local function CreateCategoryButton(name)
    local b = Instance.new("TextButton")
    b.Size = UDim2.new(1,0,0,38) b.BackgroundColor3 = Color3.fromRGB(30,30,35) b.BackgroundTransparency = 0.3 b.BorderSizePixel = 0
    b.Text = "    "..name b.TextColor3 = Colors.TextDim b.Font = Enum.Font.GothamSemibold b.TextSize = 12
    b.TextXAlignment = Enum.TextXAlignment.Left b.AutoButtonColor = false b.Parent = CategoryContainer
    local bc = Instance.new("UICorner") bc.CornerRadius = UDim.new(0,6) bc.Parent = b
    CategoryButtons[name] = b
    b.MouseButton1Click:Connect(function()
        CurrentCategory = name
        for _, o in pairs(CategoryButtons) do o.BackgroundColor3 = Color3.fromRGB(30,30,35) o.TextColor3 = Colors.TextDim end
        b.BackgroundColor3 = Colors.AccentBlue b.TextColor3 = Colors.Text
        SetCategoryVisibility(name, SearchBox.Text)
    end)
    return b
end

CreateCategoryButton("Main")
if IS_MM_GAME then CreateCategoryButton("ChooseMap") end
CreateCategoryButton("Legit")
CreateCategoryButton("Rage")
CreateCategoryButton("Visuals")
if IS_MM_GAME then CreateCategoryButton("WebHook") end
CreateCategoryButton("Binds")

CategoryButtons["Main"].BackgroundColor3 = Colors.AccentBlue
CategoryButtons["Main"].TextColor3 = Colors.Text
SetCategoryVisibility("Main", "")

SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
    SetCategoryVisibility(CurrentCategory, SearchBox.Text)
end)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if Settings.FlyKey and input.KeyCode == Settings.FlyKey then ToggleFly(not Settings.Fly) end
    if Settings.NoClipKey and input.KeyCode == Settings.NoClipKey then ToggleNoClip(not Settings.NoClip) end
    if Settings.AimBotKey and input.KeyCode == Settings.AimBotKey then ToggleAimBot(not Settings.AimBot) end
    if Settings.LockMouseKey and input.KeyCode == Settings.LockMouseKey then ToggleLockMouse(not Settings.LockMouse) end
end)

local BlurEffect = Instance.new("BlurEffect")
BlurEffect.Size = 0 BlurEffect.Parent = Lighting

local isOpen, isAnimating = false, false

local function OpenGUI()
    if isAnimating or isOpen then return end
    isAnimating = true isOpen = true
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0,0,0,0) MainFrame.Position = UDim2.new(0.5,0,0.5,0)
    MainFrame.BackgroundTransparency = 1 Sidebar.BackgroundTransparency = 1
    TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(0,700,0,450), Position = UDim2.new(0.5,-350,0.5,-225),
        BackgroundTransparency = Colors.BackgroundTransparency,
    }):Play()
    TweenService:Create(Sidebar, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        BackgroundTransparency = Colors.SidebarTransparency,
    }):Play()
    TweenService:Create(BlurEffect, TweenInfo.new(0.35), {Size = 12}):Play()
    task.wait(0.35)
    isAnimating = false
end

local function CloseGUI()
    if isAnimating or not isOpen then return end
    isAnimating = true isOpen = false
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        Size = UDim2.new(0,0,0,0), Position = UDim2.new(0.5,0,0.5,0), BackgroundTransparency = 1,
    }):Play()
    TweenService:Create(Sidebar, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        BackgroundTransparency = 1,
    }):Play()
    TweenService:Create(BlurEffect, TweenInfo.new(0.3), {Size = 0}):Play()
    task.wait(0.3)
    MainFrame.Visible = false
    isAnimating = false
end

ExitButton.MouseButton1Click:Connect(CloseGUI)

local OpenModeButton = Instance.new("TextButton")
OpenModeButton.Size = UDim2.new(0,130,0,40) OpenModeButton.Position = UDim2.new(0,20,0.5,-20)
OpenModeButton.BackgroundColor3 = Color3.fromRGB(25,25,32) OpenModeButton.BackgroundTransparency = 0.1
OpenModeButton.BorderSizePixel = 0 OpenModeButton.Text = "" OpenModeButton.AutoButtonColor = false
OpenModeButton.Visible = false OpenModeButton.Active = true OpenModeButton.Draggable = true
OpenModeButton.Parent = ScreenGui

local ombCorner = Instance.new("UICorner") ombCorner.CornerRadius = UDim.new(0,10) ombCorner.Parent = OpenModeButton
local ombStroke = Instance.new("UIStroke")
ombStroke.Color = RankColor1 ombStroke.Thickness = 1.5 ombStroke.Transparency = 0.2 ombStroke.Parent = OpenModeButton
local ombGradient = Instance.new("UIGradient")
ombGradient.Color = ColorSequence.new({ColorSequenceKeypoint.new(0,RankColor1),ColorSequenceKeypoint.new(1,RankColor2)})
ombGradient.Parent = ombStroke

local ombLabel = Instance.new("TextLabel")
ombLabel.Size = UDim2.new(1,-20,0,22) ombLabel.Position = UDim2.new(0,10,0,4) ombLabel.BackgroundTransparency = 1
ombLabel.Text = "MegolaHub" ombLabel.TextColor3 = Colors.Text ombLabel.Font = Enum.Font.GothamBlack
ombLabel.TextSize = 15 ombLabel.TextXAlignment = Enum.TextXAlignment.Center ombLabel.Parent = OpenModeButton

local ombSubLabel = Instance.new("TextLabel")
ombSubLabel.Size = UDim2.new(1,-20,0,12) ombSubLabel.Position = UDim2.new(0,10,0,24) ombSubLabel.BackgroundTransparency = 1
ombSubLabel.Text = RankName ombSubLabel.TextColor3 = RankColor1 ombSubLabel.Font = Enum.Font.GothamBold
ombSubLabel.TextSize = 10 ombSubLabel.TextXAlignment = Enum.TextXAlignment.Center ombSubLabel.Parent = OpenModeButton

task.spawn(function()
    while ombLabel.Parent do
        for i = 0, 1, 0.02 do if ombGradient then ombGradient.Offset = Vector2.new(i,0) end task.wait(0.03) end
        for i = 1, 0, -0.02 do if ombGradient then ombGradient.Offset = Vector2.new(i,0) end task.wait(0.03) end
    end
end)

local function SetOpenMode(mode)
    Settings.OpenMode = mode
    OpenModeButton.Visible = (mode == "Button")
end

SetOpenMode(Settings.OpenMode)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if Settings.OpenMode == "Key" and input.KeyCode == Enum.KeyCode.RightShift then
        if isOpen then CloseGUI() else OpenGUI() end
    end
end)

OpenModeButton.MouseButton1Click:Connect(function()
    if isOpen then CloseGUI() else OpenGUI() end
end)

CreateSliderCard("Visuals", "Open Mode (1=Key 2=Button)", 1, 2, 2, function(v)
    local mode = math.clamp(math.floor(v), 1, 2)
    SetOpenMode(mode == 1 and "Key" or "Button")
end)

print("MegolaHub PREMIUM загружен! MM-игра: " .. tostring(IS_MM_GAME))
