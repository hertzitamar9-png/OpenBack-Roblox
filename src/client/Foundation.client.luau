local Players = game:GetService("Players")
local player = Players.LocalPlayer
if not player then return end
local gui = Instance.new("ScreenGui")
gui.Name = "OpenBackFoundationUI"; gui.ResetOnSpawn = false
gui.ScreenInsets = Enum.ScreenInsets.CoreUISafeInsets
gui.ClipToDeviceSafeArea = true
gui.Parent = player:WaitForChild("PlayerGui")
local frame = Instance.new("Frame")
frame.Name = "PreviewHeader"; frame.Size = UDim2.new(1,-24,0,144)
frame.Position = UDim2.fromOffset(12,12)
frame.BackgroundColor3 = Color3.fromRGB(10,24,35)
frame.BackgroundTransparency = 0.12; frame.BorderSizePixel = 0
frame.Parent = gui
local corner = Instance.new("UICorner"); corner.CornerRadius = UDim.new(0,12); corner.Parent = frame
local title = Instance.new("TextLabel")
title.Position = UDim2.fromOffset(12,8); title.Size = UDim2.new(1,-24,0,26)
title.BackgroundTransparency = 1; title.Font = Enum.Font.GothamBold
title.TextSize = 20; title.TextColor3 = Color3.fromRGB(105,227,219)
title.Text = "OB  |  OPENBACK"; title.TextXAlignment = Enum.TextXAlignment.Left; title.Parent = frame
local status = Instance.new("TextLabel")
status.Position = UDim2.fromOffset(12,38); status.Size = UDim2.new(1,-24,0,46)
status.BackgroundTransparency = 1; status.TextWrapped = true
status.Font = Enum.Font.Gotham; status.TextSize = 13
status.TextColor3 = Color3.fromRGB(220,233,240)
status.TextXAlignment = Enum.TextXAlignment.Left
status.Text = "Roblox foundation preview — loading original unit showcase.\nNot a playable match. Created by frootz jhklphy."
status.Parent = frame
local toggle = Instance.new("TextButton")
toggle.Position = UDim2.fromOffset(12,92); toggle.Size = UDim2.new(0.5,-18,0,40)
toggle.Text = "Loading..."; toggle.Font = Enum.Font.GothamBold; toggle.TextSize = 14
toggle.TextColor3 = Color3.fromRGB(9,26,34); toggle.BackgroundColor3 = Color3.fromRGB(100,216,204)
toggle.Active = false; toggle.AutoButtonColor = false; toggle.Parent = frame
local buttonCorner = Instance.new("UICorner"); buttonCorner.Parent = toggle
local hint = Instance.new("TextLabel")
hint.Position = UDim2.new(0.5,4,0,90); hint.Size = UDim2.new(0.5,-16,0,44)
hint.BackgroundTransparency = 1; hint.TextWrapped = true; hint.Font = Enum.Font.Gotham
hint.TextSize = 12; hint.TextColor3 = Color3.fromRGB(189,210,219)
hint.Text = "Orbit: right-drag / two fingers\nZoom: mouse wheel"; hint.Parent = frame
-- Dependencies can replicate later than the LocalScript. Keep status visible while waiting.
local scene = workspace:WaitForChild("OpenBackFoundation",30)
if not scene then
  status.Text = "Preview scene did not initialize. Check Studio Output. No match or purchases are running."
  toggle.Text = "Unavailable"
  return
end
while not workspace.CurrentCamera and gui.Parent do task.wait() end
if not gui.Parent then return end
local CameraController = require(script.Parent:WaitForChild("CameraController"))
local controller = CameraController.new()
status.Text = "Roblox foundation preview — original unit showcase.\nNot a playable match. Created by frootz jhklphy."
toggle.Text = "Switch to 2D view"; toggle.Active = true; toggle.AutoButtonColor = true
local mode = "3d"
local cameraChanged = workspace:GetPropertyChangedSignal("CurrentCamera"):Connect(function()
  controller:destroy()
  if workspace.CurrentCamera then
    controller = CameraController.new()
    controller:setMode(mode)
    toggle.Active = true; toggle.AutoButtonColor = true
    toggle.Text = if mode == "3d" then "Switch to 2D view" else "Switch to 3D view"
  else
    toggle.Active = false; toggle.AutoButtonColor = false; toggle.Text = "Waiting for camera..."
  end
end)
local activated = toggle.Activated:Connect(function()
  if controller.destroyed then return end
  mode = if mode == "3d" then "overhead" else "3d"
  controller:setMode(mode)
  toggle.Text = if mode == "3d" then "Switch to 2D view" else "Switch to 3D view"
end)
local cleanup
cleanup = gui.Destroying:Connect(function()
  activated:Disconnect(); cameraChanged:Disconnect(); controller:destroy(); cleanup:Disconnect()
end)
