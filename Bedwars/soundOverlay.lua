repeat wait() until game:IsLoaded()
if game.GameId ~= 2619619496 then
    return
end
local bedwars = {
	["Sound"] = require(game:GetService("ReplicatedStorage").TS.sound["game-sound"]),
	["GameSound"] = require(game:GetService("ReplicatedStorage").TS.sound["game-sound"]).GameSound,
	["Assets"] = game:GetService("ReplicatedStorage"):WaitForChild("Assets"),
}
local lplr = game.Players.LocalPlayer
local requestfunc = syn and syn.request or http and http.request or http_request or fluxus and fluxus.request or getgenv().request or request
local queueteleport = syn and syn.queue_on_teleport or queue_on_teleport or fluxus and fluxus.queue_on_teleport
local getasset = getsynasset or getcustomasset
queueteleport("repeat wait() until game:IsLoaded() loadstring(game:HttpGet('https://raw.githubusercontent.com/joeengo/exploiting/main/Bedwars/soundOverlay.lua'))()")

local function assetfunc(path)
	if not isfile(path) then
		spawn(function()
            local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
			local textlabel = Instance.new("TextLabel")
			textlabel.Size = UDim2.new(1, 0, 0, 36)
			textlabel.Text = "Downloading "..path
			textlabel.BackgroundTransparency = 1
			textlabel.TextStrokeTransparency = 0
			textlabel.TextSize = 30
			textlabel.Font = Enum.Font.GothamSemibold
			textlabel.TextColor3 = Color3.fromRGB(200, 200, 200)
			textlabel.Position = UDim2.new(0, 0, 0, -36)
			textlabel.Parent = gui
			repeat wait() until isfile(path)
			gui:Remove()
		end)
		local req = requestfunc({
			Url = "https://raw.githubusercontent.com/joeengo/exploiting/main/Bedwars/"..path:gsub("bedwars/assets", "assets"),
			Method = "GET"
		})
		writefile(path, req.Body)
	end
	return getasset(path) 
end

local function filefunc(path)
	if not isfile(path) then
		spawn(function()
            local gui = Instance.new("ScreenGui", game:GetService("CoreGui"))
			local textlabel = Instance.new("TextLabel")
			textlabel.Size = UDim2.new(1, 0, 0, 36)
			textlabel.Text = "Downloading "..path
			textlabel.BackgroundTransparency = 1
			textlabel.TextStrokeTransparency = 0
			textlabel.TextSize = 30
			textlabel.Font = Enum.Font.GothamSemibold
			textlabel.TextColor3 = Color3.fromRGB(200, 200, 200)
			textlabel.Position = UDim2.new(0, 0, 0, -36)
			textlabel.Parent = gui
			repeat wait() until isfile(path)
			gui:Remove()
		end)
		local req = requestfunc({
			Url = "https://raw.githubusercontent.com/joeengo/exploiting/main/Bedwars/"..path:gsub("bedwars/assets", "assets"),
			Method = "GET"
		})
		writefile(path, req.Body)
	end
	return readfile(path)
end

local function isasset(path)
    if isfile(path) then
        return true
    else
		local req = requestfunc({
			Url = "https://raw.githubusercontent.com/joeengo/exploiting/main/Bedwars/"..path:gsub("bedwars/assets", "assets"),
			Method = "GET"
		})
		if req.StatusCode == 200 then 
            return true
        end
	end
    return false
end

function muteOld()
	for i,v in pairs(game.Workspace:children()) do
		if v.Name == lplr.Name then 
			local x=v.HumanoidRootPart
			for i2,v2 in pairs(x:children()) do
				if v2:IsA("Sound") then 
					v2.Volume = 0
				end
			end
		end
	end
end
muteOld()


function getsounds()
    for i,v in pairs(bedwars["GameSound"]) do 
		spawn(function()
			if isasset("bedwars/assets/"..i..".mp3") then 
				local _asset = assetfunc("bedwars/assets/"..i..".mp3")
				bedwars["GameSound"][i] = _asset
			elseif isasset("bedwars/assets/"..i..".rbxassetid") then
				local _asset = filefunc("bedwars/assets/"..i..".rbxassetid")
				bedwars["GameSound"][i] = _asset
			end
		end)
    end
end

getsounds()
--
