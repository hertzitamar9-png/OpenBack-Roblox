--!strict
-- Newly authored validation; no inherited OpenBack implementation.
local ValidateGeometry = {}
local shapes = {block=true, wedge=true, cylinder=true, ball=true}
local function finite(value: any): boolean
  return type(value) == "number" and value == value and math.abs(value) < math.huge
end
local function triple(value: any, kind: string)
  assert(type(value) == "table" and #value == 3, "Expected triple: " .. kind)
  for _, number in value do
    assert(finite(number), "Nonfinite " .. kind)
    if kind == "size" then assert(number > 0 and number <= 256, "Invalid size") end
    if kind == "color" then assert(number >= 0 and number <= 1, "Invalid color") end
    assert(math.abs(number) <= 512, "Geometry exceeds fixture bounds")
  end
end
function ValidateGeometry.validate(catalogue: any)
  assert(type(catalogue) == "table" and #catalogue > 0 and #catalogue <= 64, "Empty or excessive catalogue")
  local ids = {}
  for _, unit in catalogue do
    assert(type(unit) == "table", "Invalid unit")
    assert(type(unit.id) == "string" and unit.id:match("^[a-z][a-z0-9%-]*$"), "Invalid id")
    assert(not ids[unit.id], "Duplicate id")
    ids[unit.id] = true
    assert(type(unit.label) == "string" and #unit.label > 0 and #unit.label <= 64, "Invalid label")
    assert(type(unit.parts) == "table" and #unit.parts > 0 and #unit.parts <= 64, "Invalid parts")
    for _, part in unit.parts do
      assert(type(part) == "table" and shapes[part.shape], "Unknown shape")
      triple(part.size, "size"); triple(part.offset, "offset")
      triple(part.rotation, "rotation"); triple(part.color, "color")
    end
  end
end
return ValidateGeometry
