local Players = game:GetService("Players")
local shared = game:GetService("ReplicatedStorage"):WaitForChild("OpenBack")
local Rules = require(shared:WaitForChild("MatchRules"))
local Sessions = require(shared:WaitForChild("MatchSessions"))
local sessions = Sessions.new(Rules)
local remote = Instance.new("RemoteEvent")
remote.Name = "SoloMatch"; remote.Parent = shared
local limits = {}
local function send(player,message)
  local snapshot,meta = sessions:snapshot(player.UserId)
  remote:FireClient(player,snapshot,message,meta)
end
local function broadcast(excluded)
  for _,player in Players:GetPlayers() do
    if player ~= excluded and (sessions.members[player.UserId] or sessions:isQueued(player.UserId)) then send(player,nil) end
  end
end
local function notify(ids,excluded)
  for _,id in ids do
    local player = Players:GetPlayerByUserId(id)
    if player and player ~= excluded then send(player,nil) end
  end
end
remote.OnServerEvent:Connect(function(player,action,id)
  -- Fixed-window budget limits work before inspecting untrusted payloads.
  local now = os.clock()
  local budget = limits[player]
  if not budget or now-budget.start >= 1 then budget = {start=now,count=0}; limits[player] = budget end
  budget.count += 1
  if budget.count > 4 or type(action) ~= "string" then return end
  if action == "start" or action == "queue" then
    local ok,message
    if action == "start" then ok,message = sessions:solo(player.UserId)
    else ok,message = sessions:queue(player.UserId) end
    send(player,message)
    if ok then notify(sessions:recipients(player.UserId),player) end
  elseif action == "exit" then
    local affected = sessions:recipients(player.UserId)
    sessions:exit(player.UserId); send(player,"Returned to original unit showcase"); notify(affected,player)
  elseif action == "attack" then
    local ok,message = sessions:attack(player.UserId,id)
    send(player,message)
    if ok then notify(sessions:recipients(player.UserId),player) end
  end
end)
Players.PlayerRemoving:Connect(function(player)
  local affected = sessions:recipients(player.UserId)
  sessions:exit(player.UserId); limits[player] = nil; notify(affected,player)
end)
while true do
  task.wait(1)
  sessions:step(); broadcast()
end
