-- Client-side only: camera/controller lifecycle in the real engine.
return function()
  local player = game:GetService("Players").LocalPlayer
  assert(player, "Run camera integration on a client, not the server")
  local scripts = player:WaitForChild("PlayerScripts"):WaitForChild("OpenBack")
  local camera = workspace.CurrentCamera
  assert(camera, "Camera must be initialized")
  -- Dispose the production controller before testing, rather than competing with it.
  local gui = player:WaitForChild("PlayerGui"):WaitForChild("OpenBackFoundationUI")
  gui:Destroy()
  task.wait()
  camera.CameraType = Enum.CameraType.Custom
  local prior = {kind=camera.CameraType, frame=camera.CFrame, focus=camera.Focus, fov=camera.FieldOfView}
  local folder = workspace:WaitForChild("OpenBackFoundation")
  local count = #folder:GetDescendants()
  local controller = require(scripts.CameraController).new()
  for index=1,20 do
    local mode = if index%2==0 then "overhead" else "3d"
    controller:setMode(mode)
    task.wait(0.7)
    local direction = camera.CFrame.LookVector
    if mode == "overhead" then assert(direction.Y < -0.98, "Overhead pose rendered")
    else assert(direction.Y > -0.8 and direction.Y < -0.6, "Angled pose rendered") end
  end
  assert(#folder:GetDescendants() == count, "View switch must not recreate the scene")
  assert(camera.CameraType == Enum.CameraType.Scriptable)
  local connections = table.clone(controller.connections)
  controller:destroy()
  controller:destroy() -- teardown is idempotent
  assert(camera.CameraType == prior.kind, "Restore prior camera type")
  assert(camera.CFrame == prior.frame and camera.Focus == prior.focus, "Restore camera pose")
  assert(camera.FieldOfView == prior.fov, "Restore field of view")
  for _, connection in connections do assert(not connection.Connected, "Input/render handlers disconnected") end
  print("OPENBACK_STUDIO_CAMERA_PASS")
end
