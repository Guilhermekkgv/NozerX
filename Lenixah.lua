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

    local Glow = Linux.Instance("ImageLabel", {
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
            local tween = TweenInfo.new(2, Enum.EasingStyle.Sine, Enum.EasingDirection.InOut)
            TweenService:Create(MainGradient, tween, {Offset = Vector2.new(1, 0)}):Play()
            wait(2)
            TweenService:Create(MainGradient, tween, {Offset = Vector2.new(-1, 0)}):Play()
            wait(2)
        end
    end)

    local MainParticles = Linux.Instance("Frame", {
        Parent = Main,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        ZIndex = 5
    })

    spawn(function()
        for i = 1, 10 do
            local Particle = Linux.Instance("Frame", {
                Parent = MainParticles,
                BackgroundColor3 = Linux.Theme.Accent,
                Size = UDim2.new(0, 3, 0, 3),
                Position = UDim2.new(math.random(), 0, math.random(), 0),
                ZIndex = 6
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
                        BackgroundTransparency = math.random(0.4, 0.8)
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
            ColorSequenceKeypoint.new(0, Color3.fromRGB(28, 28, 28)),
            ColorSequenceKeypoint.new(1, Color3.fromRGB(50, 50, 50))
        }),
        Rotation = 45
    })

    local TopBarGlow = Linux.Instance("ImageLabel", {
        Parent = TopBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(1, 0, 1, 0),
        Image = "rbxassetid://243098098",
        ImageColor3 = Linux.Theme.Accent,
        ImageTransparency = 0.9,
        ScaleType = Enum.ScaleType.Slice,
        ZIndex = 1
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
        ZIndex = 3
    })

    local MinimizeButton = Linux.Instance("TextButton", {
        Parent = TopBar,
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -45, 0, 2),
        Text = "",
        ZIndex = 3,
        AutoButtonColor = false
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
        BackgroundTransparency = 1,
        Size = UDim2.new(0, 20, 0, 20),
        Position = UDim2.new(1, -20, 0, 2),
        Text = "",
        ZIndex = 3,
        AutoButtonColor = false
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

        local TabGlow = Linux.Instance("ImageLabel", {
            Parent = TabBtn,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 1, 0),
            Image = "rbxassetid://243098098",
            ImageColor3 = Linux.Theme.Accent,
            ImageTransparency = 1,
            ScaleType = Enum.ScaleType.Slice,
            ZIndex = 1
        })

        local TabWave = Linux.Instance("Frame", {
            Parent = TabBtn,
            BackgroundTransparency = 1,
            Size = UDim2.new(1, 0, 0, 10),
            Position = UDim2.new(0, 0, 0.5, 0),
            AnchorPoint = Vector2.new(0, 0.5),
            ZIndex = 3
        })

        local tabWaveLines = {}
        for i = 1, 5 do
            local WaveLine = Linux.Instance("Frame", {
                Parent = TabWave,
                BackgroundColor3 = Linux.Theme.Accent,
                Size = UDim2.new(0, 2, 0, 5),
                Position = UDim2.new((i - 1) / 5, 0, 0.5, 0),
                AnchorPoint = Vector2.new(0, 0.5),
                BackgroundTransparency = 1,
                ZIndex = 3
            })

            Linux.Instance("UICorner", {
                Parent = WaveLine,
                CornerRadius = UDim.new(1, 0)
            })

            tabWaveLines[i] = WaveLine
        end

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
                TweenService:Create(tab.Glow, TweenInfo.new(0.3), {ImageTransparency = 1}):Play()
            end
            TabContent.Visible = true
            TabText.TextColor3 = Color3.fromRGB(255, 255, 255)
            if TabIcon then
                TabIcon.ImageColor3 = Color3.fromRGB(255, 255, 255)
            end
            TweenService:Create(TabGlow, TweenInfo.new(0.3), {ImageTransparency = 0.7}):Play()

            spawn(function()
                for _, line in ipairs(tabWaveLines) do
                    line.BackgroundTransparency = 0
                    local wave = TweenInfo.new(0.3, Enum.EasingStyle.Sine)
                    TweenService:Create(line, wave, {Size = UDim2.new(0, 2, 0, 10)}):Play()
                    wait(0.05)
                    TweenService:Create(line, wave, {Size = UDim2.new(0, 2, 0, 5), BackgroundTransparency = 1}):Play()
                end
            end)

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
            TweenService:Create(TabGlow, TweenInfo.new(0.3), {ImageTransparency = 0.7}):Play()
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

            local BtnGlow = Linux.Instance("ImageLabel", {
                Parent = BtnFrame,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
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

            Btn.MouseButton1Click:Connect(function()
                TweenService:Create(BtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Linux.Theme.Accent}):Play()
                TweenService:Create(BtnGlow, TweenInfo.new(0.1), {ImageTransparency = 0.5}):Play()
                spawn(function() Linux:SafeCallback(config.Callback) end)
                wait(0.1)
                TweenService:Create(BtnFrame, TweenInfo.new(0.1), {BackgroundColor3 = Linux.Theme.Element}):Play()
                TweenService:Create(BtnGlow, TweenInfo.new(0.1), {ImageTransparency = 1}):Play()
            end)

            Btn.MouseEnter:Connect(function()
                TweenService:Create(BtnGlow, TweenInfo.new(0.2), {ImageTransparency = 0.8}):Play()
            end)

            Btn.MouseLeave:Connect(function()
                TweenService:Create(BtnGlow, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
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

            local ToggleGlow = Linux.Instance("ImageLabel", {
                Parent = Toggle,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
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

            local KnobGlow = Linux.Instance("ImageLabel", {
                Parent = Knob,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Image = "rbxassetid://243098098",
                ImageColor3 = Linux.Theme.Accent,
                ImageTransparency = 0.8,
                ScaleType = Enum.ScaleType.Slice,
                ZIndex = 1
            })

            local State = config.Default or false

            local function UpdateToggle()
                local tween = TweenInfo.new(0.2, Enum.EasingStyle.Quad)
                if State then
                    TweenService:Create(ToggleFill, tween, {BackgroundColor3 = Linux.Theme.Accent, Size = UDim2.new(1, 0, 1, 0)}):Play()
                    TweenService:Create(Knob, tween, {Position = UDim2.new(1, -18, 0, 2), BackgroundColor3 = Color3.fromRGB(255, 255, 255)}):Play()
                    TweenService:Create(KnobGlow, tween, {ImageTransparency = 0.5}):Play()
                else
                    TweenService:Create(ToggleFill, tween, {BackgroundColor3 = Linux.Theme.Toggle, Size = UDim2.new(0, 0, 1, 0)}):Play()
                    TweenService:Create(Knob, tween, {Position = UDim2.new(0, 2, 0, 2), BackgroundColor3 = Color3.fromRGB(150, 150, 150)}):Play()
                    TweenService:Create(KnobGlow, tween, {ImageTransparency = 0.8}):Play()
                end
            end

            UpdateToggle()

            Toggle.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    State = not State
                    UpdateToggle()
                    TweenService:Create(ToggleGlow, TweenInfo.new(0.2), {ImageTransparency = 0.5}):Play()
                    wait(0.2)
                    TweenService:Create(ToggleGlow, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
                    spawn(function() Linux:SafeCallback(config.Callback, State) end)
                end
            end)

            Toggle.MouseEnter:Connect(function()
                TweenService:Create(ToggleGlow, TweenInfo.new(0.2), {ImageTransparency = 0.8}):Play()
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

            local DropGlow = Linux.Instance("ImageLabel", {
                Parent = Dropdown,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
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
                            CornerRadius = UDim.new(0, 6)
                        })

                        local OptGlow = Linux.Instance("ImageLabel", {
                            Parent = OptBtn,
                            BackgroundTransparency = 1,
                            Size = UDim2.new(1, 0, 1, 0),
                            Image = "rbxassetid://243098098",
                            ImageColor3 = Linux.Theme.Accent,
                            ImageTransparency = 1,
                            ScaleType = Enum.ScaleType.Slice,
                            ZIndex = 2
                        })

                        OptBtn.MouseEnter:Connect(function()
                            TweenService:Create(OptGlow, TweenInfo.new(0.2), {ImageTransparency = 0.8}):Play()
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
                            TweenService:Create(DropGlow, TweenInfo.new(0.2), {ImageTransparency = 0.5}):Play()
                            wait(0.2)
                            TweenService:Create(DropGlow, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
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
                    TweenService:Create(DropGlow, TweenInfo.new(0.2), {ImageTransparency = 0.5}):Play()
                    wait(0.2)
                    TweenService:Create(DropGlow, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
                end
            end)

            Dropdown.MouseEnter:Connect(function()
                TweenService:Create(DropGlow, TweenInfo.new(0.2), {ImageTransparency = 0.8}):Play()
            end)

            Dropdown.MouseLeave:Connect(function()
                TweenService:Create(DropGlow, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
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

            local SliderGlow = Linux.Instance("ImageLabel", {
                Parent = Slider,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
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

            local KnobGlow = Linux.Instance("ImageLabel", {
                Parent = Knob,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Image = "rbxassetid://243098098",
                ImageColor3 = Linux.Theme.Accent,
                ImageTransparency = 0.8,
                ScaleType = Enum.ScaleType.Slice,
                ZIndex = 1
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
                TweenService:Create(SliderGlow, TweenInfo.new(0.2), {ImageTransparency = 0.8}):Play()
            end)

            Slider.MouseLeave:Connect(function()
                TweenService:Create(SliderGlow, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
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

            local InputGlow = Linux.Instance("ImageLabel", {
                Parent = Input,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
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
                CornerRadius = UDim.new(0, 6)
            })

            local TextBoxGlow = Linux.Instance("ImageLabel", {
                Parent = TextBox,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Image = "rbxassetid://243098098",
                ImageColor3 = Linux.Theme.Accent,
                ImageTransparency = 0.8,
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
                    TweenService:Create(TextBoxGlow, TweenInfo.new(0.2), {ImageTransparency = 0.5}):Play()
                    wait(0.2)
                    TweenService:Create(TextBoxGlow, TweenInfo.new(0.2), {ImageTransparency = 0.8}):Play()
                end
            end)

            TextBox.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    TextBox:CaptureFocus()
                    TweenService:Create(InputGlow, TweenInfo.new(0.2), {ImageTransparency = 0.5}):Play()
                end
            end)

            Input.MouseEnter:Connect(function()
                TweenService:Create(InputGlow, TweenInfo.new(0.2), {ImageTransparency = 0.8}):Play()
            end)

            Input.MouseLeave:Connect(function()
                TweenService:Create(InputGlow, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
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

            local KeybindGlow = Linux.Instance("ImageLabel", {
                Parent = Keybind,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
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
                Text = config.Default and tostring(config.Default) or "None",
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextScaled = true,
                TextTruncate = Enum.TextTruncate.AtEnd,
                TextXAlignment = Enum.TextXAlignment.Center,
                ClipsDescendants = true,
                ZIndex = 2,
                AutoButtonColor = false
            })

            Linux.Instance("UICorner", {
                Parent = KeyBox,
                CornerRadius = UDim.new(0, 6)
            })

            local KeyBoxGlow = Linux.Instance("ImageLabel", {
                Parent = KeyBox,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Image = "rbxassetid://243098098",
                ImageColor3 = Linux.Theme.Accent,
                ImageTransparency = 0.8,
                ScaleType = Enum.ScaleType.Slice,
                ZIndex = 1
            })

            local Mode = config.Mode or "Hold"
            local CurrentKey = config.Default or nil
            local IsBinding = false
            local ToggleState = false
            local IsHolding = false

            local function UpdateKeyText()
                KeyBox.Text = CurrentKey and tostring(CurrentKey) or "None"
            end

            local function ExecuteCallback(state)
                if Mode == "Hold" then
                    spawn(function() Linux:SafeCallback(config.Callback, state) end)
                elseif Mode == "Toggle" then
                    if state then
                        ToggleState = not ToggleState
                        spawn(function() Linux:SafeCallback(config.Callback, ToggleState) end)
                    end
                elseif Mode == "Always" then
                    if ToggleState then
                        spawn(function() Linux:SafeCallback(config.Callback, true) end)
                    end
                end
            end

            KeyBox.MouseButton1Click:Connect(function()
                if not IsBinding then
                    IsBinding = true
                    KeyBox.Text = "..."
                    TweenService:Create(KeyBoxGlow, TweenInfo.new(0.2), {ImageTransparency = 0.5}):Play()
                end
            end)

            KeyBox.MouseButton2Click:Connect(function()
                CurrentKey = nil
                IsBinding = false
                UpdateKeyText()
                TweenService:Create(KeyBoxGlow, TweenInfo.new(0.2), {ImageTransparency = 0.5}):Play()
                wait(0.2)
                TweenService:Create(KeyBoxGlow, TweenInfo.new(0.2), {ImageTransparency = 0.8}):Play()
            end)

            InputService.InputBegan:Connect(function(input, gameProcessedEvent)
                if gameProcessedEvent then return end

                if IsBinding then
                    if input.UserInputType == Enum.UserInputType.Keyboard then
                        CurrentKey = input.KeyCode
                        IsBinding = false
                        UpdateKeyText()
                        TweenService:Create(KeyBoxGlow, TweenInfo.new(0.2), {ImageTransparency = 0.5}):Play()
                        wait(0.2)
                        TweenService:Create(KeyBoxGlow, TweenInfo.new(0.2), {ImageTransparency = 0.8}):Play()
                    elseif input.UserInputType == Enum.UserInputType.MouseButton1 then
                        CurrentKey = Enum.UserInputType.MouseButton1
                        IsBinding = false
                        UpdateKeyText()
                        TweenService:Create(KeyBoxGlow, TweenInfo.new(0.2), {ImageTransparency = 0.5}):Play()
                        wait(0.2)
                        TweenService:Create(KeyBoxGlow, TweenInfo.new(0.2), {ImageTransparency = 0.8}):Play()
                    elseif input.UserInputType == Enum.UserInputType.MouseButton2 then
                        CurrentKey = Enum.UserInputType.MouseButton2
                        IsBinding = false
                        UpdateKeyText()
                        TweenService:Create(KeyBoxGlow, TweenInfo.new(0.2), {ImageTransparency = 0.5}):Play()
                        wait(0.2)
                        TweenService:Create(KeyBoxGlow, TweenInfo.new(0.2), {ImageTransparency = 0.8}):Play()
                    elseif input.UserInputType == Enum.UserInputType.MouseButton3 then
                        CurrentKey = Enum.UserInputType.MouseButton3
                        IsBinding = false
                        UpdateKeyText()
                        TweenService:Create(KeyBoxGlow, TweenInfo.new(0.2), {ImageTransparency = 0.5}):Play()
                        wait(0.2)
                        TweenService:Create(KeyBoxGlow, TweenInfo.new(0.2), {ImageTransparency = 0.8}):Play()
                    end
                elseif CurrentKey then
                    if (CurrentKey == input.KeyCode or CurrentKey == input.UserInputType) then
                        IsHolding = true
                        ExecuteCallback(true)
                    end
                end
            end)

            InputService.InputEnded:Connect(function(input, gameProcessedEvent)
                if gameProcessedEvent then return end

                if CurrentKey and (CurrentKey == input.KeyCode or CurrentKey == input.UserInputType) then
                    IsHolding = false
                    if Mode == "Hold" then
                        ExecuteCallback(false)
                    end
                end
            end)

            if Mode == "Always" then
                spawn(function()
                    while true do
                        if ToggleState then
                            ExecuteCallback(true)
                        end
                        wait()
                    end
                end)
            end

            Keybind.MouseEnter:Connect(function()
                TweenService:Create(KeybindGlow, TweenInfo.new(0.2), {ImageTransparency = 0.8}):Play()
            end)

            Keybind.MouseLeave:Connect(function()
                TweenService:Create(KeybindGlow, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
            end)

            local function SetKey(newKey)
                CurrentKey = newKey
                UpdateKeyText()
            end

            local function GetKey()
                return CurrentKey
            end

            local function SetMode(newMode)
                Mode = newMode
                ToggleState = false
                IsHolding = false
            end

            UpdateKeyText()

            return {
                Instance = Keybind,
                SetKey = SetKey,
                GetKey = GetKey,
                SetMode = SetMode
            }
        end

        function TabElements.ColorPicker(config)
            elementOrder = elementOrder + 1
            totalElements = totalElements + 1
            local ColorPicker = Linux.Instance("Frame", {
                Parent = ElementContainer,
                BackgroundColor3 = Linux.Theme.Element,
                Size = UDim2.new(1, -5, 0, 90),
                ZIndex = 1,
                LayoutOrder = elementOrder
            })

            Linux.Instance("UICorner", {
                Parent = ColorPicker,
                CornerRadius = UDim.new(0, 6)
            })

            local ColorPickerGlow = Linux.Instance("ImageLabel", {
                Parent = ColorPicker,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Image = "rbxassetid://243098098",
                ImageColor3 = Linux.Theme.Accent,
                ImageTransparency = 1,
                ScaleType = Enum.ScaleType.Slice,
                ZIndex = 0
            })

            local Label = Linux.Instance("TextLabel", {
                Parent = ColorPicker,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, -10, 0, 20),
                Position = UDim2.new(0, 5, 0, 5),
                Font = Enum.Font.SourceSans,
                Text = config.Name,
                TextColor3 = Linux.Theme.Text,
                TextSize = 14,
                TextXAlignment = Enum.TextXAlignment.Left,
                ZIndex = 1
            })

            local Palette = Linux.Instance("ImageButton", {
                Parent = ColorPicker,
                BackgroundColor3 = Color3.fromRGB(255, 0, 0),
                Size = UDim2.new(1, -10, 0, 60),
                Position = UDim2.new(0, 5, 0, 25),
                Image = "rbxassetid://698052001",
                ZIndex = 1,
                AutoButtonColor = false
            })

            Linux.Instance("UICorner", {
                Parent = Palette,
                CornerRadius = UDim.new(0, 6)
            })

            local PaletteGlow = Linux.Instance("ImageLabel", {
                Parent = Palette,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Image = "rbxassetid://243098098",
                ImageColor3 = Linux.Theme.Accent,
                ImageTransparency = 0.8,
                ScaleType = Enum.ScaleType.Slice,
                ZIndex = 0
            })

            local PaletteKnob = Linux.Instance("Frame", {
                Parent = Palette,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Size = UDim2.new(0, 8, 0, 8),
                Position = UDim2.new(1, -4, 1, -4),
                ZIndex = 2
            })

            Linux.Instance("UICorner", {
                Parent = PaletteKnob,
                CornerRadius = UDim.new(1, 0)
            })

            local KnobGlow = Linux.Instance("ImageLabel", {
                Parent = PaletteKnob,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Image = "rbxassetid://243098098",
                ImageColor3 = Linux.Theme.Accent,
                ImageTransparency = 0.5,
                ScaleType = Enum.ScaleType.Slice,
                ZIndex = 1
            })

            local Saturation = Linux.Instance("ImageLabel", {
                Parent = Palette,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Image = "rbxassetid://6014261993",
                ZIndex = 1
            })

            Linux.Instance("UICorner", {
                Parent = Saturation,
                CornerRadius = UDim.new(0, 6)
            })

            local ValueGradient = Linux.Instance("UIGradient", {
                Parent = Saturation,
                Color = ColorSequence.new(Color3.new(0, 0, 0), Color3.new(1, 1, 1)),
                Rotation = 90
            })

            local Hue = Linux.Instance("Frame", {
                Parent = ColorPicker,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Size = UDim2.new(1, -10, 0, 6),
                Position = UDim2.new(0, 5, 1, -10),
                ZIndex = 1
            })

            Linux.Instance("UICorner", {
                Parent = Hue,
                CornerRadius = UDim.new(1, 0)
            })

            local HueGradient = Linux.Instance("UIGradient", {
                Parent = Hue,
                Color = ColorSequence.new({
                    ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 0, 0)),
                    ColorSequenceKeypoint.new(0.167, Color3.fromRGB(255, 255, 0)),
                    ColorSequenceKeypoint.new(0.333, Color3.fromRGB(0, 255, 0)),
                    ColorSequenceKeypoint.new(0.5, Color3.fromRGB(0, 255, 255)),
                    ColorSequenceKeypoint.new(0.667, Color3.fromRGB(0, 0, 255)),
                    ColorSequenceKeypoint.new(0.833, Color3.fromRGB(255, 0, 255)),
                    ColorSequenceKeypoint.new(1, Color3.fromRGB(255, 0, 0))
                })
            })

            local HueKnob = Linux.Instance("Frame", {
                Parent = Hue,
                BackgroundColor3 = Color3.fromRGB(255, 255, 255),
                Size = UDim2.new(0, 8, 0, 12),
                Position = UDim2.new(0, -2, 0, -3),
                ZIndex = 2
            })

            Linux.Instance("UICorner", {
                Parent = HueKnob,
                CornerRadius = UDim.new(1, 0)
            })

            local HueKnobGlow = Linux.Instance("ImageLabel", {
                Parent = HueKnob,
                BackgroundTransparency = 1,
                Size = UDim2.new(1, 0, 1, 0),
                Image = "rbxassetid://243098098",
                ImageColor3 = Linux.Theme.Accent,
                ImageTransparency = 0.5,
                ScaleType = Enum.ScaleType.Slice,
                ZIndex = 1
            })

            local CurrentColor = config.Default or Color3.fromRGB(255, 0, 0)
            local HSV = Color3.toHSV(CurrentColor)
            local HueValue, SaturationValue, ValueValue = HSV[1], HSV[2], HSV[3]

            local function UpdateColor()
                local newColor = Color3.fromHSV(HueValue, SaturationValue, ValueValue)
                CurrentColor = newColor
                Palette.BackgroundColor3 = Color3.fromHSV(HueValue, 1, 1)
                spawn(function() Linux:SafeCallback(config.Callback, CurrentColor) end)
            end

            local function UpdatePaletteKnob(pos)
                local paletteSize = Palette.AbsoluteSize
                local palettePos = Palette.AbsolutePosition
                local relativeX = math.clamp((pos.X - palettePos.X) / paletteSize.X, 0, 1)
                local relativeY = math.clamp((pos.Y - palettePos.Y) / paletteSize.Y, 0, 1)
                SaturationValue = relativeX
                ValueValue = 1 - relativeY
                PaletteKnob.Position = UDim2.new(relativeX, -4, relativeY, -4)
                UpdateColor()
            end

            local function UpdateHueKnob(pos)
                local hueSize = Hue.AbsoluteSize.X
                local huePos = Hue.AbsolutePosition.X
                local relativeX = math.clamp((pos.X - huePos) / hueSize, 0, 1)
                HueValue = relativeX
                HueKnob.Position = UDim2.new(relativeX, -4, 0, -3)
                UpdateColor()
            end

            local draggingPalette = false
            local draggingHue = false

            Palette.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingPalette = true
                    UpdatePaletteKnob(input.Position)
                    TweenService:Create(PaletteGlow, TweenInfo.new(0.2), {ImageTransparency = 0.5}):Play()
                end
            end)

            Palette.InputChanged:Connect(function(input)
                if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) and draggingPalette then
                    UpdatePaletteKnob(input.Position)
                end
            end)

            Palette.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingPalette = false
                    TweenService:Create(PaletteGlow, TweenInfo.new(0.2), {ImageTransparency = 0.8}):Play()
                end
            end)

            Hue.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingHue = true
                    UpdateHueKnob(input.Position)
                    TweenService:Create(HueKnobGlow, TweenInfo.new(0.2), {ImageTransparency = 0.5}):Play()
                end
            end)

            Hue.InputChanged:Connect(function(input)
                if (input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseMovement) and draggingHue then
                    UpdateHueKnob(input.Position)
                end
            end)

            Hue.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.Touch or input.UserInputType == Enum.UserInputType.MouseButton1 then
                    draggingHue = false
                    TweenService:Create(HueKnobGlow, TweenInfo.new(0.2), {ImageTransparency = 0.5}):Play()
                end
            end)

            ColorPicker.MouseEnter:Connect(function()
                TweenService:Create(ColorPickerGlow, TweenInfo.new(0.2), {ImageTransparency = 0.8}):Play()
            end)

            ColorPicker.MouseLeave:Connect(function()
                TweenService:Create(ColorPickerGlow, TweenInfo.new(0.2), {ImageTransparency = 1}):Play()
            end)

            local function SetColor(newColor)
                CurrentColor = newColor
                local h, s, v = Color3.toHSV(newColor)
                HueValue, SaturationValue, ValueValue = h, s, v
                Palette.BackgroundColor3 = Color3.fromHSV(HueValue, 1, 1)
                PaletteKnob.Position = UDim2.new(SaturationValue, -4, 1 - ValueValue, -4)
                HueKnob.Position = UDim2.new(HueValue, -4, 0, -3)
                spawn(function() Linux:SafeCallback(config.Callback, CurrentColor) end)
            end

            SetColor(CurrentColor)

            return {
                Instance = ColorPicker,
                SetColor = SetColor,
                GetColor = function() return CurrentColor end
            }
        end

        return TabElements
    end

    local function IntroSequence()
        local fadeIn = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.Out)
        TweenService:Create(IntroTitle, fadeIn, {TextTransparency = 0}):Play()
        TweenService:Create(WelcomeText, fadeIn, {TextTransparency = 0}):Play()
        TweenService:Create(ProgressText, fadeIn, {TextTransparency = 0}):Play()

        for i = 1, #waveLines do
            local WaveLine = waveLines[i]
            local wave = TweenInfo.new(0.3, Enum.EasingStyle.Sine)
            TweenService:Create(WaveLine, wave, {Size = UDim2.new(0, 4, 0, 20)}):Play()
            wait(0.05)
            TweenService:Create(WaveLine, wave, {Size = UDim2.new(0, 4, 0, 10)}):Play()
        end

        for i = 0, 100, 5 do
            ProgressText.Text = "Loading... " .. i .. "%"
            wait(0.05)
        end

        local fadeOut = TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.In)
        TweenService:Create(IntroTitle, fadeOut, {TextTransparency = 1}):Play()
        TweenService:Create(WelcomeText, fadeOut, {TextTransparency = 1}):Play()
        TweenService:Create(ProgressText, fadeOut, {TextTransparency = 1}):Play()
        for _, particle in pairs(ParticleContainer:GetChildren()) do
            if particle:IsA("Frame") then
                TweenService:Create(particle, fadeOut, {BackgroundTransparency = 1}):Play()
            end
        end

        wait(0.5)
        IntroFrame.Visible = false
        Main.Visible = true
    end

    spawn(IntroSequence)

    return LinuxLib
end

return Linux
