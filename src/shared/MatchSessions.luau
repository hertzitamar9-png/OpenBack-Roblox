-- Authoritative session lifecycle; callers supply the rules and transport.
local Sessions = {}
Sessions.__index = Sessions
function Sessions.new(rules)
  return setmetatable({rules=rules,members={},waiting={},matches={},nextId=0},Sessions)
end
function Sessions:_create(ids,mode)
  self.nextId += 1
  local match = {id=self.nextId,mode=mode,ids=ids,state=self.rules.new()}
  self.matches[match.id] = match
  for seat,id in ids do self.members[id] = {match=match,seat=seat} end
  return match
end
function Sessions:isQueued(id)
  return table.find(self.waiting,id) ~= nil
end
function Sessions:cancel(id)
  local index = table.find(self.waiting,id)
  if index then table.remove(self.waiting,index) end
end
function Sessions:exit(id)
  self:cancel(id)
  local member = self.members[id]
  if not member then return end
  local match = member.match
  if match.mode == "duel" and not match.state.finished then
    match.state.finished = true
    match.state.winner = if member.seat == 1 then 2 else 1
    match.reason = "Opponent left the match"
  end
  self.members[id] = nil
  local occupied = false
  for _,other in match.ids do if self.members[other] and self.members[other].match == match then occupied = true end end
  if not occupied then self.matches[match.id] = nil end
end
function Sessions:solo(id)
  local member = self.members[id]
  if member and not member.match.state.finished then return false,"Finish or exit this match first" end
  self:exit(id)
  self:_create({id},"solo")
  return true,"Click or tap neighbouring land to expand."
end
function Sessions:queue(id)
  local member = self.members[id]
  if member and not member.match.state.finished then return false,"Finish or exit this match first" end
  if self:isQueued(id) then return false,"Already waiting for an opponent" end
  self:exit(id)
  local opponent = table.remove(self.waiting,1)
  if opponent then
    self:_create({opponent,id},"duel")
    return true,"Opponent found. Click or tap neighbouring land."
  end
  table.insert(self.waiting,id)
  return true,"Waiting for another player in this server. You can cancel."
end
function Sessions:attack(id,tile)
  local member = self.members[id]
  if not member then return false,"No active match" end
  return self.rules.attack(member.match.state,member.seat,tile)
end
function Sessions:step()
  for _,match in self.matches do
    if not match.state.finished then
      self.rules.step(match.state)
      if match.mode == "solo" and match.state.tick%2 == 0 then self.rules.bot(match.state) end
    end
  end
end
function Sessions:snapshot(id)
  local member = self.members[id]
  if not member then return nil,{queued=self:isQueued(id)} end
  local snapshot = self.rules.snapshot(member.match.state)
  snapshot.seat = member.seat; snapshot.mode = member.match.mode
  snapshot.matchId = member.match.id; snapshot.reason = member.match.reason
  return snapshot,{queued=false}
end
function Sessions:recipients(id)
  local member = self.members[id]
  local result = {}
  if member then
    for _,other in member.match.ids do
      if self.members[other] and self.members[other].match == member.match then table.insert(result,other) end
    end
  end
  return result
end
return Sessions
