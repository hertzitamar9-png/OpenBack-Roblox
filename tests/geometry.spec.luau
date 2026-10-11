local ok, catalogue = pcall(require, "../src/shared/UnitCatalogue")
assert(ok, "UnitCatalogue must exist before geometry can be validated")
local valid, validator = pcall(require, "../src/shared/ValidateGeometry")
assert(valid, "ValidateGeometry must exist")
validator.validate(catalogue)
local required = {"transport", "trade-ship", "warship", "tank", "plane", "sam-launcher", "sam-missile", "silo", "military-base", "projectile"}
local byId = {}
local signatures = {}
for _, unit in catalogue do
  byId[unit.id] = unit
  local signature = ""
  for _, part in unit.parts do
    signature ..= part.shape .. table.concat(part.size, ",") .. table.concat(part.offset, ",")
  end
  assert(not signatures[signature], "Unit silhouettes must differ: " .. unit.id)
  signatures[signature] = true
end
for _, id in required do assert(byId[id], "Missing unit family: " .. id) end
local function unit()
  return {id="fixture", label="Fixture", parts={{shape="block", size={2,1,4}, offset={0,0,0}, rotation={0,0,0}, color={0.3,0.5,0.7}}}}
end
local function rejected(data)
  assert(not pcall(validator.validate, data), "Invalid geometry must be rejected")
end
local a = unit(); a.parts[1].size[1] = 0; rejected({a})
a = unit(); a.parts[1].size[2] = -1; rejected({a})
a = unit(); a.parts[1].offset[1] = 0/0; rejected({a})
a = unit(); a.parts[1].rotation[1] = math.huge; rejected({a})
a = unit(); a.parts[1].color[1] = 2; rejected({a})
a = unit(); a.parts[1].shape = "mesh"; rejected({a})
a = unit(); a.parts = {}; rejected({a})
a = unit(); a.label = ""; rejected({a})
a = unit(); a.parts[1].size = {2,1}; rejected({a})
rejected({unit(), unit()})
rejected({})
print("Geometry: unit families, distinct silhouettes and malformed numeric data PASS")
