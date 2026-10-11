local RunService = game:GetService("RunService")
local Input = game:GetService("UserInputService")
local settings = require(game:GetService("ReplicatedStorage"):WaitForChild("OpenBack"):WaitForChild("CameraSettings"))
local profiles = require(game:GetService("ReplicatedStorage"):WaitForChild("OpenBack"):WaitForChild("DeviceProfile"))
local CameraController = {}
CameraController.__index = CameraController
function CameraController.new()
  local self = setmetatable({mode="3d", distance=150, yaw=0, connections={}, touches={}, destroyed=false}, CameraController)
  self.camera = workspace.CurrentCamera
  self.ui = game:GetService("Players").LocalPlayer:WaitForChild("PlayerGui"):FindFirstChild("OpenBackFoundationUI")
  assert(self.camera, "Wait for CurrentCamera before creating controller")
  self.previous = {kind=self.camera.CameraType, frame=self.camera.CFrame, focus=self.camera.Focus, fov=self.camera.FieldOfView}
  self.camera.CameraType = Enum.CameraType.Scriptable
  self.camera.FieldOfView = 50
  local function connect(signal, callback) table.insert(self.connections, signal:Connect(callback)) end
  connect(Input.InputBegan,function(input, processed)
    if not processed and input.UserInputType == Enum.UserInputType.MouseButton2 then self.dragging = true end
  end)
  connect(Input.InputEnded,function(input)
    if input.UserInputType == Enum.UserInputType.MouseButton2 then self.dragging = false end
  end)
  connect(Input.WindowFocusReleased,function()
    self.dragging = false; table.clear(self.touches); self.touchCentre = nil; self.pinchStart = nil
  end)
  connect(Input.InputChanged,function(input, processed)
    if processed then return end
    if input.UserInputType == Enum.UserInputType.MouseWheel then
      self.distance = math.clamp(self.distance-input.Position.Z*10,40,220)
    elseif self.dragging and input.UserInputType == Enum.UserInputType.MouseMovement then
      self.yaw -= input.Delta.X*0.008
    end
  end)
  local function touchCentre()
    local total = Vector2.zero; local count = 0
    for _, point in self.touches do total += point; count += 1 end
    return if count == 2 then total/2 else nil
  end
  connect(Input.TouchStarted,function(input, processed)
    if not processed then
      self.touches[input] = Vector2.new(input.Position.X,input.Position.Y)
      self.touchCentre = touchCentre()
    end
  end)
  connect(Input.TouchMoved,function(input)
    if not self.touches[input] then return end
    self.touches[input] = Vector2.new(input.Position.X,input.Position.Y)
    local centre = touchCentre()
    if centre and self.touchCentre then self.yaw -= (centre.X-self.touchCentre.X)*0.012 end
    self.touchCentre = centre
  end)
  connect(Input.TouchEnded,function(input)
    self.touches[input] = nil; self.touchCentre = touchCentre()
  end)
  connect(Input.TouchPinch,function(positions, scale, _velocity, state, processed)
    if processed or #positions ~= 2 then self.pinchStart = nil; return end
    if state == Enum.UserInputState.Begin then
      self.pinchStart = self.distance
    elseif state == Enum.UserInputState.Change and self.pinchStart and scale > 0 and scale < math.huge then
      self.distance = settings.zoomForPinch(self.pinchStart,scale)
    elseif state == Enum.UserInputState.End or state == Enum.UserInputState.Cancel then
      self.pinchStart = nil
    end
  end)
  connect(RunService.RenderStepped,function(delta)
    if workspace.CurrentCamera ~= self.camera then self:destroy(); return end
    local size = self.camera.ViewportSize
    local profile = profiles.forInput(Input.PreferredInput.Name,math.max(1,size.X - 24),if self.ui then self.ui.AbsoluteSize.Y else size.Y)
    local playing = self.ui and self.ui:GetAttribute("MatchActive") == true
    local footer = self.ui and self.ui:FindFirstChild("SoloControls")
    local framing = settings.framing(math.max(1,size.X),math.max(1,size.Y),self.distance,if playing then 70 else profile.headerHeight,if footer then footer.AbsoluteSize.Y else nil)
    local view = settings.forView(self.mode,{0,2,0},framing.distance)
    local eye = Vector3.new(table.unpack(view.eye))
    local focus = Vector3.new(table.unpack(view.focus))
    eye = focus + CFrame.Angles(0,self.yaw,0):VectorToWorldSpace(eye-focus)
    local target = CFrame.lookAt(eye,focus) * CFrame.new(0,framing.lift,0)
    self.camera.CFrame = self.camera.CFrame:Lerp(target,1-math.exp(-12*delta))
    self.camera.Focus = CFrame.new(focus)
  end)
  return self
end
function CameraController:setMode(mode)
  assert(not self.destroyed, "Controller destroyed")
  settings.forView(mode,{0,2,0},self.distance)
  self.mode = mode
end
function CameraController:destroy()
  if self.destroyed then return end
  self.destroyed = true
  for _, connection in self.connections do connection:Disconnect() end
  table.clear(self.connections); table.clear(self.touches)
  if self.camera.Parent and workspace.CurrentCamera == self.camera then
    self.camera.CameraType = self.previous.kind
    self.camera.CFrame = self.previous.frame; self.camera.Focus = self.previous.focus
    self.camera.FieldOfView = self.previous.fov
  end
end
return CameraController
