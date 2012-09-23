-- Space Shooter Game
-- Developed by Carlos Yanez

-- Hide Status Bar

display.setStatusBar(display.HiddenStatusBar)

-- Import MovieClip Library

local movieclip = require('movieclip')

-- Import Physics

local physics = require('physics')
physics.start()
physics.setGravity(0, 0)

-- Graphics

-- Background

local bg = display.newImage('images/bg.png')

-- [Title View]

local title
local playBtn
local creditsBtn
local titleView

-- [Credits]

local creditsView

-- [Ship]

local ship

-- [Boss]

local boss

-- [Score]

local score

-- [Lives]

local lives

-- Load Sounds

local shot = audio.loadSound('media/shot.mp3')
local explo = audio.loadSound('media/explo.mp3')
local bossSound = audio.loadSound('media/boss.mp3')

-- Variables

local timerSource
local lives = display.newGroup()
local bullets = display.newGroup()
local enemies = display.newGroup()
local scoreN = 0
local bossHealth = 20

-- Functions

local Main = {}
local addTitleView = {}
local showCredits = {}
local removeCredits = {}
local removeTitleView = {}
local addShip = {}
local addScore = {}
local addLives = {}
local listeners = {}
local moveShip = {}
local shoot = {}
local addEnemy = {}
local alert = {}
local update = {}
local collisionHandler = {}
local restart = {}

-- Main Function

function Main()
	addTitleView()
end

function addTitleView()
	title = display.newImage('images/title.png')
	playBtn = display.newImage('images/playBtn.png')
	playBtn.x = display.contentCenterX
	playBtn.y = display.contentCenterY + 10
	playBtn:addEventListener('tap', removeTitleView)
	
	creditsBtn = display.newImage('images/creditsBtn.png')
	creditsBtn.x = display.contentCenterX
	creditsBtn.y = display.contentCenterY + 60
	creditsBtn:addEventListener('tap', showCredits)
	
	titleView = display.newGroup(title, playBtn, creditsBtn)
end

function removeTitleView:tap(e)
	transition.to(titleView,  {time = 300, y = -display.contentHeight, onComplete = function() display.remove(titleView) titleView = null addShip() end})
end

function showCredits:tap(e)
	creditsBtn.isVisible = false
	creditsView = display.newImage('images/creditsView.png')
	creditsView:setReferencePoint(display.TopLeftReferencePoint)
	transition.from(creditsView, {time = 300, x = display.contentWidth})
	creditsView:addEventListener('tap', removeCredits)
end

function removeCredits:tap(e)
	creditsBtn.isVisible = true
	transition.to(creditsView, {time = 300, x = display.contentWidth, onComplete = function() display.remove(creditsView) creditsView = null end})
end

function addShip()
	ship = movieclip.newAnim({'images/shipA.png', 'images/shipB.png'})
	ship.x = display.contentWidth * 0.5
	ship.y = display.contentHeight - ship.height
	ship.name = 'ship'
	ship:play()
	physics.addBody(ship)
	
	addScore()
end

function addScore()
	score = display.newText('Score: ', 1, 0, native.systemFontBold, 14)
	score.y = display.contentHeight - score.height * 0.5
	score.text = score.text .. tostring(scoreN)
	score:setReferencePoint(display.TopLeftReferencePoint)
	score.x = 1
	
	addLives()
end

function addLives()
	for i = 1, 3 do
		live = display.newImage('images/live.png')
		live.x = (display.contentWidth - live.width * 0.7) - (5 * i+1) - live.width * i + 20
		live.y = display.contentHeight - live.height * 0.7
		
		lives.insert(lives, live)
	end
	listeners('add')
end

function listeners(action)
	if(action == 'add') then	
		bg:addEventListener('touch', moveShip)
		bg:addEventListener('tap', shoot)
		Runtime:addEventListener('enterFrame', update)
		timerSource = timer.performWithDelay(800, addEnemy, 0)
	else
		bg:removeEventListener('touch', moveShip)
		bg:removeEventListener('tap', shoot)
		Runtime:removeEventListener('enterFrame', update)
		timer.cancel(timerSource)
	end
end

function moveShip:touch(e)
	if(e.phase == 'began') then
		lastX = e.x - ship.x
	elseif(e.phase == 'moved') then
		ship.x = e.x - lastX
	end
end

function shoot:tap(e)
	local bullet = display.newImage('images/bullet.png')
	bullet.x = ship.x
	bullet.y = ship.y - ship.height
	bullet.name = 'bullet'
	physics.addBody(bullet)
	
	audio.play(shot)
	
	bullets.insert(bullets, bullet)
end

function addEnemy(e)
	local enemy = movieclip.newAnim({'images/enemyA.png', 'images/enemyA.png','images/enemyA.png','images/enemyA.png','images/enemyA.png','images/enemyA.png','images/enemyB.png','images/enemyB.png','images/enemyB.png','images/enemyB.png','images/enemyB.png','images/enemyB.png'})
	enemy.x = math.floor(math.random() * (display.contentWidth - enemy.width))
	enemy.y = -enemy.height
	enemy.name = 'enemy'
	physics.addBody(enemy)
	enemy.bodyType = 'static'
	enemies.insert(enemies, enemy)
	enemy:play()
	enemy:addEventListener('collision', collisionHandler)
end

function alert(e)
	listeners('remove')
	local alertView
	
	if(e == 'win') then
		alertView = display.newImage('images/youWon.png')
		alertView.x = display.contentWidth * 0.5
		alertView.y = display.contentHeight * 0.5
	else
		alertView = display.newImage('images/gameOver.png')
		alertView.x = display.contentWidth * 0.5
		alertView.y = display.contentHeight * 0.5
	end
	
	alertView:addEventListener('tap', restart)
end

function update(e)
	-- Move Bullets
	
	if(bullets.numChildren ~= 0) then
		for i = 1, bullets.numChildren do
			bullets[i].y = bullets[i].y - 10
			
			-- Destroy Offstage Bullets

			if(bullets[i].y < -bullets[i].height) then
				bullets:remove(bullets[i])
				display.remove(bullets[i])
				bullets[i] = nil
			end
		end
	end
	
	-- Move Enemies
	
	if(enemies.numChildren ~= 0) then
		for i = 1, enemies.numChildren do
			if(enemies[i] ~= nil) then
				enemies[i].y = enemies[i].y + 3
			
				-- Destroy Offstage Enemies
			
				if(enemies[i].y > display.contentHeight) then
					enemies:remove(enemies[i])
					display.remove(enemies[i])
				end
			end
		end
	end
	
	-- Show Boss
	
	if(scoreN == 50 and boss == nil) then
		audio.play(bossSound)
		boss = movieclip.newAnim({'images/bossA.png','images/bossA.png','images/bossA.png','images/bossA.png','images/bossA.png', 'images/bossA.png','images/bossA.png', 'images/bossB.png','images/bossB.png','images/bossB.png','images/bossB.png','images/bossB.png','images/bossB.png','images/bossB.png'})
		boss.x = display.contentWidth * 0.5
		boss.name = 'boss'
		physics.addBody(boss)
		boss.bodyType = 'static'
		transition.to(boss, {time = 1500, y = boss.height + (boss.height * 0.5)})
		boss:play()
		boss:addEventListener('collision', collisionHandler)
	end
end

function collisionHandler(e)
	if(e.other.name == 'bullet' and e.target.name == 'enemy') then
		audio.play(explo)
		display.remove(e.other)
		display.remove(e.target)
		scoreN = scoreN + 50
		score.text = 'Score: ' .. tostring(scoreN)
		score:setReferencePoint(display.TopLeftReferencePoint)
		score.x = 1
	elseif(e.other.name == 'bullet' and e.target.name == 'boss') then
		audio.play(explo)
		display.remove(e.other)
		bossHealth = bossHealth - 1
		scoreN = scoreN + 50
		score.text = 'Score: ' .. tostring(scoreN)
		score:setReferencePoint(display.TopLeftReferencePoint)
		score.x = 1
		if(bossHealth <= 0) then
			display.remove(e.target)
			alert('win')
		end
	elseif(e.other.name == 'ship') then
		audio.play(explo)
		
		display.remove(e.target)
		
		-- Remove Live
		
		display.remove(lives[lives.numChildren])
		
		-- Check for Game Over
		
		if(lives.numChildren < 1) then
			alert('lose')
		end
	end
end

function restart()
	listeners('remove')
	
	display.remove(bullets)
	display.remove(enemies)
	display.remove(ship)
	display.remove(alertView)
	
	Main()
end

Main()