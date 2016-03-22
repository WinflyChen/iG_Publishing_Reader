--[[ comment ]]-- 

--os.execute('clear') -- linux/mac
--os.execute('cls')   -- windows

--display.setStatusBar( display.HiddenStatusBar )
display.setStatusBar( display.DefaultStatusBar)
local composer = require("composer")
local Process  = require( "proc_download_number")
local Process2 = require("proc_download")
local widget   = require( "widget" )
local sysFunction = require("systeminfo")

print("-------------------------------------------------------------")
print("Device Resolution:")
print("display.pixelWidth  = " .. tostring (display.pixelWidth))
print("display.pixelHeight = " .. tostring (display.pixelHeight))
print("display.contentWidth  = " .. tostring (display.contentWidth))
print("display.contentHeight = " .. tostring (display.contentHeight))
print("display.screenOriginY = " .. display.screenOriginY)
print("display.screenOriginX = " .. display.screenOriginX)
print("-------------------------------------------------------------")

--------------------------------------------------------------
local wetools = require("wetools")
--physics = require("physics")
pleft = 1
system.setTapDelay( 0.1 )
pright = 0
p1 = 1
p2 = 0

-- local showText1 = display.newText( "", 200, 400, native.systemFontBold, 30 )
 local options = 
                {
                            --parent = groupObj,
                    text ="",     
                    x = 0,
                    y = -150,
                    width = 1200,            --required for multiline and alignment
                    height = 250,           --required for multiline and alignment
                    font = native.systemFontBold,   
                    fontSize = fontSize,
                    align = "center"          --new alignment field
                }

    --local showText1 = display.newText( options)
-- local showText2 = display.newText( "", 0, 0, native.systemFontBold, 30 )
-- local showText3 = display.newText( "", 0, 0, native.systemFontBold, 30 )
-- local showText4 = display.newText( "", 0, 0, native.systemFontBold, 30 )

rate = 0 ----最小尺寸
nowrate = 1 --目前尺寸
maxrate = 3.5---最大尺寸
targetrate = 0
maxPage = 10

loadInfo = {}

pageList2 = {}
--bookmark = wetools.creatonelist(0,maxPage)
_W = display.contentWidth * 0.5
_H = display.contentHeight * 0.5 
_X = display.contentCenterX
_Y = display.contentCenterY
setupf = true
setupFirst = true
statusbarHeight = display.topStatusBarContentHeight

optionf = true  --開啟功能列
scalef = false  --放大狀態
gNetworkStatus = false

flipType = 0 --0是關閉，1是開啟

oldflipType = 0
gTimeLimit = ""
optionItemf = false --功能列細項
scrOrgx = display.screenOriginX
scrOrgy = display.screenOriginY
baseDir = system.DocumentsDirectory
resDir = system.ResourceDirectory
gResumef = false
gOrientf = false
gPubid = ""
gDocid = ""
gDownloadTpye = 1
gTransf = false --偵測是否轉向
gEnterBookf = false
gJSON_convertstatus = ""
gLastPage = 1
gInputWidth = 400
loadingBtn = nil
gWarning = nil
gNoBtn = nil
gTransOver = false
checkover = 0
checkThumbOver = 0
gBookInfo = {}
gNowPrecent = 0
gLoading = false
gFirstEnterBook = false
choice_bookcode = ""
gKeyList = {'A','a','B','b','C','c','D','d','E','e','F','f','G','g','H','h','I','i','J','j','K','k','L','l','M','m','N','n','O','o','P','p','Q','q','R','r','S','s','T','t','U','u','V','v','W','w','X','x','Y','y','Z','z','0','1','2','3','4','5','6','7','8','9','-'}
print("gKeyList[1]==",gKeyList[1])

gBackToScale = false
gWifi = false
gDeviceID = system.getInfo("deviceID")
gCode = ""
gBookCode = "" --抓verify 用的
--gInputY = 0
--currentOrientation = system.orientation
--oldorientation = "portrait"
--------------------------------------------------------------
gInputGroup = display.newGroup( )
gNaviBar = require "navibar"
gSystem  = require "systeminfo"
gProfile = require "bookprofile"

--gProfile = require "profile"
g_curr_Dir = system.orientation
g_old_Dir  = system.orientation--"portrait"
gUrl = ""
gUrlText   = display.newText("novalue", 
                              display.contentWidth*0.5, display.contentHeight * 0.5, 
                              display.contentWidth*0.5, display.contentHeight * 0.5, 
                              native.systemFont, 38 )

local changeSceneEffectSetting = 
{
    effect = "crossFade", -- 以什麼方式進入下個畫面的設定
    time = 300, -- 0.3 sec
}



local qrscanner = require('plugin.qrscanner')

--local function listener(message)
    
--end






-- local scanButton = widget.newButton {
--     x = rect.x, y = rect.y,
--     width = 75, height = 50,
--     label = 'Scan',
--     onRelease = function()
--         print('Showing QR')
--         qrscanner.show(listener)
--     end}


------------------------------------------------------------
--  程式初始化判斷
------------------------------------------------------------
gProfile.initial_bookprofile()

--gSystem.sys_info()

------------------------------------------------------------
--  
------------------------------------------------------------
function sceneVHCtrl(scenename)
    if system.orientation ~= "landscapeLeft" and system.orientation ~= "landscapeRight" then
        composer.gotoScene(scenename, changeSceneEffectSetting)
    else
        local currScene = composer.getSceneName( "current" )
            if currScene ~= "hpage" and  currScene ~= "trans" then
                composer.gotoScene(scenename.."_h", changeSceneEffectSetting)
            else
                print("bbbbbbbbb")
                --composer.gotoScene( "trans" )
            end
    end
end 

------------------------------------------------------------
-- 畫出導覽列並前往 scene
------------------------------------------------------------
local function drawBar()
    gNaviBar.navibarDelete()
    gNaviBar.navibarDraw()

    -- [Debug]測試時保留下面這行
    --gUrlText.text = "igpreader://license.acs.igpublish.com/igpspot:55dcf13e77914071b22fc40204e4cb8ea383ae029304427698be07106bf133c3:20a3d22364724db68a1cce084113d1d1:1447152093"


    print("gUrlText = ", gUrlText.text, gUrlText.text:sub( 0, 12 ), math.random())

    -- if bb ~= nil then display.remove( bb ) bb = nil end
    --  bb = display.newText( gUrlText.text:sub( 0, 9 ), 
    --                                   480, 640, 
    --                                   display.contentWidth*0.75, 0,
    --                                   native.systemFontBold, 60)
    --  bb:setFillColor(1, 0, 0)      

    gUrlText.isVisible = false
    --
    --if gUrlText.text:sub( 0, 12 ) == "igpreader://" then
        --print("ttttttttttttttt")
        --sceneVHCtrl("scene_download") 
    --else
        --sceneVHCtrl("scene_download")
       
            sceneVHCtrl("scene_bookshelf")
        
    --end

end


------------------------------------------------------------
--  APP開啟時 抓取 URL 資訊
--  event.url pattern : 
--  igpreader://serverip/ticket/spotkey/expiration
------------------------------------------------------------
--local launchURL = "igpreader://211.75.254.216/igpspot/:e18205939abe42f1a57ca5d07146c8cff66f8b04eff64fbba0827d0c11811683:02d60288072046558c8e771f658fc8ba:1420041600"
--local launchURL = "igpreader://license.acs.igpublish.com/igpspot/:5d8de08dd9704428b31c6a6a8704884ba76d2299bcf7471b9d59d709feabe8c6:4621813f3c0047eba3e7dd58ccd818e9:1430418498"
local function onSystemEvent( event )
    print( "yourapp: onSystemEvent [" .. tostring(event.type) .. "] URL: " .. tostring(event.url) )
        



    if event.type == "applicationSuspend" then
        --native.requestExit();
        -- local options2 = 
        -- {
        --     text = "applicationSuspend",
        --     x = display.contentWidth*0.5,
        --     y = 350,
        --     width = display.contentWidth*0.5,     --required for multi-line and alignment
        --     font = native.systemFont,
        --     fontSize = 38
        -- }
        -- if gUrlText ~= nil then display.remove( gUrlText ) end
        -- gUrlText = display.newText( options2 )
        -- gUrlText:setFillColor(1, 0, 0)

   
    elseif event.type == "applicationOpen" and event.url then
        -- Prints all launch arguments
        --printTable(event)

        -- local iniCome = display.newText("applicationOpen"..math.random(), display.contentWidth*0.5, 600, native.systemFont, 38 )
        -- iniCome:setFillColor( math.random(), math.random(), math.random() )
        
        launchURL = event.url

        print( launchURL )  -- output: coronasdkapp://mycustomstring
        
        local options2 = 
        {
            text = launchURL,
            x = display.contentWidth*0.5,
            y = 350,
            width = display.contentWidth*0.5,     --required for multi-line and alignment
            font = native.systemFont,
            fontSize = 38
        }
        if gUrlText ~= nil then display.remove( gUrlText ) end
        gUrlText = display.newText( options2 )
        gUrlText:setFillColor(1, 0 , 0)
        



        drawBar()

    elseif event.type == "applicationResume" then
        
        -- 這邊原本有些 debug 用的 code，不過後來被上面的 drawBar() 取代，若有要檢查，可以看舊版本
        if(composer.getSceneName("current") == "hpage" and gOrientf == false) then
            gResumef = true
            onResume( event.type )
        end
    else
        print("event.type ==", event.type)
        drawBar()
    end


    
    -- print("event.url", event.url)
    -- if event.url == nil then 
    --     gUrlText.text = "no event url"
    -- else 
    --     gUrlText.text = "SSSSSPPPP" .. event.url 
    -- end
    
end


Runtime:addEventListener( "system", onSystemEvent )


local function changeInputPos()

end
-----------------------------------------------------------
--  直向橫向判斷
-----------------------------------------------------------
function onOrientationChange( event )
   
    g_curr_Dir = event.type

    --
    if g_curr_Dir == "faceUp" or g_curr_Dir == "faceDown" then
        g_curr_Dir = g_old_Dir
        --currentOrientation = oldorientation
        --oldorientation = g_old_Dir
    end
    
    --currentOrientation = g_curr_Dir
    --oldorientation     = g_old_Dir
    
    -- local msg1 = display.newText( ("old = ".. g_old_Dir), 300, 200, native.systemFont, 60 )
    --  msg1:setFillColor(0)
    --  local msg2 = display.newText( ("new = ".. g_curr_Dir), 300, 300, native.systemFont, 60 )
    --  msg2:setFillColor(0)

    --
    print("rota_composer=",rota_composer)
    if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
        if g_old_Dir == "portrait" or g_old_Dir == "portraitUpsideDown" then

            g_old_Dir = g_curr_Dir
            --oldorientation = g_curr_Dir
            
            gNaviBar.navibarDelete()
            gNaviBar.navibarDraw()
            print("=========turn lands============")
            --
            --DrawBackground()

            if  composer.getSceneName("current") ~= "hpage" 
            and composer.getSceneName("current") ~= "hpage_online" 
            and composer.getSceneName("current") ~= "trans" then
                composer.gotoScene(rota_composer.."_h", changeSceneEffectSetting)
            end
            if composer.getSceneName( "current" ) == "hpage" and gResumef == false then
                gOrientf = true
                vtoh()
            end

        end
    
    elseif g_curr_Dir == "portrait" or g_curr_Dir == "portraitUpsideDown" then
        if g_old_Dir == "landscapeLeft" or g_old_Dir == "landscapeRight" then

            g_old_Dir = g_curr_Dir
            --oldorientation = g_curr_Dir
            gNaviBar.navibarDelete()
            gNaviBar.navibarDraw()
            print("=========turn protrait============")
            --DrawBackground()
            if  composer.getSceneName("current") ~= "hpage" 
            and composer.getSceneName("current") ~= "hpage_online" and composer.getSceneName("current") ~= "trans" then
                composer.gotoScene(rota_composer, changeSceneEffectSetting)
            end
            if composer.getSceneName( "current" ) == "hpage" and gResumef == false then
                gOrientf = true
                htov()
            end
        end 
    end 
    gInputGroup.x = display.contentCenterX
    gInputGroup.y = display.contentCenterY 
    gNoBtn.x = gNoBtn.width*0.5 + display.screenOriginX + 40
    gNoBtn.y = gNoBtn.height*0.5 + display.screenOriginY + 40

    --changeInputPos()

    gNoBtn:toFront( )
    --currentOrientation = g_curr_Dir
    
    
end

Runtime:addEventListener( "orientation", onOrientationChange )
--drawBar()



-----------------------------------------------------------
--  建立輸入書碼跳出框
-----------------------------------------------------------
local function creatInputGroup()
    local json = require ("json")
    --local x = math.max(display.contentWidth-2*display.screenOriginX,display.contentHeight-2*display.screenOriginY)
    local bg = display.newRect(  0, 0, 4000, 4000 )
    gInputGroup.x = display.contentCenterX
    gInputGroup.y = display.contentCenterY
    bg.alpha = 0.7
    bg:setFillColor(0)
    local function nothing(event)
        print("event.phase=",event.phase)

        if event.phase == "ended" then

        end
        return true
    end
    local inputWidth = 200
    -----(1)
    bg:addEventListener( "touch", nothing )
    gInputGroup:insert(bg)

    local fontSize = 75
    print("svreensize = ",gSystem.calculateSize( ))
    if gSystem.calculateSize( ) < 7 then
        fontSize = 68
        --inputWidth = 300
    end
    --"Please enter checkout code or touch QRcode scanner to download"

    ----(2)
    local options = 
                {
                            --parent = groupObj,
                    text ="Checkout",     
                    x = 0,
                    y = -300,
                    width = 600,            --required for multiline and alignment
                    height = 150,           --required for multiline and alignment
                    font = native.systemFontBold,   
                    fontSize = fontSize,
                    align = "center"          --new alignment field
                }

    local _txt = display.newText( options)--gInputGroup,"Please enter checkout code to download the book", 0, -100, native.systemFont, fontSize )
    gInputGroup:insert(_txt)
    

    local function networkListenerCheck(event)
        
        if ( event.isError ) then
            print( "Network error!")
            -- showText1.text = "Network error!"
            --    showText1.x = display.contentWidth*0.2
            --    showText1.y = display.contentHeight*0.2
            --    showText1:toFront()
             local function onComplete( event )
                     if event.action == "clicked" then
                          local i = event.index
                          if i == 1 then
                              -- Do nothing; dialog will simply dismiss
                          
                          end
                      end
                  end

                  -- Show alert with two buttons
                  local alert = native.showAlert( "Network Error !!", "Please make sure internet connected and try again", { "OK" }, onComplete )

        else
            --native.setActivityIndicator( false )
            
            
            JSON_metadata = json.decode(event.response)
            --print("JSON_metadata number = ", table.getn(JSON_metadata))
            


            if JSON_metadata == nil then
                print( "network JSON_metadata = nil" ) 
               -- showText1.text = "network JSON_metadata = nil"
               -- showText1.x = display.contentWidth*0.2
               -- showText1.y = display.contentHeight*0.2
               -- showText1:toFront()
            else
                --  showText1.text = "JSON_message ="..JSON_metadata[1].message
                -- showText1.x = display.contentWidth*0.2
                -- showText1.y = display.contentHeight*0.2
                -- showText1:toFront()
                
                if JSON_metadata[1].status == "success" then
                    gInputGroup.isVisible = false
                    gTimeLimit = JSON_metadata[1].message
                    display.remove( gInputGroup[gInputGroup.numChildren] )
                    gInputGroup[3].ticket = JSON_metadata[1].ticket
                    gInputGroup[3].spotkey = JSON_metadata[1].spotkey
                   -- gUrlTextNumber = "http://license.acs.igpublish.com/igpspot/"..JSON_metadata[1].ticket.."/"..JSON_metadata[1].spotkey.."/"
                    gInputGroup[gInputGroup.numChildren] = nil
                    --Process.setisDownloading(true)
                    gNoBtn.isVisible = false

                    sceneVHCtrl("scene_download_number")
                else
                    local function onComplete( event )
                     if event.action == "clicked" then
                          local i = event.index
                          if i == 1 then
                              -- Do nothing; dialog will simply dismiss
                          
                          end
                      end
                  end

                  -- Show alert with two buttons
                    local alert = native.showAlert( "Checkout code Error !!", "Checkout code expired and try again", { "OK" }, onComplete )

                    gInputGroup[3].waitf = false
                    gInputGroup[gInputGroup.numChildren].text = ""
                end
               
            end

        end

    end

    local function networkListenerQrcode(event)
        if ( event.isError ) then
            local function onComplete( event )
                     if event.action == "clicked" then
                          local i = event.index
                          if i == 1 then
                              -- Do nothing; dialog will simply dismiss
                          
                          end
                      end
                  end

                  -- Show alert with two buttons
                  local alert = native.showAlert( "Network Error !!", "Please make sure internet connected and try again", { "OK" }, onComplete )

        else
            --native.setActivityIndicator( false )
            print( "event.response_spotkey = " .. event.response );
            
            local JSON_convertstatus = json.decode(event.response)
            gJSON_convertstatus = JSON_convertstatus
            --Process2.setJSON_convertstatus(JSON_convertstatus)
            --print("JSON_convertstatus number = ", table.getn(JSON_convertstatus))

            if JSON_convertstatus == nil then
                print( "network JSON_metadata = nil" ) 
               -- showText1.text = "network JSON_metadata = nil"
               -- showText1.x = display.contentWidth*0.2
               -- showText1.y = display.contentHeight*0.2
               -- showText1:toFront()
            else
                --  showText1.text = "JSON_message ="..JSON_metadata[1].message
                -- showText1.x = display.contentWidth*0.2
                -- showText1.y = display.contentHeight*0.2
                -- showText1:toFront()
                
                if JSON_convertstatus[1].status == "done" or JSON_convertstatus[1].status == "processing" then

                    ----下載書

                    gInputGroup.isVisible = false

                    
                    local Para = sysFunction.split(gUrl:sub( 13 ), ":")
                    gTimeLimit = Para[4] .. "000"
                    print("gTimeLimit=",gTimeLimit)

                    display.remove( gInputGroup[gInputGroup.numChildren] )
                    gInputGroup[3].ticket = Para[2]
                    gInputGroup[3].spotkey = Para[3]
                   
                    gInputGroup[gInputGroup.numChildren] = nil
                    
                    gNoBtn.isVisible = false
                    sceneVHCtrl("scene_download_number")
                else
                    local function onComplete( event )
                     if event.action == "clicked" then
                          local i = event.index
                          if i == 1 then
                              -- Do nothing; dialog will simply dismiss
                          
                          end
                      end
                  end

                  -- Show alert with two buttons
                    local alert = native.showAlert( "Checkout code Error !!", "Checkout code expired and try again", { "OK" }, onComplete )

                    gInputGroup[3].waitf = false
                    gInputGroup[gInputGroup.numChildren].text = ""
                end
               
            end

        end
    end

  

    local function checkQrcode(message)
        print('QR Code message: ' .. tostring(message))
        
        local code = tostring(message)
        

        -- Para = sysFunction.split(gUrl:sub( 13 ), ":")
       
        -- local temp = os.time() + 1209600
        --     Para[4] = tostring( temp )
        -- local URL = "http://" .. Para[1] .. "/convertstatusmobile/" .. Para[2] .. "/" .. Para[3]
        -- print("URL" , URL)
        --native.showAlert('QR Code Scanner', URL, {'OK'})
        --network.request( URL, "GET", networkListenerQrcode) 

        if code == "" then
            code = "12123232432"
        end
        gCode = code
                --event.target.waitf = true
                local URL = "http://license.acs.igpublish.com/igpspot/verifynumkey/" .. code
                --local URL = "http://www.google.com.tw"
                print("URL" , URL)
               --  showText2.text = URL
               -- showText2.x = display.contentWidth*0.2
               -- showText2.y = display.contentHeight*0.25
               -- showText2:toFront()
               gDownloadTpye = 1

        network.request( URL, "GET", networkListenerCheck)
        --sceneVHCtrl("scene_download") 
        --network.request( URL, "GET", networkListenerCheck)

        
        
    end

    local function qrBtnFn(event)
        if event.phase == "ended" then
            gDownloadTpye = 1
            qrscanner.show(checkQrcode)
            --checkQrcode(gUrlText.text)
        end
        return true
    end
    
    local function check(event)
        if event.phase == "ended" then
            print("waitf=",waitf)
            if event.target.waitf == false then
                
                --downBook()
                local code = gInputGroup[gInputGroup.numChildren].text
                print("code = ", code)
               
                if code == "" then
                    code = "12123232432"
                end
                gCode = code
                event.target.waitf = true
                local URL = "http://license.acs.igpublish.com/igpspot/verifynumkey/" .. code
                --local URL = "http://www.google.com.tw"
                print("URL" , URL)
               --  showText2.text = URL
               -- showText2.x = display.contentWidth*0.2
               -- showText2.y = display.contentHeight*0.25
               -- showText2:toFront()
               gDownloadTpye = 1
                network.request( URL, "GET", networkListenerCheck)
                --gInputGroup.isVisible = false
                --display.remove( gInputGroup[gInputGroup.numChildren] )
                --gInputGroup[gInputGroup.numChildren] = nil
                
                --sceneVHCtrl("scene_download")
            end
        end
        return true
    end
    --image/ic_check_white_48dp.png
    
    print("gInputGroup.x=",gInputGroup.x)
    --print("width=",yesBtn.width)
    --第四個是取消
    local function cancel(event)
        if event.phase == "ended" then

            gInputGroup.isVisible = false
            display.remove( gInputGroup[gInputGroup.numChildren] )
            gInputGroup[gInputGroup.numChildren] = nil
            gNoBtn.isVisible = false
        end
        return true
    end
    -----(3)
    local yesBtn = display.newImage( gInputGroup, "button/b_yes.png" ,system.ResourceDirectory  )
    yesBtn.width = 100
    yesBtn.height = 100
    yesBtn.x =  300
    --_txt.x + _txt.width*0.5 - yesBtn.width*0.5  - 100---display.pixelWidth*0.25--gInputGroup.x - display.contentWidth*0.25--- yesBtn.contentWidth + display.screenOriginX
    yesBtn.y =  0
    yesBtn.waitf = false
    yesBtn:addEventListener( "touch", check )
    --image/ic_close_white_48dp.png

    gNoBtn = display.newImage(  "button/b_no.png" ,system.ResourceDirectory  )
    gNoBtn.width = 100
    gNoBtn.height = 100
    gNoBtn.x = yesBtn.x - 100 - 20--display.pixelWidth*0.25
    --yesBtn.x + _txt.width*0.5 - 80
    --_txt.x + _txt.width*0.5 - noBtn.width*0.5--display.pixelWidth*0.25--gInputGroup.x + display.contentWidth*0.25--yesBtn.x + noBtn.contentWidth - display.screenOriginY
    gNoBtn.y =  90
    gNoBtn:addEventListener( "touch", cancel )

    gNoBtn.isVisible = false
    gTransOver = false
    print("11111111111111111111111111111111111111")

    -----(4)
    local qrBtn = display.newImage( gInputGroup, "button/qrcode_icon.png",system.ResourceDirectory )
    --qrBtn.width = 100
    --qrBtn.height = 100
    qrBtn.waitf = false
    qrBtn.x = 0
    --noBtn.x + _txt.width*0.5 - qrBtn.contentWidth*0.5 - 20
    --yesBtn.x + (noBtn.x - yesBtn.x)/2
    qrBtn.y = yesBtn.y 
    qrBtn:addEventListener( "touch", qrBtnFn)
    -- local rect = display.newRect(yesBtn.x + (noBtn.x-yesBtn.x)*0.5, noBtn.y + 100, 200, 200)
    -- rect:setFillColor(0.75)
    -- local scanButton = widget.newButton {
    --     x = rect.x, y = rect.y,
    --     width = 175, height = 150,
    --     label = 'Scan',
    --     onRelease = function()
    --         print('Showing QR')
    --         qrscanner.show(checkQrcode)
    --     end
    -- }

    -- gInputGroup:insert( rect )
    -- gInputGroup:insert( scanButton )
    
    local x1 = _txt.x - _txt.width*0.5 - 60
    local x2 = _txt.x + _txt.width*0.5 + 60
    local y1 = _txt.y +20

    -----(5)
    local line = display.newLine( gInputGroup, x1, y1, x2, y1  )
    line.strokeWidth = 2

    -----(6)
    local _enterTxt = display.newText( gInputGroup, "Enter Authorization Code", 0, 0,  native.systemFontBold, fontSize - 30 )
    _enterTxt.y = line.y + 100
    gInputWidth = _enterTxt.width

    -----(7)
    local _orTxt = display.newText( gInputGroup, "or", 0, 0, native.systemFontBold, fontSize-10 )
     --local line2 = display.newLine( gInputGroup, x1 + 60, y1, x2 - 60, y1  )
    --line2.strokeWidth = 2

    gInputGroup:toFront( )

    gInputGroup.isVisible = false
    --print("name=",gInputGroup[3].name)
    --showText1:toFront( )
end


-----------------------------------------------------------
--偵測網路
-----------------------------------------------------------

function networkListener(event)
    print( "address", event.address )
    print( "isReachable", event.isReachable )
    print( "isConnectionRequired", event.isConnectionRequired )
    print( "isConnectionOnDemand", event.isConnectionOnDemand )
    print( "IsInteractionRequired", event.isInteractionRequired )
    print( "IsReachableViaCellular", event.isReachableViaCellular )
    print( "IsReachableViaWiFi", event.isReachableViaWiFi )
    
        gWifi = event.isReachableViaWiFi

    

    if event.isConnectionRequired == false then
        gNetworkStatus = true
        if gWarning ~= nil and gWarning.isVisible == true then
            gWarning.isVisible = false
        end
    else
        if loadingBtn ~= nil and loadingBtn.isVisible == true then
            loadingBtn.isVisible = false
        end
        if gWarning ~= nil and gWarning.isVisible == false then
            gWarning.isVisible = true
        end
        gNetworkStatus = false
    end

     -- if showtext2 == nil then
     --                showtext2 = display.newText( tostring( event.isConnectionRequired ), _W, _H+50, native.systemFontBold, 50 )
     --                showtext2:setFillColor( 0 )
     --            else
     --              showtext2.text = tostring(tostring( event.isConnectionRequired))
     --            end
end

-- print("network.canDetectNetworkStatusChanges=",network.canDetectNetworkStatusChanges)



function checkNetwork()
    --if system.getInfo( "platformName" ) == "Android" then
            local status = network.getConnectionStatus()
            --print("status.isConnected==",status.isConnected)
            if status.isConnected then
                gNetworkStatus = true
                if gWarning ~= nil and gWarning.isVisible == true then
                    gWarning.isVisible = false
                end
            else
                if loadingBtn ~= nil and loadingBtn.isVisible == true then
                    loadingBtn.isVisible = false
                end
                if gWarning ~= nil and gWarning.isVisible == false then
                    gWarning.isVisible = true
                end
                gNetworkStatus = false
            end

            if status.isMobile then
                gWifi = false
               -- Device has network access via cellular service.
            else
                gWifi = true
               -- Device has network access via WiFi.
            end

           --print("aaaaaaa")
            --if ( network.canDetectNetworkStatusChanges ) then
                
            -- else
            --     print( "Network reachability not supported on this platform." )
            -- end

--     else
--             if network.canDetectNetworkStatusChanges then
--                     network.setStatusListener( "www.apple.com", networkListener ) 
-- --MyNetworkReachabilityListener triggers download function        
--                     print("Waiting for network response")
--             else
--                     --print("network reachability not supported on this platform")
--                     --native.showAlert( "Network Error", "Network reachability not supported on this platform.", {"OK"}  )
--             end
--     end

end


creatInputGroup()
-----------------------------------------------------------
--  按下返回的按鈕
-----------------------------------------------------------
local noticeGroup = display.newGroup( )



local function Button_Yes2(top)
        -- button event
        local justPressed = function(event)
            if event.phase == "ended" then
              if system.getInfo( "platformName" ) == "Android" then
                native.requestExit()
              end
         
            end
        end

        local button = widget.newButton
        {
            --width  = 0,
            --height = 0,
            x      = display.contentWidth*0.5 - 140,
            y      = top, --display.contentHeight*0.65,
            
            label = "Yes",
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
        button.name = "Btn_Exit"
        --BlockGroup:insert(button)
        return button
end

-----------------------------------------------------------
    -- 取消
    -----------------------------------------------------------
    local function Button_No(top)
        -- button event
        local justPressed = function(event)
            if event.phase == "ended" then
                  optionItemf = false
                  exitf = false
                  for i=1,noticeGroup.numChildren do
                    display.remove( noticeGroup[1] )
                    noticeGroup[1] = nil
                  end
            end
        end

        local button = widget.newButton
        {
            --width  = 0,
            --height = 0,
            x      = display.contentWidth*0.5 + 140,
            y      = top, --display.contentHeight*0.65,
            
            label = "No",
            lableColor = { default={1, 1, 1}, over={1, 1, 1, 1} },
            font        = native.systemFontBold,
            fontSize    = 40,
            -- defaultFile = "image/option.png",
            -- overFile    = "image/option_over.png",
            onEvent     = justPressed,

            shape  ="roundedRect",
            width  = 240,
            height = 80,
            cornerRadius = 9,
            fillColor = { default={ 0.65, 0.65, 0.65, 1 }, over={ 0.65, 0.65, 0.65, 0.4 } },
            strokeColor = { default={ 0.55, 0.55, 0.55, 1 }, over={ 0.35, 0.35, 0.35, 1 } },
            strokeWidth = 2              
        }
        button.name = "Btn_LogoutCancel"
        --BlockGroup:insert(button)

        return button
    end 

local function arrang2()
    -- local text = display.newText( tostring(exitf),200,200,native.systemFontBold,50 )
    -- text:setFillColor( 1,0,0 )
    
        
        local bg = display.newRect( _W, _H, _W*2-display.screenOriginX*2, _H*2-display.screenOriginY*2 )
        bg:setFillColor( 0 )
        bg.alpha = 0.7
        exitf = true
        local noticetext = display.newText( "Would you like to close the App ?" ,0,0,native.systemFontBold,40)
        noticetext:setFillColor( 1)
        noticetext.x = _W
        noticetext.y = _H - 50

        local yestext = Button_Yes2(noticetext.y+100)
        local notext  = Button_No(noticetext.y+100)

        -- local yestext = display.newText( "Yes",0,0,native.systemFontBold,50 )
        -- --yestext:setFillColor( gray )
        -- yestext.x = _W -100
        -- yestext.y = _H + 50
        -- yestext:addEventListener( "touch", exit )
        -- local notext = display.newText( "Cancel",0,0,native.systemFontBold,50 )
        -- --yestext:setFillColor( gray )
        -- notext.x = _W +100
        -- notext.y = _H + 50
        -- notext:addEventListener( "touch", notexit )
        noticeGroup:insert(bg)
        noticeGroup:insert(noticetext)
        noticeGroup:insert(yestext)
        noticeGroup:insert(notext)
        noticeGroup:toFront( )
    
end

 function onKeyEvent( event )

    if event.phase == "up" then
        if (event.keyName == "back") and (system.getInfo("platformName") == "Android")  then
            if   composer.getSceneName("current") == "hpage" then
                arrang()
            else
                
                arrang2()
            end
            --gUrlText:setFillColor( 1, 0 ,0 )
            --os.exit()
            --native.requestExit()

            return true
        end
    end

    return false
end

-- checkNetf = false
 checkNum = 10
-- local function networkCheckListener( event )
--     if ( event.isError ) then
--         if loadingBtn ~= nil and loadingBtn.isVisible == true then
--             loadingBtn.isVisible = false
--         end
--         if gWarning ~= nil and gWarning.isVisible == false then
--             gWarning.isVisible = true
--         end
--         gNetworkStatus = false
--         --checkNetf = checkNetf + 1
--         checkNetf = false
--         if showtext2 == nil then
--                     showtext2 = display.newText( tostring( gNetworkStatus ), _W, _H+50, native.systemFontBold, 50 )
--                     showtext2:setFillColor( 0 )
--                 else
--                   showtext2.text = tostring(tostring( gNetworkStatus))
--                 end

--     else
--         gNetworkStatus = true
--         if gWarning ~= nil and gWarning.isVisible == true then
--             gWarning.isVisible = false
--         end
--         checkNetf = false
--         if showtext2 == nil then
--                     showtext2 = display.newText( tostring( gNetworkStatus ), _W, _H+50, native.systemFontBold, 50 )
--                     showtext2:setFillColor( 0 )
--                 else
--                   showtext2.text = tostring(tostring( gNetworkStatus))
--                 end
--     end
-- end

-- local function myNetworkReachabilityListener( event )
--             print( "isConnectionRequired", event.isConnectionRequired )
--         end

function onCheckNetwork(e)


    if checkNum % 10 == 0  then
        -- network.request( "https://www.google.com", "GET", networkCheckListener )
        --print("checkNetf=",checkNetf)
        checkNetwork()
        checkNum = 1 
       -- checkNetf = true
    end
    checkNum = checkNum + 1
end

--print("deviceId==",system.getInfo("deviceID"))

-- if showtext == nil then
--                 showtext = display.newText( system.getInfo("deviceID"), _W, _H, native.systemFontBold, 50 )
--                 showtext:setFillColor( 0 )
--             else
--               showtext.text = system.getInfo("deviceID")
--             end
--             showtext:toFront( )

--network.setStatusListener( "www.google.com", networkListener )
Runtime:addEventListener("enterFrame",onCheckNetwork)
Runtime:addEventListener( "key", onKeyEvent )
