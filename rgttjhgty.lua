--[[
    MegolaHub | MM2 Script - PREMIUM VERSION
    GUI: RightShift
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
    
    local dotFrame = Instance.new("Frame")
    dotFrame.Size = UDim2.new(0, 28, 0, 28)
    dotFrame.Position = UDim2.new(0, 22, 0, 10)
    dotFrame.BackgroundColor3 = iconColor or Color3.fromRGB(90, 130, 255)
    dotFrame.BackgroundTransparency = 0.8
    dotFrame.BorderSizePixel = 0
    dotFrame.Parent = notif
    
    local dotCorner = Instance.new("UICorner")
    dotCorner.CornerRadius = UDim.new(1, 0)
    dotCorner.Parent = dotFrame
    
    local dotStroke = Instance.new("UIStroke")
    dotStroke.Color = iconColor or Color3.fromRGB(90, 130, 255)
    dotStroke.Thickness = 1.5
    dotStroke.Parent = dotFrame
    
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
    textLabel.TextTruncate = Enum.TextTruncate.AtEnd
    textLabel.Parent = notif
    
    local subLabel = Instance.new("TextLabel")
    subLabel.Size = UDim2.new(1, -70, 0, 14)
    subLabel.Position = UDim2.new(0, 60, 0, 56)
    subLabel.BackgroundTransparency = 1
    subLabel.Text = "Обнаружен в игре"
    subLabel.TextColor3 = Color3.fromRGB(140, 140, 150)
    subLabel.Font = Enum.Font.Gotham
    subLabel.TextSize = 10
    subLabel.TextXAlignment = Enum.TextXAlignment.Left
    subLabel.Parent = notif
    
    notif.Position = UDim2.new(1, 400, 0, 0)
    notif.Rotation = 5
    TweenService:Create(notif, TweenInfo.new(0.45, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {
        Position = UDim2.new(1, -340, 0, 0),
        Rotation = 0,
    }):Play()
    
    task.spawn(function()
        while notif.Parent and dotStroke.Parent do
            TweenService:Create(dotStroke, TweenInfo.new(0.6), {Transparency = 0.8}):Play()
            TweenService:Create(dotFrame, TweenInfo.new(0.6), {BackgroundTransparency = 0.95}):Play()
            task.wait(0.6)
            TweenService:Create(dotStroke, TweenInfo.new(0.6), {Transparency = 0}):Play()
            TweenService:Create(dotFrame, TweenInfo.new(0.6), {BackgroundTransparency = 0.8}):Play()
            task.wait(0.6)
        end
    end)
    
    task.delay(4, function()
        if notif and notif.Parent then
            local outTween = TweenService:Create(notif, TweenInfo.new(0.35, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {
                Position = UDim2.new(1, 400, 0, 0),
                Rotation = -5,
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
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 180, 60)),
    })
elseif IS_PREMIUM then
    HubTitleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 215, 0)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 100, 255)),
    })
else
    HubTitleGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 180, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 90, 255)),
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

local SettingsButton = Instance.new("TextButton")
SettingsButton.Size = UDim2.new(0, 30, 1, 0)
SettingsButton.Position = UDim2.new(1, -30, 0, 0)
SettingsButton.BackgroundColor3 = Colors.SearchBar
SettingsButton.BackgroundTransparency = 0.2
SettingsButton.BorderSizePixel = 0
SettingsButton.Text = "+"
SettingsButton.TextColor3 = Colors.TextDim
SettingsButton.Font = Enum.Font.GothamBold
SettingsButton.TextSize = 16
SettingsButton.Parent = TopBar

local SettingsBtnCorner = Instance.new("UICorner")
SettingsBtnCorner.CornerRadius = UDim.new(0, 6)
SettingsBtnCorner.Parent = SettingsButton

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

local Remotes = ReplicatedStorage:WaitForChild("Remotes")
local GameplayRemotes = Remotes:WaitForChild("Gameplay")
local GetCurrentPlayerData = GameplayRemotes:WaitForChild("GetCurrentPlayerData")
local PlayerDataChanged = GameplayRemotes:WaitForChild("PlayerDataChanged")

local PlayerData = {}

local function GetRoleFromInfo(info)
    if not info then return nil end
    local role = tostring(info.Role or ""):lower()
    if role:find("murder") or role:find("killer") then return "Murderer" end
    if role:find("sheriff") or role:find("police") then return "Sheriff" end
    if role:find("hero") or role:find("innocent") or role:find("civilian") then return "Innocent" end
    return nil
end

local function UpdatePlayerData(newData)
    if type(newData) ~= "table" then return end
    PlayerData = newData
end

local function FetchPlayerData()
    task.spawn(function()
        local ok, data = pcall(function()
            return GetCurrentPlayerData:InvokeServer()
        end)
        if ok and type(data) == "table" then
            UpdatePlayerData(data)
        end
    end)
end

FetchPlayerData()

PlayerDataChanged.OnClientEvent:Connect(function(newData)
    if type(newData) == "table" then
        UpdatePlayerData(newData)
    else
        FetchPlayerData()
    end
end)

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
    RoundEndFade.OnClientEvent:Connect(function()
        PlayerData = {}
    end)
end

local function GetPlayerRole(player)
    if not player then return "Lobby" end
    local info = PlayerData[player.Name]
    if not info or type(info) ~= "table" then return "Lobby" end
    if info.Dead == true then return "Lobby" end
    local role = info.Role
    if not role or role == "" then return "Lobby" end
    local detected = GetRoleFromInfo(info)
    return detected or "Innocent"
end

local function GetRoleColor(role)
    if role == "Murderer" then
        return Color3.fromRGB(230, 40, 40)
    elseif role == "Sheriff" then
        return Color3.fromRGB(40, 120, 255)
    elseif role == "Innocent" then
        return Color3.fromRGB(0, 220, 40)
    else
        return Color3.fromRGB(200, 200, 210)
    end
end

local ESPHighlights = {}
local NameTagGuis = {}

local function CreateESP(player)
    if ESPHighlights[player] then
        ESPHighlights[player]:Destroy()
        ESPHighlights[player] = nil
    end
    local role = GetPlayerRole(player)
    if role == "Lobby" then return end
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
    b.Size = UDim2.new(0, 150, 0, 30)
    b.StudsOffset = Vector3.new(0, 3, 0)
    b.AlwaysOnTop = true
    b.MaxDistance = 300
    b.Adornee = root
    b.Parent = root
    local t = Instance.new("TextLabel")
    t.Size = UDim2.new(1, 0, 1, 0)
    t.BackgroundTransparency = 1
    t.Text = player.Name
    t.TextColor3 = Color3.fromRGB(255, 255, 255)
    t.TextStrokeTransparency = 0
    t.TextStrokeColor3 = Color3.fromRGB(0, 0, 0)
    t.Font = Enum.Font.GothamBold
    t.TextSize = 14
    t.Parent = b
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

local lastRoleCheck = 0
RunService.Heartbeat:Connect(function()
    if not Settings.PlayerESP then return end
    local now = tick()
    if now - lastRoleCheck < 0.03 then return end
    lastRoleCheck = now
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer and player.Character then
            local role = GetPlayerRole(player)
            local existing = ESPHighlights[player]
            if role == "Lobby" then
                if existing then
                    existing:Destroy()
                    ESPHighlights[player] = nil
                end
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

local NotifiedPlayers = { Murderer = {}, Sheriff = {} }

RunService.Heartbeat:Connect(function()
    if not Settings.MurderNotification and not Settings.SheriffNotification then return end
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local role = GetPlayerRole(player)
            if Settings.MurderNotification and role == "Murderer" and not NotifiedPlayers.Murderer[player] then
                NotifiedPlayers.Murderer[player] = true
                ShowNotification("УБИЙЦА НАЙДЕН", player.Name, Color3.fromRGB(230, 40, 40))
            end
            if Settings.SheriffNotification and role == "Sheriff" and not NotifiedPlayers.Sheriff[player] then
                NotifiedPlayers.Sheriff[player] = true
                ShowNotification("ШЕРИФ НАЙДЕН", player.Name, Color3.fromRGB(40, 120, 255))
            end
        end
    end
end)

local RoundEndFadeReset = GameplayRemotes:FindFirstChild("RoundEndFade")
if RoundEndFadeReset then
    RoundEndFadeReset.OnClientEvent:Connect(function()
        NotifiedPlayers.Murderer = {}
        NotifiedPlayers.Sheriff = {}
    end)
end

for _, player in pairs(Players:GetPlayers()) do
    player.CharacterAdded:Connect(function()
        NotifiedPlayers.Murderer[player] = nil
        NotifiedPlayers.Sheriff[player] = nil
    end)
end
Players.PlayerAdded:Connect(function(player)
    player.CharacterAdded:Connect(function()
        NotifiedPlayers.Murderer[player] = nil
        NotifiedPlayers.Sheriff[player] = nil
    end)
end)

Players.PlayerRemoving:Connect(function(player)
    NotifiedPlayers.Murderer[player] = nil
    NotifiedPlayers.Sheriff[player] = nil
end)

local Skyboxes = {
    Day = {
        SkyboxBk = "rbxassetid://159454299", SkyboxDn = "rbxassetid://159454296", SkyboxFt = "rbxassetid://159454293",
        SkyboxLf = "rbxassetid://159454286", SkyboxRt = "rbxassetid://159454300", SkyboxUp = "rbxassetid://159454288",
        Brightness = 2, ClockTime = 14, Ambient = Color3.fromRGB(130, 130, 130),
        OutdoorAmbient = Color3.fromRGB(128, 128, 128), FogEnd = 100000, FogColor = Color3.fromRGB(200, 200, 200),
    },
    Night = {
        SkyboxBk = "rbxassetid://12064107", SkyboxDn = "rbxassetid://12064152", SkyboxFt = "rbxassetid://12064121",
        SkyboxLf = "rbxassetid://12063984", SkyboxRt = "rbxassetid://12064115", SkyboxUp = "rbxassetid://12064130",
        Brightness = 1, ClockTime = 0, Ambient = Color3.fromRGB(30, 30, 50),
        OutdoorAmbient = Color3.fromRGB(25, 25, 40), FogEnd = 500, FogColor = Color3.fromRGB(20, 20, 40),
    },
    Evening = {
        SkyboxBk = "rbxassetid://271042516", SkyboxDn = "rbxassetid://271077243", SkyboxFt = "rbxassetid://271042556",
        SkyboxLf = "rbxassetid://271042310", SkyboxRt = "rbxassetid://271042467", SkyboxUp = "rbxassetid://271077958",
        Brightness = 1.5, ClockTime = 18, Ambient = Color3.fromRGB(100, 80, 80),
        OutdoorAmbient = Color3.fromRGB(90, 70, 70), FogEnd = 1000, FogColor = Color3.fromRGB(150, 100, 80),
    },
    Sunset = {
        SkyboxBk = "rbxassetid://105092364", SkyboxDn = "rbxassetid://105092385", SkyboxFt = "rbxassetid://105092306",
        SkyboxLf = "rbxassetid://105092413", SkyboxRt = "rbxassetid://105092351", SkyboxUp = "rbxassetid://105092442",
        Brightness = 2, ClockTime = 17, Ambient = Color3.fromRGB(180, 120, 80),
        OutdoorAmbient = Color3.fromRGB(160, 100, 60), FogEnd = 2000, FogColor = Color3.fromRGB(255, 140, 80),
    },
    Anime = {
        SkyboxBk = "rbxassetid://6444884337", SkyboxDn = "rbxassetid://6444884951", SkyboxFt = "rbxassetid://6444884415",
        SkyboxLf = "rbxassetid://6444883914", SkyboxRt = "rbxassetid://6444883684", SkyboxUp = "rbxassetid://6444885256",
        Brightness = 3, ClockTime = 12, Ambient = Color3.fromRGB(200, 200, 255),
        OutdoorAmbient = Color3.fromRGB(180, 180, 255), FogEnd = 5000, FogColor = Color3.fromRGB(220, 220, 255),
    },
}

local CurrentSky = nil
local SavedLighting = nil

local function SaveLighting()
    if SavedLighting then return end
    SavedLighting = {
        Brightness = Lighting.Brightness,
        ClockTime = Lighting.ClockTime,
        Ambient = Lighting.Ambient,
        OutdoorAmbient = Lighting.OutdoorAmbient,
        FogEnd = Lighting.FogEnd,
        FogColor = Lighting.FogColor,
        EnvironmentDiffuseScale = Lighting.EnvironmentDiffuseScale,
        EnvironmentSpecularScale = Lighting.EnvironmentSpecularScale,
    }
end

local function ApplySkybox(skyName)
    local data = Skyboxes[skyName]
    if not data then return end
    SaveLighting()
    if CurrentSky then CurrentSky:Destroy() end
    CurrentSky = Instance.new("Sky")
    CurrentSky.Name = "MegolaHub_Sky"
    CurrentSky.SkyboxBk = data.SkyboxBk
    CurrentSky.SkyboxDn = data.SkyboxDn
    CurrentSky.SkyboxFt = data.SkyboxFt
    CurrentSky.SkyboxLf = data.SkyboxLf
    CurrentSky.SkyboxRt = data.SkyboxRt
    CurrentSky.SkyboxUp = data.SkyboxUp
    CurrentSky.Parent = Lighting
    Lighting.Brightness = data.Brightness
    Lighting.ClockTime = data.ClockTime
    Lighting.Ambient = data.Ambient
    Lighting.OutdoorAmbient = data.OutdoorAmbient
    Lighting.FogEnd = data.FogEnd
    Lighting.FogColor = data.FogColor
end

local function RemoveSkybox()
    if CurrentSky then
        CurrentSky:Destroy()
        CurrentSky = nil
    end
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

local ShaderDOF = Instance.new("DepthOfFieldEffect")
ShaderDOF.Name = "MegolaHub_Shader_DOF"
ShaderDOF.FocusDistance = 5
ShaderDOF.InFocusRadius = 20
ShaderDOF.NearIntensity = 0
ShaderDOF.FarIntensity = 0
ShaderDOF.Parent = Lighting

local UltraBloom = Instance.new("BloomEffect")
UltraBloom.Name = "MegolaHub_Ultra_Bloom"
UltraBloom.Intensity = 0
UltraBloom.Size = 24
UltraBloom.Threshold = 0.9
UltraBloom.Parent = Lighting

local UltraCC = Instance.new("ColorCorrectionEffect")
UltraCC.Name = "MegolaHub_Ultra_CC"
UltraCC.Brightness = 0
UltraCC.Contrast = 0
UltraCC.Saturation = 0
UltraCC.TintColor = Color3.fromRGB(255, 255, 255)
UltraCC.Parent = Lighting

local UltraSun = Instance.new("SunRaysEffect")
UltraSun.Name = "MegolaHub_Ultra_Sun"
UltraSun.Intensity = 0
UltraSun.Spread = 1
UltraSun.Parent = Lighting

local UltraAtmo = Instance.new("Atmosphere")
UltraAtmo.Name = "MegolaHub_Ultra_Atmo"
UltraAtmo.Density = 0
UltraAtmo.Offset = 0
UltraAtmo.Color = Color3.fromRGB(199, 199, 199)
UltraAtmo.Decay = Color3.fromRGB(106, 112, 125)
UltraAtmo.Glare = 0
UltraAtmo.Haze = 0
UltraAtmo.Parent = Lighting

local function ApplyBlurShader(enabled)
    if enabled then
        TweenService:Create(ShaderDOF, TweenInfo.new(0.4), {FarIntensity = 1}):Play()
        TweenService:Create(UltraBloom, TweenInfo.new(0.4), {Intensity = 0}):Play()
        TweenService:Create(UltraCC, TweenInfo.new(0.4), {Saturation = 0, Contrast = 0, Brightness = 0}):Play()
        TweenService:Create(UltraSun, TweenInfo.new(0.4), {Intensity = 0}):Play()
        TweenService:Create(UltraAtmo, TweenInfo.new(0.4), {Density = 0, Haze = 0}):Play()
    else
        TweenService:Create(ShaderDOF, TweenInfo.new(0.4), {FarIntensity = 0}):Play()
    end
end

local function ApplyUltraRealismShader(enabled)
    if enabled then
        ShaderDOF.FocusDistance = 12
        ShaderDOF.InFocusRadius = 40
        ShaderDOF.NearIntensity = 0.15
        TweenService:Create(ShaderDOF, TweenInfo.new(0.6), {FarIntensity = 0.7}):Play()
        TweenService:Create(UltraBloom, TweenInfo.new(0.6), {Intensity = 0.6, Size = 28, Threshold = 0.85}):Play()
        TweenService:Create(UltraCC, TweenInfo.new(0.6), {
            Brightness = 0.05, Contrast = 0.15, Saturation = 0.25, TintColor = Color3.fromRGB(255, 250, 245),
        }):Play()
        TweenService:Create(UltraSun, TweenInfo.new(0.6), {Intensity = 0.12, Spread = 0.9}):Play()
        TweenService:Create(UltraAtmo, TweenInfo.new(0.6), {
            Density = 0.35, Haze = 1.5, Glare = 0.15,
            Color = Color3.fromRGB(190, 195, 205), Decay = Color3.fromRGB(115, 120, 135),
        }):Play()
        if not SavedLighting then
            SaveLighting()
            Lighting.OutdoorAmbient = Color3.fromRGB(80, 85, 95)
            Lighting.Ambient = Color3.fromRGB(70, 75, 85)
            Lighting.Brightness = 3
            Lighting.EnvironmentDiffuseScale = 0.6
            Lighting.EnvironmentSpecularScale = 0.8
        end
    else
        TweenService:Create(ShaderDOF, TweenInfo.new(0.6), {FarIntensity = 0, NearIntensity = 0}):Play()
        TweenService:Create(UltraBloom, TweenInfo.new(0.6), {Intensity = 0}):Play()
        TweenService:Create(UltraCC, TweenInfo.new(0.6), {
            Brightness = 0, Contrast = 0, Saturation = 0, TintColor = Color3.fromRGB(255, 255, 255),
        }):Play()
        TweenService:Create(UltraSun, TweenInfo.new(0.6), {Intensity = 0}):Play()
        TweenService:Create(UltraAtmo, TweenInfo.new(0.6), {Density = 0, Haze = 0, Glare = 0}):Play()
        if SavedLighting then
            Lighting.OutdoorAmbient = SavedLighting.OutdoorAmbient
            Lighting.Ambient = SavedLighting.Ambient
            Lighting.Brightness = SavedLighting.Brightness
            Lighting.EnvironmentDiffuseScale = SavedLighting.EnvironmentDiffuseScale or 1
            Lighting.EnvironmentSpecularScale = SavedLighting.EnvironmentSpecularScale or 1
            SavedLighting = nil
        end
    end
end

local ShaderMode = "None"

local function SetShaderMode(mode)
    if ShaderMode == mode then return end
    ShaderMode = mode
    if mode == "None" then
        ApplyBlurShader(false)
        ApplyUltraRealismShader(false)
    elseif mode == "Blur" then
        ApplyUltraRealismShader(false)
        ApplyBlurShader(true)
    elseif mode == "Ultra" then
        ApplyBlurShader(false)
        ApplyUltraRealismShader(true)
    end
end

local function ToggleShaders(enabled)
    Settings.Shaders = enabled
    if enabled then
        if ShaderMode == "None" then
            SetShaderMode("Blur")
        else
            SetShaderMode(ShaderMode)
        end
    else
        SetShaderMode("None")
    end
end

local function SetShaderModeByNumber(num)
    if not Settings.Shaders then return end
    if num == 1 then
        SetShaderMode("Blur")
    elseif num == 2 then
        SetShaderMode("Ultra")
    end
end

local AuraParts = {}
local AuraConnection = nil
local AuraLoopConnection = nil

local AuraTypes = {
    [1] = { Name = "Огненная аура", Mode = "Fire" },
    [2] = { Name = "Ледяная аура", Mode = "Ice" },
    [3] = { Name = "Молния", Mode = "Lightning" },
}

local function ClearAura()
    for _, p in pairs(AuraParts) do
        if p and p.Parent then p:Destroy() end
    end
    AuraParts = {}
    if AuraLoopConnection then
        AuraLoopConnection:Disconnect()
        AuraLoopConnection = nil
    end
end

local function ApplyFireAura(char)
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local attachment = Instance.new("Attachment")
    attachment.Name = "MegolaHub_FireAttach"
    attachment.Position = Vector3.new(0, -2, 0)
    attachment.Parent = root
    table.insert(AuraParts, attachment)
    local emitter = Instance.new("ParticleEmitter")
    emitter.Texture = "rbxassetid://243660364"
    emitter.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 200, 50)),
        ColorSequenceKeypoint.new(0.5, Color3.fromRGB(255, 100, 20)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(150, 20, 0)),
    })
    emitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.5, 2),
        NumberSequenceKeypoint.new(1, 0),
    })
    emitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.2, 0.3),
        NumberSequenceKeypoint.new(1, 1),
    })
    emitter.Lifetime = NumberRange.new(0.8, 1.3)
    emitter.Rate = 60
    emitter.Speed = NumberRange.new(4, 8)
    emitter.SpreadAngle = Vector2.new(30, 30)
    emitter.Rotation = NumberRange.new(0, 360)
    emitter.RotSpeed = NumberRange.new(-30, 30)
    emitter.LightEmission = 1
    emitter.LightInfluence = 0
    emitter.Acceleration = Vector3.new(0, 8, 0)
    emitter.Parent = attachment
    table.insert(AuraParts, emitter)
    local light = Instance.new("PointLight")
    light.Color = Color3.fromRGB(255, 120, 30)
    light.Range = 12
    light.Brightness = 2
    light.Parent = root
    table.insert(AuraParts, light)
end

local function ApplyIceAura(char)
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return end
    local orbCount = 8
    local iceParts = {}
    for i = 1, orbCount do
        local crystal = Instance.new("Part")
        crystal.Name = "MegolaHub_IceCrystal"
        crystal.Size = Vector3.new(0.4, 1.2, 0.4)
        crystal.Material = Enum.Material.Glass
        crystal.Color = Color3.fromRGB(150, 220, 255)
        crystal.Transparency = 0.3
        crystal.Anchored = true
        crystal.CanCollide = false
        crystal.CanQuery = false
        crystal.CanTouch = false
        crystal.CastShadow = false
        crystal.Parent = workspace
        table.insert(AuraParts, crystal)
        table.insert(iceParts, crystal)
    end
    local startTime = tick()
    AuraLoopConnection = RunService.Heartbeat:Connect(function()
        if not Settings.Aura or Settings.AuraType ~= 2 then return end
        local ch = LocalPlayer.Character
        if not ch or not ch:FindFirstChild("HumanoidRootPart") then return end
        local rp = ch.HumanoidRootPart
        local elapsed = tick() - startTime
        for i, crystal in ipairs(iceParts) do
            if crystal and crystal.Parent then
                local angle = elapsed * 1.5 + (i / orbCount) * math.pi * 2
                local radius = 4
                local height = math.sin(elapsed * 2 + i) * 1.5
                crystal.CFrame = CFrame.new(rp.Position + Vector3.new(
                    math.cos(angle) * radius, height, math.sin(angle) * radius
                )) * CFrame.Angles(elapsed * 2, elapsed * 3, elapsed * 2)
            end
        end
    end)
    local attachment = Instance.new("Attachment")
    attachment.Position = Vector3.new(0, 0, 0)
    attachment.Parent = root
    table.insert(AuraParts, attachment)
    local emitter = Instance.new("ParticleEmitter")
    emitter.Texture = "rbxassetid://243660364"
    emitter.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 240, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 180, 255)),
    })
    emitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.5, 1.5),
        NumberSequenceKeypoint.new(1, 0),
    })
    emitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.3, 0.4),
        NumberSequenceKeypoint.new(1, 1),
    })
    emitter.Lifetime = NumberRange.new(1, 1.8)
    emitter.Rate = 30
    emitter.Speed = NumberRange.new(1, 3)
    emitter.SpreadAngle = Vector2.new(180, 180)
    emitter.Rotation = NumberRange.new(0, 360)
    emitter.RotSpeed = NumberRange.new(-60, 60)
    emitter.LightEmission = 1
    emitter.LightInfluence = 0
    emitter.Parent = attachment
    table.insert(AuraParts, emitter)
    local light = Instance.new("PointLight")
    light.Color = Color3.fromRGB(150, 220, 255)
    light.Range = 14
    light.Brightness = 2
    light.Parent = root
    table.insert(AuraParts, light)
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
            local bolt = Instance.new("Part")
            bolt.Name = "MegolaHub_Bolt"
            bolt.Size = Vector3.new(0.3, 0.3, math.random(3, 8))
            bolt.Material = Enum.Material.Neon
            bolt.Color = Color3.fromRGB(150, 200, 255)
            bolt.Transparency = 0.3
            bolt.Anchored = true
            bolt.CanCollide = false
            bolt.CanQuery = false
            bolt.CanTouch = false
            bolt.CastShadow = false
            bolt.Parent = workspace
            local light = Instance.new("PointLight")
            light.Color = Color3.fromRGB(150, 200, 255)
            light.Range = 8
            light.Brightness = 3
            light.Parent = bolt
            local angle = math.random() * math.pi * 2
            local dist = math.random(20, 50) / 10
            local offset = Vector3.new(math.cos(angle) * dist, math.random(-2, 4), math.sin(angle) * dist)
            bolt.CFrame = CFrame.new(rp.Position + offset) * CFrame.Angles(
                math.random() * math.pi * 2, math.random() * math.pi * 2, math.random() * math.pi * 2
            )
            task.spawn(function()
                for i = 1, 3 do
                    if bolt and bolt.Parent then
                        bolt.Transparency = 0.8
                        task.wait(0.03)
                        bolt.Transparency = 0.2
                        task.wait(0.03)
                    end
                end
                if bolt then
                    TweenService:Create(bolt, TweenInfo.new(0.2), {Transparency = 1}):Play()
                    task.wait(0.2)
                    if bolt and bolt.Parent then bolt:Destroy() end
                end
            end)
        end
    end)
    local attachment = Instance.new("Attachment")
    attachment.Position = Vector3.new(0, 0, 0)
    attachment.Parent = root
    table.insert(AuraParts, attachment)
    local emitter = Instance.new("ParticleEmitter")
    emitter.Texture = "rbxassetid://243660364"
    emitter.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 220, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 150, 255)),
    })
    emitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.5, 1.2),
        NumberSequenceKeypoint.new(1, 0),
    })
    emitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.3, 0.3),
        NumberSequenceKeypoint.new(1, 1),
    })
    emitter.Lifetime = NumberRange.new(0.5, 1)
    emitter.Rate = 40
    emitter.Speed = NumberRange.new(3, 8)
    emitter.SpreadAngle = Vector2.new(180, 180)
    emitter.Rotation = NumberRange.new(0, 360)
    emitter.RotSpeed = NumberRange.new(-180, 180)
    emitter.LightEmission = 1
    emitter.LightInfluence = 0
    emitter.Parent = attachment
    table.insert(AuraParts, emitter)
    local light = Instance.new("PointLight")
    light.Color = Color3.fromRGB(150, 200, 255)
    light.Range = 14
    light.Brightness = 2.5
    light.Parent = root
    table.insert(AuraParts, light)
end

local function ApplyAura()
    ClearAura()
    local char = LocalPlayer.Character
    if not char then return end
    local data = AuraTypes[Settings.AuraType] or AuraTypes[1]
    local mode = data.Mode
    if mode == "Fire" then
        ApplyFireAura(char)
    elseif mode == "Ice" then
        ApplyIceAura(char)
    elseif mode == "Lightning" then
        ApplyLightningAura(char)
    end
end

local function ToggleAura(enabled)
    Settings.Aura = enabled
    if enabled then
        ApplyAura()
        AuraConnection = LocalPlayer.CharacterAdded:Connect(function()
            task.wait(0.5)
            if Settings.Aura then
                ApplyAura()
            end
        end)
    else
        if AuraConnection then
            AuraConnection:Disconnect()
            AuraConnection = nil
        end
        ClearAura()
    end
end

local function RefreshAura()
    if Settings.Aura then
        ApplyAura()
    end
end

local ParticleParts = {}
local ParticleConnection = nil
local PARTICLE_COUNT = 100
local PARTICLE_MIN_DIST = 15
local PARTICLE_MAX_DIST = 60
local PARTICLE_RANGE = 80
local PARTICLE_Y_RANGE = 40

local SNOW_TEXTURE = "rbxassetid://243660364"

local function CreateSnowflake()
    local part = Instance.new("Part")
    part.Name = "MegolaHub_Snowflake"
    part.Size = Vector3.new(0.25, 0.25, 0.25)
    part.Shape = Enum.PartType.Ball
    part.Material = Enum.Material.Neon
    part.Color = Color3.fromRGB(220, 240, 255)
    part.Transparency = 0.2
    part.Anchored = true
    part.CanCollide = false
    part.CanQuery = false
    part.CanTouch = false
    part.CastShadow = false
    part.Locked = true
    part.Parent = workspace
    local light = Instance.new("PointLight")
    light.Color = Color3.fromRGB(220, 240, 255)
    light.Range = 3
    light.Brightness = 1
    light.Parent = part
    local emitter = Instance.new("ParticleEmitter")
    emitter.Texture = SNOW_TEXTURE
    emitter.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(180, 220, 255)),
    })
    emitter.Size = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0),
        NumberSequenceKeypoint.new(0.5, 0.4),
        NumberSequenceKeypoint.new(1, 0),
    })
    emitter.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 1),
        NumberSequenceKeypoint.new(0.3, 0.3),
        NumberSequenceKeypoint.new(1, 1),
    })
    emitter.Lifetime = NumberRange.new(1, 2)
    emitter.Rate = 4
    emitter.Speed = NumberRange.new(0.5, 2)
    emitter.SpreadAngle = Vector2.new(180, 180)
    emitter.Rotation = NumberRange.new(0, 360)
    emitter.RotSpeed = NumberRange.new(-60, 60)
    emitter.LightEmission = 1
    emitter.LightInfluence = 0
    emitter.Parent = part
    return part
end

local function GetRandomParticlePosition()
    local char = LocalPlayer.Character
    local centerPos = Vector3.new(0, 50, 0)
    if char and char:FindFirstChild("HumanoidRootPart") then
        centerPos = char.HumanoidRootPart.Position
    end
    local angle = math.random() * math.pi * 2
    local distance = math.random(PARTICLE_MIN_DIST * 10, PARTICLE_MAX_DIST * 10) / 10
    local offsetX = math.cos(angle) * distance
    local offsetZ = math.sin(angle) * distance
    local offsetY = math.random(-PARTICLE_Y_RANGE, PARTICLE_Y_RANGE)
    return centerPos + Vector3.new(offsetX, offsetY, offsetZ)
end

local function SpawnParticles()
    for _, p in pairs(ParticleParts) do
        if p and p.Parent then p:Destroy() end
    end
    ParticleParts = {}
    for i = 1, PARTICLE_COUNT do
        local snowflake = CreateSnowflake()
        snowflake.Position = GetRandomParticlePosition()
        table.insert(ParticleParts, snowflake)
    end
end

local function ClearParticles()
    for _, p in pairs(ParticleParts) do
        if p and p.Parent then p:Destroy() end
    end
    ParticleParts = {}
end

local function StartParticleAnimation()
    if ParticleConnection then
        ParticleConnection:Disconnect()
        ParticleConnection = nil
    end
    local particleData = {}
    for i, p in ipairs(ParticleParts) do
        particleData[p] = {
            basePos = p.Position,
            phaseX = math.random() * math.pi * 2,
            phaseY = math.random() * math.pi * 2,
            phaseZ = math.random() * math.pi * 2,
            speedX = math.random(5, 15) / 10,
            speedY = math.random(8, 20) / 10,
            speedZ = math.random(5, 15) / 10,
            ampX = math.random(15, 40) / 10,
            ampY = math.random(20, 50) / 10,
            ampZ = math.random(15, 40) / 10,
            rotSpeed = math.random(-30, 30) / 10,
        }
    end
    local startTime = tick()
    ParticleConnection = RunService.Heartbeat:Connect(function()
        if not Settings.Particles then return end
        local elapsed = tick() - startTime
        local char = LocalPlayer.Character
        if not char or not char:FindFirstChild("HumanoidRootPart") then return end
        local playerPos = char.HumanoidRootPart.Position
        for i, p in ipairs(ParticleParts) do
            if not p or not p.Parent then continue end
            local data = particleData[p]
            if not data then continue end
            local offsetX = math.sin(elapsed * data.speedX + data.phaseX) * data.ampX
            local offsetY = math.cos(elapsed * data.speedY + data.phaseY) * data.ampY
            local offsetZ = math.sin(elapsed * data.speedZ + data.phaseZ) * data.ampZ
            local targetPos = data.basePos + Vector3.new(offsetX, offsetY, offsetZ)
            local dist = (targetPos - playerPos).Magnitude
            if dist > PARTICLE_RANGE * 1.5 then
                data.basePos = GetRandomParticlePosition()
                data.phaseX = math.random() * math.pi * 2
                data.phaseY = math.random() * math.pi * 2
                data.phaseZ = math.random() * math.pi * 2
                targetPos = data.basePos
            end
            p.Position = targetPos
            p.CFrame = CFrame.new(p.Position) * CFrame.Angles(
                elapsed * data.rotSpeed,
                elapsed * data.rotSpeed * 0.7,
                elapsed * data.rotSpeed * 0.5
            )
            local light = p:FindFirstChildOfClass("PointLight")
            if light then
                light.Brightness = 0.8 + math.sin(elapsed * 2 + data.phaseX) * 0.4
            end
        end
    end)
end

local function ToggleParticles(enabled)
    Settings.Particles = enabled
    if enabled then
        SpawnParticles()
        StartParticleAnimation()
    else
        if ParticleConnection then
            ParticleConnection:Disconnect()
            ParticleConnection = nil
        end
        ClearParticles()
    end
end

local GunLooterConnection = nil
local LastLootTime = 0
local LOOT_COOLDOWN = 0.15
local CachedGunDrops = {}
local LastCacheUpdate = 0
local CACHE_UPDATE_INTERVAL = 0.5

local function IsGunDrop(obj)
    if not obj then return false end
    if not (obj:IsA("Model") or obj:IsA("BasePart") or obj:IsA("Tool")) then return false end
    local name = obj.Name:lower()
    if name == "gundrop" or name:find("gundrop") then return true end
    if name == "knifedrop" or name:find("knifedrop") then return true end
    if name == "droppedgun" or name == "dropped_gun" then return true end
    return false
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
    local newCache = {}
    local seen = {}
    for _, obj in pairs(workspace:GetChildren()) do
        if IsGunDrop(obj) and not seen[obj] then
            seen[obj] = true
            if not IsMineOrInHands(obj, myChar) then
                table.insert(newCache, obj)
            end
        end
    end
    local foldersToCheck = {"DroppedItems", "Items", "Drops", "Weapons", "Objects", "Map", "ItemsFolder", "ToolDrops"}
    for _, folderName in ipairs(foldersToCheck) do
        local folder = workspace:FindFirstChild(folderName)
        if folder then
            for _, obj in pairs(folder:GetDescendants()) do
                if IsGunDrop(obj) and not seen[obj] then
                    seen[obj] = true
                    if not IsMineOrInHands(obj, myChar) then
                        table.insert(newCache, obj)
                    end
                end
            end
        end
    end
    for _, child in pairs(workspace:GetChildren()) do
        if child:IsA("Folder") or child:IsA("Model") then
            for _, obj in pairs(child:GetChildren()) do
                if IsGunDrop(obj) and not seen[obj] then
                    seen[obj] = true
                    if not IsMineOrInHands(obj, myChar) then
                        table.insert(newCache, obj)
                    end
                end
            end
        end
    end
    CachedGunDrops = newCache
    LastCacheUpdate = tick()
end

local function TeleportGunToMe(gunDrop, myRoot)
    if not gunDrop or not myRoot then return false end
    local targetCFrame = CFrame.new(myRoot.Position + Vector3.new(0, -2.5, 0))
    local moved = false
    if gunDrop:IsA("Model") then
        for _, part in pairs(gunDrop:GetDescendants()) do
            if part:IsA("BasePart") then
                if part.Anchored then pcall(function() part.Anchored = false end) end
                if part.CanCollide then pcall(function() part.CanCollide = false end) end
            end
        end
        pcall(function()
            gunDrop:PivotTo(targetCFrame)
            moved = true
        end)
    elseif gunDrop:IsA("BasePart") then
        if gunDrop.Anchored then pcall(function() gunDrop.Anchored = false end) end
        local ok = pcall(function()
            gunDrop.CFrame = targetCFrame
            gunDrop.Velocity = Vector3.zero
        end)
        if ok then moved = true end
    end
    return moved
end

local function FindNearestGunFromCache()
    local char = LocalPlayer.Character
    if not char or not char:FindFirstChild("HumanoidRootPart") then return nil end
    local myPos = char.HumanoidRootPart.Position
    local nearest = nil
    local nearestDist = math.huge
    for _, obj in ipairs(CachedGunDrops) do
        if obj and obj.Parent then
            local pos = nil
            if obj:IsA("Model") then
                local primary = obj.PrimaryPart or obj:FindFirstChildWhichIsA("BasePart")
                if primary then pos = primary.Position end
            elseif obj:IsA("BasePart") then
                pos = obj.Position
            elseif obj:IsA("Tool") then
                local h = obj:FindFirstChild("Handle")
                if h and h:IsA("BasePart") then pos = h.Position end
            end
            if pos then
                local dist = (pos - myPos).Magnitude
                if dist < nearestDist then
                    nearestDist = dist
                    nearest = obj
                end
            end
        end
    end
    return nearest
end

local function ToggleAutoGunLooter(enabled)
    if not HasAccess("premium") then return end
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
            if now - LastCacheUpdate > CACHE_UPDATE_INTERVAL then
                UpdateGunDropCache()
            end
            local gun = FindNearestGunFromCache()
            if gun then
                LastLootTime = now
                TeleportGunToMe(gun, myRoot)
            end
        end)
    else
        if GunLooterConnection then
            GunLooterConnection:Disconnect()
            GunLooterConnection = nil
        end
        CachedGunDrops = {}
    end
end

local KillAllRunning = false

local function GetKnifeTool(char)
    for _, tool in pairs(char:GetChildren()) do
        if tool:IsA("Tool") then
            local n = tool.Name:lower()
            if n:find("knife") or n:find("sword") or n:find("blade") or n:find("dagger") or n:find("darksword") then
                return tool
            end
        end
    end
    return nil
end

local function GetTargetsForKillAll()
    local targets = {}
    for _, player in pairs(Players:GetPlayers()) do
        if player ~= LocalPlayer then
            local info = PlayerData[player.Name]
            if info and type(info) == "table" then
                if info.Dead ~= true and info.Role and info.Role ~= "" then
                    local char = player.Character
                    if char then
                        local h = char:FindFirstChildOfClass("Humanoid")
                        local root = char:FindFirstChild("HumanoidRootPart")
                        if h and root and h.Health > 0 then
                            table.insert(targets, { player = player, root = root, char = char })
                        end
                    end
                end
            end
        end
    end
    return targets
end

local function RunKillAll()
    if not HasAccess("premium") then return end
    if KillAllRunning then return end
    KillAllRunning = true
    pcall(function()
        local char = LocalPlayer.Character
        if not char then return end
        local myRoot = char:FindFirstChild("HumanoidRootPart")
        if not myRoot then return end
        local originalCFrame = myRoot.CFrame
        local knife = GetKnifeTool(char)
        if not knife then return end
        local targets = GetTargetsForKillAll()
        for _, target in ipairs(targets) do
            if not Settings.KillAll then break end
            if target.root and target.root.Parent then
                local h = target.char:FindFirstChildOfClass("Humanoid")
                if h and h.Health > 0 then
                    myRoot.CFrame = target.root.CFrame + Vector3.new(0, 3, 0)
                    task.wait(0.08)
                    myRoot.CFrame = CFrame.lookAt(myRoot.Position, target.root.Position)
                    pcall(function() knife:Activate() end)
                    task.wait(0.15)
                end
            end
        end
        if myRoot and myRoot.Parent then
            myRoot.CFrame = originalCFrame
        end
    end)
    KillAllRunning = false
end

local function ToggleKillAll(enabled)
    if not HasAccess("premium") then return end
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

local ChooseMapRunning = false

local function FindAllVotePads()
    local pads = {}
    local lobby = workspace:FindFirstChild("RegularLobby")
    local root = lobby or workspace
    for _, obj in pairs(root:GetChildren()) do
        if obj.Name:match("^VotePad%d+$") then
            table.insert(pads, obj)
        end
    end
    return pads
end

local function GetMapNameFromPad(votePad)
    local mapInfoGui = votePad:FindFirstChild("MapInfoGui")
    if not mapInfoGui then return nil end
    local gameMode = mapInfoGui:FindFirstChild("GameMode")
    if gameMode and gameMode:IsA("TextLabel") then
        local text = gameMode.Text
        if text and text ~= "" then
            return text
        end
    end
    for _, obj in pairs(mapInfoGui:GetDescendants()) do
        if obj:IsA("TextLabel") and obj.Text ~= "" then
            return obj.Text
        end
    end
    return nil
end

local function GetPadPart(votePad)
    local pad = votePad:FindFirstChild("Pad")
    if pad then
        if pad:IsA("BasePart") then return pad end
        if pad:IsA("Model") then
            return pad.PrimaryPart or pad:FindFirstChildWhichIsA("BasePart")
        end
    end
    return votePad:FindFirstChildWhichIsA("BasePart")
end

local function GetAvailableMaps()
    local result = {}
    local votePads = FindAllVotePads()
    for _, pad in ipairs(votePads) do
        local mapName = GetMapNameFromPad(pad)
        if mapName then
            result[mapName] = pad
        end
    end
    return result
end

local function RespawnSelf()
    local char = LocalPlayer.Character
    if char then
        local h = char:FindFirstChildOfClass("Humanoid")
        if h then
            h.Health = 0
        end
    end
end

local function VoteOnPad(votePad)
    if not votePad or not votePad.Parent then return false end
    local padPart = GetPadPart(votePad)
    if not padPart then return false end
    local char = LocalPlayer.Character
    if not char then return false end
    local root = char:FindFirstChild("HumanoidRootPart")
    if not root then return false end
    root.CFrame = CFrame.new(padPart.Position + Vector3.new(0, 3, 0))
    root.Velocity = Vector3.zero
    return true
end

local function Start100ChooseMap(mapName)
    if ChooseMapRunning then return end
    ChooseMapRunning = true
    task.spawn(function()
        for i = 1, 20 do
            if not Settings.ChooseMap100 then break end
            local maps = GetAvailableMaps()
            local targetPad = maps[mapName]
            if targetPad then
                VoteOnPad(targetPad)
                task.wait(0.4)
            end
            RespawnSelf()
            task.wait(0.8)
        end
        ChooseMapRunning = false
        Settings.ChooseMap100 = false
    end)
end

local function OpenChooseMapSelector()
    local existing = ScreenGui:FindFirstChild("ChooseMapSelector")
    if existing then existing:Destroy() end
    
    local frame = Instance.new("Frame")
    frame.Name = "ChooseMapSelector"
    frame.Size = UDim2.new(0, 320, 0, 420)
    frame.Position = UDim2.new(0.5, -160, 0.5, -210)
    frame.BackgroundColor3 = Color3.fromRGB(22, 22, 28)
    frame.BorderSizePixel = 0
    frame.ZIndex = 50
    frame.Active = true
    frame.Draggable = true
    frame.Parent = ScreenGui
    
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 10)
    corner.Parent = frame
    
    local stroke = Instance.new("UIStroke")
    stroke.Color = Colors.AccentBlue
    stroke.Thickness = 1.5
    stroke.Parent = frame
    
    local title = Instance.new("TextLabel")
    title.Size = UDim2.new(1, -40, 0, 30)
    title.Position = UDim2.new(0, 15, 0, 10)
    title.BackgroundTransparency = 1
    title.Text = "Выбор карты — 100ChooseMap"
    title.TextColor3 = Colors.Text
    title.Font = Enum.Font.GothamBold
    title.TextSize = 13
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = frame
    
    local closeBtn = Instance.new("TextButton")
    closeBtn.Size = UDim2.new(0, 25, 0, 25)
    closeBtn.Position = UDim2.new(1, -32, 0, 12)
    closeBtn.BackgroundColor3 = Color3.fromRGB(220, 50, 50)
    closeBtn.BorderSizePixel = 0
    closeBtn.Text = "X"
    closeBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    closeBtn.Font = Enum.Font.GothamBold
    closeBtn.TextSize = 12
    closeBtn.Parent = frame
    
    local closeCorner = Instance.new("UICorner")
    closeCorner.CornerRadius = UDim.new(0, 5)
    closeCorner.Parent = closeBtn
    
    closeBtn.MouseButton1Click:Connect(function()
        frame:Destroy()
    end)
    
    local hint = Instance.new("TextLabel")
    hint.Size = UDim2.new(1, -30, 0, 20)
    hint.Position = UDim2.new(0, 15, 0, 45)
    hint.BackgroundTransparency = 1
    hint.Text = "Стоя на плите — обнови список карт"
    hint.TextColor3 = Colors.TextDim
    hint.Font = Enum.Font.Gotham
    hint.TextSize = 11
    hint.TextXAlignment = Enum.TextXAlignment.Left
    hint.Parent = frame
    
    local refreshBtn = Instance.new("TextButton")
    refreshBtn.Size = UDim2.new(1, -30, 0, 30)
    refreshBtn.Position = UDim2.new(0, 15, 0, 70)
    refreshBtn.BackgroundColor3 = Colors.AccentBlue
    refreshBtn.BorderSizePixel = 0
    refreshBtn.Text = "ОБНОВИТЬ СПИСОК КАРТ"
    refreshBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    refreshBtn.Font = Enum.Font.GothamBold
    refreshBtn.TextSize = 11
    refreshBtn.Parent = frame
    
    local refreshCorner = Instance.new("UICorner")
    refreshCorner.CornerRadius = UDim.new(0, 6)
    refreshCorner.Parent = refreshBtn
    
    local scroll = Instance.new("ScrollingFrame")
    scroll.Size = UDim2.new(1, -30, 1, -120)
    scroll.Position = UDim2.new(0, 15, 0, 110)
    scroll.BackgroundTransparency = 1
    scroll.BorderSizePixel = 0
    scroll.ScrollBarThickness = 4
    scroll.ScrollBarImageColor3 = Colors.AccentBlue
    scroll.CanvasSize = UDim2.new(0, 0, 0, 0)
    scroll.Parent = frame
    
    local list = Instance.new("UIListLayout")
    list.SortOrder = Enum.SortOrder.LayoutOrder
    list.Padding = UDim.new(0, 5)
    list.Parent = scroll
    
    local function PopulateMaps()
        for _, child in pairs(scroll:GetChildren()) do
            if child:IsA("TextButton") then child:Destroy() end
        end
        local maps = GetAvailableMaps()
        local yPos = 0
        for mapName, pad in pairs(maps) do
            local btn = Instance.new("TextButton")
            btn.Size = UDim2.new(1, 0, 0, 35)
            btn.BackgroundColor3 = Color3.fromRGB(35, 35, 42)
            btn.BorderSizePixel = 0
            btn.Text = mapName
            btn.TextColor3 = Colors.Text
            btn.Font = Enum.Font.GothamSemibold
            btn.TextSize = 12
            btn.AutoButtonColor = false
            btn.Parent = scroll
            local btnCorner = Instance.new("UICorner")
            btnCorner.CornerRadius = UDim.new(0, 5)
            btnCorner.Parent = btn
            btn.MouseButton1Click:Connect(function()
                Settings.SelectedMap = mapName
                Settings.ChooseMap100 = true
                Start100ChooseMap(mapName)
                frame:Destroy()
            end)
            yPos = yPos + 40
        end
        if yPos == 0 then
            local empty = Instance.new("TextLabel")
            empty.Size = UDim2.new(1, 0, 0, 30)
            empty.BackgroundTransparency = 1
            empty.Text = "Карты не найдены. Встань на плиту голосования."
            empty.TextColor3 = Colors.TextDim
            empty.Font = Enum.Font.Gotham
            empty.TextSize = 11
            empty.TextWrapped = true
            empty.Parent = scroll
            yPos = 40
        end
        scroll.CanvasSize = UDim2.new(0, 0, 0, yPos)
    end
    
    refreshBtn.MouseButton1Click:Connect(PopulateMaps)
    PopulateMaps()
end

local function Toggle100ChooseMap(enabled)
    Settings.ChooseMap100 = enabled
    if enabled then
        OpenChooseMapSelector()
    else
        Settings.ChooseMap100 = false
    end
end

local FlyBV = nil
local FlyBG = nil
local FlyConnection = nil

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
        FlyBV.Name = "FlyBV"
        FlyBV.MaxForce = Vector3.new(1e5, 1e5, 1e5)
        FlyBV.P = 1250
        FlyBV.Velocity = Vector3.zero
        FlyBV.Parent = root
        FlyBG = Instance.new("BodyGyro")
        FlyBG.Name = "FlyBG"
        FlyBG.MaxTorque = Vector3.new(1e6, 1e6, 1e6)
        FlyBG.P = 3000
        FlyBG.D = 500
        FlyBG.CFrame = root.CFrame
        FlyBG.Parent = root
        FlyConnection = RunService.RenderStepped:Connect(function()
            if not Settings.Fly then return end
            if not root or not root.Parent then return end
            if not FlyBV or not FlyBG then return end
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
                if part:IsA("BasePart") and part.CanCollide then
                    part.CanCollide = false
                end
            end
        end)
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = false
                end
            end
        end
    else
        if NoClipConnection then
            NoClipConnection:Disconnect()
            NoClipConnection = nil
        end
        local char = LocalPlayer.Character
        if char then
            for _, part in pairs(char:GetDescendants()) do
                if part:IsA("BasePart") then
                    part.CanCollide = true
                end
            end
        end
    end
end

local function ToggleLockMouse(enabled)
    Settings.LockMouse = enabled
    if enabled then
        UserInputService.MouseBehavior = Enum.MouseBehavior.LockCenter
    else
        UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    end
end

local FOVCircle = Drawing.new("Circle")
FOVCircle.Thickness = 2
FOVCircle.Radius = 100
FOVCircle.Color = Color3.fromRGB(150, 100, 255)
FOVCircle.Transparency = 0.8
FOVCircle.Visible = false
FOVCircle.Filled = false

local AimBotConnection
local function IsVisible(targetPart)
    if not Settings.AimBotWallCheck then return true end
    local origin = Camera.CFrame.Position
    local dir = (targetPart.Position - origin)
    local params = RaycastParams.new()
    params.FilterType = Enum.RaycastFilterType.Exclude
    params.FilterDescendantsInstances = {LocalPlayer.Character, targetPart.Parent}
    local result = workspace:Raycast(origin, dir, params)
    return result == nil
end

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
                        if Settings.AimBotOnlyMurderer then
                            if GetPlayerRole(player) ~= "Murderer" then skip = true end
                        end
                        if not skip then
                            if IsVisible(rp) then
                                local sp, onScreen = Camera:WorldToScreenPoint(rp.Position)
                                if onScreen then
                                    local d = (Vector2.new(sp.X, sp.Y) - Vector2.new(Camera.ViewportSize.X/2, Camera.ViewportSize.Y/2)).Magnitude
                                    if d < closest then closest = d target = rp end
                                end
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

local AllCards = {}

local function ApplyCardGradient(card)
    local cardGradient = Instance.new("UIGradient")
    cardGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(90, 130, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(160, 90, 255)),
    })
    cardGradient.Rotation = 0
    cardGradient.Transparency = NumberSequence.new({
        NumberSequenceKeypoint.new(0, 0.75),
        NumberSequenceKeypoint.new(1, 0.75),
    })
    cardGradient.Parent = card
end

local function ApplyLockOverlay(card)
    local darkOverlay = Instance.new("Frame")
    darkOverlay.Size = UDim2.new(1, 0, 1, 0)
    darkOverlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    darkOverlay.BackgroundTransparency = 0.5
    darkOverlay.BorderSizePixel = 0
    darkOverlay.ZIndex = 5
    darkOverlay.Parent = card
    local overlayCorner = Instance.new("UICorner")
    overlayCorner.CornerRadius = UDim.new(0, 8)
    overlayCorner.Parent = darkOverlay
    local lockBanner = Instance.new("Frame")
    lockBanner.Size = UDim2.new(1, 0, 0, 26)
    lockBanner.Position = UDim2.new(0, 0, 0.5, -13)
    lockBanner.BackgroundColor3 = Color3.fromRGB(200, 30, 30)
    lockBanner.BackgroundTransparency = 0.1
    lockBanner.BorderSizePixel = 0
    lockBanner.ZIndex = 6
    lockBanner.Parent = card
    local bannerGradient = Instance.new("UIGradient")
    bannerGradient.Color = ColorSequence.new({
        ColorSequenceKeypoint.new(0, Color3.fromRGB(220, 40, 40)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 100, 60)),
    })
    bannerGradient.Rotation = 0
    bannerGradient.Parent = lockBanner
    local lockText = Instance.new("TextLabel")
    lockText.Size = UDim2.new(1, 0, 1, 0)
    lockText.BackgroundTransparency = 1
    lockText.Text = "🔒 НЕТУ ДОСТУПА"
    lockText.TextColor3 = Color3.fromRGB(255, 255, 255)
    lockText.Font = Enum.Font.GothamBlack
    lockText.TextSize = 11
    lockText.ZIndex = 7
    lockText.Parent = lockBanner
end

local function CreateCard(category, name, defaultState, callback, accessLevel)
    local hasAccess = HasAccess(accessLevel)
    local isLocked = not hasAccess
    local card = Instance.new("Frame")
    card.Name = name .. "_Card"
    card.BackgroundColor3 = Colors.CardBackground
    card.BackgroundTransparency = Colors.CardTransparency
    card.BorderSizePixel = 0
    card.Visible = false
    card.Parent = CardsScroll
    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 8)
    cardCorner.Parent = card
    ApplyCardGradient(card)
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
    local switchCorner = Instance.new("UICorner")
    switchCorner.CornerRadius = UDim.new(1, 0)
    switchCorner.Parent = Switch
    local Knob = Instance.new("Frame")
    Knob.Size = UDim2.new(0, 16, 0, 16)
    Knob.Position = UDim2.new(0, 2, 0.5, -8)
    Knob.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Knob.BorderSizePixel = 0
    Knob.Parent = Switch
    local knobCorner = Instance.new("UICorner")
    knobCorner.CornerRadius = UDim.new(1, 0)
    knobCorner.Parent = Knob
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
        Switch.MouseButton1Click:Connect(function()
            local originalPos = card.Position
            for i = 1, 3 do
                card.Position = originalPos + UDim2.new(0, 5, 0, 0)
                task.wait(0.03)
                card.Position = originalPos - UDim2.new(0, 5, 0, 0)
                task.wait(0.03)
            end
            card.Position = originalPos
        end)
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
    local hasAccess = HasAccess(accessLevel)
    local isLocked = not hasAccess
    local card = Instance.new("Frame")
    card.Name = name .. "_Card"
    card.BackgroundColor3 = Colors.CardBackground
    card.BackgroundTransparency = Colors.CardTransparency
    card.BorderSizePixel = 0
    card.Visible = false
    card.Parent = CardsScroll
    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 8)
    cardCorner.Parent = card
    ApplyCardGradient(card)
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
    local slCorner = Instance.new("UICorner")
    slCorner.CornerRadius = UDim.new(1, 0)
    slCorner.Parent = SliderBtn
    local Fill = Instance.new("Frame")
    Fill.Size = UDim2.new((default-min)/(max-min), 0, 1, 0)
    Fill.BackgroundColor3 = Colors.AccentBlue
    Fill.BorderSizePixel = 0
    Fill.Parent = SliderBtn
    local fillCorner = Instance.new("UICorner")
    fillCorner.CornerRadius = UDim.new(1, 0)
    fillCorner.Parent = Fill
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
    local hasAccess = HasAccess(accessLevel)
    local isLocked = not hasAccess
    local card = Instance.new("Frame")
    card.Name = name .. "_Card"
    card.BackgroundColor3 = Colors.CardBackground
    card.BackgroundTransparency = Colors.CardTransparency
    card.BorderSizePixel = 0
    card.Visible = false
    card.Parent = CardsScroll
    local cardCorner = Instance.new("UICorner")
    cardCorner.CornerRadius = UDim.new(0, 8)
    cardCorner.Parent = card
    ApplyCardGradient(card)
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
    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 5)
    bCorner.Parent = BindBtn
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

CreateCard("Main", "AutoGunLooter", false, ToggleAutoGunLooter, "premium")
CreateCard("Main", "KillAll", false, ToggleKillAll, "premium")
CreateCard("ChooseMap", "100 Choose Map", false, Toggle100ChooseMap, "admin")
CreateCard("Legit", "AimBot", false, ToggleAimBot)
CreateCard("Legit", "AimBot Only Murderer", false, function(s) Settings.AimBotOnlyMurderer = s end)
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
CreateCard("Visuals", "Ambience", false, function(s)
    Settings.Ambience = s
    if s then
        ApplySkybox(Settings.AmbienceType)
    else
        RemoveSkybox()
    end
end)
CreateSliderCard("Visuals", "Ambience Type (1-5)", 1, 5, 1, function(v)
    local types = {"Day", "Night", "Evening", "Sunset", "Anime"}
    Settings.AmbienceType = types[math.clamp(math.floor(v), 1, 5)]
    if Settings.Ambience then ApplySkybox(Settings.AmbienceType) end
end)
CreateCard("Visuals", "Shaders", false, ToggleShaders)
CreateSliderCard("Visuals", "Shader Mode (1=Blur 2=Ultra)", 1, 2, 1, function(v)
    Settings.ShaderMode = math.clamp(math.floor(v), 1, 2)
    SetShaderModeByNumber(Settings.ShaderMode)
end)
CreateCard("Visuals", "Aura", false, ToggleAura)
CreateSliderCard("Visuals", "Aura Type (1=Fire 2=Ice 3=Bolt)", 1, 3, 1, function(v)
    Settings.AuraType = math.clamp(math.floor(v), 1, 3)
    if Settings.Aura then RefreshAura() end
end)
CreateCard("Visuals", "Particles", false, ToggleParticles)

CreateCard("WebHook", "MurderNotification", false, function(s)
    Settings.MurderNotification = s
    if not s then NotifiedPlayers.Murderer = {} end
end)
CreateCard("WebHook", "SheriffNotification", false, function(s)
    Settings.SheriffNotification = s
    if not s then NotifiedPlayers.Sheriff = {} end
end)

CreateBindCard("Binds", "Fly Key", function(key) Settings.FlyKey = key end)
CreateBindCard("Binds", "NoClip Key", function(key) Settings.NoClipKey = key end)
CreateBindCard("Binds", "AimBot Key", function(key) Settings.AimBotKey = key end)
CreateBindCard("Binds", "Lock Mouse Key", function(key) Settings.LockMouseKey = key end)

local CurrentCategory = "Main"
local CategoryButtons = {}

local function SetCategoryVisibility(cat, searchQuery)
    searchQuery = (searchQuery or ""):lower()
    for _, card in pairs(AllCards) do
        if card.category == cat then
            if searchQuery == "" or card.name:lower():find(searchQuery, 1, true) then
                card.frame.Visible = true
            else
                card.frame.Visible = false
            end
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
    local bCorner = Instance.new("UICorner")
    bCorner.CornerRadius = UDim.new(0, 6)
    bCorner.Parent = btn
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

CreateCategoryButton("Main")
CreateCategoryButton("ChooseMap")
CreateCategoryButton("Legit")
CreateCategoryButton("Rage")
CreateCategoryButton("Visuals")
CreateCategoryButton("WebHook")
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
BlurEffect.Name = "MegolaHub_Blur"
BlurEffect.Size = 0
BlurEffect.Parent = Lighting

local function SetBlur(amount)
    TweenService:Create(BlurEffect, TweenInfo.new(0.35, Enum.EasingStyle.Quart), {Size = amount}):Play()
end

local isOpen = false
local isAnimating = false

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
    SetBlur(12)
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
    SetBlur(0)
    task.wait(0.3)
    MainFrame.Visible = false
    isAnimating = false
end

ExitButton.MouseButton1Click:Connect(CloseGUI)

UserInputService.InputBegan:Connect(function(input, gp)
    if gp then return end
    if input.KeyCode == Enum.KeyCode.RightShift then
        if isOpen then CloseGUI() else OpenGUI() end
    end
end)

print("MegolaHub PREMIUM загружен! Нажмите RightShift для открытия GUI.")
