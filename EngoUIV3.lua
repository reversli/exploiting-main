local settings = {}
local GuiLibrary = {
    ["Tabs"] = {},
    ["Notification"] = nil,
    ["FirstTab"] = nil,
}

local dragutil = loadstring(game:HttpGet("https://raw.githubusercontent.com/joeengo/roblox/main/Dragify.lua", true))()
local acsutil = loadstring(game:HttpGet("https://raw.githubusercontent.com/joeengo/roblox/main/AutoCanvasSize.lua", true))()
local framework = loadstring(game:HttpGet("https://raw.githubusercontent.com/joeengo/ui-framework/main/src.lua", true))()
local ts = game:GetService("TweenService")

function GuiLibrary.Main(name)
    local mainapi = {}

    local name = name or "Unnamed UI"
    local UI = Instance.new("ScreenGui", game:GetService("CoreGui"))
    local Main = Instance.new("Frame")
    local Topbar = Instance.new("Frame")
    local Ico = Instance.new("ImageButton")
    local Sidebar = Instance.new("ScrollingFrame")
    local UIListLayout_2 = Instance.new("UIListLayout")
    local Title = Instance.new("TextLabel")

    UI.Name = "EngoUI"
    UI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    GuiLibrary["ScreenGui"] = UI

    Main.Name = "Main"
    Main.Parent = UI
    Main.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
    Main.BorderSizePixel = 0
    Main.Position = UDim2.new(0.416460395, 0, 0.332163781, 0)
    Main.Size = UDim2.new(0, 635, 0, 424)
    Main.Active = true
    local _DRAG = dragutil.start(Main, Topbar)

    Topbar.Name = "Topbar"
    Topbar.Parent = Main
    Topbar.BackgroundColor3 = Color3.fromRGB(50, 50, 51)
    Topbar.BorderSizePixel = 0
    Topbar.Size = UDim2.new(0, 635, 0, 29)

    Ico.Name = "Ico"
    Ico.Parent = Topbar
    Ico.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Ico.BackgroundTransparency = 1.000
    Ico.BorderSizePixel = 0
    Ico.Position = UDim2.new(0.00787401572, 0, 0.188965514, 0)
    Ico.Size = UDim2.new(0, 17, 0, 17)
    Ico.Image = "rbxassetid://8684103736"

    Title.Name = "Title"
    Title.Parent = Topbar
    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1.000
    Title.BorderSizePixel = 0
    Title.Position = UDim2.new(0.0488188975, 0, 0.103448279, 0)
    Title.Size = UDim2.new(0, 347, 0, 23)
    Title.Font = Enum.Font.GothamBold
    Title.Text = name
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14.000
    Title.TextXAlignment = Enum.TextXAlignment.Left

    Sidebar.Name = "Sidebar"
    Sidebar.Parent = Main
    Sidebar.Active = true
    Sidebar.BackgroundColor3 = Color3.fromRGB(37, 37, 37)
    Sidebar.BorderSizePixel = 0
    Sidebar.Position = UDim2.new(0, 0, 0.0872640759, 0)
    Sidebar.Size = UDim2.new(0, 136, 0, 385)
    Sidebar.ScrollBarThickness = 4
    Sidebar.ScrollBarImageColor3 = Color3.fromRGB(46, 46, 46)

    UIListLayout_2.Parent = Sidebar
    UIListLayout_2.SortOrder = Enum.SortOrder.LayoutOrder
    acsutil.Connect(Sidebar)

    function mainapi.Notification(info, timeout) 

        if GuiLibrary["Notification"] then 
            GuiLibrary["Notification"]:Destroy()
        end

        local Notification = Instance.new("Frame")
        local Text_2 = Instance.new("TextLabel")
        local Info = Instance.new("ImageLabel")
        local Close = Instance.new("ImageButton")

        Notification.Name = "Notification"
        Notification.Parent = Main
        Notification.BackgroundColor3 = Color3.fromRGB(37, 37, 38)
        Notification.BorderColor3 = Color3.fromRGB(29, 29, 29)
        Notification.BorderSizePixel = 2
        Notification.Position = UDim2.new(0.532283485, 0, 0.889150918, 0)
        Notification.Size = UDim2.new(0, 285, 0, 38)
        Notification.Visible = true

        Text_2.Name = "Text"
        Text_2.Parent = Notification
        Text_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Text_2.BackgroundTransparency = 1.000
        Text_2.Position = UDim2.new(0.140350878, 0, 0, 0)
        Text_2.Size = UDim2.new(0, 211, 0, 38)
        Text_2.Font = Enum.Font.Gotham
        Text_2.Text = info
        Text_2.TextColor3 = Color3.fromRGB(255, 255, 255)
        Text_2.TextSize = 14.000
        Text_2.TextWrapped = true
        Text_2.TextXAlignment = Enum.TextXAlignment.Left

        Info.Name = "Info"
        Info.Parent = Notification
        Info.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Info.BackgroundTransparency = 1.000
        Info.Position = UDim2.new(0.0385964923, 0, 0.236842096, 0)
        Info.Size = UDim2.new(0, 20, 0, 20)
        Info.Image = "rbxassetid://8676375407"
        Info.ImageColor3 = Color3.fromRGB(29, 203, 255)

        Close.Name = "Close"
        Close.Parent = Notification
        Close.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Close.BackgroundTransparency = 1.000
        Close.Position = UDim2.new(0.915789425, 0, 0.263157904, 0)
        Close.Size = UDim2.new(0, 18, 0, 18)
        Close.Image = "rbxassetid://8676436308"

        GuiLibrary["Notification"] = Notification
        Close.MouseButton1Click:connect(function()
            Notification:Destroy()
            GuiLibrary["Notification"] = nil
        end)
        if timeout then 
            spawn(function()
                task.wait(timeout)
                if Notification then
                    Notification:Destroy()
                end
                GuiLibrary["Notification"] = nil
            end)
        end
    end

    function mainapi.Tab(name) 
        local tabapi = {}

        local Tab = Instance.new("ScrollingFrame")
        local UIListLayout = Instance.new("UIListLayout")
        local TabButton = Instance.new("TextButton")
        local Icon_2 = Instance.new("ImageLabel")
        local Title_7 = Instance.new("TextLabel")

        Tab.Name = name.."Tab"
        Tab.Parent = Main
        Tab.Active = true
        Tab.BackgroundColor3 = Color3.fromRGB(17, 17, 17)
        Tab.BackgroundTransparency = 1.000
        Tab.BorderSizePixel = 0
        Tab.Position = UDim2.new(0.20814468, 0, 0.0872641504, 0)
        Tab.Size = UDim2.new(0, 502, 0, 379)
        Tab.CanvasPosition = Vector2.new(0, 0)
        Tab.ScrollBarThickness = 4
        Tab.ScrollBarImageColor3 = Color3.fromRGB(46, 46, 46)
        Tab.Visible = false
        if not GuiLibrary["FirstTab"] then 
            GuiLibrary["FirstTab"] = Tab
            Tab.Visible = true
        end

        UIListLayout.Parent = Tab
        UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
        UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
        UIListLayout.Padding = UDim.new(0, 5)
        acsutil.Connect(Tab)

        TabButton.Name = "TabButton"
        TabButton.Parent = Sidebar
        TabButton.BackgroundColor3 = Color3.fromRGB(43, 43, 44)
        TabButton.BorderSizePixel = 0
        TabButton.Position = UDim2.new(0, 0, -7.70645912e-08, 0)
        TabButton.Size = UDim2.new(0, 133, 0, 23)
        TabButton.Font = Enum.Font.GothamSemibold
        TabButton.Text = ""
        TabButton.TextColor3 = Color3.fromRGB(255, 255, 255)
        TabButton.TextSize = 14.000

        Icon_2.Name = "Icon"
        Icon_2.Parent = TabButton
        Icon_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Icon_2.BackgroundTransparency = 1.000
        Icon_2.Position = UDim2.new(0.0450000018, 0, 0.103, 0)
        Icon_2.Selectable = true
        Icon_2.Size = UDim2.new(0, 17, 0, 18)
        Icon_2.Image = "rbxassetid://8677795776"

        Title_7.Name = "Title"
        Title_7.Parent = TabButton
        Title_7.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
        Title_7.BackgroundTransparency = 1.000
        Title_7.BorderSizePixel = 0
        Title_7.Position = UDim2.new(0.234375, 0, 0, 0)
        Title_7.Size = UDim2.new(0, 101, 0, 23)
        Title_7.Font = Enum.Font.GothamSemibold
        Title_7.Text = name
        Title_7.TextColor3 = Color3.fromRGB(255, 255, 255)
        Title_7.TextSize = 13
        Title_7.TextWrapped = true
        Title_7.TextXAlignment = Enum.TextXAlignment.Left

        function tabapi.open() 
            for i,v in next, GuiLibrary["Tabs"] do 
                v.Instance.Visible = false
            end
            Tab.Visible = true
        end
        tabapi["Instance"] = Tab
        
        TabButton.MouseButton1Click:connect(function()
            tabapi.open()
        end)

        function tabapi.Button(argstable)
            assert((argstable["Function"] and argstable["Name"] and argstable["Description"]), "Missing value!")
            local buttonapi = {}

            local Button = Instance.new("Frame")
            local Title6 = Instance.new("TextLabel")
            local Description_3 = Instance.new("TextLabel")
            local Click = Instance.new("TextButton")
            local UICorner_3 = Instance.new("UICorner")
            local Icon = Instance.new("ImageLabel")
            
            Button.Name = "Button"
            Button.Parent = Tab
            Button.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
            Button.BorderSizePixel = 0
            Button.Position = UDim2.new(0.0179999992, 0, 0, 0)
            Button.Size = UDim2.new(0, 478, 0, 70)

            Title6.Name = "Title"
            Title6.Parent = Button
            Title6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title6.BackgroundTransparency = 1.000
            Title6.Position = UDim2.new(0.0309999995, 0, 0.143000007, 0)
            Title6.Size = UDim2.new(0, 427, 0, 19)
            Title6.Font = Enum.Font.GothamBold
            Title6.Text = argstable["Name"]
            Title6.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title6.TextSize = 16.000
            Title6.TextWrapped = true
            Title6.TextXAlignment = Enum.TextXAlignment.Left

            Description_3.Name = "Description"
            Description_3.Parent = Button
            Description_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Description_3.BackgroundTransparency = 1.000
            Description_3.Position = UDim2.new(0.109999999, 0, 0.425999999, 0)
            Description_3.Size = UDim2.new(0, 390, 0, 32)
            Description_3.Font = Enum.Font.Gotham
            Description_3.Text = argstable["Description"]
            Description_3.TextColor3 = Color3.fromRGB(255, 255, 255)
            Description_3.TextSize = 15.000
            Description_3.TextWrapped = true
            Description_3.TextXAlignment = Enum.TextXAlignment.Left

            Click.Name = "Click"
            Click.Parent = Button
            Click.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            Click.BorderColor3 = Color3.fromRGB(130, 130, 130)
            Click.BorderSizePixel = 0
            Click.Position = UDim2.new(0.0320000015, 0, 0.486000001, 0)
            Click.Size = UDim2.new(0, 25, 0, 25)
            Click.AutoButtonColor = false
            Click.Font = Enum.Font.SourceSans
            Click.Text = ""
            Click.TextColor3 = Color3.fromRGB(0, 0, 0)
            Click.TextSize = 14.000

            UICorner_3.CornerRadius = UDim.new(0, 5)
            UICorner_3.Parent = Click

            Icon.Name = "Icon"
            Icon.Parent = Click
            Icon.Active = true
            Icon.AnchorPoint = Vector2.new(0.5, 0.5)
            Icon.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Icon.BackgroundTransparency = 1.000
            Icon.Position = UDim2.new(0.5, 0, 0.5, 0)
            Icon.Size = UDim2.new(0, 20, 0, 18)
            Icon.Image = "rbxassetid://8678474678"


            local buttonfw = framework.button(Click)

            buttonfw.clicked:connect(function()
                argstable["Function"]()
                spawn(function()
                    local ti = TweenInfo.new(0.05, Enum.EasingStyle.Linear, Enum.EasingDirection.InOut)
                    local tween = ts:Create(Click, ti, {Size = UDim2.new(0, 22, 0, 22)}):Play()
                    local tween2 = ts:Create(Click, ti, {Size = UDim2.new(0, 25, 0, 25)})
                    wait(0.05)
                    tween2:Play()
                end)
            end)

            buttonapi["API"] = buttonfw
            buttonapi["Instance"] = Button
            return buttonapi
        end

        function tabapi.Toggle(argstable)
            assert((argstable["Function"] and argstable["Name"] and argstable["Description"]), "Missing value!")
            local toggleapi = {}

            local Toggle = Instance.new("Frame")
            local Title_2 = Instance.new("TextLabel")
            local Description = Instance.new("TextLabel")
            local Toggle_2 = Instance.new("TextButton")
            local UICorner = Instance.new("UICorner")
            local Check = Instance.new("ImageLabel")

            Toggle.Name = "Toggle"
            Toggle.Parent = Tab
            Toggle.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
            Toggle.BorderSizePixel = 0
            Toggle.Position = UDim2.new(0.0179999992, 0, 0, 0)
            Toggle.Size = UDim2.new(0, 478, 0, 70)

            Title_2.Name = "Title"
            Title_2.Parent = Toggle
            Title_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title_2.BackgroundTransparency = 1.000
            Title_2.Position = UDim2.new(0.0309999995, 0, 0.143000007, 0)
            Title_2.Size = UDim2.new(0, 427, 0, 19)
            Title_2.Font = Enum.Font.GothamBold
            Title_2.Text = argstable["Name"]
            Title_2.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title_2.TextSize = 16.000
            Title_2.TextWrapped = true
            Title_2.TextXAlignment = Enum.TextXAlignment.Left

            Description.Name = "Description"
            Description.Parent = Toggle
            Description.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Description.BackgroundTransparency = 1.000
            Description.Position = UDim2.new(0.109999999, 0, 0.425999999, 0)
            Description.Size = UDim2.new(0, 390, 0, 32)
            Description.Font = Enum.Font.Gotham
            Description.Text = argstable["Description"]
            Description.TextColor3 = Color3.fromRGB(255, 255, 255)
            Description.TextSize = 15.000
            Description.TextWrapped = true
            Description.TextXAlignment = Enum.TextXAlignment.Left

            Toggle_2.Name = "Toggle"
            Toggle_2.Parent = Toggle
            Toggle_2.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            Toggle_2.BorderColor3 = Color3.fromRGB(130, 130, 130)
            Toggle_2.BorderSizePixel = 0
            Toggle_2.Position = UDim2.new(0.0320000015, 0, 0.486000001, 0)
            Toggle_2.Size = UDim2.new(0, 25, 0, 25)
            Toggle_2.AutoButtonColor = false
            Toggle_2.Font = Enum.Font.SourceSans
            Toggle_2.Text = ""
            Toggle_2.TextColor3 = Color3.fromRGB(0, 0, 0)
            Toggle_2.TextSize = 14.000

            UICorner.CornerRadius = UDim.new(0, 5)
            UICorner.Parent = Toggle_2

            Check.Name = "Check"
            Check.Parent = Toggle_2
            Check.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Check.BackgroundTransparency = 1.000
            Check.Position = UDim2.new(0.159999996, 0, 0.159999996, 0)
            Check.Size = UDim2.new(0, 18, 0, 16)
            Check.Image = "rbxassetid://8677598889"
            Check.ImageTransparency = 1

            local fw = framework.toggle(Toggle_2)

            fw.enabled:connect(function()
                ts:Create(Check, TweenInfo.new(0.2, Enum.EasingStyle.Circular, Enum.EasingDirection.In), {ImageTransparency = 0}):Play()
            end)
            fw.disabled:connect(function()
                ts:Create(Check, TweenInfo.new(0.2, Enum.EasingStyle.Circular, Enum.EasingDirection.Out), {ImageTransparency = 1}):Play()
            end)
            fw.toggled:connect(argstable["Function"])
            toggleapi["API"] = fw
            return toggleapi
        end

        function tabapi.Slider(argstable)
            assert((argstable["Function"] and argstable["Name"] and argstable["Description"] and argstable["Min"] and argstable["Max"]), "Missing value!")
            local sliderapi = {}

            local Slider = Instance.new("Frame")
            local Title_6 = Instance.new("TextLabel")
            local Description_5 = Instance.new("TextLabel")
            local SliderBack = Instance.new("Frame")
            local UICorner_4 = Instance.new("UICorner")
            local SliderFill = Instance.new("Frame")
            local UICorner_5 = Instance.new("UICorner")
            local Value = Instance.new("TextBox")

            Slider.Name = "Slider"
            Slider.Parent = Tab
            Slider.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
            Slider.BorderSizePixel = 0
            Slider.Position = UDim2.new(0.0229540914, 0, 0.446753174, 0)
            Slider.Size = UDim2.new(0, 478, 0, 78)

            Title_6.Name = "Title"
            Title_6.Parent = Slider
            Title_6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title_6.BackgroundTransparency = 1.000
            Title_6.Position = UDim2.new(0.0320000015, 0, 0.134706378, 0)
            Title_6.Size = UDim2.new(0, 427, 0, 19)
            Title_6.Font = Enum.Font.GothamBold
            Title_6.Text = argstable["Name"]
            Title_6.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title_6.TextSize = 16.000
            Title_6.TextWrapped = true
            Title_6.TextXAlignment = Enum.TextXAlignment.Left

            Description_5.Name = "Description"
            Description_5.Parent = Slider
            Description_5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Description_5.BackgroundTransparency = 1.000
            Description_5.Position = UDim2.new(0.0320000425, 0, 0.380156845, 0)
            Description_5.Size = UDim2.new(0, 444, 0, 17)
            Description_5.Font = Enum.Font.Gotham
            Description_5.Text = argstable["Description"]
            Description_5.TextColor3 = Color3.fromRGB(255, 255, 255)
            Description_5.TextSize = 15.000
            Description_5.TextWrapped = true
            Description_5.TextXAlignment = Enum.TextXAlignment.Left
            Description_5.TextYAlignment = Enum.TextYAlignment.Top

            SliderBack.Name = "SliderBack"
            SliderBack.Parent = Slider
            SliderBack.BackgroundColor3 = Color3.fromRGB(30, 30, 30)
            SliderBack.BorderSizePixel = 0
            SliderBack.Position = UDim2.new(0.0369999446, 0, 0.679999709, 0)
            SliderBack.Size = UDim2.new(0, 272, 0, 13)

            UICorner_4.Parent = SliderBack

            SliderFill.Name = "SliderFill"
            SliderFill.Parent = SliderBack
            SliderFill.BackgroundColor3 = Color3.fromRGB(165, 165, 165)
            SliderFill.BorderSizePixel = 0
            SliderFill.Position = UDim2.new(-0.00877402816, 0, -0.0183903612, 0)
            SliderFill.Size = UDim2.new(0, 219, 0, 13)

            UICorner_5.Parent = SliderFill

            Value.Name = "Value"
            Value.Parent = Slider
            Value.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Value.BackgroundTransparency = 1.000
            Value.Position = UDim2.new(0.632000029, 0, 0.680000007, 0)
            Value.Size = UDim2.new(0, 142, 0, 15)
            Value.ClearTextOnFocus = false
            Value.Font = Enum.Font.GothamBold
            Value.PlaceholderText = "Value"
            Value.Text = argstable["Default"] or argstable["Min"]
            Value.TextColor3 = Color3.fromRGB(255, 255, 255)
            Value.TextSize = 14.000
            Value.TextXAlignment = Enum.TextXAlignment.Left
           
            local fw = framework.sizeslider(SliderBack, SliderFill, argstable["Min"], argstable["Max"], 0.1)
            fw:set(argstable["Default"] or argstable["Min"])

            fw.Updated:connect(function(value) 
                argstable["Function"](value)
                Value.Text = tostring(value)
            end)            

            fw.Input:connect(function(sliding)
                if sliding and _DRAG then
                    _DRAG.End()
                else
                    _DRAG = dragutil.start(Main, Topbar)
                end
            end)

            Value.FocusLost:connect(function()
                if tonumber(Value.Text) then 
                    fw:set(Value.Text)
                else
                    Value.Text = ""
                    mainapi.Notification("Sliderbox expected number!", 4)
                end
            end)
            sliderapi["API"] = fw
            return sliderapi
        end

        function tabapi.Textbox(argstable)
            assert((argstable["Function"] and argstable["Name"] and argstable["Description"]), "Missing value!")
            local textboxapi = {}
                    
            local Textbox = Instance.new("Frame")
            local Title_5 = Instance.new("TextLabel")
            local Description_4 = Instance.new("TextLabel")
            local Textbox_2 = Instance.new("Frame")
            local Textbox_3 = Instance.new("TextBox")
            
            Textbox.Name = "Textbox"
            Textbox.Parent = Tab
            Textbox.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
            Textbox.BorderSizePixel = 0
            Textbox.Position = UDim2.new(0.0229540914, 0, 0.662337601, 0)
            Textbox.Size = UDim2.new(0, 478, 0, 78)

            Title_5.Name = "Title"
            Title_5.Parent = Textbox
            Title_5.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title_5.BackgroundTransparency = 1.000
            Title_5.Position = UDim2.new(0.0320000015, 0, 0.0711921751, 0)
            Title_5.Size = UDim2.new(0, 427, 0, 19)
            Title_5.Font = Enum.Font.GothamBold
            Title_5.Text = argstable["Name"]
            Title_5.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title_5.TextSize = 16.000
            Title_5.TextWrapped = true
            Title_5.TextXAlignment = Enum.TextXAlignment.Left

            Description_4.Name = "Description"
            Description_4.Parent = Textbox
            Description_4.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Description_4.BackgroundTransparency = 1.000
            Description_4.Position = UDim2.new(0.0320000425, 0, 0.322164953, 0)
            Description_4.Size = UDim2.new(0, 444, 0, 18)
            Description_4.Font = Enum.Font.Gotham
            Description_4.Text = argstable["Description"]
            Description_4.TextColor3 = Color3.fromRGB(255, 255, 255)
            Description_4.TextSize = 15.000
            Description_4.TextWrapped = true
            Description_4.TextXAlignment = Enum.TextXAlignment.Left
            Description_4.TextYAlignment = Enum.TextYAlignment.Top

            Textbox_2.Name = "Textbox"
            Textbox_2.Parent = Textbox
            Textbox_2.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            Textbox_2.BorderSizePixel = 0
            Textbox_2.Position = UDim2.new(0.034907639, 0, 0.590000272, 0)
            Textbox_2.Size = UDim2.new(0, 272, 0, 24)

            Textbox_3.Name = "Textbox"
            Textbox_3.Parent = Textbox_2
            Textbox_3.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            Textbox_3.BackgroundTransparency = 1.000
            Textbox_3.BorderSizePixel = 0
            Textbox_3.Position = UDim2.new(0.017394118, 0, 0, 0)
            Textbox_3.Size = UDim2.new(0, 266, 0, 24)
            Textbox_3.Font = Enum.Font.Gotham
            Textbox_3.PlaceholderText = "Input text"
            Textbox_3.Text = ""
            Textbox_3.TextColor3 = Color3.fromRGB(255, 255, 255)
            Textbox_3.TextSize = 14.000
            Textbox_3.TextXAlignment = Enum.TextXAlignment.Left


            local fw = framework.box(Textbox_3)
            fw.Updated:connect(function(value)
                argstable["Function"](value)
            end)
            textboxapi["API"] = fw

            return textboxapi
        end

        function tabapi.Bind(argstable)
            assert((argstable["Function"] and argstable["Name"]), "Missing value!")
            local bindapi = {}

            local Bind = Instance.new("Frame")
            local Title_3 = Instance.new("TextLabel")
            local Description_2 = Instance.new("TextLabel")
            local Bind_2 = Instance.new("TextButton")
            local UICorner_2 = Instance.new("UICorner")
            local Edit = Instance.new("ImageLabel")
            
            Bind.Name = "Bind"
            Bind.Parent = Tab
            Bind.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
            Bind.BorderSizePixel = 0
            Bind.Position = UDim2.new(0.0179999992, 0, 0, 0)
            Bind.Size = UDim2.new(0, 478, 0, 70)

            Title_3.Name = "Title"
            Title_3.Parent = Bind
            Title_3.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title_3.BackgroundTransparency = 1.000
            Title_3.Position = UDim2.new(0.0306367744, 0, 0.142508507, 0)
            Title_3.Size = UDim2.new(0, 427, 0, 19)
            Title_3.Font = Enum.Font.GothamBold
            Title_3.Text = argstable["Name"]
            Title_3.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title_3.TextSize = 16.000
            Title_3.TextWrapped = true
            Title_3.TextXAlignment = Enum.TextXAlignment.Left

            Description_2.Name = "Description"
            Description_2.Parent = Bind
            Description_2.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Description_2.BackgroundTransparency = 1.000
            Description_2.Position = UDim2.new(0.110240854, 0, 0.426025391, 0)
            Description_2.Size = UDim2.new(0, 391, 0, 32)
            Description_2.Font = Enum.Font.Gotham
            Description_2.Text = not argstable["Default"] and "Unbound" or ("Bound to "..argstable["Default"].Name)
            Description_2.TextColor3 = Color3.fromRGB(255, 255, 255)
            Description_2.TextSize = 15.000
            Description_2.TextWrapped = true
            Description_2.TextXAlignment = Enum.TextXAlignment.Left

            Bind_2.Name = "Bind"
            Bind_2.Parent = Bind
            Bind_2.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            Bind_2.BorderColor3 = Color3.fromRGB(130, 130, 130)
            Bind_2.BorderSizePixel = 0
            Bind_2.Position = UDim2.new(0.0320071951, 0, 0.485714287, 0)
            Bind_2.Size = UDim2.new(0, 25, 0, 25)
            Bind_2.AutoButtonColor = false
            Bind_2.Font = Enum.Font.GothamSemibold
            Bind_2.Text = "F"
            Bind_2.TextColor3 = Color3.fromRGB(255, 255, 255)
            Bind_2.TextSize = 16.000
            Bind_2.TextWrapped = true

            UICorner_2.CornerRadius = UDim.new(0, 5)
            UICorner_2.Parent = Bind_2

            Edit.Name = "Edit"
            Edit.Parent = Bind_2
            Edit.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Edit.BackgroundTransparency = 1.000
            Edit.Position = UDim2.new(0.159999996, 0, 0.159999996, 0)
            Edit.Size = UDim2.new(0, 18, 0, 16)
            Edit.Visible = false
            Edit.Image = "rbxassetid://8678415975"

            local fw = framework.Keybind(Bind_2)

            Bind_2.MouseEnter:connect(function()
                Bind_2.Text = ""
                Edit.Visible = true
            end)

            Bind_2.MouseLeave:connect(function()
                Bind_2.Text = "F"
                Edit.Visible = false
            end)

            Bind_2.MouseButton1Click:connect(function()
                Description_2.Text = "Recording key..."
            end)

            fw.Updated:connect(function(value) 
                if value == Enum.KeyCode.Backspace then 
                    fw:set({Name = ""})
                    Description_2.Text = "Unbound"
                    return
                end
                Description_2.Text = "Bound to "..value.Name
            end)

            fw.Pressed:connect(function()
                argstable["Function"]()
            end)

            bindapi["API"] = fw
            return bindapi
        end

        function tabapi.Dropdown(argstable)
            local dropdownapi = {["Open"] = false}

            local Dropdown = Instance.new("Frame")
            local Title_7 = Instance.new("TextLabel")
            local Description_6 = Instance.new("TextLabel")
            local Dropdown_2 = Instance.new("Frame")
            local Text1 = Instance.new("TextLabel")
            local Drop = Instance.new("ImageButton")
            local ItemContainer = Instance.new("ScrollingFrame")
            local UIListLayout5 = Instance.new("UIListLayout")
            local Option = Instance.new("TextButton")
            local Text = Instance.new("TextLabel")

            Dropdown.Name = "Dropdown"
            Dropdown.Parent = Tab
            Dropdown.BackgroundColor3 = Color3.fromRGB(38, 38, 38)
            Dropdown.BorderSizePixel = 0
            Dropdown.Position = UDim2.new(0.0229540914, 0, 0.194805115, 0)
            Dropdown.Size = UDim2.new(0, 478, 0, 86)
            Dropdown.ZIndex = 2

            Title_7.Name = "Title"
            Title_7.Parent = Dropdown
            Title_7.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Title_7.BackgroundTransparency = 1.000
            Title_7.Position = UDim2.new(0.0369998179, 0, 0.143000051, 0)
            Title_7.Size = UDim2.new(0, 427, 0, 12)
            Title_7.Font = Enum.Font.GothamBold
            Title_7.Text = argstable["Name"]
            Title_7.TextColor3 = Color3.fromRGB(255, 255, 255)
            Title_7.TextSize = 16.000
            Title_7.TextWrapped = true
            Title_7.TextXAlignment = Enum.TextXAlignment.Left

            Description_6.Name = "Description"
            Description_6.Parent = Dropdown
            Description_6.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Description_6.BackgroundTransparency = 1.000
            Description_6.Position = UDim2.new(0.0369129889, 0, 0.348743886, 0)
            Description_6.Size = UDim2.new(0, 441, 0, 10)
            Description_6.Font = Enum.Font.Gotham
            Description_6.Text = argstable["Description"]
            Description_6.TextColor3 = Color3.fromRGB(255, 255, 255)
            Description_6.TextSize = 15.000
            Description_6.TextWrapped = true
            Description_6.TextXAlignment = Enum.TextXAlignment.Left
            Description_6.TextYAlignment = Enum.TextYAlignment.Top

            Dropdown_2.Name = "Dropdown"
            Dropdown_2.Parent = Dropdown
            Dropdown_2.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            Dropdown_2.BorderSizePixel = 0
            Dropdown_2.ClipsDescendants = true
            Dropdown_2.Position = UDim2.new(0.0359999985, 0, 0.600000024, 0)
            Dropdown_2.Size = UDim2.new(0, 273, 0, 25)
            Dropdown_2.ZIndex = 4

            Text1.Name = "Text"
            Text1.Parent = Dropdown_2
            Text1.BackgroundColor3 = Color3.fromRGB(60, 60, 60)
            Text1.BackgroundTransparency = 1.000
            Text1.BorderSizePixel = 0
            Text1.Position = UDim2.new(0.017394118, 0, 0, 0)
            Text1.Size = UDim2.new(0, 232, 0, 24)
            Text1.ZIndex = 6
            Text1.Font = Enum.Font.Gotham
            Text1.Text = "Pick an option"
            Text1.TextColor3 = Color3.fromRGB(255, 255, 255)
            Text1.TextSize = 14.000
            Text1.TextXAlignment = Enum.TextXAlignment.Left

            Drop.Name = "Drop"
            Drop.Parent = Dropdown_2
            Drop.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Drop.BackgroundTransparency = 1.000
            Drop.BorderSizePixel = 0
            Drop.Position = UDim2.new(0.909999967, 0, 0, 0)
            Drop.Size = UDim2.new(0, 20, 0, 24)
            Drop.ZIndex = 2
            Drop.Image = "rbxassetid://8678019862"

            ItemContainer.Name = "ItemContainer"
            ItemContainer.Parent = Dropdown_2
            ItemContainer.Active = true
            ItemContainer.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            ItemContainer.BackgroundTransparency = 1.000
            ItemContainer.BorderSizePixel = 0
            ItemContainer.Position = UDim2.new(0, 0, 0.179104477, 0)
            ItemContainer.Size = UDim2.new(0, 273, 0, 110)
            ItemContainer.ScrollBarThickness = 3
            ItemContainer.ScrollBarImageColor3 = Color3.fromRGB(97, 97, 97)
            ItemContainer.Visible = false

            UIListLayout5.Parent = ItemContainer
            UIListLayout5.HorizontalAlignment = Enum.HorizontalAlignment.Center
            UIListLayout5.SortOrder = Enum.SortOrder.LayoutOrder
            acsutil.Connect(ItemContainer)

            -- BEGIN TEMPLATE --
            Option.Name = "Option"
            Option.BackgroundColor3 = Color3.fromRGB(52, 52, 52)
            Option.BorderSizePixel = 0
            Option.Size = UDim2.new(0, 273, 0, 23)
            Option.Font = Enum.Font.Gotham
            Option.Text = ""
            Option.TextColor3 = Color3.fromRGB(255, 255, 255)
            Option.TextSize = 14.000
            Option.TextXAlignment = Enum.TextXAlignment.Left

            Text.Name = "Text"
            Text.Parent = Option
            Text.AnchorPoint = Vector2.new(0, 0.5)
            Text.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
            Text.BackgroundTransparency = 1.000
            Text.Position = UDim2.new(0.0156059964, 0, 0.5, 0)
            Text.Size = UDim2.new(0, 242, 0, 16)
            Text.Font = Enum.Font.Gotham
            Text.Text = "Option"
            Text.TextColor3 = Color3.fromRGB(255, 255, 255)
            Text.TextSize = 14.000
            Text.TextXAlignment = Enum.TextXAlignment.Left
            -- END TEMPLATE --

            local fw = framework.Dropdown(ItemContainer, argstable["List"], Option)

            function dropdownapi.Enable() 
                dropdownapi["Open"] = not dropdownapi["Open"]
                local size = dropdownapi["Open"] and UDim2.new(0, 273, 0, 135) or UDim2.new(0, 273, 0, 25)
                Dropdown_2.Size = size
                ItemContainer.Visible = dropdownapi["Open"]
            end

            Drop.MouseButton1Click:connect(dropdownapi.Enable)

            fw.Selected:connect(function(option) 
                argstable["Function"](option)
                Text1.Text = tostring(option)
                dropdownapi.Enable()
            end)

            dropdownapi["API"] = fw
            return dropdownapi
        end

        GuiLibrary["Tabs"][name] = tabapi
        return tabapi
    end

    Ico.MouseButton1Click:connect(function()
        mainapi.Notification("EngoUI-V3 by engo#0320\nVisit my site @ https://engo.gq", 5)
    end)

    return mainapi
end

return GuiLibrary
