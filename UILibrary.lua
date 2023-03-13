local Library = {}
local HttpService = game:GetService("HttpService")
local TS = game:GetService("TweenService")
local TXTSRV = game:GetService("TextService")
local UIS = game:GetService("UserInputService")

-- color constants
Library.Colors = {
    LRED = Color3.fromRGB(250, 100, 100),
    LGREEN = Color3.fromRGB(100, 250, 100),
}

Library.CreatedElements = {}
Library.Tabs = {}

-- make tables lowercase
local function formatTable(tbl) 
    local n = {}
    for i, v in next, tbl do 
        n[(type(i) == "string" and i:lower()) or i] = v
    end
    return n
end

-- function to make sure proper arguments are provided and returns arguments in a way so you can put parameters in a table or not.
local function argEval(def, args) 
    local args = formatTable(args or {})
    local handled = {}
    local EVAL = false

    for i, v in next, def do 
        for k, j in next, args do
            EVAL = true
            if typeof(j) == 'table' then
                local j = formatTable(j)
                local arg = j[v] == nil and j[i] or j[v]
                if arg == nil then 
                   -- warn("[Library] expected argument #" .. tostring(i) .. " '" .. v .. "'")
                end
                handled[#handled+1] = arg
            else
                local arg = args[i]
                if arg == nil then 
                  --  warn("[Library] expected argument #" .. tostring(i) .. " '" .. v .. "'")
                end
                handled[#handled+1] = arg 
                break
            end
        end
        if not EVAL then
           -- warn("[Library] expected argument #" .. tostring(i) .. " '" .. v .. "'")
        end 
    end

    return table.unpack(handled)
end

local ConvertToParseableTable
function ConvertToParseableTable(t) 
    local nt = {}
    local t = t or {}
    for i, v in next, t do 
        local ty = typeof(v)
        if ty == "table" then
            nt[i] = ConvertToParseableTable(v)
        elseif ty == "string" or ty == "number" or ty == "boolean" then
            nt[i] = v
        elseif ty == "Color3" then
            nt[i] = {__LIBRARY_COLOR_VALUE = true, R = v.R, B = v.B, G = v.G}
        elseif ty == "EnumItem" then
            nt[i] = {__LIBRARY_ENUM_VALUE = true, Path = tostring(v):gsub("Enum%.", ""):split(".")}
        end
    end
    return nt
end

local ConvertFromParseableTable
function ConvertFromParseableTable(t) 
    local nt = {}
    local t = t or {}
    for i, v in next, t do 
        local ty = typeof(v)
        if ty == "table" then
            if v.__LIBRARY_COLOR_VALUE == true then
                nt[i] = Color3.new(v.R, v.G, v.B)
                continue
            end 
            if v.__LIBRARY_ENUM_VALUE == true then 
                nt[i] = Enum
                for i2, v2 in next, (typeof(v.Path[1]) == "table" and v.Path[1] or v.Path) do 
                    nt[i] = nt[i][v2]
                end
                continue
            end
            nt[i] = ConvertFromParseableTable(v)
        elseif ty == "string" or ty == "number" or ty == "boolean" then
            nt[i] = v
        end
    end
    return nt
end

function Library:Tween(...) 
    task.spawn(function(...)
        TS:Create(...):Play()
    end, ...)
end

function Library:Search(Text, Inverse) 
    local Found = {}
    for i,v in next, Library.Elements do
        local Valid = (v.Name:lower():match(Text:lower())) ~= nil
        if (Inverse and not Valid) or (not Inverse and Valid) then 
            Found[#Found+1] = v
        end
    end
    return Found
end

function Library:PerformSearch(Text) 
    local Search = {}
    local Invalid = Library:Search(Text, true)
    for i,v in next, Invalid do 
        v.Element.Visible = false
    end

    function Search:End() 
        for i,v in next, Library.Elements do 
            v.Element.Visible = true
        end
    end

    return Search
end

function Library:End() 
    if Library.InputConnection and Library.InputConnection.Connected then 
        Library.InputConnection:Disconnect()
    end
    if Library.ScreenGui then
        Library.ScreenGui:Destroy()
    end
    getgenv()._Library = nil
end

function Library:Save(folder, filename) 
    if not isfolder(folder) then
        makefolder(folder)
    end

    local Config = ConvertToParseableTable(Library.CreatedElements)
    Config = HttpService:JSONEncode(Config)

    writefile(folder .. "/" .. filename, Config)

    repeat task.wait() until isfile(folder .. "/" .. filename)
end

function Library:Load(folder, filename) 
    local Config = isfile(folder .. "/" .. filename) and readfile(folder .. "/" .. filename)
    Config = HttpService:JSONDecode(Config)
    Config = ConvertFromParseableTable(Config)

    for i, v in next, Config do 
        for i2, v2 in next, Library.CreatedElements do 
            if v2.Element.Name == v.Element.Name and v2.Type == v.Type then 
                
                if v2.Type == "Toggle" then 
                    if v2.Enabled ~= v.Enabled then
                        v2:Toggle()
                    end
                end

                if v2.Type == "Slider" then 
                    if v2.Value ~= v.Value then
                        v2:Set(v.Value)
                    end
                end

                if v2.Type == "Selector" then 
                    if v2.Selected.Value ~= v.Selected.Value then
                        v2:Select(v.Selected.Value)
                    end
                end

                if v2.Type == "Textbox" then 
                    if v2.Value ~= v.Value then
                        v2:Update(v.Value)
                    end
                end

                if v2.Type == "Bind" then 
                    if v2.Bind ~= v.Bind then
                        v2:Set(v.Bind)
                    end
                end

                break
            end
        end
    end
end

-- init function
function Library:Init(...) 
    local _Name = argEval({"name"}, {...})

    if _Library then 
        _Library:End()
    end

    Library.Elements = {}

    local UI = Instance.new("ScreenGui", gethui and gethui())
    if not gethui then syn.protect_gui(UI); UI.Parent = game:GetService("CoreGui") end
    UI.Name = _Name
    UI.ZIndexBehavior = Enum.ZIndexBehavior.Sibling

    Library.ScreenGui = UI

    local Frame = Instance.new("Frame")
    Frame.Parent = UI
    Frame.ZIndex = 2
    Frame.AnchorPoint = Vector2.one / 2
    Frame.BackgroundColor3 = Color3.fromRGB(25, 25, 25)
    Frame.BorderSizePixel = 0
    Frame.Position = UDim2.new(0.5, 0, 0.5, 0)
    Frame.Size = UDim2.new(0, 404, 0, 311)
    Frame.Draggable = true
    Frame.Active = true

    local TabLabelContainer = Instance.new("Frame")
    TabLabelContainer.Parent = Frame
    TabLabelContainer.ZIndex = 2
    TabLabelContainer.AnchorPoint = Vector2.new(0.5, 0)
    TabLabelContainer.BackgroundTransparency = 1
    TabLabelContainer.BorderSizePixel = 0
    TabLabelContainer.Position = UDim2.new(0.5, 0, 0, 25)
    TabLabelContainer.Size = UDim2.new(0, 404, 0, 20)

    local ContainerUIListLayout = Instance.new("UIListLayout")
    ContainerUIListLayout.FillDirection = Enum.FillDirection.Horizontal
    ContainerUIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    ContainerUIListLayout.VerticalAlignment = Enum.VerticalAlignment.Center
    ContainerUIListLayout.Padding = UDim.new(0, 10)
    ContainerUIListLayout.Parent = TabLabelContainer

    Library.Frame = Frame
    Library.TabLabelContainer = TabLabelContainer

    local UIGradient = Instance.new("UIGradient")
    UIGradient.Color = ColorSequence.new{ColorSequenceKeypoint.new(0.00, Color3.fromRGB(162, 85, 255)), ColorSequenceKeypoint.new(1.00, Color3.fromRGB(108, 147, 255))}
    UIGradient.Parent = Frame

    local TextLabel = Instance.new("TextLabel")
    TextLabel.Parent = Frame
    TextLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.BackgroundTransparency = 1.000
    TextLabel.Size = UDim2.new(0, 300, 0, 28)
    TextLabel.Position = UDim2.new(0, 10, 0, 0)
    TextLabel.Font = Enum.Font.GothamBold
    TextLabel.Text = _Name
    TextLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TextLabel.TextSize = 14.000
    TextLabel.TextXAlignment = Enum.TextXAlignment.Left

    --[[
    local SearchBox = Instance.new("TextBox")
    SearchBox.ClearTextOnFocus = false
    SearchBox.Parent = Frame
    SearchBox.AnchorPoint = Vector2.new(0.5, 0.5)
    SearchBox.Position = UDim2.new(0.749467909, 2, 0, -15)
    SearchBox.Size = UDim2.new(0, 199, 0, 25)
    SearchBox.Font = Enum.Font.GothamMedium
    SearchBox.Text = ""
    SearchBox.PlaceholderText = "Search"
    SearchBox.TextSize = 14
    SearchBox.TextColor3 = Color3.new(1, 1, 1)
    SearchBox.BackgroundColor3 = Color3.fromRGB(13, 11, 25)
    SearchBox.Visible = false

    local UICorner = Instance.new("UICorner")
    UICorner.Parent = SearchBox

    local SearchButton = Instance.new("ImageButton")
    SearchButton.Name = "SearchButton"
    SearchButton.Parent = Frame
    SearchButton.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    SearchButton.BackgroundTransparency = 1
    SearchButton.Position = UDim2.new(0.936, 0, 0.013, 0)
    SearchButton.Size = UDim2.new(0, 20, 0, 20)
    SearchButton.Image = "rbxassetid://11759335689"

    SearchButton.MouseButton1Click:Connect(function()
        SearchBox.Visible = not SearchBox.Visible
        if SearchBox.Visible then 
            SearchBox:CaptureFocus()
        else
            SearchBox:ReleaseFocus()
            if Library.CurrentSearch then 
                Library.CurrentSearch:End()
                SearchBox.Text = ""
            end
        end
    end)

    SearchBox:GetPropertyChangedSignal("Text"):Connect(function()
        if Library.CurrentSearch then 
            Library.CurrentSearch:End()
        end
        if SearchBox.Text ~= "" then
            Library.CurrentSearch = Library:PerformSearch(SearchBox.Text)
        end
    end)
    ]]

    Library.InputConnection = UIS.InputBegan:Connect(function(Input, GPE)
        if Input.UserInputType == Enum.UserInputType.Keyboard then
            if Input.KeyCode == Enum.KeyCode.Unknown then
                return
            end
    
            if Library.Recording then 
                Library.Recording:Set(Input.KeyCode)
                Library.Recording:StopRecording()
                Library.Recording = nil
                return
            end
    
            for i, v in next, Library.CreatedElements do 
                if v.Type == "Bind" then 
                    if v.Bind == Input.KeyCode then 
                        v:Press()
                    end
                end
            end
        end
    end)
end

local FirstTab = true
function Library:Tab(...) 
    local _Name = argEval({"name"}, {...})
    local Tab = {}
    Library.Tabs[#Library.Tabs+1] = Tab

    local ScrollingFrame = Instance.new("ScrollingFrame")
    ScrollingFrame.Parent = Library.Frame
    ScrollingFrame.Active = true
    ScrollingFrame.Visible = FirstTab
    ScrollingFrame.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    ScrollingFrame.BackgroundTransparency = 1.000
    ScrollingFrame.BorderSizePixel = 0
    ScrollingFrame.Position = UDim2.new(0, 0, 0, 47)
    ScrollingFrame.Size = UDim2.new(0, 404, 0, 260)
    ScrollingFrame.ScrollBarThickness = 0

    Tab.Scroller = ScrollingFrame

    local UIListLayout = Instance.new("UIListLayout")
    UIListLayout.Parent = ScrollingFrame
    UIListLayout.HorizontalAlignment = Enum.HorizontalAlignment.Center
    UIListLayout.VerticalAlignment = Enum.VerticalAlignment.Top
    UIListLayout.SortOrder = Enum.SortOrder.LayoutOrder
    UIListLayout.Padding = UDim.new(0, 5)

    local TabLabel = Instance.new("TextButton")
    TabLabel.Name = "TabLabel"
    TabLabel.AutoButtonColor = false
    TabLabel.Text = _Name
    TabLabel.Font = FirstTab and Enum.Font.GothamBold or Enum.Font.Gotham
    TabLabel.TextSize = 12.5
    TabLabel.Parent = Library.TabLabelContainer
    TabLabel.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    TabLabel.BackgroundTransparency = 1
    TabLabel.BorderSizePixel = 0
    TabLabel.Position = UDim2.new(0, 0, 0, 0)
    TabLabel.Size = UDim2.new(0, 380, 0, 35)
    TabLabel.TextColor3 = Color3.fromRGB(255, 255, 255)
    TabLabel.TextXAlignment = Enum.TextXAlignment.Left

    Tab.TabLabel = TabLabel

    local TextSize = TXTSRV:GetTextSize(_Name, TabLabel.TextSize, TabLabel.Font, Vector2.one * 9e9)
    TabLabel.Size = UDim2.fromOffset(TextSize.X, TextSize.Y)
    
    TabLabel.MouseButton1Click:Connect(function() 
        for i, v in next, Library.Tabs do 
            v.Scroller.Visible = false
            v.TabLabel.Font = Enum.Font.Gotham
        end
        Tab.Scroller.Visible = true
        Tab.TabLabel.Font = Enum.Font.GothamBold
    end)

    UIListLayout:GetPropertyChangedSignal("AbsoluteContentSize"):Connect(function()
        ScrollingFrame.CanvasSize = UDim2.fromOffset(0, UIListLayout.AbsoluteContentSize.Y + 10)
    end)

    FirstTab = false
    
    return Tab
end

function Library:Element(...)
    local _Name, _Hover, _Tab = argEval({"name", "hover", "tab"}, {...})

    local Element = Instance.new("TextButton")
    Element.Name = "Element"
    Element.AutoButtonColor = false
    Element.Text = ""
    Element.Parent = _Tab.Scroller
    Element.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Element.BackgroundTransparency = 0.925
    Element.BorderSizePixel = 0
    Element.Position = UDim2.new(0.0297029708, 0, 0, 0)
    Element.Size = UDim2.new(0, 380, 0, 35)

    local Title = Instance.new("TextLabel")
    Title.Name = "Title"
    Title.Parent = Element
    Title.AnchorPoint = Vector2.new(0.5, 0.5)
    Title.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Title.BackgroundTransparency = 1.000
    Title.Position = UDim2.new(0.263999999, 0, 0.5, 0)
    Title.Size = UDim2.new(0, 183, 0, 17)
    Title.Font = Enum.Font.GothamMedium
    Title.Text = _Name
    Title.TextColor3 = Color3.fromRGB(255, 255, 255)
    Title.TextSize = 14.000
    Title.TextXAlignment = Enum.TextXAlignment.Left

    local UICorner = Instance.new("UICorner")
    UICorner.Parent = Element

    local Container = Instance.new("Frame")
    Container.Name = "Container"
    Container.Parent = Element
    Container.AnchorPoint = Vector2.new(0, 0.5)
    Container.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Container.BackgroundTransparency = 1.000
    Container.BorderSizePixel = 0
    Container.Position = UDim2.new(0.505000055, 0, 0.5, 0)
    Container.Size = UDim2.new(0, 187, 0, 36)

    if _Hover then 
        Element.MouseEnter:Connect(function()
            Library:Tween(
                Element,
                TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), 
                {BackgroundTransparency = 0.95}
            )
        end)

        Element.MouseLeave:Connect(function()
            Library:Tween(
                Element, 
                TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), 
                {BackgroundTransparency = 0.925}
            )
        end)
    end

    local Element2 = {Element = Element, Container = Container, Name = _Name}
    Library.Elements[#Library.Elements+1] = Element2
    return Element2
end

function Library:Seperator(_Tab) 
    local Element = Library:Element("", false, _Tab)
    Element.Element.Size = UDim2.new(0, 380, 0, 1)
    Element.Element.BackgroundTransparency = 0
end

function Library:Button(...)
    local Button = {}
    local _Name, _Function, _Tab = argEval({"name", "function", "tab"}, {...})
    local Element = Library:Element(_Name, true, _Tab)

    Element.Element.MouseButton1Click:Connect(function()
        Library:Tween(
            Element.Element, 
            TweenInfo.new(0.15, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, true), 
            {BackgroundTransparency = 0.85}
        )
        Button:Click()
    end)

    function Button:Click() 
        _Function()
    end

    Button.Element = Element
    Button.Type = "Button"
    Library.CreatedElements[#Library.CreatedElements+1] = Button

    return Button
end

function Library:Toggle(...) 
    local Toggle = {Enabled = false}
    local _Name, _Function, _Default, _Tab, _Texts = argEval({"name", "function", "default", "tab", "texts"}, {...})
    local Element = Library:Element(_Name, true, _Tab)
    local _Texts = _Texts or {Enabled = "Enabled", Disabled = "Disabled"}

    Toggle.Element = Element

    local StatusText = Instance.new("TextLabel")
    StatusText.Parent = Element.Container
    StatusText.AnchorPoint = Vector2.new(0, 0.5)
    StatusText.Position = UDim2.new(0.95, 0, 0.5, 0)
    StatusText.Text = _Texts.Disabled
    StatusText.TextColor3 = Library.Colors.LRED
    StatusText.Font = Enum.Font.GothamMedium
    StatusText.TextSize = 14
    StatusText.TextXAlignment = Enum.TextXAlignment.Right

    Toggle.StatusText = StatusText

    function Toggle:Toggle()
        Toggle.Enabled = not Toggle.Enabled
        StatusText.TextColor3 = Toggle.Enabled and Library.Colors.LGREEN or Library.Colors.LRED
        StatusText.Text = Toggle.Enabled and _Texts.Enabled or _Texts.Disabled
        _Function(Toggle.Enabled)
    end

    if _Default then 
        Toggle:Toggle()
    end

    Element.Element.MouseButton1Click:Connect(function()
        Library:Tween(
            Element.Element, 
            TweenInfo.new(0.15, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, true), 
            {BackgroundTransparency = 0.85}
        )
        Toggle:Toggle()
    end)

    Toggle.Element = Element
    Toggle.Type = "Toggle"
    Library.CreatedElements[#Library.CreatedElements+1] = Toggle

    return Toggle
end

function Library:Textbox(...) 
    local Textbox = {Value = ""}
    local _Name, _Function, _Default, _Tab = argEval({"name", "function", "default", "tab"}, {...})
    local Element = Library:Element(_Name, false, _Tab)

    Textbox.Element = Element

    local Box = Instance.new("TextBox")
    Box.ClearTextOnFocus = false
    Box.Parent = Element.Container
    Box.AnchorPoint = Vector2.new(1, 0.5)
    Box.Position = UDim2.new(0, 180, 0.5, 0)
    Box.Size = UDim2.new(0, 20, 0, 25)
    Box.Font = Enum.Font.GothamMedium
    Box.Text = ""
    Box.PlaceholderText = "Input"
    Box.TextSize = 14
    Box.BackgroundTransparency = 1
    Box.TextColor3 = Color3.new(1, 1, 1)
    Box.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Box.Visible = true
    Box.TextTruncate = Enum.TextTruncate.AtEnd

    local UICorner = Instance.new("UICorner")
    UICorner.Parent = Box

    local function GetBoxTextSize() 
        return TXTSRV:GetTextSize(Box.Text == "" and Box.PlaceholderText or Box.Text, Box.TextSize, Box.Font, Vector2.new(9e9, 9e9))
    end

    function Textbox:Update(Text) 
        Box.Text = Text
        Textbox.Value = Text
        
        local Vec = GetBoxTextSize()
        Box.Size = UDim2.new(0, math.clamp(Vec.X + 5, 0, 275), 0, 25)
    end

    local Hovering = false
    Box:GetPropertyChangedSignal("Text"):Connect(function()
        if Box:IsFocused() then
            local Vec = GetBoxTextSize()
            Library:Tween(
                Box,
                TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), 
                {Size = UDim2.new(0, math.clamp(Vec.X + 10, 155, 275), 0, 25)}
            )
        end
        _Function(Box.Text)
    end)

    Box.Focused:Connect(function()
        Library:Tween(
            Box, 
            TweenInfo.new(0.15, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), 
            {BackgroundTransparency = 0.85}
        )
    end)

    Box.FocusLost:Connect(function()
        if Hovering then
            return
        end

        Library:Tween(
            Box, 
            TweenInfo.new(0.15, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out), 
            {BackgroundTransparency = 1}
        )

        local Vec = GetBoxTextSize()
        Library:Tween(
            Box,
            TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), 
            {Size = UDim2.new(0, math.clamp(Vec.X + 5, 0, 275), 0, 25)}
        )
    end)

    Box.MouseEnter:Connect(function()
        Hovering = true
        if Box:IsFocused() then 
            return
        end

        Library:Tween(
            Box,
            TweenInfo.new(0.1, Enum.EasingStyle.Linear, Enum.EasingDirection.Out), 
            {BackgroundTransparency = 0.95}
        )

        local Vec = GetBoxTextSize()
        Library:Tween(
            Box,
            TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), 
            {Size = UDim2.new(0, math.clamp(Vec.X + 10, 155, 275), 0, 25)}
        )
    end)

    Box.MouseLeave:Connect(function()
        Hovering = false
        if Box:IsFocused() then 
            return
        end

        Library:Tween(
            Box, 
            TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), 
            {BackgroundTransparency = 1}
        )

        local Vec = GetBoxTextSize()
        Library:Tween(
            Box,
            TweenInfo.new(0.25, Enum.EasingStyle.Quad, Enum.EasingDirection.Out), 
            {Size = UDim2.new(0, math.clamp(Vec.X + 5, 0, 275), 0, 25)}
        )
    end)

    Textbox:Update(_Default or "")

    Textbox.Element = Element
    Textbox.Type = "Textbox"
    Library.CreatedElements[#Library.CreatedElements+1] = Textbox

    return Textbox
end

function Library:Slider(...) 
    local Slider = {}
    local _Name, _Function, _Min, _Max, _Decimals, _Default, _Tab = argEval({"name", "function", "min", "max", "decimals", "default", "tab"}, {...})
    local Element = Library:Element(_Name, true, _Tab)

    local Text = Instance.new("TextLabel")
    Text.Parent = Element.Container
    Text.AnchorPoint = Vector2.new(0, 0.5)
    Text.Position = UDim2.new(0.95, 0, 0.5, 0)
    Text.Text = tostring(_Default)
    Text.TextColor3 = Color3.new(1, 1, 1)
    Text.Font = Enum.Font.GothamMedium
    Text.TextSize = 14
    Text.TextXAlignment = Enum.TextXAlignment.Right

    Slider.Text = Text

    local Slide = Instance.new("TextButton")
    Slide.Name = "Slide"
    Slide.AutoButtonColor = false
    Slide.Text = "" 
    Slide.Parent = Element.Element
    Slide.BackgroundColor3 = Color3.fromRGB(255, 255, 255)
    Slide.BackgroundTransparency = 1
    Slide.BorderSizePixel = 0
    Slide.Position = UDim2.new(0, 0, 0, 0)
    Slide.Size = UDim2.new(0.05, 0, 0, 35)

    local UICorner = Instance.new("UICorner")
    UICorner.Parent = Slide

    function Slider:Set(Value, Tween) 
        local value = math.round((math.clamp(Value, _Min, _Max) * (10 ^ _Decimals))) / (10 ^ _Decimals)
        local sizeValue = math.round((math.clamp(value, _Min, _Max) * (10^ _Decimals))) / (10 ^ _Decimals)
        
        local Size =  UDim2.new((sizeValue - _Min) / (_Max - _Min), 0, 1, 0)
        if not Tween then
            Slide.Size = Size
        else
            Library:Tween(
                Slide, 
                TweenInfo.new(0.25, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), 
                {Size = Size}
            )
        end
        Slider.Value = Value
        Text.Text = tostring(value)
        _Function(value)
    end

    local Hovering = false
    local Sliding = false
    Element.Element.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then 
            Sliding = true
            local SizeX = math.clamp((Input.Position.X - Element.Element.AbsolutePosition.X) / Element.Element.AbsoluteSize.X, 0, 1)
            local value = math.round(((( (_Max - _Min) * SizeX ) + _Min) * (10 ^ _Decimals))) / (10 ^ _Decimals)
            Slider:Set(value, true)
        end
    end)

    Element.Element.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then 
            Sliding = false
            if not Hovering then 
                Library:Tween(
                    Slide, 
                    TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), 
                    {BackgroundTransparency = 1}
                )
            end
        end
    end)

    Slide.InputBegan:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then 
            Sliding = true
            local SizeX = math.clamp((Input.Position.X - Element.Element.AbsolutePosition.X) / Element.Element.AbsoluteSize.X, 0, 1)
            local value = math.round(((( (_Max - _Min) * SizeX ) + _Min) * (10 ^ _Decimals))) / (10 ^ _Decimals)
            Slider:Set(value, true)
        end
    end)

    Slide.InputEnded:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseButton1 then 
            Sliding = false
            if not Hovering then 
                Library:Tween(
                    Slide, 
                    TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), 
                    {BackgroundTransparency = 1}
                )
            end
        end
    end)

    UIS.InputChanged:Connect(function(Input)
        if Input.UserInputType == Enum.UserInputType.MouseMovement then 
            if not Sliding then 
                return
            end

            local SizeX = math.clamp((Input.Position.X - Element.Element.AbsolutePosition.X) / Element.Element.AbsoluteSize.X, 0, 1)
            local value = math.round(((( (_Max - _Min) * SizeX ) + _Min) * (10 ^ _Decimals))) / (10 ^ _Decimals)
            Slider:Set(value)
        end
    end)

    Element.Element.MouseEnter:Connect(function(x, y)
        Hovering = true
        Library:Tween(
            Slide, 
            TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), 
            {BackgroundTransparency = 0.925}
        )
    end)

    Element.Element.MouseLeave:Connect(function(x, y)
        Hovering = false
        if Sliding then 
            return
        end

        Library:Tween(
            Slide, 
            TweenInfo.new(0.2, Enum.EasingStyle.Sine, Enum.EasingDirection.Out), 
            {BackgroundTransparency = 1}
        )
    end)

    Slider:Set(_Default)

    Slider.Element = Element
    Slider.Type = "Slider"
    Library.CreatedElements[#Library.CreatedElements+1] = Slider

    return Slider
end

function Library:Selector(...) 
    local Selector = {}
    local _Name, _Function, _List, _Default, _Tab = argEval({"name", "function", "list", "default", "tab"}, {...})
    local Element = Library:Element(_Name, true, _Tab)

    local Text = Instance.new("TextLabel")
    Text.Parent = Element.Container
    Text.AnchorPoint = Vector2.new(0, 0.5)
    Text.Position = UDim2.new(0.95, 0, 0.5, 0)
    Text.Text = tostring(_Default)
    Text.TextColor3 = Color3.new(1, 1, 1)
    Text.Font = Enum.Font.GothamMedium
    Text.TextSize = 14
    Text.TextXAlignment = Enum.TextXAlignment.Right

    function Selector:Selectable(Value)
        local Selectable = {}

        Selectable.Value = Value

        function Selectable:End() 
            -- Placeholder incase anything needs to end when new list is set.
        end

        function Selectable:Select()
            Text.Text = tostring(Selectable.Value)
            Selector.Selected = Selectable
            _Function(Selectable.Value)
        end

        Selector.Selectables[#Selector.Selectables+1] = Selectable
        return Selectable
    end

    function Selector:Select(Value) 
        for i,v in next, Selector.Selectables do 
            if v.Value == Value then 
                v:Select()
            end
        end
    end

    function Selector:SetList(List) 
        for i,v in next, (Selector.Selectables or {}) do 
            v:End()
        end
        Selector.Selectables = {}
        Selector.List = List
        for i,v in next, Selector.List do 
            Selector:Selectable(v)
        end
    end

    function Selector:GetIndexFromValue(Value) 
        for i,v in next, Selector.Selectables do 
            if v.Value == Value then
                return i
            end
        end
    end

    -- Convert number into valid index
    function Selector:Wrap(Index, Add) 
        local NumOf = #Selector.Selectables
        local TrueIndex = Index + Add

        if TrueIndex < 1 then 
            TrueIndex = NumOf
        end
        if TrueIndex > NumOf then 
            TrueIndex = 1
        end
        
        return TrueIndex
    end

    function Selector:SelectNext() 
        local CurrentIndex = Selector:GetIndexFromValue(Selector.Selected.Value)
        local NextIndex = Selector:Wrap(CurrentIndex, 1)
        Selector.Selectables[NextIndex]:Select()
    end

    function Selector:SelectPrevious() 
        local CurrentIndex = Selector:GetIndexFromValue(Selector.Selected.Value)
        local PreviousIndex = Selector:Wrap(CurrentIndex, -1)
        Selector.Selectables[PreviousIndex]:Select()
    end

    Element.Element.MouseButton1Click:Connect(function()
        Library:Tween(
            Element.Element, 
            TweenInfo.new(0.15, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, true), 
            {BackgroundTransparency = 0.85}
        )
        Selector:SelectNext()
    end)

    Element.Element.MouseButton2Click:Connect(function()
        Library:Tween(
            Element.Element, 
            TweenInfo.new(0.15, Enum.EasingStyle.Cubic, Enum.EasingDirection.Out, 0, true), 
            {BackgroundTransparency = 0.85}
        )
        Selector:SelectPrevious()
    end)

    Selector:SetList(_List)
    Selector:Select(_Default)

    Selector.Element = Element
    Selector.Type = "Selector"
    Library.CreatedElements[#Library.CreatedElements+1] = Selector

    return Selector
end

function Library:Bind(...) 
    local Bind = {}
    local _Name, _Function, _Default, _Tab = argEval({"name", "function", "default", "tab"}, {...})
    local Element = Library:Element(_Name, true, _Tab)

    local Text = Instance.new("TextLabel")
    Text.Parent = Element.Container
    Text.AnchorPoint = Vector2.new(0, 0.5)
    Text.Position = UDim2.new(0.95, 0, 0.5, 0)
    Text.Text = "Unbound"
    Text.TextColor3 = Color3.new(1, 1, 1)
    Text.Font = Enum.Font.GothamMedium
    Text.TextSize = 14
    Text.TextXAlignment = Enum.TextXAlignment.Right

    function Bind:Set(BindTo) 
        print(BindTo)
        Text.Text = BindTo.Name
        Bind.Bind = BindTo
    end

    function Bind:Press() 
        _Function()
    end

    function Bind:StartRecording()
        Text.Text = "Press a key..."
        Library.Recording = Bind
    end

    function Bind:StopRecording()
        if Bind.Bind then
            Text.Text = Bind.Bind.Name
        else
            Text.Text = "Unbound"
        end
        Library.Recording = nil
    end

    Element.Element.MouseButton1Click:Connect(function()
        if not Library.Recording then 
            Bind:StartRecording()
        elseif Library.Recording == Bind then
            Bind:StopRecording()
        end
    end)

    if _Default then
        Bind:Set(_Default)
    end

    Bind.Type = "Bind"
    Bind.Element = Element
    Library.CreatedElements[#Library.CreatedElements+1] = Bind

    return Bind
end

getgenv()._Library = Library -- Declare _Library env variable

return Library
