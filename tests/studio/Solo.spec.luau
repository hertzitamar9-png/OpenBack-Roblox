-- Disposable Studio fixture only: actual remote, server, rendering and lifecycle.
return function()
  local shared = game:GetService("ReplicatedStorage"):WaitForChild("OpenBack")
  local remote = shared:WaitForChild("SoloMatch")
  local player = game:GetService("Players").LocalPlayer
  local gui = player:WaitForChild("PlayerGui"):WaitForChild("OpenBackFoundationUI")
  local state, latestMessage
  local connection = remote.OnClientEvent:Connect(function(snapshot,message) state = snapshot; latestMessage = message end)
  local function waitFor(check,label)
    local deadline = os.clock()+8
    repeat task.wait(0.05) until check() or os.clock() > deadline
    assert(check(),label)
  end
  task.wait(3)
  remote:FireServer("start")
  waitFor(function() return state and workspace:FindFirstChild("OpenBackSoloBoard") end,"Solo starts and renders")
  assert(#workspace.OpenBackSoloBoard:GetChildren() == 96,"One render tile per territory")
  assert(gui:GetAttribute("MatchActive") == true,"Match HUD is active")
  task.wait(1.1)
  remote:FireServer("attack",96)
  waitFor(function() return latestMessage == "Choose land beside your territory" end,"Remote capture rejected")
  assert(state.tiles[96] == 2 and state.tiles[2] == 0)
  task.wait(1.1)
  remote:FireServer("attack",{})
  waitFor(function() return latestMessage == "Invalid order" end,"Malformed remote rejected")
  task.wait(1.1)
  remote:FireServer("attack",2)
  waitFor(function() return state.tiles[2] == 1 end,"Valid adjacent capture accepted")
  assert(workspace.OpenBackSoloBoard.Territory2.Color == Color3.fromRGB(57,151,221),"Server result rendered blue")
  task.wait(1.1)
  remote:FireServer("exit")
  waitFor(function() return state == nil and workspace:FindFirstChild("OpenBackSoloBoard") == nil end,"Exit cleans the board")
  assert(gui:GetAttribute("MatchActive") == false,"Showcase HUD restored")
  task.wait(1.1)
  remote:FireServer("start")
  waitFor(function() return state and state.tiles[2] == 0 and workspace:FindFirstChild("OpenBackSoloBoard") end,"Restart resets state")
  connection:Disconnect()
  print("OPENBACK_STUDIO_SOLO_PASS")
end
