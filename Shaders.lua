-- // Exec once for shaders, exec again to turn off
-- // Terrible code lmfaoo

local lighting = game:GetService("Lighting")
getgenv().shaders = {}
if not shared.Check then
getgenv().oldLighting = {}
getgenv().oldLightingProp = {  -- keep old game lighting or whatever
    Ambient = lighting.Ambient,
    Brightness = lighting.Brightness,
    ColorShift_Bottom = lighting.ColorShift_Bottom,
    ColorShift_Top = lighting.ColorShift_Top,
    GlobalShadows = lighting.GlobalShadows,
    OutdoorAmbient = lighting.OutdoorAmbient,
    ShadowSoftness = lighting.ShadowSoftness,
    EnvironmentDiffuseScale = lighting.EnvironmentDiffuseScale,
    EnvironmentSpecularScale = lighting.EnvironmentSpecularScale,
    ClockTime = lighting.ClockTime,
    GeographicLatitude = lighting.GeographicLatitude,
}
end
function revertshaders()
    for i,v in pairs(getgenv().oldLightingProp) do
        lighting[i] = v
    end
    for i,v in pairs(lighting:GetChildren()) do 
        if not v:IsA("BlurEffect") and v.ClassName:lower():find("effect") then 
            v.Parent = nil
        end 
    end
    
    for i,v in pairs(oldLighting) do 
        v.Parent = lighting
    end
    
    for i,v in pairs(getgenv().shaders) do 
        v.Parent = nil
    end
    
    sethiddenproperty(lighting, "Technology", getgenv().oldLighting["Technology"])
end


function doshaders()
for i,v in pairs(lighting:GetChildren()) do 
    if not v:IsA("BlurEffect") and v.ClassName:lower():find("effect") then 
        getgenv().oldLighting[v.Name] = v
        v.Parent = nil
    end 
    getgenv().oldLighting["Technology"] = gethiddenproperty(lighting, "Technology")
end
    local Bloom = lighting:FindFirstChild("EngoShaders_Bloom") or Instance.new("BloomEffect", lighting)
    local ColorCorrection = lighting:FindFirstChild("EngoShaders_ColorCorrection") or Instance.new("ColorCorrectionEffect", lighting)
    getgenv().shaders["Bloom"] = Bloom 
    getgenv().shaders["ColorCorrection"] = ColorCorrection
    lighting.Ambient = Color3.fromRGB(230, 164, 50)
    lighting.Brightness = 7
    lighting.ColorShift_Bottom = Color3.fromRGB(0,0,0)
    lighting.ColorShift_Top = Color3.fromRGB(217, 140, 32)
    lighting.GlobalShadows = true
    lighting.OutdoorAmbient = Color3.fromRGB(102, 105, 50)
    lighting.ShadowSoftness = 0
    lighting.EnvironmentDiffuseScale = 0.05
    lighting.EnvironmentSpecularScale = 0.05
    sethiddenproperty(lighting, "Technology", Enum.Technology.ShadowMap)
    lighting.ClockTime = 9
    lighting.GeographicLatitude = 80
    Bloom.Name = "EngoShaders_Bloom"
    Bloom.Intensity = 0.1 
    Bloom.Size = 46
    Bloom.Threshold = 0.8
    ColorCorrection.Name = "EngoShaders_ColorCorrection"
    ColorCorrection.TintColor = Color3.fromRGB(244, 255, 210)
    ColorCorrection.Contrast = 0.2
    ColorCorrection.Brightness = -0.05
end

if shared.ShadersExecuted then
shared.ShadersExecuted = false
revertshaders()
else
shared.ShadersExecuted = true
doshaders()
end

shared.Check = true -- keep old game lighting or whatever
