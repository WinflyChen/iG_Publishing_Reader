local widget   = require( "widget" )
local composer = require( "composer")
local scene    = composer.newScene()
----local showText1 = display.newText( "scene_bookshelf_h", 400, 300, native.systemFontBold, 60 )
--showText1:setFillColor( 0 )
    local Show_Mata = {}
	local viewGroup
    local screenBlockGroup = display.newGroup( )

    local tab_x = display.contentWidth - 2*display.screenOriginX
    local tab_y = (display.contentHeight - 2*display.screenOriginY - gNaviBar.getNaviBarHeight())

    local backgroundImage = nil

    local books      = {}
    local bookRect   = {}
    local _pageSize  = 10
    local _page      = 1
    local coverImage = {}

    local _touchNO
    local _inBlock = false
    local _moving  = true
    
    local hint = {}
    local hintRect = {}
    local deletef = false
    local checkNum = 2
    local checkBookCode = ""
    local checkDownloadCode = ""
    local booksProfile = nil
    local states = ""
    -----------------------------------------------------------
    --  排列
    -----------------------------------------------------------
    

    local function arrangPos()
        if books ~= nil then
            for i = 1,#books do
                table.remove( books )
            end
            if bookRect[i] ~= nil then 
                print("有外框")
                --bookRect[i]:removeEventListener( "touch", covertouch )
                display.remove( bookRect[i] ) 
                bookRect[i] = nil
            end

        end
        local haveExpired = false

        for j = 2,#booksProfile do
            if booksProfile[j].expired == "true" then
                haveExpired = true
                break
            end
        end

        ------------------------------------------------
        --如果有過期的書，排二次讓過期的書在後面
        ------------------------------------------------
        if haveExpired == true then
            local tmp = {}
            for k = 2,#booksProfile do
                table.insert( tmp, booksProfile[k])
            end
            local tmp1 = {}
            for i = #tmp,1,-1 do
                if tmp[i].expired == "true" then
                    table.insert(tmp1,tmp[i])
                else
                    table.insert( tmp1, 1, tmp[i] )
                end
            end

            -------第二次排序，所有順序正常
            local tmp2 = {}
            for j = #tmp1,1,-1 do
                if tmp1[j].expired == "true" then
                    table.insert(tmp2,tmp1[j])
                else
                    table.insert(tmp2,1,tmp1[j])
                end
            end
            ------將第一個空白的塞進去並更新booksprofile, 寫入
            table.insert( tmp2, 1, booksProfile[1] )
            booksProfile = tmp2
            local contents = json.encode(booksProfile)  --print("contents", contents)
                 local path     = system.pathForFile( "bookprofile.txt", system.DocumentsDirectory )
                 local file     = io.open(path, "w")
                   -- print("contents------------------", contents)
                 if file then
                     file:write( contents )
                     io.close( file )
                else
                     print("writeRecord file error")
                 end

        end


        local booknum = 0
        for i=1, #booksProfile do
            
            if i > 1 then
                local tmp ={}
                tmp["bookcode"]    = booksProfile[i].bookcode
                tmp["expired"]     = booksProfile[i].expired
                tmp["title"]       = booksProfile[i].title
                tmp["author"]      = booksProfile[i].author
                tmp["publisher"]   = booksProfile[i].publisher
                tmp["year"]        = booksProfile[i].year
                tmp["page"]        = booksProfile[i].page
                tmp["lastpage"]    = booksProfile[i].lastpage
                tmp["download"]    = booksProfile[i].download
                tmp["expirytime"]  = booksProfile[i].expirytime
                booknum = booknum + 1

                table.insert(books, tmp)
            --end
            end
        end

        if booknum == 0 then
            local inputWidth = gInputGroup[2].width - 200
            local fontSize = 60
            --local yshift = 0 - 40 - 150
            local num = gSystem.calculateSize( )
            if gInputGroup.numChildren == 7  then
                if num <= 6 then
                    fontSize = 90
                    --inputWidth = gInputGroup[2].width - 200
                    --yshift = 20 - 40 - 150
                elseif num == 7 then
                    fontSize = 70
                    --inputWidth = gInputGroup[2].width - 200
                    --yshift = 15 - 40 - 150

                end
                local bookNumField = native.newTextField( 0, 0, gInputWidth, fontSize)
                bookNumField.name = "input"
                bookNumField.isVisible = true
                bookNumField.inputType = "number"
                --bookNumField.isSecure = true
                --print("bookNumField.x == ",bookNumField.x)
                --print("bookNumField.y == ",bookNumField.y)
                gInputGroup:insert(bookNumField) 
                bookNumField.y = gInputGroup[6].y + (gInputGroup[6].height + fontSize)*0.5
                gInputGroup[3].x = bookNumField.x + gInputWidth*0.5 + gInputGroup[3].width*0.5 + 10
                gInputGroup[3].y = bookNumField.y
                gInputGroup[3].width = fontSize
                gInputGroup[3].height = fontSize
                gNoBtn.width = fontSize
                gNoBtn.height = fontSize
                gInputGroup[7].y = bookNumField.y + fontSize + 60
                gInputGroup[4].y = gInputGroup[7].y + gInputGroup[4].height + 60
                -- gInputGroup[6].y = bookNumField.y - fontSize*0.5 - gInputGroup[6].height*0.5
                -- gInputGroup[5].y = 

            end

            --gInputGroup.y = gInputGroup.y 
            print("gInputGroup.y= ", gInputGroup.y)
            gInputGroup.isVisible = true
            gInputGroup:toFront( )
            gNoBtn.x = gNoBtn.width*0.5 + display.screenOriginX + 40
            gNoBtn.y = gNoBtn.height*0.5 + display.screenOriginY + 60
            gNoBtn:toFront( )
            gNoBtn.isVisible = true
               
        end
        
    end

    -----------------------------------------------------------
    --  取得downloadcode
    -----------------------------------------------------------
    local function getDownloadCode(bc)
        local idPath = bc .. "/"
                local path = system.pathForFile( idPath.."six.txt", system.DocumentsDirectory )
                local fh, errStr = io.open( path, "r" )
               
                    --fh = io.open(path, "w" )
                    local tmp = fh:read("*a")
                    io.close( fh )
        return tmp
    end

    -----------------------------------------------------------
    -- 還書
    -----------------------------------------------------------
    local function returnBookFn(event)
        if ( event.isError ) then
            if states == "returnBook" then
                local alert = native.showAlert( "Network Error !!", "Please make sure internet connected and try again", { "OK" } )
            end
            --scene.change_page()
        else
             print("returnBook _ response ==",event.response)
             print("checkBookCode=",checkBookCode)
             print("checkDownloadCode=",checkDownloadCode)
            if event.response == "ok" then
                checkNum = 2
                getbookparameter()
            end
        end
    end


    -----------------------------------------------------------
    -- 取得還書的確認
    -----------------------------------------------------------
    local function checkReturned(event)
        if ( event.isError ) then
            checkNum = 2
                getbookparameter()
            scene.change_page()
        else
            print("return _ response ==",event.response)
            if event.response == "true" then
                 booksProfile[checkNum].expired = "true"

                 local contents = json.encode(booksProfile)  --print("contents", contents)
                 local path     = system.pathForFile( "bookprofile.txt", system.DocumentsDirectory )
                 local file     = io.open(path, "w")
                  
                 if file then
                     file:write( contents )
                     io.close( file )
                else
                     print("writeRecord file error")
                 end

            end

            checkNum = checkNum + 1 
            if checkNum <= #booksProfile then
                getbookparameter()
            else
                ---都檢查完了，開始排列
                print("arrang......")
                arrangPos()
                scene.change_page()
            end
        end
    end

    -----------------------------------------------------------
    -- 取得還書的Verify Key
    -----------------------------------------------------------
    local function getVerifyKey(event)
        if ( event.isError ) then
             arrangPos()
            scene.change_page()

            if states == "returnBook" then
                local alert = native.showAlert( "Network Error !!", "Please make sure internet connected and try again", { "OK" } )
            end
        else
            print( "event.response_verify = " .. event.response );
            local verify = event.response
            --連結裝置和個人帳號
             if states == "checkReturned" then
               local URL = "http://testportal.igpublish.com/iglibrary/api/checkout/CheckIfReturned/"..verify.."/"..checkBookCode.."/"..checkDownloadCode.."/"..gDeviceID
                network.request( URL, "GET", checkReturned)
            elseif states == "returnBook" then
                print("returnbook.........")
                local URL = "http://testportal.igpublish.com/iglibrary/api/checkout/ReturnBook/"..verify.."/"..checkBookCode.."/"..checkDownloadCode.."/"..gDeviceID
                network.request( URL, "GET", returnBookFn)
            end
        end
    end

    -----------------------------------------------------------
    --  檢查過期
    -----------------------------------------------------------


    function getbookparameter()
        
       print("#################=====",#booksProfile)

        if #booksProfile > 1 then
           checkBookCode = booksProfile[checkNum].bookcode
            checkDownloadCode = getDownloadCode(checkBookCode)
            
            states = "checkReturned"
            local URL =  "http://testportal.igpublish.com/iglibrary/api/checkout/RequestVerifyKey/AnyString/"..checkBookCode.."/"..checkDownloadCode.."/"..gDeviceID
            network.request( URL, "GET", getVerifyKey)
                --end
        else
             arrangPos()
             scene.change_page()
        end
    end

    -----------------------------------------------------------
    -- read
    -----------------------------------------------------------
    local function Button_Read(bookcode, page)
        -- button event
        local justPressed = function(event)
            if event.phase == "ended" then
                print("ended")

                -- 從這邊進入 reader 之前也要刪除
                for i = 1,screenBlockGroup.numChildren do
                    display.remove(screenBlockGroup[1])
                    screenBlockGroup[1] = nil
                end

                -- 下載沒有問題就直接開閱讀器
                choice_bookcode = bookcode
                maxPage = tonumber(page)
                pleft = 1
                p1 = 1
                currentOrientation = g_curr_Dir
                local idPath = bookcode .. "/"
                local path = system.pathForFile( idPath.."precent.txt", system.DocumentsDirectory )
                local fh, errStr = io.open( path, "r" )
                if fh then
                    gNowPercent = tonumber(fh:read("*a"))
                    io.close(fh)
                else
                    fh = io.open(path, "w" )
                    gNowPercent = 10
                    fh:write( 10 )
                    io.close( fh )
                end
                composer.gotoScene("hpage")
            end
        end

        local button = widget.newButton
        {
            --width  = 0,
            --height = 0,
            x      = display.contentWidth*0.15+150,
            y      = tab_y*0.3-56,
            
            -- label = "Yes",
            -- lableColor = { default={1, 1, 1}, over={1, 1, 1, 1} },
            -- font        = native.systemFontBold,
            -- fontSize    = 30,
            --defaultFile = "image/ic_local_library_white_48dp.png",
            --overFile    = "image/ic_local_library_grey600_48dp.png",
            defaultFile = "button/reading.png",
            overFile    = "button/reading.png",
            onEvent     = justPressed,
            
            --width  = 96,
            --height = 96,
            --shape="roundedRect",
            -- cornerRadius = 9,
            -- fillColor = { default={ 0.65, 0.65, 0.65, 1 }, over={ 0.65, 0.65, 0.65, 0.4 } },
            -- strokeColor = { default={ 0.55, 0.55, 0.55, 1 }, over={ 0.35, 0.35, 0.35, 1 } },
            -- strokeWidth = 2                   
        }
        button.name = "Button_Read"
        button:toFront( )
        button.y = Show_Mata["page"].y + button.height +30

        --button.anchorX = 0
        button.x = display.contentCenterX
        screenBlockGroup:insert(button)
        return button
    end

    -----------------------------------------------------------
    -- close
    -----------------------------------------------------------
    local function Button_Close()
        -- button event
        local justPressed = function(event)
            if event.phase == "ended" then
                print("ended")
                for i = 1,screenBlockGroup.numChildren do
                    display.remove(screenBlockGroup[1])
                    screenBlockGroup[1] = nil
                end
            end
            deletef = false
        end

        local button = widget.newButton
        {
            --width  = 0,
            --height = 0,
            x      = display.contentWidth*0.15,
            y      = tab_y*0.3-56,
            
            -- label = "Yes",
            -- lableColor = { default={1, 1, 1}, over={1, 1, 1, 1} },
            -- font        = native.systemFontBold,
            -- fontSize    = 30,
            defaultFile = "button/b_no.png",
            overFile = "button/b_no.png",
            onEvent     = justPressed,
            
            width  = 96,
            height = 96,
            --shape="roundedRect",
            -- cornerRadius = 9,
            -- fillColor = { default={ 0.65, 0.65, 0.65, 1 }, over={ 0.65, 0.65, 0.65, 0.4 } },
            -- strokeColor = { default={ 0.55, 0.55, 0.55, 1 }, over={ 0.35, 0.35, 0.35, 1 } },
            -- strokeWidth = 2                   
        }
        button.name = "Button_Close"
        button:toFront( )
        button.width = 75
        button.height = 75
        button.x = button.width*0.5 + display.screenOriginX + 40
        button.y = button.height*0.5 + display.screenOriginY + 55
        screenBlockGroup:insert(button)
        return button
    end

    -----------------------------------------------------------
    -- close
    -----------------------------------------------------------
    local function Button_Delete_No()
        -- button event
        local justPressed = function(event)
            if event.phase == "ended" then
                print("ended")
                for i = 1,screenBlockGroup.numChildren do
                    display.remove(screenBlockGroup[1])
                    screenBlockGroup[1] = nil
                end
            end
            deletef = false
        end

        local button = widget.newButton
        {
            --width  = 0,
            --height = 0,
            x      = display.contentWidth*0.6,
            y      = tab_y*0.4,
            
            -- label = "Yes",
            -- lableColor = { default={1, 1, 1}, over={1, 1, 1, 1} },
            -- font        = native.systemFontBold,
            -- fontSize    = 30,
            --defaultFile = "image/ic_close_white_48dp.png",
            --overFile    = "image/ic_close_grey600_48dp.png",
            defaultFile = "button/b_no.png",
            overFile = "button/b_no.png",
            onEvent     = justPressed,
            
            width  = 96,
            height = 96,
            --shape="roundedRect",
            -- cornerRadius = 9,
            -- fillColor = { default={ 0.65, 0.65, 0.65, 1 }, over={ 0.65, 0.65, 0.65, 0.4 } },
            -- strokeColor = { default={ 0.55, 0.55, 0.55, 1 }, over={ 0.35, 0.35, 0.35, 1 } },
            -- strokeWidth = 2                   
        }
        button.name = "Button_Close"
        button:toFront( )
        button.width = 75
        button.height = 75
        button.x = button.width*0.5 + display.screenOriginX + 40
        button.y = button.height*0.5 + display.screenOriginY + 55
        screenBlockGroup:insert(button)
        return button
    end

     -----------------------------------------------------------
    -- return check
    -----------------------------------------------------------
    local function Button_Return_Yes(del_bookcode)

        local justPressed = function(event)
            if event.phase == "ended" then
                states = "returnBook"
                local URL =  "http://testportal.igpublish.com/iglibrary/api/checkout/RequestVerifyKey/AnyString/"..checkBookCode.."/"..checkDownloadCode.."/"..gDeviceID
                network.request( URL, "GET", getVerifyKey)
                for i = 1,screenBlockGroup.numChildren do
                    display.remove(screenBlockGroup[1])
                    screenBlockGroup[1] = nil
                end
            end
            deletef = false
        end
        local button = widget.newButton
            {
            --width  = 0,
            --height = 0,
            x      = display.contentWidth*0.5 ,
            y      = tab_y*0.5, --display.contentHeight*0.65,
            
            label = "Return",
            lableColor = { default={1, 1, 1}, over={1, 1, 1, 1} },
            font        = native.systemFontBold,
            fontSize    = 40,
            -- defaultFile = "image/option.png",
            -- overFile    = "image/option_over.png",
            onEvent     = justPressed,
            shape="roundedRect",
            width  = 240,
            height = 80,
            cornerRadius = 9,
            fillColor = { default={ 0.65, 0.65, 0.65, 1 }, over={ 0.65, 0.65, 0.65, 0.4 } },
            strokeColor = { default={ 0.55, 0.55, 0.55, 1 }, over={ 0.35, 0.35, 0.35, 1 } },
            strokeWidth = 2                   
        }
        button.name = "Button_Reutrn"
        button:toFront( )
        --button.anchorX = 0
        screenBlockGroup:insert(button)
        return button

    end

    -----------------------------------------------------------
    -- delete check
    -----------------------------------------------------------
    local function Button_Delete_Yes(del_bookcode,ty)
        -- button event
        local justPressed = function(event)
            if event.phase == "ended" then
                print("ended")

                for i = 1,screenBlockGroup.numChildren do
                    display.remove(screenBlockGroup[1])
                    screenBlockGroup[1] = nil
                end

                print("del_bookcod=",del_bookcode)

                local bookPath = system.pathForFile(del_bookcode..'/',system.DocumentsDirectory )
                local success = lfs.chdir( bookPath )     
                if success then
                    local files             
                    for files in lfs.dir(bookPath) do
                        local file_path = system.pathForFile(del_bookcode..'/'..files,system.DocumentsDirectory)  
                        os.remove(file_path)                        
                    end
        
                    lfs.rmdir(bookPath)                                              
                end

                local thumbPath = system.pathForFile(del_bookcode..'thumb/',system.DocumentsDirectory )
                local success = lfs.chdir( thumbPath )     
                if success then
                    local files             
                    for files in lfs.dir(thumbPath) do
                        local file_path = system.pathForFile(del_bookcode..'thumb/'..files,system.DocumentsDirectory)  
                        os.remove(file_path)                        
                    end
        
                    lfs.rmdir(thumbPath)                                              
                end

                --thumb
                deletef = false

                gProfile.DeleteBook(del_bookcode)
                booksProfile = gProfile.getBooksJSON()
                checkNum = 2
                getbookparameter()
                scene.change_page()
            end
        end

        -- local button = widget.newButton
        -- {
        --     --width  = 0,
        --     --height = 0,
        --     x      = display.contentWidth*0.5,
        --     y      = tab_y*0.5,
            
        --     -- label = "Yes",
        --     -- lableColor = { default={1, 1, 1}, over={1, 1, 1, 1} },
        --     -- font        = native.systemFontBold,
        --     -- fontSize    = 30,
        --     --defaultFile = "image/ic_check_white_48dp.png",
        --     --overFile    = "image/ic_check_grey600_48dp.png",
        --     defaultFile = "button/b_yes.png",
        --     overFile = "button/b_yes.png",
        --     onEvent     = justPressed,
            
        --     width  = 96,
        --     height = 96,
        --     --shape="roundedRect",
        --     -- cornerRadius = 9,
        --     -- fillColor = { default={ 0.65, 0.65, 0.65, 1 }, over={ 0.65, 0.65, 0.65, 0.4 } },
        --     -- strokeColor = { default={ 0.55, 0.55, 0.55, 1 }, over={ 0.35, 0.35, 0.35, 1 } },
        --     -- strokeWidth = 2                   
        -- }

        local xpos = 0
        print("ty===",ty)
        -- if ty == 1 then
        --     xpos = display.contentWidth*0.5 + 140
        -- else
            xpos = display.contentWidth*0.5
        ----end

         local button = widget.newButton
            {
            --width  = 0,
            --height = 0,
            x      = xpos,
            y      = tab_y*0.5, --display.contentHeight*0.65,
            
            label = "Delete",
            lableColor = { default={1, 1, 1}, over={1, 1, 1, 1} },
            font        = native.systemFontBold,
            fontSize    = 40,
            -- defaultFile = "image/option.png",
            -- overFile    = "image/option_over.png",
            onEvent     = justPressed,
            shape="roundedRect",
            width  = 240,
            height = 80,
            cornerRadius = 9,
            fillColor = { default={ 0.65, 0.65, 0.65, 1 }, over={ 0.65, 0.65, 0.65, 0.4 } },
            strokeColor = { default={ 0.55, 0.55, 0.55, 1 }, over={ 0.35, 0.35, 0.35, 1 } },
            strokeWidth = 2                   
        }

        button.name = "Button_Delete"
        button:toFront( )
        --button.anchorX = 0
        screenBlockGroup:insert(button)
        return button
    end
    -----------------------------------------------------------
    --
    -----------------------------------------------------------
    local function covertouch(event)
        --
        -- print("bookRect[event.target.bookcode].isVisible", bookRect[event.target.bookcode].isVisible)
        -- print("event.target.bookcode", event.target.bookcode)

        if bookRect[event.target.bookcode].isVisible == true then
            print("touch book ", event.target.bookcode)

            _inBlock = true

            _touchNO = event.target.bookcode+(_page-1)*_pageSize
        end
    end

    -----------------------------------------------------------
    --  
    -----------------------------------------------------------
    function scene:change_page()

        -- print("WHWHWHWHWHWHW", scrollView.height, scrollView.width, 
        --     scrollView.height/scrollView.width, scrollView.width/scrollView.height)

        -- local _bkH
        -- local _bkW

        -- if scrollView.width/scrollView.height > 0.7 then
        --     _bkH  = scrollView.height*0.33
        --     _bkW  = _bkH*0.7
        -- else
        --     _bkW  = scrollView.width*0.3
        --     _bkH  = _bkW*1.5
        -- end


        local _bkH  = scrollView.height*0.46*0.85
        local _bkW  = _bkH*0.65
        local _bkRH = scrollView.height*0.49
        local _bkRW = scrollView.width*0.20


        -- 畫外框
        for i = 1, _pageSize do
                local w = math.floor((i-1)%5)
                local h = math.floor((i-1)/5) 

            -- 移除原有外框
            if bookRect[i] ~= nil then 
                bookRect[i]:removeEventListener( "touch", covertouch )
                display.remove( bookRect[i] ) 
                bookRect[i] = nil
            end

                bookRect[i] = display.newRoundedRect( _bkRW*0.5 + _bkRW*(w-1)+_bkRW, 
                                                      _bkRH*0.5 + _bkRH*h +10, 
                                                      _bkW, 
                                                      _bkH, 
                                                      1)

            bookRect[i].strokeWidth = 4
            bookRect[i]:setStrokeColor( 0.8 )
            bookRect[i]:setFillColor( 1)
            bookRect[i].bookcode = i
            bookRect[i]:addEventListener( "touch", covertouch )
            scrollView:insert(bookRect[i])

        end


        -- 載入封面
        local add = (_page-1)*_pageSize
        for i=1, _pageSize do

            -- 將舊資料清除
            if coverImage[i] ~= nil then display.remove( coverImage[i] ) coverImage[i] = nil end
            if hint[i]       ~= nil then display.remove( hint[i] ) hint[i] = nil end
            if hintRect[i]   ~= nil then display.remove( hintRect[i] ) hintRect[i] = nil end


            if books[i+add] ~= nil and bookRect[i] ~= nil then

                bookRect[i].isVisible = true

                -- 從資料夾找到封面
                coverImage[i] = display.newImage( books[i+add].bookcode.."thumb/1.png", system.DocumentsDirectory, 
                                                  bookRect[i].x, bookRect[i].y )

                if coverImage[i] ~= nil then
                    print("SSSSSSSSSSSSS", books[i+add].bookcode)
                    
                    -- coverImage[i].height = scrollView.height*0.3*0.9
                    -- coverImage[i].width  = coverImage[i].height*0.7
                    -- bookRect[i].width  = coverImage[i].width + 20
                    -- bookRect[i].height = coverImage[i].height + 20   


                    coverImage[i].alpha  = 0

                    coverImage[i].height = bookRect[i].height - 20
                    coverImage[i].width  = bookRect[i].width - 20 


                    --transition.to( coverImage[i], { time=1000, alpha = 1.0 } )
                    if books[i+add]["expired"] == "false" then
                    
                        transition.to( coverImage[i], { time=1000, alpha = 1.0 } )
                    else

                        transition.to( coverImage[i], { time=1000, alpha = 0.2 } )
                    end

                    scrollView:insert(coverImage[i])
                

                    -- 到期時間
                    local temp = os.date("*t",tonumber(books[i+add].expirytime)/1000)
                    -- local hint = display.newText( "Until "..os.date("%c",tonumber(books[i+add].expirytime)), 
                    --                            100, 200, native.systemFont, 20 )
                    
                   if books[i+add].expired == "false" then
                        hint[i] = display.newText( "Until ".. temp.year .. "-" .. temp.month .. "-" .. temp.day, 
                                                      100, 200, native.systemFont, 25 )
                        hint[i]:setFillColor(1)
                    else
                        hint[i] = display.newText( "Returned", 
                                                      100, 200, native.systemFont, 25 )
                        hint[i]:setFillColor(1)
                    end
                    hint[i].x = bookRect[i].x
                    hint[i].y = bookRect[i].y + bookRect[i].height*0.5 - hint[i].height*0.5
                
                    hintRect[i] = display.newRect( hint[i].x, hint[i].y, bookRect[i].width, hint[i].height )
                    hintRect[i].strokeWidth = 3
                    if books[i+add].expired == "false" then
                       hintRect[i]:setFillColor( 0 )
                       hintRect[i]:setStrokeColor( 0 )  
                    else
                        hintRect[i]:setFillColor( 1,0,0 )
                        hintRect[i]:setStrokeColor( 1,0,0 ) 
                    end
                    --hintRect[i]:setStrokeColor( 0 )     
                    hintRect[i].alpha = 0.65

                    scrollView:insert(hintRect[i])
                    scrollView:insert(hint[i])
                end

            else
                -- 沒有載入書本的 外框就不顯示
                bookRect[i].isVisible = false

            end

        end

    end

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
        local blockRect = display.newRect( _x*0.5,
                                           _y*0.5, 
                                           _x - 2*display.screenOriginX, 
                                           _y - 2*display.screenOriginY)
        blockRect:setFillColor( 0 )
        blockRect.alpha = 0.7
        --transition.to( blockRect, { time=100, alpha=0.7 } )
        blockRect:addEventListener( "touch", screentouch )
        screenBlockGroup:insert(blockRect)
    
    end

     -----------------------------------------------------------
    --  return選項
    -----------------------------------------------------------
    local function returnBook(bookNO)
        Runtime:removeEventListener( "enterFrame", checkLongClickFn )
       ScreenBlock()
       Button_Delete_No()
        Button_Return_Yes(books[bookNO].bookcode)
        -- do you like to remove (book name) from the bookshelf? 
        -- Do you really want to return this book?
        local deleteMessage = display.newText( "Do you like to return this book from the bookshelf ?", 
                      tab_x*0.5, tab_y*0.3, 
                      display.contentWidth*0.75, 0,
                      native.systemFontBold, 50)
        deleteMessage:setFillColor( 1 ) screenBlockGroup:insert(deleteMessage)


    end

    -----------------------------------------------------------
    --  
    -----------------------------------------------------------
    local function deleteBook(bookNO)

        ScreenBlock()
        Button_Delete_No()
        Button_Delete_Yes(books[bookNO].bookcode)

        local deleteMessage = display.newText( "Do you like to remove this book from the bookshelf ?", 
                      display.contentWidth*0.5,
                      tab_y*0.3, 
                      display.contentWidth*0.75, 0,
                      native.systemFontBold, 50)
        deleteMessage:setFillColor( 1 ) screenBlockGroup:insert(deleteMessage)



    end


    -----------------------------------------------------------
    --  
    -----------------------------------------------------------
    local MSGtext = nil
    local Show_Title = nil
    
    local function ShowMessage( bookNO )
        
        local fontSize = 40
        -- print("books[_touchNO].bookcode", books[bookNO].bookcode)
        -- print("books[_touchNO].title", books[bookNO].title)
        -- print("books[_touchNO].year", books[bookNO].year)
        -- print("books[_touchNO].publisher", books[bookNO].publisher)
        -- print("books[_touchNO].page", books[bookNO].page)
        -- print("books[_touchNO].author", books[bookNO].author)
        --display.newText( [parentGroup,], text, x, y, [width, height,], font, fontSize )

        if Show_Mata["title"] ~= nil then display.remove(Show_Mata["title"]) Show_Mata["title"] = nil end
        Show_Mata["title"] = display.newText( books[bookNO].title, 
                                      tab_x*0.15, tab_y*0.15, 
                                      display.contentWidth*0.8, 0,
                                      native.systemFontBold, fontSize + 10)

        gBookInfo["title"] = books[bookNO].title

       
        if Show_Mata["title"].height > 415 then
            display.remove(Show_Mata["title"]) 
            Show_Mata["title"] = nil
            Show_Mata["title"] = display.newText( books[bookNO].title, 
                                      tab_x*0.15, tab_y*0.15, 
                                      display.contentWidth*0.8, 0,
                                      native.systemFontBold, fontSize + 5)
        end
         Show_Mata["title"]:setFillColor(1)     screenBlockGroup:insert(Show_Mata["title"])
        Show_Mata["title"].anchorY = 0 Show_Mata["title"].anchorX = 0
        print("Show_Mata[title].height=",Show_Mata["title"].height)
        if Show_Mata["author"] ~= nil then display.remove(Show_Mata["author"] ) Show_Mata["author"]  = nil end
        Show_Mata["author"] = display.newText( books[bookNO].author, 
                                      tab_x*0.15, Show_Mata["title"].y + Show_Mata["title"].height + fontSize, 
                                      display.contentWidth*0.5, 0,
                                      native.systemFontBold, fontSize )
        gBookInfo["author"] = books[bookNO].author
        Show_Mata["author"] :setFillColor(1)     screenBlockGroup:insert(Show_Mata["author"] )
        Show_Mata["author"].anchorY = 0 Show_Mata["author"].anchorX = 0

        if Show_Mata["publisher"] ~= nil then display.remove(Show_Mata["publisher"] ) Show_Mata["publisher"]  = nil end
        Show_Mata["publisher"] = display.newText( books[bookNO].publisher .. ",  " .. books[bookNO].year, 
                                      tab_x*0.15, Show_Mata["author"].y + Show_Mata["author"].height + fontSize, 
                                      display.contentWidth*0.5, 0,
                                      native.systemFontBold, fontSize )
        gBookInfo["publisher"] = books[bookNO].publisher
        Show_Mata["publisher"] :setFillColor(1)     screenBlockGroup:insert(Show_Mata["publisher"] )
        Show_Mata["publisher"].anchorY = 0 Show_Mata["publisher"].anchorX = 0

        -- if Show_Mata["year"] ~= nil then display.remove(Show_Mata["year"] ) Show_Mata["year"]  = nil end
        -- Show_Mata["year"] = display.newText( "Year  ", 
        --                            tab_x*0.15, Show_Mata["publisher"].y + Show_Mata["publisher"].height + fontSize, 
        --                            display.contentWidth*0.5, 0,
        --                            native.systemFontBold, fontSize )
        -- Show_Mata["year"] :setFillColor(1)     screenBlockGroup:insert(Show_Mata["year"] )
        -- Show_Mata["year"].anchorY = 0 Show_Mata["year"].anchorX = 0

        if Show_Mata["page"] ~= nil then display.remove(Show_Mata["page"] ) Show_Mata["page"]  = nil end
        Show_Mata["page"] = display.newText( "Page  "..books[bookNO].page, 
                                      tab_x*0.15, Show_Mata["publisher"].y + Show_Mata["publisher"].height + fontSize, 
                                      display.contentWidth*0.5, 0,
                                      native.systemFontBold, fontSize )
        gBookInfo["page"] = books[bookNO].page
        Show_Mata["page"] :setFillColor(1)     screenBlockGroup:insert(Show_Mata["page"] )
        Show_Mata["page"].anchorY = 0 Show_Mata["page"].anchorX = 0

        --gLastPage = tonumber(books[bookNO].lastpage)
        
        Button_Close()
        Button_Read(books[bookNO].bookcode, books[bookNO].page)
    end

    local function checkLongClickFn(e)
        --計算長按的時間是否超過 1 sec
        if _inBlock == true then
                local timeHeld = os.time() - pressTimer
                print("timeheld==",timeHeld)
                print("isBlock=",_inBlock)
                print("_moving",_moving)
            if timeHeld >= 1.2 then
                    
                    if _moving == false then
                        print("本書是否過期===",booksProfile[_touchNO+1].expired)
                        if booksProfile[_touchNO+1].expired == "false" then
                            --deleteBook(_touchNO,1)
                            checkBookCode = booksProfile[_touchNO+1].bookcode
                            checkDownloadCode = getDownloadCode(checkBookCode)
                            returnBook(_touchNO)
                        else
                            deleteBook(_touchNO,2)
                        end
                        deletef = true
                    end
                    Runtime:removeEventListener( "enterFrame", checkLongClickFn )
            end
        end
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
                pressTimer = os.time()
                _moving  = false
                Runtime:addEventListener( "enterFrame", checkLongClickFn )
            elseif "moved" == phase then
                print( "Moved" )

                _moving  = true
                _inBlock = false
                Runtime:removeEventListener( "enterFrame", checkLongClickFn )
            elseif "ended" == phase then
                print( "Ended", _moving, _inBlock)

                -- 計算長按的時間是否超過 1 sec
                --local timeHeld = os.time() - pressTimer
                -- if timeHeld >= 1.2 and _inBlock == true then
                --     --print("Held for 1.2 sec or longer, do something")
                --     if _moving == false then
                --         deleteBook(_touchNO)
                --     end

                -- elseif _moving == false and _inBlock == true then
                if _moving == false then 
                    print("deletef=",deletef)
                    if _inBlock == true then
                        if deletef == false then
                            pressTimer = os.time()
                           if books[_touchNO].expired == "false" then
                               ScreenBlock()
                               ShowMessage(_touchNO)
                            end
                           Runtime:removeEventListener( "enterFrame", checkLongClickFn )
                        end
                    else
                        pressTimer = os.time()
                        Runtime:removeEventListener( "enterFrame", checkLongClickFn )
                    end

                elseif _moving == true then
                    print("scrolling")
                end
                pressTimer = os.time()
                _moving  = false 
                _inBlock = false 
                Runtime:removeEventListener( "enterFrame", checkLongClickFn )
            end
            
            -- If the scrollView has reached it's scroll limit
            if event.limitReached then
                if "up" == direction then
                    print( "Reached Top Limit" )
                elseif "down" == direction then
                    print( "Reached Bottom Limit" )
                elseif "left" == direction then
                    print( "Reached Left Limit" ) 
                    --print(#books)

                    -- next page
                    if #books > _pageSize*_page then
                        _page = _page+1
                        scene.change_page()
                    end


                elseif "right" == direction then
                    print( "Reached Right Limit" )
                    --print(#books)

                    -- last page
                    _page = _page-1
                    if _page < 1 then _page = 1 end
                    scene.change_page()

                end
            end

            return true
        end

        --
    	scrollView = widget.newScrollView
    	{
            left   = display.screenOriginX ,
            top    = display.screenOriginY + gNaviBar.getNaviBarHeight()*1 + display.topStatusBarContentHeight,
            width  = display.contentWidth  - 2*display.screenOriginX,
            height = display.contentHeight - 2*display.screenOriginY- 1*gNaviBar.getNaviBarHeight() - display.topStatusBarContentHeight,         
    	

    		id     = "RentScrollView",
    		hideBackground = true,
    		horizontalScrollDisabled = false,
    	    verticalScrollDisabled   = false,
    		--maskFile = "image/searchBG.png",
    		listener = scrollListener,
    	}
    end


	-----------------------------------------------------------
	--
	-----------------------------------------------------------
	function scene:create(event)
		print( "==================== view setting create event ====================" )
        local bg = display.newImage(  "image/igpbg.png" ,system.ResourceDirectory,true  )
            bg.x = display.contentWidth*0.5
            bg.y = bg.height*0.5
        createview()
		viewGroup = self.view
        viewGroup:insert(bg)
		viewGroup:insert(scrollView)
		
		-- -- add background
		-- local backgroundImage = display.newRect(0, 
		-- 	                                    0,
		-- 	                                    scrollView.width, 
  --                                               scrollView.height )
  --       backgroundImage.x = display.contentWidth*0.5 - display.screenOriginX
  --       backgroundImage.y = backgroundImage.height*0.5
		-- backgroundImage:setFillColor( 0.5, 0.5, 0.5 )
		-- scrollView:insert(backgroundImage)

  --       -- NaviBar 這個 global 變數在 main.lua
  --       gNaviBar.icoShowSearch(false)
  --       gNaviBar.icoShowOption(true)
	end

	-----------------------------------------------------------
	--
	-----------------------------------------------------------
	function scene:show(event)
        print("event.phase===",event.phase)
		if event.phase == "will" then
			print("====================  view setting HHH will show ====================")

            viewGroup.isVisible = true

            -- add background

            -- local backgroundImage = display.newRect(0, 
            --                                         0,
            --                                         scrollView.width, 
            --                                         scrollView.height )
            -- backgroundImage.x = display.contentWidth*0.5 - display.screenOriginX
            -- backgroundImage.y = backgroundImage.height*0.5
            -- backgroundImage:setFillColor(1 )
            -- local backgroundImage = display.newImage(  "image/igpbg.jpg" ,system.ResourceDirectory,true  )
            -- backgroundImage.x = display.contentWidth*0.5 - display.screenOriginX
            -- backgroundImage.y = backgroundImage.height*0.5
            -- scrollView:insert(backgroundImage)

            -- NaviBar 這個 global 變數在 main.lua
            -- gNaviBar.icoShowSearch(false)
            -- gNaviBar.icoShowOption(true)


            rota_composer = "scene_bookshelf"

            -- if gUrlText ~= nil then
            --     gUrlText:toFront()
            --     gUrlText:setFillColor( 0, 1 ,1 )
            -- end
            print("hhhhhhhhh")
            booksProfile = gProfile.getBooksJSON()
            checkNum = 2
            getbookparameter()
            --scene.change_page()
		end
		if event.phase == "did" then
			print("====================  view setting HHH did show ====================")
			--
            local currScene = composer.getSceneName( "current" )
            print("currScenehhhhh :", currScene)
            local prevScene = composer.getSceneName( "previous" )
            print("previoushhhh :", prevScene)
            local overlayScene = composer.getSceneName( "overlay" )
            print("overlayhhhhh :", overlayScene)

			if prevScene ~= nil and prevScene ~= currScene then
                print("remove scenehhhh", prevScene)
				composer.removeScene(prevScene) -- call scene destory function
			end
		end
	end

	-----------------------------------------------------------
	--
	-----------------------------------------------------------
	function scene:hide( event )
			if event.phase == "will" then
			print("====================  view setting HHH will hide ====================")
            viewGroup.isVisible = false
		end
		if event.phase == "did" then
            Runtime:removeEventListener( "enterFrame", checkLongClickFn )
			print("====================  view setting HHH did hide ====================")
		end
	end

	-----------------------------------------------------------
	--
	-----------------------------------------------------------
	function scene:destroy( event )
		print("====================  view setting HHH destroy event ====================")

		-- for i = 1,viewGroup.numChildren do
		-- 	local ch = viewGroup[1]
		-- 	if ch ~= nil and ch.numChildren > 0 then 
		-- 		for j=1, ch.numChildren do
		-- 			display.remove( ch[1] )
		-- 			ch[1] = nil
		-- 		end
		-- 	end	

		-- 	display.remove(viewGroup[1])
		-- 	viewGroup[1] = nil
		-- end
        display.remove(viewGroup)
        viewGroup = nil
		for i = 1,screenBlockGroup.numChildren do
			display.remove(screenBlockGroup[1])
			screenBlockGroup[1] = nil
		end

	end


scene:addEventListener( "create", scene )
scene:addEventListener( "show", scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )
return scene