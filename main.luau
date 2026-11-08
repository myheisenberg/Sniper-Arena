local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local HttpService = game:GetService("HttpService")
local CoreGui = game:GetService("CoreGui")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local SERVICE_SLUG = "zynexscripts"
local SAVE_PATH = "SniperArena_Key.txt"
local DEFAULT_DISCORD = "https://discord.gg/ehbX2MVbTw"
local VSS_URL = "https://vault.pandauth.com/vss/918acd524004d8b1"

local PandaAuth = (function()
    local ok, lib = pcall(function()
        local src = game:HttpGet("https://secure.pandauth.com/pv4/lib")
        return loadstring(src)()
    end)
    if ok and type(lib) == "table" and type(lib.configure) == "function" then
        lib.configure({serviceId = SERVICE_SLUG, debug = false, kickOnDetect = false})
        return lib
    end
    return nil
end)()

local discordUrl = DEFAULT_DISCORD
pcall(function()
    local fetched = game:HttpGetAsync("https://raw.githubusercontent.com/myheisenberg/Fluent-Renewed/main/discord.txt")
    if fetched and fetched:find("discord.gg") then
        discordUrl = fetched:match("^%s*(.-)%s*$")
    end
end)

local function CheckWhitelist(key)
    if not key or key == "" then return false end
    key = string.gsub(key, "^%s*(.-)%s*$", "%1")
    if not PandaAuth then return false end
    local ok, res = pcall(function()
        return PandaAuth.validate(key)
    end)
    if ok and res and res.success == true then
        return true
    end
    return false
end

local function GetKeyURL()
    if PandaAuth then
        local ok, url = pcall(function() return PandaAuth.getKeyUrl() end)
        if ok and url and url ~= "" then return url end
    end
    return "https://ads.pandauth.com/getkey/" .. SERVICE_SLUG
end

local function LaunchMainScript()
    loadstring(game:HttpGet(VSS_URL))()
end

local function CreateKeyModal(onSuccess)
    if isfile and readfile and isfile(SAVE_PATH) then
        local savedKey = nil
        pcall(function() savedKey = readfile(SAVE_PATH) end)
        if savedKey and savedKey ~= "" then
            if CheckWhitelist(savedKey) then
                onSuccess()
                return
            end
        end
    end

    for _, name in ipairs({"Platoboost_AuthModal", "SniperArena_AuthModal", "Zynex_AuthModal"}) do
        local old = (gethui and gethui():FindFirstChild(name)) or CoreGui:FindFirstChild(name)
        if old then old:Destroy() end
        local oldRoblox = CoreGui:FindFirstChild("RobloxGui") and CoreGui.RobloxGui:FindFirstChild(name)
        if oldRoblox then oldRoblox:Destroy() end
    end

    local parent = (gethui and gethui()) or CoreGui:FindFirstChild("RobloxGui") or CoreGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "Zynex_AuthModal"
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    ScreenGui.Parent = parent

    local Overlay = Instance.new("TextButton")
    Overlay.Name = "Overlay"
    Overlay.Text = ""
    Overlay.AutoButtonColor = false
    Overlay.Size = UDim2.fromScale(1, 1)
    Overlay.BackgroundColor3 = Color3.fromRGB(0, 0, 0)
    Overlay.BackgroundTransparency = 0.55
    Overlay.BorderSizePixel = 0
    Overlay.Parent = ScreenGui

    local Card = Instance.new("Frame")
    Card.Name = "Card"
    Card.Size = UDim2.fromOffset(480, 255)
    Card.AnchorPoint = Vector2.new(0.5, 0.5)
    Card.Position = UDim2.fromScale(0.5, 0.5)
    Card.BackgroundTransparency = 1
    Card.BorderSizePixel = 0
    Card.Parent = ScreenGui

    local Shadow = Instance.new("ImageLabel")
    Shadow.Name = "Shadow"
    Shadow.AnchorPoint = Vector2.new(0.5, 0.5)
    Shadow.Position = UDim2.fromScale(0.5, 0.5)
    Shadow.Size = UDim2.new(1, 110, 1, 110)
    Shadow.BackgroundTransparency = 1
    Shadow.Image = "rbxassetid://8992230677"
    Shadow.ImageColor3 = Color3.fromRGB(0, 0, 0)
    Shadow.ImageTransparency = 0.5
    Shadow.ScaleType = Enum.ScaleType.Slice
    Shadow.SliceCenter = Rect.new(99, 99, 99, 99)
    Shadow.ZIndex = 1
    Shadow.Parent = Card

    local Background = Instance.new("Frame")
    Background.Name = "Background"
    Background.Size = UDim2.fromScale(1, 1)
    Background.BackgroundColor3 = Color3.fromRGB(36, 36, 42)
    Background.BackgroundTransparency = 0.22
    Background.BorderSizePixel = 0
    Background.ZIndex = 2
    Background.Parent = Card

    local BgCorner = Instance.new("UICorner")
    BgCorner.CornerRadius = UDim.new(0, 8)
    BgCorner.Parent = Background

    local GradientFrame = Instance.new("Frame")
    GradientFrame.Name = "Gradient"
    GradientFrame.Size = UDim2.fromScale(1, 1)
    GradientFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    GradientFrame.BackgroundTransparency = 0.75
    GradientFrame.BorderSizePixel = 0
    GradientFrame.ZIndex = 2
    GradientFrame.Parent = Card

    local GradCorner = Instance.new("UICorner")
    GradCorner.CornerRadius = UDim.new(0, 8)
    GradCorner.Parent = GradientFrame

    local Grad = Instance.new("UIGradient")
    Grad.Rotation = 90
    Grad.Color = ColorSequence.new(Color3.fromRGB(48, 48, 54), Color3.fromRGB(24, 24, 28))
    Grad.Parent = GradientFrame

    local Noise = Instance.new("ImageLabel")
    Noise.Name = "Noise"
    Noise.Size = UDim2.fromScale(1, 1)
    Noise.BackgroundTransparency = 1
    Noise.Image = "rbxassetid://9968344227"
    Noise.ImageTransparency = 0.94
    Noise.ScaleType = Enum.ScaleType.Tile
    Noise.TileSize = UDim2.new(0, 128, 0, 128)
    Noise.ZIndex = 2
    Noise.Parent = Card

    local NoiseCorner = Instance.new("UICorner")
    NoiseCorner.CornerRadius = UDim.new(0, 8)
    NoiseCorner.Parent = Noise

    local BorderFrame = Instance.new("Frame")
    BorderFrame.Name = "Border"
    BorderFrame.Size = UDim2.fromScale(1, 1)
    BorderFrame.BackgroundTransparency = 1
    BorderFrame.ZIndex = 4
    BorderFrame.Parent = Card

    local BorderCorner = Instance.new("UICorner")
    BorderCorner.CornerRadius = UDim.new(0, 8)
    BorderCorner.Parent = BorderFrame

    local BorderStroke = Instance.new("UIStroke")
    BorderStroke.Color = Color3.fromRGB(90, 90, 95)
    BorderStroke.Transparency = 0.5
    BorderStroke.Thickness = 1
    BorderStroke.Parent = BorderFrame

    local TopLine = Instance.new("Frame")
    TopLine.Name = "TopLine"
    TopLine.Size = UDim2.new(1, -16, 0, 1)
    TopLine.Position = UDim2.fromOffset(8, 0)
    TopLine.BackgroundColor3 = Color3.fromRGB(96, 205, 255)
    TopLine.BackgroundTransparency = 0.4
    TopLine.BorderSizePixel = 0
    TopLine.ZIndex = 5
    TopLine.Parent = Card

    local Header = Instance.new("Frame")
    Header.Name = "Header"
    Header.Size = UDim2.new(1, 0, 0, 52)
    Header.BackgroundTransparency = 1
    Header.ZIndex = 5
    Header.Parent = Card

    local Icon = Instance.new("ImageLabel")
    Icon.Name = "Icon"
    Icon.Size = UDim2.fromOffset(22, 22)
    Icon.Position = UDim2.fromOffset(20, 16)
    Icon.BackgroundTransparency = 1
    Icon.Image = "rbxassetid://118976126805967"
    Icon.ImageRectOffset = Vector2.new(320, 64)
    Icon.ImageRectSize = Vector2.new(64, 64)
    Icon.ImageColor3 = Color3.fromRGB(96, 205, 255)
    Icon.ZIndex = 5
    Icon.Parent = Header

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Text = "Sniper Arena Hub"
    Title.Font = Enum.Font.GothamBold
    Title.TextSize = 16
    Title.TextColor3 = Color3.fromRGB(245, 245, 245)
    Title.TextXAlignment = Enum.TextXAlignment.Left
    Title.BackgroundTransparency = 1
    Title.Position = UDim2.fromOffset(50, 12)
    Title.Size = UDim2.new(1, -60, 0, 18)
    Title.AutoLocalize = false
    Title.ZIndex = 5
    Title.Parent = Header

    local SubTitle = Instance.new("TextLabel")
    SubTitle.Name = "SubTitle"
    SubTitle.Text = "Authentication | by zynex"
    SubTitle.Font = Enum.Font.Gotham
    SubTitle.TextSize = 12
    SubTitle.TextColor3 = Color3.fromRGB(175, 175, 180)
    SubTitle.TextXAlignment = Enum.TextXAlignment.Left
    SubTitle.BackgroundTransparency = 1
    SubTitle.Position = UDim2.fromOffset(50, 31)
    SubTitle.Size = UDim2.new(1, -60, 0, 14)
    SubTitle.AutoLocalize = false
    SubTitle.ZIndex = 5
    SubTitle.Parent = Header

    local Body = Instance.new("Frame")
    Body.Name = "Body"
    Body.Size = UDim2.new(1, -40, 0, 115)
    Body.Position = UDim2.fromOffset(20, 58)
    Body.BackgroundTransparency = 1
    Body.ZIndex = 5
    Body.Parent = Card

    local InputFrame = Instance.new("Frame")
    InputFrame.Name = "InputFrame"
    InputFrame.Size = UDim2.new(1, 0, 0, 38)
    InputFrame.Position = UDim2.fromOffset(0, 6)
    InputFrame.BackgroundColor3 = Color3.fromRGB(48, 48, 54)
    InputFrame.BackgroundTransparency = 0.2
    InputFrame.BorderSizePixel = 0
    InputFrame.ZIndex = 5
    InputFrame.Parent = Body

    local InputCorner = Instance.new("UICorner")
    InputCorner.CornerRadius = UDim.new(0, 4)
    InputCorner.Parent = InputFrame

    local InputStroke = Instance.new("UIStroke")
    InputStroke.Color = Color3.fromRGB(75, 75, 82)
    InputStroke.Transparency = 0.6
    InputStroke.Thickness = 1
    InputStroke.Parent = InputFrame

    local TextBox = Instance.new("TextBox")
    TextBox.Name = "Input"
    TextBox.PlaceholderText = "Paste key here..."
    TextBox.PlaceholderColor3 = Color3.fromRGB(150, 150, 155)
    TextBox.Text = ""
    TextBox.Font = Enum.Font.Gotham
    TextBox.TextSize = 13
    TextBox.TextColor3 = Color3.fromRGB(245, 245, 245)
    TextBox.TextXAlignment = Enum.TextXAlignment.Left
    TextBox.ClearTextOnFocus = false
    TextBox.BackgroundTransparency = 1
    TextBox.Size = UDim2.new(1, -24, 1, 0)
    TextBox.Position = UDim2.fromOffset(12, 0)
    TextBox.AutoLocalize = false
    TextBox.ZIndex = 6
    TextBox.Parent = InputFrame

    local Indicator = Instance.new("Frame")
    Indicator.Name = "Indicator"
    Indicator.Size = UDim2.new(1, -4, 0, 1)
    Indicator.Position = UDim2.new(0, 2, 1, -1)
    Indicator.BackgroundColor3 = Color3.fromRGB(145, 145, 150)
    Indicator.BackgroundTransparency = 0.5
    Indicator.BorderSizePixel = 0
    Indicator.ZIndex = 6
    Indicator.Parent = InputFrame

    TextBox.Focused:Connect(function()
        TweenService:Create(InputFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(38, 38, 44), BackgroundTransparency = 0.1}):Play()
        TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(96, 205, 255), BackgroundTransparency = 0, Size = UDim2.new(1, -2, 0, 2)}):Play()
    end)

    TextBox.FocusLost:Connect(function()
        TweenService:Create(InputFrame, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(48, 48, 54), BackgroundTransparency = 0.2}):Play()
        TweenService:Create(Indicator, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(145, 145, 150), BackgroundTransparency = 0.5, Size = UDim2.new(1, -4, 0, 1)}):Play()
    end)

    local StatusLabel = Instance.new("TextLabel")
    StatusLabel.Name = "Status"
    StatusLabel.Text = "Click \"Get Key\" to copy the verification link."
    StatusLabel.Font = Enum.Font.Gotham
    StatusLabel.TextSize = 12
    StatusLabel.TextColor3 = Color3.fromRGB(155, 155, 160)
    StatusLabel.TextXAlignment = Enum.TextXAlignment.Left
    StatusLabel.BackgroundTransparency = 1
    StatusLabel.Position = UDim2.fromOffset(2, 50)
    StatusLabel.Size = UDim2.new(1, -4, 0, 20)
    StatusLabel.AutoLocalize = false
    StatusLabel.ZIndex = 5
    StatusLabel.Parent = Body

    local BottomBar = Instance.new("Frame")
    BottomBar.Name = "BottomBar"
    BottomBar.Size = UDim2.new(1, 0, 0, 58)
    BottomBar.Position = UDim2.new(0, 0, 1, -58)
    BottomBar.BackgroundColor3 = Color3.fromRGB(30, 30, 34)
    BottomBar.BackgroundTransparency = 0.2
    BottomBar.BorderSizePixel = 0
    BottomBar.ZIndex = 5
    BottomBar.Parent = Card

    local BottomCorner = Instance.new("UICorner")
    BottomCorner.CornerRadius = UDim.new(0, 8)
    BottomCorner.Parent = BottomBar

    local BottomCover = Instance.new("Frame")
    BottomCover.Name = "Cover"
    BottomCover.Size = UDim2.new(1, 0, 0, 8)
    BottomCover.Position = UDim2.new(0, 0, 0, 0)
    BottomCover.BackgroundColor3 = Color3.fromRGB(30, 30, 34)
    BottomCover.BackgroundTransparency = 0.2
    BottomCover.BorderSizePixel = 0
    BottomCover.ZIndex = 5
    BottomCover.Parent = BottomBar

    local BottomLine = Instance.new("Frame")
    BottomLine.Name = "Sep"
    BottomLine.Size = UDim2.new(1, 0, 0, 1)
    BottomLine.Position = UDim2.new(0, 0, 0, 0)
    BottomLine.BackgroundColor3 = Color3.fromRGB(60, 60, 66)
    BottomLine.BackgroundTransparency = 0.4
    BottomLine.BorderSizePixel = 0
    BottomLine.ZIndex = 6
    BottomLine.Parent = BottomBar

    local DiscordBtn = Instance.new("TextButton")
    DiscordBtn.Name = "DiscordBtn"
    DiscordBtn.Text = "Discord"
    DiscordBtn.Font = Enum.Font.GothamBold
    DiscordBtn.TextSize = 14
    DiscordBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    DiscordBtn.Size = UDim2.fromOffset(88, 34)
    DiscordBtn.Position = UDim2.fromOffset(20, 12)
    DiscordBtn.BackgroundColor3 = Color3.fromRGB(88, 101, 242)
    DiscordBtn.BackgroundTransparency = 0.1
    DiscordBtn.AutoButtonColor = false
    DiscordBtn.AutoLocalize = false
    DiscordBtn.ZIndex = 7
    DiscordBtn.Parent = BottomBar

    local DiscordCorner = Instance.new("UICorner")
    DiscordCorner.CornerRadius = UDim.new(0, 4)
    DiscordCorner.Parent = DiscordBtn

    local DiscordStroke = Instance.new("UIStroke")
    DiscordStroke.Color = Color3.fromRGB(114, 137, 218)
    DiscordStroke.Transparency = 0.4
    DiscordStroke.Thickness = 1
    DiscordStroke.Parent = DiscordBtn

    DiscordBtn.MouseEnter:Connect(function()
        TweenService:Create(DiscordBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(105, 118, 245), BackgroundTransparency = 0}):Play()
    end)
    DiscordBtn.MouseLeave:Connect(function()
        TweenService:Create(DiscordBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(88, 101, 242), BackgroundTransparency = 0.1}):Play()
    end)

    DiscordBtn.MouseButton1Click:Connect(function()
        if setclipboard then
            setclipboard(discordUrl)
            StatusLabel.Text = "Discord invite copied to clipboard! (" .. discordUrl .. ")"
            StatusLabel.TextColor3 = Color3.fromRGB(114, 137, 218)
        else
            StatusLabel.Text = discordUrl
            StatusLabel.TextColor3 = Color3.fromRGB(240, 200, 80)
        end
    end)

    local RightHolder = Instance.new("Frame")
    RightHolder.Name = "RightHolder"
    RightHolder.Size = UDim2.new(0, 260, 0, 34)
    RightHolder.Position = UDim2.new(1, -280, 0, 12)
    RightHolder.BackgroundTransparency = 1
    RightHolder.ZIndex = 6
    RightHolder.Parent = BottomBar

    local RightLayout = Instance.new("UIListLayout")
    RightLayout.FillDirection = Enum.FillDirection.Horizontal
    RightLayout.HorizontalAlignment = Enum.HorizontalAlignment.Right
    RightLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    RightLayout.Padding = UDim.new(0, 10)
    RightLayout.Parent = RightHolder

    local GetKeyBtn = Instance.new("TextButton")
    GetKeyBtn.Name = "GetKeyBtn"
    GetKeyBtn.Text = "Get Key"
    GetKeyBtn.Font = Enum.Font.GothamMedium
    GetKeyBtn.TextSize = 13
    GetKeyBtn.TextColor3 = Color3.fromRGB(235, 235, 240)
    GetKeyBtn.Size = UDim2.fromOffset(125, 34)
    GetKeyBtn.BackgroundColor3 = Color3.fromRGB(48, 48, 54)
    GetKeyBtn.BackgroundTransparency = 0.1
    GetKeyBtn.AutoButtonColor = false
    GetKeyBtn.AutoLocalize = false
    GetKeyBtn.ZIndex = 7
    GetKeyBtn.Parent = RightHolder

    local GetKeyCorner = Instance.new("UICorner")
    GetKeyCorner.CornerRadius = UDim.new(0, 4)
    GetKeyCorner.Parent = GetKeyBtn

    local GetKeyStroke = Instance.new("UIStroke")
    GetKeyStroke.Color = Color3.fromRGB(75, 75, 82)
    GetKeyStroke.Transparency = 0.6
    GetKeyStroke.Thickness = 1
    GetKeyStroke.Parent = GetKeyBtn

    GetKeyBtn.MouseEnter:Connect(function()
        TweenService:Create(GetKeyBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(62, 62, 70)}):Play()
    end)
    GetKeyBtn.MouseLeave:Connect(function()
        TweenService:Create(GetKeyBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(48, 48, 54)}):Play()
    end)

    GetKeyBtn.MouseButton1Click:Connect(function()
        local url = GetKeyURL()
        if setclipboard then
            setclipboard(url)
            StatusLabel.Text = "Key link copied to clipboard! Complete checkpoint in browser."
            StatusLabel.TextColor3 = Color3.fromRGB(96, 205, 255)
        else
            StatusLabel.Text = "Link: " .. url
            StatusLabel.TextColor3 = Color3.fromRGB(240, 200, 80)
        end
    end)

    local VerifyBtn = Instance.new("TextButton")
    VerifyBtn.Name = "VerifyBtn"
    VerifyBtn.Text = "Verify Key"
    VerifyBtn.Font = Enum.Font.GothamBold
    VerifyBtn.TextSize = 14
    VerifyBtn.TextColor3 = Color3.fromRGB(255, 255, 255)
    VerifyBtn.Size = UDim2.fromOffset(115, 34)
    VerifyBtn.BackgroundColor3 = Color3.fromRGB(0, 120, 212)
    VerifyBtn.BackgroundTransparency = 0
    VerifyBtn.AutoButtonColor = false
    VerifyBtn.AutoLocalize = false
    VerifyBtn.ZIndex = 7
    VerifyBtn.Parent = RightHolder

    local VerifyCorner = Instance.new("UICorner")
    VerifyCorner.CornerRadius = UDim.new(0, 4)
    VerifyCorner.Parent = VerifyBtn

    local VerifyStroke = Instance.new("UIStroke")
    VerifyStroke.Color = Color3.fromRGB(96, 205, 255)
    VerifyStroke.Transparency = 0.6
    VerifyStroke.Thickness = 1
    VerifyStroke.Parent = VerifyBtn

    VerifyBtn.MouseEnter:Connect(function()
        TweenService:Create(VerifyBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(16, 137, 230)}):Play()
    end)
    VerifyBtn.MouseLeave:Connect(function()
        TweenService:Create(VerifyBtn, TweenInfo.new(0.15), {BackgroundColor3 = Color3.fromRGB(0, 120, 212)}):Play()
    end)

    local verifying = false
    VerifyBtn.MouseButton1Click:Connect(function()
        if verifying then return end
        local entered = TextBox.Text
        if not entered or entered == "" then
            StatusLabel.Text = "Please paste your key into the text field first."
            StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
            return
        end

        verifying = true
        VerifyBtn.Text = "Checking..."
        StatusLabel.Text = "Validating key with PandaAuth..."
        StatusLabel.TextColor3 = Color3.fromRGB(180, 180, 185)

        task.spawn(function()
            local valid = CheckWhitelist(entered)
            if valid then
                StatusLabel.Text = "Key verified successfully! Loading script..."
                StatusLabel.TextColor3 = Color3.fromRGB(100, 255, 120)
                if writefile then
                    pcall(function() writefile(SAVE_PATH, entered) end)
                end
                task.wait(0.6)
                ScreenGui:Destroy()
                onSuccess()
            else
                StatusLabel.Text = "Invalid or expired key. Please get a new key."
                StatusLabel.TextColor3 = Color3.fromRGB(255, 100, 100)
                VerifyBtn.Text = "Verify Key"
                verifying = false
            end
        end)
    end)

    local dragging, dragInput, dragStart, startPos
    Card.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            dragging = true
            dragStart = input.Position
            startPos = Card.Position
            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then dragging = false end
            end)
        end
    end)
    Card.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            dragInput = input
        end
    end)
    UserInputService.InputChanged:Connect(function(input)
        if input == dragInput and dragging then
            local delta = input.Position - dragStart
            Card.Position = UDim2.new(startPos.X.Scale, startPos.X.Offset + delta.X, startPos.Y.Scale, startPos.Y.Offset + delta.Y)
        end
    end)
end

CreateKeyModal(LaunchMainScript)
