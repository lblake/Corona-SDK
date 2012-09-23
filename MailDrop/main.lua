
-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------

display.setStatusBar(display.HiddenStatusBar)

require("physics")
physics.start()
--physics.setDrawMode("hybrid")
physics.setGravity(0, 0)

local gameLayer = display.newGroup()
local islandLayer = display.newGroup()
local cloudLayer = display.newGroup()
local halfPlayerWidth


local textureCache = {}
textureCache[1] = display.newImage("images/island.gif"); textureCache[1].isVisible = false;
textureCache[2] = display.newImage("images/cloud.gif");  textureCache[2].isVisible = false;

local halfEnemyWidth = textureCache[1].contentWidth * .5


local sounds = {

engine = audio.loadStream("media/airplane.mp3" ),
thunder = audio.loadSound("media/fail.caf"),
yay = audio.loadSound("media/win.caf")
}
-- Adjust the volume
audio.setMaxVolume( 0.95, { channel=1 } )



local island = display.newImage(islandLayer, "images/island.gif")

island:setReferencePoint(display.CenterReferencePoint)
island.x = display.contentWidth - island.width
island.y = display.contentHeight- island.height
physics.addBody(island,"static", {bounce = 0})

island.name = "island"







local cloud1 = display.newImage(cloudLayer, "images/cloud.gif")

cloud1:setReferencePoint(display.CenterRightReferencePoint)
cloud1.x = display.contentCenterX
cloud1.y = display.contentCenterY
physics.addBody(cloud1,"static", {bounce = 0})

cloud1.name = "cloud1"

local cloud2 = display.newImage(cloudLayer, "images/cloud.gif")

cloud2:setReferencePoint(display.CenterLeftReferencePoint)
cloud2.x = 50
cloud2.y = 100
physics.addBody(cloud2,"static", {bounce = 0})

cloud2.name = "cloud2"


-- Load and position the plane
plane = display.newImage("images/plane.png")
plane.x = display.contentCenterX
plane.y = display.contentHeight - plane.contentHeight
halfPlayerWidth = plane.contentWidth * .5
-- Add a physics body. It is kinematic, so it doesn't react to gravity.
physics.addBody(plane, "static", {bounce = 0})

plane.name = "plane"



local function movePlane( event )
-- Only move to the screen boundaries
if event.x >= halfPlayerWidth and event.x <= display.contentWidth - halfPlayerWidth then
    -- Update plane x axis
	plane.x = event.x
        end
end
plane:addEventListener( "touch", movePlane )


local scrollbg1 = display.newImage(gameLayer,"images/ocean.gif")
scrollbg1:setReferencePoint( display.CenterLeftReferencePoint )
scrollbg1.x = 0
scrollbg1.y = 0



local scrollbg2 = display.newImage(gameLayer, "images/ocean.gif")
scrollbg2:setReferencePoint( display.CenterLeftReferencePoint )
scrollbg2.x = 0
scrollbg2.y = 480




local tPrevious = system.getTimer( )

local function move(event)
--audio.play(sounds.engine)

local tDelta = event.time - tPrevious
tPrevious = event.time
local yOffset = (0.14 * tDelta)

local islandOffset = (1 * tDelta)

island.y = island.y + yOffset
if(island.y  > 480)then
    island:translate(0, -320*2)
    end

scrollbg1.y = scrollbg1.y + yOffset
scrollbg2.y = scrollbg2.y + yOffset

if (scrollbg1.y > 480)then
    scrollbg1:translate(0, -320*2)
end
if (scrollbg2.y > 480) then
    scrollbg2:translate( 0, -320*2 )
    end
end
Runtime:addEventListener( "enterFrame", move )


function plane:collision(event)
    if(event.phase == "began")then
        if(event.other.name == "island")then
           -- print("Began: " .. event.other.name .. "collided with " .. event.target.name)
            audio.play(sounds.yay)
           end

     end
end
plane:addEventListener( "collision", plane )



