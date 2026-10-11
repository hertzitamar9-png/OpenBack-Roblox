local Solo = require("../src/client/SoloMatchClient")
local camera = {
  ViewportPointToRay=function(_self,x,y) return {kind="viewport",x=x,y=y} end,
  ScreenPointToRay=function(_self,x,y) return {kind="screen",x=x,y=y} end,
}
local touch = Solo.rayForInput(camera,{X=305,Y=177},"Touch")
local mouse = Solo.rayForInput(camera,{X=305,Y=177},"Mouse")
assert(touch.kind == "viewport" and touch.x == 305 and touch.y == 177)
assert(mouse.kind == "screen" and mouse.x == 305 and mouse.y == 177)
assert(not pcall(Solo.rayForInput,camera,{X=0,Y=0},"unknown"))
print("POINTER_COORDINATES_PASS")
