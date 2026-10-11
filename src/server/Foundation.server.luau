local Players = game:GetService("Players")
local Lighting = game:GetService("Lighting")
local shared = game:GetService("ReplicatedStorage"):WaitForChild("OpenBack")
local catalogue = require(shared:WaitForChild("UnitCatalogue"))
local validate = require(shared:WaitForChild("ValidateGeometry"))
local build = require(script.Parent:WaitForChild("BuildUnit"))
validate.validate(catalogue)
-- This is a presentation fixture, not a match. No avatars or purchases.
Players.CharacterAutoLoads = false
Lighting.ClockTime = 14
Lighting.Brightness = 2
Lighting.Ambient = Color3.fromRGB(108,126,145)
local scene = Instance.new("Folder")
scene.Name = "OpenBackFoundation"
scene:SetAttribute("PreviewOnly", true)
require(script.Parent.BuildDemoMap).create(scene)
for index, unit in catalogue do
  local column = (index-1)%5
  local row = math.floor((index-1)/5)
  local model = build.create(unit, scene)
  model:PivotTo(CFrame.new((column-2)*22,4,(row-0.5)*34))
  local anchor = model:FindFirstChildWhichIsA("BasePart")
  local label = Instance.new("BillboardGui")
  label.Name = "UnitLabel"; label.Adornee = anchor
  label.Size = UDim2.fromOffset(160,32)
  label.StudsOffsetWorldSpace = Vector3.new(0,5,0)
  label.AlwaysOnTop = true; label.MaxDistance = 350
  local text = Instance.new("TextLabel")
  text.Size = UDim2.fromScale(1,1); text.BackgroundTransparency = 1
  text.Font = Enum.Font.GothamMedium; text.TextSize = 13
  text.TextColor3 = Color3.fromRGB(235,245,249)
  text.TextStrokeTransparency = 0.35; text.Text = unit.label
  text.Parent = label; label.Parent = model
end
scene.Parent = workspace -- replicate complete scene, not an incomplete fixture
print("OpenBack Roblox foundation ready: original geometry, no match or purchases")
