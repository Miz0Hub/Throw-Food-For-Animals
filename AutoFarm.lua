local function createMiz0(...)
local options = ...
if type(options) ~= "table" then options = {} end
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local UserInputService = game:GetService("UserInputService")
local player = Players.LocalPlayer
local env = getgenv()
local previous = env.Miz0GuiTemplate
if previous and previous.cleanup then pcall(previous.cleanup) end
local A: any = {alive=true, demoState={enabled=false,mode="Normal",speed=50,label="Miz0"}}
env.Miz0GuiTemplate = A
local window, uiStyleConnection
function A.cleanup()
    if not A.alive then return end
    A.alive = false
    if uiStyleConnection then uiStyleConnection:Disconnect(); uiStyleConnection=nil end
    if window and not window.unloaded then window:Unload() end
    if env.Miz0GuiTemplate==A then env.Miz0GuiTemplate=nil end
end
local compactUI, palette, uiRoot, initialViewport
do
local WindUI = assert(loadstring(game:HttpGet("https://github.com/Footagesus/WindUI/releases/latest/download/main.lua")))()
if not A.alive then return end
WindUI:SetParent(player:WaitForChild("PlayerGui"))
initialViewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
local function menuLayout(viewport, touch, keyboard)
    viewport = viewport or (workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize) or initialViewport
    if touch == nil then touch = UserInputService.TouchEnabled end
    if keyboard == nil then keyboard = UserInputService.KeyboardEnabled end
    local compact = viewport.X < 720 or viewport.Y < 480 or (touch and not keyboard)
    local width = math.max(1, math.min(650, viewport.X - 24))
    local height = math.max(1, math.min(540, viewport.Y - 72))
    return {compact = compact, width = width, height = height,
        sidebar = math.floor(math.min(compact and 122 or 178, width * 0.36))}
end
local initialLayout = menuLayout(initialViewport, UserInputService.TouchEnabled, UserInputService.KeyboardEnabled)
compactUI = initialLayout.compact
local menuWidth, menuHeight = initialLayout.width, initialLayout.height
A.getUILayout = menuLayout
palette = {amber = Color3.fromHex("397CA8"), blue = Color3.fromHex("59B5EE"),
    green = Color3.fromHex("308C80"), red = Color3.fromHex("CA687A")}
local theme = table.clone(WindUI:GetThemes().Light)
theme.Name = "Miz0 Light Blue"
for key, hex in pairs({Accent="D8EEFF",Background="DCEFFF",Dialog="EAF6FF",Outline="91BFE0",
    Text="163850",Placeholder="53728B",Button="397CA8",Icon="36759F",Toggle="59B5EE",
    Slider="59B5EE",Checkbox="59B5EE",PanelBackground="CEE8FA",ElementBackground="F0F9FF",
    TabBackground="E4F3FD",TabBackgroundActive="A6D7F6",TabBackgroundHover="C6E7FC",
    DropdownBackground="EBF7FF",DropdownTabBackground="C0E1F8",LabelBackground="C8E7FC"}) do
    theme[key] = Color3.fromHex(hex)
end
theme.PanelBackgroundTransparency = 0.48
theme.ElementBackgroundTransparency = 0.22
WindUI:AddTheme(theme)
local imageAsset = ""
local imageOK, imageError = pcall(function()
    if not isfolder("Miz0Gui") then makefolder("Miz0Gui") end
    local encoded = "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"
    local alphabet = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local lookup = {}
    for index=1,#alphabet do lookup[alphabet:sub(index,index)] = index-1 end
    local bytes, value, bits = {}, 0, 0
    for index=1,#encoded do
        local n = lookup[encoded:sub(index,index)]
        if n then
            value = value*64+n; bits += 6
            if bits >= 8 then
                bits -= 8
                table.insert(bytes,string.char(math.floor(value / 2^bits) % 256))
                value %= 2^bits
            end
        end
        if index % 4096 == 0 then task.wait() end
    end
    writefile("Miz0Gui/portrait.jpg",table.concat(bytes))
    imageAsset = getcustomasset("Miz0Gui/portrait.jpg")
end)
if not imageOK then A.backgroundError = tostring(imageError) end
A.portraitAsset = imageAsset
local beforeMenuMouseBehavior = UserInputService.MouseBehavior
local beforeMenuMouseIcon = UserInputService.MouseIconEnabled
local windWindow = WindUI:CreateWindow({
    Title = options.Title or "Miz0 Hub", Author = options.Subtitle or "Your hub  /  Blue Hour", Icon = imageAsset ~= "" and imageAsset or "egg",
    Folder = "Miz0Gui", Theme = theme.Name, Size = UDim2.fromOffset(menuWidth,menuHeight),
    MinSize = Vector2.new(math.min(280,menuWidth),math.min(260,menuHeight)), MaxSize = Vector2.new(850,800),
    SideBarWidth = initialLayout.sidebar, AutoScale = true, Radius = 18, ElementsRadius = 12,
    NewElements = true, Transparent = true, Acrylic = false,
    Resizable = not (UserInputService.TouchEnabled and not UserInputService.KeyboardEnabled),
    HideSearchBar = true, ScrollBarEnabled = true, IgnoreAlerts = true,
    Background = WindUI:Gradient({["0"]={Color=Color3.fromHex("E2F5FF"),Transparency=0.1},
        ["100"]={Color=Color3.fromHex("ACD7F4"),Transparency=0.08}},{Rotation=32}),
    BackgroundImageTransparency = 0.15, User = {Enabled=not compactUI,Anonymous=false},
    OpenButton = {Title="Miz0 Hub",Icon="egg",Enabled=false,OnlyMobile=false,Draggable=true},
})
windWindow:SetToggleKey(Enum.KeyCode.RightShift)
windWindow:SetBackgroundTransparency(0.12)
WindUI:ToggleAcrylic(false)
if imageAsset ~= "" then windWindow:SetBackgroundImage(imageAsset); windWindow:SetBackgroundImageTransparency(0.15) end
if not compactUI then windWindow:Tag({Title="BLUE HOUR",Color=Color3.fromHex("4B9DCE")}) end
local windMain = windWindow.UIElements and windWindow.UIElements.Main
uiRoot = assert((windMain and windMain:FindFirstAncestorOfClass("ScreenGui")) or player.PlayerGui:FindFirstChild("WindUI"),"WindUI root did not load")
uiRoot.DisplayOrder = 10000
uiRoot.ResetOnSpawn = false
for index, name in ipairs({"DropdownGui", "TooltipGui", "NotificationGui"}) do
    local overlay = WindUI[name]
    if overlay and overlay:IsA("ScreenGui") then
        overlay.DisplayOrder = uiRoot.DisplayOrder + index * 10
        overlay.ResetOnSpawn = false
    end
end
local uiConnections = {}
local function uiConnect(signal, callback)
    local connection = signal:Connect(callback)
    table.insert(uiConnections, connection)
    return connection
end
local Lighting = game:GetService("Lighting")
local softBlur = Instance.new("BlurEffect")
softBlur.Name = "Miz0GuiSoftBlur"
softBlur.Size = 6
softBlur.Parent = Lighting
local blurEnabled, cursorCaptured, firstMouseCapture = true, false, true
local savedMouseBehavior, savedMouseIcon
local launcher
local cursorBinding = "Miz0GuiCursor"
local function releaseMenuMouse()
    if not cursorCaptured then return end
    cursorCaptured = false
    if savedMouseBehavior then UserInputService.MouseBehavior = savedMouseBehavior end
    if savedMouseIcon ~= nil then UserInputService.MouseIconEnabled = savedMouseIcon end
end
local uiCleaned = false
local function cleanupWindUI()
    if uiCleaned then return end
    uiCleaned = true
    RunService:UnbindFromRenderStep(cursorBinding)
    releaseMenuMouse()
    for _, connection in ipairs(uiConnections) do connection:Disconnect() end
    table.clear(uiConnections)
    if softBlur then softBlur:Destroy(); softBlur = nil end
    if launcher then launcher:Destroy(); launcher = nil end
end
window = {unloaded=false}
function window:Unload()
    if self.unloaded then return end
    self.unloaded = true
    cleanupWindUI()
    if not windWindow.Destroyed then windWindow:Destroy() end
end
function window:ToggleHide()
    if windWindow.Closed then windWindow:Open() else windWindow:Close() end
end
windWindow:OnOpen(function() if softBlur then softBlur.Enabled = blurEnabled end end)
windWindow:OnClose(function() if softBlur then softBlur.Enabled = false end; releaseMenuMouse() end)
windWindow:OnDestroy(function()
    window.unloaded = true
    cleanupWindUI()
    if A.alive then A.cleanup() end
end)
local function plainRichText(value)
    return tostring(value):gsub("&","&amp;"):gsub("<","&lt;"):gsub(">","&gt;")
end
local function wrapWindTab(raw)
    local tab: any = {raw=raw,cardCount=0}
    function tab:NewSection(title, icon)
        self.cardCount += 1
        raw:Section({Title=title,Icon=icon})
        return raw
    end
    function tab:Container() return raw end
    function tab:CreateToggle(options)
        local handle: any = {value=options.value,silent=false}
        local control = raw:Toggle({Title=options.name,Desc=options.description,Value=options.value,
            Callback=function(value)
                setthreadidentity(8)
                handle.value = value
                if not handle.silent and options.callback then options.callback(value) end
            end})
        function handle:Set(value, silent)
            self.value = value
            self.silent = silent == true
            control:Set(value)
            self.silent = false
        end
        return handle
    end
    function tab:CreateButton(options)
        return raw:Button({Title=options.name,Desc=options.description,Icon=options.icon,Color=options.color,
            Callback=function() setthreadidentity(8); if options.callback then options.callback() end end})
    end
    function tab:CreateDropdown(options)
        return raw:Dropdown({Title=options.name,Desc=options.description,Values=options.options,Value=options.value,
            Multi=false,SearchBarEnabled=#options.options>12,
            Callback=function(value) setthreadidentity(8); if value~=nil and options.callback then options.callback(value) end end})
    end
    function tab:CreateSlider(options)
        return raw:Slider({Title=options.name,Desc=options.description,
            Value={Min=options.range[1],Max=options.range[2],Default=options.value},Step=options.increment or 1,
            Callback=function(value) setthreadidentity(8); if options.callback then options.callback(value) end end})
    end
    function tab:CreateInput(options)
        return raw:Input({Title=options.name,Desc=options.description,
            Value=options.value~=nil and tostring(options.value) or "",
            Placeholder=options.placeholder or options.name,
            ClearTextOnFocus=options.clearTextOnFocus==true,
            Callback=function(value)
                setthreadidentity(8)
                if options.numeric then
                    local number=tonumber(value)
                    if not number or number~=number or math.abs(number)==math.huge or number<0 then return end
                end
                if options.callback then options.callback(value) end
            end})
    end
    function tab:CreateConsole(options)
        local control = raw:Button({Title=options.name,Desc=options.text or "",Icon="list",Callback=function() end})
        local handle: any = {lines={},maxLines=options.maxLines or 8}
        function handle:Set(text)
            self.lines = string.split(tostring(text),"\n")
            while #self.lines>self.maxLines do table.remove(self.lines,1) end
            control:SetDesc(plainRichText(table.concat(self.lines,"\n")))
        end
        function handle:Append(line)
            table.insert(self.lines,tostring(line))
            while #self.lines>self.maxLines do table.remove(self.lines,1) end
            control:SetDesc(plainRichText(table.concat(self.lines,"\n")))
        end
        return handle
    end
    function tab:Heading(title) return self:NewSection(title) end
    function tab:Card(title,text,icon,color,buttons)
        local control = raw:Button({Title=title,Desc=plainRichText(text),Icon=icon,Color=color,Callback=function() end})
        local children = {}
        for _, button in ipairs(buttons or {}) do
            table.insert(children,raw:Button({Title=button.Title,Icon=button.Icon,
                Callback=function() setthreadidentity(8); if button.Callback then button.Callback() end end}))
        end
        local handle: any = {title=title,text=text,model=control}
        function handle:Set(value,titleValue)
            value = tostring(value)
            if titleValue and self.title~=titleValue then control:SetTitle(titleValue); self.title=titleValue end
            if self.text~=value then control:SetDesc(plainRichText(value)); self.text=value end
        end
        function handle:Destroy()
            for _, child in ipairs(children) do child:Destroy() end
            control:Destroy()
        end
        return handle
    end
    function tab:Row() return self end
    return tab
end
function window:CreateTab(options)
    local icons={Overview="home",Stealing="target",Movement="move",Farming="leaf",Upgrades="trending-up",
        Visuals="eye",Targets="users",Activity="list"}
    return wrapWindTab(windWindow:Tab({Title=options.name,Icon=options.icon or icons[options.name] or "circle"}))
end
local disclaimer = windWindow:Tab({Title="Disclaimer",Icon="info"})
disclaimer:Button({Title="Miz0  /  Blue Hour",Desc=options.Subtitle or "Reusable Miz0 GUI template",Icon=imageAsset~="" and imageAsset or "egg",Callback=function() end})
local creditsCard = disclaimer:Button({Title="Credit Miz0",Desc="If you share or redistribute Miz0 Hub, give credit to Miz0.",Icon="info",Callback=function() end})
A.uiLibrary = "WindUI"
A.uiPlatform = compactUI and "Compact" or "Desktop"
A.uiTheme = "Miz0 Light Blue"
A.uiLayoutVersion = 5
A.uiBackgroundURL = "Embedded user portrait"
A.uiRoot, A.uiWindow, A.window = uiRoot, windWindow, window
A.credits = "Miz0"
function A.hasCredits() return creditsCard ~= nil and A.credits == "Miz0" end
local function removeCornerTexture(object)
    object.Image = ""
    uiConnect(object:GetPropertyChangedSignal("Image"),function() if object.Image~="" then object.Image="" end end)
end
local function styleWindRow(row)
    if row:IsA("TextLabel") and row.Text=="Locked" then row.Visible=false end
    if not row:IsA("ImageButton") or row:GetAttribute("Miz0Styled") or not row:FindFirstChild("TitleFrame",true)
        or not row.Parent or not row.Parent:IsA("ScrollingFrame") then return end
    row:SetAttribute("Miz0Styled",true)
    removeCornerTexture(row)
    row.ImageTransparency=1
    row.BackgroundColor3=Color3.new(1,1,1)
    row.BackgroundTransparency=0.14
    for _, layer in ipairs(row:GetDescendants()) do
        local parent=layer.Parent
        if layer:IsA("ImageLabel") and parent and parent:IsA("Frame") and parent.Parent==row
            and parent.Size.X.Scale>=0.9 and parent.Size.Y.Scale>=0.9 and layer.Size.X.Scale>=0.9 and layer.Size.Y.Scale>=0.9 then
            removeCornerTexture(layer)
        end
        if layer:IsA("TextLabel") then layer.TextColor3=Color3.fromHex("244B67") end
    end
    for _, decoration in ipairs(row:GetChildren()) do
        if decoration:IsA("Frame") and decoration:FindFirstChildOfClass("ImageLabel")
            and decoration.Size.X.Scale==0 and decoration.Size.Y.Scale==0 and decoration.Size.X.Offset<=24
            and decoration.Size.Y.Offset<=24 and not decoration:FindFirstChildWhichIsA("GuiButton",true) then decoration.Visible=false end
    end
    local gradient=Instance.new("UIGradient")
    gradient.Name="Miz0SkyGradient"; gradient.Rotation=90
    gradient.Color=ColorSequence.new(Color3.fromHex("F3FBFF"),Color3.fromHex("CEE9FB")); gradient.Parent=row
    local corner=Instance.new("UICorner"); corner.CornerRadius=UDim.new(0,12); corner.Parent=row
    local border=Instance.new("UIStroke"); border.Name="Miz0SkyEdge"; border.Color=Color3.fromHex("8EBDE0")
    border.Thickness=0.8; border.Transparency=0.52; border.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; border.Parent=row
end
local lastViewport = initialViewport
function A.fitMenuToViewport()
    local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize
    if not viewport or viewport==lastViewport then return end
    lastViewport=viewport
    local layout=menuLayout(viewport,UserInputService.TouchEnabled,UserInputService.KeyboardEnabled)
    windWindow:SetSize(UDim2.fromOffset(layout.width,layout.height))
    windWindow:SetUIScale(math.max(0.1,math.min(1,(viewport.X-16)/layout.width,(viewport.Y-50)/layout.height)))
    if launcher then
        local position=launcher.Position
        launcher.Position=UDim2.fromOffset(
            math.clamp(position.X.Scale*viewport.X+position.X.Offset,4,math.max(4,viewport.X-120)),
            math.clamp(position.Y.Scale*viewport.Y+position.Y.Offset,25,math.max(25,viewport.Y-25)))
    end
end
function A.finalizeUI(_info,activity)
    if A.uiReady then return end
    activity:Heading("Credits")
    activity:Card("Created by Miz0","If you share or redistribute Miz0 Hub, give credit to Miz0.","badge-check",palette.amber)
    local style=windWindow:Tab({Title="Style",Icon="palette"})
    style:Toggle({Title="Soft Background Blur",Value=true,Callback=function(value)
        blurEnabled=value; if softBlur then softBlur.Enabled=value and windWindow.Closed==false end
    end})
    style:Slider({Title="Picture Visibility",Desc="Your artwork fills the menu background.",
        Value={Min=10,Max=100,Default=85},Step=5,Callback=function(value) windWindow:SetBackgroundImageTransparency(1-value/100) end})
    style:Slider({Title="Glass Transparency",Value={Min=0,Max=45,Default=12},Step=1,
        Callback=function(value) windWindow:SetBackgroundTransparency(value/100) end})
    for _, row in ipairs(uiRoot:GetDescendants()) do styleWindRow(row) end
    uiStyleConnection=uiRoot.DescendantAdded:Connect(function(row)
        task.defer(function() if A.alive and row.Parent then styleWindRow(row) end end)
    end)
    launcher=Instance.new("TextButton")
    launcher.Name="Miz0Open"; launcher.AnchorPoint=Vector2.new(0,0.5); launcher.Position=UDim2.new(0,12,0.5,0)
    launcher.Size=UDim2.fromOffset(116,42); launcher.BackgroundColor3=Color3.new(1,1,1)
    launcher.BackgroundTransparency=0.06; launcher.BorderSizePixel=0; launcher.Text="Miz0 Hub  ›"
    launcher.TextColor3=Color3.fromHex("244B67"); launcher.TextSize=14; launcher.Font=Enum.Font.GothamMedium
    launcher.AutoButtonColor=true; launcher.Visible=false; launcher.ZIndex=100; launcher.Parent=uiRoot
    local sky=Instance.new("UIGradient"); sky.Rotation=90
    sky.Color=ColorSequence.new(Color3.fromHex("F3FBFF"),Color3.fromHex("BCDEFA")); sky.Parent=launcher
    local corner=Instance.new("UICorner"); corner.CornerRadius=UDim.new(0,15); corner.Parent=launcher
    local edge=Instance.new("UIStroke"); edge.Color=Color3.fromHex("8EBDE0"); edge.Thickness=0.8
    edge.Transparency=0.3; edge.ApplyStrokeMode=Enum.ApplyStrokeMode.Border; edge.Parent=launcher
    local dragging,dragOrigin,startPosition,dragInput
    local draggedAt=-math.huge
    uiConnect(launcher.InputBegan,function(input)
        if input.UserInputType==Enum.UserInputType.MouseButton1 or input.UserInputType==Enum.UserInputType.Touch then
            dragging=true; dragOrigin=input.Position; startPosition=launcher.Position; dragInput=input
        end
    end)
    uiConnect(UserInputService.InputChanged,function(input)
        if dragging and (input.UserInputType==Enum.UserInputType.MouseMovement or input==dragInput) then
            local delta=input.Position-dragOrigin
            if delta.Magnitude>6 then
                draggedAt=os.clock()
                local view=workspace.CurrentCamera.ViewportSize
                launcher.Position=UDim2.fromOffset(math.clamp(startPosition.X.Offset+delta.X,4,math.max(4,view.X-120)),
                    math.clamp(startPosition.Y.Scale*view.Y+startPosition.Y.Offset+delta.Y,25,math.max(25,view.Y-25)))
            end
        end
    end)
    uiConnect(UserInputService.InputEnded,function(input) if input==dragInput then dragging=false; dragInput=nil end end)
    uiConnect(launcher.Activated,function() if os.clock()-draggedAt>0.25 then windWindow:Open() end end)
    RunService:UnbindFromRenderStep(cursorBinding)
    RunService:BindToRenderStep(cursorBinding,Enum.RenderPriority.Last.Value+10,function()
        if not A.alive then return end
        A.fitMenuToViewport()
        local opened=windWindow.Closed==false and not windWindow.Destroyed
        A.menuOpen=opened
        if UserInputService.MouseEnabled then
            if opened then
                if not cursorCaptured then
                    if firstMouseCapture then
                        savedMouseBehavior=beforeMenuMouseBehavior; savedMouseIcon=beforeMenuMouseIcon
                    else
                        savedMouseBehavior=UserInputService.MouseBehavior; savedMouseIcon=UserInputService.MouseIconEnabled
                    end
                    firstMouseCapture=false
                    cursorCaptured=true
                end
                UserInputService.MouseBehavior=Enum.MouseBehavior.Default; UserInputService.MouseIconEnabled=true
            else releaseMenuMouse() end
        end
        if launcher then launcher.Visible=not opened end
    end)
    A.uiReady=true
    lastViewport=Vector2.new(-1,-1)
    A.fitMenuToViewport()
    windWindow:SelectTab(1)
    windWindow:Open()
end
end

-- Public builder helpers. Add tabs and controls before calling Finish().
function A:CreateTab(tabOptions)
    assert(self.alive, "This GUI has been destroyed")
    return window:CreateTab(tabOptions)
end
function A:Toggle()
    if self.alive then window:ToggleHide() end
end
function A:Finish()
    assert(self.alive, "This GUI has been destroyed")
    if self.uiReady then return self end
    local activity=self.activityTab or self:CreateTab({name="Activity",icon="list"})
    self.activityTab=activity
    self.finalizeUI(nil,activity)
    return self
end
function A:Destroy() self.cleanup() end

-- EXAMPLE CONTROLS: replace callback bodies with your own script's actions.
if options.Examples ~= false then
    local main=A:CreateTab({name="Overview",icon="home"})
    main:Heading("Your hub")
    local stateCard=main:Card("Ready","Attach your own actions to these controls.","sparkles",palette.blue)
    main:CreateToggle({name="Enable feature",value=false,description="Example toggle.",
        callback=function(value)
            A.demoState.enabled=value
            stateCard:Set(value and "Example enabled." or "Example paused.")
        end})
    main:CreateButton({name="Example button",icon="mouse-pointer-click",description="Use this button style for your own action.",
        callback=function() stateCard:Set("Button pressed.") end})
    main:CreateDropdown({name="Choose mode",options={"Normal","Fast","Custom"},value="Normal",
        callback=function(value) A.demoState.mode=value end})
    main:CreateSlider({name="Example amount",range={0,100},value=50,increment=1,
        callback=function(value) A.demoState.speed=value end})
    main:CreateInput({name="Your label",value="Miz0",placeholder="Type here",
        callback=function(value) A.demoState.label=value end})
    local settings=A:CreateTab({name="Settings",icon="settings"})
    settings:Card("Make it yours","Add tabs, toggles, buttons, dropdowns, sliders, inputs and cards using the helpers above.","palette")
    settings:CreateButton({name="Hide menu",icon="panel-left-close",callback=function() A:Toggle() end})
    settings:CreateButton({name="Unload GUI",icon="x",color=palette.red,callback=function() A:Destroy() end})
    A:Finish()
end
return A


end

-- Throw Food For Animals | Perfect Throw Auto Farm
-- F6: pause/resume. F7: stop and unload.
-- Trains, catches animals with perfect accuracy, equips best, and buys upgrades.
-- Skips the throw animation and teleports directly to the food's landing point.
-- Enabled upgrades use earned cash. The filter sells only weak pets from new throws.
-- Egg controls use already-owned eggs; egg rewards are always kept.
local lifecycle: any = nil -- Real live-reload supplies this when launching.

local SETTINGS = {
    TrainingSeconds = 5,
    ThrowsPerCycle = 20,
    PerfectAccuracy = 1,
    AutoTrain = true,
    AutoUpgradeTraining = true,
    AutoUpgradeFood = true,
    FastMode = true,
    KeepRule = "Better Income",
    MinimumIncome = 0,
    AutoUpgradeFence = false,
    AutoClaimFree = true,
    AutoClaimOffline = true,
    AutoUseSuper = false,
    AutoResume = true,
    ShowSideTracker = true,
    StartPaused = false,
    ProtectedSpecies = "",
    ProtectedMutations = "Rainbow",
    ProtectedRarities = "",
    AutoHatchEggs = false,
    EggType = "Any Owned",
    OfferTrainingAfterSkips = true,
    TrainingOnly = false,
    ToggleKey = Enum.KeyCode.F6,
    StopKey = Enum.KeyCode.F7,
}

local SETTINGS_FILE = "Miz0Gui/throw-food-settings.json"
local RESUME_FILE = "Miz0Gui/throw-food-resume.json"
local RESUME_SCRIPT = "Miz0Gui/ThrowFoodAutoFarm.luau"
local DEFAULT_SETTINGS = table.clone(SETTINGS)
pcall(function()
    if not isfile(SETTINGS_FILE) then return end
    local saved = json.decode(readfile(SETTINGS_FILE))
    if type(saved) ~= "table" then return end
    for key, default in pairs(DEFAULT_SETTINGS) do
        local candidate = saved[key]
        if (type(default) == "boolean" or type(default) == "string" or type(default) == "number")
            and type(candidate) == type(default) then
            if type(candidate) ~= "number" or (candidate == candidate and math.abs(candidate) < math.huge) then
                (SETTINGS :: any)[key] = candidate
            end
        end
    end
end)
SETTINGS.TrainingSeconds = math.clamp(SETTINGS.TrainingSeconds, 5, 120)
SETTINGS.ThrowsPerCycle = math.floor(math.clamp(SETTINGS.ThrowsPerCycle, 1, 100))
SETTINGS.MinimumIncome = math.max(0, SETTINGS.MinimumIncome)
if SETTINGS.TrainingOnly then SETTINGS.AutoTrain = true end
if not table.find({"Better Income", "Better Income or New", "All Pets"}, SETTINGS.KeepRule) then
    SETTINGS.KeepRule = "Better Income"
end
local function persistSettings()
    local saved = {}
    for key, value in pairs(SETTINGS) do
        if type(value) == "boolean" or type(value) == "string" or type(value) == "number" then saved[key] = value end
    end
    local ok, err = pcall(writefile, SETTINGS_FILE, json.encode(saved))
    if not ok then warn("[Food Farm] Settings could not be saved: " .. tostring(err)) end
end
local saveRevision = 0
local function setSetting(key: string, value: any)
    (SETTINGS :: any)[key] = value
    saveRevision += 1
    local revision = saveRevision
    task.delay(0.2, function()
        if revision == saveRevision then persistSettings() end
    end)
end

local Players = game:GetService("Players")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UserInputService = game:GetService("UserInputService")
local CollectionService = game:GetService("CollectionService")
local player = Players.LocalPlayer
assert(game.PlaceId == 120219252362013, "Join Throw Food For Animals first.")

local oldControl = player.PlayerScripts:FindFirstChild("CodexFoodFarmControl")
if oldControl and oldControl:IsA("BindableEvent") then
    oldControl:Fire("stop")
    local deadline = os.clock() + 12
    while oldControl.Parent and os.clock() < deadline do
        task.wait(0.1)
    end
    assert(not oldControl.Parent, "Previous farm is still stopping; try again shortly.")
end

local controllers = player.PlayerScripts:WaitForChild("Client"):WaitForChild("Controllers")
local function module(folder: Instance, name: string): any
    local source: any = folder:WaitForChild(name, 10)
    assert(source, "Missing game module: " .. name)
    return require(source)
end
local clientState = module(controllers, "ClientState")
local config = ReplicatedStorage:WaitForChild("Config")
local foods = module(config, "FoodsConfig")
local stands = module(config, "StandsConfig")
local gameConfig = module(config, "GameConfig")
local fences = module(config, "FenceConfig")
local eggsConfig = module(config, "EggsConfig")
if SETTINGS.EggType ~= "Any Owned" and not eggsConfig.Get(SETTINGS.EggType) then SETTINGS.EggType = "Any Owned" end
local offlineEarnings = module(controllers, "OfflineEarnings")
local mutations = module(ReplicatedStorage:WaitForChild("Shared"), "Mutations")
local remotes = ReplicatedStorage:WaitForChild("Remotes")
local control = Instance.new("BindableEvent")
control.Name = "CodexFoodFarmControl"
control.Parent = player.PlayerScripts
control:SetAttribute("Enabled", not SETTINGS.StartPaused)
control:SetAttribute("Status", "Starting")
control:SetAttribute("Catches", 0)
control:SetAttribute("PerfectThrows", 0)
control:SetAttribute("Cycles", 0)
control:SetAttribute("TrainingUpgrades", 0)
control:SetAttribute("Previews", 0)
control:SetAttribute("Skipped", 0)
control:SetAttribute("FenceUpgrades", 0)
control:SetAttribute("SuperThrowsUsed", 0)
control:SetAttribute("RewardsClaimed", 0)
control:SetAttribute("EggsStarted", 0)
control:SetAttribute("EggsHatched", 0)
control:SetAttribute("EggNote", "Waiting for an owned egg")
control:SetAttribute("SkippedInRow", 0)
control:SetAttribute("TrainingOnly", SETTINGS.TrainingOnly)
control:SetAttribute("TrainingPromptVisible", false)

local running = true
local enabled = not SETTINGS.StartPaused
local trainingOnly = SETTINGS.TrainingOnly
local skippedInRow = 0
local awaitingTrainingChoice = false
local ownsTraining = false
local ownsThrow = false
local token = "CodexPerfectFoodFarm"
local connections: {RBXScriptConnection} = {}
local savedPosition: CFrame? = nil
local savedCharacter: Model? = nil
local needsRestore = false
local failures = 0
local ui: any = nil
local farmToggle: any = nil
local trainingOnlyToggle: any = nil
local autoTrainToggle: any = nil
local requestTrainingPrompt: (() -> ())? = nil
local dismissTrainingPrompt: (() -> ())? = nil
local answerTrainingPrompt: ((boolean) -> ())? = nil
local sideTracker: any = nil
local nextThrowAt = 0
local lastMoveTarget: Vector3? = nil
local rollHistory: {string} = {}
local shortHistory: {string} = {}
local lastRewardCheck = -math.huge
local queuedResume = false
local oneEggRequested = false
local nextEggAttemptAt = 0
local eggPlacementIndex = 0
local watchedEggs: {[Instance]: boolean} = {}
setmetatable(watchedEggs, {__mode="k"})
local logSequence = 0
local function resumePermission(allow: boolean)
    pcall(writefile, RESUME_FILE, json.encode({allowed = allow}))
end
local function matchesList(list: string, value: any): boolean
    if value == nil then return false end
    local wanted = string.lower(tostring(value)):gsub("%s+", "")
    for entry in list:gmatch("[^,]+") do
        if string.lower(entry):gsub("%s+", "") == wanted then return true end
    end
    return false
end

local function recordRoll(result: any, outcome: string, reason: string)
    logSequence += 1
    control:SetAttribute("LastPetStatus", outcome)
    table.insert(rollHistory, 1, string.format("#%s  %s  |  %s  |  %s/s  |  %s",
        tostring(logSequence), outcome,
        tostring(result.DisplayName or result.ModelName), tostring(result.Income or 0), reason))
    while #rollHistory > 12 do table.remove(rollHistory) end
    table.insert(shortHistory, 1, outcome .. "  ·  " .. tostring(result.DisplayName or result.ModelName))
    while #shortHistory > 3 do table.remove(shortHistory) end
    if outcome == "SKIPPED" then skippedInRow += 1 else skippedInRow = 0 end
    control:SetAttribute("SkippedInRow", skippedInRow)
    if skippedInRow >= 3 and SETTINGS.OfferTrainingAfterSkips and enabled and not trainingOnly and requestTrainingPrompt then
        requestTrainingPrompt()
    end
end

local function syncModeControls()
    control:SetAttribute("TrainingOnly", trainingOnly)
    control:SetAttribute("Mode", not enabled and "Paused" or trainingOnly and "Training Only" or "Farming")
    local farming = enabled and not trainingOnly
    local training = enabled and trainingOnly
    if farmToggle and farmToggle.value ~= farming then farmToggle:Set(farming, true) end
    if trainingOnlyToggle and trainingOnlyToggle.value ~= training then trainingOnlyToggle:Set(training, true) end
    if autoTrainToggle and autoTrainToggle.value ~= SETTINGS.AutoTrain then autoTrainToggle:Set(SETTINGS.AutoTrain, true) end
end

local function status(message: string)
    control:SetAttribute("Status", message)
end

local function data(): Instance?
    local folder = ReplicatedStorage:FindFirstChild("PlayerData")
    return folder and folder:FindFirstChild(tostring(player.UserId))
end

local function value(folder: Instance?, name: string, fallback: any): any
    local item = folder and folder:FindFirstChild(name)
    if item and item:IsA("ValueBase") then
        return (item :: any).Value
    end
    return fallback
end

local function invoke(name: string, ...: any): any
    local remote = remotes:FindFirstChild(name)
    if not remote or not remote:IsA("RemoteFunction") then
        return {Ok = false, Reason = "Missing remote: " .. name}
    end
    local ok, reply = pcall(remote.InvokeServer, remote, ...)
    if not ok then
        return {Ok = false, Reason = tostring(reply)}
    end
    if type(reply) ~= "table" then
        return {Ok = false, Reason = "Invalid response"}
    end
    return reply
end

local function active(): boolean
    return running and enabled and control.Parent ~= nil
end

local function waitActive(seconds: number): boolean
    local deadline = os.clock() + seconds
    repeat
        if not active() then
            return false
        end
        task.wait(math.min(0.1, math.max(0.01, deadline - os.clock())))
    until os.clock() >= deadline
    return active()
end

local function character(): Model?
    local char = player.Character
    local hum = char and char:FindFirstChildOfClass("Humanoid")
    local root = char and char:FindFirstChild("HumanoidRootPart")
    if char and hum and hum.Health > 0 and root and root:IsA("BasePart") then
        return char
    end
    return nil
end

local function moveTo(position: Vector3, force: boolean?): boolean
    local char = character()
    if not char or not active() then
        return false
    end
    local root = char:FindFirstChild("HumanoidRootPart") :: BasePart
    root.Anchored = false
    lastMoveTarget = position
    if not force and (char:GetPivot().Position - position).Magnitude < 2 then
        return active()
    end
    root.AssemblyLinearVelocity = Vector3.zero
    char:PivotTo(CFrame.lookAt(position, position + Vector3.new(0, 0, -1)))
    root.CFrame = CFrame.lookAt(position, position + Vector3.new(0, 0, -1))
    local deadline = os.clock() + (SETTINGS.FastMode and 0.8 or 1.5)
    repeat
        if not waitActive(0.05) then return false end
        if character() == char and (char:GetPivot().Position - position).Magnitude < 8 then
            return true
        end
    until os.clock() >= deadline
    return false
end

local function inventorySnapshot(): ({[string]: boolean}, number)
    local known: {[string]: boolean} = {}
    local incomes: {number} = {}
    local d = data()
    local animals = d and d:FindFirstChild("Animals")
    if animals then
        for _, animal in ipairs(animals:GetChildren()) do
            known[animal.Name] = true
            local info = {
                ModelName = value(animal, "ModelName", ""),
                Mutation = value(animal, "Mutation", nil),
                Size = value(animal, "Size", 1),
                OfBest = value(animal, "OfBest", nil),
            }
            table.insert(incomes, mutations.IncomeOf(info, player:GetAttribute("BestIncome") or 0))
        end
    end
    table.sort(incomes, function(a, b) return a > b end)
    local fenceLevel = value(d, "FenceLevel", 0)
    local fence = fences.Upgrades[fenceLevel]
    local slots = fence and fence.Slots or fences.BaseSlots or gameConfig.Plot.MaxPlacedAnimals or 10
    control:SetAttribute("PetSlots", slots)
    return known, #incomes >= slots and incomes[slots] or 0
end

local function shouldKeep(result: any, cutoff: number): (boolean, string)
    local income = tonumber(result.Income) or mutations.Income(result.ModelName, result.Mutation, result.Size)
    control:SetAttribute("PreviewIncome", income)
    control:SetAttribute("KeepThreshold", cutoff)
    if matchesList(SETTINGS.ProtectedSpecies, result.ModelName) or matchesList(SETTINGS.ProtectedSpecies, result.DisplayName) then
        return true, "Protected pet"
    end
    if matchesList(SETTINGS.ProtectedMutations, result.Mutation) then return true, "Protected mutation" end
    if matchesList(SETTINGS.ProtectedRarities, result.Rarity) then return true, "Protected rarity" end
    if SETTINGS.KeepRule == "All Pets" then
        return true, "Keep all"
    end
    if income < SETTINGS.MinimumIncome then
        return false, "Below minimum income"
    end
    if SETTINGS.KeepRule == "Better Income or New" and result.IsNew then
        return true, "New pet"
    end
    if income > cutoff then
        return true, "Income upgrade"
    end
    return false, "Does not improve your best lineup"
end

local function discardNewPet(id: any, known: {[string]: boolean}): boolean
    if type(id) ~= "string" or id == "" or known[id] then
        error("Refusing to sell a pet that was already owned before this throw")
    end
    local d = data()
    local animals = d and d:FindFirstChild("Animals")
    local animal = animals and animals:FindFirstChild(id)
    if animal and (value(animal, "Bought", false) or value(animal, "Placed", false)) then
        control:SetAttribute("FilterNote", "Kept a protected or placed pet")
        return false
    end
    local reply = invoke("Plot_SellAnimal", id)
    if not reply.Ok then
        control:SetAttribute("FilterNote", "Discard failed: " .. tostring(reply.Reason))
        return false
    end
    control:SetAttribute("FilterNote", nil)
    return true
end

local function invokeAtStation(name: string, ...: any): any
    local args = table.pack(...)
    local reply: any = {Ok = false, Reason = "Paused"}
    for attempt = 1, 4 do
        if not active() then return reply end
        reply = invoke(name, table.unpack(args, 1, args.n))
        if reply.Ok or reply.Reason ~= "TooFar" then return reply end
        if lastMoveTarget and not moveTo(lastMoveTarget, true) then return reply end
        if not waitActive(0.3 * attempt) then return reply end
    end
    return reply
end

local function release()
    local ownedSession = clientState.Busy == token
    if ownsTraining then
        invoke("Training_Stop")
        ownsTraining = false
    end
    if ownsThrow then
        invoke("Throw_Cancel")
        ownsThrow = false
    end
    if ownedSession then
        local char = player.Character
        local root = char and char:FindFirstChild("HumanoidRootPart")
        if root and root:IsA("BasePart") then root.Anchored = false end
    end
    if savedPosition and savedCharacter == player.Character and savedCharacter and savedCharacter.Parent then
        savedCharacter:PivotTo(savedPosition)
    end
    savedPosition = nil
    savedCharacter = nil
    if clientState.Busy == token then
        clientState.Busy = nil
    end
end

local function upgrade(trainingOnly: boolean?)
    if not SETTINGS.AutoUpgradeTraining and (trainingOnly or not SETTINGS.AutoUpgradeFood) then
        return
    end
    for _ = 1, 8 do
        if not active() then
            return
        end
        local d = data()
        if not d then
            return
        end
        local money = value(d, "Money", 0)
        local owned = d:FindFirstChild("OwnedFoods")
        local bestOwned = 1
        local candidate: any = nil
        for index, food in pairs(foods.List) do
            if value(owned, tostring(index), false) then
                bestOwned = math.max(bestOwned, index)
            elseif SETTINGS.AutoUpgradeFood and not trainingOnly and food.Price <= money
                and (not candidate or food.Price < candidate.Price) then
                candidate = food
            end
        end
        if value(d, "EquippedFood", 1) < bestOwned then
            invoke("Shop_Equip", bestOwned)
        end
        local nextStand = stands.Get(value(d, "Stand", 0) + 1)
        local plots = workspace:FindFirstChild("Plots")
        local plot = plots and plots:FindFirstChild(tostring(player:GetAttribute("PlotIndex")))
        if not plot or not plot:IsA("BasePart") then
            return
        end
        local reply
        local buyingStand = SETTINGS.AutoUpgradeTraining and nextStand and nextStand.Price <= money
        if buyingStand then
            status("Upgrading training bar")
            if not moveTo(plot.Position + gameConfig.Plot.UpgradeButtonOffset + Vector3.new(0, 3, 0)) then
                return
            end
            reply = invokeAtStation("Stand_Upgrade")
        elseif candidate then
            status("Buying " .. candidate.Name)
            if not moveTo(plot.Position + gameConfig.Plot.ShopCircleOffset + Vector3.new(0, 3, 0)) then
                return
            end
            reply = invokeAtStation("Shop_Buy", candidate.Index)
            if reply.Ok then
                invoke("Shop_Equip", candidate.Index)
            end
        else
            return
        end
        if not reply.Ok then
            control:SetAttribute("UpgradeNote", tostring(reply.Reason))
            return
        end
        control:SetAttribute("UpgradeNote", nil)
        if buyingStand then
            control:SetAttribute("TrainingUpgrades", (control:GetAttribute("TrainingUpgrades") :: number) + 1)
            control:SetAttribute("TrainingBar", nextStand.Name)
        end
        if not waitActive(0.3) then
            return
        end
    end
end

local function claimRewards()
    if not active() or os.clock() - lastRewardCheck < 10 then return end
    lastRewardCheck = os.clock()
    local d = data()
    if not d then return end
    local pending = d:FindFirstChild("OfflinePending")
    if SETTINGS.AutoClaimOffline and value(pending, "Base", 0) > 0 then
        status("Claiming offline earnings")
        local before = value(pending, "Base", 0)
        local ok, err = pcall(offlineEarnings.Claim)
        if ok and value(pending, "Base", 0) < before then
            control:SetAttribute("RewardsClaimed", (control:GetAttribute("RewardsClaimed") :: number) + 1)
            control:SetAttribute("RewardNote", "Offline earnings claimed")
        elseif not ok then
            control:SetAttribute("RewardNote", "Offline claim: " .. tostring(err))
        end
    end
    if SETTINGS.AutoClaimFree and not value(d, "FreeAnimalClaimed", true) then
        status("Claiming free animal")
        local reply = invoke("Shop_ClaimFree")
        if reply.Ok then
            control:SetAttribute("RewardsClaimed", (control:GetAttribute("RewardsClaimed") :: number) + 1)
            control:SetAttribute("RewardNote", "Free animal claimed")
            invoke("Plot_EquipBest")
        else
            control:SetAttribute("RewardNote", "Free claim: " .. tostring(reply.Reason))
            lastRewardCheck = os.clock() + 50
        end
    end
end

local function upgradeFence()
    if not SETTINGS.AutoUpgradeFence then return end
    for _ = 1, #fences.Upgrades do
        if not active() then return end
        local d = data()
        local nextUpgrade = fences.Upgrades[value(d, "FenceLevel", 0) + 1]
        if not nextUpgrade or value(d, "Money", 0) < nextUpgrade.Price then return end
        local plots = workspace:FindFirstChild("Plots")
        local plot = plots and plots:FindFirstChild(tostring(player:GetAttribute("PlotIndex")))
        if not plot or not plot:IsA("BasePart") then return end
        status("Upgrading fence to " .. tostring(nextUpgrade.Slots) .. " pet slots")
        if not moveTo(plot.Position + fences.SignOffset + Vector3.new(0, 3.5, 0)) then return end
        local reply = invokeAtStation("Plot_UpgradeFence")
        if not reply.Ok then
            control:SetAttribute("FenceNote", tostring(reply.Reason))
            return
        end
        control:SetAttribute("FenceNote", nil)
        control:SetAttribute("FenceUpgrades", (control:GetAttribute("FenceUpgrades") :: number) + 1)
        control:SetAttribute("PetSlots", nextUpgrade.Slots)
        invoke("Plot_EquipBest")
        if not waitActive(0.3) then return end
    end
end

local function eggCount(key: string): number
    local d = data()
    local folder = d and d:FindFirstChild("Eggs")
    return math.max(0, tonumber(value(folder, key, 0)) or 0)
end

local function chooseOwnedEgg(): string?
    if SETTINGS.EggType ~= "Any Owned" then
        return eggCount(SETTINGS.EggType) > 0 and SETTINGS.EggType or nil
    end
    for _,key in ipairs(eggsConfig.Order or {}) do
        if eggCount(key) > 0 then return key end
    end
    return nil
end

local function watchEgg(model: Instance)
    if watchedEggs[model] then return end
    watchedEggs[model] = true
    task.spawn(function()
        setthreadidentity(8)
        local deadline = os.clock() + 5
        while running and model.Parent and os.clock() < deadline do
            if model:GetAttribute("OwnerUserId") and model:GetAttribute("HatchStart") then break end
            task.wait(0.1)
        end
        if not running or model:GetAttribute("OwnerUserId") ~= player.UserId then return end
        local started = tonumber(model:GetAttribute("HatchStart"))
        if not started then return end
        local duration = tonumber(model:GetAttribute("HatchDuration")) or eggsConfig.Hatch.Duration or 6.5
        local finishAt = started + duration
        local key = tostring(model:GetAttribute("EggKey") or "Egg")
        local animalId = model:GetAttribute("AnimalId")
        local result: any = {}
        local timeout = os.clock() + duration + 15
        while running and os.clock() < timeout do
            animalId = model:GetAttribute("AnimalId") or animalId
            result.ModelName = model:GetAttribute("ResultModel") or result.ModelName
            result.DisplayName = model:GetAttribute("ResultName") or result.DisplayName
            result.Rarity = model:GetAttribute("ResultRarity") or result.Rarity
            result.Mutation = model:GetAttribute("ResultMutation") or result.Mutation
            result.Size = model:GetAttribute("ResultSize") or result.Size
            result.Income = model:GetAttribute("ResultIncome") or result.Income
            local d = data()
            local animals = d and d:FindFirstChild("Animals")
            local animal = type(animalId) == "string" and animals and animals:FindFirstChild(animalId)
            if workspace:GetServerTimeNow() >= finishAt and animal then
                result.ModelName = result.ModelName or value(animal, "ModelName", nil)
                result.DisplayName = result.DisplayName or result.ModelName
                result.Mutation = result.Mutation or value(animal, "Mutation", nil)
                result.Size = result.Size or value(animal, "Size", 1)
                if not result.Income then
                    result.Income = mutations.IncomeOf({ModelName=result.ModelName,Mutation=result.Mutation,
                        Size=result.Size,OfBest=value(animal,"OfBest",nil)}, player:GetAttribute("BestIncome") or 0)
                end
                control:SetAttribute("EggsHatched", (control:GetAttribute("EggsHatched") :: number) + 1)
                control:SetAttribute("LastAnimal", tostring(result.DisplayName or "Egg reward"))
                control:SetAttribute("LastRarity", tostring(result.Rarity or "Egg Reward"))
                control:SetAttribute("LastMutation", tostring(result.Mutation or "Normal"))
                control:SetAttribute("PreviewIncome", result.Income or 0)
                control:SetAttribute("LastDecision", "Kept: protected " .. key .. " egg reward")
                control:SetAttribute("EggNote", "Hatched " .. tostring(result.DisplayName or result.ModelName))
                recordRoll(result, "HATCHED", key .. " egg reward kept")
                return
            end
            task.wait(0.2)
        end
        if running then control:SetAttribute("EggNote", "Hatch result not confirmed; check your inventory") end
    end)
end

local function reserveEggSlot(): boolean
    local d = data()
    local animals = d and d:FindFirstChild("Animals")
    if not animals then return false end
    local weakest: Instance? = nil
    local lowest = math.huge
    for _,animal in ipairs(animals:GetChildren()) do
        if value(animal, "Placed", false) then
            local info = {ModelName=value(animal,"ModelName",""),Mutation=value(animal,"Mutation",nil),
                Size=value(animal,"Size",1),OfBest=value(animal,"OfBest",nil)}
            local income = mutations.IncomeOf(info, player:GetAttribute("BestIncome") or 0)
            if income < lowest then lowest = income; weakest = animal end
        end
    end
    if not weakest then return false end
    -- Picking up a pet preserves it in inventory; no pet is sold to make hatch space.
    return invoke("Plot_PickUpAnimal", weakest.Name).Ok == true
end

local function hatchOwnedEgg()
    if not active() or (not SETTINGS.AutoHatchEggs and not oneEggRequested) or os.clock() < nextEggAttemptAt then return end
    local key = chooseOwnedEgg()
    if not key then
        oneEggRequested = false
        control:SetAttribute("EggNote", "No matching owned egg; no hatch request sent")
        return
    end
    oneEggRequested = false
    for _,model in ipairs(CollectionService:GetTagged("HatchingEgg")) do
        if model:GetAttribute("OwnerUserId") == player.UserId then
            watchEgg(model)
            control:SetAttribute("EggNote", "Waiting for the current egg to hatch")
            nextEggAttemptAt = os.clock() + 2
            return
        end
    end
    local plots = workspace:FindFirstChild("Plots")
    local plot = plots and plots:FindFirstChild(tostring(player:GetAttribute("PlotIndex")))
    if not plot or not plot:IsA("BasePart") then return end
    status("Hatching " .. key .. " egg")
    if not moveTo(plot.Position + gameConfig.Plot.EntranceOffset) then return end
    local beforeCount = eggCount(key)
    if beforeCount < 1 then return end
    local offset = eggPlacementIndex % 9
    eggPlacementIndex += 1
    local spot = plot.Position + Vector3.new((offset % 3 - 1) * 9, plot.Size.Y / 2, (math.floor(offset / 3) - 1) * 9)
    local beforeHatched = control:GetAttribute("EggsHatched") :: number
    local reply = invoke("Egg_Place", key, spot)
    local pickedUp = false
    if not reply.Ok and reply.Reason == "Full" and eggCount(key) == beforeCount and active() then
        pickedUp = reserveEggSlot()
        if pickedUp and eggCount(key) >= 1 then reply = invoke("Egg_Place", key, spot) end
    end
    if not reply.Ok then
        if pickedUp then invoke("Plot_EquipBest") end
        control:SetAttribute("EggNote", "Hatch not started: " .. tostring(reply.Reason))
        nextEggAttemptAt = os.clock() + 10
        return
    end
    control:SetAttribute("EggsStarted", (control:GetAttribute("EggsStarted") :: number) + 1)
    control:SetAttribute("EggNote", "Hatching " .. key .. "...")
    control:SetAttribute("LastPetStatus", "HATCHING")
    control:SetAttribute("LastAnimal", key .. " Egg")
    control:SetAttribute("LastRarity", "Egg")
    control:SetAttribute("LastMutation", "Waiting")
    control:SetAttribute("PreviewIncome", 0)
    control:SetAttribute("LastDecision", "Waiting for the server to finish hatching")
    local deadline = os.clock() + (eggsConfig.Hatch.Duration or 6.5) + 15
    while active() and os.clock() < deadline do
        for _,model in ipairs(CollectionService:GetTagged("HatchingEgg")) do
            if model:GetAttribute("OwnerUserId") == player.UserId then watchEgg(model) end
        end
        if (control:GetAttribute("EggsHatched") :: number) > beforeHatched then break end
        if not waitActive(0.2) then break end
    end
    if active() and (control:GetAttribute("EggsHatched") :: number) <= beforeHatched then
        control:SetAttribute("EggNote", "Hatch result not confirmed; check your inventory")
    end
    invoke("Plot_EquipBest")
    nextEggAttemptAt = os.clock() + 1
end

table.insert(connections, CollectionService:GetInstanceAddedSignal("HatchingEgg"):Connect(watchEgg))
for _,model in ipairs(CollectionService:GetTagged("HatchingEgg")) do watchEgg(model) end

local function train()
    if not SETTINGS.AutoTrain then
        return
    end
    local d = data()
    if value(d, "Stand", 0) < 1 then
        if trainingOnly then status("Waiting for a training bar"); waitActive(1) end
        return
    end
    local plots = workspace:FindFirstChild("Plots")
    local plot = plots and plots:FindFirstChild(tostring(player:GetAttribute("PlotIndex")))
    if not plot or not plot:IsA("BasePart") then
        return
    end
    local position = plot.Position + gameConfig.Plot.TrainingSpotOffset + Vector3.new(0, 3, 0)
    status("Moving to training")
    if not moveTo(position) then
        return
    end
    ownsTraining = true
    local reply = invokeAtStation("Training_Start")
    if not reply.Ok then
        ownsTraining = false
        error("Training: " .. tostring(reply.Reason))
    end
    local finishAt = os.clock() + SETTINGS.TrainingSeconds
    local nextUpgradeCheck = 0
    while active() and SETTINGS.AutoTrain and not awaitingTrainingChoice and (trainingOnly or os.clock() < finishAt) do
        status(trainingOnly and "Training only — pet farming stopped" or "Training")
        if SETTINGS.AutoUpgradeTraining and os.clock() >= nextUpgradeCheck then
            nextUpgradeCheck = os.clock() + 2
            local currentData = data()
            local nextStand = stands.Get(value(currentData, "Stand", 0) + 1)
            if nextStand and value(currentData, "Money", 0) >= nextStand.Price then
                invoke("Training_Stop")
                ownsTraining = false
                upgrade(true)
                if not moveTo(position) then
                    return
                end
                ownsTraining = true
                local restarted = invokeAtStation("Training_Start")
                if not restarted.Ok then
                    ownsTraining = false
                    error("Training restart: " .. tostring(restarted.Reason))
                end
            end
        end
        if not waitActive(0.5) then
            break
        end
    end
    invoke("Training_Stop")
    ownsTraining = false
    waitActive(0.3)
end

local function throwPerfect()
    if not waitActive(math.max(0, nextThrowAt - os.clock())) then
        return
    end
    status("Moving to throwing line")
    local starter = workspace:FindFirstChild("StarterArea")
    local crossLine = starter and starter:FindFirstChild("CrossLine")
    local safeZ = crossLine and crossLine:IsA("BasePart") and crossLine.Position.Z + 0.5
        or gameConfig.Throw.LaunchPosition.Z + 5.5
    local launch = Vector3.new(gameConfig.Throw.LaunchPosition.X, gameConfig.Throw.LaunchPosition.Y + 6, safeZ)
    if not moveTo(launch) then
        return
    end
    local known, cutoff = inventorySnapshot()
    local started: any = nil
    for attempt = 1, 4 do
        if not active() then return end
        started = invoke("Throw_Start")
        if started.Ok then break end
        if started.Reason ~= "Cooldown" and started.Reason ~= "TooFar" then
            error("Throw start: " .. tostring(started.Reason))
        end
        if not moveTo(launch, true) or not waitActive(0.25 * attempt) then return end
    end
    if not started or not started.Ok then
        error("Throw start: " .. tostring(started and started.Reason))
    end
    ownsThrow = true
    if not active() then
        return
    end
    if SETTINGS.AutoUseSuper and value(data(), "SuperThrows", 0) > 0 then
        local super = invoke("Throw_UseSuper")
        if super.Ok then
            control:SetAttribute("SuperThrowsUsed", (control:GetAttribute("SuperThrowsUsed") :: number) + 1)
        else
            control:SetAttribute("SuperNote", tostring(super.Reason))
        end
    end
    local result = invoke("Throw_Resolve", SETTINGS.PerfectAccuracy)
    if not result.Ok then
        error("Throw resolve: " .. tostring(result.Reason))
    end
    assert(result.Accuracy == 1, "Game did not confirm perfect accuracy")
    control:SetAttribute("LastAccuracy", result.Accuracy)
    control:SetAttribute("LastBonus", result.Bonus or 0)
    control:SetAttribute("LastAnimal", tostring(result.DisplayName or result.ModelName))
    control:SetAttribute("LastRarity", tostring(result.Rarity or "Unknown"))
    control:SetAttribute("LastMutation", tostring(result.Mutation or "Normal"))
    control:SetAttribute("LastPetStatus", "CHECKING")
    control:SetAttribute("LastPetArea", tostring(result.AreaName or "Unknown"))
    control:SetAttribute("LastPetAreaIndex", result.AreaIndex or 0)
    control:SetAttribute("Previews", (control:GetAttribute("Previews") :: number) + 1)
    control:SetAttribute("PerfectThrows", (control:GetAttribute("PerfectThrows") :: number) + 1)
    local keep, reason = shouldKeep(result, cutoff)
    control:SetAttribute("LastDecision", (keep and "Keeping: " or "Skipping: ") .. reason)
    status((keep and "Keeping " or "Skipping ") .. tostring(result.DisplayName or result.ModelName))
    local char = character()
    if not char or typeof(result.LandingPosition) ~= "Vector3" then
        error("Food landing position is unavailable")
    end
    if keep and active() then
        char:PivotTo(CFrame.new(result.LandingPosition + Vector3.new(0, 4, 0)))
        waitActive(SETTINGS.FastMode and 0.03 or 0.15)
    end
    local completed = invoke("Throw_Complete")
    if not completed.Ok then
        error("Throw complete: " .. tostring(completed.Reason))
    end
    ownsThrow = false
    local currentRoot = player.Character and player.Character:FindFirstChild("HumanoidRootPart")
    if currentRoot and currentRoot:IsA("BasePart") then currentRoot.Anchored = false end
    nextThrowAt = os.clock() + math.max(0.1, gameConfig.Throw.Cooldown or 1.5)
    if keep then
        control:SetAttribute("Catches", (control:GetAttribute("Catches") :: number) + 1)
        recordRoll(result, "KEPT", reason)
        invoke("Plot_EquipBest")
    elseif discardNewPet(completed.AnimalId, known) then
        control:SetAttribute("Skipped", (control:GetAttribute("Skipped") :: number) + 1)
        recordRoll(result, "SKIPPED", reason)
    else
        control:SetAttribute("LastDecision", "Kept: server declined discard")
        recordRoll(result, "KEPT", "Server declined discard")
    end
    control:SetAttribute("LastError", nil)
end

local function stop()
    if not running then
        return
    end
    enabled = false
    running = false
    control:SetAttribute("Enabled", false)
    status("Stopping")
    if dismissTrainingPrompt then dismissTrainingPrompt() end
    saveRevision += 1
    persistSettings()
    resumePermission(false)
    for _, connection in ipairs(connections) do
        connection:Disconnect()
    end
    print("[Food Farm] Stopping and restoring your character.")
    if sideTracker then
        sideTracker:Destroy()
        sideTracker = nil
    end
    if ui and ui.alive then
        ui:Destroy()
    end
end

local function toggle()
    if not running then
        return
    end
    enabled = not enabled
    setSetting("StartPaused", not enabled)
    resumePermission(enabled and SETTINGS.AutoResume)
    needsRestore = not enabled
    control:SetAttribute("Enabled", enabled)
    if not enabled and dismissTrainingPrompt then dismissTrainingPrompt() end
    syncModeControls()
    status(if enabled then "Resuming" else "Pausing")
    print(if enabled then "[Food Farm] Resumed" else "[Food Farm] Paused")
end

local function setTrainingOnly(value: boolean)
    if dismissTrainingPrompt then dismissTrainingPrompt() end
    trainingOnly = value
    enabled = value
    needsRestore = not value
    setSetting("TrainingOnly", value)
    setSetting("StartPaused", not enabled)
    if value then setSetting("AutoTrain", true) end
    control:SetAttribute("Enabled", enabled)
    skippedInRow = 0
    control:SetAttribute("SkippedInRow", 0)
    resumePermission(enabled and SETTINGS.AutoResume)
    syncModeControls()
    status(value and "Switching to training only" or "Paused")
end

local function startFarming()
    if dismissTrainingPrompt then dismissTrainingPrompt() end
    trainingOnly = false
    enabled = true
    setSetting("TrainingOnly", false)
    setSetting("StartPaused", false)
    control:SetAttribute("Enabled", true)
    resumePermission(SETTINGS.AutoResume)
    syncModeControls()
    status("Resuming farming")
end

local promptRoot: ScreenGui? = nil
local promptConnections: {RBXScriptConnection} = {}
local promptMouseBehavior: Enum.MouseBehavior? = nil
local promptMouseIcon: boolean? = nil
dismissTrainingPrompt = function()
    awaitingTrainingChoice = false
    control:SetAttribute("TrainingPromptVisible", false)
    for _,connection in ipairs(promptConnections) do connection:Disconnect() end
    table.clear(promptConnections)
    if promptRoot then promptRoot:Destroy(); promptRoot = nil end
    if promptMouseBehavior then UserInputService.MouseBehavior = promptMouseBehavior; promptMouseBehavior = nil end
    if promptMouseIcon ~= nil then UserInputService.MouseIconEnabled = promptMouseIcon; promptMouseIcon = nil end
end

answerTrainingPrompt = function(yes: boolean)
    if not awaitingTrainingChoice then return end
    control:SetAttribute("LastTrainingChoice", yes and "Yes" or "No")
    if dismissTrainingPrompt then dismissTrainingPrompt() end
    skippedInRow = 0
    control:SetAttribute("SkippedInRow", 0)
    if yes then
        setTrainingOnly(true)
    else
        syncModeControls()
        status("Continuing farming")
    end
end

requestTrainingPrompt = function()
    if not running or not enabled or trainingOnly or awaitingTrainingChoice then return end
    awaitingTrainingChoice = true
    control:SetAttribute("TrainingPromptVisible", true)
    control:SetAttribute("LastTrainingChoice", "Waiting")
    status("Waiting for your training choice")
    promptMouseBehavior = UserInputService.MouseBehavior
    promptMouseIcon = UserInputService.MouseIconEnabled
    UserInputService.MouseBehavior = Enum.MouseBehavior.Default
    UserInputService.MouseIconEnabled = true
    local root = Instance.new("ScreenGui")
    root.Name = "Miz0TrainingPrompt"
    root.ResetOnSpawn = false
    root.IgnoreGuiInset = true
    root.DisplayOrder = 10080
    root.Parent = player:WaitForChild("PlayerGui")
    promptRoot = root
    local backdrop = Instance.new("TextButton")
    backdrop.Name = "Backdrop"
    backdrop.Size = UDim2.fromScale(1, 1)
    backdrop.BackgroundColor3 = Color3.fromHex("163850")
    backdrop.BackgroundTransparency = 0.4
    backdrop.BorderSizePixel = 0
    backdrop.Text = ""
    backdrop.AutoButtonColor = false
    backdrop.Modal = true
    backdrop.Parent = root
    local card = Instance.new("Frame")
    card.Name = "TrainingChoice"
    card.AnchorPoint = Vector2.new(0.5, 0.5)
    card.Position = UDim2.fromScale(0.5, 0.5)
    local viewport = workspace.CurrentCamera and workspace.CurrentCamera.ViewportSize or Vector2.new(1280, 720)
    card.Size = UDim2.fromOffset(math.min(430, math.max(260, viewport.X - 24)), 238)
    card.BackgroundColor3 = Color3.fromHex("EAF6FF")
    card.BorderSizePixel = 0
    card.Parent = root
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 18)
    corner.Parent = card
    local edge = Instance.new("UIStroke")
    edge.Color = Color3.fromHex("8EBDE0")
    edge.Thickness = 1
    edge.Parent = card
    local title = Instance.new("TextLabel")
    title.Name = "Title"
    title.BackgroundTransparency = 1
    title.Position = UDim2.fromOffset(22, 17)
    title.Size = UDim2.new(1, -65, 0, 30)
    title.Text = "Switch to training?"
    title.TextColor3 = Color3.fromHex("244B67")
    title.Font = Enum.Font.GothamBold
    title.TextSize = 20
    title.TextXAlignment = Enum.TextXAlignment.Left
    title.Parent = card
    local body = Instance.new("TextLabel")
    body.Name = "Message"
    body.BackgroundTransparency = 1
    body.Position = UDim2.fromOffset(22, 58)
    body.Size = UDim2.new(1, -44, 0, 105)
    body.Text = "3 pets were skipped in a row.\nTrain to improve your throws?\n\nYes stops pet farming and trains continuously."
    body.TextColor3 = Color3.fromHex("53728B")
    body.Font = Enum.Font.GothamMedium
    body.TextSize = 14
    body.TextWrapped = true
    body.TextXAlignment = Enum.TextXAlignment.Left
    body.TextYAlignment = Enum.TextYAlignment.Top
    body.Parent = card
    local function button(name: string, text: string, xScale: number, xOffset: number, color: Color3): TextButton
        local item = Instance.new("TextButton")
        item.Name = name
        item.Position = UDim2.new(xScale, xOffset, 1, -60)
        item.Size = UDim2.new(0.5, -30, 0, 40)
        item.BackgroundColor3 = color
        item.BorderSizePixel = 0
        item.Text = text
        item.Font = Enum.Font.GothamBold
        item.TextSize = 14
        item.TextColor3 = name == "YesTrain" and Color3.new(1,1,1) or Color3.fromHex("244B67")
        item.Modal = true
        item.Parent = card
        local round = Instance.new("UICorner")
        round.CornerRadius = UDim.new(0, 10)
        round.Parent = item
        return item
    end
    local yes = button("YesTrain", "Yes, train", 0, 22, Color3.fromHex("397CA8"))
    local no = button("KeepFarming", "Keep farming", 0.5, 8, Color3.fromHex("D0E8F9"))
    table.insert(promptConnections, yes.Activated:Connect(function()
        setthreadidentity(8)
        if answerTrainingPrompt then answerTrainingPrompt(true) end
    end))
    table.insert(promptConnections, no.Activated:Connect(function()
        setthreadidentity(8)
        if answerTrainingPrompt then answerTrainingPrompt(false) end
    end))
    table.insert(promptConnections, backdrop.Activated:Connect(function()
        setthreadidentity(8)
        if answerTrainingPrompt then answerTrainingPrompt(false) end
    end))
end

table.insert(connections, control.Event:Connect(function(command: string)
    if command == "stop" then
        stop()
    elseif command == "toggle" then
        toggle()
    elseif command == "show-training-prompt" and requestTrainingPrompt then
        requestTrainingPrompt()
    elseif command == "choose-training-yes" and answerTrainingPrompt then
        answerTrainingPrompt(true)
    elseif command == "choose-training-no" and answerTrainingPrompt then
        answerTrainingPrompt(false)
    elseif command == "farm" then
        startFarming()
    elseif command == "training-only" then
        setTrainingOnly(true)
    end
end))

table.insert(connections, player.OnTeleport:Connect(function(state)
    if queuedResume or state ~= Enum.TeleportState.Started or not SETTINGS.AutoResume or not enabled then return end
    if not isfile(RESUME_SCRIPT) then
        control:SetAttribute("ResumeNote", "Run the saved script after joining")
        return
    end
    persistSettings()
    resumePermission(true)
    local ok, err = pcall(queue_on_teleport, [==[
task.spawn(function()
    for _ = 1, 120 do
        if game:IsLoaded() and game:GetService("Players").LocalPlayer then break end
        task.wait(0.5)
    end
    if game.PlaceId ~= 120219252362013 then return end
    local ok, allowed = pcall(function() return json.decode(readfile("Miz0Gui/throw-food-resume.json")) end)
    local settingsOK, settings = pcall(function() return json.decode(readfile("Miz0Gui/throw-food-settings.json")) end)
    if not ok or not allowed.allowed or not settingsOK or not settings.AutoResume or settings.StartPaused then return end
    local p = game:GetService("Players").LocalPlayer
    for _ = 1, 120 do
        if p and p:GetAttribute("DataLoaded") then break end
        task.wait(0.5)
        p = game:GetService("Players").LocalPlayer
    end
    if not p or not p:GetAttribute("DataLoaded") then return end
    local run = loadfile("Miz0Gui/ThrowFoodAutoFarm.luau")
    if run then run() end
end)
]==])
    queuedResume = ok
    control:SetAttribute("ResumeNote", ok and "Resume queued" or tostring(err))
end))
table.insert(connections, UserInputService.InputBegan:Connect(function(input, processed)
    if processed or UserInputService:GetFocusedTextBox() then
        return
    end
    if input.KeyCode == SETTINGS.ToggleKey then
        toggle()
    elseif input.KeyCode == SETTINGS.StopKey then
        stop()
    end
end))
table.insert(connections, remotes.Training_Bonus.OnClientEvent:Connect(function(id)
    if active() and ownsTraining then
        task.spawn(function()
            invoke("Training_TapBonus", id)
        end)
    end
end))

local function createSideTracker(): any
    local playerGui = player:WaitForChild("PlayerGui")
    local previous = playerGui:FindFirstChild("Miz0PetTracker")
    if previous then previous:Destroy() end
    local root = Instance.new("ScreenGui")
    root.Name = "Miz0PetTracker"
    root.ResetOnSpawn = false
    root.IgnoreGuiInset = false
    root.DisplayOrder = 10050
    root.ZIndexBehavior = Enum.ZIndexBehavior.Sibling
    root.Parent = playerGui
    local panel = Instance.new("Frame")
    panel.Name = "PetTracker"
    panel.AnchorPoint = Vector2.new(1, 0.5)
    panel.Position = UDim2.new(1, -16, 0.5, 0)
    panel.Size = UDim2.fromOffset(272, 302)
    panel.BackgroundColor3 = Color3.fromHex("EAF6FF")
    panel.BackgroundTransparency = 0.04
    panel.BorderSizePixel = 0
    panel.Parent = root
    local corner = Instance.new("UICorner")
    corner.CornerRadius = UDim.new(0, 16)
    corner.Parent = panel
    local edge = Instance.new("UIStroke")
    edge.Color = Color3.fromHex("8EBDE0")
    edge.Transparency = 0.25
    edge.Thickness = 1
    edge.Parent = panel
    local gradient = Instance.new("UIGradient")
    gradient.Color = ColorSequence.new(Color3.fromHex("F3FBFF"), Color3.fromHex("CEE9FB"))
    gradient.Rotation = 90
    gradient.Parent = panel
    local portrait = ui and ui.portraitAsset or ""
    if portrait ~= "" then
        local picture = Instance.new("ImageLabel")
        picture.Name = "Miz0PictureBackground"
        picture.BackgroundTransparency = 1
        picture.Size = UDim2.fromScale(1, 1)
        picture.Image = portrait
        picture.ImageTransparency = 0.90
        picture.ScaleType = Enum.ScaleType.Crop
        picture.ZIndex = 1
        picture.Parent = panel
        local pictureCorner = Instance.new("UICorner")
        pictureCorner.CornerRadius = UDim.new(0, 16)
        pictureCorner.Parent = picture
        local avatar = Instance.new("ImageLabel")
        avatar.Name = "Miz0Picture"
        avatar.BackgroundTransparency = 1
        avatar.Position = UDim2.fromOffset(14, 8)
        avatar.Size = UDim2.fromOffset(32, 32)
        avatar.Image = portrait
        avatar.ScaleType = Enum.ScaleType.Crop
        avatar.ZIndex = 2
        avatar.Parent = panel
        local avatarCorner = Instance.new("UICorner")
        avatarCorner.CornerRadius = UDim.new(0, 16)
        avatarCorner.Parent = avatar
    end

    local function label(name: string, text: string, y: number, height: number, size: number): TextLabel
        local item = Instance.new("TextLabel")
        item.Name = name
        item.BackgroundTransparency = 1
        item.Position = UDim2.fromOffset(14, y)
        item.Size = UDim2.new(1, -28, 0, height)
        item.Font = Enum.Font.GothamMedium
        item.TextSize = size
        item.TextColor3 = Color3.fromHex("244B67")
        item.TextXAlignment = Enum.TextXAlignment.Left
        item.TextYAlignment = Enum.TextYAlignment.Center
        item.TextWrapped = true
        item.Text = text
        item.ZIndex = 2
        item.Parent = panel
        return item
    end
    local title = label("Title", "Miz0  /  Pet Tracker", 12, 24, 16)
    title.Font = Enum.Font.GothamBold
    if portrait ~= "" then
        title.Position = UDim2.fromOffset(56, 12)
        title.Size = UDim2.new(1, -70, 0, 24)
        title.Text = "Miz0 Pet Tracker"
    end
    local badge = label("Outcome", "WAITING", 45, 28, 13)
    badge.BackgroundTransparency = 0
    badge.BackgroundColor3 = Color3.fromHex("D0E8F9")
    badge.TextXAlignment = Enum.TextXAlignment.Center
    local badgeCorner = Instance.new("UICorner")
    badgeCorner.CornerRadius = UDim.new(0, 8)
    badgeCorner.Parent = badge
    local petName = label("PetName", "Waiting for a pet", 82, 32, 19)
    petName.Font = Enum.Font.GothamBold
    local details = label("Details", "", 116, 42, 12)
    local decision = label("Decision", "The next roll will appear here.", 160, 34, 12)
    local counts = label("Counts", "Kept 0  ·  Skipped 0\nEggs hatched 0", 197, 37, 12)
    counts.Font = Enum.Font.GothamBold
    local recent = label("Recent", "Recent rolls will appear here.", 243, 46, 11)
    recent.TextYAlignment = Enum.TextYAlignment.Top
    recent.TextColor3 = Color3.fromHex("53728B")

    local tracker: any = {}
    function tracker:SetVisible(visible: boolean)
        root.Enabled = visible
    end
    function tracker:Update()
        if not root.Parent then return end
        local outcome = tostring(control:GetAttribute("LastPetStatus") or "WAITING")
        badge.Text = outcome
        local kept = outcome == "KEPT" or outcome == "HATCHED"
        badge.TextColor3 = outcome == "SKIPPED" and Color3.fromHex("A63859")
            or kept and Color3.fromHex("237568") or Color3.fromHex("397CA8")
        badge.BackgroundColor3 = outcome == "SKIPPED" and Color3.fromHex("F8DDE5")
            or kept and Color3.fromHex("D8F1E8") or Color3.fromHex("D0E8F9")
        petName.Text = tostring(control:GetAttribute("LastAnimal") or "Waiting for a pet")
        details.Text = string.format("%s  ·  %s\nIncome: %s/s",
            tostring(control:GetAttribute("LastRarity") or ""), tostring(control:GetAttribute("LastMutation") or ""),
            tostring(control:GetAttribute("PreviewIncome") or 0))
        decision.Text = tostring(control:GetAttribute("LastDecision") or "Checking the next roll...")
        counts.Text = string.format("Kept %s  ·  Skipped %s\nEggs hatched %s", tostring(control:GetAttribute("Catches") or 0),
            tostring(control:GetAttribute("Skipped") or 0), tostring(control:GetAttribute("EggsHatched") or 0))
        recent.Text = #shortHistory > 0 and table.concat(shortHistory, "\n") or "Recent rolls will appear here."
    end
    function tracker:Destroy()
        root:Destroy()
    end
    return tracker
end

local function initializeUI()
    ui = createMiz0({Title = "Miz0 Hub", Subtitle = "Throw Food For Animals", Examples = false})
    local oldCleanup = ui.cleanup
    ui.cleanup = function()
        stop()
        oldCleanup()
    end
    sideTracker = createSideTracker()
    local main = ui:CreateTab({name = "Farming", icon = "leaf"})
    main:Heading("Perfect Catch Farm")
    farmToggle = main:CreateToggle({
        name = "Auto Farm", value = enabled and not trainingOnly,
        description = "Train, catch animals, and grow your income. F6 pauses or resumes.",
        callback = function(value)
            if value ~= (enabled and not trainingOnly) then
                if value then startFarming() elseif not trainingOnly then toggle() end
            end
        end,
    })
    local stateCard = main:Card("Starting", "Preparing the farm...", "activity")
    local petCard = main:Card("Latest Pet", "Waiting for the first preview.", "paw-print")
    main:Card("Perfect Throws", "Always 100% accuracy with the full +20 power bonus.", "target")
    main:Card("Fast Pet Filter", "Previews every perfect throw. Keeps upgrades and immediately sells weak pets from that throw.", "paw-print")
    main:CreateDropdown({name = "Keep Rule", options = {"Better Income", "Better Income or New", "All Pets"}, value = SETTINGS.KeepRule,
        description = "Better Income keeps pets that improve your strongest lineup.",
        callback = function(value) setSetting("KeepRule", value) end})
    main:CreateToggle({name = "Fast Mode", value = SETTINGS.FastMode,
        description = "Skips animations and extra waits. Weak rolls skip travel to the food.",
        callback = function(value) setSetting("FastMode", value) end})
    autoTrainToggle = main:CreateToggle({name = "Auto Train", value = SETTINGS.AutoTrain,
        description = "Build throw power between catch batches.",
        callback = function(value)
            setSetting("AutoTrain", value)
            if not value and trainingOnly then setTrainingOnly(false) end
        end})
    trainingOnlyToggle = main:CreateToggle({name = "Training Only", value = enabled and trainingOnly,
        description = "Train continuously without pet farming. Turn Auto Farm on to resume catches.",
        callback = function(value)
            if value ~= (enabled and trainingOnly) then setTrainingOnly(value) end
        end})
    main:CreateToggle({name = "Auto Upgrade Training", value = SETTINGS.AutoUpgradeTraining,
        description = "Buy the next affordable bar, including while training. Uses earned cash.",
        callback = function(value) setSetting("AutoUpgradeTraining", value) end})
    main:CreateToggle({name = "Auto Upgrade Food", value = SETTINGS.AutoUpgradeFood,
        description = "Buy and equip better food with earned cash.",
        callback = function(value) setSetting("AutoUpgradeFood", value) end})
    main:CreateToggle({name = "Auto Upgrade Fence", value = SETTINGS.AutoUpgradeFence,
        description = "Spend earned cash on larger fences and more pet slots. Off until enabled.",
        callback = function(value) setSetting("AutoUpgradeFence", value) end})
    main:CreateToggle({name = "Use Earned Super Throws", value = SETTINGS.AutoUseSuper,
        description = "Uses saved Super Throw charges. Off until enabled; never opens a purchase prompt.",
        callback = function(value) setSetting("AutoUseSuper", value) end})

    local settings = ui:CreateTab({name = "Settings", icon = "settings"})
    settings:CreateToggle({name = "Offer Training After 3 Skips", value = SETTINGS.OfferTrainingAfterSkips,
        description = "Asks Yes or No after three skipped pets in a row. Yes switches to training only.",
        callback = function(value)
            setSetting("OfferTrainingAfterSkips", value)
            if not value and awaitingTrainingChoice and answerTrainingPrompt then answerTrainingPrompt(false) end
        end})
    settings:CreateButton({name = "Preview Training Popup", icon = "message-circle",
        description = "Shows the training choice while farming is enabled.",
        callback = function() if requestTrainingPrompt then requestTrainingPrompt() end end})
    settings:CreateToggle({name = "Side Pet Tracker", value = SETTINGS.ShowSideTracker,
        description = "Shows the separate pet panel on the right, even when this menu is hidden.",
        callback = function(value)
            setSetting("ShowSideTracker", value)
            if sideTracker then sideTracker:SetVisible(value) end
        end})
    sideTracker:SetVisible(SETTINGS.ShowSideTracker)
    settings:CreateSlider({name = "Training Time", description = "Seconds of training per cycle.",
        range = {5, 120}, value = SETTINGS.TrainingSeconds, increment = 5,
        callback = function(value) setSetting("TrainingSeconds", value) end})
    settings:CreateSlider({name = "Throws Per Cycle", description = "Perfect catches before returning to train.",
        range = {1, 100}, value = SETTINGS.ThrowsPerCycle, increment = 1,
        callback = function(value) setSetting("ThrowsPerCycle", value) end})
    settings:CreateInput({name = "Minimum Pet Income", value = SETTINGS.MinimumIncome, numeric = true,
        description = "Minimum income per second to keep. Zero uses your lineup's cutoff.",
        callback = function(value) setSetting("MinimumIncome", tonumber(value) or 0) end})
    settings:CreateInput({name = "Never Sell These Pets", value = SETTINGS.ProtectedSpecies,
        description = "Comma-separated pet names, for example Wolf, Griffin. Applies to new rolls.",
        callback = function(value) setSetting("ProtectedSpecies", tostring(value)) end})
    settings:CreateInput({name = "Protected Mutations", value = SETTINGS.ProtectedMutations,
        description = "Comma-separated mutations that are always kept, for example Rainbow, Diamond.",
        callback = function(value) setSetting("ProtectedMutations", tostring(value)) end})
    settings:CreateInput({name = "Protected Rarities", value = SETTINGS.ProtectedRarities,
        description = "Comma-separated rarities to keep, for example Mythic, Secret.",
        callback = function(value) setSetting("ProtectedRarities", tostring(value)) end})
    settings:CreateToggle({name = "Resume After Teleport", value = SETTINGS.AutoResume,
        description = "Restores saved settings on game teleports while Real remains injected.",
        callback = function(value)
            setSetting("AutoResume", value)
            resumePermission(enabled and value)
        end})
    settings:CreateButton({name = "Save Settings Now", icon = "save", callback = persistSettings})
    settings:CreateButton({name = "Equip Best Animals", icon = "sparkles",
        callback = function() task.spawn(function() invoke("Plot_EquipBest") end) end})
    settings:CreateButton({name = "Hide Menu", icon = "panel-left-close",
        description = "Right Shift or the Miz0 launcher opens it again.", callback = function() ui:Toggle() end})
    settings:CreateButton({name = "Stop and Unload", icon = "x",
        description = "Stops the farm, restores your character, and closes this menu. F7 also stops.",
        callback = stop})
    local extras = ui:CreateTab({name = "Rewards & Eggs", icon = "gift"})
    extras:CreateToggle({name = "Claim Free Animal", value = SETTINGS.AutoClaimFree,
        description = "Claims the free animal when your account is eligible.",
        callback = function(value) setSetting("AutoClaimFree", value) end})
    extras:CreateToggle({name = "Claim Offline Earnings", value = SETTINGS.AutoClaimOffline,
        description = "Uses the game's normal free claim button when earnings are pending.",
        callback = function(value) setSetting("AutoClaimOffline", value) end})
    local rewardCard = extras:Card("Rewards", "Checking your account...", "gift")
    local eggCard = extras:Card("Egg Inventory", "Checking owned eggs...", "egg")
    extras:CreateToggle({name = "Auto Hatch Owned Eggs", value = SETTINGS.AutoHatchEggs,
        description = "Uses your owned eggs, one at a time. Egg rewards are kept. Never buys eggs.",
        callback = function(value) setSetting("AutoHatchEggs", value) end})
    local eggOptions = {"Any Owned"}
    for _,key in ipairs(eggsConfig.Order or {}) do table.insert(eggOptions, key) end
    extras:CreateDropdown({name = "Egg Type", options = eggOptions, value = SETTINGS.EggType,
        description = "Choose which owned eggs to hatch.",
        callback = function(value) setSetting("EggType", value) end})
    extras:CreateButton({name = "Hatch One Owned Egg", icon = "egg",
        description = "Uses one owned egg at the next safe point and resumes the farm if paused.",
        callback = function()
            oneEggRequested = true
            nextEggAttemptAt = 0
            if not enabled then toggle() end
        end})
    extras:CreateButton({name = "Open Egg Inventory", icon = "backpack",
        description = "Pauses the farm and opens your normal inventory.",
        callback = function()
            if enabled then toggle() end
            task.spawn(function()
                setthreadidentity(8)
                for _ = 1, 100 do
                    if not clientState.Busy then break end
                    task.wait(0.1)
                end
                if not clientState.Busy then module(controllers, "Inventory").Open() end
            end)
        end})
    local activity = ui:CreateTab({name = "Activity", icon = "list"})
    ui.activityTab = activity
    local statsCard = activity:Card("Session Progress", "Waiting for the first catch.", "trending-up")
    local lastCard = activity:Card("Last Catch", "No farm catch yet.", "paw-print")
    local petLog = ui:CreateTab({name = "Pet Log", icon = "list"})
    local rollConsole = petLog:CreateConsole({name = "Recent Pet Rolls", text = "Waiting for rolls...", maxLines = 12})
    ui:Finish()
    ui.uiWindow:SelectTab(2)
    task.spawn(function()
        setthreadidentity(8)
        while running and ui.alive and control.Parent do
            local ok, err = pcall(function()
                local d = data()
                local state = tostring(control:GetAttribute("Status"))
                local catches = control:GetAttribute("Catches") or 0
                local perfect = control:GetAttribute("PerfectThrows") or 0
                stateCard:Set(string.format("Level %s  |  Cash $%.0f\nKept %s  |  Skipped %s  |  Previews %s",
                    tostring(value(d, "Level", 1)), value(d, "Money", 0), tostring(catches),
                    tostring(control:GetAttribute("Skipped") or 0), tostring(perfect)), state)
                petCard:Set(string.format("%s  |  %s  |  %s\nIncome %s/s\n%s",
                    tostring(control:GetAttribute("LastAnimal") or "Waiting"),
                    tostring(control:GetAttribute("LastRarity") or ""),
                    tostring(control:GetAttribute("LastMutation") or ""),
                    tostring(control:GetAttribute("PreviewIncome") or 0),
                    tostring(control:GetAttribute("LastDecision") or "Checking the next pet")),
                    tostring(control:GetAttribute("LastPetStatus") or "Latest Pet"))
                rollConsole:Set(#rollHistory > 0 and table.concat(rollHistory, "\n") or "Waiting for rolls...")
                if sideTracker then sideTracker:Update() end
                statsCard:Set(string.format("Catches: %s\nPerfect throws: %s\nCompleted cycles: %s\nTraining bar: %s  |  Food: %s\nPet slots: %s  |  Fence upgrades: %s\nSaved Super Throws used: %s",
                    tostring(catches), tostring(perfect), tostring(control:GetAttribute("Cycles") or 0),
                    tostring(value(d, "Stand", 0)), tostring(value(d, "EquippedFood", 1)),
                    tostring(control:GetAttribute("PetSlots") or "Checking"),
                    tostring(control:GetAttribute("FenceUpgrades") or 0), tostring(control:GetAttribute("SuperThrowsUsed") or 0)))
                local pending = d and d:FindFirstChild("OfflinePending")
                rewardCard:Set(string.format("Free animal: %s\nOffline earnings waiting: %s\nClaims this session: %s\n%s",
                    value(d, "FreeAnimalClaimed", false) and "Claimed" or "Unclaimed",
                    tostring(value(pending, "Base", 0)), tostring(control:GetAttribute("RewardsClaimed") or 0),
                    tostring(control:GetAttribute("RewardNote") or "")))
                local eggFolder = d and d:FindFirstChild("Eggs")
                local eggs = {}
                if eggFolder then
                    for _,egg in ipairs(eggFolder:GetChildren()) do
                        if egg:IsA("ValueBase") then table.insert(eggs, egg.Name .. ": " .. tostring((egg :: any).Value)) end
                    end
                end
                local inventoryText = #eggs > 0 and table.concat(eggs, "\n") or "No eggs owned. Waiting for an owned egg."
                eggCard:Set(string.format("%s\nStarted: %s  |  Hatched: %s\n%s", inventoryText,
                    tostring(control:GetAttribute("EggsStarted") or 0), tostring(control:GetAttribute("EggsHatched") or 0),
                    tostring(control:GetAttribute("EggNote") or "")))
                lastCard:Set(string.format("Animal: %s\nAccuracy: %s  |  Bonus: +%s\nIncome: %s  |  Cutoff: %s\n%s\n%s",
                    tostring(control:GetAttribute("LastAnimal") or "Waiting"),
                    control:GetAttribute("LastAccuracy") == 1 and "100%" or "Waiting",
                    tostring(control:GetAttribute("LastBonus") or 0),
                    tostring(control:GetAttribute("PreviewIncome") or 0),
                    tostring(control:GetAttribute("KeepThreshold") or 0),
                    tostring(control:GetAttribute("LastDecision") or "Waiting"),
                    tostring(control:GetAttribute("LastError") or "")))
                syncModeControls()
            end)
            if not ok then
                warn("[Food Farm UI] " .. tostring(err))
            end
            task.wait(1)
        end
    end)
end

local uiOK, uiError = pcall(initializeUI)
if not uiOK then
    stop()
    control:Destroy()
    error("Miz0 menu: " .. tostring(uiError))
end
if lifecycle then
    lifecycle.onCleanup(stop)
end
persistSettings()
resumePermission(enabled and SETTINGS.AutoResume)

print("[Food Farm] Perfect throws ON. F6 pause/resume. F7 stop/unload.")
task.spawn(function()
    setthreadidentity(8)
    local trainer = module(controllers, "TrainingController")
    if trainer.IsRunning() then
        trainer.Stop()
    end
    while running do
        if enabled and (not clientState.Busy or clientState.OfflineOpen) then
            local ok, err = pcall(claimRewards)
            if not ok then control:SetAttribute("RewardNote", tostring(err)) end
        end
        if not enabled or needsRestore then
            release()
            needsRestore = false
            status(if enabled then "Resuming" else "Paused")
            task.wait(0.2)
        elseif awaitingTrainingChoice then
            release()
            status("Waiting for your training choice")
            task.wait(0.2)
        elseif not character() or not data() then
            release()
            status("Waiting for character")
            task.wait(0.5)
        elseif (clientState.Busy and clientState.Busy ~= token) or clientState.OfflineOpen then
            status("Waiting for current game action")
            task.wait(0.5)
        else
            savedCharacter = character()
            savedPosition = savedCharacter and savedCharacter:GetPivot()
            clientState.Busy = token
            local ok, err = pcall(function()
                if trainingOnly then
                    upgrade(true)
                    train()
                    return
                end
                upgrade()
                upgradeFence()
                hatchOwnedEgg()
                if active() then
                    train()
                end
                for _ = 1, SETTINGS.ThrowsPerCycle do
                    if not active() or not character() or trainingOnly or awaitingTrainingChoice then
                        break
                    end
                    hatchOwnedEgg()
                    if trainingOnly or awaitingTrainingChoice then break end
                    throwPerfect()
                end
            end)
            release()
            if ok then
                failures = 0
                if active() and not trainingOnly and not awaitingTrainingChoice then
                    control:SetAttribute("Cycles", (control:GetAttribute("Cycles") :: number) + 1)
                end
            else
                failures += 1
                control:SetAttribute("LastError", tostring(err))
                warn("[Food Farm] " .. tostring(err))
                status("Retrying: " .. tostring(err))
                if failures >= 3 then
                    enabled = false
                    control:SetAttribute("Enabled", false)
                    status("Paused after 3 errors; F6 retries")
                else
                    waitActive(2)
                end
            end
        end
    end
    release()
    control:Destroy()
    print("[Food Farm] Stopped. Character restored.")
end)


