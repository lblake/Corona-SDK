-----------------------------------------------------------------------------------------
--
-- main.lua
--
-----------------------------------------------------------------------------------------


display.setStatusBar(display.HiddenStatusBar)

require("physics")
physics.start()

physics.setGravity(0, 20)

local gameLayer = display.newGroup()
local bulletsLayer = display.newGroup()
local enemiesLayer = display.newGroup()


local gameIsActive = true
local scoreText
local sounds
local score = 0
local toRemove = {}
local background
local player
local halfPlayerWidth


local textureCache = {
}
textureCache[1] = display.newImage('images/enemy.png')
textureCache[1].isVisible = false
textureCache[2] = display.newImage('images/bullet.png')
textureCache[2].isVisible = false
local halfEnemyWidth = textureCache[1].contentWidth * .5

audio.setMaxVolume(0.85, { channel = 1 })

sounds = {
	pew = audio.loadSound("media/pew.wav"),
	boom = audio.loadSound("media/boom.wav"),
	gameOver = audio.loadSound("media/gameOver.wav")
}

background = display.newRect(0,0, display.contentWidth, display.contentHeight)
background:setFillColor(21, 115,193)
gameLayer:insert(background)
gameLayer:insert(bulletsLayer)
gameLayer:insert(enemiesLayer)

local function onCollision(event)
	if (self.name == "bullet" and event.other.name == "enemy" and gameIsActive) then
		score = score + 1
		scoreText.text = score
		audio.play(sounds.boom)
		table.insert(toRemove, event.other)
	elseif(self.name == "player" and event.other.name == "enemy") then
		audio.play(sounds.gameOver)
		local gameOverText = display.newText("Game Over!!", 0.0, "HelveticaNeue", 35)
		gameOverText:setTextColor(255,255,255)
		gameOverText.x = display.contentCenterX
		gameOverText.y = diplay.display.contentCenterY
		gameLayer:insert(gameOverText)
		gameIsActive = false
	end
end


player = display.newImage( "images/player.png" )
player.x = display.contentCenterX
player.y = display.contentHeight - player.contentHeight

physics.addBody( player, "kinematic", { bounce = 0} )

player.name = "player"

--player.collision = onCollision
player:addEventListener("collision", onCollision)
--player:addEventListener("collision", player)

gameLayer:insert(player)

halfPlayerWidth = player.contentWidth * .5

scoreText = display.newText(score, 0,0, "HelveticaNeue", 35)
scoreText:setTextColor(255,255,255)
scoreText.x = 30
scoreText.y = 25
gameLayer:insert(scoreText)

local timeLastBullet, timeLastEnemy = 0,0
local bulletInterval = 1000

local function gameLoop(event)
    if gameActive then
        for i = 1, #toRemove do
            toRemove[i].parent:remove( toRemove[i] )
            toRemove[i] = nil
        end
        if event.time - timeLastEnemy >= math.random(600, 1000) then
            local enemy = display.newImage('images/enemy.png')
            enemy.x = math.random(halfEnemyWidth, display.contentWidth - halfEnemyWidth)
            enemy.y = - enemy.contentHeight
            physics.addBody(enemy, "dynamic", {bounce = 0})
            enemy.name = "enemy"
            enemiesLayer:insert(enemy)
            timeLastEnemy = event.time
        end

        if event.time - timeLastBullet >= math.random(250, 300) then
            local bullet = display.newImage('images/bullet.ng')
            bullet.x = player.x
            bullet.y = player.y - halfPlayerWidth

            physics.addBody(bullet, "kinematic", {bounce = 0})
            bullet.name = "bullet"

            bullet.collision = onCollision
            bullet:addEventListener( "collision", bullet)
            bulletsLayer:insert(bullet)
            --gameLayer:insert(bullet)

            audio.play(sounds.pew)

            transition.to(bullet, {time = 1000, y = -bullet.contentHeight,onComplete = function(self) self.parent:remove(self); self = nil; end })
            timeLastBullet = event.time
        end
       end
 end

    Runtime:addEventListener( "enterFrame", gameLoop )


    local function playerMovement(event)
        if not gameActive then return false end
        if event.x >= halfPlayerWidth and event.x <= display.contentWidth - halfPlayerWith then
            player.x = event.x
            end
    end
    player:addEventListener( "touch", playerMovement )

