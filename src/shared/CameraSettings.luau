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
function CameraSettings.zoomForPinch(distance: number, scale: number)
  assert(finite(distance) and finite(scale) and scale > 0, "Invalid pinch")
  return math.clamp(distance / scale,40,220)
end
function CameraSettings.framing(width: number, height: number, distance: number, headerHeight: number?, footerHeight: number?)
  assert(finite(width) and finite(height) and width > 0 and height > 0, "Invalid viewport")
  assert(finite(distance), "Nonfinite zoom")
  assert(headerHeight == nil or (finite(headerHeight) and headerHeight > 0), "Invalid header")
  local reserved = math.min((headerHeight or 144) + 72, height * 0.6)
  assert(footerHeight == nil or (finite(footerHeight) and footerHeight >= 0), "Invalid footer")
  local bottom = if footerHeight then math.min(footerHeight + 24,height * 0.4) else 0
  local initialDistance = if width < height then 220 else 150
  local effectiveDistance = math.clamp(distance * initialDistance / 150,40,220)
  return {
    initialDistance = initialDistance,
    distance = effectiveDistance,
    -- Centre the scene between upper and lower safe-area controls.
    lift = (reserved-bottom) / height * effectiveDistance * math.tan(math.rad(25)),
  }
end
return CameraSettings
