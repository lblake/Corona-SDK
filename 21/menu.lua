-----------------------------------------------------------------------------------------
--
-- menu.lua
--
-----------------------------------------------------------------------------------------

display.display.setStatusBar(display.HiddenStatusBar)

_H = display.contentHeight;
_W = display.contentWidth;

local background = display.newRect(0,0,_W, _H)
background:setFillColor(255,255,255)

local score = 0

local scoreLabel = display.newText(score, 0,0, native.systemFontBold, 120)
scoreLabel.x = display.viewableContentWidth /2
scoreLabel.y = display.viewableContentHeight /2
scoreLabel:setTextColor(0,0,0,0)


local function createPlayer(x,y, width, height, rotation)
	local  p = display.display.newRect(x,y, width, height)
	p:setFillColor(0,0,0)
	p.rotation = rotation

	return p
end

local player = createPlayer(display.viewableContentWidth /2, display.viewableContentHeight/2 2,20,20,0)