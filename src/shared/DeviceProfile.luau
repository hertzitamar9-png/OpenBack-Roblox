--!strict
local DeviceProfile = {}
function DeviceProfile.forInput(preferred: string, width: number, height: number?)
  assert(width == width and width > 0 and width < math.huge, "Invalid viewport width")
  local mobile = preferred == "Touch"
  local compact = width < 520
  local short = height ~= nil and height < 500
  return {
    mobile = mobile, compact = compact,
    headerHeight = if short and not compact then 128 else if compact then 202 else if mobile then 152 else 144,
    buttonHeight = if mobile then 48 else 40,
    statusHeight = if short and not compact then 30 else if compact then 60 else 46,
    buttonY = if short and not compact then 72 else if compact then 108 else 92,
    hintY = if short and not compact then 72 else if compact then 166 else 90,
    hintHeight = if compact then 28 else 44,
    hint = if mobile then "Orbit: two-finger drag\nZoom: pinch" else if preferred == "Gamepad" then "Controller controls are not available in this preview" else "Orbit: right-drag\nZoom: mouse wheel",
  }
end
return DeviceProfile
