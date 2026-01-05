local TweenService = game:GetService("TweenService")
local UserInputService = game:GetService("UserInputService")
local Players = game:GetService("Players")

local LocalPlayer = Players.LocalPlayer
local Mouse = LocalPlayer:GetMouse()

local Library = {}

local function MakeDraggable(Frame, DragHandle)
    local Dragging, DragInput, DragStart, StartPos

    DragHandle.InputBegan:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseButton1 or input.UserInputType == Enum.UserInputType.Touch then
            Dragging = true
            DragStart = input.Position
            StartPos = Frame.Position

            input.Changed:Connect(function()
                if input.UserInputState == Enum.UserInputState.End then
                    Dragging = false
                end
            end)
        end
    end)

    DragHandle.InputChanged:Connect(function(input)
        if input.UserInputType == Enum.UserInputType.MouseMovement or input.UserInputType == Enum.UserInputType.Touch then
            DragInput = input
        end
    end)

    UserInputService.InputChanged:Connect(function(input)
        if Dragging and input == DragInput then
            local delta = input.Position - DragStart
            local newPos = UDim2.new(StartPos.X.Scale, StartPos.X.Offset + delta.X, StartPos.Y.Scale, StartPos.Y.Offset + delta.Y)
            TweenService:Create(Frame, TweenInfo.new(0.05), {Position = newPos}):Play()
        end
    end)
end

-- Tema visual
local THEME = {
    Background = Color3.fromRGB(15, 15, 15), -- Onyx #0F0F0F
    Topbar = Color3.fromRGB(28, 28, 32),
    ElementBackground = Color3.fromRGB(26, 26, 26), -- #1A1A1A
    TextColor = Color3.fromRGB(255, 255, 255),
    TextDim = Color3.fromRGB(150, 150, 150),
    Accent = Color3.fromRGB(0, 122, 255), -- Electric Blue
    Accent2 = Color3.fromRGB(50, 150, 255),
    Stroke = Color3.fromRGB(35, 35, 35),
    CornerRadius = UDim.new(0, 6)
}

function Library:CreateWindow(Config)
    local Title = Config.Title or "UI Library"

    -- Apply custom theme if provided
    if Config.Theme then
        for k, v in pairs(Config.Theme) do
            THEME[k] = v
        end
    end

    -- Game Lock / PlaceId Check
    if Config.PlaceId and type(Config.PlaceId) == "number" and Config.PlaceId > 0 then
        if game.PlaceId ~= Config.PlaceId then
            local ErrorGui = Instance.new("ScreenGui")
            ErrorGui.Name = "ErrorUI"
            ErrorGui.ResetOnSpawn = false
            pcall(function() ErrorGui.Parent = game:GetService("CoreGui") end)
            if not ErrorGui.Parent then ErrorGui.Parent = LocalPlayer:WaitForChild("PlayerGui") end

            local ErrorFrame = Instance.new("Frame")
            ErrorFrame.Size = UDim2.new(0, 400, 0, 240)
            ErrorFrame.Position = UDim2.new(0.5, -200, 0.5, -120)
            ErrorFrame.BackgroundColor3 = THEME.Background
            ErrorFrame.BorderSizePixel = 0
            ErrorFrame.Parent = ErrorGui

            local ErrorCorner = Instance.new("UICorner")
            ErrorCorner.CornerRadius = UDim.new(0, 10)
            ErrorCorner.Parent = ErrorFrame

            local ErrorStroke = Instance.new("UIStroke")
            ErrorStroke.Thickness = 2
            ErrorStroke.Parent = ErrorFrame

            local StrokeGrad = Instance.new("UIGradient")
            StrokeGrad.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 60, 60)),
                ColorSequenceKeypoint.new(1, THEME.Accent)
            }
            StrokeGrad.Rotation = 45
            StrokeGrad.Parent = ErrorStroke

            local Icon = Instance.new("ImageLabel")
            Icon.Size = UDim2.new(0, 60, 0, 60)
            Icon.Position = UDim2.new(0.5, -30, 0.12, 0)
            Icon.BackgroundTransparency = 1
            Icon.Image = "rbxassetid://114509698380342" -- Aetherium Logo
            Icon.Parent = ErrorFrame

            local Title = Instance.new("TextLabel")
            Title.Text = "Incorrect Game"
            Title.Font = Enum.Font.GothamBold
            Title.TextSize = 22
            Title.TextColor3 = THEME.TextColor
            Title.Size = UDim2.new(1, 0, 0, 30)
            Title.Position = UDim2.new(0, 0, 0.42, 0)
            Title.BackgroundTransparency = 1
            Title.Parent = ErrorFrame

            local Desc = Instance.new("TextLabel")
            Desc.Text = "This script is locked to a specific game.\nPlease join the correct game to use it."
            Desc.Font = Enum.Font.Gotham
            Desc.TextSize = 14
            Desc.TextColor3 = THEME.TextDim
            Desc.Size = UDim2.new(0.9, 0, 0, 40)
            Desc.Position = UDim2.new(0.05, 0, 0.58, 0)
            Desc.BackgroundTransparency = 1
            Desc.TextWrapped = true
            Desc.Parent = ErrorFrame

            local CloseBtn = Instance.new("TextButton")
            CloseBtn.Size = UDim2.new(0.4, 0, 0, 35)
            CloseBtn.Position = UDim2.new(0.3, 0, 0.8, 0)
            CloseBtn.BackgroundColor3 = Color3.fromRGB(40, 40, 40)
            CloseBtn.Text = "Close"
            CloseBtn.TextColor3 = Color3.new(1,1,1)
            CloseBtn.Font = Enum.Font.GothamBold
            CloseBtn.TextSize = 14
            CloseBtn.Parent = ErrorFrame
            Instance.new("UICorner", CloseBtn).CornerRadius = UDim.new(0, 6)
            
            CloseBtn.MouseButton1Click:Connect(function() ErrorGui:Destroy() end)

            local DummyWindow = {}
            function DummyWindow:Tab() return {Button=function()end,Toggle=function()end,Slider=function()end,Dropdown=function()end,Label=function()end} end
            function DummyWindow:Notification() end
            return DummyWindow
        end
    end

    -- ScreenGui
    local ScreenGui = Instance.new("ScreenGui")
    ScreenGui.Name = "ModernUI_" .. math.random(1000, 9999)
    ScreenGui.ResetOnSpawn = false
    ScreenGui.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    -- Intentar poner en CoreGui (útil en exploits), fallback a PlayerGui
    local success = pcall(function()
        ScreenGui.Parent = game:GetService("CoreGui")
    end)
    if not success then
        ScreenGui.Parent = LocalPlayer:WaitForChild("PlayerGui")
    end

    -- Ventana principal
    local MainFrame = Instance.new("Frame")
    MainFrame.Name = "MainFrame"
    MainFrame.Size = UDim2.new(0, 550, 0, 350)
    MainFrame.Position = UDim2.new(0.5, -275, 0.5, -175)
    MainFrame.BackgroundTransparency = 1
    MainFrame.BorderSizePixel = 0
    MainFrame.ClipsDescendants = false
    MainFrame.Visible = true -- Hidden until KeySystem/Init
    MainFrame.Parent = ScreenGui

    -- Background
    local Bg = Instance.new("Frame")
    Bg.Name = "Bg"
    Bg.Size = UDim2.new(1, 0, 1, 0)
    Bg.BackgroundColor3 = THEME.Background
    Bg.BorderSizePixel = 0
    Bg.ClipsDescendants = true
    Bg.Parent = MainFrame

    local MainCorner = Instance.new("UICorner")
    MainCorner.CornerRadius = THEME.CornerRadius
    MainCorner.Parent = Bg

    local BgGradient = Instance.new("UIGradient")
    BgGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
    }
    BgGradient.Rotation = 90
    BgGradient.Parent = Bg

    local Pattern = Instance.new("ImageLabel")
    Pattern.Name = "Pattern"
    Pattern.Size = UDim2.new(1, 0, 1, 0)
    Pattern.BackgroundTransparency = 1
    Pattern.Image = "rbxassetid://2151741365"
    Pattern.ImageTransparency = 0.92
    Pattern.ScaleType = Enum.ScaleType.Tile
    Pattern.TileSize = UDim2.new(0, 100, 0, 100)
    Pattern.Parent = Bg

    local MainStroke = Instance.new("UIStroke")
    MainStroke.Thickness = 1
    MainStroke.Color = THEME.Stroke
    MainStroke.Parent = Bg

    local StrokeGradient = Instance.new("UIGradient")
    StrokeGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, THEME.Accent),
        ColorSequenceKeypoint.new(1, Color3.fromRGB(60, 60, 60))
    }
    StrokeGradient.Rotation = 45
    StrokeGradient.Parent = MainStroke

    -- Topbar
    local Topbar = Instance.new("Frame")
    Topbar.Name = "Topbar"
    Topbar.Size = UDim2.new(1, 0, 0, 40)
    Topbar.BackgroundColor3 = THEME.Topbar
    Topbar.BorderSizePixel = 0
    Topbar.Parent = Bg

    MakeDraggable(MainFrame, Topbar)

    local Separator = Instance.new("Frame")
    Separator.Name = "Separator"
    Separator.Size = UDim2.new(1, 0, 0, 1)
    Separator.Position = UDim2.new(0, 0, 1, 0)
    Separator.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Separator.BorderSizePixel = 0
    Separator.ZIndex = 5
    Separator.Parent = Topbar

    local Icon = Instance.new("ImageLabel")
    Icon.Name = "Icon"
    Icon.Size = UDim2.new(0, 38, 0, 38)
    Icon.Position = UDim2.new(0, 10, 0.5, -19)
    Icon.BackgroundTransparency = 1
    Icon.Image = "rbxassetid://114509698380342"
    Icon.Parent = Topbar

    local TitleLabel = Instance.new("TextLabel")
    TitleLabel.Text = Title
    TitleLabel.Font = Enum.Font.GothamBold
    TitleLabel.TextSize = 16
    TitleLabel.TextColor3 = THEME.TextColor
    TitleLabel.BackgroundTransparency = 1
    TitleLabel.Size = UDim2.new(1, -100, 1, 0)
    TitleLabel.Position = UDim2.new(0, 50, 0, 0)
    TitleLabel.TextXAlignment = Enum.TextXAlignment.Left
    TitleLabel.Parent = Topbar

    -- Botones de control (cerrar/minimizar)
    local function createControlBtn(color, offset)
        local btn = Instance.new("TextButton")
        btn.Text = ""
        btn.BackgroundColor3 = color
        btn.Size = UDim2.new(0, 14, 0, 14)
        btn.Position = UDim2.new(1, offset, 0.5, -7)
        btn.AutoButtonColor = false
        btn.BackgroundTransparency = 0
        btn.ZIndex = 20
        btn.Parent = Topbar

        local corner = Instance.new("UICorner")
        corner.CornerRadius = UDim.new(1, 0)
        corner.Parent = btn

        btn.MouseEnter:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0.3}):Play()
        end)
        btn.MouseLeave:Connect(function()
            TweenService:Create(btn, TweenInfo.new(0.2), {BackgroundTransparency = 0}):Play()
        end)

        return btn
    end

    local CloseBtn = createControlBtn(Color3.fromRGB(255, 95, 87), -24) -- Mac Red
    local MinBtn = createControlBtn(Color3.fromRGB(255, 189, 46), -46) -- Mac Yellow
    local MaxBtn = createControlBtn(Color3.fromRGB(40, 201, 64), -68) -- Mac Green (Visual)

    local Maximized = false
    local DefaultSize = UDim2.new(0, 550, 0, 350)
    local MaxSize = UDim2.new(0, 800, 0, 500)

    MaxBtn.MouseButton1Click:Connect(function()
        Maximized = not Maximized
        local targetSize = Maximized and MaxSize or DefaultSize
        local targetPos = Maximized and UDim2.new(0.5, -400, 0.5, -250) or UDim2.new(0.5, -275, 0.5, -175)
        
        TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {
            Size = targetSize, Position = targetPos
        }):Play()
    end)

    CloseBtn.MouseButton1Click:Connect(function()
        ScreenGui:Destroy()
    end)

    -- Floating Widget
    local FloatingWidget = Instance.new("Frame")
    FloatingWidget.Name = "FloatingWidget"
    FloatingWidget.Size = UDim2.new(0, 200, 0, 40)
    FloatingWidget.Position = UDim2.new(0.1, 0, 0.1, 0)
    FloatingWidget.BackgroundColor3 = THEME.Background
    FloatingWidget.Visible = false
    FloatingWidget.Parent = ScreenGui

    local FloatingCorner = Instance.new("UICorner")
    FloatingCorner.CornerRadius = UDim.new(0, 8)
    FloatingCorner.Parent = FloatingWidget

    local FloatingStroke = Instance.new("UIStroke")
    FloatingStroke.Thickness = 1.5
    FloatingStroke.Color = Color3.fromRGB(255, 255, 255)
    FloatingStroke.Parent = FloatingWidget

    -- Aura (White Glow)
    local Aura = Instance.new("ImageLabel")
    Aura.Name = "Aura"
    Aura.Size = UDim2.new(1, 40, 1, 40)
    Aura.Position = UDim2.new(0.5, 0, 0.5, 0)
    Aura.AnchorPoint = Vector2.new(0.5, 0.5)
    Aura.BackgroundTransparency = 1
    Aura.ImageColor3 = Color3.new(1, 1, 1)
    Aura.ImageTransparency = 0.6
    Aura.ZIndex = 0
    Aura.Parent = FloatingWidget

    -- Triangle Particles
    task.spawn(function()
        while FloatingWidget.Parent do
            local Particle = Instance.new("ImageLabel")
            Particle.Size = UDim2.new(0, math.random(6, 10), 0, math.random(6, 10))
            Particle.Position = UDim2.new(math.random(10, 190)/200, 0, 1, 0)
            Particle.BackgroundTransparency = 1
            Particle.Image = "rbxassetid://8539427585" -- Triangle
            Particle.ImageColor3 = Color3.new(1, 1, 1)
            Particle.ImageTransparency = 0.4
            Particle.Rotation = math.random(0, 360)
            Particle.ZIndex = 0
            Particle.Parent = FloatingWidget
            
            local duration = math.random(15, 25) / 10
            TweenService:Create(Particle, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
                Position = UDim2.new(Particle.Position.X.Scale, 0, -0.8, 0),
                ImageTransparency = 1,
                Rotation = Particle.Rotation + math.random(-90, 90)
            }):Play()
            
            task.delay(duration, function() Particle:Destroy() end)
            task.wait(0.3)
        end
    end)

    local FloatingGradient = Instance.new("UIGradient")
    FloatingGradient.Color = ColorSequence.new{
        ColorSequenceKeypoint.new(0, Color3.new(1, 1, 1)),
        ColorSequenceKeypoint.new(0.5, Color3.new(0, 0, 0)),
        ColorSequenceKeypoint.new(1, Color3.new(1, 1, 1))
    }
    FloatingGradient.Parent = FloatingStroke

    local FloatingIcon = Instance.new("ImageLabel")
    FloatingIcon.Name = "Icon"
    FloatingIcon.Size = UDim2.new(0, 20, 0, 20)
    FloatingIcon.Position = UDim2.new(0, 12, 0.5, -10)
    FloatingIcon.BackgroundTransparency = 1
    FloatingIcon.Image = "rbxassetid://114509698380342"
    FloatingIcon.Parent = FloatingWidget

    task.spawn(function()
        while FloatingWidget.Parent do
            FloatingGradient.Rotation = (FloatingGradient.Rotation + 1) % 360
            task.wait()
        end
    end)

    local FloatingTitle = Instance.new("TextLabel")
    FloatingTitle.Text = "Aetherium"
    FloatingTitle.Font = Enum.Font.GothamBold
    FloatingTitle.TextSize = 14
    FloatingTitle.TextColor3 = THEME.TextColor
    FloatingTitle.BackgroundTransparency = 1
    FloatingTitle.Size = UDim2.new(1, -80, 1, 0)
    FloatingTitle.Position = UDim2.new(0, 40, 0, 0)
    FloatingTitle.TextXAlignment = Enum.TextXAlignment.Left
    FloatingTitle.Parent = FloatingWidget

    local MaximizeBtn = Instance.new("ImageButton")
    MaximizeBtn.Name = "Maximize"
    MaximizeBtn.BackgroundTransparency = 1
    MaximizeBtn.Image = "rbxassetid://6031094678"
    MaximizeBtn.Size = UDim2.new(0, 20, 0, 20)
    MaximizeBtn.Position = UDim2.new(1, -32, 0.5, -10)
    MaximizeBtn.ImageColor3 = THEME.TextDim
    MaximizeBtn.Parent = FloatingWidget

    MaximizeBtn.MouseEnter:Connect(function()
        TweenService:Create(MaximizeBtn, TweenInfo.new(0.2), {ImageColor3 = THEME.TextColor}):Play()
    end)
    MaximizeBtn.MouseLeave:Connect(function()
        TweenService:Create(MaximizeBtn, TweenInfo.new(0.2), {ImageColor3 = THEME.TextDim}):Play()
    end)

    MakeDraggable(FloatingWidget, FloatingWidget)
    
    local function ToggleMinimize()
        TweenService:Create(MainFrame, TweenInfo.new(0.4, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 0)}):Play()
        task.wait(0.4)
        MainFrame.Visible = false
        
        FloatingWidget.Visible = true
        FloatingWidget.Size = UDim2.new(0, 0, 0, 40)
        TweenService:Create(FloatingWidget, TweenInfo.new(0.5, Enum.EasingStyle.Elastic, Enum.EasingDirection.Out), {Size = UDim2.new(0, 200, 0, 40)}):Play()
    end

    MaximizeBtn.MouseButton1Click:Connect(function()
        TweenService:Create(FloatingWidget, TweenInfo.new(0.3, Enum.EasingStyle.Back, Enum.EasingDirection.In), {Size = UDim2.new(0, 0, 0, 40)}):Play()
        task.wait(0.3)
        FloatingWidget.Visible = false
        
        MainFrame.Visible = true
        MainFrame.Size = UDim2.new(0, 0, 0, 0)
        TweenService:Create(MainFrame, TweenInfo.new(0.5, Enum.EasingStyle.Back, Enum.EasingDirection.Out), {Size = UDim2.new(0, 550, 0, 350)}):Play()
    end)

    MinBtn.MouseButton1Click:Connect(ToggleMinimize)

    -- Contenedor de pestañas
    local TabContainer = Instance.new("CanvasGroup")
    TabContainer.Name = "TabContainer"
    TabContainer.Size = UDim2.new(1, -24, 0, 32)
    TabContainer.Position = UDim2.new(0, 12, 0, 45)
    TabContainer.BackgroundTransparency = 1
    TabContainer.GroupTransparency = 0
    TabContainer.BorderSizePixel = 0
    TabContainer.ZIndex = 2
    TabContainer.Parent = MainFrame

    local TabLayout = Instance.new("UIListLayout")
    TabLayout.FillDirection = Enum.FillDirection.Horizontal
    TabLayout.SortOrder = Enum.SortOrder.LayoutOrder
    TabLayout.Padding = UDim.new(0, 8)
    TabLayout.Parent = TabContainer

    -- Contenedor de contenido
    local ContentContainer = Instance.new("CanvasGroup")
    ContentContainer.Name = "ContentContainer"
    ContentContainer.Size = UDim2.new(1, -24, 1, -85)
    ContentContainer.Position = UDim2.new(0, 12, 0, 80)
    ContentContainer.BackgroundTransparency = 1
    ContentContainer.GroupTransparency = 0
    ContentContainer.BorderSizePixel = 0
    ContentContainer.ZIndex = 2
    ContentContainer.Parent = MainFrame

    -- Notification Holder
    local NotificationHolder = Instance.new("Frame")
    NotificationHolder.Name = "NotificationHolder"
    NotificationHolder.Size = UDim2.new(0, 300, 1, 0)
    NotificationHolder.Position = UDim2.new(1, -320, 0, 0)
    NotificationHolder.BackgroundTransparency = 1
    NotificationHolder.Parent = ScreenGui

    local NotifList = Instance.new("UIListLayout")
    NotifList.SortOrder = Enum.SortOrder.LayoutOrder
    NotifList.VerticalAlignment = Enum.VerticalAlignment.Bottom
    NotifList.Padding = UDim.new(0, 10)
    NotifList.Parent = NotificationHolder

    local NotifPad = Instance.new("UIPadding")
    NotifPad.PaddingBottom = UDim.new(0, 20)
    NotifPad.Parent = NotificationHolder

    local Window = {}
    local FirstTab = true

    function Window:Tab(Name)
        -- Botón de pestaña
        local TabBtn = Instance.new("TextButton")
        TabBtn.Text = Name
        TabBtn.Font = Enum.Font.Gotham
        TabBtn.TextSize = 13
        TabBtn.TextColor3 = THEME.TextDim
        TabBtn.BackgroundColor3 = THEME.ElementBackground
        TabBtn.Size = UDim2.new(0, 0, 1, 0)
        TabBtn.AutomaticSize = Enum.AutomaticSize.X
        TabBtn.Parent = TabContainer

        local TabPad = Instance.new("UIPadding")
        TabPad.PaddingLeft = UDim.new(0, 12)
        TabPad.PaddingRight = UDim.new(0, 12)
        TabPad.Parent = TabBtn

        local TabCorner = Instance.new("UICorner")
        TabCorner.CornerRadius = UDim.new(0, 4)
        TabCorner.Parent = TabBtn

        local TabStroke = Instance.new("UIStroke")
        TabStroke.Thickness = 1
        TabStroke.Color = THEME.Stroke
        TabStroke.Parent = TabBtn

        -- Contenido de la pestaña
        local TabFrame = Instance.new("ScrollingFrame")
        TabFrame.Name = Name .. "Frame"
        TabFrame.Size = UDim2.new(1, 0, 1, 0)
        TabFrame.BackgroundTransparency = 1
        TabFrame.ScrollBarThickness = 2
        TabFrame.ScrollBarImageColor3 = Color3.fromRGB(80, 80, 80)
        TabFrame.Visible = false
        TabFrame.CanvasSize = UDim2.new(0, 0, 0, 0)
        TabFrame.AutomaticCanvasSize = Enum.AutomaticSize.Y
        TabFrame.Parent = ContentContainer

        local TabList = Instance.new("UIListLayout")
        TabList.SortOrder = Enum.SortOrder.LayoutOrder
        TabList.Padding = UDim.new(0, 6)
        TabList.Parent = TabFrame

        -- Primera pestaña activa por defecto
        if FirstTab then
            FirstTab = false
            TabFrame.Visible = true
            TabBtn.TextColor3 = THEME.TextColor
            TabBtn.BackgroundColor3 = THEME.Accent
            TabStroke.Color = THEME.Accent
        end

        TabBtn.MouseButton1Click:Connect(function()
            if TabFrame.Visible then return end
            
            TweenService:Create(ContentContainer, TweenInfo.new(0.15), {GroupTransparency = 1}):Play()
            task.wait(0.1)
            
            for _, v in pairs(ContentContainer:GetChildren()) do
                if v:IsA("ScrollingFrame") then
                    v.Visible = false
                end
            end
            for _, v in pairs(TabContainer:GetChildren()) do
                if v:IsA("TextButton") then
                    TweenService:Create(v, TweenInfo.new(0.2), {
                        TextColor3 = THEME.TextDim,
                        BackgroundColor3 = THEME.ElementBackground,
                    }):Play()
                    TweenService:Create(v.UIStroke, TweenInfo.new(0.2), {Color = THEME.Stroke}):Play()
                end
            end
            TabFrame.Visible = true
            TweenService:Create(TabBtn, TweenInfo.new(0.2), {
                TextColor3 = THEME.TextColor,
                BackgroundColor3 = THEME.Accent
            }):Play()
            TweenService:Create(TabStroke, TweenInfo.new(0.2), {Color = THEME.Accent}):Play()
            
            TweenService:Create(ContentContainer, TweenInfo.new(0.2), {GroupTransparency = 0}):Play()
        end)

        local TabObj = {}

        -- Botón
        function TabObj:Button(Text, Callback)
            local Button = Instance.new("TextButton")
            Button.Size = UDim2.new(1, 0, 0, 36)
            Button.BackgroundColor3 = THEME.ElementBackground
            Button.Text = Text
            Button.Font = Enum.Font.GothamMedium
            Button.TextColor3 = THEME.TextColor
            Button.TextSize = 14
            Button.AutoButtonColor = false
            Button.Parent = TabFrame

            local BtnCorner = Instance.new("UICorner")
            BtnCorner.CornerRadius = UDim.new(0, 4)
            BtnCorner.Parent = Button

            local BtnStroke = Instance.new("UIStroke")
            BtnStroke.Thickness = 1
            BtnStroke.Color = THEME.Stroke
            BtnStroke.Parent = Button

            local BtnGradient = Instance.new("UIGradient")
            BtnGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
            }
            BtnGradient.Rotation = 90
            BtnGradient.Parent = Button

            Button.MouseEnter:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(40, 40, 46)}):Play()
                TweenService:Create(BtnStroke, TweenInfo.new(0.2), {Color = THEME.Accent}):Play()
            end)
            Button.MouseLeave:Connect(function()
                TweenService:Create(Button, TweenInfo.new(0.2), {BackgroundColor3 = THEME.ElementBackground}):Play()
                TweenService:Create(BtnStroke, TweenInfo.new(0.2), {Color = THEME.Stroke}):Play()
            end)

            Button.MouseButton1Click:Connect(function()
                pcall(Callback)
            end)
        end

        -- Toggle
        function TabObj:Toggle(Text, Default, Callback)
            local Toggled = Default or false

            local ToggleBtn = Instance.new("TextButton")
            ToggleBtn.Size = UDim2.new(1, 0, 0, 36)
            ToggleBtn.BackgroundColor3 = THEME.ElementBackground
            ToggleBtn.Text = ""
            ToggleBtn.AutoButtonColor = false
            ToggleBtn.Parent = TabFrame

            local ToggleCorner = Instance.new("UICorner")
            ToggleCorner.CornerRadius = UDim.new(0, 4)
            ToggleCorner.Parent = ToggleBtn

            local ToggleGradient = Instance.new("UIGradient")
            ToggleGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
            }
            ToggleGradient.Rotation = 90
            ToggleGradient.Parent = ToggleBtn

            local Label = Instance.new("TextLabel")
            Label.Text = Text
            Label.Font = Enum.Font.Gotham
            Label.TextColor3 = THEME.TextColor
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(1, -60, 1, 0)
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.Parent = ToggleBtn

            local Switch = Instance.new("Frame")
            Switch.Size = UDim2.new(0, 44, 0, 22)
            Switch.Position = UDim2.new(1, -54, 0.5, -11)
            Switch.BackgroundColor3 = Toggled and THEME.Accent or Color3.fromRGB(60, 60, 60)
            Switch.Parent = ToggleBtn

            local SwitchCorner = Instance.new("UICorner")
            SwitchCorner.CornerRadius = UDim.new(1, 0)
            SwitchCorner.Parent = Switch

            local Circle = Instance.new("Frame")
            Circle.Size = UDim2.new(0, 16, 0, 16)
            Circle.Position = Toggled and UDim2.new(1, -19, 0.5, -8) or UDim2.new(0, 3, 0.5, -8)
            Circle.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Circle.Parent = Switch

            local CircleCorner = Instance.new("UICorner")
            CircleCorner.CornerRadius = UDim.new(1, 0)
            CircleCorner.Parent = Circle

            local ToggleStroke = Instance.new("UIStroke")
            ToggleStroke.Thickness = 1
            ToggleStroke.Color = THEME.Stroke
            ToggleStroke.Parent = ToggleBtn

            ToggleBtn.MouseEnter:Connect(function()
                TweenService:Create(ToggleStroke, TweenInfo.new(0.2), {Color = THEME.Accent}):Play()
            end)
            ToggleBtn.MouseLeave:Connect(function()
                TweenService:Create(ToggleStroke, TweenInfo.new(0.2), {Color = THEME.Stroke}):Play()
            end)

            ToggleBtn.MouseButton1Click:Connect(function()
                Toggled = not Toggled
                pcall(Callback, Toggled)

                if Toggled then
                    TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = THEME.Accent}):Play()
                    TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(1, -19, 0.5, -8)}):Play()
                else
                    TweenService:Create(Switch, TweenInfo.new(0.2), {BackgroundColor3 = Color3.fromRGB(60, 60, 60)}):Play()
                    TweenService:Create(Circle, TweenInfo.new(0.2), {Position = UDim2.new(0, 3, 0.5, -8)}):Play()
                end
            end)
        end

        -- Slider
        function TabObj:Slider(Text, Min, Max, Default, Callback)
            local Value = Default or Min

            local SliderBtn = Instance.new("TextButton")
            SliderBtn.Size = UDim2.new(1, 0, 0, 50)
            SliderBtn.BackgroundColor3 = THEME.ElementBackground
            SliderBtn.Text = ""
            SliderBtn.AutoButtonColor = false
            SliderBtn.Parent = TabFrame

            local SliderCorner = Instance.new("UICorner")
            SliderCorner.CornerRadius = UDim.new(0, 4)
            SliderCorner.Parent = SliderBtn

            local SliderGradient = Instance.new("UIGradient")
            SliderGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
            }
            SliderGradient.Rotation = 90
            SliderGradient.Parent = SliderBtn

            local Label = Instance.new("TextLabel")
            Label.Text = Text
            Label.Font = Enum.Font.GothamMedium
            Label.TextColor3 = THEME.TextColor
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(1, -24, 0, 20)
            Label.Position = UDim2.new(0, 12, 0, 6)
            Label.Parent = SliderBtn

            local ValueLabel = Instance.new("TextLabel")
            ValueLabel.Text = tostring(Value)
            ValueLabel.Font = Enum.Font.Gotham
            ValueLabel.TextColor3 = THEME.TextDim
            ValueLabel.TextSize = 14
            ValueLabel.TextXAlignment = Enum.TextXAlignment.Right
            ValueLabel.BackgroundTransparency = 1
            ValueLabel.Size = UDim2.new(1, -24, 0, 20)
            ValueLabel.Position = UDim2.new(0, 12, 0, 6)
            ValueLabel.Parent = SliderBtn

            local SliderBar = Instance.new("Frame")
            SliderBar.Size = UDim2.new(1, -24, 0, 6)
            SliderBar.Position = UDim2.new(0, 12, 0, 36)
            SliderBar.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            SliderBar.Parent = SliderBtn

            local BarCorner = Instance.new("UICorner")
            BarCorner.CornerRadius = UDim.new(1, 0)
            BarCorner.Parent = SliderBar

            local Fill = Instance.new("Frame")
            Fill.Size = UDim2.new((Value - Min) / (Max - Min), 0, 1, 0)
            Fill.BackgroundColor3 = THEME.Accent
            Fill.Parent = SliderBar

            local FillCorner = Instance.new("UICorner")
            FillCorner.CornerRadius = UDim.new(1, 0)
            FillCorner.Parent = Fill

            local FillGradient = Instance.new("UIGradient")
            FillGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, THEME.Accent),
                ColorSequenceKeypoint.new(1, THEME.Accent2)
            }
            FillGradient.Parent = Fill

            local SliderStroke = Instance.new("UIStroke")
            SliderStroke.Thickness = 1
            SliderStroke.Color = THEME.Stroke
            SliderStroke.Parent = SliderBtn

            SliderBtn.MouseEnter:Connect(function()
                TweenService:Create(SliderStroke, TweenInfo.new(0.2), {Color = THEME.Accent}):Play()
            end)
            SliderBtn.MouseLeave:Connect(function()
                TweenService:Create(SliderStroke, TweenInfo.new(0.2), {Color = THEME.Stroke}):Play()
            end)

            local IsDragging = false

            local function updateValue(input)
                local relX = math.clamp((input.Position.X - SliderBar.AbsolutePosition.X) / SliderBar.AbsoluteSize.X, 0, 1)
                local newValue = math.floor(Min + (Max - Min) * relX)
                if newValue ~= Value then
                    Value = newValue
                    ValueLabel.Text = tostring(Value)
                    TweenService:Create(Fill, TweenInfo.new(0.1), {Size = UDim2.new(relX, 0, 1, 0)}):Play()
                    pcall(Callback, Value)
                end
            end

            SliderBtn.InputBegan:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    IsDragging = true
                    updateValue(input)
                end
            end)

            UserInputService.InputChanged:Connect(function(input)
                if IsDragging and input.UserInputType == Enum.UserInputType.MouseMovement then
                    updateValue(input)
                end
            end)

            UserInputService.InputEnded:Connect(function(input)
                if input.UserInputType == Enum.UserInputType.MouseButton1 then
                    IsDragging = false
                end
            end)
        end

        -- Dropdown
        function TabObj:Dropdown(Text, Options, Default, Callback)
            local Expanded = false
            local Selected = Default or Options[1]

            local DropdownFrame = Instance.new("Frame")
            DropdownFrame.Size = UDim2.new(1, 0, 0, 36)
            DropdownFrame.BackgroundColor3 = THEME.ElementBackground
            DropdownFrame.ClipsDescendants = true
            DropdownFrame.Parent = TabFrame

            local DropCorner = Instance.new("UICorner")
            DropCorner.CornerRadius = UDim.new(0, 4)
            DropCorner.Parent = DropdownFrame

            local DropGradient = Instance.new("UIGradient")
            DropGradient.Color = ColorSequence.new{
                ColorSequenceKeypoint.new(0, Color3.fromRGB(255, 255, 255)),
                ColorSequenceKeypoint.new(1, Color3.fromRGB(200, 200, 200))
            }
            DropGradient.Rotation = 90
            DropGradient.Parent = DropdownFrame

            local DropStroke = Instance.new("UIStroke")
            DropStroke.Thickness = 1
            DropStroke.Color = THEME.Stroke
            DropStroke.Parent = DropdownFrame

            local DropBtn = Instance.new("TextButton")
            DropBtn.Size = UDim2.new(1, 0, 0, 36)
            DropBtn.BackgroundTransparency = 1
            DropBtn.Text = ""
            DropBtn.Parent = DropdownFrame

            local Label = Instance.new("TextLabel")
            Label.Text = Text
            Label.Font = Enum.Font.GothamMedium
            Label.TextColor3 = THEME.TextColor
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(1, -60, 1, 0)
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.Parent = DropBtn

            local SelectedLabel = Instance.new("TextLabel")
            SelectedLabel.Text = Selected
            SelectedLabel.Font = Enum.Font.Gotham
            SelectedLabel.TextColor3 = THEME.TextDim
            SelectedLabel.TextSize = 14
            SelectedLabel.TextXAlignment = Enum.TextXAlignment.Right
            SelectedLabel.BackgroundTransparency = 1
            SelectedLabel.Size = UDim2.new(1, -60, 1, 0)
            SelectedLabel.Position = UDim2.new(0, 12, 0, 0)
            SelectedLabel.Parent = DropBtn

            local Arrow = Instance.new("ImageLabel")
            Arrow.Image = "rbxassetid://6031091004" -- Flecha hacia abajo
            Arrow.Size = UDim2.new(0, 20, 0, 20)
            Arrow.Position = UDim2.new(1, -32, 0.5, -10)
            Arrow.BackgroundTransparency = 1
            Arrow.Rotation = 0
            Arrow.Parent = DropBtn

            local OptionList = Instance.new("Frame")
            OptionList.Size = UDim2.new(1, 0, 0, 0)
            OptionList.Position = UDim2.new(0, 0, 0, 36)
            OptionList.BackgroundTransparency = 1
            OptionList.Parent = DropdownFrame

            local ListLayout = Instance.new("UIListLayout")
            ListLayout.SortOrder = Enum.SortOrder.LayoutOrder
            ListLayout.Parent = OptionList

            DropBtn.MouseEnter:Connect(function()
                TweenService:Create(DropStroke, TweenInfo.new(0.2), {Color = THEME.Accent}):Play()
            end)
            DropBtn.MouseLeave:Connect(function()
                TweenService:Create(DropStroke, TweenInfo.new(0.2), {Color = THEME.Stroke}):Play()
            end)

            local function RefreshList(NewOptions)
                for _, v in pairs(OptionList:GetChildren()) do
                    if v:IsA("TextButton") then v:Destroy() end
                end
                
                for _, option in ipairs(NewOptions) do
                    local OptBtn = Instance.new("TextButton")
                    OptBtn.Size = UDim2.new(1, 0, 0, 30)
                    OptBtn.BackgroundColor3 = THEME.ElementBackground
                    OptBtn.Text = option
                    OptBtn.Font = Enum.Font.Gotham
                    OptBtn.TextColor3 = THEME.TextDim
                    OptBtn.TextSize = 14
                    OptBtn.TextXAlignment = Enum.TextXAlignment.Left
                    OptBtn.Parent = OptionList

                    local OptPad = Instance.new("UIPadding")
                    OptPad.PaddingLeft = UDim.new(0, 12)
                    OptPad.Parent = OptBtn

                    OptBtn.MouseEnter:Connect(function()
                        TweenService:Create(OptBtn, TweenInfo.new(0.2), {
                            BackgroundColor3 = Color3.fromRGB(45, 45, 45),
                            TextColor3 = THEME.TextColor
                        }):Play()
                    end)
                    OptBtn.MouseLeave:Connect(function()
                        TweenService:Create(OptBtn, TweenInfo.new(0.2), {
                            BackgroundColor3 = THEME.ElementBackground,
                            TextColor3 = THEME.TextDim
                        }):Play()
                    end)

                    OptBtn.MouseButton1Click:Connect(function()
                        Selected = option
                        SelectedLabel.Text = Selected
                        pcall(Callback, Selected)
                        Expanded = false
                        TweenService:Create(DropdownFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, 36)}):Play()
                        TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = 0}):Play()
                    end)
                end
            end

            RefreshList(Options)

            DropBtn.MouseButton1Click:Connect(function()
                Expanded = not Expanded
                local targetHeight = Expanded and (36 + (#Options * 30)) or 36
                TweenService:Create(DropdownFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
                TweenService:Create(Arrow, TweenInfo.new(0.3), {Rotation = Expanded and 180 or 0}):Play()
            end)

            local DropdownMethods = {}
            function DropdownMethods:Refresh(NewOptions, NewDefault)
                Options = NewOptions
                RefreshList(Options)
                if NewDefault then
                    Selected = NewDefault
                    SelectedLabel.Text = Selected
                elseif not table.find(Options, Selected) then
                    Selected = Options[1] or "None"
                    SelectedLabel.Text = Selected
                end
                
                if Expanded then
                    local targetHeight = 36 + (#Options * 30)
                    TweenService:Create(DropdownFrame, TweenInfo.new(0.3), {Size = UDim2.new(1, 0, 0, targetHeight)}):Play()
                end
            end
            
            return DropdownMethods
        end

        -- Label
        function TabObj:Label(Text)
            local Label = Instance.new("TextLabel")
            Label.Text = Text
            Label.Font = Enum.Font.Gotham
            Label.TextColor3 = THEME.TextColor
            Label.TextSize = 14
            Label.TextXAlignment = Enum.TextXAlignment.Left
            Label.BackgroundTransparency = 1
            Label.Size = UDim2.new(1, -24, 0, 26)
            Label.Position = UDim2.new(0, 12, 0, 0)
            Label.Parent = TabFrame
            
            local LabelPad = Instance.new("UIPadding")
            LabelPad.PaddingLeft = UDim.new(0, 12)
            LabelPad.Parent = Label

            local LabelMethods = {}
            function LabelMethods:SetText(NewText)
                Label.Text = NewText
            end
            return LabelMethods
        end

        return TabObj
    end

    function Window:Notification(Title, Content, Duration)
        local Notif = Instance.new("Frame")
        Notif.Name = "Notification"
        Notif.Size = UDim2.new(1, 0, 0, 0) -- Start small
        Notif.BackgroundColor3 = THEME.ElementBackground
        Notif.BorderSizePixel = 0
        Notif.ClipsDescendants = true
        Notif.Parent = NotificationHolder

        local NotifCorner = Instance.new("UICorner")
        NotifCorner.CornerRadius = UDim.new(0, 6)
        NotifCorner.Parent = Notif

        local NotifStroke = Instance.new("UIStroke")
        NotifStroke.Thickness = 1
        NotifStroke.Color = THEME.Stroke
        NotifStroke.Parent = Notif

        local NotifTitle = Instance.new("TextLabel")
        NotifTitle.Text = Title
        NotifTitle.Font = Enum.Font.GothamBold
        NotifTitle.TextColor3 = THEME.TextColor
        NotifTitle.TextSize = 14
        NotifTitle.TextXAlignment = Enum.TextXAlignment.Left
        NotifTitle.BackgroundTransparency = 1
        NotifTitle.Size = UDim2.new(1, -20, 0, 20)
        NotifTitle.Position = UDim2.new(0, 10, 0, 10)
        NotifTitle.Parent = Notif

        local NotifContent = Instance.new("TextLabel")
        NotifContent.Text = Content
        NotifContent.Font = Enum.Font.Gotham
        NotifContent.TextColor3 = THEME.TextDim
        NotifContent.TextSize = 13
        NotifContent.TextXAlignment = Enum.TextXAlignment.Left
        NotifContent.TextWrapped = true
        NotifContent.BackgroundTransparency = 1
        NotifContent.Size = UDim2.new(1, -20, 0, 30)
        NotifContent.Position = UDim2.new(0, 10, 0, 30)
        NotifContent.Parent = Notif

        -- Animation
        TweenService:Create(Notif, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.Out), {Size = UDim2.new(1, 0, 0, 70)}):Play()
        
        task.delay(Duration or 3, function()
            TweenService:Create(Notif, TweenInfo.new(0.3, Enum.EasingStyle.Quart, Enum.EasingDirection.In), {Size = UDim2.new(1, 0, 0, 0)}):Play()
            task.wait(0.3)
            Notif:Destroy()
        end)
    end

    -- Key System Logic
    local function ShowKeySystem()
        MainFrame.Visible = false -- Ocultar UI principal mientras se valida
        
        local Dimmer = Instance.new("Frame")
        Dimmer.Name = "KeySystemDimmer"
        Dimmer.Size = UDim2.new(1, 0, 1, 0)
        Dimmer.BackgroundColor3 = Color3.new(0, 0, 0)
        Dimmer.BackgroundTransparency = 0.3
        Dimmer.ZIndex = 9999
        Dimmer.Parent = ScreenGui

        local KeyFrame = Instance.new("Frame")
        KeyFrame.Name = "KeyFrame"
        KeyFrame.Size = UDim2.new(0, 420, 0, 260)
        KeyFrame.Position = UDim2.new(0.5, -210, 0.5, -130)
        KeyFrame.BackgroundColor3 = THEME.Background
        KeyFrame.BorderSizePixel = 0
        KeyFrame.ClipsDescendants = true
        KeyFrame.Parent = Dimmer

        local KeyCorner = Instance.new("UICorner")
        KeyCorner.CornerRadius = UDim.new(0, 10)
        KeyCorner.Parent = KeyFrame

        local KeyStroke = Instance.new("UIStroke")
        KeyStroke.Thickness = 1.5
        KeyStroke.Color = THEME.Stroke
        KeyStroke.Parent = KeyFrame

        -- Triangle Particles (KeySystem Background)
        task.spawn(function()
            while KeyFrame.Parent do
                local Particle = Instance.new("ImageLabel")
                Particle.Size = UDim2.new(0, math.random(6, 10), 0, math.random(6, 10))
                Particle.Position = UDim2.new(math.random(0, 100)/100, 0, 1, 0)
                Particle.BackgroundTransparency = 1
                Particle.Image = "rbxassetid://8539427585" -- Triangle
                Particle.ImageColor3 = Color3.new(1, 1, 1)
                Particle.ImageTransparency = 0.8
                Particle.Rotation = math.random(0, 360)
                Particle.ZIndex = 1
                Particle.Parent = KeyFrame
                
                local duration = math.random(20, 40) / 10
                TweenService:Create(Particle, TweenInfo.new(duration, Enum.EasingStyle.Linear), {
                    Position = UDim2.new(Particle.Position.X.Scale, 0, -0.2, 0),
                    ImageTransparency = 1,
                    Rotation = Particle.Rotation + math.random(-90, 90)
                }):Play()
                
                task.delay(duration, function() Particle:Destroy() end)
                task.wait(0.2)
            end
        end)

        -- Header Section
        local Header = Instance.new("Frame")
        Header.Name = "Header"
        Header.Size = UDim2.new(1, 0, 0, 70)
        Header.BackgroundTransparency = 1
        Header.Parent = KeyFrame

        local HeaderIcon = Instance.new("ImageLabel")
        HeaderIcon.Size = UDim2.new(0, 40, 0, 40)
        HeaderIcon.Position = UDim2.new(0, 20, 0.5, -20)
        HeaderIcon.BackgroundTransparency = 1
        HeaderIcon.Image = "rbxassetid://114509698380342" -- Aetherium Icon
        HeaderIcon.Parent = Header

        local HeaderTitle = Instance.new("TextLabel")
        HeaderTitle.Text = "Aetherium"
        HeaderTitle.Font = Enum.Font.GothamBold
        HeaderTitle.TextSize = 20
        HeaderTitle.TextColor3 = THEME.TextColor
        HeaderTitle.Size = UDim2.new(0, 200, 0, 25)
        HeaderTitle.Position = UDim2.new(0, 70, 0, 12)
        HeaderTitle.TextXAlignment = Enum.TextXAlignment.Left
        HeaderTitle.BackgroundTransparency = 1
        HeaderTitle.Parent = Header

        local HeaderSubtitle = Instance.new("TextLabel")
        HeaderSubtitle.Text = "Key System v2.5 | Secure Gateway"
        HeaderSubtitle.Font = Enum.Font.Gotham
        HeaderSubtitle.TextSize = 12
        HeaderSubtitle.TextColor3 = THEME.Accent -- Subtitle color
        HeaderSubtitle.Size = UDim2.new(0, 200, 0, 15)
        HeaderSubtitle.Position = UDim2.new(0, 70, 0, 38)
        HeaderSubtitle.TextXAlignment = Enum.TextXAlignment.Left
        HeaderSubtitle.BackgroundTransparency = 1
        HeaderSubtitle.Parent = Header

        local Separator = Instance.new("Frame")
        Separator.Size = UDim2.new(1, 0, 0, 1)
        Separator.Position = UDim2.new(0, 0, 1, 0)
        Separator.BackgroundColor3 = THEME.Stroke
        Separator.BorderSizePixel = 0
        Separator.Parent = Header

        MakeDraggable(KeyFrame, KeyFrame)

        -- Content Section
        local Content = Instance.new("Frame")
        Content.Name = "Content"
        Content.Size = UDim2.new(1, 0, 1, -70)
        Content.Position = UDim2.new(0, 0, 0, 70)
        Content.BackgroundTransparency = 1
        Content.Parent = KeyFrame

        local KeyInput = Instance.new("TextBox")
        KeyInput.Size = UDim2.new(0.85, 0, 0, 45)
        KeyInput.Position = UDim2.new(0.075, 0, 0.15, 0)
        KeyInput.BackgroundColor3 = THEME.ElementBackground
        KeyInput.TextColor3 = THEME.TextColor
        KeyInput.PlaceholderText = "Write your key..."
        KeyInput.PlaceholderColor3 = Color3.fromRGB(120, 120, 120)
        KeyInput.Font = Enum.Font.Gotham
        KeyInput.TextSize = 14
        KeyInput.TextXAlignment = Enum.TextXAlignment.Center
        KeyInput.Parent = Content

        local InputStroke = Instance.new("UIStroke")
        InputStroke.Thickness = 1
        InputStroke.Color = THEME.Stroke
        InputStroke.Parent = KeyInput

        local InputCorner = Instance.new("UICorner")
        InputCorner.CornerRadius = UDim.new(0, 6)
        InputCorner.Parent = KeyInput

        -- Focus effect on input
        KeyInput.Focused:Connect(function()
            TweenService:Create(InputStroke, TweenInfo.new(0.2), {Color = THEME.Accent}):Play()
        end)
        KeyInput.FocusLost:Connect(function()
            TweenService:Create(InputStroke, TweenInfo.new(0.2), {Color = THEME.Stroke}):Play()
        end)

        local SubmitBtn = Instance.new("TextButton")
        SubmitBtn.Size = UDim2.new(0.4, 0, 0, 40)
        SubmitBtn.Position = UDim2.new(0.525, 0, 0.55, 0)
        SubmitBtn.BackgroundColor3 = THEME.Accent
        SubmitBtn.Text = "Verify Key"
        SubmitBtn.Font = Enum.Font.GothamBold
        SubmitBtn.TextColor3 = Color3.new(1,1,1)
        SubmitBtn.TextSize = 14
        SubmitBtn.AutoButtonColor = false
        SubmitBtn.ClipsDescendants = true
        SubmitBtn.Parent = Content

        local SubmitCorner = Instance.new("UICorner")
        SubmitCorner.CornerRadius = UDim.new(0, 6)
        SubmitCorner.Parent = SubmitBtn

        -- Progress Bar inside button
        local ProgressBar = Instance.new("Frame")
        ProgressBar.Name = "ProgressBar"
        ProgressBar.Size = UDim2.new(0, 0, 1, 0)
        ProgressBar.BackgroundColor3 = Color3.new(1,1,1)
        ProgressBar.BackgroundTransparency = 0.8
        ProgressBar.BorderSizePixel = 0
        ProgressBar.Parent = SubmitBtn

        local isChecking = false

        local function CheckKey()
            if isChecking then return end
            isChecking = true
            
            local originalText = SubmitBtn.Text
            SubmitBtn.Text = "Checking..."
            
            -- Progress Bar Animation
            ProgressBar.Size = UDim2.new(0, 0, 1, 0)
            local tween = TweenService:Create(ProgressBar, TweenInfo.new(1.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = UDim2.new(1, 0, 1, 0)})
            tween:Play()
            
            -- Simulate network delay or wait for tween
            task.wait(1.5)

            local Input = KeyInput.Text:gsub("%s+", "")
            local ValidKey = Config.KeySettings.Key
            
            if Config.KeySettings.GrabKeyFromSite then
                local s, r = pcall(function() return game:HttpGet(Config.KeySettings.Site) end)
                if s then 
                    ValidKey = r:gsub("[\n\r]", " "):gsub("%s+", "") 
                else
                    -- Error handling
                    Window:Notification("Error", "Failed to fetch key from site", 3)
                    SubmitBtn.Text = "Error"
                    task.wait(1)
                    SubmitBtn.Text = originalText
                    ProgressBar.Size = UDim2.new(0, 0, 1, 0)
                    isChecking = false
                    return
                end
            end

            if Input == ValidKey then
                SubmitBtn.Text = "Success!"
                SubmitBtn.BackgroundColor3 = Color3.fromRGB(40, 200, 60) -- Green
                task.wait(0.5)
                TweenService:Create(Dimmer, TweenInfo.new(0.5), {BackgroundTransparency = 1}):Play()
                TweenService:Create(KeyFrame, TweenInfo.new(0.5), {Position = UDim2.new(0.5, -210, 1.5, 0)}):Play() -- Slide down
                task.wait(0.5)
                Dimmer:Destroy()
                MainFrame.Visible = true
                Window:Notification("System", "Access Granted", 3)
            else
                SubmitBtn.Text = "Invalid Key"
                SubmitBtn.BackgroundColor3 = Color3.fromRGB(200, 40, 40) -- Red
                TweenService:Create(KeyFrame, TweenInfo.new(0.05), {Position = UDim2.new(0.5, -215, 0.5, -130)}):Play()
                task.wait(0.05)
                TweenService:Create(KeyFrame, TweenInfo.new(0.05), {Position = UDim2.new(0.5, -205, 0.5, -130)}):Play()
                task.wait(0.05)
                TweenService:Create(KeyFrame, TweenInfo.new(0.05), {Position = UDim2.new(0.5, -210, 0.5, -130)}):Play()
                
                task.wait(1)
                SubmitBtn.Text = originalText
                SubmitBtn.BackgroundColor3 = THEME.Accent
                ProgressBar.Size = UDim2.new(0, 0, 1, 0)
                KeyInput.Text = ""
            end
            isChecking = false
        end

        SubmitBtn.MouseButton1Click:Connect(CheckKey)
        KeyInput.FocusLost:Connect(function(enterPressed)
            if enterPressed then CheckKey() end
        end)

        -- Get Key Button
        local GetKeyBtn = Instance.new("TextButton")
        GetKeyBtn.Size = UDim2.new(0.4, 0, 0, 40)
        GetKeyBtn.Position = UDim2.new(0.075, 0, 0.55, 0)
            GetKeyBtn.BackgroundColor3 = THEME.ElementBackground
            GetKeyBtn.Text = "Get Key"
            GetKeyBtn.Font = Enum.Font.GothamBold
            GetKeyBtn.TextColor3 = THEME.TextDim
            GetKeyBtn.TextSize = 14
            GetKeyBtn.AutoButtonColor = false
            GetKeyBtn.Parent = Content

            local GetKeyCorner = Instance.new("UICorner")
            GetKeyCorner.CornerRadius = UDim.new(0, 6)
            GetKeyCorner.Parent = GetKeyBtn

            local GetKeyStroke = Instance.new("UIStroke")
            GetKeyStroke.Thickness = 1
            GetKeyStroke.Color = THEME.Stroke
            GetKeyStroke.Parent = GetKeyBtn

            GetKeyBtn.MouseEnter:Connect(function()
                TweenService:Create(GetKeyStroke, TweenInfo.new(0.2), {Color = THEME.Accent}):Play()
                TweenService:Create(GetKeyBtn, TweenInfo.new(0.2), {TextColor3 = THEME.TextColor}):Play()
            end)
            GetKeyBtn.MouseLeave:Connect(function()
                TweenService:Create(GetKeyStroke, TweenInfo.new(0.2), {Color = THEME.Stroke}):Play()
                TweenService:Create(GetKeyBtn, TweenInfo.new(0.2), {TextColor3 = THEME.TextDim}):Play()
            end)
            
            GetKeyBtn.MouseButton1Click:Connect(function()
                local link = Config.KeySettings.Discord ~= "" and Config.KeySettings.Discord or Config.KeySettings.Site
                if setclipboard then 
                    setclipboard(link) 
                    Window:Notification("System", "Link copied to clipboard", 2)
                end
                GetKeyBtn.Text = "Copied!"
                task.wait(2)
                GetKeyBtn.Text = "Get Key"
            end)
        
        -- Close Button
        local CloseKey = Instance.new("TextButton")
        CloseKey.Size = UDim2.new(0, 30, 0, 30)
        CloseKey.Position = UDim2.new(1, -35, 0, 20)
        CloseKey.BackgroundTransparency = 1
        CloseKey.Text = "×"
        CloseKey.TextColor3 = Color3.fromRGB(150, 150, 150)
        CloseKey.Font = Enum.Font.Gotham
        CloseKey.TextSize = 24
        CloseKey.Parent = KeyFrame
        
        CloseKey.MouseEnter:Connect(function() CloseKey.TextColor3 = Color3.fromRGB(255, 255, 255) end)
        CloseKey.MouseLeave:Connect(function() CloseKey.TextColor3 = Color3.fromRGB(150, 150, 150) end)
        
        CloseKey.MouseButton1Click:Connect(function() ScreenGui:Destroy() end)
    end

    -- Init Sequence (Loading)
    local function InitSequence()
        MainFrame.Visible = true
        
        local LoadingFrame = Instance.new("Frame")
        LoadingFrame.Name = "LoadingFrame"
        LoadingFrame.Size = UDim2.new(1, 0, 1, 0)
        LoadingFrame.BackgroundColor3 = THEME.Background
        LoadingFrame.BorderSizePixel = 0
        LoadingFrame.ZIndex = 10
        LoadingFrame.Parent = MainFrame

        local LoadingCorner = Instance.new("UICorner")
        LoadingCorner.CornerRadius = THEME.CornerRadius
        LoadingCorner.Parent = LoadingFrame

        local LoadIcon = Instance.new("ImageLabel")
        LoadIcon.Name = "LoadIcon"
        LoadIcon.Size = UDim2.new(0, 48, 0, 48)
        LoadIcon.Position = UDim2.new(0.5, 0, 0.5, -25)
        LoadIcon.AnchorPoint = Vector2.new(0.5, 0.5)
        LoadIcon.BackgroundTransparency = 1
        LoadIcon.Image = "rbxassetid://114509698380342"
        LoadIcon.ZIndex = 11
        LoadIcon.Parent = LoadingFrame

        local LoadingBarBg = Instance.new("Frame")
        LoadingBarBg.Name = "LoadingBarBg"
        LoadingBarBg.Size = UDim2.new(0.6, 0, 0, 4)
        LoadingBarBg.Position = UDim2.new(0.5, 0, 0.5, 25)
        LoadingBarBg.AnchorPoint = Vector2.new(0.5, 0.5)
        LoadingBarBg.BackgroundColor3 = Color3.fromRGB(40, 40, 45)
        LoadingBarBg.ZIndex = 11
        LoadingBarBg.Parent = LoadingFrame

        local LoadingBarBgCorner = Instance.new("UICorner")
        LoadingBarBgCorner.CornerRadius = UDim.new(1, 0)
        LoadingBarBgCorner.Parent = LoadingBarBg

        local LoadingText = Instance.new("TextLabel")
        LoadingText.Text = "Initializing Framework..."
        LoadingText.Font = Enum.Font.Gotham
        LoadingText.TextColor3 = THEME.TextDim
        LoadingText.TextSize = 12
        LoadingText.BackgroundTransparency = 1
        LoadingText.Size = UDim2.new(1, 0, 0, 20)
        LoadingText.Position = UDim2.new(0, 0, 1, 5)
        LoadingText.Parent = LoadingBarBg

        local VersionLabel = Instance.new("TextLabel")
        VersionLabel.Text = "v1.0.0"
        VersionLabel.Font = Enum.Font.GothamBold
        VersionLabel.TextColor3 = Color3.fromRGB(80, 80, 80)
        VersionLabel.TextSize = 12
        VersionLabel.BackgroundTransparency = 1
        VersionLabel.Size = UDim2.new(1, 0, 0, 20)
        VersionLabel.Position = UDim2.new(0, 0, 1, -20)
        VersionLabel.Parent = LoadingFrame

        local LoadingBar = Instance.new("Frame")
        LoadingBar.Size = UDim2.new(0, 0, 1, 0)
        LoadingBar.BackgroundColor3 = THEME.Accent
        LoadingBar.ZIndex = 12
        LoadingBar.Parent = LoadingBarBg

        local LoadingBarCorner = Instance.new("UICorner")
        LoadingBarCorner.CornerRadius = UDim.new(1, 0)
        LoadingBarCorner.Parent = LoadingBar

        task.spawn(function()
            TweenService:Create(LoadingBar, TweenInfo.new(1, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = UDim2.new(0.4, 0, 1, 0)}):Play()
            LoadingText.Text = "Loading Assets & Scripts..."
            task.wait(1)
            TweenService:Create(LoadingBar, TweenInfo.new(0.8, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = UDim2.new(0.8, 0, 1, 0)}):Play()
            LoadingText.Text = "Verifying Integrity..."
            task.wait(0.8)
            TweenService:Create(LoadingBar, TweenInfo.new(0.5, Enum.EasingStyle.Quad, Enum.EasingDirection.InOut), {Size = UDim2.new(1, 0, 1, 0)}):Play()
            LoadingText.Text = "Welcome!"
            task.wait(0.5)
            
            local fadeInfo = TweenInfo.new(0.5)
            TweenService:Create(LoadingFrame, fadeInfo, {BackgroundTransparency = 1}):Play()
            TweenService:Create(LoadingText, fadeInfo, {TextTransparency = 1}):Play()
            TweenService:Create(LoadIcon, fadeInfo, {ImageTransparency = 1}):Play()
            TweenService:Create(LoadingBarBg, fadeInfo, {BackgroundTransparency = 1}):Play()
            TweenService:Create(LoadingBar, fadeInfo, {BackgroundTransparency = 1}):Play()
            
            task.wait(0.5)
            LoadingFrame:Destroy()
            
            if Config.KeySystem then
                ShowKeySystem()
            else
                Window:Notification("System", "Welcome to " .. Title, 3)
            end
        end)
    end

    InitSequence()

    return Window
end

return Library
