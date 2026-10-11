--!strict
local CameraSettings = {}
local function finite(value: any): boolean
  return type(value) == "number" and value == value and math.abs(value) < math.huge
end
function CameraSettings.forView(mode: string, centre: {number}, distance: number)
  assert(mode == "overhead" or mode == "3d", "Unknown camera mode")
  assert(type(centre) == "table" and #centre == 3, "Invalid focus")
  for _, value in centre do assert(finite(value), "Nonfinite focus") end
  assert(finite(distance), "Nonfinite zoom")
  local bounded = math.clamp(distance, 40, 220)
  local angle = math.rad(if mode == "overhead" then 89 else 48)
  return {
    distance=bounded, focus={centre[1],centre[2],centre[3]},
    eye={centre[1],centre[2]+math.sin(angle)*bounded,centre[3]+math.cos(angle)*bounded},
  }
end
return CameraSettings
