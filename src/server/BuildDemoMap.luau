-- New deterministic demonstration islands; no imported map data or coastlines.
local BuildDemoMap = {}
function BuildDemoMap.create(parent)
  local model = Instance.new("Model")
  model.Name = "Original island table"
  model:SetAttribute("Origin", "newly-authored")
  local function tile(name, size, position, color, material)
    local part = Instance.new("Part")
    part.Name = name; part.Size = size; part.Position = position
    part.Color = color; part.Material = material
    part.Anchored = true; part.CanCollide = false; part.CanTouch = false
    part.TopSurface = Enum.SurfaceType.Smooth
    part.BottomSurface = Enum.SurfaceType.Smooth
    part.Parent = model
  end
  tile("Sea",Vector3.new(126,1,84),Vector3.new(0,-2,0),Color3.fromRGB(17,55,76),Enum.Material.SmoothPlastic)
  for x=-10,10 do
    for z=-6,6 do
      local island = math.sin(x*0.47)+math.cos(z*0.67)+0.4*math.sin((x+z)*0.71)
      if island > 0.55 then
        local height = 0.5+math.max(island-1,0)*1.2
        tile("Island",Vector3.new(5.8,height,5.8),Vector3.new(x*5.8,-1.4+height/2,z*5.8),
          if island>1.7 then Color3.fromRGB(80,139,100) else Color3.fromRGB(56,112,89),Enum.Material.SmoothPlastic)
      end
    end
  end
  model.Parent = parent
  return model
end
return BuildDemoMap
