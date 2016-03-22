local widget = require( "widget" )
local composer = require("composer")

-- local MenuDlg = require "menudlg"
-- local CategoryDlg = require "categoriesdlg"
module(..., package.seeall)


    ---------------------------[[ Global variable]]---------------------------
    local naviBarGroup = display.newGroup() -- 把 local 拿掉就變成整支專案都看得到的全域
    
    local _naviBarHeight = 55  function getNaviBarHeight() return _naviBarHeight end
    local _Btn_SizeW
    local _Btn_SizeH
    local _menuShowFlag = false -- 控制顯示的 flag

    local Btn_Menu   = nil
    local Btn_Search = nil
    local Btn_Pause  = nil

    local menudlg
    local categoriesdlg
    local blockRect  = nil

    -----------------------------------------------------------
    --  搜尋框的 收合
    -----------------------------------------------------------
    function CategroyBlockCtrl(status)
        -- sf 是搜尋框 的輸入元件
        local sf = CategoryDlg.getSearchField() 

        if categoriesdlg.x == 0 or status == "close" then
            blockRect.isVisible = false
            --sf.isVisible = true
            transition.to( sf, { time=300, x = categoriesdlg.width*2,  transition=easing.linear } )
            transition.to( categoriesdlg, { time=300, x = categoriesdlg.width*2,  transition=easing.linear } )           
        else
            blockRect.isVisible = true
            blockRect:toFront( )
            --sf.isVisible = true
            categoriesdlg:toFront( )
            sf:toFront( )
            transition.to( sf, { time=300, x =  20+categoriesdlg.width*0.5,  transition=easing.linear } )
            transition.to( categoriesdlg, { time=300, x = 0,  transition=easing.linear } )
        end

        --print("sf.xsf.xsf.xsf.xsf.x", sf.x)
    end

    -----------------------------------------------------------
    --  search 選單的按鈕
    -----------------------------------------------------------
    local function Button_Category_Dlg()
        
        local bg = display.newRect( 0, 0, _Btn_SizeW, _Btn_SizeH )
        bg:setFillColor( 0.3 )
        
        naviBarGroup:insert( bg )

        -- button event
        local justPressed = function(event)
            if event.phase == "began" then
                --print( "ended")
                event.target.bg.alpha = 0.5

            end

            if event.phase == "ended" then
                print( "ended")
                event.target.bg.alpha = 0

                CategroyBlockCtrl()
            end
        end

        -- button style
        local button = widget.newButton
        {
            width  = _Btn_SizeW,
            height = _Btn_SizeH,
            x      = display.contentWidth - _Btn_SizeW*0.5 - display.screenOriginX,
            y      = _Btn_SizeH*0.5 + display.screenOriginY,
            
            -- label = "Type",
            -- lableColor = { default={1, 0, 1}, over={0, 0, 0, 1} },
            font        = native.systemFontBold,
            -- fontSize    = 50,
            defaultFile = "button/ic_search_white_48dp.png",
            overFile    = "button/ic_search_white_48dp.png",
            onEvent     = justPressed
        }

        button.bg = bg
        button.name = "ButtonSearch"
        
        naviBarGroup:insert(button)

        bg.alpha = 0
        bg.x = button.x
        bg.y = button.y

        return button
    end

    -----------------------------------------------------------
    -- menu 選單顯示控制
    -----------------------------------------------------------
    function MenuBlockCtrl(status)

        if menudlg.x ~= 0 and status ~= "close" then 
            
            blockRect.isVisible = true
            blockRect:toFront( )
            Button_Menu_Dlg("button/b_menu02.png")
            menudlg:toFront()
            transition.to( menudlg, { time=300, x = 0,  transition=easing.linear } )
       
        else

            blockRect.isVisible = false
            Button_Menu_Dlg("button/b_menu01.png")
            transition.to( menudlg, { time=300, x = -1*menudlg.width,  transition=easing.linear } )
        end
    end

    -----------------------------------------------------------
    -- menu 選單按鈕
    -----------------------------------------------------------
    function Button_Menu_Dlg(FileName)
        
        local function touch(event)
            if event.phase == "began" then
                --print( "began" )
            elseif event.phase == "moved" then
                --print("moved")
            elseif event.phase == "ended"   then
                --print( "ended")
                MenuBlockCtrl()
            end
            return true
        end

        if Btn_Menu ~= nil then display.remove( Btn_Menu ) Btn_Menu = nil end
        Btn_Menu  = display.newImage(FileName)
        Btn_Menu.height = _Btn_SizeW
        Btn_Menu.width  = _Btn_SizeW

        Btn_Menu.height = _Btn_SizeW
        Btn_Menu.width  = _Btn_SizeW

        Btn_Menu.x = _naviBarHeight*0.5 + display.screenOriginX
        Btn_Menu.y = _naviBarHeight*0.5 + display.screenOriginY

        Btn_Menu:addEventListener( "touch", touch )
        naviBarGroup:insert(Btn_Menu)
    end

    -----------------------------------------------------------
    --  logo
    -----------------------------------------------------------
    local function logoOnNavBar()
        local logo = display.newImage( "image/mainlogo.png" )
        logo.x = 0 + display.screenOriginX-- _Btn_SizeW + display.screenOriginX
        logo.y = _naviBarHeight*0.5 + display.screenOriginY
        
        logo.width = logo.width*(_naviBarHeight/logo.height)
        logo.height = _naviBarHeight

        --print( "logo.width" , logo.width)
        logo.anchorX = 0
        naviBarGroup:insert(logo)
    end

    -----------------------------------------------------------
    --  
    -----------------------------------------------------------
    local function Button_download()
        local function touch(event)
            if event.phase == "ended" then
                local inputWidth = gInputGroup[2].width - 200--display.pixelWidth*0.8
                local yshift = 0 - 40 - 150
                local fontSize = 60
                local num = gSystem.calculateSize( )
            
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
                gInputGroup.isVisible = true
                gInputGroup[3].waitf = false
                --gInputGroup[5].waitf = false
                gInputGroup:toFront( )
                gNoBtn.isVisible = true
                gNoBtn:toFront( )
                gNoBtn.x = gNoBtn.width*0.5 + display.screenOriginX + 40
                gNoBtn.y = gNoBtn.height*0.5 + display.screenOriginY + 60
                gTransOver = false
                print("2222222222222222222")
            end
        end
        Btn_download  = display.newImage("button/b_add.png")
        Btn_download.height = _Btn_SizeW
        Btn_download.width  = _Btn_SizeW

        Btn_download.x = display.contentWidth - display.screenOriginX - Btn_download.contentWidth*0.5-20
        Btn_download.y = _naviBarHeight*0.5 + display.screenOriginY

        Btn_download:addEventListener( "touch", touch )
        naviBarGroup:insert(Btn_download)
    end


    -----------------------------------------------------------
    --  半透明深色的遮罩，讓 user 無法點選後面的東西
    -----------------------------------------------------------    
    local function Block_Background()
        local function screentouch( event )
            if event.phase == "began" then
                print( "began" )
            elseif event.phase == "moved" then
                --print("moved")
            elseif event.phase == "ended"   then
                print( "ended")
                CategroyBlockCtrl("close")
                MenuBlockCtrl("close")
            end
            return true           
        end

        -- 
        blockRect = display.newRect( display.contentWidth*0.5,
                                     0,
                                     display.contentWidth-2*display.screenOriginX, 
                                     display.contentHeight-2*display.screenOriginY)
        
        blockRect.y = display.topStatusBarContentHeight + _naviBarHeight + display.screenOriginY
        blockRect.anchorY = 0
        blockRect:setFillColor( 0 )
        blockRect.alpha = 0.5
        blockRect:addEventListener( "touch", screentouch )

        blockRect.isVisible = false
    end

    -----------------------------------------------------------
    --  畫出 導覽列
    -----------------------------------------------------------    
    function navibarDraw()
        deviceSize = gSystem.calculateSize( )
        if     deviceSize > 8 then  _naviBarHeight = 55
        elseif deviceSize > 6 then  _naviBarHeight = 88
        else                        _naviBarHeight = 120 end

        _Btn_SizeW = _naviBarHeight
        _Btn_SizeH = _naviBarHeight

        local naviBar = display.newRect(0, 0, display.contentWidth-2*display.screenOriginX, _naviBarHeight)

        naviBar.x = display.contentWidth*0.5
        naviBar.y =  _naviBarHeight*0.5 + display.screenOriginY
        
        naviBar:setFillColor(0.203)
        naviBar.name = "naviBar"
        naviBarGroup:insert( naviBar )

        naviBarGroup.y = display.topStatusBarContentHeight

        -- 遮罩
        Block_Background()
        
        -- 導覽列上面的各個按鈕
        logoOnNavBar()
        -- Button_Menu_Dlg("button/ic_menu_white_48dp.png")
        --Btn_Search = Button_Category_Dlg()
        Button_download()



        -- 建立兩側的 Dialog，並讓位置預先藏在畫面外
        -- menudlg         = MenuDlg.drawMenuDialog(naviBarGroup.y)
        -- categoriesdlg   = CategoryDlg.drawCategoryDialog(naviBarGroup.y)
        -- menudlg.x       = -1*menudlg.width
        -- categoriesdlg.x = categoriesdlg.width*2

    end

    -----------------------------------------------------------
    --
    -----------------------------------------------------------    
    function navibarDelete()

        --
        -- MenuDlg.deleteMenuDialog()
        -- CategoryDlg.deleteCategoryDialog()

        --
        if blockRect ~= nil then display.remove( blockRect ) end

        print("naviBarGroup.numChildrennaviBarGroup.numChildren", naviBarGroup.numChildren)
        for i = 1,naviBarGroup.numChildren do

            if naviBarGroup[i] ~= nil then
                local ch = naviBarGroup[i]
                -- print("chchchchchch", ch)
                -- print("ch.numChildrench.numChildren", ch.numChildren)
                if ch.numChildren ~= nil then 
                    for j=1, ch.numChildren do
                        display.remove( ch[1] )
                        ch[1] = nil
                    end
                end
            end

            display.remove(naviBarGroup[1])
            naviBarGroup[1] = nil
        end
        print("naviBarGroup.numChildrennaviBarGroup.numChildren", naviBarGroup.numChildren)

    end

    -----------------------------------------------------------
    --  控制在 navibar 上面的按鈕是否要顯示
    -----------------------------------------------------------
    function icoShowSearch(status)
        Btn_Search.isVisible = status
    end
    function icoShowOption(status)
        Btn_Menu.isVisible = status
        if status == false then
            Btn_Pause.isVisible = true
        else
            Btn_Pause.isVisible = false
        end
    end
    function NaviBarShow( status )
        naviBarGroup.isVisible = status
    end