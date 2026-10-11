local Validate = require(game:GetService("ReplicatedStorage"):WaitForChild("OpenBack"):WaitForChild("ValidateGeometry"))
local BuildUnit = {}
function BuildUnit.create(definition, parent)
  Validate.validate({definition})
  local model = Instance.new("Model")
  model.Name = definition.label
  model:SetAttribute("UnitKind", definition.id)
  for index, spec in definition.parts do
    local part = Instance.new(if spec.shape == "wedge" then "WedgePart" else "Part")
    if spec.shape == "cylinder" then part.Shape = Enum.PartType.Cylinder end
    if spec.shape == "ball" then part.Shape = Enum.PartType.Ball end
    part.Name = "Geometry" .. index
    part.Size = Vector3.new(table.unpack(spec.size))
    part.CFrame = CFrame.new(table.unpack(spec.offset)) * CFrame.Angles(
      math.rad(spec.rotation[1]),math.rad(spec.rotation[2]),math.rad(spec.rotation[3]))
    part.Color = Color3.new(table.unpack(spec.color))
    part.Material = Enum.Material.SmoothPlastic
    part.Anchored = true
    part.CanCollide = false
    part.CanTouch = false
    part.CastShadow = true
    part.TopSurface = Enum.SurfaceType.Smooth
    part.BottomSurface = Enum.SurfaceType.Smooth
    part.Parent = model
  end
  model.WorldPivot = CFrame.identity
  model.Parent = parent
  return model
end
return BuildUnit
