-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
H = display.contentHeight
W = display.contentWidth
display.setStatusBar(display.HiddenStatusBar)

require("physics")
physics.start()
physics.setGravity(0, 0)


	score1text = display.newText("0", W/4, H/2 - 20, "Arial", 40)
	score1text:setTextColor(0,200,0)
  score2text = display.newText("0", W/4*3, H/2 - 20, "Arial", 40)
  score2text:setTextColor(0,200,0)
  --local paddleSpot = math.random(topPaddleHeight)
  local score1 = 0
	local score2 = 0


function main()
	createPaddles()
	createBall()
	createWalls()
  startGame()
	onPostCollision()
  aiPaddle()
  ballCheck()


end

function createPaddles()
	local bottomPaddleWidth = 120
	local bottomPaddleHeight = 20

	local topPaddleWidth = 120
	local topPaddleHeight = 20

	topPaddle = display.newRect(display.contentWidth /2 - topPaddleWidth /2, display.contentHeight - 995, topPaddleWidth, topPaddleHeight)
	physics.addBody(topPaddle, "static", {bounce = 1, friction=1})

 --moveTopPaddle = function(event)
 --topPaddle.x = event.x


	bottomPaddle = display.newRect(display.contentWidth /2 - bottomPaddleWidth /2,  display.contentHeight - 50, bottomPaddleWidth, bottomPaddleHeight)
	physics.addBody(bottomPaddle, "static", {bounce = 1, friction =1})

	moveBottomPaddle = function(event)
	bottomPaddle.x = event.x


--make sure the bottomPaddle stays within the boundary of the game
  if((bottomPaddle.x - bottomPaddle.width * 0.6) < 0) then
            bottomPaddle.x = bottomPaddle.width * 0.6
        elseif((bottomPaddle.x + bottomPaddle.width * 0.6) > display.contentWidth) then
            bottomPaddle.x = display.contentWidth - bottomPaddle.width * 0.60
        end
	end

	Runtime:addEventListener("touch", moveBottomPaddle)
	--Runtime:addEventListener("touch", moveTopPaddle)

end

function createBall()
    local ballRadius = 15

    ball = display.newCircle(display.contentWidth /2, display.contentHeight / 2, ballRadius )
    physics.addBody(ball, "dynamic", {friction = 0, bounce = 1.3, radius=ballRadius})




    ball.collision = function(self,event)
        if(event.phase == "ended") then
            if(event.other.type == "destructible") then
                event.other:removeSelf( )
                self = nil
                

            end
            if(event.other.type == "bottomWall" or (event.other.type == "topWall")) then
               self:removeSelf( )
               self = nil
               
               local onTimerComplete = function(event)
               createBall()
               startGame()


            end
                timer.performWithDelay( 500, onTimerComplete, 1 )
           end
       end


end
   ball:addEventListener( "collision", ball)
   ball:addEventListener("postCollision", onPostCollision)

   

end

function onPostCollision(e)
  if (e.other.type == "topWall") then
    score2 = score2 + 1
    score2text.text = score2
    transition.to(ball, {x = W/2, y = H/2, time = 0})
    --ball:setLinearVelocity(75,150)
    createBall()
    --startGame()
  elseif (e.other.type == "bottomWall") then
    score1 = score1 + 1
    score1text.text = score1
    transition.to(ball, {x = W/2, y = H/2, time = 0})
    --ball:setLinearVelocity(75,150)
    createBall()
    --startGame()

  end
  --Runtime:addEventListener("postCollision", onPostCollision)
 --ball:addEventListener("postCollision", onPostCollision)

end





function startGame()
	ball:setLinearVelocity( 75, 150 )
end


function createWalls()

	local wallThickness = 10

	-- left wall
	local leftWall = display.newRect(0,0, wallThickness, display.contentHeight)
	physics.addBody(leftWall,"static", {friction = 0, bounce = 1} )

	 -- top wall

    topWall = display.newRect(0,0, display.contentWidth, wallThickness)
    physics.addBody(topWall,"static", {friction = 0, bounce = 0})

	-- right wall
	local rightWall = display.newRect(display.contentWidth - wallThickness, 0, wallThickness, display.contentHeight )
    physics.addBody(rightWall, "static", {friction = 0 , bounce = 1})



    -- bottom wall
    bottomWall = display.newRect(0, display.contentHeight - wallThickness, display.contentWidth, wallThickness)
    physics.addBody(bottomWall, "static", {friction = 0, bounce = 0})


    bottomWall.type = "bottomWall"
    topWall.type =  "topWall"
end




function aiPaddle(e)

 -- AI for the topPaddle
  local paddleSpeed = 4
if(topPaddle.x < ball.x + 10) then
    topPaddle.x = topPaddle.x + paddleSpeed
  elseif(topPaddle.x > ball.x - 10) then
    topPaddle.x = topPaddle.x - paddleSpeed
  end

--make sure the AI paddle stays within the boundary of the game
  if((topPaddle.x - topPaddle.width * 0.6) < 0) then
            topPaddle.x = topPaddle.width * 0.6
        elseif((topPaddle.x + topPaddle.width * 0.6) > display.contentWidth) then
            topPaddle.x = display.contentWidth - topPaddle.width * 0.60
        end
 end
Runtime:addEventListener("enterFrame", aiPaddle)


--[[
function aiPaddle(e)

 -- AI for the topPaddle
  local paddleSpeed = 3
if(topPaddle.x < ball.x + 10) then
    topPaddle.x = topPaddle.x + paddleSpeed
  elseif(topPaddle.x > ball.x - 10) then
    topPaddle.x = topPaddle.x - paddleSpeed
  end

--make sure the AI paddle stays within the boundary of the game
  if((topPaddle.x - topPaddle.width * 0.6) < 0) then
            topPaddle.x = topPaddle.width * 0.6
        elseif((topPaddle.x + topPaddle.width * 0.6) > display.contentWidth) then
            topPaddle.x = display.contentWidth - topPaddle.width * 0.60
        end
 end
Runtime:addEventListener("enterFrame", aiPaddle)



function ballCheck(e)
if(ball.y < display.contentHeight) then
  ball.x = ball.x
end
end
Runtime:addEventListener("enterFrame", ballCheck)

--]]

main()











