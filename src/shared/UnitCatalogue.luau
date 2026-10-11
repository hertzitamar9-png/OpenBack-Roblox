-- Original primitive designs for Roblox, forward = -Z. Not traced/imported meshes.
local navy = {0.12,0.22,0.31}
local steel = {0.48,0.61,0.67}
local jade = {0.22,0.47,0.34}
local gold = {0.96,0.66,0.22}
local pale = {0.82,0.90,0.93}
local red = {0.94,0.29,0.20}
local function p(shape, size, offset, color, rotation)
  return {shape=shape, size=size, offset=offset, color=color, rotation=rotation or {0,0,0}}
end
return {
  {id="transport", label="Conquest transport", parts={
    p("block",{5,1.2,11},{0,0,0},navy), p("wedge",{5,1.2,3},{0,0,-7},steel),
    p("block",{4,0.4,6},{0,0.9,-1},jade), p("block",{3,2,2},{0,1.5,3},pale),
    p("block",{0.25,2,0.25},{0,3,3},gold), p("block",{0.3,0.8,5},{-2.1,1.2,-1},steel),
    p("block",{0.3,0.8,5},{2.1,1.2,-1},steel),
  }},
  {id="trade-ship", label="Trade ship", parts={
    p("block",{5.5,1.8,12},{0,0,0},navy), p("wedge",{5.5,1.8,2},{0,0,-7},steel),
    p("block",{2,1.4,3},{-1.3,1.6,-2},gold), p("block",{2,1.4,3},{1.3,1.6,-2},red),
    p("block",{4.5,1.4,2},{0,1.6,1},jade), p("block",{3.5,2.2,2},{0,1.8,4},pale),
    p("cylinder",{2,0.8,0.8},{0,3.5,4},steel,{0,0,90}),
  }},
  {id="warship", label="Warship", parts={
    p("block",{3.8,1.2,14},{0,0,0},steel), p("wedge",{3.8,1.2,3},{0,0,-8.5},navy),
    p("block",{2,1.8,4},{0,1.4,1},navy), p("cylinder",{0.6,2,2},{0,1.1,-3.5},jade,{0,0,90}),
    p("cylinder",{3.5,0.25,0.25},{0,1.8,-5},pale,{0,90,0}),
    p("block",{0.25,4,0.25},{0,4,2},gold), p("block",{2,0.2,0.3},{0,5,2},gold),
  }},
  {id="tank", label="Tank", parts={
    p("block",{4,1,6},{0,0.5,0},jade), p("block",{0.8,1.3,6.5},{-2.2,0.2,0},navy),
    p("block",{0.8,1.3,6.5},{2.2,0.2,0},navy), p("block",{2.8,1.1,2.5},{0,1.6,-0.3},jade),
    p("cylinder",{4,0.35,0.35},{0,1.7,-2.8},steel,{0,90,0}),
    p("ball",{0.35,0.35,0.35},{-1.4,1.1,-2.7},gold),
  }},
  {id="plane", label="Strike aircraft", parts={
    p("wedge",{1.4,1.2,7},{0,0,0},pale), p("wedge",{4,0.25,3},{-2.3,-0.1,0.5},navy,{0,180,0}),
    p("wedge",{4,0.25,3},{2.3,-0.1,0.5},navy,{0,180,0}),
    p("wedge",{0.3,1.6,2},{0,0.8,2.5},jade), p("ball",{0.7,0.5,1.5},{0,0.7,-1.4},gold),
  }},
  {id="sam-launcher", label="SAM launcher", parts={
    p("block",{4.5,0.8,5},{0,0,0},navy), p("cylinder",{1,2,2},{0,1,0},jade,{0,0,90}),
    p("block",{3.5,0.5,4},{0,2.1,0},jade,{25,0,0}),
    p("cylinder",{3.5,0.6,0.6},{-1,2.7,-0.5},pale,{65,90,0}),
    p("cylinder",{3.5,0.6,0.6},{0,2.7,-0.5},pale,{65,90,0}),
    p("cylinder",{3.5,0.6,0.6},{1,2.7,-0.5},pale,{65,90,0}),
  }},
  {id="sam-missile", label="Interceptor", parts={
    p("cylinder",{4,0.55,0.55},{0,0,0},pale,{0,90,0}), p("wedge",{0.5,0.5,1},{0,0,-2.4},red),
    p("block",{1.5,0.12,0.8},{0,0,1.6},jade), p("block",{0.12,1.5,0.8},{0,0,1.6},jade),
  }},
  {id="silo", label="Missile silo", parts={
    p("block",{7,0.6,7},{0,0,0},steel), p("cylinder",{0.5,5,5},{0,0.5,0},navy,{0,0,90}),
    p("block",{3.5,0.25,5},{-2,0.9,0},jade,{0,0,-30}),
    p("cylinder",{4,1,1},{0,2,0},pale,{0,0,90}), p("wedge",{1,1.3,1},{0,4.4,0},red),
  }},
  {id="military-base", label="Military base", parts={
    p("block",{9,0.4,8},{0,0,0},steel), p("block",{5,2.6,4},{-1,1.5,0},jade),
    p("wedge",{5,1.2,4},{-1,3.3,0},navy), p("block",{2,4,2},{3,2,2},navy),
    p("ball",{2,0.5,2},{3,4.3,2},gold), p("block",{0.2,2.5,0.2},{-3,3,-2.5},steel),
  }},
  {id="projectile", label="Strike rocket", parts={
    p("cylinder",{3,0.9,0.9},{0,0,0},gold,{0,90,0}), p("wedge",{0.9,0.9,1.2},{0,0,-1.9},navy),
    p("block",{1.8,0.18,1},{0,0,1},red), p("block",{0.18,1.8,1},{0,0,1},red),
  }},
}
