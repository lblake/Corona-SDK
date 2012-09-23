H = display.contentHeight
W = display.contentWidth
display.setStatusBar(display.HiddenStatusBar)
system.activate("multitouch")
physics = require('physics')
physics.start()
physics.setGravity(0,0)
playing = false
local score1 = 0
local score2 = 0


  leftwall = display.newRect(0,0, 10, 320)
  leftwall.name = "leftwall"
  physics.addBody(leftwall, "static", {bounce=1, density=1})
  rightwall = display.newRect(470, 0, 10, 320)
  rightwall.name = "rightwall"
  physics.addBody(rightwall, "static", {bounce=1, density=1})
  floor = display.newRect(0,310, 480, 10)
  physics.addBody(floor, "static", {bounce=1, density=1})
  top = display.newRect(0,0, 480, 10)
  physics.addBody(top, "static", {bounce=1, density=1})


function onPostCollision(e)
  if (e.other.name == "leftwall") then
    score2 = score2 + 1
    score2text.text = score2
    transition.to(ball, {x = W/2, y= H/2, time=0})
    playing = false
    ball:setLinearVelocity(0,0)
  elseif (e.other.name == "rightwall") then
    score1 = score1 + 1
    score1text.text = score1
    transition.to(ball, {x = W/2, y= H/2, time=0})
    playing = false
    ball:setLinearVelocity(0,1)
  end
end


local function onCollision(e)
end
  ball = display.newCircle(250,165,10)
  ball.name = "ball"
  physics.addBody(ball, {bounce=1, density=10, radius=10})
  ball:addEventListener("postCollision", onPostCollision)
  ball:addEventListener("collision", onCollision)


function movePad(e)
  if not (e.target.name == "pad1" or e.target.name == "pad2") then
    return false
  end
  local touchObject = e.target
  if e.phase == "moved" then
    touchObject.y = e.y
  end
end


  pad1 = display.newRect(30, 115, 20, 90)
  pad1.name = "pad1"
  physics.addBody(pad1, "static", {bounce=1, density=1})
  pad1:addEventListener("touch", movePad)
  pad2 = display.newRect(430, 115, 20, 90)
  pad2.name = "pad2"
  physics.addBody(pad2, "static", {bounce=1, density=1})
  pad2:addEventListener("touch", movePad)
  score1text = display.newText("0", W/4, H/2 - 20, "Arial", 40)
  score1text:setTextColor(0,200,0)
  score2text = display.newText("0", W/4*3, H/2 - 20, "Arial", 40)
  score2text:setTextColor(0,200,0)
local pause = display.newRect(W/2, 280, 20,20)


function pause:tap(e)
  playing = not playing
  if (playing) then
    ball:applyLinearImpulse(10,10, ball.x, ball.y)
  else
  	ball:setLinearVelocity(0,0)
  	end
end
pause:addEventListener("tap", pause)