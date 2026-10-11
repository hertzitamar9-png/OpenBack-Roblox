-- Client-side only: camera/controller lifecycle in the real engine.
return function()
  local player = game:GetService("Players").LocalPlayer
  assert(player, "Run camera integration on a client, not the server")
  local scripts = player:WaitForChild("PlayerScripts"):WaitForChild("OpenBack")
  local camera = workspace.CurrentCamera
  assert(camera, "Camera must be initialized")
  local prior = camera.CameraType
  local folder = workspace:WaitForChild("OpenBackFoundation")
  local count = #folder:GetDescendants()
  local controller = require(scripts.CameraController).new()
  for index=1,20 do controller:setMode(if index%2==0 then "overhead" else "3d") end
  task.wait(0.2)
  assert(#folder:GetDescendants() == count, "View switch must not recreate the scene")
  assert(camera.CameraType == Enum.CameraType.Scriptable)
  controller:destroy()
  controller:destroy() -- teardown is idempotent
  assert(camera.CameraType == prior, "Restore prior camera")
  print("OPENBACK_STUDIO_CAMERA_PASS")
end
