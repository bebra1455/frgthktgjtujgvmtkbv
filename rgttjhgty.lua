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
    OpenMode = "Button",
    CloseTab = false,
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
NotifContainer.Name = "Notifications"
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
    notif.Name = "Notif"
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

    local nGradient = Instance.new("UIGradient")
    nGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(38, 38, 50)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(22, 22, 28)),
    })
    nGradient.Rotation = 45
    nGradient.Parent = notif

    local sideBar = Instance.new("Frame")
    sideBar.Size = UDim2.new(0, 4, 1, -20)
    sideBar.Position = UDim2.new(0, 8, 0, 10)
    sideBar.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    sideBar.BorderSizePixel = 0
    sideBar.Parent = notif

    local sbCorner = Instance.new("UICorner")
    sbCorner.CornerRadius = UDim.new(1, 0)
    sbCorner.Parent = sideBar

    local sbGradient = Instance.new("UIGradient")
    sbGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, iconColor or Color3.fromRGB(90, 130, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 90, 255)),
    })
    sbGradient.Rotation = 90
    sbGradient.Parent = sideBar

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
MainFrame.Name = "MainFrame"
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
Sidebar.Name = "Sidebar"
Sidebar.Size = UDim2.new(0, 200, 1, 0)
Sidebar.Position = UDim2.new(0, 0, 0, 0)
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
HubTitleLabel.Name = "HubTitle"
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
HubTitleGradient.Rotation = 0
HubTitleGradient.Parent = HubTitleLabel

task.spawn(function()
    while HubTitleLabel.Parent do
        for i = 0, 1, 0.02 do
            HubTitleGradient.Offset = Vector2.new(i, 0)
            task.wait(0.03)
        end
        for i = 1, 0, -0.02 do
            HubTitleGradient.Offset = Vector2.new(i, 0)
            task.wait(0.03)
        end
    end
end)

local ProfileFrame = Instance.new("Frame")
ProfileFrame.Name = "Profile"
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
AvatarImage.Name = "Avatar"
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
ProfileName.TextTruncate = Enum.TextTruncate.AtEnd
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
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 180, 60)),
    })
elseif IS_PREMIUM then
    BadgeFrame.BackgroundColor3 = Color3.fromRGB(255, 215, 0)
    BadgeGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 215, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 100, 255)),
    })
else
    BadgeFrame.BackgroundColor3 = Color3.fromRGB(70, 130, 240)
    BadgeGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(70, 130, 240)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 90, 255)),
    })
end
BadgeGradient.Rotation = 0
BadgeGradient.Parent = BadgeFrame

local BadgeText = Instance.new("TextLabel")
BadgeText.Size = UDim2.new(1, 0, 1, 0)
BadgeText.BackgroundTransparency = 1
if IS_ADMIN then
    BadgeText.Text = "DEV"
elseif IS_PREMIUM then
    BadgeText.Text = "PREMIUM"
else
    BadgeText.Text = "USER"
end
BadgeText.TextColor3 = Color3.fromRGB(255, 255, 255)
BadgeText.Font = Enum.Font.GothamBlack
BadgeText.TextSize = 9
BadgeText.Parent = BadgeFrame

local CategoryContainer = Instance.new("Frame")
CategoryContainer.Name = "CategoryContainer"
CategoryContainer.Size = UDim2.new(1, -20, 1, -190)
CategoryContainer.Position = UDim2.new(0, 10, 0, 88)
CategoryContainer.BackgroundTransparency = 1
CategoryContainer.Parent = Sidebar

local CategoryList = Instance.new("UIListLayout")
CategoryList.SortOrder = Enum.SortOrder.LayoutOrder
CategoryList.Padding = UDim.new(0, 5)
CategoryList.Parent = CategoryContainer

local ExitButton = Instance.new("TextButton")
ExitButton.Name = "ExitButton"
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
ContentArea.Name = "ContentArea"
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
CardsScroll.Name = "CardsScroll"
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
local GameplayRemotes = nil
local GetCurrentPlayerData = nil
local PlayerDataChanged = nil

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
            remote.OnClientEvent:Connect(function()
                task.wait(0.05)
                FetchPlayerData()
            end)
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
    local detected = GetRoleFromInfo(info)
    return detected or "Innocent"
end

local function GetRoleColor(role)
    if not IS_MM_GAME then return Color3.fromRGB(160, 90, 255) end
    if role == "Murderer" then return Color3.fromRGB(230, 40, 40) end
    if role == "Sheriff" then return Color3.fromRGB(40, 120, 255) end
    if role == "Hero" then return Color3.fromRGB(255, 215, 0) end
    if role == "Innocent" then return Color3.fromRGB(0, 220, 40) end
    return Color3.fromRGB(200, 200, 210)
end

-- ESP + NameTags
local ESPHighlights = {}
local NameTagGuis = {}

local function CreateESP(player)
    if ESPHighlights[player] then ESPHighlights[player]:Destroy() ESPHighlights[player] = nil end
    local role = GetPlayerRole(player)
    if IS_MM_GAME and role == "Lobby" then return end
    local character = player.Character
    if not character then return end
    local h = Instance.new("Highlight")
    h.Name = "ESP_Highlight"
    h.FillColor = GetRoleColor(role)
    h.FillTransparency = 0.7
    h.OutlineColor = GetRoleColor(role)
    h.OutlineTransparency = 0
    h.DepthMode = Enum.HighlightDepthMode.AlwaysOnTop
    h.Adornee = character
    h.Parent = character
    ESPHighlights[player] = h
end

local function ClearAllESP()
    for _, h in pairs(ESPHighlights) do
        if h then h:Destroy() end
    end
    ESPHighlights = {}
end

local function CreateNameTag(player)
    if NameTagGuis[player] then NameTagGuis[player]:Destroy() end
    local character = player.Character
    if not character then return end
    local root = character:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local b = Instance.new("BillboardGui")
    b.Name = "NameTag_GUI"
    b.Size = UDim2.new(0, 200, 0, 40)
    b.StudsOffset = Vector3.new(0, 3, 0)
    b.AlwaysOnTop = true
    b.MaxDistance = 300
    b.Adornee = root
    b.Parent = root

    local nameLabel = Instance.new("TextLabel")
    nameLabel.Size = UDim2.new(1, 0, 0, 18)
    nameLabel.BackgroundTransparency = 1
    nameLabel.Text = player.Name
    nameLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    nameLabel.TextStrokeTransparency = 0
    nameLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    nameLabel.Font = Enum.Font.GothamBold
    nameLabel.TextSize = 14
    nameLabel.Parent = b

    local role = GetPlayerRole(player)
    local roleLabel = Instance.new("TextLabel")
    roleLabel.Name = "RoleLabel"
    roleLabel.Size = UDim2.new(1, 0, 0, 14)
    roleLabel.Position = UDim2.new(0, 0, 0, 17)
    roleLabel.BackgroundTransparency = 1
    roleLabel.Text = role
    roleLabel.TextColor3 = GetRoleColor(role)
    roleLabel.TextStrokeTransparency = 0
    roleLabel.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    roleLabel.Font = Enum.Font.GothamSemibold
    roleLabel.TextSize = 12
    roleLabel.Parent = b

    NameTagGuis[player] = b
end

local function ClearAllNameTags()
    for _, g in pairs(NameTagGuis) do
        if g then g:Destroy() end
    end
    NameTagGuis = {}
end

local function UpdateAllVisuals()
    ClearAllESP()
    ClearAllNameTags()
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            if Settings.PlayerESP then CreateESP(player) end
            if Settings.NameTags then CreateNameTag(player) end
        end
    end
end

RunService.Heartbeat:Connect(function()
    if not Settings.PlayerESP and not Settings.NameTags then return end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            if Settings.PlayerESP then
                local role = GetPlayerRole(player)
                local existing = ESPHighlights[player]
                if (IS_MM_GAME and role == "Lobby") then
                    if existing then existing:Destroy() ESPHighlights[player] = nil end
                else
                    local color = GetRoleColor(role)
                    if existing then
                        if existing.FillColor ~= color then
                            existing.FillColor = color
                            existing.OutlineColor = color
                        end
                    else
                        CreateESP(player)
                    end
                end
            end
            if Settings.NameTags then
                local gui = NameTagGuis[player]
                if gui then
                    local roleLabel = gui:FindFirstChild("RoleLabel")
                    if roleLabel then
                        local role = GetPlayerRole(player)
                        roleLabel.Text = role
                        roleLabel.TextColor3 = GetRoleColor(role)
                    end
                end
            end
        end
    end
end)

local function OnCharacterAdded(player, character)
    task.wait(0.1)
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

-- Fly, NoClip, LockMouse
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
        FlyBV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        FlyBV.P = 1250
        FlyBV.Velocity = Vector3.zero
        FlyBV.Parent = root
        FlyBG = Instance.new("BodyGyro")
        FlyBG.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
        FlyBG.P = 3000
        FlyBG.D = 500
        FlyBG.CFrame = root.CFrame
        FlyBG.Parent = root
        FlyConnection = RunService.RenderStepped:Connect(function()
            if not Settings.Fly or not root or not root.Parent or not FlyBV or not FlyBG then return end
            local v = Vector3.zero
            if UserInputService:IsKeyDown(Enum.KeyCode.Space) then v += Vector3.new(0, 50, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.LeftShift) then v += Vector3.new(0, -50, 0) end
            if UserInputService:IsKeyDown(Enum.KeyCode.W) then v += Camera.CFrame.LookVector * 50 end
            if UserInputService:IsKeyDown(Enum.KeyCode.S) then v -= Camera.CFrame.LookVector * 50 end
            if UserInputService:IsKeyDown(Enum.KeyCode.A) then v -= Camera.CFrame.RightVector * 50 end
            if UserInputService:IsKeyDown(Enum.KeyCode.D) then v += Camera.CFrame.RightVector * 50 end
            FlyBV.Velocity = v
            local lookDir = Camera.CFrame.LookVector
            local flatLook = Vector3.new(lookDir.X, 0, lookDir.Z)
            if flatLook.Magnitude > 0.01 then
                FlyBG.CFrame = CFrame.lookAt(root.Position, root.Position + flatLook.Unit)
            end
            root.AssemblyAngularVelocity = Vector3.zero
            root.RotVelocity = Vector3.zero
        end)
    else
        if FlyConnection then FlyConnection:Disconnect() FlyConnection = nil end
        if FlyBV then FlyBV:Destroy() FlyBV = nil end
        if FlyBG then FlyBG:Destroy() FlyBG = nil end
        if humanoid then
            humanoid.PlatformStand = false
            humanoid:ChangeState(Enum.HumanoidStateType.GettingUp)
        end
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

-- AimBot
local AimBotConnection
local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Radius = 100
FOVCircle.Color = Color3.fromRGB(150, 100, 255)
FOVCircle.Transparency = 0.8
FOVCircle.Visible = false
FOVCircle.Filled = false

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
                                local d = (Vector2.new(sp.X, sp.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                                if d < closest then closest = d target = rp end
                            end
                        end
                    end
                end
            end
            if target then
                local pred = target.Velocity * (Settings.AimBotPrediction / 100)
                Camera.CFrame = CFrame.lookAt(Camera.CFrame.Position, target.Position + pred)
            end
        end)
    else
        if AimBotConnection then AimBotConnection:Disconnect() AimBotConnection = nil end
    end
end

RunService.RenderStepped:Connect(function()
    if FOVCircle.Visible then
        FOVCircle.Position = Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)
    end
end)

-- AutoGunLooter
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
    return n == "gundrop" or n:find("gundrop") or n == "knifedrop" or n:find("knifedrop")
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
    CachedGunDrops = newCache
    LastCacheUpdate = tick()
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
                local dist = (pos - myPos).Magnitude
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
                local target = CFrame.new(myRoot.Position + Vector3.new(0, -2.5, 0))
                if gun:IsA("Model") then
                    for _, part in pairs(gun:GetDescendants()) do
                        if part:IsA("BasePart") and part.Anchored then pcall(function() part.Anchored = false end) end
                    end
                    pcall(function() gun:PivotTo(target) end)
                elseif gun:IsA("BasePart") then
                    pcall(function()
                        gun.CFrame = target
                        gun.Velocity = Vector3.zero
                    end)
                end
            end
        end)
    else
        if GunLooterConnection then GunLooterConnection:Disconnect() GunLooterConnection = nil end
        CachedGunDrops = {}
    end
end

-- KillAll
local KillAllRunning = false

local function GetKnifeTool(char)
    for _, tool in pairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            local n = tool.Name:lower()
            if n:find("knife") or n:find("sword") or n:find("blade") or n:find("dagger") then return tool end
        end
    end
    return nil
end

local function RunKillAll()
    if not IS_MM_GAME then return end
    if KillAllRunning then return end
    KillAllRunning = true
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local myRoot = char:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end
        local orig = myRoot.CFrame
        local knife = GetKnifeTool(char)
        if not knife then return end
        for _, player in pairs(Players:GetPlayers()) do
            if not Settings.KillAll then break end
            if player ~= LocalPlayer then
                local info = PlayerData[player.Name]
                if info and type(info) == "table" and info.Dead ~= true and info.Role and info.Role ~= "" then
                    local tChar = player.Character
                    if tChar then
                        local h = tChar:FindFirstChildOfClass("Humanoid")
                        local root = tChar:FindFirstChild("HumanoidRootPart")
                        if h and root and h.Health > 0 then
                            myRoot.CFrame = root.CFrame + Vector3.new(0, 3, 0)
                            task.wait(0.08)
                            myRoot.CFrame = CFrame.lookAt(myRoot.Position, root.Position)
                            pcall(function() knife:Activate() end)
                            task.wait(0.15)
                        end
                    end
                end
            end
        end
        if myRoot and myRoot.Parent then myRoot.CFrame = orig end
    end)
    KillAllRunning = false
end

local function ToggleKillAll(enabled)
    if not IS_MM_GAME then return end
    Settings.KillAll = enabled
    if enabled then
        task.spawn(function()
            while Settings.KillAll do
                RunKillAll()
                task.wait(1)
            end
        end)
    end
end

-- ============================================================
-- СИСТЕМА КАРТОЧЕК
-- ============================================================
local AllCards = {}

local function ApplyLockOverlay(card)
    local darkOverlay = Instance.new("Frame")
    darkOverlay.Size = UDim2.new(1, 0, 1, 0)
    darkOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    darkOverlay.BackgroundTransparency = 0.5
    darkOverlay.BorderSizePixel = 0
    darkOverlay.ZIndex = 5
    darkOverlay.Parent = card
    local oc = Instance.new("UICorner")
    oc.CornerRadius = UDim.new(0, 8)
    oc.Parent = darkOverlay
    local lockBanner = Instance.new("Frame")
    lockBanner.Size = UDim2.new(1, 0, 0, 26)
    lockBanner.Position = UDim2.new(0, 0, 0.5, -13)
    lockBanner.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
    lockBanner.BorderSizePixel = 0
    lockBanner.ZIndex = 6
    lockBanner.Parent = card
    local lt = Instance.new("TextLabel")
    lt.Size = UDim2.new(1, 0, 1, 0)
    lt.BackgroundTransparency = 1
    lt.Text = "🔒 НЕТ ДОСТУПА"
    lt.TextColor3 = Color3.fromRGB(255, 255, 255)
    lt.Font = Enum.Font.GothamBlack
    lt.TextSize = 11
    lt.ZIndex = 7
    lt.Parent = lockBanner
end

local function CreateCard(category, name, defaultState, callback, accessLevel)
    local isLocked = not HasAccess(accessLevel)
    local card = Instance.new("Frame")
    card.Name = name .. "_Card"
    card.BackgroundColor3 = Colors.CardBackground
    card.BackgroundTransparency = Colors.CardTransparency
    card.BorderSizePixel = 0
    card.Visible = false
    card.Parent = CardsScroll
    local cc = Instance.new("UICorner")
    cc.CornerRadius = UDim.new(0, 8)
    cc.Parent = card

    local cardName = Instance.new("TextLabel")
    cardName.Size = UDim2.new(1, -70, 0, 25)
    cardName.Position = UDim2.new(0, 12, 0, 8)
    cardName.BackgroundTransparency = 1
    cardName.Text = name
    cardName.TextColor3 = Colors.Text
    cardName.Font = Enum.Font.GothamBold
    cardName.TextSize = 12
    cardName.TextXAlignment = Enum.TextXAlignment.Left
    cardName.Parent = card

    local Switch = Instance.new("TextButton")
    Switch.Size = UDim2.new(0, 40, 0, 20)
    Switch.Position = UDim2.new(1, -52, 0, 10)
    Switch.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    Switch.BorderSizePixel = 0
    Switch.Text = ""
    Switch.AutoButtonColor = false
    Switch.Parent = card
    local sc = Instance.new("UICorner")
    sc.CornerRadius = UDim.new(1, 0)
    sc.Parent = Switch

    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 16, 0, 16)
    Knob.Position = UDim2.new(0, 2, 0.5, -8)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel = 0
    Knob.Parent = Switch
    local kc = Instance.new("UICorner")
    kc.CornerRadius = UDim.new(1, 0)
    kc.Parent = Knob

    local state = defaultState or false
    local function UpdateVisual()
        local goalPos = state and UDim2.new(1, -18, 0.5, -8) or UDim2.new(0, 2, 0.5, -8)
        local goalColor = state and Colors.AccentBlue or Color3.fromRGB(50, 50, 55)
        TweenService:Create(Knob, TweenInfo.new(0.2), {Position = goalPos}):Play()
        TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = goalColor}):Play()
    end
    UpdateVisual()

    if isLocked then
        ApplyLockOverlay(card)
        Switch.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
        Knob.BackgroundColor3 = Color3.fromRGB(120, 120, 120)
    else
        Switch.MouseButton1Click:Connect(function()
            state = not state
            UpdateVisual()
            callback(state)
        end)
    end
    table.insert(AllCards, {category = category, frame = card, name = name})
    return card
end

local function CreateSliderCard(category, name, min, max, default, callback, accessLevel)
    local isLocked = not HasAccess(accessLevel)
    local card = Instance.new("Frame")
    card.Name = name .. "_Card"
    card.BackgroundColor3 = Colors.CardBackground
    card.BackgroundTransparency = Colors.CardTransparency
    card.BorderSizePixel = 0
    card.Visible = false
    card.Parent = CardsScroll
    local cc = Instance.new("UICorner")
    cc.CornerRadius = UDim.new(0, 8)
    cc.Parent = card

    local cardName = Instance.new("TextLabel")
    cardName.Size = UDim2.new(1, -20, 0, 20)
    cardName.Position = UDim2.new(0, 12, 0, 5)
    cardName.BackgroundTransparency = 1
    cardName.Text = name .. ": " .. default
    cardName.TextColor3 = Colors.Text
    cardName.Font = Enum.Font.GothamBold
    cardName.TextSize = 12
    cardName.TextXAlignment = Enum.TextXAlignment.Left
    cardName.Parent = card

    local SliderBtn = Instance.new("TextButton")
    SliderBtn.Size = UDim2.new(1, -24, 0, 8)
    SliderBtn.Position = UDim2.new(0, 12, 0, 38)
    SliderBtn.BackgroundColor3 = Color3.fromRGB(50, 50, 55)
    SliderBtn.BorderSizePixel = 0
    SliderBtn.Text = ""
    SliderBtn.AutoButtonColor = false
    SliderBtn.Parent = card
    local sc = Instance.new("UICorner")
    sc.CornerRadius = UDim.new(1, 0)
    sc.Parent = SliderBtn

    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    Fill.BackgroundColor3 = Colors.AccentBlue
    Fill.BorderSizePixel = 0
    Fill.Parent = SliderBtn
    local fc = Instance.new("UICorner")
    fc.CornerRadius = UDim.new(1, 0)
    fc.Parent = Fill

    local val = default
    local dragging = false
    local function Update(input)
        local pos = input.Position.X
        local abs = SliderBtn.AbsolutePosition.X
        local size = SliderBtn.AbsoluteSize.X
        local p = math.clamp((pos-abs)/size, 0, 1)
        val = min + (max-min)*p
        Fill.Size = UDim2.new(p, 0, 1, 0)
        cardName.Text = name .. ": " .. math.floor(val)
        callback(val)
    end

    if isLocked then
        ApplyLockOverlay(card)
    else
        SliderBtn.MouseButton1Down:Connect(function() dragging = true end)
        UserInputService.InputEnded:Connect(function(i)
            if i.UserInputType == Enum.UserInputType.MouseButton1 then dragging = false end
        end)
        UserInputService.InputChanged:Connect(function(i)
            if dragging and i.UserInputType == Enum.UserInputType.MouseMovement then Update(i) end
        end)
    end
    table.insert(AllCards, {category = category, frame = card, name = name})
    return card
end

local function CreateBindCard(category, name, callback, accessLevel)
    local isLocked = not HasAccess(accessLevel)
    local card = Instance.new("Frame")
    card.Name = name .. "_Card"
    card.BackgroundColor3 = Colors.CardBackground
    card.BackgroundTransparency = Colors.CardTransparency
    card.BorderSizePixel = 0
    card.Visible = false
    card.Parent = CardsScroll
    local cc = Instance.new("UICorner")
    cc.CornerRadius = UDim.new(0, 8)
    cc.Parent = card

    local cardName = Instance.new("TextLabel")
    cardName.Size = UDim2.new(1, -100, 1, 0)
    cardName.Position = UDim2.new(0, 12, 0, 0)
    cardName.BackgroundTransparency = 1
    cardName.Text = name
    cardName.TextColor3 = Colors.Text
    cardName.Font = Enum.Font.GothamBold
    cardName.TextSize = 12
    cardName.TextXAlignment = Enum.TextXAlignment.Left
    cardName.Parent = card

    local BindBtn = Instance.new("TextButton")
    BindBtn.Size = UDim2.new(0, 70, 0, 22)
    BindBtn.Position = UDim2.new(1, -82, 0.5, -11)
    BindBtn.BackgroundColor3 = Colors.AccentBlue
    BindBtn.BorderSizePixel = 0
    BindBtn.Text = "NONE"
    BindBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    BindBtn.Font = Enum.Font.GothamBold
    BindBtn.TextSize = 11
    BindBtn.AutoButtonColor = false
    BindBtn.Parent = card
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 5)
    bc.Parent = BindBtn

    if isLocked then
        ApplyLockOverlay(card)
    else
        local listening = false
        BindBtn.MouseButton1Click:Connect(function()
            listening = true
            BindBtn.Text = "..."
            BindBtn.BackgroundColor3 = Color3.fromRGB(255, 200, 60)
        end)
        UserInputService.InputBegan:Connect(function(input, gp)
            if listening and not gp and input.UserInputType == Enum.UserInputType.Keyboard then
                BindBtn.Text = tostring(input.KeyCode):gsub("Enum.KeyCode.", "")
                BindBtn.BackgroundColor3 = Colors.AccentBlue
                listening = false
                callback(input.KeyCode)
            end
        end)
    end
    table.insert(AllCards, {category = category, frame = card, name = name})
    return card
end

-- Карточки
if IS_MM_GAME then
    CreateCard("Main", "AutoGunLooter", false, ToggleAutoGunLooter)
    CreateCard("Main", "KillAll", false, ToggleKillAll)
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
CreateCard("Visuals", "Ambience", false, function(s) Settings.Ambience = s end)
CreateSliderCard("Visuals", "Ambience Type (1-5)", 1, 5, 1, function(v)
    local types = {"Day", "Night", "Evening", "Sunset", "Anime"}
    Settings.AmbienceType = types[math.clamp(math.floor(v), 1, 5)]
end)
CreateCard("Visuals", "Shaders", false, function(s) Settings.Shaders = s end)
CreateSliderCard("Visuals", "Shader Mode (1=Blur 2=Ultra)", 1, 2, 1, function(v)
    Settings.ShaderMode = math.clamp(math.floor(v), 1, 2)
end)
CreateCard("Visuals", "Aura", false, function(s) Settings.Aura = s end)
CreateSliderCard("Visuals", "Aura Type (1=Fire 2=Ice 3=Bolt)", 1, 3, 1, function(v)
    Settings.AuraType = math.clamp(math.floor(v), 1, 3)
end)
CreateCard("Visuals", "Particles", false, function(s) Settings.Particles = s end)

if IS_MM_GAME then
    CreateCard("Visuals", "SeeInvisibles", false, function() end, "admin")
end

if IS_MM_GAME then
    CreateCard("WebHook", "MurderNotification", false, function(s) Settings.MurderNotification = s end)
    CreateCard("WebHook", "SheriffNotification", false, function(s) Settings.SheriffNotification = s end)
end

CreateBindCard("Binds", "Fly Key", function(key) Settings.FlyKey = key end)
CreateBindCard("Binds", "NoClip Key", function(key) Settings.NoClipKey = key end)
CreateBindCard("Binds", "AimBot Key", function(key) Settings.AimBotKey = key end)
CreateBindCard("Binds", "Lock Mouse Key", function(key) Settings.LockMouseKey = key end)

-- Категории
local CurrentCategory = "Main"
local CategoryButtons = {}

local function SetCategoryVisibility(cat, searchQuery)
    searchQuery = (searchQuery or ""):lower()
    for _, card in pairs(AllCards) do
        if card.category == cat then
            card.frame.Visible = searchQuery == "" or card.name:lower():find(searchQuery, 1, true)
        else
            card.frame.Visible = false
        end
    end
end

local function CreateCategoryButton(name)
    local btn = Instance.new("TextButton")
    btn.Name = name .. "_CatBtn"
    btn.Size = UDim2.new(1, 0, 0, 38)
    btn.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
    btn.BackgroundTransparency = 0.3
    btn.BorderSizePixel = 0
    btn.Text = "    " .. name
    btn.TextColor3 = Colors.TextDim
    btn.Font = Enum.Font.GothamSemibold
    btn.TextSize = 12
    btn.TextXAlignment = Enum.TextXAlignment.Left
    btn.AutoButtonColor = false
    btn.Parent = CategoryContainer
    local bc = Instance.new("UICorner")
    bc.CornerRadius = UDim.new(0, 6)
    bc.Parent = btn
    CategoryButtons[name] = btn
    btn.MouseButton1Click:Connect(function()
        CurrentCategory = name
        for _, other in pairs(CategoryButtons) do
            other.BackgroundColor3 = Color3.fromRGB(30, 30, 35)
            other.TextColor3 = Colors.TextDim
        end
        btn.BackgroundColor3 = Colors.AccentBlue
        btn.TextColor3 = Colors.Text
        SetCategoryVisibility(name, SearchBox.Text)
    end)
    return btn
end

if IS_MM_GAME then CreateCategoryButton("Main") end
if IS_MM_GAME then CreateCategoryButton("ChooseMap") end
CreateCategoryButton("Legit")
CreateCategoryButton("Rage")
CreateCategoryButton("Visuals")
if IS_MM_GAME then CreateCategoryButton("WebHook") end
CreateCategoryButton("Binds")

local firstCat = IS_MM_GAME and "Main" or "Legit"
CategoryButtons[firstCat].BackgroundColor3 = Colors.AccentBlue
CategoryButtons[firstCat].TextColor3 = Colors.Text
SetCategoryVisibility(firstCat, "")

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
BlurEffect.Name = "MegolaHub_Blur"
BlurEffect.Size = 0
BlurEffect.Parent = Lighting

local isOpen, isAnimating = false, false

local function OpenGUI()
    if isAnimating or isOpen then return end
    isAnimating = true
    isOpen = true
    MainFrame.Visible = true
    MainFrame.Size = UDim2.new(0, 0, 0, 0)
    MainFrame.Position = UDim2.new(0.5, 0, 0.5, 0)
    MainFrame.BackgroundTransparency = 1
    Sidebar.BackgroundTransparency = 1
    TweenService:Create(MainFrame, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
        Size = UDim2.new(0, 700, 0, 450),
        Position = UDim2.new(0.5, -350, 0.5, -225),
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
    isAnimating = true
    isOpen = false
    TweenService:Create(MainFrame, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
        Size = UDim2.new(0, 0, 0, 0),
        Position = UDim2.new(0.5, 0, 0.5, 0),
        BackgroundTransparency = 1,
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

-- OpenMode Button (золотой Premium)
local OpenModeButton = Instance.new("TextButton")
OpenModeButton.Name = "MegolaHub_ToggleButton"
OpenModeButton.Size = UDim2.new(0, 130, 0, 40)
OpenModeButton.Position = UDim2.new(0, 20, 0.5, -20)
OpenModeButton.BackgroundColor3 = Color3.fromRGB(25, 25, 32)
OpenModeButton.BackgroundTransparency = 0.1
OpenModeButton.BorderSizePixel = 0
OpenModeButton.Text = ""
OpenModeButton.AutoButtonColor = false
OpenModeButton.Visible = false
OpenModeButton.Active = true
OpenModeButton.Draggable = true
OpenModeButton.Parent = ScreenGui

local ombCorner = Instance.new("UICorner")
ombCorner.CornerRadius = UDim.new(0, 10)
ombCorner.Parent = OpenModeButton

local ombStroke = Instance.new("UIStroke")
ombStroke.Color = RankColor1
ombStroke.Thickness = 1.5
ombStroke.Transparency = 0.2
ombStroke.Parent = OpenModeButton

local ombLabel = Instance.new("TextLabel")
ombLabel.Size = UDim2.new(1, -20, 0, 22)
ombLabel.Position = UDim2.new(0, 10, 0, 4)
ombLabel.BackgroundTransparency = 1
ombLabel.Text = "MegolaHub"
ombLabel.TextColor3 = Colors.Text
ombLabel.Font = Enum.Font.GothamBlack
ombLabel.TextSize = 15
ombLabel.TextXAlignment = Enum.TextXAlignment.Center
ombLabel.Parent = OpenModeButton

local ombSubLabel = Instance.new("TextLabel")
ombSubLabel.Size = UDim2.new(1, -20, 0, 12)
ombSubLabel.Position = UDim2.new(0, 10, 0, 24)
ombSubLabel.BackgroundTransparency = 1
ombSubLabel.Text = RankName
ombSubLabel.TextColor3 = RankColor1
ombSubLabel.Font = Enum.Font.GothamBold
ombSubLabel.TextSize = 10
ombSubLabel.TextXAlignment = Enum.TextXAlignment.Center
ombSubLabel.Parent = OpenModeButton

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
