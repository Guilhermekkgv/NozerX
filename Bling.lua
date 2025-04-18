local TweenService = game:GetService("TweenService")
local InputService = game:GetService("UserInputService")
local RunService = game:GetService("RunService")
local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer

local Linux = {
    Theme = {
        Background = Color3.fromRGB(24, 24, 24),
        Element = Color3.fromRGB(28, 28, 28),
        Accent = Color3.fromRGB(80, 120, 255),
        Text = Color3.fromRGB(180, 180, 180),
        Toggle = Color3.fromRGB(40, 40, 40),
        TabInactive = Color3.fromRGB(28, 28, 28),
        DropdownOption = Color3.fromRGB(30, 30, 30)
    }
}

function Linux.Instance(class, props)
    local inst = Instance.new(class)
    for k, v in pairs(props or {}) do
        inst[k] = v
    end
    return inst
end

function Linux:SafeCallback(Function, ...)
    if not Function then
        return
    end

    local Success, Error = pcall(Function, ...)
    if not Success then
        self:Notify({
            Title = "Callback Error",
            Content = tostring(Error),
            Duration = 5
        })
    end
end

function Linux:Notify(config)
    local isMobile = InputService.TouchEnabled and not InputService.KeyboardEnabled
    local notificationWidth = isMobile and 200 or 300
    local notificationHeight = config.SubContent and 80 or 60
    local startPosX = isMobile and 10 or 20

    local NotificationHolder = Linux.Instance("ScreenGui", {
        Name = "NotificationHolder",
        Parent = RunService:IsStudio() and LocalPlayer.PlayerGui or game:GetService("CoreGui"),
        ResetOnSpawn = false,
        Enabled = true,
        ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    })

    local Notification = Linux.Instance("Frame", {
        Parent = NotificationHolder,
        BackgroundColor3 = Linux.Theme.Background,
        Size = UDim2.new(0, notificationWidth, 0, notificationHeight),
        Position = UDim2.new(1, 10, 1, -notificationHeight - 10),
        ZIndex = 100
    })

    Linux.Instance("UICorner", {
        Parent = Notification,
        CornerRadius = UDim.new(0, 5)
    })

    local Gradient = Linux.Instance("UIGradient", {
        Parent = Notification,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Linux.Theme.Background),
            ColorSequenceKeypoint.new(1, Linux.Theme.Element)
        }),
        Rotation = 45
    })

    local TitleLabel = Linux.Instance("TextLabel", {
        Parent = Notification,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -10, 0, 20),
        Position = UDim2.new(0, 5, 0, 5),
        Font = Enum.Font.SourceSansBold,
        Text = config.Title or "Notification",
        TextColor3 = Linux.Theme.Text,
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        ZIndex = 101
    })

    local ContentLabel = Linux.Instance("TextLabel", {
        Parent = Notification,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, -10, 0, 20),
        Position = UDim2.new(0, 5, 0, 25),
        Font = Enum.Font.SourceSans,
        Text = config.Content or "Content",
        TextColor3 = Linux.Theme.Text,
        TextSize = 14,
        TextWrapped = true,
        TextXAlignment = Enum.TextXAlignment.Left,
        TextYAlignment = Enum.TextYAlignment.Top,
        ZIndex = 101
    })

    if config.SubContent then
        local SubContentLabel = Linux.Instance("TextLabel", {
            Parent = Notification,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -10, 0, 20),
            Position = UDim2.new(0, 5, 0, 45),
            Font = Enum.Font.SourceSans,
            Text = config.SubContent,
            TextColor3 = Color3.fromRGB(150, 150, 150),
            TextSize = 12,
            TextWrapped = true,
            TextXAlignment = Enum.TextXAlignment.Left,
            TextYAlignment = Enum.TextYAlignment.Top,
            ZIndex = 101
        })
    end

    local tweenInfo = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
    TweenService:Create(Notification, tweenInfo, {Position = UDim2.new(0, startPosX, 1, -notificationHeight - 10)}):Play()

    if config.Duration then
        task.delay(config.Duration, function()
            TweenService:Create(Notification, tweenInfo, {Position = UDim2.new(1, 10, 1, -notificationHeight - 10)}):Play()
            task.wait(0.5)
            NotificationHolder:Destroy()
        end)
    end
end

function Linux.Create(config)
    local randomName = "UI_" .. tostring(math.random(100000, 999999))

    for _, v in pairs(game.CoreGui:GetChildren()) do
        if v:IsA("ScreenGui") and v.Name:match("^UI_%d+$") then
            v:Destroy()
        end
    end

    local ProtectGui = protectgui or (syn and syn.protect_gui) or function() end

    local LinuxUI = Linux.Instance("ScreenGui", {
        Name = randomName,
        Parent = RunService:IsStudio() and LocalPlayer.PlayerGui or game:GetService("CoreGui"),
        ResetOnSpawn = false,
        Enabled = true
    })

    ProtectGui(LinuxUI)

    local FakeUI = Instance.new("ScreenGui", game:GetService("CoreGui"))
    FakeUI.Name = "FakeUI"
    FakeUI.Enabled = false
    FakeUI.ResetOnSpawn = false

    local tabWidth = config.TabWidth or 110

    local isMobile = InputService.TouchEnabled and not InputService.KeyboardEnabled
    local uiSize = isMobile and (config.SizeMobile or UDim2.fromOffset(495, 345)) or (config.SizePC or UDim2.fromOffset(600, 400))

    local IntroFrame = Linux.Instance("Frame", {
        Parent = LinuxUI,
        BackgroundColor3 = Linux.Theme.Background,
        Size = uiSize,
        Position = UDim2.new(0.5, -uiSize.X.Offset / 2, 0.5, -uiSize.Y.Offset / 2),
        ZIndex = 1000
    })

    Linux.Instance("UICorner", {
        Parent = IntroFrame,
        CornerRadius = UDim.new(0, 5)
    })

    local Gradient = Linux.Instance("UIGradient", {
        Parent = IntroFrame,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 24)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40))
        }),
        Rotation = 45
    })

    spawn(function()
        while IntroFrame.Parent do
            local tween = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            TweenService:Create(Gradient, tween, {Offset = Vector2.new(1, 0)}):Play()
            wait(2)
            TweenService:Create(Gradient, tween, {Offset = Vector2.new(-1, 0)}):Play()
            wait(2)
        end
    end)

    local IntroTitle = Linux.Instance("TextLabel", {
        Parent = IntroFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 50),
        Position = UDim2.new(0, 0, 0, 80),
        Font = Enum.Font.SourceSansBold,
        Text = config.Name or "Linux UI",
        TextColor3 = Linux.Theme.Text,
        TextSize = 36,
        TextTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 1001
    })

    spawn(function()
        while IntroTitle.Parent do
            local pulse = TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut)
            TweenService:Create(IntroTitle, pulse, {TextSize = 38}):Play()
            wait(0.8)
            TweenService:Create(IntroTitle, pulse, {TextSize = 36}):Play()
            wait(0.8)
        end
    end)

    local WelcomeText = Linux.Instance("TextLabel", {
        Parent = IntroFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 30),
        Position = UDim2.new(0, 0, 0, 130),
        Font = Enum.Font.SourceSans,
        Text = "Welcome, " .. LocalPlayer.Name,
        TextColor3 = Linux.Theme.Text,
        TextSize = 20,
        TextTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 1001
    })

    local ParticleContainer = Linux.Instance("Frame", {
        Parent = IntroFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 1002
    })

    spawn(function()
        for i = 1, 15 do
            local Particle = Linux.Instance("Frame", {
                Parent = ParticleContainer,
                BackgroundColor3 = Linux.Theme.Accent,
                Size = UDim2.new(0, 4, 0, 4),
                Position = UDim2.new(math.random(), 0, math.random(), 0),
                ZIndex = 1003
            })

            Linux.Instance("UICorner", {
                Parent = Particle,
                CornerRadius = UDim.new(1, 0)
            })

            spawn(function()
                while Particle.Parent do
                    local move = TweenInfo.new(math.random(2, 4), Enum.EasingStyle.Sine)
                    TweenService:Create(Particle, move, {
                        Position = UDim2.new(math.random(), 0, math.random(), 0),
                        BackgroundTransparency = math.random(0.3, 0.7)
                    }):Play()
                    wait(math.random(2, 4))
                end
            end)
        end
    end)

    local WaveContainer = Linux.Instance("Frame", {
        Parent = IntroFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.6, 0, 0, 40),
        Position = UDim2.new(0.2, 0, 0.65, 0),
        ZIndex = 1001
    })

    local waveLines = {}
    for i = 1, 20 do
        local WaveLine = Linux.Instance("Frame", {
            Parent = WaveContainer,
            BackgroundColor3 = Linux.Theme.Accent,
            Size = UDim2.new(0, 4, 0, 10),
            Position = UDim2.new((i - 1) / 20, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            ZIndex = 1002
        })

        Linux.Instance("UICorner", {
            Parent = WaveLine,
            CornerRadius = UDim.new(1, 0)
        })

        waveLines[i] = WaveLine
    end

    local ProgressText = Linux.Instance("TextLabel", {
        Parent = IntroFrame,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 0, 20),
        Position = UDim2.new(0, 0, 0.8, 0),
        Font = Enum.Font.SourceSansBold,
        Text = "Loading... 0%",
        TextColor3 = Linux.Theme.Text,
        TextSize = 16,
        TextTransparency = 1,
        TextXAlignment = Enum.TextXAlignment.Center,
        ZIndex = 1001
    })

    local Glow = Linux'system
    Linux.Instance("ImageLabel", {
        Parent = ProgressText,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 20, 1, 20),
        Position = UDim2.new(-0.05, 0, -0.5, 0),
        Image = "rbxassetid://243098098",
        ImageColor3 = Linux.Theme.Accent,
        ImageTransparency = 0.8,
        ScaleType = Enum.ScaleType.Slice,
        ZIndex = 1000
    })

    local Main = Linux.Instance("Frame", {
        Parent = LinuxUI,
        BackgroundColor3 = Linux.Theme.Background,
        Size = uiSize,
        Position = UDim2.new(0.5, -uiSize.X.Offset / 2, 0.5, -uiSize.Y.Offset / 2),
        Active = true,
        Draggable = true,
        ZIndex = 1,
        Visible = false
    })

    Linux.Instance("UICorner", {
        Parent = Main,
        CornerRadius = UDim.new(0, 8)
    })

    local MainGradient = Linux.Instance("UIGradient", {
        Parent = Main,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Color3.fromRGB(24, 24, 24)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40))
        }),
        Rotation = 45
    })

    spawn(function()
        while Main.Parent do
            local tween = TweenInfo.new(3, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            TweenService:Create(MainGradient, tween, {Offset = Vector2.new(1, 0)}):Play()
            wait(3)
            TweenService:Create(MainGradient, tween, {Offset = Vector2.new(-1, 0)}):Play()
            wait(3)
        end
    end)

    local BackgroundParticles = Linux.Instance("Frame", {
        Parent = Main,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 0
    })

    spawn(function()
        for i = 1, 10 do
            local Particle = Linux.Instance("Frame", {
                Parent = BackgroundParticles,
                BackgroundColor3 = Linux.Theme.Accent,
                Size = UDim2.new(0, 3, 0, 3),
                Position = UDim2.new(math.random(), 0, math.random(), 0),
                ZIndex = 0
            })

            Linux.Instance("UICorner", {
                Parent = Particle,
                CornerRadius = UDim.new(1, 0)
            })

            spawn(function()
                while Particle.Parent do
                    local move = TweenInfo.new(math.random(3, 5), Enum.EasingStyle.Sine)
                    TweenService:Create(Particle, move, {
                        Position = UDim2.new(math.random(), 0, math.random(), 0),
                        BackgroundTransparency = math.random(0.5, 0.9)
                    }):Play()
                    wait(math.random(3, 5))
                end
            end)
        end
    end)

    local TopBar = Linux.Instance("Frame", {
        Parent = Main,
        BackgroundColor3 = Linux.Theme.Element,
        Size = UDim2.new(1, 0, 0, 25),
        ZIndex = 2
    })

    Linux.Instance("UICorner", {
        Parent = TopBar,
        CornerRadius = UDim.new(0, 8)
    })

    local TopBarGradient = Linux.Instance("UIGradient", {
        Parent = TopBar,
        Color = ColorSequence.new({
            ColorSequenceKeypoint.new(0, Linux.Theme.Element),
            ColorSequenceKeypoint.new(1, Linux.Theme.Background)
        }),
        Rotation = 45
    })

    local Title = Linux.Instance("TextLabel", {
        Parent = TopBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(0.8, -10, 1, 0),
        Position = UDim2.new(0, 5, 0, 0),
        Font = Enum.Font.SourceSansBold,
        Text = config.Name or "Linux UI",
        TextColor3 = Color3.fromRGB(255, 255, 255),
        TextSize = 16,
        TextXAlignment = Enum.TextXAlignment.Left,
        ZIndex = 2
    })

    local MinimizeButton = Linux.Instance("TextButton", {
        Parent = TopBar,
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -45, 0, 2),
        ZIndex = 3,
        AutoButtonColor = false
    })

    Linux.Instance("UICorner", {
        Parent = MinimizeButton,
        CornerRadius = UDim.new(1, 0)
    })

    local MinimizeGlow = Linux.Instance("ImageLabel", {
        Parent = MinimizeButton,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 10, 1, 10),
        Position = UDim2.new(-0.25, 0, -0.25, 0),
        Image = "rbxassetid://243098098",
        ImageColor3 = Linux.Theme.Accent,
        ImageTransparency = 1,
        ScaleType = Enum.ScaleType.Slice,
        ZIndex = 2
    })

    local MinimizeIcon = Linux.Instance("ImageLabel", {
        Parent = MinimizeButton,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0.5, -8, 0.5, -8),
        Image = "rbxassetid://10734895698",
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        ZIndex = 3
    })

    local CloseButton = Linux.Instance("TextButton", {
        Parent = TopBar,
        BackgroundColor3 = Color3.fromRGB(40, 40, 40),
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -20, 0, 2),
        ZIndex = 3,
        AutoButtonColor = false
    })

    Linux.Instance("UICorner", {
        Parent = CloseButton,
        CornerRadius = UDim.new(1, 0)
    })

    local CloseGlow = Linux.Instance("ImageLabel", {
        Parent = CloseButton,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 10, 1, 10),
        Position = UDim2.new(-0.25, 0, -0.25, 0),
        Image = "rbxassetid://243098098",
        ImageColor3 = Linux.Theme.Accent,
        ImageTransparency = 1,
        ScaleType = Enum.ScaleType.Slice,
        ZIndex = 2
    })

    local CloseIcon = Linux.Instance("ImageLabel", {
        Parent = CloseButton,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 16, 0, 16),
        Position = UDim2.new(0.5, -8, 0.5, -8),
        Image = "rbxassetid://10747384394",
        ImageColor3 = Color3.fromRGB(255, 255, 255),
        ZIndex = 3
    })

    MinimizeButton.MouseEnter:Connect(function()
        TweenService:Create(MinimizeGlow, TweenInfo.new(0.2), {ImageTransparency = 0.5}):Play()
    end)

    MinimizeButton.MouseLeave:Connect(function()
        TweenService:Create(MinimizeGlow, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
    end)

    CloseButton.MouseEnter:Connect(function()
        TweenService:Create(CloseGlow, TweenInfo.new(0.2), {ImageTransparency = 0.5}):Play()
    end)

    CloseButton.MouseLeave:Connect(function()
        TweenService:Create(CloseGlow, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
    end)

    local TabsBar = Linux.Instance("Frame", {
        Parent = Main,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, 0, 0, 25),
        Size = UDim2.new(0, tabWidth, 1, -25),
        ZIndex = 2
    })

    local TabHolder = Linux.Instance("ScrollingFrame", {
        Parent = TabsBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        CanvasSize = UDim2.new(0, 0, 0, 0),
        AutomaticCanvasSize = Enum.AutomaticSize.Y,
        ScrollBarThickness = 0,
        ZIndex = 2
    })

    local TabLayout = Linux.Instance("UIListLayout", {
        Parent = TabHolder,
        Padding = UDim.new(0, 3),
        HorizontalAlignment = Enum.HorizontalAlignment.Left,
        VerticalAlignment = Enum.VerticalAlignment.Top,
        SortOrder = Enum.SortOrder.LayoutOrder
    })

    local TabPadding = Linux.Instance("UIPadding", {
        Parent = TabHolder,
        PaddingLeft = UDim.new(0, 5),
        PaddingTop = UDim.new(0, 5)
    })

    local Content = Linux.Instance("Frame", {
        Parent = Main,
        BackgroundTransparency = 1,
        Position = UDim2.new(0, tabWidth, 0, 25),
        Size = UDim2.new(1, -tabWidth, 1, -25),
        ZIndex = 1
    })

    local isMinimized = false
    local originalSize = Main.Size
    local originalPos = Main.Position
    local isHidden = false

    MinimizeButton.MouseButton1Click:Connect(function()
        local tweenInfo = TweenInfo.new(0.3, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        if not isMinimized then
            TweenService:Create(Main, tweenInfo, {Size = UDim2.new(0, 200, 0, 25), Position = UDim2.new(0.5, -100, 0, 0)}):Play()
            TabsBar.Visible = false
            Content.Visible = false
            MinimizeIcon.Image = "rbxassetid://10734886735"
            isMinimized = true
        else
            TweenService:Create(Main, tweenInfo, {Size = originalSize, Position = originalPos}):Play()
            TabsBar.Visible = true
            Content.Visible = true
            MinimizeIcon.Image = "rbxassetid://10734895698"
            isMinimized = false
        end
    end)

    CloseButton.MouseButton1Click:Connect(function()
        LinuxUI:Destroy()
        FakeUI:Destroy()
    end)

    InputService.InputBegan:Connect(function(input)
        if input.KeyCode == Enum.KeyCode.LeftAlt then
            isHidden = not isHidden
            Main.Visible = not isHidden
        end
    end)

    local LinuxLib = {}
    local Tabs = {}
    local CurrentTab = nil
    local tabOrder = 0
    local totalElements = 0

    function LinuxLib.Tab(config)
        tabOrder = tabOrder + 1
        local tabIndex = tabOrder

        local TabBtn = Linux.Instance("TextButton", {
            Parent = TabHolder,
            BackgroundColor3 = Linux.Theme.TabInactive,
            Size = UDim2.new(1, -5, 0, 28),
            Font = Enum.Font.SourceSans,
            Text = "",
            TextColor3 = Linux.Theme.Text,
            TextSize = 14,
            ZIndex = 2,
            AutoButtonColor = false,
            LayoutOrder = tabIndex
        })

        Linux.Instance("UICorner", {
            Parent = TabBtn,
            CornerRadius = UDim.new(0, 6)
        })

        local TabGradient = Linux.Instance("UIGradient", {
            Parent = TabBtn,
            Color = ColorSequence.new({
                ColorSequenceKeypoint.new(0, Linux.Theme.TabInactive),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40))
            }),
            Rotation = 45
        })

        local TabGlow = Linux.Instance("ImageLabel", {
            Parent = TabBtn,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 10, 1, 10),
            Position = UDim2.new(-0.05, 0, -0.05, 0),
            Image = "rbxassetid://243098098",
            ImageColor3 = Linux.Theme.Accent,
            ImageTransparency = 1,
            ScaleType = Enum.ScaleType.Slice,
            ZIndex = 1
        })

        local TabIcon
        if config.Icon and config.Icon.Enabled then
            TabIcon = Linux.Instance("ImageLabel", {
                Parent = TabBtn,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(0, 5, 0.5, -8),
                Image = config.Icon.Image or "rbxassetid://10747384394",
                ImageColor3 = Color3.fromRGB(150, 150, 150),
                ZIndex = 2
            })
        end

        local TabText = Linux.Instance("TextLabel", {
            Parent = TabBtn,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, config.Icon and config.Icon.Enabled and -26 or -10, 1, 0),
            Position = UDim2.new(0, config.Icon and config.Icon.Enabled and 26 or 5, 0, 0),
            Font = Enum.Font.SourceSans,
            Text = config.Name,
            TextColor3 = Color3.fromRGB(150, 150, 150),
            TextSize = 14,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 2
        })

        local TabContent = Linux.Instance("ScrollingFrame", {
            Parent = Content,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            CanvasSize = UDim2.new(0, 0, 0, 0),
            AutomaticCanvasSize = Enum.AutomaticSize.Y,
            ScrollBarThickness = 0,
            Visible = false,
            ZIndex = 1
        })

        local TabTitle = Linux.Instance("TextLabel", {
            Parent = TabContent,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, -10, 0, 30),
            Position = UDim2.new(0, 5, 0, 0),
            Font = Enum.Font.SourceSansBold,
            Text = config.Name,
            TextColor3 = Color3.fromRGB(255, 255, 255),
            TextSize = 18,
            TextXAlignment = Enum.TextXAlignment.Left,
            ZIndex = 2
        })

        local ElementContainer = Linux.Instance("Frame", {
            Parent = TabContent,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, -30),
            Position = UDim2.new(0, 0, 0, 30),
            ZIndex = 1
        })

        local ContentLayout = Linux.Instance("UIListLayout", {
            Parent = ElementContainer,
            Padding = UDim.new(0, 4),
            HorizontalAlignment = Enum.HorizontalAlignment.Left,
            SortOrder = Enum.SortOrder.LayoutOrder
        })

        local ContentPadding = Linux.Instance("UIPadding", {
            Parent = ElementContainer,
            PaddingLeft = UDim.new(0, 5),
            PaddingTop = UDim.new(0, 5)
        })

        TabBtn.MouseButton1Click:Connect(function()
            for _, tab in pairs(Tabs) do
                tab.Content.Visible = false
                tab.Text.TextColor3 = Color3.fromRGB(150, 150, 150)
                if tab.Icon then
                    tab.Icon.ImageColor3 = Color3.fromRGB(150, 150, 150)
                end
                tab.Button.BackgroundTransparency = 0.2
                TweenService:Create(tab.Glow, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
                for _, child in pairs(tab.Content:GetChildren()) do
                    if child:IsA("Frame") or child:IsA("ScrollingFrame") then
                        TweenService:Create(child, TweenInfo.new(0.2), {BackgroundTransparency = child.BackgroundTransparency + 0.2}):Play()
                    end
                end
            end
            TabContent.Visible = true
            TabText.TextColor3 = Color3.fromRGB(255, 255, 255)
            if TabIcon then
                TabIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
            end
            TabBtn.BackgroundTransparency = 0
            TweenService:Create(TabGlow, TweenInfo.new(0.2), {ImageTransparency = 0.5}):Play()
            for _, child in pairs(TabContent:GetChildren()) do
                if child:IsA("Frame") or child:IsA("ScrollingFrame") then
                    TweenService:Create(child, TweenInfo.new(0.2), {BackgroundTransparency = child.BackgroundTransparency - 0.2}):Play()
                end
            end
            CurrentTab = tabIndex
        end)

        Tabs[tabIndex] = {
            Name = config.Name,
            Button = TabBtn,
            Text = TabText,
            Icon = TabIcon,
            Content = TabContent,
            Glow = TabGlow
        }

        if not CurrentTab then
            TabContent.Visible = true
            TabText.TextColor3 = Color3.fromRGB(255, 255, 255)
            if TabIcon then
                TabIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
            end
            TabBtn.BackgroundTransparency = 0
            TweenService:Create(TabGlow, TweenInfo.new(0.2), {ImageTransparency = 0.5}):Play()
            CurrentTab = tabIndex
        end

        local TabElements = {}
        local elementOrder = 0

        function TabElements.Button(config)
            elementOrder = elementOrder + 1
            totalElements = totalElements + 1
            local BtnFrame = Linux.Instance("Frame", {
                Parent = ElementContainer,
                BackgroundColor3 = Linux.Theme.Element,
                Size = UDim2.new(1, -5, 0, 30),
                ZIndex = 1,
                LayoutOrder = elementOrder
            })

            Linux.Instance("UICorner", {
                Parent = BtnFrame,
                CornerRadius = UDim.new(0, 6)
            })

            local BtnGradient = Linux.Instance("UIGradient", {
                Parent = BtnFrame,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Linux.Theme.Element),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40))
                }),
                Rotation = 45
            })

            local BtnGlow = Linux.Instance("ImageLabel", {
                Parent = BtnFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 10, 1, 10),
                Position = UDim2.new(-0.05, 0, -0.05, 0),
                Image = "rbxassetid://243098098",
                ImageColor3 = Linux.Theme.Accent,
                ImageTransparency = 1,
                ScaleType = Enum.ScaleType.Slice,
                ZIndex = 0
            })

            local Btn = Linux.Instance("TextButton", {
                Parent = BtnFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 0, 30),
                Position = UDim2.new(0, 0, 0, 0),
                Font = Enum.Font.SourceSans,
                Text = config.Name,
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 1,
                AutoButtonColor = false
            })

            local BtnPadding = Linux.Instance("UIPadding", {
                Parent = Btn,
                PaddingLeft = UDim.new(0, 5)
            })

            local BtnIcon = Linux.Instance("ImageLabel", {
                Parent = BtnFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 14, 0, 14),
                Position = UDim2.new(1, -20, 0.5, -7),
                Image = "rbxassetid://10709791437",
                ImageColor3 = Linux.Theme.Text,
                ZIndex = 1
            })

            Btn.MouseEnter:Connect(function()
                TweenService:Create(BtnGlow, TweenInfo.new(0.2), {ImageTransparency = 0.5}):Play()
            end)

            Btn.MouseLeave:Connect(function()
                TweenService:Create(BtnGlow, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
            end)

            Btn.MouseButton1Click:Connect(function()
                TweenService:Create(BtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Linux.Theme.Accent}):Play()
                spawn(function() Linux:SafeCallback(config.Callback) end)
                wait(0.1)
                TweenService:Create(BtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Linux.Theme.Element}):Play()
                TweenService:Create(BtnGradient, TweenInfo.new(0.1), {Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Linux.Theme.Element),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40))
                })}):Play()
            end)

            return Btn
        end

        function TabElements.Toggle(config)
            elementOrder = elementOrder + 1
            totalElements = totalElements + 1
            local Toggle = Linux.Instance("Frame", {
                Parent = ElementContainer,
                BackgroundColor3 = Linux.Theme.Element,
                Size = UDim2.new(1, -5, 0, 30),
                ZIndex = 1,
                LayoutOrder = elementOrder
            })

            Linux.Instance("UICorner", {
                Parent = Toggle,
                CornerRadius = UDim.new(0, 6)
            })

            local ToggleGradient = Linux.Instance("UIGradient", {
                Parent = Toggle,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Linux.Theme.Element),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40))
                }),
                Rotation = 45
            })

            local ToggleGlow = Linux.Instance("ImageLabel", {
                Parent = Toggle,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 10, 1, 10),
                Position = UDim2.new(-0.05, 0, -0.05, 0),
                Image = "rbxassetid://243098098",
                ImageColor3 = Linux.Theme.Accent,
                ImageTransparency = 1,
                ScaleType = Enum.ScaleType.Slice,
                ZIndex = 0
            })

            local Label = Linux.Instance("TextLabel", {
                Parent = Toggle,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.8, 0, 0, 30),
                Position = UDim2.new(0, 5, 0, 0),
                Font = Enum.Font.SourceSans,
                Text = config.Name,
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 1
            })

            local ToggleBox = Linux.Instance("Frame", {
                Parent = Toggle,
                BackgroundColor3 = Linux.Theme.Toggle,
                Size = UDim2.new(0, 40, 0, 20),
                Position = UDim2.new(1, -45, 0, 5),
                ZIndex = 1
            })

            Linux.Instance("UICorner", {
                Parent = ToggleBox,
                CornerRadius = UDim.new(1, 0)
            })

            local ToggleBoxGradient = Linux.Instance("UIGradient", {
                Parent = ToggleBox,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Linux.Theme.Toggle),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
                }),
                Rotation = 45
            })

            local ToggleFill = Linux.Instance("Frame", {
                Parent = ToggleBox,
                BackgroundColor3 = Linux.Theme.Toggle,
                Size = UDim2.new(0, 0, 1, 0),
                ZIndex = 1
            })

            Linux.Instance("UICorner", {
                Parent = ToggleFill,
                CornerRadius = UDim.new(1, 0)
            })

            local ToggleFillGradient = Linux.Instance("UIGradient", {
                Parent = ToggleFill,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Linux.Theme.Toggle),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
                }),
                Rotation = 45
            })

            local Knob = Linux.Instance("Frame", {
                Parent = ToggleBox,
                BackgroundColor3 = Color3.fromRGB(150, 150, 150),
                Size = UDim2.new(0, 16, 0, 16),
                Position = UDim2.new(0, 2, 0, 2),
                ZIndex = 2
            })

            Linux.Instance("UICorner", {
                Parent = Knob,
                CornerRadius = UDim.new(1, 0)
            })

            local KnobGradient = Linux.Instance("UIGradient", {
                Parent = Knob,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 150, 150)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
                }),
                Rotation = 45
            })

            local State = config.Default or false

            local function UpdateToggle()
                local tween = TweenInfo.new(0.2, Enum.EasingStyle.Quad)
                if State then
                    TweenService:Create(ToggleFill, tween, {BackgroundColor3 = Linux.Theme.Accent, Size = UDim2.new(1, 0, 1, 0)}):Play()
                    TweenService:Create(ToggleFillGradient, tween, {Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Linux.Theme.Accent),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 140, 255))
                    })}):Play()
                    TweenService:Create(Knob, tween, {Position = UDim2.new(1, -18, 0, 2), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                    TweenService:Create(KnobGradient, tween, {Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
                    })}):Play()
                else
                    TweenService:Create(ToggleFill, tween, {BackgroundColor3 = Linux.Theme.Toggle, Size = UDim2.new(0, 0, 1, 0)}):Play()
                    TweenService:Create(ToggleFillGradient, tween, {Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Linux.Theme.Toggle),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
                    })}):Play()
                    TweenService:Create(Knob, tween, {Position = UDim2.new(0, 2, 0, 2), BackgroundColor3 = Color3.fromRGB(150, 150, 150)}):Play()
                    TweenService:Create(KnobGradient, tween, {Color = ColorSequence.new({
                        ColorSequenceKeypoint.new(0, Color3.fromRGB(150, 150, 150)),
                        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
                    })}):Play()
                end
            end

            UpdateToggle()

            Toggle.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    State = not State
                    UpdateToggle()
                    TweenService:Create(ToggleGlow, TweenInfo.new(0.2), {ImageTransparency = 0.5}):Play()
                    spawn(function() Linux:SafeCallback(config.Callback, State) end)
                end
            end)

            Toggle.MouseEnter:Connect(function()
                TweenService:Create(ToggleGlow, TweenInfo.new(0.2), {ImageTransparency = 0.5}):Play()
            end)

            Toggle.MouseLeave:Connect(function()
                TweenService:Create(ToggleGlow, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
            end)

            return Toggle
        end

        function TabElements.Dropdown(config)
            elementOrder = elementOrder + 1
            totalElements = totalElements + 1
            local Dropdown = Linux.Instance("Frame", {
                Parent = ElementContainer,
                BackgroundColor3 = Linux.Theme.Element,
                Size = UDim2.new(1, -5, 0, 30),
                ZIndex = 2,
                LayoutOrder = elementOrder
            })

            Linux.Instance("UICorner", {
                Parent = Dropdown,
                CornerRadius = UDim.new(0, 6)
            })

            local DropdownGradient = Linux.Instance("UIGradient", {
                Parent = Dropdown,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Linux.Theme.Element),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40))
                }),
                Rotation = 45
            })

            local DropdownGlow = Linux.Instance("ImageLabel", {
                Parent = Dropdown,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 10, 1, 10),
                Position = UDim2.new(-0.05, 0, -0.05, 0),
                Image = "rbxassetid://243098098",
                ImageColor3 = Linux.Theme.Accent,
                ImageTransparency = 1,
                ScaleType = Enum.ScaleType.Slice,
                ZIndex = 1
            })

            local Label = Linux.Instance("TextLabel", {
                Parent = Dropdown,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.8, 0, 1, 0),
                Position = UDim2.new(0, 5, 0, 0),
                Font = Enum.Font.SourceSans,
                Text = config.Name,
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 2
            })

            local Selected = Linux.Instance("TextLabel", {
                Parent = Dropdown,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -40, 1, 0),
                Font = Enum.Font.SourceSans,
                Text = config.Default or (config.Options and config.Options[1]) or "None",
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right,
                ZIndex = 2
            })

            local Arrow = Linux.Instance("ImageLabel", {
                Parent = Dropdown,
                BackgroundTransparency = 1,
                Size = UDim2.new(0, 14, 0, 14),
                Position = UDim2.new(1, -20, 0.5, -7),
                Image = "rbxassetid://10709767827",
                ImageColor3 = Linux.Theme.Text,
                ZIndex = 2
            })

            local DropFrame = Linux.Instance("ScrollingFrame", {
                Parent = ElementContainer,
                BackgroundColor3 = Linux.Theme.Element,
                Size = UDim2.new(1, -5, 0, 0),
                CanvasSize = UDim2.new(0, 0, 0, 0),
                AutomaticCanvasSize = Enum.AutomaticSize.Y,
                ScrollBarThickness = 0,
                ClipsDescendants = true,
                ZIndex = 3,
                LayoutOrder = elementOrder + 1
            })

            Linux.Instance("UICorner", {
                Parent = DropFrame,
                CornerRadius = UDim.new(0, 6)
            })

            local DropFrameGradient = Linux.Instance("UIGradient", {
                Parent = DropFrame,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Linux.Theme.Element),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40))
                }),
                Rotation = 45
            })

            local DropLayout = Linux.Instance("UIListLayout", {
                Parent = DropFrame,
                Padding = UDim.new(0, 2),
                HorizontalAlignment = Enum.HorizontalAlignment.Left
            })

            local DropPadding = Linux.Instance("UIPadding", {
                Parent = DropFrame,
                PaddingLeft = UDim.new(0, 5),
                PaddingTop = UDim.new(0, 5)
            })

            local Options = config.Options or {}
            local IsOpen = false
            local SelectedValue = config.Default or (Options[1] or "None")

            local function UpdateDropSize()
                local optionHeight = 25
                local paddingBetween = 2
                local paddingTop = 5
                local maxHeight = 150
                local numOptions = #Options
                local calculatedHeight = numOptions * optionHeight + (numOptions - 1) * paddingBetween + paddingTop
                local finalHeight = math.min(calculatedHeight, maxHeight)
                if finalHeight < 0 then finalHeight = 0 end

                local tween = TweenInfo.new(0.2, Enum.EasingStyle.Quad)
                if IsOpen then
                    TweenService:Create(DropFrame, tween, {Size = UDim2.new(1, -5, 0, finalHeight)}):Play()
                    TweenService:Create(Arrow, tween, {Rotation = 180}):Play()
                else
                    TweenService:Create(DropFrame, tween, {Size = UDim2.new(1, -5, 0, 0)}):Play()
                    TweenService:Create(Arrow, tween, {Rotation = 0}):Play()
                end
                task.wait(0.2)
                TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y)
            end

            local function PopulateOptions()
                for _, child in pairs(DropFrame:GetChildren()) do
                    if child:IsA("TextButton") then
                        child:Destroy()
                    end
                end
                if IsOpen then
                    for _, opt in pairs(Options) do
                        local OptBtn = Linux.Instance("TextButton", {
                            Parent = DropFrame,
                            BackgroundColor3 = Linux.Theme.DropdownOption,
                            Size = UDim2.new(1, -5, 0, 25),
                            Font = Enum.Font.SourceSans,
                            Text = tostring(opt),
                            TextColor3 = opt == SelectedValue and Linux.Theme.Accent or Linux.Theme.Text,
                            TextSize = 14,
                            TextXAlignment = Enum.TextXAlignment.Left,
                            ZIndex = 3,
                            AutoButtonColor = false
                        })

                        Linux.Instance("UICorner", {
                            Parent = OptBtn,
                            CornerRadius = UDim.new(0, 4)
                        })

                        local OptGradient = Linux.Instance("UIGradient", {
                            Parent = OptBtn,
                            Color = ColorSequence.new({
                                ColorSequenceKeypoint.new(0, Linux.Theme.DropdownOption),
                                ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40))
                            }),
                            Rotation = 45
                        })

                        local OptGlow = Linux.Instance("ImageLabel", {
                            Parent = OptBtn,
                            BackgroundTransparency = 1,
                            Size = UDim2.new(1, 10, 1, 10),
                            Position = UDim2.new(-0.05, 0, -0.05, 0),
                            Image = "rbxassetid://243098098",
                            ImageColor3 = Linux.Theme.Accent,
                            ImageTransparency = 1,
                            ScaleType = Enum.ScaleType.Slice,
                            ZIndex = 2
                        })

                        OptBtn.MouseEnter:Connect(function()
                            TweenService:Create(OptGlow, TweenInfo.new(0.2), {ImageTransparency = 0.5}):Play()
                        end)

                        OptBtn.MouseLeave:Connect(function()
                            TweenService:Create(OptGlow, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
                        end)

                        OptBtn.MouseButton1Click:Connect(function()
                            SelectedValue = opt
                            Selected.Text = tostring(opt)
                            for _, btn in pairs(DropFrame:GetChildren()) do
                                if btn:IsA("TextButton") then
                                    btn.TextColor3 = btn.Text == tostring(opt) and Linux.Theme.Accent or Linux.Theme.Text
                                end
                            end
                            spawn(function() Linux:SafeCallback(config.Callback, opt) end)
                        end)
                    end
                end
                UpdateDropSize()
            end

            if #Options > 0 then
                PopulateOptions()
            end

            Dropdown.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    IsOpen = not IsOpen
                    PopulateOptions()
                    TweenService:Create(DropdownGlow, TweenInfo.new(0.2), {ImageTransparency = IsOpen and 0.5 or 1}):Play()
                end
            end)

            Dropdown.MouseEnter:Connect(function()
                TweenService:Create(DropdownGlow, TweenInfo.new(0.2), {ImageTransparency = 0.5}):Play()
            end)

            Dropdown.MouseLeave:Connect(function()
                if not IsOpen then
                    TweenService:Create(DropdownGlow, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
                end
            end)

            local function SetOptions(newOptions)
                Options = newOptions or {}
                SelectedValue = config.Default or (Options[1] or "None")
                Selected.Text = tostring(SelectedValue)
                PopulateOptions()
            end

            local function SetValue(value)
                if table.find(Options, value) then
                    SelectedValue = value
                    Selected.Text = tostring(value)
                    for _, btn in pairs(DropFrame:GetChildren()) do
                        if btn:IsA("TextButton") then
                            btn.TextColor3 = btn.Text == tostring(value) and Linux.Theme.Accent or Linux.Theme.Text
                        end
                    end
                    spawn(function() Linux:SafeCallback(config.Callback, value) end)
                end
            end

            return {
                Instance = Dropdown,
                SetOptions = SetOptions,
                SetValue = SetValue,
                GetValue = function() return SelectedValue end
            }
        end

        function TabElements.Slider(config)
            elementOrder = elementOrder + 1
            totalElements = totalElements + 1
            local Slider = Linux.Instance("Frame", {
                Parent = ElementContainer,
                BackgroundColor3 = Linux.Theme.Element,
                Size = UDim2.new(1, -5, 0, 40),
                ZIndex = 1,
                LayoutOrder = elementOrder
            })

            Linux.Instance("UICorner", {
                Parent = Slider,
                CornerRadius = UDim.new(0, 6)
            })

            local SliderGradient = Linux.Instance("UIGradient", {
                Parent = Slider,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Linux.Theme.Element),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40))
                }),
                Rotation = 45
            })

            local SliderGlow = Linux.Instance("ImageLabel", {
                Parent = Slider,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 10, 1, 10),
                Position = UDim2.new(-0.05, 0, -0.05, 0),
                Image = "rbxassetid://243098098",
                ImageColor3 = Linux.Theme.Accent,
                ImageTransparency = 1,
                ScaleType = Enum.ScaleType.Slice,
                ZIndex = 0
            })

            local Label = Linux.Instance("TextLabel", {
                Parent = Slider,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.6, 0, 0, 20),
                Position = UDim2.new(0, 5, 0, 2),
                Font = Enum.Font.SourceSans,
                Text = config.Name,
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 1
            })

            local ValueLabel = Linux.Instance("TextLabel", {
                Parent = Slider,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.4, -5, 0, 20),
                Position = UDim2.new(0.6, 0, 0, 2),
                Font = Enum.Font.SourceSans,
                Text = tostring(config.Default or config.Min or 0),
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Right,
                ZIndex = 1
            })

            local SliderBar = Linux.Instance("Frame", {
                Parent = Slider,
                BackgroundColor3 = Linux.Theme.Toggle,
                Size = UDim2.new(1, -10, 0, 6),
                Position = UDim2.new(0, 5, 0, 28),
                ZIndex = 1
            })

            Linux.Instance("UICorner", {
                Parent = SliderBar,
                CornerRadius = UDim.new(1, 0)
            })

            local SliderBarGradient = Linux.Instance("UIGradient", {
                Parent = SliderBar,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Linux.Theme.Toggle),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
                }),
                Rotation = 45
            })

            local FillBar = Linux.Instance("Frame", {
                Parent = SliderBar,
                BackgroundColor3 = Color3.fromRGB(200, 200, 200),
                Size = UDim2.new(0, 0, 1, 0),
                Position = UDim2.new(0, 0, 0, 0),
                ZIndex = 1
            })

            Linux.Instance("UICorner", {
                Parent = FillBar,
                CornerRadius = UDim.new(1, 0)
            })

            local FillBarGradient = Linux.Instance("UIGradient", {
                Parent = FillBar,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(200, 200, 200)),
                    ColorSequenceKeypoint.new(1, Linux.Theme.Accent)
                }),
                Rotation = 45
            })

            local Knob = Linux.Instance("Frame", {
                Parent = SliderBar,
                BackgroundColor3 = Color3.fromRGB(255, 255, 250),
                Size = UDim2.new(0, 12, 0, 12),
                Position = UDim2.new(0, 0, 0, -3),
                ZIndex = 2
            })

            Linux.Instance("UICorner", {
                Parent = Knob,
                CornerRadius = UDim.new(1, 0)
            })

            local KnobGradient = Linux.Instance("UIGradient", {
                Parent = Knob,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 250)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
                }),
                Rotation = 45
            })

            local Min = config.Min or 0
            local Max = config.Max or 100
            local Default = config.Default or Min
            local Value = Default

            local function UpdateSlider(pos)
                local barSize = SliderBar.AbsoluteSize.X
                local relativePos = math.clamp((pos - SliderBar.AbsolutePosition.X) / barSize, 0, 1)
                Value = Min + (Max - Min) * relativePos
                Value = math.floor(Value + 0.5)
                Knob.Position = UDim2.new(relativePos, -6, 0, -3)
                FillBar.Size = UDim2.new(relativePos, 0, 1, 0)
                ValueLabel.Text = tostring(Value)
                spawn(function() Linux:SafeCallback(config.Callback, Value) end)
            end

            local draggingSlider = false

            Slider.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSlider = true
                    UpdateSlider(input.Position.X)
                    TweenService:Create(SliderGlow, TweenInfo.new(0.2), {ImageTransparency = 0.5}):Play()
                end
            end)

            Slider.InputChanged:Connect(function(input)
                if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) and draggingSlider then
                    UpdateSlider(input.Position.X)
                end
            end)

            Slider.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSlider = false
                    TweenService:Create(SliderGlow, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
                end
            end)

            Slider.MouseEnter:Connect(function()
                TweenService:Create(SliderGlow, TweenInfo.new(0.2), {ImageTransparency = 0.5}):Play()
            end)

            Slider.MouseLeave:Connect(function()
                if not draggingSlider then
                    TweenService:Create(SliderGlow, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
                end
            end)

            local function SetValue(newValue)
                newValue = math.clamp(newValue, Min, Max)
                Value = math.floor(newValue + 0.5)
                local relativePos = (Value - Min) / (Max - Min)
                Knob.Position = UDim2.new(relativePos, -6, 0, -3)
                FillBar.Size = UDim2.new(relativePos, 0, 1, 0)
                ValueLabel.Text = tostring(Value)
                spawn(function() Linux:SafeCallback(config.Callback, Value) end)
            end

            SetValue(Default)

            return {
                Instance = Slider,
                SetValue = SetValue,
                GetValue = function() return Value end
            }
        end

        function TabElements.Input(config)
            elementOrder = elementOrder + 1
            totalElements = totalElements + 1
            local Input = Linux.Instance("Frame", {
                Parent = ElementContainer,
                BackgroundColor3 = Linux.Theme.Element,
                Size = UDim2.new(1, -5, 0, 30),
                ZIndex = 1,
                LayoutOrder = elementOrder
            })

            Linux.Instance("UICorner", {
                Parent = Input,
                CornerRadius = UDim.new(0, 6)
            })

            local InputGradient = Linux.Instance("UIGradient", {
                Parent = Input,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Linux.Theme.Element),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40))
                }),
                Rotation = 45
            })

            local InputGlow = Linux.Instance("ImageLabel", {
                Parent = Input,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 10, 1, 10),
                Position = UDim2.new(-0.05, 0, -0.05, 0),
                Image = "rbxassetid://243098098",
                ImageColor3 = Linux.Theme.Accent,
                ImageTransparency = 1,
                ScaleType = Enum.ScaleType.Slice,
                ZIndex = 0
            })

            local Label = Linux.Instance("TextLabel", {
                Parent = Input,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.5, 0, 1, 0),
                Position = UDim2.new(0, 5, 0, 0),
                Font = Enum.Font.SourceSans,
                Text = config.Name,
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 1
            })

            local TextBox = Linux.Instance("TextBox", {
                Parent = Input,
                BackgroundColor3 = Linux.Theme.Toggle,
                Size = UDim2.new(0.5, -10, 0, 20),
                Position = UDim2.new(0.5, 5, 0.5, -10),
                Font = Enum.Font.SourceSans,
                Text = config.Default or "",
                PlaceholderText = config.Placeholder or "Text Here",
                PlaceholderColor3 = Color3.fromRGB(150, 150, 150),
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextScaled = false,
                TextTruncate = Enum.TextTruncate.AtEnd,
                TextXAlignment = Enum.TextXAlignment.Left,
                ClearTextOnFocus = false,
                ClipsDescendants = true,
                ZIndex = 2
            })

            Linux.Instance("UICorner", {
                Parent = TextBox,
                CornerRadius = UDim.new(0, 4)
            })

            local TextBoxGradient = Linux.Instance("UIGradient", {
                Parent = TextBox,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Linux.Theme.Toggle),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
                }),
                Rotation = 45
            })

            local TextBoxGlow = Linux.Instance("ImageLabel", {
                Parent = TextBox,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 10, 1, 10),
                Position = UDim2.new(-0.05, 0, -0.05, 0),
                Image = "rbxassetid://243098098",
                ImageColor3 = Linux.Theme.Accent,
                ImageTransparency = 1,
                ScaleType = Enum.ScaleType.Slice,
                ZIndex = 1
            })

            local MaxLength = 50

            local function CheckTextBounds()
                if #TextBox.Text > MaxLength then
                    TextBox.Text = string.sub(TextBox.Text, 1, MaxLength)
                end
            end

            TextBox:GetPropertyChangedSignal("Text"):Connect(function()
                CheckTextBounds()
            end)

            local function UpdateInput()
                CheckTextBounds()
                spawn(function() Linux:SafeCallback(config.Callback, TextBox.Text) end)
            end

            TextBox.FocusLost:Connect(function(enterPressed)
                if enterPressed then
                    UpdateInput()
                end
                TweenService:Create(TextBoxGlow, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
            end)

            TextBox.Focused:Connect(function()
                TweenService:Create(TextBoxGlow, TweenInfo.new(0.2), {ImageTransparency = 0.5}):Play()
            end)

            TextBox.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    TextBox:CaptureFocus()
                    TweenService:Create(InputGlow, TweenInfo.new(0.2), {ImageTransparency = 0.5}):Play()
                end
            end)

            Input.MouseEnter:Connect(function()
                TweenService:Create(InputGlow, TweenInfo.new(0.2), {ImageTransparency = 0.5}):Play()
            end)

            Input.MouseLeave:Connect(function()
                if not TextBox:IsFocused() then
                    TweenService:Create(InputGlow, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
                end
            end)

            local function SetValue(newValue)
                local text = tostring(newValue)
                if #text > MaxLength then
                    text = string.sub(text, 1, MaxLength)
                end
                TextBox.Text = text
                UpdateInput()
            end

            return {
                Instance = Input,
                SetValue = SetValue,
                GetValue = function() return TextBox.Text end
            }
        end

        function TabElements.Label(config)
            elementOrder = elementOrder + 1
            totalElements = totalElements + 1
            local LabelFrame = Linux.Instance("Frame", {
                Parent = ElementContainer,
                BackgroundColor3 = Linux.Theme.Element,
                Size = UDim2.new(1, -5, 0, 30),
                ZIndex = 1,
                LayoutOrder = elementOrder
            })

            Linux.Instance("UICorner", {
                Parent = LabelFrame,
                CornerRadius = UDim.new(0, 6)
            })

            local LabelGradient = Linux.Instance("UIGradient", {
                Parent = LabelFrame,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Linux.Theme.Element),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40))
                }),
                Rotation = 45
            })

            local LabelGlow = Linux.Instance("ImageLabel", {
                Parent = LabelFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 10, 1, 10),
                Position = UDim2.new(-0.05, 0, -0.05, 0),
                Image = "rbxassetid://243098098",
                ImageColor3 = Linux.Theme.Accent,
                ImageTransparency = 1,
                ScaleType = Enum.ScaleType.Slice,
                ZIndex = 0
            })

            local LabelText = Linux.Instance("TextLabel", {
                Parent = LabelFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -10, 1, 0),
                Position = UDim2.new(0, 5, 0, 0),
                Font = Enum.Font.SourceSans,
                Text = config.Text or "Label",
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextTruncate = Enum.TextTruncate.AtEnd,
                ZIndex = 1
            })

            LabelFrame.MouseEnter:Connect(function()
                TweenService:Create(LabelGlow, TweenInfo.new(0.2), {ImageTransparency = 0.5}):Play()
            end)

            LabelFrame.MouseLeave:Connect(function()
                TweenService:Create(LabelGlow, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
            end)

            local function SetText(newText)
                LabelText.Text = tostring(newText)
            end

            return {
                Instance = LabelFrame,
                SetText = SetText,
                GetText = function() return LabelText.Text end
            }
        end

        function TabElements.Section(config)
            elementOrder = elementOrder + 1
            totalElements = totalElements + 1
            local Section = Linux.Instance("Frame", {
                Parent = ElementContainer,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -5, 0, 24),
                ZIndex = 1,
                LayoutOrder = elementOrder
            })

            local SectionText = Linux.Instance("TextLabel", {
                Parent = Section,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -10, 1, 0),
                Position = UDim2.new(0, 5, 0, 0),
                Font = Enum.Font.SourceSansBold,
                Text = config.Name,
                TextColor3 = Color3.fromRGB(255, 255, 255),
                TextSize = 18,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 1
            })

            local Separator = Linux.Instance("Frame", {
                Parent = Section,
                BackgroundColor3 = Linux.Theme.Accent,
                Size = UDim2.new(1, -10, 0, 2),
                Position = UDim2.new(0, 5, 1, -2),
                ZIndex = 1
            })

            local SeparatorGradient = Linux.Instance("UIGradient", {
                Parent = Separator,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Linux.Theme.Accent),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(100, 140, 255))
                }),
                Rotation = 90
            })

            return Section
        end

        function TabElements.Keybind(config)
            elementOrder = elementOrder + 1
            totalElements = totalElements + 1
            local Keybind = Linux.Instance("Frame", {
                Parent = ElementContainer,
                BackgroundColor3 = Linux.Theme.Element,
                Size = UDim2.new(1, -5, 0, 30),
                ZIndex = 1,
                LayoutOrder = elementOrder
            })

            Linux.Instance("UICorner", {
                Parent = Keybind,
                CornerRadius = UDim.new(0, 6)
            })

            local KeybindGradient = Linux.Instance("UIGradient", {
                Parent = Keybind,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Linux.Theme.Element),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40))
                }),
                Rotation = 45
            })

            local KeybindGlow = Linux.Instance("ImageLabel", {
                Parent = Keybind,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 10, 1, 10),
                Position = UDim2.new(-0.05, 0, -0.05, 0),
                Image = "rbxassetid://243098098",
                ImageColor3 = Linux.Theme.Accent,
                ImageTransparency = 1,
                ScaleType = Enum.ScaleType.Slice,
                ZIndex = 0
            })

            local Label = Linux.Instance("TextLabel", {
                Parent = Keybind,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.5, 0, 1, 0),
                Position = UDim2.new(0, 5, 0, 0),
                Font = Enum.Font.SourceSans,
                Text = config.Name,
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 1
            })

            local KeyBox = Linux.Instance("TextButton", {
                Parent = Keybind,
                BackgroundColor3 = Linux.Theme.Toggle,
                Size = UDim2.new(0, 60, 0, 20),
                Position = UDim2.new(1, -65, 0.5, -10),
                Font = Enum.Font.SourceSans,
                Text = config.Default and tostring(config.Default) or "Text = config.Default and tostring(config.Default) or "None",
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Center,
                ZIndex = 2,
                AutoButtonColor = false
            })

            Linux.Instance("UICorner", {
                Parent = KeyBox,
                CornerRadius = UDim.new(0, 4)
            })

            local KeyBoxGradient = Linux.Instance("UIGradient", {
                Parent = KeyBox,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Linux.Theme.Toggle),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
                }),
                Rotation = 45
            })

            local KeyBoxGlow = Linux.Instance("ImageLabel", {
                Parent = KeyBox,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 10, 1, 10),
                Position = UDim2.new(-0.05, 0, -0.05, 0),
                Image = "rbxassetid://243098098",
                ImageColor3 = Linux.Theme.Accent,
                ImageTransparency = 1,
                ScaleType = Enum.ScaleType.Slice,
                ZIndex = 1
            })

            local CurrentKey = config.Default
            local AwaitingInput = false

            KeyBox.MouseButton1Click:Connect(function()
                AwaitingInput = true
                KeyBox.Text = "..."
                TweenService:Create(KeyBoxGlow, TweenInfo.new(0.2), {ImageTransparency = 0.5}):Play()
            end)

            InputService.InputBegan:Connect(function(input)
                if AwaitingInput and input.UserInputType == Enum.UserInputType.Keyboard then
                    local key = input.KeyCode
                    if key ~= Enum.KeyCode.Escape then
                        CurrentKey = key
                        KeyBox.Text = tostring(key)
                        spawn(function() Linux:SafeCallback(config.Callback, key) end)
                    else
                        CurrentKey = nil
                        KeyBox.Text = "None"
                        spawn(function() Linux:SafeCallback(config.Callback, nil) end)
                    end
                    AwaitingInput = false
                    TweenService:Create(KeyBoxGlow, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
                end
            end)

            Keybind.MouseEnter:Connect(function()
                TweenService:Create(KeybindGlow, TweenInfo.new(0.2), {ImageTransparency = 0.5}):Play()
            end)

            Keybind.MouseLeave:Connect(function()
                if not AwaitingInput then
                    TweenService:Create(KeybindGlow, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
                end
            end)

            local function SetKey(newKey)
                CurrentKey = newKey
                KeyBox.Text = newKey and tostring(newKey) or "None"
                spawn(function() Linux:SafeCallback(config.Callback, newKey) end)
            end

            return {
                Instance = Keybind,
                SetKey = SetKey,
                GetKey = function() return CurrentKey end
            }
        end

        function TabElements.ColorPicker(config)
            elementOrder = elementOrder + 1
            totalElements = totalElements + 1
            local ColorPicker = Linux.Instance("Frame", {
                Parent = ElementContainer,
                BackgroundColor3 = Linux.Theme.Element,
                Size = UDim2.new(1, -5, 0, 30),
                ZIndex = 2,
                LayoutOrder = elementOrder
            })

            Linux.Instance("UICorner", {
                Parent = ColorPicker,
                CornerRadius = UDim.new(0, 6)
            })

            local ColorPickerGradient = Linux.Instance("UIGradient", {
                Parent = ColorPicker,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Linux.Theme.Element),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40))
                }),
                Rotation = 45
            })

            local ColorPickerGlow = Linux.Instance("ImageLabel", {
                Parent = ColorPicker,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 10, 1, 10),
                Position = UDim2.new(-0.05, 0, -0.05, 0),
                Image = "rbxassetid://243098098",
                ImageColor3 = Linux.Theme.Accent,
                ImageTransparency = 1,
                ScaleType = Enum.ScaleType.Slice,
                ZIndex = 1
            })

            local Label = Linux.Instance("TextLabel", {
                Parent = ColorPicker,
                BackgroundTransparency = 1,
                Size = UDim2.new(0.8, 0, 1, 0),
                Position = UDim2.new(0, 5, 0, 0),
                Font = Enum.Font.SourceSans,
                Text = config.Name,
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 2
            })

            local ColorBox = Linux.Instance("Frame", {
                Parent = ColorPicker,
                BackgroundColor3 = config.Default or Color3.fromRGB(255, 255, 255),
                Size = UDim2.new(0, 20, 0, 20),
                Position = UDim2.new(1, -25, 0.5, -10),
                ZIndex = 2
            })

            Linux.Instance("UICorner", {
                Parent = ColorBox,
                CornerRadius = UDim.new(1, 0)
            })

            local ColorBoxGradient = Linux.Instance("UIGradient", {
                Parent = ColorBox,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, config.Default or Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
                }),
                Rotation = 45
            })

            local PickerFrame = Linux.Instance("Frame", {
                Parent = ElementContainer,
                BackgroundColor3 = Linux.Theme.Element,
                Size = UDim2.new(1, -5, 0, 0),
                ZIndex = 3,
                LayoutOrder = elementOrder + 1
            })

            Linux.Instance("UICorner", {
                Parent = PickerFrame,
                CornerRadius = UDim.new(0, 6)
            })

            local PickerFrameGradient = Linux.Instance("UIGradient", {
                Parent = PickerFrame,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Linux.Theme.Element),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40))
                }),
                Rotation = 45
            })

            local HueBar = Linux.Instance("Frame", {
                Parent = PickerFrame,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Size = UDim2.new(0, 20, 0, 100),
                Position = UDim2.new(0, 5, 0, 5),
                ZIndex = 3
            })

            Linux.Instance("UICorner", {
                Parent = HueBar,
                CornerRadius = UDim.new(0, 4)
            })

            local HueGradient = Linux.Instance("UIGradient", {
                Parent = HueBar,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                    ColorSequenceKeypoint.new(0.17, Color3.fromRGB(255, 255, 0)),
                    ColorSequenceKeypoint.new(0.33, Color3.fromRGB(0, 255, 0)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                    ColorSequenceKeypoint.new(0.67, Color3.fromRGB(0, 0, 255)),
                    ColorSequenceKeypoint.new(0.83, Color3.fromRGB(255, 0, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                })
            })

            local HueKnob = Linux.Instance("Frame", {
                Parent = HueBar,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Size = UDim2.new(1, 4, 0, 4),
                Position = UDim2.new(0, -2, 0, 0),
                ZIndex = 4
            })

            Linux.Instance("UICorner", {
                Parent = HueKnob,
                CornerRadius = UDim.new(1, 0)
            })

            local SaturationValue = Linux.Instance("Frame", {
                Parent = PickerFrame,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Size = UDim2.new(1, -40, 0, 100),
                Position = UDim2.new(0, 30, 0, 5),
                ZIndex = 3
            })

            Linux.Instance("UICorner", {
                Parent = SaturationValue,
                CornerRadius = UDim.new(0, 4)
            })

            local SatGradient = Linux.Instance("UIGradient", {
                Parent = SaturationValue,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                }),
                Rotation = 0
            })

            local ValGradient = Linux.Instance("UIGradient", {
                Parent = SaturationValue,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(0, 0, 0))
                }),
                Rotation = 90
            })

            local SVKnob = Linux.Instance("Frame", {
                Parent = SaturationValue,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Size = UDim2.new(0, 8, 0, 8),
                Position = UDim2.new(1, -4, 1, -4),
                ZIndex = 4
            })

            Linux.Instance("UICorner", {
                Parent = SVKnob,
                CornerRadius = UDim.new(1, 0)
            })

            local IsOpen = false
            local CurrentColor = config.Default or Color3.fromRGB(255, 255, 255)
            local H, S, V = CurrentColor:ToHSV()

            local function UpdatePicker()
                local tween = TweenInfo.new(0.2, Enum.EasingStyle.Quad)
                if IsOpen then
                    TweenService:Create(PickerFrame, tween, {Size = UDim2.new(1, -5, 0, 110)}):Play()
                else
                    TweenService:Create(PickerFrame, tween, {Size = UDim2.new(1, -5, 0, 0)}):Play()
                end
                task.wait(0.2)
                TabContent.CanvasSize = UDim2.new(0, 0, 0, ContentLayout.AbsoluteContentSize.Y)
            end

            local function UpdateColor()
                SatGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromHSV(H, 1, 1))
                })
                CurrentColor = Color3.fromHSV(H, S, V)
                ColorBox.BackgroundColor3 = CurrentColor
                ColorBoxGradient.Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, CurrentColor),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
                })
                spawn(function() Linux:SafeCallback(config.Callback, CurrentColor) end)
            end

            local function UpdateHue(pos)
                local relativePos = math.clamp((pos - HueBar.AbsolutePosition.Y) / HueBar.AbsoluteSize.Y, 0, 1)
                H = 1 - relativePos
                HueKnob.Position = UDim2.new(0, -2, relativePos, -2)
                UpdateColor()
            end

            local function UpdateSV(posX, posY)
                local satPos = math.clamp((posX - SaturationValue.AbsolutePosition.X) / SaturationValue.AbsoluteSize.X, 0, 1)
                local valPos = math.clamp((posY - SaturationValue.AbsolutePosition.Y) / SaturationValue.AbsoluteSize.Y, 0, 1)
                S = satPos
                V = 1 - valPos
                SVKnob.Position = UDim2.new(satPos, -4, valPos, -4)
                UpdateColor()
            end

            local draggingHue = false
            local draggingSV = false

            HueBar.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingHue = true
                    UpdateHue(input.Position.Y)
                end
            end)

            HueBar.InputChanged:Connect(function(input)
                if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) and draggingHue then
                    UpdateHue(input.Position.Y)
                end
            end)

            HueBar.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingHue = false
                end
            end)

            SaturationValue.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSV = true
                    UpdateSV(input.Position.X, input.Position.Y)
                end
            end)

            SaturationValue.InputChanged:Connect(function(input)
                if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) and draggingSV then
                    UpdateSV(input.Position.X, input.Position.Y)
                end
            end)

            SaturationValue.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingSV = false
                end
            end)

            ColorPicker.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    IsOpen = not IsOpen
                    UpdatePicker()
                    TweenService:Create(ColorPickerGlow, TweenInfo.new(0.2), {ImageTransparency = IsOpen and 0.5 or 1}):Play()
                end
            end)

            ColorPicker.MouseEnter:Connect(function()
                TweenService:Create(ColorPickerGlow, TweenInfo.new(0.2), {ImageTransparency = 0.5}):Play()
            end)

            ColorPicker.MouseLeave:Connect(function()
                if not IsOpen then
                    TweenService:Create(ColorPickerGlow, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
                end
            end)

            local function SetColor(newColor)
                CurrentColor = newColor
                H, S, V = newColor:ToHSV()
                HueKnob.Position = UDim2.new(0, -2, 1 - H, -2)
                SVKnob.Position = UDim2.new(S, -4, 1 - V, -4)
                UpdateColor()
            end

            SetColor(CurrentColor)

            return {
                Instance = ColorPicker,
                SetColor = SetColor,
                GetColor = function() return CurrentColor end
            }
        end

        function TabElements.Paragraph(config)
            elementOrder = elementOrder + 1
            totalElements = totalElements + 1
            local Paragraph = Linux.Instance("Frame", {
                Parent = ElementContainer,
                BackgroundColor3 = Linux.Theme.Element,
                Size = UDim2.new(1, -5, 0, 60),
                ZIndex = 1,
                LayoutOrder = elementOrder
            })

            Linux.Instance("UICorner", {
                Parent = Paragraph,
                CornerRadius = UDim.new(0, 6)
            })

            local ParagraphGradient = Linux.Instance("UIGradient", {
                Parent = Paragraph,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Linux.Theme.Element),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(40, 40, 40))
                }),
                Rotation = 45
            })

            local ParagraphGlow = Linux.Instance("ImageLabel", {
                Parent = Paragraph,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 10, 1, 10),
                Position = UDim2.new(-0.05, 0, -0.05, 0),
                Image = "rbxassetid://243098098",
                ImageColor3 = Linux.Theme.Accent,
                ImageTransparency = 1,
                ScaleType = Enum.ScaleType.Slice,
                ZIndex = 0
            })

            local Title = Linux.Instance("TextLabel", {
                Parent = Paragraph,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -10, 0, 20),
                Position = UDim2.new(0, 5, 0, 5),
                Font = Enum.Font.SourceSansBold,
                Text = config.Title or "Paragraph",
                TextColor3 = Linux.Theme.Text,
                TextSize = 16,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                ZIndex = 1
            })

            local Content = Linux.Instance("TextLabel", {
                Parent = Paragraph,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -10, 0, 30),
                Position = UDim2.new(0, 5, 0, 25),
                Font = Enum.Font.SourceSans,
                Text = config.Content or "Content",
                TextColor3 = Color3.fromRGB(150, 150, 150),
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                TextWrapped = true,
                ZIndex = 1
            })

            Paragraph.MouseEnter:Connect(function()
                TweenService:Create(ParagraphGlow, TweenInfo.new(0.2), {ImageTransparency = 0.5}):Play()
            end)

            Paragraph.MouseLeave:Connect(function()
                TweenService:Create(ParagraphGlow, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
            end)

            local function SetText(newTitle, newContent)
                Title.Text = tostring(newTitle)
                Content.Text = tostring(newContent)
            end

            return {
                Instance = Paragraph,
                SetText = SetText,
                GetText = function() return Title.Text, Content.Text end
            }
        end

        return TabElements
    end

    local introDuration = config.IntroDuration or 3
    local progress = 0
    local tweenInfo = TweenInfo.new(introDuration / 100, Enum.EasingStyle.Linear)

    local function UpdateProgress()
        progress = progress + 1
        ProgressText.Text = "Loading... " .. math.floor((progress / 100) * 100) .. "%"
        if progress >= 100 then
            local fadeOut = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
            TweenService:Create(IntroFrame, fadeOut, {BackgroundTransparency = 1}):Play()
            TweenService:Create(IntroTitle, fadeOut, {TextTransparency = 1}):Play()
            TweenService:Create(WelcomeText, fadeOut, {TextTransparency = 1}):Play()
            TweenService:Create(ProgressText, fadeOut, {TextTransparency = 1}):Play()
            for _, wave in pairs(waveLines) do
                TweenService:Create(wave, fadeOut, {BackgroundTransparency = 1}):Play()
            end
            for _, particle in pairs(ParticleContainer:GetChildren()) do
                if particle:IsA("Frame") then
                    TweenService:Create(particle, fadeOut, {BackgroundTransparency = 1}):Play()
                end
            end
            task.wait(0.5)
            IntroFrame:Destroy()
            Main.Visible = true
            local fadeIn = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
            TweenService:Create(Main, fadeIn, {BackgroundTransparency = 0}):Play()
        end
    end

    spawn(function()
        for i = 1, 100 do
            UpdateProgress()
            task.wait(introDuration / 100)
        end
    end)

    spawn(function()
        local waveDuration = 0.5
        while IntroFrame.Parent do
            for i = 1, #waveLines do
                local wave = waveLines[i]
                local height = math.sin((i / #waveLines) * math.pi * 2 + (tick() % (2 * math.pi))) * 10 + 10
                TweenService:Create(wave, TweenInfo.new(waveDuration, Enum.EasingStyle.Sine), {Size = UDim2.new(0, 4, 0, height)}):Play()
            end
            task.wait(waveDuration)
        end
    end)

    local fadeIn = TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
    TweenService:Create(IntroTitle, fadeIn, {TextTransparency = 0}):Play()
    TweenService:Create(WelcomeText, fadeIn, {TextTransparency = 0}):Play()
    TweenService:Create(ProgressText, fadeIn, {TextTransparency = 0}):Play()

    return LinuxLib
end

return Linux
