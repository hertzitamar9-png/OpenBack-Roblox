local Solo = {}
function Solo.rayForInput(camera,position,kind)
  assert(kind == "Touch" or kind == "Mouse", "Unknown pointer kind")
  -- TouchTapInWorld supplies viewport coordinates; mouse InputObject uses screen coordinates.
  return if kind == "Touch" then camera:ViewportPointToRay(position.X,position.Y) else camera:ScreenPointToRay(position.X,position.Y)
end
function Solo.mount(gui,status,toggle,header)
  local Input = game:GetService("UserInputService")
  local shared = game:GetService("ReplicatedStorage"):WaitForChild("OpenBack")
  local remote = shared:WaitForChild("SoloMatch",30)
  if not remote or not gui.Parent then return end
  local connections = {}
  local board, state
  local tiles = {}
  local colours = {[-1]=Color3.fromRGB(45,108,144),[0]=Color3.fromRGB(116,150,107),[1]=Color3.fromRGB(57,151,221),[2]=Color3.fromRGB(224,91,76)}
  local footer = Instance.new("Frame")
  footer.Name = "SoloControls"; footer.AnchorPoint = Vector2.new(0,1)
  footer.Position = UDim2.new(0,12,1,-12); footer.Size = UDim2.new(1,-24,0,116)
  footer.BackgroundColor3 = Color3.fromRGB(10,24,35); footer.BorderSizePixel = 0; footer.Parent = gui
  local corner = Instance.new("UICorner"); corner.Parent = footer
  local info = Instance.new("TextLabel")
  info.Position = UDim2.fromOffset(12,8); info.Size = UDim2.new(1,-24,0,48)
  info.BackgroundTransparency = 1; info.TextWrapped = true; info.Font = Enum.Font.Gotham
  info.TextSize = 13; info.TextColor3 = Color3.fromRGB(230,240,245)
  info.Text = "Solo conquest prototype\nConstruction, naval units and multiplayer are not available yet."; info.Parent = footer
  local function button(label,x)
    local result = Instance.new("TextButton")
    result.Size = UDim2.new(0.5,-18,0,48); result.Position = UDim2.new(x,if x == 0 then 12 else 6,0,60)
    result.Text = label; result.Font = Enum.Font.GothamBold; result.TextSize = 14
    result.BackgroundColor3 = Color3.fromRGB(100,216,204); result.TextColor3 = Color3.fromRGB(9,26,34)
    result.Parent = footer; local c = Instance.new("UICorner"); c.Parent = result
    return result
  end
  local start = button("Play solo prototype",0)
  local exit = button("Back to showcase",0.5); exit.Visible = false
  local function connect(signal,callback) table.insert(connections,signal:Connect(callback)) end
  local compact, buttonY, orderMessage = false,60,"Blue is yours. Tap neighbouring land."
  local function layout()
    compact = gui.AbsoluteSize.Y < 500; buttonY = if compact then 6 else 60
    footer.Size = UDim2.new(1,-24,0,if compact then 60 else 116)
    info.Visible = not compact
    start.Position = UDim2.fromOffset(12,buttonY); exit.Position = UDim2.new(0.5,6,0,buttonY)
    if state then toggle.Position = UDim2.fromOffset(12,buttonY) end
  end
  connect(gui:GetPropertyChangedSignal("AbsoluteSize"),layout); layout()
  local function showcase(visible)
    local scene = workspace:FindFirstChild("OpenBackFoundation")
    if not scene then return end
    for _,object in scene:GetDescendants() do
      if object:IsA("BasePart") then object.LocalTransparencyModifier = if visible then 0 else 1
      elseif object:IsA("BillboardGui") then object.Enabled = visible end
    end
  end
  local function clear()
    if board then board:Destroy(); board = nil end
    table.clear(tiles); showcase(true)
  end
  connect(remote.OnClientEvent,function(snapshot,message)
    state = snapshot
    if not state then
      toggle.Parent = header; toggle.Visible = true; gui:SetAttribute("MatchActive",false)
      clear(); start.Text = "Play solo prototype"; start.Visible = true; exit.Visible = false
      status.Text = "Roblox unit showcase — solo prototype available below.\nCreated by frootz jhklphy."
      info.Text = "Solo conquest prototype\nConstruction, naval units and multiplayer are not available yet."
      return
    end
    toggle.Parent = footer; toggle.Position = UDim2.fromOffset(12,buttonY); toggle.Size = UDim2.new(0.5,-18,0,48)
    toggle.Visible = not state.finished; gui:SetAttribute("MatchActive",true)
    if not board then
      showcase(false)
      board = Instance.new("Folder"); board.Name = "OpenBackSoloBoard"
      for id,owner in state.tiles do
        local x = (id-1)%state.width+1; local y = math.floor((id-1)/state.width)+1
        local tile = Instance.new("Part")
        tile.Name = "Territory"..id; tile:SetAttribute("TerritoryId",id)
        tile.Anchored = true; tile.Size = Vector3.new(7.9,if owner == -1 then 0.3 else 2,7.9)
        tile.Position = Vector3.new((x-0.5-state.width/2)*8,if owner == -1 then 0 else 1,(y-0.5-state.height/2)*8)
        tile.Material = if owner == -1 then Enum.Material.SmoothPlastic else Enum.Material.Grass
        tile.Parent = board; tiles[id] = tile
      end
      board.Parent = workspace
    end
    for id,owner in state.tiles do tiles[id].Color = colours[owner] end
    start.Visible = state.finished; start.Text = "Play again"; exit.Visible = true
    local a,b = state.players[1],state.players[2]
    info.Text = string.format("You: %d troops · %d gold  |  Bot: %d troops\n%d:%02d / 10:00",a.troops,a.gold,b.troops,math.floor(state.tick/60),state.tick%60)
    if state.finished then
      status.Text = (if state.winner == 1 then "Victory!" else if state.winner == 0 then "Draw." else "Defeat.").." Play again or return to the showcase."
    else
      if message then orderMessage = message end
      status.Text = if compact then string.format("You: %d troops · %d gold  |  Bot: %d troops · %d:%02d\n%s",a.troops,a.gold,b.troops,math.floor(state.tick/60),state.tick%60,orderMessage) else orderMessage.."\nSolo conquest prototype — no purchases."
    end
  end)
  connect(start.Activated,function() if state and not state.finished then return end; clear(); remote:FireServer("start") end)
  connect(exit.Activated,function() remote:FireServer("exit") end)
  local function attack(position,kind)
    if not board or not state or state.finished or not workspace.CurrentCamera then return end
    local ray = Solo.rayForInput(workspace.CurrentCamera,position,kind)
    local params = RaycastParams.new(); params.FilterType = Enum.RaycastFilterType.Include; params.FilterDescendantsInstances = {board}
    local hit = workspace:Raycast(ray.Origin,ray.Direction*1000,params)
    if hit then remote:FireServer("attack",hit.Instance:GetAttribute("TerritoryId")) end
  end
  connect(Input.InputBegan,function(input,processed)
    if not processed and input.UserInputType == Enum.UserInputType.MouseButton1 then attack(input.Position,"Mouse") end
  end)
  connect(Input.TouchTapInWorld,function(position,processed) if not processed then attack(position,"Touch") end end)
  gui.Destroying:Once(function()
    for _,connection in connections do connection:Disconnect() end
    clear(); remote:FireServer("exit")
  end)
end
return Solo
