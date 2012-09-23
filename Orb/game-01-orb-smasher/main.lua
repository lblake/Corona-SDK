CiderRunMode = {};CiderRunMode.runmode = true;CiderRunMode.assertImage = true;require "CiderDebugger";--http://www.youtube.com/watch?v=6TsDdLY7VXk&list=PLB8268CBEDDE78ED9&index=18&feature=plpp_video


--[[
Copyright (C) 2011 by Rafael Hernandez

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.
]]--

--constants
_H = display.contentHeight;
_W = display.contentWidth;
mRand = math.random;
o = 0;
time_remain = 10;
time_up = false;
total_orbs = 20;
ready = false;

--Prepare sounds to be played or accessed
local soundtrack = audio.loadStream("media/soundtrack.caf");
local pop_sound = audio.loadSound("media/pop.caf");
local win_sound = audio.loadSound("media/win.caf");
local fail_sound = audio.loadSound("media/fail.caf");

local display_txt = display.newText("Wait", 0, 0, native.systemFont, 16*2);
display_txt.xScale = .5; display_txt.yScale = .5;
display_txt:setReferencePoint(display.BottomLeftReferencePoint);
display_txt.x = 20; display_txt.y = _H-20;

local countdowntxt = display.newText(time_remain, 0, 0, native.systemFont, 16*2);
countdowntxt.xScale = .5; countdowntxt.yScale = .5;
countdowntxt:setReferencePoint(display.BottomRightReferencePoint);
countdowntxt.x = _W-20; countdowntxt.y = _H-20;

local function winLose(condition)
	if(condition == "win") then
		display_txt.text = "WIN!";
	elseif(condition == "fail") then
		display_txt.text = "FAIL";
	end
end

local function trackOrbs(obj)
	obj:removeSelf();
	o = o-1;
	
	if(time_up ~= true) then
		--If all the orbs are removed from the display
		if(o == 0) then
			audio.play(win_sound);
			timer.cancel(gametmr);
			winLose("win");
		end
	end
end

local function countDown(e)
	if(time_remain == 10) then
		ready = true;
		display_txt.text = "Go!";
		audio.play(soundtrack, {loops=-1});
	end
	time_remain = time_remain - 1;
	countdowntxt.text = time_remain;
	
	if(time_remain == 0) then
		time_up = true;
		
		if(o ~= 0) then
			audio.play(fail_sound);
			display_txt.text = "FAIL";
			ready = false;
		end
		
	end
end

local function spawnOrb()
	local orb = display.newImageRect("images/blue_orb.png", 45, 45);
	orb:setReferencePoint(display.CenterReferencePoint);
	orb.x = mRand(50, _W-50); orb.y = mRand(50, _H-50);
	
	function orb:touch(e)
		if(ready == true) then
			if(time_up ~= true) then
				if(e.phase == "ended") then
					--Play the popping sound
					audio.play(pop_sound);
					--Remove the orbs
					trackOrbs(self);
				end
			end
		end
		
		return true;
		
	end
	
	--Increment o for every orb created
	o = o+1;
	
	orb:addEventListener("touch", orb);
	
	--If all orbs created, start the game timer
	if(o == total_orbs) then
		gametmr = timer.performWithDelay(1000, countDown, 10);
	else
		ready = false;
	end
	
	
end

tmr = timer.performWithDelay(20, spawnOrb, total_orbs);