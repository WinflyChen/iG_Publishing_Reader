local widget   = require( "widget" )
local composer = require( "composer")
local scene    = composer.newScene()
local Process  = require( "proc_download")


	local screenBlockGroup = display.newGroup( )
	local viewGroup
    local messageGroup = display.newGroup( )
	local tab_x = display.contentWidth - 2*display.screenOriginX
	local tab_y = (display.contentHeight - 2*display.screenOriginY - 1*gNaviBar.getNaviBarHeight())

    local expiration = 0
    local DownMsg

	local changeSceneEffectSetting = 
	{
	    effect = "crossFade", -- 以什麼方式進入下個畫面的設定
	    time = 300, -- 0.3 sec
	}

    local backgroundImage = nil

    
    -----------------------------------------------------------
    --  屏蔽螢幕的圖案
    -----------------------------------------------------------
    local function ScreenBlock()
        local function screentouch( event )
            if event.phase == "began" then
                print( "began" )
            elseif event.phase == "moved" then
                --print("moved")
            elseif event.phase == "ended"   then
                print( "ended")
            end
            return true           
        end

        local _x = display.contentWidth
        local _y = display.contentHeight

        -- 半透明深色的遮罩，讓 user 無法點選後面的東西
        local loginRect = display.newRect( _x*0.5,
                                           _y*0.5, 
                                           _x - 2*display.screenOriginX, 
                                           _y - 2*display.screenOriginY)
        loginRect:setFillColor( 0 )
        loginRect.alpha = 0.5
        --transition.to( loginRect, { time=3000, alpha=0.8 } )
        loginRect:addEventListener( "touch", screentouch )
        screenBlockGroup:insert(loginRect)

  --       showContentPage   = display.newText("Cover: Done", _x*0.5, _y*0.5, native.systemFont, 40 )
  --       showContentPage:setFillColor( 1, 0, 1 )
  --       screenBlockGroup:insert(showContentPage)
        
        -- showThumbnailPage = display.newText("Thumbnail: Done", _x*0.5, _y*0.6, native.systemFont, 40 )
        -- showThumbnailPage:setFillColor( 1, 0, 1 )
        -- screenBlockGroup:insert(showThumbnailPage)

        --showPercentPage = display.newText("0 %", _x*0.5, _y*0.5, native.systemFont, 200 )
        --showPercentPage:setFillColor( 1)
        --screenBlockGroup:insert(showPercentPage)
    end



    -----------------------------------------------------------
    --  取得書本 metadata
    -----------------------------------------------------------
    local function Check_metadata(event)

        local JSON_metadata = Process.getJSON_metadata()
        -- 
        if JSON_metadata ~= nil and JSON_metadata[1].bookcode ~= "" and JSON_metadata[1].pages ~= "" then
            print("MMMMMMMMMMMMMMMMM")
            timer.cancel( event.source )
            --timer.performWithDelay( 500, listener )   

            --timer.performWithDelay( 500, listener )   
            print("time===",JSON_metadata[1].message)
            gSystem.createFolder(JSON_metadata[1].bookcode)

            gProfile.writeRecord(JSON_metadata[1], gTimeLimit)
            messageGroup.isVisible = false
            system.setIdleTimer( false )
            Process.downloadBook("scene_download", JSON_metadata[1].bookcode, JSON_metadata[1].pages) --JSON_metadata[1].pages
        end

        if event.count >= 4 then

            --timer.performWithDelay( 500, listener )
            timer.cancel( event.source ) -- after 3rd invocation, cancel timer
            print("SSSSSSSSSSSSSSSSSSSSSSSSSSSSS")
        end 
    end

    -----------------------------------------------------------
    --  檢查書本轉檔狀態
    -----------------------------------------------------------
    local function Check_convertstatusmobile(event)

        local JSON_convertstatus = gJSON_convertstatus
        --Process.getJSON_convertstatus()

        --  done : 書本已經轉好檔
        if JSON_convertstatus ~= nil and JSON_convertstatus[1].status == "done" then
            print("CCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCCC")
            timer.cancel( event.source )
            
            -- 
            Process.getBookMatadata()
            timer.performWithDelay( 500, Check_metadata, 4 ) -- repeat 4 times
            
        --  processing : 書本尚未轉好檔
        elseif JSON_convertstatus ~= nil and JSON_convertstatus[1].status == "processing" then
            print("PPPPP book processing")

            local options = 
            {
                text  = "Book is transfering.",     
                x     = tab_x*0.5,
                y     = tab_y*0.25,
                width = tab_x*0.7,     --required for multi-line and alignment
                font  = native.systemFontBold,   
                fontSize = 50,
                align = "center"  --new alignment parameter
            }

            -- if DownMsg ~= nil then display.remove(DownMsg) DownMsg = nil end
            -- DownMsg = display.newText(options)-- message, tab_x*0.5, tab_y * 0.8, native.systemFontBold, 30 )
            -- DownMsg:setFillColor(1, 0, 0)     scrollView:insert(DownMsg)
            -- DownMsg:toFront()
            messageGroup.isVisible = true

            if messageGroup[2] ~= nil then
                messageGroup[2].text = "Book is transfering."
                messageGroup[2]:setFillColor( 1,0,0 )
            end
            screenBlockGroup.isVisible = false
                       
        end

        if event.count >= 4 then

            --timer.performWithDelay( 500, listener )
            timer.cancel( event.source ) -- after 3rd invocation, cancel timer
            print("DDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDDD")

            local options = 
            {
                text  =  JSON_convertstatus[1].message,     
                x     = tab_x*0.5,
                y     = tab_y*0.25,
                width = tab_x*0.7,     --required for multi-line and alignment
                font  = native.systemFontBold,   
                fontSize = 50,
                align = "center"  --new alignment parameter
            }

            -- if DownMsg ~= nil then display.remove(DownMsg) DownMsg = nil end
            -- DownMsg = display.newText(options)-- message, tab_x*0.5, tab_y * 0.8, native.systemFontBold, 30 )
            -- DownMsg:setFillColor(1, 0, 0)     scrollView:insert(DownMsg)
            -- DownMsg:toFront()
            print("###=",messageGroup)
             if messageGroup[2] ~= nil then
                messageGroup.isVisible = true
            end
            if messageGroup[2] ~= nil then
                messageGroup:toFront( )
            end
            
            if messageGroup[2] ~= nil then
                messageGroup[2].text = JSON_convertstatus[1].message
                messageGroup[2]:setFillColor( 1,0,0 )
            end
            --messageGroup[3].waitf = false
            screenBlockGroup.isVisible = false

            screenBlockGroup.isVisible = false

        end 

    end

    -----------------------------------------------------------
    -- 確認
    -----------------------------------------------------------
    local function Button_Yes(top_y)
        -- button event
        -- local justPressed = function(event)
        --     if event.phase == "ended" then
        --         print("ended")

                if DownMsg ~= nil then display.remove(DownMsg) DownMsg = nil end

                Process.setisDownloading(true)
                screenBlockGroup.isVisible = true
                -- 檢查轉檔狀態
                Process.getBookConvertStatus()
                timer.performWithDelay( 500, Check_convertstatusmobile, 4 ) -- repeat 4 times
        --     end
        -- end

        -- local button = widget.newButton
        -- {
        --     --width  = 0,
        --     --height = 0,
        --     x      = display.contentWidth*0.5 - 150,
        --     y      = top_y+150, --display.contentHeight*0.5,
            
        --     -- label = "Yes",
        --     -- lableColor = { default={1, 1, 1}, over={1, 1, 1, 1} },
        --     -- font        = native.systemFontBold,
        --     -- fontSize    = 30,
        --     defaultFile = "image/ic_check_white_48dp.png",
        --     overFile    = "image/ic_check_grey600_48dp.png",
        --     onEvent     = justPressed,
            
        --     width  = 96,
        --     height = 96,
        --     -- shape="roundedRect",
        --     -- cornerRadius = 9,
        --     -- fillColor = { default={ 0.65, 0.65, 0.65, 1 }, over={ 0.65, 0.65, 0.65, 0.4 } },
        --     -- strokeColor = { default={ 0.55, 0.55, 0.55, 1 }, over={ 0.35, 0.35, 0.35, 1 } },
        --     -- strokeWidth = 2                   
        -- }
        -- button.name = "Btn_LogoutConfirm"
        -- scrollView:insert(button)
        -- return button
    end
    -----------------------------------------------------------
    -- 取消
    -----------------------------------------------------------
    local function Button_No(top_y)
        -- button event
        local justPressed = function(event)
            if event.phase == "ended" then
            	print("ended")
                if DownMsg ~= nil then display.remove(DownMsg) DownMsg = nil end

                composer.gotoScene("scene_bookshelf", changeSceneEffectSetting)
            end
        end

        local button = widget.newButton
        {
            --width  = 0,
            --height = 0,
            x      = display.contentWidth*0.5 + 100 ,
            y      = top_y+150, --display.contentHeight*0.5,
            
            -- label = "Cancel",
            -- lableColor = { default={1, 1, 1}, over={1, 1, 1, 1} },
            -- font        = native.systemFontBold,
            -- fontSize    = 30,
            defaultFile = "image/ic_close_white_48dp.png",
            overFile    = "image/ic_close_grey600_48dp.png",
            onEvent     = justPressed,
            width  = 96,
            height = 96,
            -- shape  ="roundedRect",
            -- cornerRadius = 9,
            -- fillColor = { default={ 0.65, 0.65, 0.65, 1 }, over={ 0.65, 0.65, 0.65, 0.4 } },
            -- strokeColor = { default={ 0.55, 0.55, 0.55, 1 }, over={ 0.35, 0.35, 0.35, 1 } },
            -- strokeWidth = 2              
        }
        button.name = "Btn_LogoutCancel"
        scrollView:insert(button)

        return button
    end 


    -----------------------------------------------------------
    --  Create a ScrollView 
    -----------------------------------------------------------
    local function createview()

        --  ScrollView listener 
        local function scrollListener( event )
            local phase = event.phase
            local direction = event.direction
            
            if "began" == phase then
                --print( "Began" )
            elseif "moved" == phase then
                --print( "Moved" )
            elseif "ended" == phase then
                --print( "Ended" )
            end
            
            -- If the scrollView has reached it's scroll limit
            if event.limitReached then
                if "up" == direction then
                    print( "Reached Top Limit" )
                elseif "down" == direction then
                    print( "Reached Bottom Limit" )
                elseif "left" == direction then
                    print( "Reached Left Limit" )   
                elseif "right" == direction then
                    print( "Reached Right Limit" )
                end
            end
                    
            return true
        end

        --
    	scrollView = widget.newScrollView
    	{
            left   = display.screenOriginX,
            top    = display.screenOriginY + gNaviBar.getNaviBarHeight()*1 + display.topStatusBarContentHeight,
            width  = display.contentWidth  - 2*display.screenOriginX,
            height = display.contentHeight - 2*display.screenOriginY- 1*gNaviBar.getNaviBarHeight() - display.topStatusBarContentHeight,        

    		id     = "RentScrollView",
    		hideBackground = false,
    		horizontalScrollDisabled = false,
    	    verticalScrollDisabled   = false,
    		--maskFile = "image/searchBG.png",
    		listener = scrollListener,
    	}
    end


    local MSGtext = nil
    local function ShowMessage( message )
    	local options = 
		{
		    text  = message,     
		    x     = tab_x*0.5,
		    y     = tab_y*0.8,
		    width = tab_x*0.7,     --required for multi-line and alignment
		    font  = native.systemFontBold,   
		    fontSize = 30,
		    --align = "center"  --new alignment parameter
		}


    	if MSGtext ~= nil then display.remove(MSGtext) MSGtext = nil end
		MSGtext = display.newText(options)-- message, tab_x*0.5, tab_y * 0.8, native.systemFontBold, 30 )
	    MSGtext:setFillColor(1,0,0)     scrollView:insert(MSGtext)
    end

    -----------------------------------------------------------
    --
    -----------------------------------------------------------
    function scene:setPercentPage(contentPage, thumbPage, totalPage) 
        local percent = math.floor((contentPage/totalPage)*100)--math.ceil(((thumbPage/totalPage)*0.2+(contentPage/totalPage)*0.8 )*100)
        if percent > 100 then percent = 100 end
        showPercentPage.text =  percent .. "%"
    end  


    -----------------------------------------------------------
    --  下載完成後的檢查
    -----------------------------------------------------------   
    function scene:Done(errpage) -- 下載完成後的檢查

        -- 關閉遮罩
        screenBlockGroup.isVisible = false

        Process.setisDownloading(false)

        -- 
        --gProfile.update(gProfile.BookInfo["bookcode"], true)  
        
        local JSON_metadata = Process.getJSON_metadata()

        -- 
        if JSON_metadata ~= nil and JSON_metadata[1].bookcode ~= "" and JSON_metadata[1].pages ~= "" then
            -- 關閉遮罩
            screenBlockGroup.isVisible = false

            -- 下載沒有問題就直接開閱讀器
            choice_bookcode = JSON_metadata[1].bookcode
            maxPage = tonumber( JSON_metadata[1].pages )
            gBookInfo = {}
            gBookInfo["title"] = JSON_metadata[1].title
            gBookInfo["author"] = JSON_metadata[1].author
            gBookInfo["publisher"] = JSON_metadata[1].publisher
            gBookInfo["page"] = JSON_metadata[1].pages
            pleft = 1
            p1 = 1
            local idPath = JSON_metadata[1].bookcode .. "/"
            print("idpath...................=",idPath)
            gNowPrecent = math.floor( (20/maxPage)*100)
            local path = system.pathForFile( idPath.."precent.txt", system.DocumentsDirectory )
                local fh, errStr = io.open( path, "r" )
                if fh then
                    --checkOver = tonumber(fh:read("*a"))
                    --io.close(fh)
                else
                    fh = io.open(path, "w" )
                    fh:write( gNowPrecent )
                    io.close( fh )
                end

            composer.gotoScene("hpage")
        end
        
    end

-----------------------------------------------------------
    --建立錯誤訊息
    -----------------------------------------------------------
    local function createMessageGroup()
        local inputWidth = 200
        --local x = math.max(display.contentWidth-2*display.screenOriginX,display.contentHeight-2*display.screenOriginY)
        local bg = display.newRect(  0, 0, 4000, 4000 )
        messageGroup.x = display.contentCenterX
        messageGroup.y = display.contentCenterY
        bg.alpha = 0.7
        bg:setFillColor(0)
        local function nothing(event)
            print("event.phase=",event.phase)

            if event.phase == "ended" then

            end
            return true
        end
        
        bg:addEventListener( "touch", nothing )
        messageGroup:insert(bg)

        --2是訊息
        local _txt = display.newText( messageGroup,"", 0, -100, native.systemFont, 60 )


        local function check(event)
            if event.phase == "ended" then
                --print("yesBtn.waitf=",yesBtn.waitf)
               
                    local tab_xx = display.contentWidth - display.screenOriginX
                    local tab_yy = (display.contentHeight - 2*display.screenOriginY - 1*gNaviBar.getNaviBarHeight())
                    messageGroup.isVisible = false

                    Button_Yes(tab_yy*0.35)
               
            end
            return true
        end
        --image/ic_tryagain.png
        local yesBtn = display.newImage( messageGroup, "button/b_reload.png" ,system.ResourceDirectory  )
        yesBtn.width = 96
        yesBtn.height = 96
        yesBtn.x =  - yesBtn.contentWidth
        yesBtn.y =  150
        yesBtn.waitf = false
        yesBtn:addEventListener( "touch", check )

    --print("width=",yesBtn.width)
    --第四個是取消
    local function cancel(event)
        if event.phase == "ended" then

            local inputWidth = gInputGroup[2].width
            local fontSize = 60
            local yshift = 0
            local num = gSystem.calculateSize( )
            
                if num <= 6 then
                    fontSize = 100
                    inputWidth = gInputGroup[2].width
                    yshift = 20
                elseif num == 7 then
                    fontSize = 80
                    inputWidth = gInputGroup[2].width
                    yshift = 15

                end
             

                local bookNumField = native.newTextField( 0, yshift, inputWidth, fontSize)
                
                bookNumField.name = "input"
                bookNumField.isVisible = true
                bookNumField.inputType = "number"
                --bookNumField.isSecure = true
                gInputGroup:insert(bookNumField) 
                gInputGroup.isVisible = true
                gInputGroup[3].waitf = false
                gInputGroup:toFront( )
            messageGroup.isVisible = false
            composer.gotoScene("scene_bookshelf", changeSceneEffectSetting)
        end
        return true
    end
    --"image/ic_close_white_48dp.png"
    local noBtn = display.newImage( messageGroup, "button/b_no.png" ,system.ResourceDirectory  )
    noBtn.width = 96
    noBtn.height = 96
    noBtn.x = inputWidth - noBtn.contentWidth
    noBtn.y =  150
    noBtn:addEventListener( "touch", cancel )
    messageGroup:toFront( )
    if Process.checkLoadingImg() == true then
    messageGroup.isVisible = false
    end
    --messageGroup.isVisible = false

    end


	-----------------------------------------------------------
	--
	-----------------------------------------------------------
	function scene:create(event)
		print( "==================== view setting create event ====================" )

        createview()
		viewGroup = self.view
		viewGroup:insert(scrollView)
		
		-- -- add background
		-- local backgroundImage = display.newRect(0, 
		-- 	                                    0,
		-- 	                                    scrollView.width, 
		-- 	                                    scrollView.height )
		-- backgroundImage.x = display.contentWidth*0.5
		-- backgroundImage.y = backgroundImage.height*0.5
		-- backgroundImage:setFillColor(1)
		-- scrollView:insert(backgroundImage)

  --       -- NaviBar 這個 global 變數在 main.lua
  --       gNaviBar.icoShowSearch(false)
  --       gNaviBar.icoShowOption(true)
	end

	-----------------------------------------------------------
	--
	-----------------------------------------------------------
	function scene:show(event)
		if event.phase == "will" then
			print("====================  view setting will show ====================")

            viewGroup.isVisible = true
            -- add background
            if backgroundImage ~= nil then display.remove( backgroundImage ) backgroundImage = nil end
            backgroundImage = display.newRect(0, 
                                            0,
                                            scrollView.width, 
                                            scrollView.height )
            backgroundImage.x = display.contentWidth*0.5
            backgroundImage.y = backgroundImage.height*0.5
            backgroundImage:setFillColor(0.45)
            scrollView:insert(backgroundImage)

            -- NaviBar 這個 global 變數在 main.lua
            -- gNaviBar.icoShowSearch(false)
            -- gNaviBar.icoShowOption(true)

			local ParaChecker = ""

            rota_composer = "scene_download"
            if gUrlText ~= nil then
                -- gUrlText:toFront()
                -- gUrlText:setFillColor( 1, 0 ,1 )

                -- 分析 url
                ParaChecker, expiration = Process.jsonParse(gUrl)
            end

            if ParaChecker == "ok" then
            	print("parse corona URL ok")

                local tab_xx = display.contentWidth - display.screenOriginX
                local tab_yy = (display.contentHeight - 2*display.screenOriginY - 1*gNaviBar.getNaviBarHeight())

		  --   	local options = 
				-- {
				--     text  = "Do you want to download the book?",     
				--     x     = tab_xx*0.5,
				--     y     = tab_yy*0.35,
				--     width = tab_xx*0.7,     --required for multi-line and alignment
				--     font  = native.systemFontBold,   
				--     fontSize = 50,
				--     align = "center"  --new alignment parameter
				-- }
    --         	local DownText = display.newText(options)-- message, tab_x*0.5, tab_y * 0.8, native.systemFontBold, 30 )
	   --  		DownText:setFillColor(1)     scrollView:insert(DownText)

    --             --print("DownText.yDownText.yDownText.y", DownText.y)

    --         	Button_Yes(DownText.y)
    --         	Button_No(DownText.y)
                if Process.getisDownloading() then
                    Process.changeDir()
                else
                    
                   Button_Yes(tab_yy*0.35) 
                end

            else
            	print("Error Parameter URL, go to bookshelf")
            	composer.gotoScene("scene_bookshelf", changeSceneEffectSetting)
            end


            -- 設定遮罩
            ScreenBlock()
            if Process.getisDownloading() then
                screenBlockGroup.isVisible = true
            else
                screenBlockGroup.isVisible = false
            end


		end
		if event.phase == "did" then
			print("====================  view setting did show ====================")
			--
            local currScene = composer.getSceneName( "current" )
            print("currScene :", currScene)
            local prevScene = composer.getSceneName( "previous" )
            print("previous :", prevScene)
            local overlayScene = composer.getSceneName( "overlay" )
            print("overlay :", overlayScene)

			if prevScene ~= nil and prevScene ~= currScene then
                print("remove scene", prevScene)
				composer.removeScene(prevScene) -- call scene destory function
			end
            if messageGroup.numChildren == 0 then
                
                
                    createMessageGroup()
                
                -- if DownMsg ~= nil then display.remove(DownMsg) DownMsg = nil end
                -- print("yesyesyesyes======")
                -- Process.setisDownloading(true)
                -- screenBlockGroup.isVisible = true
                -- -- 檢查轉檔狀態
                -- Process.getBookConvertStatus()
                -- timer.performWithDelay( 500, Check_convertstatusmobile, 4 ) -- repeat 4 times

               
            end
		end
	end

	-----------------------------------------------------------
	--
	-----------------------------------------------------------
	function scene:hide( event )
			if event.phase == "will" then
			print("====================  view setting will hide ====================")
			viewGroup.isVisible = false
		end
		if event.phase == "did" then
			print("====================  view setting did hide ====================")
		end
	end

	-----------------------------------------------------------
	--
	-----------------------------------------------------------
	function scene:destroy( event )
		print("====================  view setting destroy event ====================")
        for i = 1,screenBlockGroup.numChildren do
            display.remove(screenBlockGroup[1])
            screenBlockGroup[1] = nil
        end
		for i = 1,viewGroup.numChildren do
			local ch = viewGroup[1]
			if ch ~= nil and ch.numChildren > 0 then 
				for j=1, ch.numChildren do
					display.remove( ch[1] )
					ch[1] = nil
				end
			end	

			display.remove(viewGroup[1])
			viewGroup[1] = nil
		end



	end


scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
return scene