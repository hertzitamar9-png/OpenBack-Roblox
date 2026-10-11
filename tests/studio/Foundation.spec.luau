-- Engine integration test. Run only in a disposable Studio verification place.
return function()
  local shared = game:GetService("ReplicatedStorage"):WaitForChild("OpenBack")
  local server = game:GetService("ServerScriptService"):WaitForChild("OpenBack")
  local units = require(shared.UnitCatalogue)
  local build = require(server.BuildUnit)
  local folder = Instance.new("Folder")
  folder.Name = "VerificationOnly"
  folder.Parent = workspace
  local ok, reason = pcall(function()
    for _, unit in units do
      local model = build.create(unit, folder)
      assert(model:GetAttribute("UnitKind") == unit.id)
      assert(#model:GetChildren() == #unit.parts)
      for _, part in model:GetChildren() do
        assert(part:IsA("BasePart") and not part:IsA("MeshPart"))
        assert(part.Anchored and not part.CanCollide)
      end
      local forward = model:GetPivot().LookVector
      assert(forward:Dot(Vector3.new(0,0,-1)) > 0.99)
    end
    assert(not pcall(build.create, {id="bad",label="Bad",parts={}}, folder))
    local map = require(server.BuildDemoMap).create(folder)
    assert(map:GetAttribute("Origin") == "newly-authored")
    assert(#map:GetDescendants() > 20)
  end)
  folder:Destroy()
  assert(ok, reason)
  print("OPENBACK_STUDIO_GEOMETRY_PASS")
end
