local Players = game:GetService("Players")
local shared = game:GetService("ReplicatedStorage"):WaitForChild("OpenBack")
local Rules = require(shared:WaitForChild("MatchRules"))
local remote = Instance.new("RemoteEvent")
remote.Name = "SoloMatch"; remote.Parent = shared
local matches, limits = {}, {}
local function send(player,message)
  remote:FireClient(player,if matches[player] then Rules.snapshot(matches[player]) else nil,message)
end
remote.OnServerEvent:Connect(function(player,action,id)
  -- Fixed-window budget limits work before inspecting untrusted payloads.
  local now = os.clock()
  local budget = limits[player]
  if not budget or now-budget.start >= 1 then budget = {start=now,count=0}; limits[player] = budget end
  budget.count += 1
  if budget.count > 4 or type(action) ~= "string" then return end
  if action == "start" then
    if matches[player] and not matches[player].finished then send(player,"Finish or exit this match first"); return end
    matches[player] = Rules.new(); send(player,"Blue is yours. Click or tap neighbouring land to expand.")
  elseif action == "exit" then
    matches[player] = nil; send(player,"Returned to original unit showcase")
  elseif action == "attack" and matches[player] then
    local _,message = Rules.attack(matches[player],1,id)
    send(player,message)
  end
end)
Players.PlayerRemoving:Connect(function(player) matches[player] = nil; limits[player] = nil end)
while true do
  task.wait(1)
  for player,state in matches do
    if not state.finished then
      Rules.step(state)
      if state.tick%2 == 0 then Rules.bot(state) end
      send(player,nil)
    end
  end
end
