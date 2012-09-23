local square = display.newRect( 0, 0, 100, 100 )
square:setFillColor( 255,255,255 )
 
local w,h = display.viewableContentWidth, display.viewableContentWidth
 
local listener = function( obj )
        print( "Transition completed on object: " .. tostring( obj ) )
end