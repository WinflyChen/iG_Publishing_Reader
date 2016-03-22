local composer = require "composer"



local scene = composer.newScene()
local sceneGroup2
function scene:create(event)

end

local function gohpage()
	print("111111")
	composer.gotoScene( "hpage" )
end

function scene:show(event)
	 local ph = event.phase

  --print("show_ph===",ph)
  		if "did" == ph then
        gTransf = true
  			sceneGroup2 = self.view
        local _W = display.contentWidth * 0.5
        local _H = display.contentHeight * 0.5
        local scrOrgx = display.screenOriginX
        local scrOrgy = display.screenOriginY
  			--currentOrientation = system.orientation
        g_curr_Dir = system.orientation
        gOrientf = false
        bg = display.newRect( 0, 0, _W*2-scrOrgx*2, _H*2 - scrOrgy*2 )
        bg.x = _W
        bg.y = _H
        bg:setFillColor( 1 )
        bg.name = "bg"
        sceneGroup2:insert(bg)
        gResumef = false
  			 composer.removeScene("hpage")
  			
  	-- 		 local textnum = display.newText("trans",100,100,native.systemFont,50)
   --    		  sceneGroup2:insert(textnum)
			-- if currentOrientation == "portrait" or currentOrientation == "portraitUpsideDown" then
   -- -- display.remove( pageList )
  	-- 	 		if pleft == 1 then
   --    				p1 = 1
   --  			else
   --    				p1 = pleft -1
   --  			end

   --  		end

   --  if currentOrientation == "landscapeLeft" or currentOrientation == "landscapeRight" then
   --   --display.remove( pageList )
   --   --pageList = nil
   --   if p1 == 1 then
   --    pleft =1
   --   else
   --    if p1 % 2 == 0  then
   --      pleft = p1 + 1
   --    else
   --      pleft = p1
   --    end
   --   end
   --    pright = pleft -1
     
   --   --local textnum = display.newText("直轉橫"..tostring(pleft),100,50,native.systemFont,50)
   --   --textnum:setFillColor( 1,0,0 ) 

   --   if pleft > 1 then
   --    p1 = pleft - 2
   --   else
   --    p1 = 1
   --   end

    --  bg:removeEventListener("touch",testTimeFn)
    -- Runtime:removeEventListener("touch",turnPagefn)

    

    -- Runtime:removeEventListener("enterFrame",autoturnfn )
    -- Runtime:removeEventListener( "orientation", onOrientationChange )
    -- Runtime:removeEventListener("enterFrame",closeOptionFn)

     
  --end
  --print("bbbbbb")
  timer.performWithDelay( 500, gohpage )
 end 
end

function scene:hide(event)
  -- local ph = event.phase
  -- if "will" == ph then
   
  -- end
end

function scene:destory(event)
end


scene:addEventListener( "create",scene)
scene:addEventListener( "show",scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destory", scene )


return scene
