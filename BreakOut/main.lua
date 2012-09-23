-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------
--[[

Breakout game modiied by Lloyd Blake this was based on tutorial from
'anscamobile'  http://www.youtube.com/watch?v=4ee261iYTaI

Added the following functions:

1: displayScore(): which displays the score and the number of balls(lives) you have
2: restartGame(): which restarts the game after all the balls have been lost

I also added sound when the ball hit the paddle and when the ball hit the bricks
--]]


require ("physics")
display.setStatusBar( display.HiddenStatusBar )



local function main()

    setUpPhysics()
    createWalls()
    createBricks()
    createBall()
    createPaddle()
    startGame()
    displayScore()
    --checkPaddle()
    --restartGame()

end


function setUpPhysics()
    physics.start( )
    physics.setGravity( 0,0 )
end


function createPaddle()


    local paddleWidth = 100
    local paddleHeight = 10
    local paddle = display.newRect(display.contentWidth /2 - paddleWidth /2,  display.contentHeight - 50, paddleWidth, paddleHeight )
    physics.addBody(paddle, "static", {friction = 2, bounce = 1})



    local movePaddle = function(event)

         paddle.x = event.x

         --check the paddle stays within the boundary of the game
         if((paddle.x - paddle.width * 0.6) < 0) then
            paddle.x = paddle.width * 0.6
        elseif((paddle.x + paddle.width * 0.6) > display.contentWidth) then
            paddle.x = display.contentWidth - paddle.width * 0.6
        end

    end


    Runtime:addEventListener( "touch", movePaddle )
end

function createBall()
    local ballRadius = 10
    local hit_sound = audio.loadSound("media/hit_sound.wav")

    ball = display.newCircle(display.contentWidth /2, display.contentHeight / 2, ballRadius )
    physics.addBody(ball, "dynamic", {friction = 0, bounce = 1, radius=ballRadius})

    ball.collision = function(self,event)
        if(event.phase == "ended") then
        audio.play(hit_sound)
            if(event.other.type == "destructible") then
                event.other:removeSelf()
                score.text = score.text + 15
                end
            if(event.other.type == "bottomWall") then
                self:removeSelf()
                balls.text = balls.text -1
                local onTimerComplete = function(event)

                   createBall()
                   startGame()
               end
               timer.performWithDelay( 500, onTimerComplete, 1 )
           end
       end
   end

   ball:addEventListener( "collision",ball )

end

function startGame()
    ball:setLinearVelocity( 75, 150 )
end


function createBricks()

    local brickWidth = 40
    local brickHeight = 20

    local numOfRows = 4
    local numOfCols = 6

    local topLeft = {x = display.contentWidth / 2 - ( brickWidth * numOfCols )/2, y = 50 }
    local row
    local col

    for row = 0, numOfRows - 1 do
        for col = 0, numOfCols - 1 do

            -- create a brick
            local brick = display.newRect(topLeft.x + (col * brickWidth), topLeft.y + (row * brickHeight), brickWidth, brickHeight)
            brick:setFillColor(math.random(50,255), math.random(50, 255), math.random(50, 255), 255)
            brick.type = "destructible"

            physics.addBody(brick, "static", {friction = 1, bounce = 1})
        end
    end
end

function createWalls()

    local wallThickness = 10

    leftWall = display.newRect( 0,0, wallThickness, display.contentHeight )
    physics.addBody( leftWall, "static", { friction = 0, bounce = 1} )

    topWall = display.newRect(0,0, display.contentWidth, wallThickness)
    physics.addBody(topWall,"static", {friction = 0, bounce = 1})

    rightWall = display.newRect(display.contentWidth - wallThickness, 0, wallThickness, display.contentHeight )
    physics.addBody(rightWall, "static", {friction = 0 , bounce = 1})

    bottomWall = display.newRect(0, display.contentHeight - wallThickness, display.contentWidth, wallThickness)
    physics.addBody(bottomWall, "static", {friction = 0, bounce = 1})

    bottomWall.type = "bottomWall"

end

function displayScore()

    ball_number = {1,2,3,4,5}
    brick_score = 0
    brickScore = 10


    score_text = display.newText('Score: ', 10,10, native.systemFontBold, 14)
    ball_text = display.newText('Lives: ', 220, 10, native.systemFontBold, 14)

    score  = display.newText(brick_score, 100,300, native.systemFontBold, 14)
    score:setReferencePoint(display.TopLeftReferencePoint)
    score.x = 60
    score.y = 10

    balls = display.newText(#ball_number, 100, 300, native.systemFontBold, 14)
    balls:setReferencePoint(display.TopRightReferencePoint)
    balls.x = 285
    balls.y = 10



end

function restartGame()
    if(balls.text == "0")then

        elseif(#ball_count == #ball_count)then
        end
end

main()