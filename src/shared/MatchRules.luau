-- Newly authored server-side strategy rules. No Roblox services or client authority.
local Rules = {}
local function integer(value)
  return type(value) == "number" and value == value and value % 1 == 0 and math.abs(value) < math.huge
end
function Rules.new()
  local state = {width=12,height=8,tick=0,finished=false,winner=nil,tiles={},players={{troops=80,gold=0},{troops=80,gold=0}}}
  for y=1,state.height do
    for x=1,state.width do
      local water = (x == 6 or x == 7) and y ~= 4 and y ~= 5
      table.insert(state.tiles,if water then -1 else 0)
    end
  end
  state.tiles[1] = 1; state.tiles[#state.tiles] = 2
  return state
end
function Rules.count(state,player)
  local count = 0
  for _, owner in state.tiles do if owner == player then count += 1 end end
  return count
end
function Rules.neighbours(state,id)
  local result = {}
  local x = (id-1)%state.width+1
  if x > 1 then table.insert(result,id-1) end
  if x < state.width then table.insert(result,id+1) end
  if id > state.width then table.insert(result,id-state.width) end
  if id <= #state.tiles-state.width then table.insert(result,id+state.width) end
  return result
end
function Rules.attack(state,player,id)
  if state.finished then return false,"Match has ended" end
  if not integer(player) or (player ~= 1 and player ~= 2) or not integer(id) or id < 1 or id > #state.tiles then
    return false,"Invalid order"
  end
  local owner = state.tiles[id]
  if owner == -1 then return false,"Water requires naval units; not available yet" end
  if owner == player then return false,"Already your territory" end
  local adjacent = false
  for _, neighbour in Rules.neighbours(state,id) do
    if state.tiles[neighbour] == player then adjacent = true; break end
  end
  if not adjacent then return false,"Choose land beside your territory" end
  local cost = 8
  if owner ~= 0 then
    cost = math.max(12,math.ceil(state.players[owner].troops / math.max(1,Rules.count(state,owner)) * 0.5))
  end
  if state.players[player].troops < cost then return false,"Wait for more troops" end
  state.players[player].troops -= cost
  state.tiles[id] = player
  if owner ~= 0 then
    state.players[owner].troops = math.max(0,state.players[owner].troops-math.ceil(cost*0.5))
    if Rules.count(state,owner) == 0 then state.finished = true; state.winner = player end
  end
  return true,"Territory captured"
end
function Rules.step(state)
  if state.finished then return end
  state.tick += 1
  for player=1,2 do
    local land = Rules.count(state,player)
    if land > 0 then
      state.players[player].troops = math.min(10000,state.players[player].troops+5+land)
      state.players[player].gold = math.min(100000,state.players[player].gold+land)
    end
  end
  if state.tick >= 600 then
    local a,b = Rules.count(state,1),Rules.count(state,2)
    state.finished = true; state.winner = if a == b then 0 else if a > b then 1 else 2
  end
end
function Rules.bot(state)
  if state.finished then return end
  -- Stable ascending choices: deterministic and subject to exactly the player's rules.
  for _, desired in {0,1} do
    for id,owner in state.tiles do
      if owner == desired then
        local ok = Rules.attack(state,2,id)
        if ok then return end
      end
    end
  end
end
function Rules.snapshot(state)
  return {
    width=state.width,height=state.height,tick=state.tick,finished=state.finished,winner=state.winner,
    tiles=table.clone(state.tiles),
    players={{troops=state.players[1].troops,gold=state.players[1].gold},{troops=state.players[2].troops,gold=state.players[2].gold}},
  }
end
return Rules
