local Rules = require("../src/shared/MatchRules")
local state = Rules.new()
assert(#state.tiles == 96 and Rules.count(state,1) == 1 and Rules.count(state,2) == 1)
local initial = state.players[1].troops
for _, invalid in {0,97,-1,0/0,math.huge,1.5,"2",{}} do
  assert(not Rules.attack(state,1,invalid))
end
assert(not Rules.attack(state,0,2))
assert(not Rules.attack(state,1,96)) -- no remote capture
assert(not Rules.attack(state,1,1)) -- no self capture
assert(not Rules.attack(state,1,6)) -- water
assert(state.players[1].troops == initial)
assert(Rules.attack(state,1,2))
assert(state.players[1].troops == initial-8 and Rules.count(state,1) == 2)
state.players[1].troops = 0
assert(not Rules.attack(state,1,3))
Rules.step(state)
assert(state.players[1].troops == 7 and state.players[1].gold == 2)
local snapshot = Rules.snapshot(state)
snapshot.tiles[1] = 2; snapshot.players[1].troops = 999999
assert(state.tiles[1] == 1 and state.players[1].troops == 7)
local a,b = Rules.new(),Rules.new()
for _=1,600 do
  Rules.step(a); Rules.step(b)
  if a.tick%2 == 0 then Rules.bot(a); Rules.bot(b) end
  for id,owner in a.tiles do assert(owner == b.tiles[id] and owner >= -1 and owner <= 2) end
  for player=1,2 do assert(a.players[player].troops >= 0 and a.players[player].troops <= 10000) end
end
assert(a.finished and a.winner == 2,"Bot completes a match without privileged capture")
local tick = a.tick; local troops = a.players[1].troops
Rules.step(a); assert(not Rules.attack(a,1,2))
assert(a.tick == tick and a.players[1].troops == troops)
local victory = Rules.new()
for id,owner in victory.tiles do if owner >= 0 then victory.tiles[id] = 1 end end
victory.tiles[2] = 2; victory.players[1].troops = 500
assert(Rules.attack(victory,1,2) and victory.finished and victory.winner == 1)
print("MATCH_RULES_PASS")
