-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
display.setStatusBar(display.HiddenStatusBar)

local physics = require("physics")
physics.start()


_H = display.contentHeight;
_W = display.contentWidth;



local background = display.newRect(0,0, 480,320)
background:setFillColor(255, 255, 255)

local score = 0
local scoreLabel = display.newText(score, 0,0, native.systemFontBold, 120)

scoreLabel.x = display.viewableContentWidth/2
scoreLabel.y = display.viewableContentHeight/2
scoreLabel:setTextColor(0,0,0,10)

function createPlayer(x,y, width, height, rotation)

	local p = display.newRect(x,y, width, height)
	p:setFillColor(0,0,0)
	p.rotation = rotation

	local playerCollisonFilter = {categoryBits = 2, maskBits = 5}
	local playerBodyElement = {filter = playerCollisonFilter}

	p.isBullet = true
	p.objectType = "player"
	physics.addBody(p, "dynamic", playerBodyElement)
	physics.setGravity(0,0)

	p.isSleepingAllowed = false

	return p
end

local player = createPlayer(display.viewableContentWidth/2, display.viewableContentHeight/2, 20,20,0)

local playerRotation = function ( )
	player.rotation = player.rotation + 3
end


function onTouch(event)

	if (event.phase == "began")then
		player.isFocus = true
		player.x0 = event.x - player.x
		player.y0 = event.y - player.y
	elseif(player.isFocus) then
		if event.phase == "moved" then
			player.x = event.x - player.x0
			player.y = event.y - player.y0
			coerceOnScreen(player)
		elseif (event.phase == "ended" or event.phase == "cancelled") then
		player.isFocus = false
		end
	end
end

local function coerceOnScreen(object)
	if (object.x < object.width) then
		object.x = object.width
	end
	if (object.x > display.viewableContentWidth - object.width) then
		object.x = display.viewableContentWidth - object.width
	end
	if (object.y < object.height) then
		object.y = object.height
	end
	if(object.y > display.viewableContentHeight - object.height) then
		object.y = display.viewableContentHeight - object.height
	end
end


local function spawn(objectType, x,y)
	local object
	local sizeXY = math.random(20,100)
	local collisionFilter = {categoryBits = 4, maskBits = 2}
	local body = {filter = collisionFilter, isSensor = true}
	object = display.newRect(x,y, sizeXY, sizeXY)
	if("food" == objectType) then
		object:setFillColor(0,255,0)
	else
		object:setFillColor(0,0,255)
	end
	object.objectType = objectType
	physics.addBody(object, body)
	return object
end
local green  = spawn("food", 50,50)
local blue = spawn("enemy", 50, 200)

local function onCollision(event)
	local type1 = event.object1.objectType
	local type2 = event.object2.objectType
	print("collision between".. type1.."and"..type2)
	if(type1 == "food" or type2 == "food") then
		score = score + 1
	else
		score = score - 1
	end
	scoreLabel.text = score

end
background:addEventListener("touch", onTouch)
Runtime:addEventListener("enterFrame", playerRotation)
Runtime:addEventListener("collision", onCollision)
