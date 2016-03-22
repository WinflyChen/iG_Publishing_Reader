
os.execute('clear')

system.activate( "multitouch" )

local composer = require "composer"
local wetools = require("wetools")
local scene = composer.newScene()
local movieclip = require("movieclip")
local widget = require( "widget" )

local _W = display.contentWidth * 0.5
local _H = display.contentHeight * 0.5 
local scrOrgx = display.screenOriginX
local scrOrgy = display.screenOriginY

local _X = display.contentCenterX
local _Y = display.contentCenterY


local touchx = 0
local touchy = 0
local cornerx = 0
local cornery = 0
local centx = 0
local centy = 0
local hx = 0
local hy = 0
local vx = 0
local vy = 0
local autovx = 0
local autof = false
local pagewidth = 0
local pageheight = 0
local originpagewidth = 0
local originpageheight = 0
local onoff = nil

local pagex = 0
local pagey = 0
local mask
local turnf = false
--local currentOrientation --= "landscapeRight"
--local oldorientation --= "landscapeRight"
local dir = ""
local checkdir = true
local gof = false
local oldx = 0
--local pageList2[p1]
--local pageList2[p2] 
local canautof= false
local textgroup = display.newGroup()
local optionGroup = display.newGroup( )

local sceneGroup
local pageText = display.newText("",-10000,0,native.systemFont,30)
local contentGroup = display.newGroup( )
local optionItemGroup = display.newGroup( )
local smallPageGroup = display.newGroup()
local optionBoxUp = 88
local optionBoxDown = 150
local contwidth = (_W*2 -2*scrOrgx)*0.35

local clickWidth = 100
local flipArea = {}
local clickAreaR = {}
local clickAreaL = {}
local allArea = {}
local moveArea = {}
local smallpageVX = 0
local smallpageOldx = 0
local starttime = 0
local smallpageWidth = 0
local smallpagePos = 0
local smallpageMovef = false
local smallrate = 0
local smallpagef = false ----偵測縮圖是否移動
local smallpageinf = false ---偵測是否在縮圖中按下
local backLeft = false
local backRight = false
local jumpPagef = false
local setupt = system.getTimer( )
local contents
local option
local library
local pageList = display.newGroup( )
local bookmarkList = display.newGroup( )
local bookmarkTextlist = display.newGroup( )
local bg
local firstPos = 0
local circel

local rightpos = 0
local leftpos = 0
--------放大時用
local zoomdx = 0 ----放大時拖拉圖時，第一下按下去的點與中心點的差值
local zoomdy = 0
local zoomClickx = 0 --雙擊放大x,y位置
local zoomClicky = 0
local zoomrate = 0
----放大時彈回開關
local bigBackRight = false
local bigBackLeft = false
local bigBackUp = false
local bigBackDown = false
local bigautof = false
local bigVx = 0
local bigVy = 0
--local bigOldx = 0
--local bigOldy = 0
local bigMovef = false ---放大時是否拖動

local mutitouchPos = {}
local centerx = 0 --多點觸控中心點
local centery = 0
local touchDistance = 0 ---每點到中心點距離
local mutitouchf = false
local touchnum = 0

local idList = {}
local mutiscalef = false
local mutirate = 0
--local targetrate = 0
local delaytime = 0
local tapx = 0
local tapy = 0
local mf = false
local touchtime = 0
local numTouches = 0

local movieclip = require("movieclip")
local pname = {}

local path = choice_bookcode.."/"
local path_thumb = choice_bookcode.."thumb/"
local path_image = [[image/]]
local bookmarkf = false

local baseDir = system.TemporaryDirectory
local resDir = system.ResourceDirectory
local bookmarkNumList = nil
local scaleing = false
--local targetrate = 0
local bounds = 0
local bounds2 = 0
local contscroll = nil
local bookmarkscroll = nil
local chapterList = {}
local chapterpageList = {}
local chochapter = 0
local chobookmark = 0
local chobookmarkdel = 0
local chaptermove = false
local bookmarkmove = false
local contitemheight = 40
local contheight = 0
local mutimovefh = false
local mutimovefv = false
local markbmp = nil
local optionrate
local thumbpage = 1
local pageH = _H + statusbarHeight*0.5
--local optionBtnBase = nil
local fontSize = 25
local chapterBlock = nil
local contentBox = nil
local bookmarkBox = nil
--local bookmarkBack = nil
local bookmarkBlock = nil
local loadingf = false
local loadingImg = nil
local noticeGroup = display.newGroup( )
local exitf = false
local requestId = nil

local function makeOutLine()
   if currentOrientation == "landscapeLeft" or currentOrientation == "landscapeRight" then
      local smallpageOutline
      if pleft == 1  then
       

        local tmp = smallPageGroup[1]
        local x1 = tmp.x-tmp.width*0.5*tmp.smallrate
        local y1 = tmp.y-tmp.height*0.5*tmp.smallrate
        local x2 = tmp.x+tmp.width*0.5*tmp.smallrate
        local y2 = tmp.y+tmp.height*0.5*tmp.smallrate 
        smallpageOutline = display.newLine( x1-2, y1, x2, y1,x2,y2,x1,y2,x1,y1 )
        smallpageOutline:setStrokeColor( 1, 0, 0, 1 )
        smallpageOutline.strokeWidth = 6
      elseif pleft >= maxPage then
       -- ----print("pleft===",pleft)
        local num = 0
        if pleft >= maxPage + 2 then
          pleft = pleft -2
        end
        if pleft > maxPage then
          

          num = (pleft-1)*2 - 1
          local tmp = smallPageGroup[num]
          local x1 = tmp.x-tmp.width*0.5*tmp.smallrate
          local y1 = tmp.y-tmp.height*0.5*tmp.smallrate
          local x2 = tmp.x+tmp.width*0.5*tmp.smallrate
          local y2 = tmp.y+tmp.height*0.5*tmp.smallrate
          smallpageOutline = display.newLine( x1-2, y1, x2, y1,x2,y2,x1,y2,x1,y1 )
        else
         
          local num1 = pleft*2-1
          local tmp = smallPageGroup[num1]
          local x1 = tmp.x-tmp.width*1.5*tmp.smallrate
          local y1 = tmp.y-tmp.height*0.5*tmp.smallrate
         local x2 = tmp.x+tmp.width*0.5*tmp.smallrate
          local y2 = tmp.y+tmp.height*0.5*tmp.smallrate
          smallpageOutline = display.newLine( x1-2, y1, x2, y1,x2,y2,x1,y2,x1,y1 )
        end
        smallpageOutline:setStrokeColor( 1, 0, 0, 1 )
        smallpageOutline.strokeWidth = 6
      else
        
        local num1 = pleft*2-1
        local tmp = smallPageGroup[num1]
        local x1 = tmp.x-tmp.width*1.5*tmp.smallrate
        local y1 = tmp.y-tmp.height*0.5*tmp.smallrate
        local x2 = tmp.x+tmp.width*0.5*tmp.smallrate
        local y2 = tmp.y+tmp.height*0.5*tmp.smallrate
        smallpageOutline = display.newLine( x1-2, y1, x2, y1,x2,y2,x1,y2,x1,y1 )
        smallpageOutline:setStrokeColor( 1, 0, 0, 1 )
        smallpageOutline.strokeWidth = 6
      end
      smallPageGroup:insert(smallpageOutline)
  else
    

    local smallpageOutline
    local pos = 0
    pos = (p1*2-1)
    ----print("pos===",pos)
    local tmp = smallPageGroup[pos]
    local x1 = tmp.x-tmp.width*0.5*tmp.smallrate
    local y1 = tmp.y-tmp.height*0.5*tmp.smallrate
    local x2 = tmp.x+tmp.width*0.5*tmp.smallrate
    local y2 = tmp.y+tmp.height*0.5*tmp.smallrate 
    smallpageOutline = display.newLine( x1-2, y1, x2, y1,x2,y2,x1,y2,x1,y1 )
    smallpageOutline:setStrokeColor( 1, 0, 0, 1 )
    smallpageOutline.strokeWidth = 6

      smallPageGroup:insert(smallpageOutline)
  end
end

local function smallPageAutoMoveFn(event)
  if currentOrientation == "landscapeLeft" or currentOrientation == "landscapeRight" then
    local dx
    if backLeft == true then
    
    if pleft > maxPage then
        dx = _W*2 - scrOrgx - 20 -smallPageGroup[(pleft-1)*2-1].contentWidth*0.5 - smallPageGroup[(pleft-1)*2-1].x 
      else
        dx = _W*2 - scrOrgx - 20 -smallPageGroup[pleft*2-1].contentWidth*0.5 - smallPageGroup[pleft*2-1].x 
      end 
    dx = dx *0.2
    for i = 1,smallPageGroup.numChildren do
      smallPageGroup[i].x = smallPageGroup[i].x + dx
    end
    if math.abs(dx)< 2 then
      backLeft = false
       for i = 1,smallPageGroup.numChildren do
        smallPageGroup[i].x = smallPageGroup[i].x + dx
       end
      Runtime:removeEventListener("enterFrame",smallPageAutoMoveFn)
    end
  end

  if backRight == true then
     
    if pleft > 1  then
      dx = scrOrgx + 20 + smallPageGroup[(pleft-1)*2-1].contentWidth*0.5 - smallPageGroup[(pleft-1)*2-1].x 
    else
      dx = scrOrgx + 20 + smallPageGroup[pleft*2-1].contentWidth*0.5 - smallPageGroup[pleft*2-1].x 
    end
     dx = dx *0.2
    for i = 1,smallPageGroup.numChildren do
      smallPageGroup[i].x = smallPageGroup[i].x + dx
    end
    if math.abs(dx)< 2 then
      for i = 1,smallPageGroup.numChildren do
        smallPageGroup[i].x = smallPageGroup[i].x + dx
      end
      backRight = false
      Runtime:removeEventListener("enterFrame",smallPageAutoMoveFn)
    end
  end
 else
    local dx
  if backLeft == true then
    
    --if pleft > maxPage then
        dx = _W*2 - scrOrgx - 20 -smallPageGroup[p1*2-1].contentWidth*0.5 - smallPageGroup[p1*2-1].x +scrOrgx
    --  else
       -- dx = _W*2 - scrOrgx*2 - 60 - smallPageGroup[pleft*2].x +scrOrgx
     -- end 
    dx = dx *0.2
    for i = 1,smallPageGroup.numChildren do
      smallPageGroup[i].x = smallPageGroup[i].x + dx
    end
    if math.abs(dx)< 2 then
      backLeft = false
       for i = 1,smallPageGroup.numChildren do
        smallPageGroup[i].x = smallPageGroup[i].x + dx
       end
      Runtime:removeEventListener("enterFrame",smallPageAutoMoveFn)
    end
  end

  if backRight == true then
     --print("right......right.......")
     -- if pleft > 1  then
     dx = scrOrgx + 20 + smallPageGroup[p1*2-1].contentWidth*0.5 - smallPageGroup[p1*2-1].x 
   
     dx = dx *0.2
    for i = 1,smallPageGroup.numChildren do
      smallPageGroup[i].x = smallPageGroup[i].x + dx
    end
    if math.abs(dx)< 2 then
      for i = 1,smallPageGroup.numChildren do
        smallPageGroup[i].x = smallPageGroup[i].x + dx
      end
      backRight = false
      Runtime:removeEventListener("enterFrame",smallPageAutoMoveFn)
    end
  end
 end
end




local function compare( a, b )
    return a < b
end

local function gobookmarkFn(event)

  local ph = event.phase
  --print("ph==",ph)
  local etar = event.target
  if ph == "began" then
    --print("etar.no==",etar.no)
    chobookmark = event.target.no

  end

end

local function delbookmarkFn(event)
  local ph = event.phase
  local etar = event.target
  --print("ph==",ph)
  if ph == "began" then
    chobookmarkdel = etar.no
    --print("etar.no==",etar.no)
  end
end


local function bookmarkFn(event)
  local ph = event.phase
  local etar = event.target

  if ph == "began" then
    ----print("aaaa")
    bookmarkf = true

  elseif ph == "ended" or ph == "canceled" then
    ----print("p1==",p1)
    ----print("etar.no==",etar.no)
   -- if bookmark[etar.no] == 0 then
    local no = 0
    if currentOrientation == "landscapeLeft" or currentOrientation == "landscapeRight" then
      if pleft == 1 then
        no = 1
      elseif pleft > maxPage then
        no = maxPage
      else
        no = pleft-1
      end
    else
      no = p1
    end
    --print("no===",no)
    if wetools.findone(no,bookmarkNumList) == false then
      markbmp.alpha = 1   
      table.insert( bookmarkNumList,no)
      table.sort( bookmarkNumList, compare )  
    else
      markbmp.alpha = 0.5  
      bookmarkNumList = wetools.deleteone(no,bookmarkNumList)
    end

    local status = ""
    for i=1, #bookmarkNumList do
      status = status .. "," .. bookmarkNumList[i]
    end
    gProfile.updatebookmark( choice_bookcode, status )
        if bookmarkscroll ~= nil then
          local oldx = bookmarkscroll.x
          local orgx = bookmarkscroll.orgx

          display.remove( bookmarkscroll)
          bookmarkscroll = nil
         local totalhight_bookmark =  0
         local top = scrOrgy+statusbarHeight+optionBoxUp+contitemheight
          bookmarkscroll = widget.newScrollView
            {            
                left =scrOrgx,
                top =top,
       
                width = contwidth,
                height = contheight-contitemheight,
                
              
                rightPadding  =0,

                id = "bookmarkscroll",
                hideBackground  = true,
                horizontalScrollDisabled = true,
                verticalScrollDisabled = false,
                listener = bookmarkscrollListener,
            }
            bookmarkscroll.orgx = orgx
            bookmarkscroll.x = oldx

         if #bookmarkNumList > 0 then

            for i = 1,#bookmarkNumList do
              --print("bookmarkNumList[i]==",bookmarkNumList[i])
              local marknum = display.newText("Page: "..bookmarkNumList[i],0,totalhight_bookmark,native.systemFont,40 )
              local del = display.newText( "Del",0,0,native.systemFont,40)
              --print("1111111")
              --marknum:setFillColor( 1,0,0 )
              marknum.x =  marknum.width*0.5
              marknum.y = totalhight_bookmark + marknum.height*0.5
              del.x = contwidth - del.width*0.5-5
              del.y = marknum.y

              marknum.no = tonumber(  bookmarkNumList[i] )
              no = tonumber(  bookmarkNumList[i] )
              totalhight_bookmark = totalhight_bookmark + marknum.height + 20 + marknum.height*0.5
              
              marknum:addEventListener( "touch", gobookmarkFn )
              del:addEventListener( "touch", delbookmarkFn )
              
              bookmarkscroll:insert(marknum)
              bookmarkscroll:insert(del)
              
            end
            contentGroup:insert(bookmarkscroll)
         end
      end
  end
  return true
end


local function jumpchapter(no)
  ---jump chapter and bookmark
  --print("no====",no)
    local nowpleft = 0
              local oldpleft = 0 
              if currentOrientation == "landscapeLeft" or currentOrientation == "landscapeRight" then
                if no % 2 == 1 then
                  nowpleft = no
                else
                 nowpleft = no + 1
                end
                oldpleft = pleft
              else
                nowpleft = no
                oldpleft = p1
              end
               
                if nowpleft > oldpleft then
                  dir = "left"
                elseif nowpleft < oldpleft then
                 dir = "right"
                else
                  dir = "stop"
                end

                ----print()
                if currentOrientation == "landscapeLeft" or currentOrientation == "landscapeRight" then
                  pleft = nowpleft
                 pright = pleft - 1

                end
                  ----print("dir====",dir)
                if dir == "left" then
                    ----print("flipType========",flipType)
                    
                    if  flipType ==1 then
                      if currentOrientation == "landscapeLeft" or currentOrientation == "landscapeRight" then  
                        for i = 1,pageList.numChildren do
                          -- local no = pageList[1].no
                          -- if no ~= nil then
                          --   pageList2[no] = 1
                          -- end
                          pageList:remove(1)
                          pageList[1] = nil
                        end
                        
                        for i = pleft-1,pleft do
                          if i > 0 and i <= maxPage then
       
                            local page = display.newImage(path..i..".png",baseDir,true)
                                                    
                            if page ==  nil then
                              page = display.newRect( 0, 0, pageList2[oldpleft].width, pageList2[oldpleft].height )
                              page:setFillColor( 1,1,1 )
                              page.name="blank"
                            else
                             page.name="book"..i
                            end

                         
                            originpagewidth = page.width
                            originpageheight = page.height
                            page.originpagewidth = page.width
                            page.originpageheight = page.height

                            page.no = i

                            pageList2[i] = page

                            local rate1 = (_H*2-scrOrgy*2- statusbarHeight)/page.height
        
                            local rate2 = (_W*2-scrOrgx*2)/page.width
         
                            if i == 1 then
                              if rate1 <= rate2 then
                                rate = rate1
                              else
                                rate = rate2
                              end
                            elseif i == maxPage then
                              if i % 2 == 1 then
                                if rate1*2 <= rate2 then
                                  rate = rate1
                                else
                                  rate = rate2*0.5
                                end
                              else
                                if rate1 <= rate2 then
                                  rate = rate1
                                else
                                  rate = rate2
                                end
                              end
                            else
                              if rate1*2 <= rate2 then
                                rate = rate1
                              else
                                rate = rate2*0.5
                              end
                            end      
                            page.rate = rate
                            page.pagewidth = originpagewidth*rate
                            page.pageheight = originpageheight*rate
                            page.nowrate = rate
                            page:scale( rate, rate )
                            page.x = _W
                            page.y = pageH
                          
                            pageList:insert(page)

                            if i % 2 == 1 then
                              page.anchorX = 0
                              page.path.x3 = 0
                              page.path.x4 = 0
                            else
                              page.anchorX = 1
                             page.path.x1 = 2*originpagewidth
                              page.path.x2 = 2*originpagewidth
                            end

                          end
                        end

                     
                        for i = oldpleft-3,oldpleft do
                          if i > 0 and i <= maxPage then
       
                            local page = display.newImage(path..i..".png",baseDir,true)
                          
                         
                            if page ==  nil then
                              page = display.newRect( 0, 0, pageList2[oldpleft].width, pageList2[oldpleft].height )
                              page:setFillColor( 1,1,1 )
                              page.name="blank"
                            else
                              page.name="book"..i
                            end
                            
                            originpagewidth = page.width
                            originpageheight = page.height
                            page.originpagewidth = page.width
                            page.originpageheight = page.height

                            page.no = i

                            pageList2[i] = page

                            local rate1 = (_H*2-scrOrgy*2- statusbarHeight)/page.height
        
                            local rate2 = (_W*2-scrOrgx*2)/page.width
         
                            if i == 1 then
                              if rate1 <= rate2 then
                                rate = rate1
                              else
                                rate = rate2
                              end
                            elseif i == maxPage then
                              if i % 2 == 1 then
                                if rate1*2 <= rate2 then
                                  rate = rate1
                                else
                                  rate = rate2*0.5
                                end
                              else
                                if rate1 <= rate2 then
                                  rate = rate1
                                else
                                  rate = rate2
                                end
                              end
                            else
                              if rate1*2 <= rate2 then
                                rate = rate1
                              else
                                rate = rate2*0.5
                              end
                            end      
                            page.rate = rate
                            page.pagewidth = originpagewidth*rate
                            page.pageheight = originpageheight*rate
                            page.nowrate = rate
                        
                            page:scale( rate, rate )
                            page.x = _W
                            page.y = pageH

                            pageList:insert(page)
                            if i ~= oldpleft then
                              if i % 2 == 1 then
                                page.anchorX = 0
                                page.path.x3 = -2*originpagewidth
                                page.path.x4 = -2*originpagewidth
                              else
                                page.anchorX = 1
                                page.path.x1 = 0
                                page.path.x2 = 0
                              end
                            else
                              page.anchorX = 0
                            end
                          end
                        end
                        display.remove( mask )
                        mask = nil
                        mask = display.newImage( path_image.."mask1.png",true )
                        mask.orgx = mask.width
                        mask.orgy = mask.height
                        --local rate1 = mask.orgx/pageList2[p1].pagewidth
                        local rate1 = pageList2[p1].pagewidth/mask.orgx
                        mask:scale( 0.98*rate1, 0.98*rate1)
                        mask.anchorX = 0
                        mask.x =_W
                        mask.y = pageH 
                        mask.name = "mask"
                        pageList:insert(mask)

                        mask:toBack( )
                        if pleft == 1 then
                          mask.path.x4 = 0
                          mask.path.x3 = 0
                        end
                        if pleft >= maxPage then
                          local mratex = mask.orgx/pageList2[maxPage].originpagewidth
                          mask.path.x4 = -2*mask.orgx
                          mask.path.x3 = -2*mask.orgx
                        end

                        p1 = oldpleft
                        p2 = pleft - 1

                        -- pageList2[p1].no = p1

                        if pleft >= maxPage then
                          if flipType == 1 then
                            oldflipType = 1
                            flipType = 0
                           -- p1 = nowpleft
                           if maxPage % 2 == 0 then
                              pageList2[maxPage].anchorX = 0
                              pageList2[maxPage].x = _W*2-2*scrOrgx + (_W*2 - 2*scrOrgx - pageList2[maxPage].contentWidth)+_W
                              --print("maxpage.xxxxxxxx==",pageList2[maxPage].x)
                              --print("oldpleft.x==",pageList2[oldpleft].x)
                              pageList2[maxPage].path.x3 = 0
                              pageList2[maxPage].path.x4 = 0
                              pageList2[maxPage].path.y3 = 0
                              pageList2[maxPage].path.y4 = 0
                              pageList2[maxPage].path.x1 = 0
                              pageList2[maxPage].path.x2 = 0
                              pageList2[maxPage].path.y1 = 0
                              pageList2[maxPage].path.y2 = 0
                              pageList2[maxPage]:toFront( )
                            else
                              pageList2[maxPage].anchorX = 0
                              pageList2[maxPage-1].anchorX = 0
                              pageList2[maxPage-1].x = _W*2 - scrOrgx
                              pageList2[maxPage].x = pageList2[maxPage-1].x + pageList2[maxPage-1].contentWidth*0.5
                              ----print("dxxxxxxx===",pageList2[maxPage].x - pageList2[maxPage-1].x )

                              pageList2[maxPage].path.x3 = 0
                              pageList2[maxPage].path.x4 = 0
                              pageList2[maxPage].path.y3 = 0
                              pageList2[maxPage].path.y4 = 0
                              pageList2[maxPage].path.x1 = 0
                              pageList2[maxPage].path.x2 = 0
                              pageList2[maxPage].path.y1 = 0
                              pageList2[maxPage].path.y2 = 0
                              pageList2[maxPage-1].path.x3 = 0
                              pageList2[maxPage-1].path.x4 = 0
                              pageList2[maxPage-1].path.y3 = 0
                              pageList2[maxPage-1].path.y4 = 0
                              pageList2[maxPage-1].path.x1 = 0
                              pageList2[maxPage-1].path.x2 = 0
                              pageList2[maxPage-1].path.y1 = 0
                              pageList2[maxPage-1].path.y2 = 0
                              pageList2[maxPage-1]:toFront( )
                              pageList2[maxPage]:toFront( )
                            end
                            mask:toBack( )
                          end
                        end



                        --  smallPageGroup:remove(smallPageGroup.numChildren)
                        -- smallPageGroup[smallPageGroup.numChildren] = nil
                        -- makeOutLine()
                        
                      else
                      ---直  左翻頁
                        local pos = 0
                        for i= 1,pageList.numChildren do
                          if pageList[i].no == oldpleft+1 then
                            pos = i
                          end
                        end
                        pageList:remove(pos)
                        pageList[pos] = nil

                        --bookmarkList[bookmarkList.numChildren].no = p1

                        local page = display.newImage(path..nowpleft..".png",baseDir,true)
                                                    
                            if page ==  nil then
                             page = display.newRect( 0, 0, pageList2[oldpleft].width, pageList2[oldpleft].height )
                              page:setFillColor( 1,1,1 )
                              page.name="blank"
                            else
                             page.name="book"..nowpleft
                            end
                            
                             local rate1 = (_H*2-scrOrgy*2- statusbarHeight)/page.height
        
                            local rate2 = (_W*2-scrOrgx*2)/page.width
         
                            if rate1 <= rate2 then
                              rate = rate1
                            else
                              rate = rate2
                            end
                            page.rate = rate
                            originpagewidth = page.width
                            originpageheight = page.height
                            page.originpagewidth = page.width
                            page.originpageheight = page.height

                            page.pagewidth = originpagewidth*rate
                            page.pageheight = originpageheight*rate


                            page.no = nowpleft
                            page.anchorX = 0
                            pageList2[nowpleft] = page
                            page.nowrate = rate
                            page:scale( rate, rate )
                             local dx = _W*2-2*scrOrgx - page.width*rate
                            page.x = scrOrgx + dx/2
                            --page.x = scrOrgX
                            page.y = pageH
                          
                            pageList:insert(page)
                            pageList2[p1]:toFront( )

                      end

                      if nowpleft == maxPage then
                          if flipType == 1 then
                            oldflipType = 1
                            flipType = 0
                            p1 = nowpleft
                            pageList2[maxPage].anchorX = 0
                            pageList2[maxPage].x = _W*2 - scrOrgx 
                            pageList2[maxPage].path.x3 = 0
                            pageList2[maxPage].path.x4 = 0
                            pageList2[maxPage].path.y3 = 0
                            pageList2[maxPage].path.y4 = 0
                            mask:toBack( )
                          end
                        end

                      checkdir = false
                      jumpPagef = true
                      ----print("15")
                      turnf = false
                      -- autovx = -100 
                      -- if flipType == 1 then
                      --   autovx = -220
                      -- else
                        autovx = -140 
                      --end            
                      autof = true

                     
                      
                      Runtime:addEventListener("enterFrame",autoturnfn )
                    else
                       ----不翻頁，左    
                      ----print("dfadsfasdfadsgadgadgasdgagag")
                      if currentOrientation == "landscapeLeft" or currentOrientation == "landscapeRight" then
                        for i = 1,2 do
                          pageList:remove(pageList.numChildren)
                          pageList[pageList.numChildren] = nil
                        end
    

                        for i = pleft-1,pleft do
                          if i <= maxPage then
                            local page = display.newImage(path..i..".png",baseDir,true)

                            if page ==  nil then
                              page = display.newRect( 0, 0, pageList2[oldpleft].width, pageList2[oldpleft].height )
                              page:setFillColor( 1,1,1 )
                              page.name="blank"
                            else
                              page.name="book"..i
                            end

                            page.anchorX = 0
                            page.no = i
                         -- page.name="book"..i
                            pageList2[i] = page

                            local rate1 = (_H*2-scrOrgy*2- statusbarHeight)/page.height
        
                            local rate2 = (_W*2-scrOrgx*2)/page.width
         
                            if i == 1 then
                              if rate1 <= rate2 then
                                rate = rate1
                              else
                                rate = rate2
                              end
                            elseif i == maxPage then
                              if i % 2 == 1 then
                                if rate1*2 <= rate2 then
                                  rate = rate1
                                else
                                  rate = rate2*0.5
                                end
                              else
                                if rate1 <= rate2 then
                                  rate = rate1
                                else
                                  rate = rate2
                                end
                              end
                            else
                              if rate1*2 <= rate2 then
                                rate = rate1
                              else
                                rate = rate2*0.5
                              end
                            end      
                            page.rate = rate
                            page.nowrate = rate*nowrate

                            originpagewidth = page.width
                            originpageheight = page.height
                            page.originpagewidth = page.width
                            page.originpageheight = page.height

                            page.pagewidth = originpagewidth*rate
                            page.pageheight = originpageheight*rate


                            if scalef == false then
                              page:scale( rate, rate )
                             
                             --page.x = _W
                              page.y = pageH
                              --page.x = _W*2-scrOrgx + (i-pleft+1)*page.originpagewidth*rate
                              if i%2 == 0 then
                                page.x = _W*2 - scrOrgx
                              else
                                page.x = pageList2[i-1].x + pageList2[i-1].contentWidth
                              end

                              if pleft  > maxPage then
                                pageList2[maxPage].x = _W*2-2*scrOrgx + (_W*2 - 2*scrOrgx - pageList2[maxPage].contentWidth)+_W
                              end

                            else
                      ------放大時點頁 
                              
                               page:scale(nowrate*page.rate,nowrate*page.rate)
                               page.nowrate = nowrate*page.rate
                              page.x = _W*2-scrOrgx + (i-pleft+1)*page.contentWidth
                              page.y = scrOrgy + page.contentHeight*0.5
                        
                            end
                            pageList:insert(page)
                                                    
                          end
                          
                        end

                        

                        if scalef == false then
                          if pleft <= maxPage then
                            firstPos = pageList2[oldpleft].x
                          else
                          ------print("firstpos===",firstPos)
                            firstPos = leftpos
                          end
                        end
                      
                        p1 = oldpleft
                        p2 = pleft - 1
                     
                        if scalef == false then
                          checkdir = false
                          jumpPagef = true
                        ----print("16")
                          turnf = false
                          -- autovx = -100 
                          if flipType == 1 then
                            autovx = -220
                          else
                            autovx = -140 
                          end            
                          autof = true
                         
                          Runtime:addEventListener("enterFrame",autoturnfn )
                        else
                          jumpPagef = true
                          bigautof = true
                          Runtime:addEventListener("enterFrame",bigAutoFlipFn )
                        end
                    
                        -- smallPageGroup:remove(smallPageGroup.numChildren)
                        -- smallPageGroup[smallPageGroup.numChildren] = nil
                        -- makeOutLine()
                      else
                     ----直 不翻頁,左
                          p1 = nowpleft
                          if pageList.numChildren == 2 then
                            pageList:remove(2)
                            pageList[2] = nil
                           
                          elseif pageList.numChildren == 3 then
                            pageList:remove(1)
                            pageList[1] = nil
                           
                            pageList:remove(2)
                            pageList[2] = nil
                           
                          end
                            
                           local page = display.newImage(path..p1..".png",baseDir,true)
                                                 
                          if page ==  nil then
                            page = display.newRect( 0, 0, pageList2[oldpleft].width, pageList2[oldpleft].height )
                              page:setFillColor( 1,1,1 )
                            page.name="blank"
                          else
                            page.name="book"..p1
                          end

                        
                          local rate1 = (_H*2-scrOrgy*2- statusbarHeight)/page.height
        
                            local rate2 = (_W*2-scrOrgx*2)/page.width
         
                            if rate1 <= rate2 then
                              rate = rate1
                            else
                              rate = rate2
                            end
                            page.rate = rate
                            originpagewidth = page.width
                            originpageheight = page.height
                            page.originpagewidth = page.width
                            page.originpageheight = page.height

                            page.pagewidth = originpagewidth*rate
                            page.pageheight = originpageheight*rate

                          page.anchorX = 0
                          page.no = p1
                         -- page.name="book"..i
                          pageList2[p1] = page

                          originpagewidth = page.width
                            originpageheight = page.height
                            page.originpagewidth = page.width
                            page.originpageheight = page.height


                          if scalef == false then
                             page:scale( rate, rate )
                             
                             page.nowrate = rate
                             --page.x = _W
                             page.y = pageH
                             page.x = _W*2-scrOrgx 
                           
                          else
                      ------放大時點頁
                           -- --print("bbbbb")
                              page:scale(nowrate*page.rate,nowrate*page.rate)
                             
                             page.x =  pageList[1].x + page.contentWidth
                             page.y = scrOrgy + page.contentHeight*0.5
                           
                            ----print("bookmarkbmp.x==",bookmarkbmp.x)                         
                          end
                        
                          pageList:insert(page)
                                     
                     
                          if scalef == false then
                            checkdir = false
                            jumpPagef = true
                            --print("16")
                            turnf = false
                            --autovx = -100  

                            -- if flipType == 1 then
                            --   autovx = -220
                            -- else
                              autovx = -140 
                            --end   

                            autof = true
                            --print("autoturnfn555555")
                            
                            Runtime:addEventListener("enterFrame",autoturnfn )
                          else
                            --print("bigflipfn")
                            jumpPagef = true
                            bigautof = true
                            Runtime:addEventListener("enterFrame",bigAutoFlipFn )
                          end
                       
                        -- smallPageGroup:remove(smallPageGroup.numChildren)
                        -- smallPageGroup[smallPageGroup.numChildren] = nil
                        -- makeOutLine()

                      end
                    end
                  end

                  if dir == "right" then
                                       
                    if  flipType ==1 then 

                     if currentOrientation == "landscapeLeft" or currentOrientation == "landscapeRight" then
                      if pageList.numChildren > 6 then
                        -- local no = pageList[2].no
                        -- if no ~= nil then
                        --   pageList2[no] = 1
                        -- end
                        pageList:remove(2)
                        pageList[2] = nil
                        pageList:remove(2)
                        pageList[2] = nil
                      else
                        if pleft > maxPage then
                        -- local no = pageList[2].no
                        -- if no ~= nil then
                        --   pageList2[no] = 1
                        -- end
                         pageList:remove(2)
                         pageList[2] = nil
                        end
                      end
                     -- ----print("oldpleft===",oldpleft)
                      if oldpleft - 3 > 0 then
                        for i = 1,pageList.numChildren do
                          if pageList[i].no == oldpleft-3 then
                            -- local no = pageList[i].no
                            -- if no ~= nil then
                            --   pageList2[no] = 1
                            -- end
                            pageList:remove(i)

                            pageList[i] = nil
                            break
                          end
                        end
                      elseif oldpleft - 2 > 0 then
                      
                        for i = 1,pageList.numChildren do
                          if pageList[i].no == oldpleft-2 then
                            -- local no = pageList[i].no
                            -- if no ~= nil then
                            --   pageList2[no] = 1
                            -- end
                            pageList:remove(i)
                            pageList[i] = nil
                            break
                          end
                        end
                      end

                      local pos = 0
                      for i = 1,pageList.numChildren do
                        if pageList[i].no == oldpleft - 2 then
                          pos = i
                          break
                        end
                        ------print(pageList[i].name)
                      end
                      if pos > 0 then
                        -- local no = pageList[pos].no
                        -- if no ~= nil then
                        --   pageList2[no] = 1
                        -- end
                        display.remove(pageList[pos])
                        pageList[pos] = nil
                      end
                      for i = pleft,pleft-1,-1 do
                         if i > 0 and i <= maxPage then
       
                          local page = display.newImage(path..i..".png",baseDir,true)
                          if page ==  nil then
                            page = display.newRect( 0, 0, pageList2[oldpleft].width, pageList2[oldpleft].height )
                              page:setFillColor( 1,1,1 )
                            page.name="blank"
                          else
                            page.name="book"..i
                          end

                          local rate1 = (_H*2-scrOrgy*2- statusbarHeight)/page.height
        
                            local rate2 = (_W*2-scrOrgx*2)/page.width
         
                            if i == 1 then
                              if rate1 <= rate2 then
                                rate = rate1
                              else
                                rate = rate2
                              end
                            elseif i == maxPage then
                              if i % 2 == 1 then
                                if rate1*2 <= rate2 then
                                  rate = rate1
                                else
                                  rate = rate2*0.5
                                end
                              else
                                if rate1 <= rate2 then
                                  rate = rate1
                                else
                                  rate = rate2
                                end
                              end
                            else
                              if rate1*2 <= rate2 then
                                rate = rate1
                              else
                                rate = rate2*0.5
                              end
                            end      
                            page.rate = rate
                            originpagewidth = page.width
                            originpageheight = page.height
                            page.originpagewidth = page.width
                            page.originpageheight = page.height

                            page.pagewidth = originpagewidth*rate
                            page.pageheight = originpageheight*rate

                          page.no = i
                          --page.name="book"..i
                          pageList2[i] = page
                          --rate = (_H*2)/page.height
                          page:scale( rate, rate )
                          page.nowrate = rate
                          page.x = _W
                          page.y = pageH
                       
                          pageList:insert(page)

                        end
                      end
                      for i = pleft-1,pleft do
                        if i > 0 and i <= maxPage then
                         if i % 2 == 1 then
                           pageList2[i].anchorX = 0
                           pageList2[i].path.x3 = -2*pageList2[i].originpagewidth
                            pageList2[i].path.x4 = -2*pageList2[i].originpagewidth
                         else
                            pageList2[i].anchorX = 1
                            pageList2[i].path.x1 = 0
                            pageList2[i].path.x2 = 0
                         end
                        end
                        ------print("pageList2[i].x===" ,pageList2[i].x)
                      end
                   
                      p1 = oldpleft -1
                      p2 = pleft
               
                      -- pageList2[p1].no = p1
                     -- ----print("p2============",p2)
                      --mask:toFront( )
                      pageList2[p1]:toFront( )
                      
                      if pleft == 1 then
                        if flipType == 1 then
                          oldflipType = 1
                          flipType = 0
                          pageList2[1].anchorX = 0

                          pageList2[1].x = scrOrgx - pageList2[1].contentWidth - (_W*2 - scrOrgx*2 - pageList2[1].contentWidth)
                          pageList2[1].path.x3 = 0
                          pageList2[1].path.x4 = 0
                          pageList2[1].path.y3 = 0
                          pageList2[1].path.y4 = 0
                          mask:toBack( )
                        end
                      end

                      if flipType == 1 then
                        autovx = 220  
                      else
                        autovx = 140
                      end

                     
                     else
                      ----直 右翻頁
                      
                      local pos = 0
                        for i= 1,pageList.numChildren do
                          if pageList[i].no == oldpleft-1 then
                            pos = i
                          end
                        end
                        if pos > 0 then
                          -- local no = pageList[pos].no
                          -- if no ~= nil then
                          --   pageList2[no] = 1
                          -- end
                          pageList:remove(pos)
                          pageList[pos] = nil
                        end

                        --bookmarkList[bookmarkList.numChildren].no = p1

                        local page = display.newImage(path..nowpleft..".png",baseDir,true)
                                                    
                            if page ==  nil then
                              page = display.newRect( 0, 0, pageList2[oldpleft].width, pageList2[oldpleft].height )
                              page:setFillColor( 1,1,1 )
                              page.name="blank"
                            else
                             page.name="book"..nowpleft
                            end
                             local rate1 = (_H*2-scrOrgy*2- statusbarHeight)/page.height
        
                            local rate2 = (_W*2-scrOrgx*2)/page.width
         
                            if rate1 <= rate2 then
                              rate = rate1
                            else
                              rate = rate2
                            end
                            page.rate = rate
                            originpagewidth = page.width
                            originpageheight = page.height
                            page.originpagewidth = page.width
                            page.originpageheight = page.height

                            page.pagewidth = originpagewidth*rate
                            page.pageheight = originpageheight*rate

                            page.no = nowpleft
                            page.anchorX = 0
                            page.path.x4 = -page.pagewidth
                            page.path.x3 = -page.pagewidth
                            pageList2[nowpleft] = page
                         
                            page:scale( rate, rate )
                            page.nowrate = rate

                            local dx = _W*2-2*scrOrgx - page.width*rate
                            page.x = scrOrgx + dx/2
                            mask.x = page.x
                            page.y = pageH
                            mask.path.x4 = -mask.orgx
                            mask.path.x3 = -mask.orgx
                            mask:toFront( )
                            pageList:insert(page)
                            pageList2[nowpleft]:toFront( )
                            p1 = nowpleft

                       end
                        if p1 == 1 then
                          if flipType == 1 then
                            oldflipType = 1
                            flipType = 0
                            pageList2[1].anchorX = 0
                            pageList2[1].x = scrOrgx - pageList2[1].contentWidth
                            pageList2[1].path.x3 = 0
                            pageList2[1].path.x4 = 0
                            pageList2[1].path.y3 = 0
                            pageList2[1].path.y4 = 0
                            mask:toBack( )
                          end
                        end

                        checkdir = false
                        jumpPagef = true
                      ----print("17")
                        turnf = false
                        -- autovx = 100 
                        -- if flipType == 1 then
                        --   autovx = 220
                        -- else
                          autovx = 140 
                        -- end            
                        autof = true
                        
                        Runtime:addEventListener("enterFrame",autoturnfn )
                    else
                      if currentOrientation == "landscapeLeft" or currentOrientation == "landscapeRight" then

                          p1 = oldpleft -1
                          p2 = pleft

                          local num = pageList.numChildren


                        if num ==  6 then
                          -- local no = pageList[1].no
                          -- if no ~= nil then
                          --   pageList2[no] = 1
                          -- end
                          pageList:remove(1)
                          pageList[1] = nil
                          -- local no = pageList[1].no
                          -- if no ~= nil then
                          --   pageList2[no] = 1
                          -- end
                          pageList:remove(1)
                          pageList[1] = nil
                        
                        else
                          -- local no = pageList[1].no
                          -- if no ~= nil then
                          --   pageList2[no] = 1
                          -- end
                          pageList:remove(1)
                          pageList[1] = nil
                          
                        end

                          for i = pleft,pleft-1,-1 do
                            if i > 0 then
                              --page.x = scrOrgx - (pleft-1-i)*page.width*rate
                              local page = display.newImage(path..i..".png",baseDir,true)
                  
                              if page ==  nil then
                                page = display.newRect( 0, 0, pageList2[oldpleft].width, pageList2[oldpleft].height )
                                  page:setFillColor( 1,1,1 )
                                page.name="blank"
                              else
                                page.name="book"..i
                              end

                              local rate1 = (_H*2-scrOrgy*2- statusbarHeight)/page.height
            
                                local rate2 = (_W*2-scrOrgx*2)/page.width
             
                                if i == 1 then
                                  if rate1 <= rate2 then
                                    rate = rate1
                                  else
                                    rate = rate2
                                  end
                                elseif i == maxPage then
                                  if i % 2 == 1 then
                                    if rate1*2 <= rate2 then
                                      rate = rate1
                                    else
                                      rate = rate2*0.5
                                    end
                                  else
                                    if rate1 <= rate2 then
                                      rate = rate1
                                    else
                                      rate = rate2
                                    end
                                  end
                                else
                                  if rate1*2 <= rate2 then
                                    rate = rate1
                                  else
                                    rate = rate2*0.5
                                  end
                                end   
                                page.rate = rate
                                originpagewidth = page.width
                                originpageheight = page.height
                                page.originpagewidth = page.width
                                page.originpageheight = page.height

                                page.pagewidth = originpagewidth*rate
                                page.pageheight = originpageheight*rate


                                page.anchorX = 0
                                page.no = i
                              --page.name="book"..i
                                pageList2[i] = page
                              --rate = (_H*2)/page.height
                              if scalef == false then
                                page:scale( rate, rate )
                                page.nowrate = rate
                                
                              --page.x = _W
                                page.y = pageH
                                --page.x = scrOrgx + (i-pleft-1)*page.width*rate
                                if i == 1 then
                                  page.x =  scrOrgx - page.contentWidth - (_W*2 - scrOrgx*2 - page.contentWidth)
                                else
                                  page.x = scrOrgx + (i-pleft-1)*page.width*rate
                                end
                              else
                                page:scale(nowrate*page.rate,nowrate*page.rate)
                               
                                page.x = scrOrgx + (i-pleft-1)*page.contentWidth
                                page.y = scrOrgy + page.contentHeight*0.5
                                
                                
                              end
                              pageList:insert(page)
                             
                            end
                          end
                          pageList[1].y = -10000
                      else
                       
                      ----直不翻頁 右
                           p1 = nowpleft

                          local num = pageList.numChildren
                       
                        if num == 2 then
                          -- local no = pageList[1].no
                          -- if no ~= nil then
                          --   pageList2[no] = 1
                          -- end
                          pageList:remove(1)
                          pageList[1] = nil
                         
                        elseif num == 3 then
                          -- local no = pageList[1].no
                          -- if no ~= nil then
                          --   pageList2[no] = 1
                          -- end
                          pageList:remove(1)
                          pageList[1] = nil
                          -- local no = pageList[2].no
                          -- if no ~= nil then
                          --   pageList2[no] = 1
                          -- end
                          pageList:remove(2)
                          pageList[2] = nil
                         
                        end
                      
                        local page = display.newImage(path..p1..".png",baseDir,true)                
                          if page ==  nil then
                            page = display.newRect( 0, 0, pageList2[oldpleft].width, pageList2[oldpleft].height )
                              page:setFillColor( 1,1,1 )
                            page.name="blank"
                          else
                            page.name="book"..p1
                          end
                
                            local rate1 = (_H*2-scrOrgy*2- statusbarHeight)/page.height
        
                            local rate2 = (_W*2-scrOrgx*2)/page.width
         
                            if rate1 <= rate2 then
                              rate = rate1
                            else
                              rate = rate2
                            end
                            page.rate = rate
                            originpagewidth = page.width
                            originpageheight = page.height
                            page.originpagewidth = page.width
                            page.originpageheight = page.height

                            page.pagewidth = originpagewidth*rate
                            page.pageheight = originpageheight*rate


                            page.anchorX = 0
                            page.no = p1

                            pageList2[p1] = page
                        
                            if scalef == false then
                              page:scale( rate, rate )
                              page.nowrate = rate

                              page.y = pageH
                              page.x = scrOrgx - originpagewidth*rate
                           
                            else
                      ------放大時點頁
                              page:scale(nowrate*page.rate,nowrate*page.rate)                    
                              page.x = scrOrgx - page.contentWidth
                              page.y = scrOrgy + page.contentHeight*0.5                            
                            end
                            pageList:insert(page)                         
                     end
                      if scalef == false then
                          checkdir = false
                          jumpPagef = true
                          turnf = false
                          -- autovx = 100 
                          -- if flipType == 1 then
                          --   autovx = 220
                          -- else
                            autovx = 140 
                          --end            
                          autof = true      
                                      
                          Runtime:addEventListener("enterFrame",autoturnfn )
                      else                       
                          jumpPagef = true
                          bigautof = true
                          Runtime:addEventListener("enterFrame",bigAutoFlipFn )
                      end
                    end
                    -- smallPageGroup:remove(smallPageGroup.numChildren)
                    -- smallPageGroup[smallPageGroup.numChildren] = nil
                    -- makeOutLine()

              end
end

local function arrangBookmark()
  -- for i = 1,bookmarkTextlist.numChildren do
  --   display.remove( bookmarkTextlist[1] )
  --   bookmarkTextlist[1] = nil
  --end
  if currentOrientation == "landscapeLeft" or currentOrientation == "landscapeRight" then
        for i = 1,pageList.numChildren do
            local bookmarkbmp = display.newImage( path_image.."bookmark.png" ,true )
            bookmarkbmp.orgwidth = bookmarkbmp.width
            bookmarkbmp.orgheight = bookmarkbmp.height
            bookmarkbmp.anchorX = 0
            bookmarkbmp.no = pageList[i].no
            --if bookmark[bookmarkbmp.no] == 0 then
            if wetools.findone(bookmarkbmp.no,bookmarkNumList) == false then
              bookmarkbmp.alpha = 0.5
            end 

            if scalef == false then
              bookmarkbmp:scale(pageList[i].rate,pageList[i].rate)
              bookmarkbmp.y = pageList[i].y - pageList[i].contentHeight*0.35--scrOrgy + originpageheight*rate*0.15
               if pageList[i].no % 2 == 1 then
                bookmarkbmp.x = pageList[i].x + pageList[i].contentWidth - bookmarkbmp.contentWidth
              else
                bookmarkbmp.x = pageList[i].x 
              end
            else
               bookmarkbmp:scale( pageList[i].rate*nowrate, pageList[i].rate*nowrate )
               bookmarkbmp.y =  pageList[i].y -  pageList[i].contentHeight*0.35
               if pageList[i].no % 2 == 1 then
                 bookmarkbmp.x = pageList[i].x + pageList[i].contentWidth - bookmarkbmp.contentWidth
                 ------print("bookmarkbmp1.x===",bookmarkbmp.x)
              else
                bookmarkbmp.x = pageList[i].x  
                ------print("bookmarkbmp2.x===",bookmarkbmp.x)            
              end
            end    
            --local text = display.newText(tostring(bookmarkbmp.no),bookmarkbmp.x,bookmarkbmp.y + 100,native.systemFont,60) 
            --text:setFillColor( 1,0,0 )
            bookmarkbmp:addEventListener( "touch", bookmarkFn)
            bookmarkList:insert(bookmarkbmp)  

        end
  else
    for i = 1,pageList.numChildren do
      local bookmarkbmp = display.newImage( path_image.."bookmark.png" ,true )
        bookmarkbmp.orgwidth = bookmarkbmp.width
        bookmarkbmp.orgheight = bookmarkbmp.height
        bookmarkbmp.anchorX = 0
        bookmarkbmp.no = pageList[i].no
        --if bookmark[bookmarkbmp.no] == 0 then
        if wetools.findone(bookmarkbmp.no,bookmarkNumList) == false then
          bookmarkbmp.alpha = 0.5
        end 

        if scalef == false then
          bookmarkbmp:scale(rate,rate)
          bookmarkbmp.y = pageList[i].y - pageList[i].contentHeight*0.35--scrOrgy + originpageheight*rate*0.15
           if pageList[i].no % 2 == 1 then
            bookmarkbmp.x = pageList[i].x + pageList[i].contentWidth - bookmarkbmp.contentWidth
          else
            bookmarkbmp.x = pageList[i].x 
          end
        else
           bookmarkbmp:scale( nowrate, nowrate )
           bookmarkbmp.y =  pageList[i].y -  pageList[i].contentHeight*0.35
           if pageList[i].no % 2 == 1 then
             bookmarkbmp.x = pageList[i].x + pageList[i].contentWidth - bookmarkbmp.contentWidth
             ------print("bookmarkbmp1.x===",bookmarkbmp.x)
          else
            bookmarkbmp.x = pageList[i].x  
            ------print("bookmarkbmp2.x===",bookmarkbmp.x)            
          end
        end    
       
        bookmarkbmp:addEventListener( "touch", bookmarkFn)
        bookmarkList:insert(bookmarkbmp)  
       
    end
  end
end

local function arrangPageFn2()
 
  if currentOrientation == "landscapeLeft" or currentOrientation == "landscapeRight" then
    for i = 1,pageList.numChildren do
        pageList:remove(1)
        pageList[1] = nil
        
    end

    local tmppage = nil

    if pleft > maxPage then
      tmppage = display.newImage( path..maxPage..".png",baseDir,true )
    else
      tmppage = display.newImage( path..pleft..".png",baseDir,true )
    end

    if tmppage == nil then
      tmppage = display.newRect( -100000, 0, _W, _H*2 )
    end

    tmppage.x = -100000
    for i = pleft-3,pleft+2 do
      if i > 0 and i <= maxPage then
        
          local nextpage_path = system.pathForFile( path..i..".png", baseDir )
          local mode = lfs.attributes(nextpage_path, "mode")
     
          local page = nil 

          if mode == nil then
            page = display.newRect( 0, 0, tmppage.width, tmppage.height )
            page:setFillColor( 1,1,1 )
            page.name="blank"
          else
            page = display.newImage(path..i..".png",baseDir,true)
            page.name="book"..i
          end

          originpagewidth = page.width
          originpageheight = page.height
          page.originpagewidth = page.width
          page.originpageheight = page.height
          page.anchorX = 0
          page.no = i
          pageList2[i] = page
          local rate1 = (_H*2-scrOrgy*2 - statusbarHeight)/page.height
          local rate2 = (_W*2-scrOrgx*2)/page.width

          -- if rate1*2 <= rate2 then
          --   rate = rate1
          -- else
          --   rate = rate2*0.5
          -- end
          --print("rate1==",rate1)
          --print("rate2==",rate2)
          if i == 1 then
            if rate1 <= rate2 then
              rate = rate1
            else
              rate = rate2
            end
          elseif i == maxPage then
            if i % 2 == 1 then
              if rate1*2 <= rate2 then
                rate = rate1
              else
                rate = rate2*0.5
              end
            else
              if rate1 <= rate2 then
                rate = rate1
              else
                rate = rate2
              end
            end
          else
            if rate1*2 <= rate2 then
              rate = rate1
            else
              rate = rate2*0.5
            end
          end        

          ----print("page.name==",page.name)
          rateh = rate
          --nowrate = rate
          page.rate = rate
          page.nowrate = rate
          page.rateh = rate
          page:scale( rate, rate )
          pagewidth = originpagewidth*rate
          pageheight = originpageheight*rate
          page.pagewidth = pagewidth
          page.pageheight = pageheight

          if i == 1  then
            if pleft == 1 then
              page.x = _W - page.contentWidth*0.5
              page.firstPos = page.x
            else
              page.x = scrOrgx - page.contentWidth
              page.firstPos = _W - page.contentWidth*0.5
            end
          else     
                  if i <= pleft-2 then
                    page.x = scrOrgx - (pleft-1-i)*page.width*rate
                  elseif i > pleft-2 and i <= pleft then
                    page.x = _W - (pleft-i)*page.width*rate
                    if pleft + 2 == maxPage+1 then
                      if i == pleft - 1 then
                        firstPos = page.x
                        leftpos = page.x
                        page.firstPos = page.x
                        page.leftpos = page.x
                      end
                    else
                      if i == pleft then
                        firstPos = page.x
                        rightpos = page.x
                        page.firstPos = page.x
                        page.rightpos = page.x
                      end
                    end

                  else
                    if i == (pleft + 1) then
                      page.x = _W*2 - scrOrgx
                    else               
                        page.x = pageList2[pleft+1].x + pageList2[pleft+1].contentWidth                 
                    end
                    -- page.x = _W*2-scrOrgx + (i-pleft-1)*page.contentWidth
                    page.firstPos = page.x
                        --page.x = _W*2-scrOrgx + (i-pleft-1)*page.width*rate
                        ------print(page.x)
                  end
            end
          -- page.x = _W
            page.orgx = page.x
            page.y = pageH
           
          pageList:insert(page)
          

      end
    end
   -- ----print("333333333")
      if pleft -2 == 1 then
     
        pageList2[1].x = pageList2[2].x - pageList2[1].contentWidth - (_W*2 - scrOrgx*2 - pageList2[1].contentWidth)
        --print("page111111.x===",pageList2[1].x)
        --page.firstPos = page.x
      end
      if pleft + 1 == maxPage then
        pageList2[maxPage].x = _W*2-2*scrOrgx + (_W*2 - 2*scrOrgx - pageList2[maxPage].contentWidth)
      end
      ----print("pleft==",pleft)
      if pleft - 1 == maxPage then
        pageList2[maxPage].x = _W - pageList2[maxPage].contentWidth*0.5
      end


      mutiscalef = false
      autof = false
      turnf = false
      checkdir = true
      canautof = false
      display.remove( tmppage )
      tmppage = nil
    ------print("pagewidth==",pagewidth
  else
    ---直，正常安排
    for i = 1,pageList.numChildren do
        pageList:remove(1)
        pageList[1] = nil
        
    end

    local tmppage = display.newImage( path..p1..".png",baseDir,true )
    tmppage.x = -10000
    
    for i = p1-1,p1+1 do
      if i > 0 and i <= maxPage then
        local page = nil
          
          local nextpage_path = system.pathForFile( path..i..".png", baseDir )
          local mode = lfs.attributes(nextpage_path, "mode")
     
          local page = nil 

          if mode == nil then
            page = display.newRect( 0, 0, tmppage.width, tmppage.height )
            page:setFillColor( 1,1,1 )
            page.name="blank"
          else
            page = display.newImage(path..i..".png",baseDir,true)
            page.name="book"..i
          end

         
          originpagewidth = page.width
          originpageheight = page.height
          page.originpagewidth = page.width
          page.originpageheight = page.height
          page.anchorX = 0
          page.no = i
          local rate1 = (_H*2 -scrOrgy*2- statusbarHeight)/page.height
          local rate2 = (_W*2-scrOrgx*2)/page.width
          
          if rate1 <= rate2 then
            rate = rate1
          else
            rate = rate2
          end
          ratev = rate
          --nowrate = rate
          page:scale( rate, rate )
          page.rate = rate
          page.ratev = rate
          page.nowrate = rate
          pageList2[i] = page
        
       
     
          if i == p1 - 1 then
            page.x = scrOrgx - page.width*rate
          elseif i == p1 then
            local dx = _W*2-2*scrOrgx - page.width*rate
            page.x = scrOrgx + dx/2
            
                firstPos = page.x
                leftpos = page.x

          else
            page.x = _W*2-scrOrgx 
            ------print(page.x)
          end
          -- page.x = _W
            page.orgx = page.x
            page.y = pageH   
            
            pageList:insert(page)
  

      end
    end
   -- ----print("333333333")       
        mutiscalef = false
        autof = false
      turnf = false
      checkdir = true
      canautof = false
      display.remove( tmppage )
      tmppage = nil
  end  
end

local function arrangPageFn()
  if currentOrientation == "landscapeLeft" or currentOrientation == "landscapeRight" then
  --local pageList = display.newGroup()
      for i = 1,pageList.numChildren do
        pageList:remove(1)
        pageList[1] = nil      
      end 

      local tmppage = nil
      if pleft > maxPage then
        tmppage = display.newImage( path..maxPage..".png",baseDir,true )
      else
        tmppage = display.newImage( path..pleft..".png",baseDir,true )
      end

      if tmppage == nil then
        tmppage = display.newRect( -100000, 0, _W, _H*2 )
      end

      tmppage.x = -100000

    for i = pleft+2,pleft-3,-1 do
      if i > 0 and i <= maxPage then
          local nextpage_path = system.pathForFile( path..i..".png", baseDir )
          local mode = lfs.attributes(nextpage_path, "mode")
     
          local page = nil 

          if mode == nil then
            page = display.newRect( 0, 0, tmppage.width, tmppage.height )
            page:setFillColor( 1,1,1 )
            page.name="blank"
          else
            page = display.newImage(path..i..".png",baseDir,true)
            page.name="book"..i
          end
          -- local page = display.newImage(path..i..".png",baseDir,true)        
          -- if page ==  nil then
          --   page = display.newRect( 0, 0, tmppage.width, tmppage.height )
          --   page:setFillColor( 1,1,1 )
          --   page.name="blank"
          -- else
          --    page.name="book"..i
          -- end        
          originpagewidth = page.width
          originpageheight = page.height
          page.no = i

          page.originpagewidth = page.width
          page.originpageheight = page.height

          pageList2[i] = page
          --rate = (_H*2)/page.height
          local rate1 = (_H*2-scrOrgy*2- statusbarHeight)/page.height
         -- ----print("rate1====",rate)
          local rate2 = (_W*2-scrOrgx*2)/page.width
         -- ----print("rate2====",rate2)
          -- if rate1*2 <= rate2 then
          --   rate = rate1
          -- else
          --   rate = rate2*0.5
          -- end
          
          if i == 1 then
            if rate1 <= rate2 then
              rate = rate1
            else
              rate = rate2
            end
          elseif i == maxPage then
            if i % 2 == 1 then
              if rate1*2 <= rate2 then
                rate = rate1
              else
                rate = rate2*0.5
              end
            else
              if rate1 <= rate2 then
                rate = rate1
              else
                rate = rate2
              end
            end
          else
            if rate1*2 <= rate2 then
              rate = rate1
            else
              rate = rate2*0.5
            end
          end      

          page.rate = rate
          page.nowrate = rate
          page:scale( rate, rate )
          -- bookmarkbmp:scale(rate,rate)
          if i == 1 then
            page.x = -1000
          elseif i> maxPage-1 then
            page.x = -1000
          else      
            page.x = _W
          end
          page.y = pageH
          pagewidth = originpagewidth*rate
          pageheight = originpageheight*rate
          page.pagewidth = pagewidth
          page.pageheight = pageheight

          -- bookmarkbmp.y = scrOrgy + originpageheight*rate*0.15         
          pageList:insert(page)
          --bookmarkList:insert(bookmarkbmp)       
        --end
      end
  end
  
    display.remove( mask )
    mask = nil

    mask = display.newImage( path_image.."mask1.png",true )
    mask.orgx = mask.width
    mask.orgy = mask.height

    --print("numchildren==",pageList[pageList.numChildren].name)
    local tmppage = 0 
    if pleft> maxPage then
      tmppage = pleft-1
    else
      tmppage = pleft
    end
    local rate1 = pageList2[tmppage].contentWidth/mask.width
    local rate2 = pageList2[tmppage].contentHeight/mask.height
    local maskrate = 0
    if rate1 > rate2 then
      maskrate = rate2
    else
      maskrate = rate1
    end
    -- mask.width = pageList2[pleft].width
    -- mask.width = pageList2[pleft].height
    
    mask:scale( 0.98*maskrate, 0.98*maskrate)
   

    ----print("pageList2[p1].x=",pageList2[p1].x)
    mask.anchorX = 0
    mask.x =_W
    mask.y = pageH
    mask.name = "mask"
   -- --print("mask.x=",mask.x)
    pageList:insert(mask)

    mask:toBack( )
    if pleft == 1 then
      mask.path.x4 = 0
      mask.path.x3 = 0
    end
    if pleft >= maxPage then
      mask.path.x4 = -pageList2[maxPage].contentWidth
      mask.path.x3 = -pageList2[maxPage].contentWidth
    end
           -- pagex = page.x
           -- pagey = page.y
    if pleft == 1 then
      
      for i = 1,3 do
        if i%2 ==1 then
          pageList2[i].anchorX = 0
          pageList2[i].path.x3 = 0
          pageList2[i].path.x4 = 0
        else
          pageList2[i].anchorX = 1
          pageList2[i].path.x1 = 2*pageList2[i].originpagewidth
          pageList2[i].path.x2 = 2*pageList2[i].originpagewidth
        end
      end
    else
      for i = pleft-3,pleft-1 do
       if i > 0 then
         
        pageList2[i]:toFront( )
        if i % 2 == 1 then
            if i == pleft - 2 then
              pageList2[i].anchorX = 0
              pageList2[i].path.x1 = 0
              pageList2[i].path.x2 = 0
              pageList2[i].path.x3 = -pageList2[i].originpagewidth
              pageList2[i].path.x4 = pageList2[i].path.x3
            else
              pageList2[i].anchorX = 0
              pageList2[i].path.x3 = -pageList2[i].originpagewidth*2
              pageList2[i].path.x4 = pageList2[i].path.x3
              pageList2[i].path.x1 = 0
              pageList2[i].path.x2 = 0
            end
        else
            pageList2[i].anchorX = 1
            pageList2[i].path.x1 = 0
            pageList2[i].path.x2 = 0
            pageList2[i].path.x3 = 0
            pageList2[i].path.x4 = 0
        end
       end
      end
      for i = pleft,pleft+2 do
       if i <= maxPage then
        --local tmp = pageList2[i]
       -- tmp:toFront( )
        if i % 2 == 1 then

            pageList2[i].anchorX = 0
            --print("i=",i)
            --print("pleft+1=",pleft+1)
           

              pageList2[i].path.x3 = 0
              pageList2[i].path.x4 = 0
              pageList2[i].path.x1 = 0
              pageList2[i].path.x2 = 0
            
        else
          pageList2[i].anchorX = 1
             if i == pleft + 1 then
              --print("pagelist2[i].name==",pageList2[i].name)
              pageList2[i].path.x1 = pageList2[i].originpagewidth
              pageList2[i].path.x2 = pageList2[i].originpagewidth
              pageList2[i].path.x3 = 0
              pageList2[i].path.x4 = 0
            else

              
              pageList2[i].path.x1 = 2*pageList2[i].originpagewidth
              pageList2[i].path.x2 = 2*pageList2[i].originpagewidth
              pageList2[i].path.x3 = 0
              pageList2[i].path.x4 = 0
            end
        end
       end
      end
    end   
    if pleft == 3 then
      pageList2[1].anchorX = 0
      
      pageList2[1].x = pageList2[2].x - pageList2[1].contentWidth - (_W*2 - scrOrgx*2 - pageList2[1].contentWidth) - pageList2[2].contentWidth
      
    end
    mutiscalef = false
      autof = false
      turnf = false
      checkdir = true
      canautof = false

      display:remove( tmppage )
      tmppage = nil

  else
    --直

    for i = 1,pageList.numChildren do
        pageList:remove(1)
        pageList[1] = nil
    end
  
    local tmppage = display.newImage( path..p1..".png",baseDir,true )
    if tmppage == nil then
      tmppage = display.newRect( 0, 0, _W*2, _H*2 )
    end
    tmppage.x = -10000
      for i = p1+1,p1-1,-1 do
        if i > 0 and i <= maxPage then
          local nextpage_path = system.pathForFile( path..i..".png", baseDir )
          local mode = lfs.attributes(nextpage_path, "mode")
     
          local page = nil 

          if mode == nil then
            page = display.newRect( 0, 0, tmppage.width, tmppage.height )
            page:setFillColor( 1,1,1 )
            page.name="blank"
          else
            page = display.newImage(path..i..".png",baseDir,true)
            page.name="book"..i
          end
          -- local page = display.newImage(pageList,path..i..".png",baseDir) 
          -- if page ==  nil then
          --   page = display.newRect( 0, 0, tmppage.width, tmppage.height )
          --   page:setFillColor( 1,1,1 )
          --   page.name = "book"..i
          --   pageList2[i] = page 
          -- else
          --    page.name="book"..i
             
          -- end 
          pageList2[i] = page 
          originpagewidth = page.width
          originpageheight = page.height
          page.originpagewidth = page.width
          page.originpageheight = page.height
         
          page.anchorX = 0
      -- rate = (_H*2)/page.height
          local rate1 = (_H*2-scrOrgy*2- statusbarHeight)/page.height
           -- ----print("rate1====",rate)
          local rate2 = (_W*2-scrOrgx*2)/page.width
            ------print("rate2====",rate)
          if rate1 <= rate2 then
           rate = rate1
          else
           rate = rate2
          end
          page.rate = rate
         -- nowrate = rate
          page.nowrate = rate
          page:scale( rate, rate )
          page.no = i
     -- page.name = "book"..i
          
          local dx = _W*2-2*scrOrgx - page.width*rate
            page.x = scrOrgx + dx/2

         -- page.x = 0
          page.y = pageH
           ----print("page.name==",page.name)
           pagewidth = originpagewidth*rate
           pageheight = originpageheight*rate
           page.pagewidth = originpagewidth*rate
           page.pageheight = originpagewidth*rate

          pageList:insert(page)
          if i == p1-1 then
            page:toBack( )
            --page.path.x3 = -originpagewidth
            --page.path.x4 = -originpagewidth
          end
      end
    end
        
    ------print("rate2===",rate)
        display.remove( mask )
                        mask = nil
        local dx = _W*2-2*scrOrgx - pageList2[p1].originpagewidth*pageList2[p1].rate
        mask = display.newImage( pageList,path_image.."mask1.png",true )
        mask.orgx = mask.width
        mask.orgy = mask.height
        mask.name = "mask"
        ----print("mask.contentWidth=========",mask.contentWidth)
        local rate1 = pageList2[p1].contentWidth/mask.width
        local rate2 = pageList2[p1].contentHeight/mask.height
        local maskrate = 0
        if rate1 > rate2 then
          maskrate = rate2
        else
          maskrate = rate1
        end
    -- mask.width = pageList2[pleft].width
    -- mask.width = pageList2[pleft].height
    
    mask:scale( 0.98*maskrate, 0.98*maskrate)
        
        --mask:scale( 0.98*rate1, 0.98*rate1)
        ----print("mask.width===",mask.width)
        mask.anchorX = 0
        mask.x =scrOrgx + dx/2
        mask.y = pageH 
        mask:toFront( )

       pageList2[p1]:toFront( )

        
    

     mutiscalef = false
    turnf = false
                    
    checkdir = true
          --mask:toBack( )
    autof = false
    canautof = false
    if tmppage ~= nil then
      display.remove( tmppage )
      tmppage = nil
    end
  end
   
end

local function mutimoveFn(evnet)
  -- if textnum2 == nil then
  --     textnum2 = display.newText(tostring( system.getTimer()) ,250,200,native.systemFont,30)
  --     textnum2:setFillColor( 1,0,0 )
  --     sceneGroup:insert(textnum2)
  --   else
  --     textnum2.text = tostring(system.getTimer())
  --   end

  if mutimovefh == true then
    if currentOrientation == "landscapeLeft" or currentOrientation == "landscapeRight" then
        if pleft == 1 then
          local dx = (_W-pageList2[1].contentWidth*0.5) - pageList2[1].x
          local dy = pageH - pageList2[1].y
          dx = dx/6
          dy = dy/6
          pageList2[1].x = pageList2[1].x + dx
          pageList2[1].y = pageList2[1].y + dy
          if math.abs(dx) < 0.1 then
            nowrate = 1
            pageList2[1].x = (_W-pageList2[1].contentWidth*0.5)
            pageList2[1].y = pageH
            mutimovefh = false
            scalef = false
            scaleing = false
            onoff.alpha = 1.0
            numTouches = 0
            for i = 1,pageList.numChildren do
              if pageList[i].no ~= 1 then
                pageList[i].y = pageH
              end
            end
            -- if oldflipType == 1 then
            --   flipType = 1
            --   arrangPageFn()
            -- else
              flipType = 0
              arrangPageFn2()
            -- end
               Runtime:removeEventListener("enterFrame",mutimoveFn)
          end
        elseif pleft > maxPage then
          local dx = (_W-pageList2[maxPage].contentWidth*0.5) - pageList2[maxPage].x
          local dy = pageH - pageList2[maxPage].y
          dx = dx/6
          dy = dy/6
          pageList2[maxPage].x = pageList2[maxPage].x + dx
          pageList2[maxPage].y = pageList2[maxPage].y + dy
          if math.abs(dx) < 0.1 then
            nowrate = 1
            pageList2[maxPage].x = (_W-pageList2[maxPage].contentWidth*0.5)
            pageList2[maxPage].y = pageH
            mutimovefh = false
            scalef = false
            scaleing = false
            onoff.alpha = 1.0
            numTouches = 0
            for i = 1,pageList.numChildren do
              if pageList[i].no ~= maxPage then
                pageList[i].y = pageH
              end
            end
            -- if oldflipType == 1 then
            --   flipType = 1
            --   arrangPageFn()
            -- else
              flipType = 0
              arrangPageFn2()
            -- end
               Runtime:removeEventListener("enterFrame",mutimoveFn)
          end
        else
          local dx = _W - pageList2[pleft].x
          local dy = pageH - pageList2[pleft].y
          dx = dx/6
          dy = dy/6
          pageList2[pleft].x = pageList2[pleft].x + dx
          pageList2[pleft].y = pageList2[pleft].y + dy 
          pageList2[pleft-1].x = pageList2[pleft].x - pageList2[pleft-1].contentWidth
          pageList2[pleft-1].y = pageList2[pleft].y 
          if math.abs(dx) < 0.1 then
            nowrate = 1
            pageList2[pleft].x = _W
            pageList2[pleft].y = pageH
            pageList2[pleft-1].x = pageList2[pleft].x - pageList2[pleft-1].contentWidth
            pageList2[pleft-1].y = pageList2[pleft].y 
            mutimovefh = false
            for i = 1,pageList.numChildren do
                if pageList[i].no ~= pleft and pageList[i].no ~= pleft-1 then
                  pageList[i].y = pageH
                end
            end
            scalef = false
            scaleing = false
            onoff.alpha = 1.0
            numTouches = 0
            if oldflipType == 1 then
              if pleft == maxPage then
                flipType = 0
                arrangPageFn2()
              else
                flipType = 1
                arrangPageFn()
              end
            else
              arrangPageFn2()
            end
              Runtime:removeEventListener("enterFrame",mutimoveFn)
          end
        end
    else
      local dw = _W*2-2*scrOrgx - pageList2[p1].originpagewidth*pageList2[p1].rate
      local dx = scrOrgx - pageList2[p1].x + dw/2 
      local dy = pageH - pageList2[p1].y 
      dx = dx/7
      dy = dy/7
      pageList2[p1].x = pageList2[p1].x + dx
      pageList2[p1].y = pageList2[p1].y + dy   
      if math.abs(dx) < 0.1 then
        nowrate = 1
        pageList2[p1].x = scrOrgx + dw/2
        pageList2[p1].y = pageH
        mutimovefh = false
        for i = 1,pageList.numChildren do
          if pageList[i].no ~= p1 then
            pageList[i].y = pageH
          end
        end
        scalef = false
        scaleing = false
        onoff.alpha = 1.0
        numTouches = 0
        if oldflipType == 1 then
          if p1 == 1 or p1 == maxPage then
            flipType = 0
            arrangPageFn2()
          else
            flipType = 1
            arrangPageFn()
          end
        else
          flipType = 0
          arrangPageFn2()
        end
           Runtime:removeEventListener("enterFrame",mutimoveFn)
      end    
    end
  end
end

local function arrangBigPageFn()

  if currentOrientation == "landscapeLeft" or currentOrientation == "landscapeRight" then

    for i = 1,pageList.numChildren do
        pageList:remove(1)
        pageList[1] = nil
       
    end

    local tmppage = nil
    if pleft > maxPage then
      tmppage = display.newImage( path..maxPage..".png",baseDir,true )
    else
      tmppage = display.newImage( path..pleft..".png",baseDir,true )
    end

    if tmppage == nil then
      tmppage = display.newRect( -100000, 0, _W, _H*2 )
    end

    tmppage.x = -100000

    for i = pleft-3,pleft+2 do
      if i > 0 and i <= maxPage then
          local nextpage_path = system.pathForFile( path..i..".png", baseDir )
          local mode = lfs.attributes(nextpage_path, "mode")
     
          local page = nil 

          if mode == nil then
            page = display.newRect( 0, 0, tmppage.width, tmppage.height )
            page:setFillColor( 1,1,1 )
            page.name="blank"
          else
            page = display.newImage(path..i..".png",baseDir,true)
            page.name="book"..i
          end

          -- local page = display.newImage(path..i..".png",baseDir,true)        
          -- if page ==  nil then
          --   page = display.newRect( 0, 0, tmppage.width, tmppage.height )
          --   page:setFillColor( 1,1,1 )
          --   page.name="blank"
          -- else
          --   page.name="book"..i
          -- end


            originpagewidth = page.width
            originpageheight = page.height
            page.originpagewidth = page.width
            page.originpageheight = page.height

          page.anchorX = 0
         -- bookmarkbmp.anchorX = 0
          page.no = i
          --page.name="book"..i
          pageList2[i] = page
          

          local rate1 = (_H*2-scrOrgy*2- statusbarHeight)/page.height
         -- ----print("rate1====",rate)
          local rate2 = (_W*2-scrOrgx*2)/page.width
         -- ----print("rate2====",rate2)
          -- if rate1*2 <= rate2 then
          --   rate = rate1
          -- else
          --   rate = rate2*0.5
          -- end
          
          if i == 1 then
            if rate1 <= rate2 then
              rate = rate1
            else
              rate = rate2
            end
          elseif i == maxPage then
            if i % 2 == 1 then
              if rate1*2 <= rate2 then
                rate = rate1
              else
                rate = rate2*0.5
              end
            else
              if rate1 <= rate2 then
                rate = rate1
              else
                rate = rate2
              end
            end
          else
            if rate1*2 <= rate2 then
              rate = rate1
            else
              rate = rate2*0.5
            end
          end      

          
          page.rate = rate
          --print(" page.rate===", page.rate)
          -- if page.rate ~= targetrate then
          --   local nowrate2 = nowrate*(targetrate/page.rate)
          --   page:scale( nowrate2, nowrate2 )
          --   page.nowrate = nowrate2
          -- else
          --   page:scale( nowrate, nowrate )
          --   page.nowrate = nowrate
          -- end
         
         -- bookmarkbmp:scale(nowrate,nowrate)
          page.nowrate = rate * nowrate
          page:scale( page.nowrate, page.nowrate )
          --   page.nowrate = nowrate

          if i <= pleft-2 then
            page.x = scrOrgx - (pleft-1-i)*originpagewidth*page.nowrate
          elseif i > pleft-2 and i <= pleft then
            if pleft > 1 then
             -- ----print("i==",i)
              page.x = scrOrgx + (i-(pleft- 1))*originpagewidth*page.nowrate
             -- ----print("page.x===",page.x)
            else
            
              page.x =  _W*2 -scrOrgx - originpagewidth*page.nowrate
             -- ----print("page.x===",page.x)
            end

          else
            if i == (pleft + 1) then
              page.x = _W*2 - scrOrgx
            else               
                page.x = pageList2[pleft+1].x + pageList2[pleft+1].contentWidth                 
            end
            -- page.x = _W*2-scrOrgx + (i-pleft-1)*originpagewidth*page.nowrate
             ------print("page.x===",page.x)
          end
         

            page.y = scrOrgy + originpageheight*page.nowrate*0.5
            --bookmarkbmp.y =  page.y -  contentHeight*0.35
             -- local textnum2 = display.newText(tostring(page.y),100,50+50*i,native.systemFont,50)
             --  textnum2:setFillColor( 1,0,0 )
             --   sceneGroup:insert(textnum2)
            pageList2[i] = page
           -- bookmarkbmp:addEventListener( "touch", bookmarkFn )
            pageList:insert(page)
            --bookmarkList:insert(bookmarkbmp)
      end
    end
    mutiscalef = false
    autof = false
      turnf = false
      checkdir = true
      canautof = false
      display.remove( tmppage )
      tmppage = nil
  else
    ---直 , 放大安排
 
    for i = 1,pageList.numChildren do
        pageList:remove(1)
        pageList[1] = nil
        
    end
    local tmppage = display.newImage( path..p1..".png",baseDir,true )
    tmppage.x = -10000
    for i = p1-1,p1+1 do
      if i > 0 and i <= maxPage then
          local nextpage_path = system.pathForFile( path..i..".png", baseDir )
          local mode = lfs.attributes(nextpage_path, "mode")
     
          local page = nil 

          if mode == nil then
            page = display.newRect( 0, 0, tmppage.width, tmppage.height )
            page:setFillColor( 1,1,1 )
            page.name="blank"
          else
            page = display.newImage(path..i..".png",baseDir,true)
            page.name="book"..i
          end



        --local page = display.newImage(path..i..".png",baseDir,true)
                 
        -- if page ==  nil then
        --   page = display.newRect( 0, 0, tmppage.width, tmppage.height )
        --   page:setFillColor( 1,1,1 )
        --   page.name="blank"
        -- else
        --   page.name="book"..i
        -- end

           local rate1 = (_H*2 -scrOrgy*2- statusbarHeight)/page.height
          local rate2 = (_W*2-scrOrgx*2)/page.width
          
          if rate1 <= rate2 then
            rate = rate1
          else
            rate = rate2
          end
          ratev = rate
       
          page.rate = rate
          page.nowrate = rate*nowrate

          originpagewidth = page.width
          originpageheight = page.height

          page.originpagewidth = page.width
          page.originpageheight = page.height
     
          page.anchorX = 0
         
          page.no = i
          
          --if bookmark[i] == 0 then
             
          pageList2[i] = page
          
          page:scale( page.nowrate, page.nowrate )
          
          if i == p1 - 1 then
            page.x = scrOrgx - originpagewidth*page.nowrate
          elseif i == p1 then
            page.x = scrOrgx
                firstPos = page.x
                leftpos = page.x
                page.firstPos = page.x
                page.leftpos = page.x
          elseif i == p1 then
            page.x = scrOrgx
            firstPos = page.x
            leftpos = page.x
            page.firstPos = page.x
            page.leftpos = page.x
          else
            page.x = scrOrgx + originpagewidth*page.nowrate
            --print(page.x)
          end
          -- page.x = _W
            page.orgx = page.x
            page.y = scrOrgy + originpageheight*page.nowrate*0.5
                   
            pageList2[i] = page
            pageList:insert(page)

      end
    end
   -- ----print("333333333")       
        mutiscalef = false
        autof = false
      turnf = false
      checkdir = true
      canautof = false
      display.remove( tmppage )
      tmppage = nil
  end
end



local loadnum = 0



local function updatepage()
  if scalef == false then
    if currentOrientation == "landscapeLeft" or currentOrientation == "landscapeRight" then
        
          if oldflipType == 1 then
             
            if pleft < maxPage then
              if pleft > 1 then
                flipType = 1
                arrangPageFn()
              else
                flipType = 0
                arrangPageFn2()
              end
            else
              ----print("aaaaaa")
              flipType = 0
              arrangPageFn2()
            end
          else
            flipType = 0
             arrangPageFn2()
          end
        
    else
      if oldflipType == 1 then
        if p1 < maxPage and p1 > 1  then
          flipType = 1
          arrangPageFn()
        else
          arrangPageFn2()
        end
      else
        arrangPageFn2()
      end
    end
  else
    arrangBigPageFn()
  end
  loadingImg.isVisible = false
  loadingf = false
end


function loadpageList(num)
  
  local params = {}  params.progress = true
  local dpi = "150"
  -- loadingImg.x = display.contentWidth*0.5
  -- loadingImg.y = display.contentHeight*0.5
  -- loadingImg.isVisible = true
  -- loadingImg:toFront( )
  -- loadingf = true
  local function networkListener( event )
    if ( event.isError ) then
      
        num = num +  1
        if num <= maxPage then
          loadpageList(num)
        end
     
      
    elseif ( event.phase == "began" ) then
        ----print( "Progress Phase: began" )
    elseif ( event.phase == "ended" ) then
      
      
        num = num + 1
        if num <= maxPage then
          loadpageList(num)
        end
       
    end
  end

  local nextpage_path2 = system.pathForFile( choice_bookcode.."/"..num..".png", system.TemporaryDirectory )
  local mode2 = lfs.attributes(nextpage_path2, "mode")
  ----print("fh===",fh)

  if mode2 == nil then
      print("num===",num)
      requestId = network.download(
     --"https://s1.yimg.com/rz/d/yahoo_zh-Hant-TW_f_p_bestfit.png",
      gConServ.getURL() .. choice_bookcode .. "/" .. num .. "/" .. dpi .. "/content.png",
      "GET",
      networkListener,
      params,
      choice_bookcode.."/"..num..".png", -- put subfolder path here
      system.TemporaryDirectory
    )
  else
    num = num + 1
    if num <= maxPage then
      loadpageList(num)
    end
  end
end


--翻頁,放大，縮小，移動頁面時，連續複雜操作時，偶爾出現錯亂。
local function loadpage2(pa,upd)
  local params = {}  params.progress = true
  local dpi = "150"
  loadingImg.x = display.contentWidth*0.5
  loadingImg.y = display.contentHeight*0.5
  loadingImg.isVisible = true
  loadingImg:toFront( )
  loadingf = true

  --print("aaaa")
  local function networkListener( event )
    if ( event.isError ) then
      if loadnum == 1 then
        loadnum = 0
        if upd == false then
          start()
        else
          updatepage()
        end
      else
        loadnum = loadnum +  1
        if pa+loadnum <= maxPage then
          loadpage2(pa,true)
        else
          loadnum = 0
          updatepage()
        end
      end
      loadingImg.isVisible = false
      loadingf = false
    elseif ( event.phase == "began" ) then
        ----print( "Progress Phase: began" )
    elseif ( event.phase == "ended" ) then
      loadingImg.isVisible = false
      loadingf = false
      if loadnum == 1 then
        loadnum = 0
        if upd == false then
          start()
        else
          updatepage()
        end
      else
        loadnum = loadnum +  1
        if pa + loadnum <= maxPage then
          loadpage2(pa,true)
        else
          loadnum = 0
          updatepage()
        end
      end
    end
  end

  network.download(
    --"https://s1.yimg.com/rz/d/yahoo_zh-Hant-TW_f_p_bestfit.png",
    gConServ.getURL() .. choice_bookcode .. "/" .. (pa+loadnum) .. "/" .. dpi .. "/content.png",
    "GET",
    networkListener,
    params,
    choice_bookcode.."/"..(pa+loadnum)..".png", -- put subfolder path here
    system.TemporaryDirectory
  )

end

local function loadpage(pa,upd)
  local params = {}  params.progress = true
  local dpi = "150"
  loadingImg.x = display.contentWidth*0.5
  loadingImg.y = display.contentHeight*0.5
  --loadingImg:scale( 0.6, 0.6 )
  loadingImg.isVisible = true
  loadingImg:toFront( )
  loadingf = true
  print("loadpage.........")
    local function networkListener( event )
      if ( event.isError ) then
        if upd == false then
          start()
        else
          updatepage()
        end
        loadingImg.isVisible = false
        loadingf = false
      elseif ( event.phase == "began" ) then
          ----print( "Progress Phase: began" )
      elseif ( event.phase == "ended" ) then
        loadingImg.isVisible = false
        loadingf = false
        if upd == false then
          start()
        else
          updatepage()
        end
      end
    end

    network.download(
    --"https://s1.yimg.com/rz/d/yahoo_zh-Hant-TW_f_p_bestfit.png",
      gConServ.getURL() .. choice_bookcode .. "/" .. pa .. "/" .. dpi .. "/content.png",
      "GET",
      networkListener,
      params,
      choice_bookcode.."/"..pa..".png", -- put subfolder path here
      system.TemporaryDirectory
    )

end

local function thumbnailListener( event )
        if ( event.isError ) then

            --print( "Network error - download failed thumbnail = ", thumbpage )
            --table.insert( thumberrpage,  thumbpage)
            --thumbpage = thumbpage+1
            loadthumb()
            --netThumbnail()
            

        elseif ( event.phase == "began" ) then
            ----print( "Progress Phase: began" )
        elseif ( event.phase == "ended" ) then
            ----print( "displaying response image file" )
            -- --print( "filename = ", event.response.filename )
            -- --print( "docDirectory = ", event.response.docDirectory )

            local pos = thumbpage*2-1
            ----print("pos==",pos)
            -- --print("smallPageGroup.num==",smallPageGroup.numChildren)
             ----print("smallPageGroup[pos].name===",smallPageGroup[pos].name)
            local oldx = smallPageGroup[pos].x
            local oldy = smallPageGroup[pos].y
            local orgx = smallPageGroup[pos].orgx
            local oldwidth = smallPageGroup[pos].contentWidth
            smallPageGroup:remove(pos)
            --smallPageGroup[pos] = nil
            local smallpage = display.newImage( path_thumb..thumbpage..".png",baseDir,true)
            ----print("smallpage==",smallpage)
            smallPageGroup:insert(pos,smallpage)
            

            
            smallrate = (boxDown.height-40)/smallpage.height
            ----print("smallrate==",smallrate)
            smallpage.name = "book"..thumbpage
            smallpage.no =thumbpage
            
            smallpage:scale( smallrate, smallrate )
            smallpage.smallrate = smallrate
            
            if thumbpage > 1 then
              if thumbpage % 2 == 0 then
                ----print(smallpage.contentWidth-oldwidth)
                smallpage.x = smallPageGroup[pos-2].x + (smallpage.contentWidth+smallPageGroup[pos-2].contentWidth)*0.5 + 20
                smallpage.orgx = smallPageGroup[pos-2].orgx+ (smallpage.contentWidth+smallPageGroup[pos-2].contentWidth)*0.5 + 20
              else
                smallpage.x = smallPageGroup[pos-2].x + (smallpage.contentWidth+smallPageGroup[pos-2].contentWidth)*0.5 
                smallpage.orgx = smallPageGroup[pos-2].orgx + (smallpage.contentWidth+smallPageGroup[pos-2].contentWidth)*0.5 
                
              end
              smallPageGroup[pos+1].x = smallpage.x
            else
              smallpage.x = oldx
              smallpage.orgx = orgx
            end
            smallpage.y = oldy

            
              if thumbpage == 1 then
                makeOutLine()
              end
            
            if thumbpage == maxPage then
              --print("aaaaaaaaaaaa")
              transition.to( boxUp, { time=400, y=boxUp.height*0.5+statusbarHeight +scrOrgy} )
              transition.to( boxDown, { time=400, y=_H*2-boxDown.height*0.5-scrOrgy} )
              transition.to( library, { time=400, y=boxUp.height*0.5+statusbarHeight+scrOrgy} )
              transition.to( contents, { time=400, y=boxUp.height*0.5+statusbarHeight+scrOrgy} )
             
              transition.to( onoff, { time=400, y=boxUp.height*0.5+statusbarHeight+scrOrgy} )
              transition.to(smallPageGroup,{time = 400,y=0})
              setupt = system.getTimer( )
              if setupFirst == true then    
                Runtime:addEventListener("enterFrame",closeOptionFn)
              end
            end

            thumbpage = thumbpage+1


            ----print("current download thumbnail = ", thumbpage)
            loadthumb()
            
        end
    end

function loadthumb()

  if thumbpage <= maxPage then 
    
    local nextpage_path = system.pathForFile( path_thumb..thumbpage..".png", system.TemporaryDirectory )
    --local fh = io.open( nextpage_path, "r" )
    local mode = lfs.attributes(nextpage_path, "mode")
    ----print("mode===",mode)
    if mode == nil then
       -- --print("fh===",fh)
       -- --print("thumbpage==",thumbpage)
       -- --print("-------------------------")
     -- --print("choice_bookcode",choice_bookcode)
      ----print("aaa=",choice_bookcode.."thumb/"..thumbpage..".png")
      local params = {}  params.progress = true
        network.download(
                    --"https://s1.yimg.com/rz/d/yahoo_zh-Hant-TW_f_p_bestfit.png",
                    gConServ.getURL() .. choice_bookcode .. "/" .. thumbpage .. "/thumbnail.png",
                    "GET",
                    thumbnailListener,
                    params,
                    path_thumb..thumbpage..".png", -- put subfolder path here
                    system.TemporaryDirectory
                    )
    else
      -- --print("have......")
      -- --print("thumbpage==",thumbpage)
      -- --print("-------------------------")
      if pleft <= maxPage then
        if thumbpage == pleft then
          makeOutLine()
        end
      else
        if thumbpage == maxPage then
          makeOutLine()
        end
      end
      thumbpage = thumbpage+1
      loadthumb()
    end

  

  end
end





function autoturnfn(event)
  --if num1 = nil
  -- --print("autof===",autof)
  --print("autovx==",autovx)
  if autof == false then
    Runtime:removeEventListener("enterFrame",autoturnfn)
  end

  if currentOrientation == "landscapeLeft" or currentOrientation == "landscapeRight" then
    if autof == true then
    ---橫向
      if flipType == 1 then
        if p1 % 2 == 1 then
               -- ----print("aaaaaaa")

              ----單頁左右翻

              local pos1 = wetools.getpos2(mask,pageList)
                    
                    local pos = wetools.getpos2( pageList2[p1],pageList)
                    if pos1 < pos-1 then
                      mask:toFront( )
                      pageList2[p1]:toFront()
                    end

                if pageList2[p1].path.x4 + autovx > -pageList2[p1].originpagewidth then

                  if pageList2[p1].path.x4 + autovx < 0 then
                    
                       pageList2[p1].path.x4 = pageList2[p1].path.x4 + autovx
                       local dx = pageList2[p1].originpagewidth + pageList2[p1].path.x4
                  
                       local ang = math.acos(dx/pageList2[p1].originpagewidth)*0.3
                        pageList2[p1].path.x3 = pageList2[p1].path.x4
                        pageList2[p1].path.y4 = -pageList2[p1].originpagewidth*math.sin(ang)
                        pageList2[p1].path.y3 = pageList2[p1].path.y4

                        -- pageList2[p2].path.x1 = pageList2[p2].path.x1+autovx 
                        -- pageList2[p2].path.x2 = pageList2[p2].path.x2+autovx
                     
                        -- pageList2[p2].path.y1 = pageList2[p1].path.y3
                        -- pageList2[p2].path.y2 = pageList2[p1].path.y3
                       -- --print("p2===",pageList2[p2])
                          pageList2[p2].path.x1 = pageList2[p2].originpagewidth
                          pageList2[p2].path.x2 = pageList2[p2].originpagewidth
                     
                          pageList2[p2].path.y1 = 0
                          pageList2[p2].path.y2 = 0
                        ------print("mask.alpha===",mask.alpha)
                        local mx4 = pageList2[p1].path.x4*1.1
                        
                        mratex = mask.width/pageList2[p1].originpagewidth
                        mratey = mask.height/pageList2[p1].originpageheight

                        if mx4 < -pageList2[p1].originpagewidth then mx4 = -pageList2[p1].originpagewidth end
                           mask.path.x4 = mx4*mratex
                           mask.path.x3 = mx4*mratex
                          mask.path.y3 = -mratey*pageList2[p1].originpagewidth*math.sin(ang)/4
                        if math.abs(mask.path.x4+pageList2[p1].originpagewidth) < 3 then
                          mask.alpha = 0
                          mask:toFront( )
                          pageList2[p2].alpha = 0
                   
                          pageList2[p2].path.x4=0
                          pageList2[p2].path.x3=0
                          pageList2[p2].path.x1=pageList2[p2].originpagewidth
                          pageList2[p2].path.x2=pageList2[p2].originpagewidth
                          pageList2[p2].path.y3 = 0
                          pageList2[p2].path.y4 = 0
                    

                        end
                        ----print("900")
                        canautof = true
                  else
                    ------print("pageList2[p2].path.x1===",pageList2[p2].path.x1)
                    canautof = false
                    ----print("1111111111")
                    turnf = false
                    checkdir = true
                    pageList2[p1].path.x4 = 0
                    pageList2[p1].path.x3 = 0
                    pageList2[p1].path.y3 = 0
                    pageList2[p1].path.y4 = 0
                    pageList2[p2].path.x1 = 2*pageList2[p2].originpagewidth
                    pageList2[p2].path.x2 = 2*pageList2[p2].originpagewidth
                    pageList2[p2].path.y1 = 0
                    pageList2[p2].path.y2 = 0
                    autof = false

                    Runtime:removeEventListener("enterFrame",autoturnfn )
                  end

                else
                  ---過中線
                  ------print("pass1====")
                    --mask:toFront( )
                    pageList2[p2]:toFront( )
                 
                    if pageList2[p2].alpha == 0 then pageList2[p2].alpha = 1 end
                    if mask.alpha ==0 then mask.alpha =1 end

                        if pageList2[p2].path.x1 +autovx > 0 then
                          ------print("bbbbbbbbbbb")

                            pageList2[p2].path.x1 = pageList2[p2].path.x1 +autovx
                            ------print("x1===",pageList2[p2].path.x1)
                           -- pageList2[p1].path.x4 = pageList2[p1].path.x4 + autovx
                            
                            local dx =  pageList2[p2].originpagewidth-pageList2[p2].path.x1 -- -pageList2[p1].path.x4 - originpagewidth
                            
                            local ang = math.acos(dx/pageList2[p2].originpagewidth)*0.3
                           
              
                            pageList2[p2].path.y1 = -pageList2[p2].originpagewidth*math.sin(ang)
                             pageList2[p2].path.x2 = pageList2[p2].path.x1
                              pageList2[p2].path.y2 = -pageList2[p2].originpagewidth*math.sin(ang)
                            -- pageList2[p1].path.x4 = pageList2[p1].path.x4 + autovx
                            -- pageList2[p1].path.x3 = pageList2[p1].path.x4
                            -- pageList2[p1].path.y4 = pageList2[p2].path.y1
                            -- pageList2[p1].path.y3 = pageList2[p2].path.y2
                            pageList2[p1].path.x4 = -pageList2[p1].originpagewidth
                            pageList2[p1].path.x3 = -pageList2[p1].originpagewidth
                            pageList2[p1].path.y4 = 0
                            pageList2[p1].path.y3 = 0

                            
                              local mx4 = -pageList2[p2].originpagewidth-(dx)*0.9
                              mask.alpha = 1
                              mratex = mask.orgx/pageList2[p2].originpagewidth
                              mratey = mask.orgy/pageList2[p2].originpageheight

                               mask.path.x4 = mx4*mratex
                       
                              mask.path.x3 = mx4*mratex
                          mask.path.y3 = -mratey*pageList2[p2].originpagewidth*math.sin(ang)/4
                          ----print("960")
                          canautof = true
                        else
                        --  ----print("ccccccc")
                         -- ----print("pageList2[p1].path.x4===",pageList2[p1].path.x4)
                          
                          pageList2[p2].path.x1 = 0
                          pageList2[p2].path.x2 =  0
                          pageList2[p2].path.y1 = 0
                          pageList2[p2].path.y2 = 0
                        
                          pageList2[p2].path.y4 = 0
                          pageList2[p2].path.y3 = 0
                          pageList2[p1].path.x4 = -2*pageList2[p1].originpagewidth
                          pageList2[p1].path.x3 = -2*pageList2[p1].originpagewidth
                          pageList2[p1].path.y3 = 0
                          pageList2[p1].path.y4 = 0


                          if dir == "left"    then
                                smallPageGroup:remove(smallPageGroup.numChildren)
                                smallPageGroup[smallPageGroup.numChildren] = nil
                            if jumpPagef == false then
                                if pleft + 2 <= maxPage  then
                                  pleft = pleft + 2
                                 -- if maxPage % 2 == 1 then
                                    pright = pleft -1                                 
                                else
                                  pright = maxPage
                                  pleft = pleft + 2
                                end
                                local nextpage_path = system.pathForFile( choice_bookcode.."/"..(pleft-1)..".png", baseDir )
                                local mode = lfs.attributes(nextpage_path, "mode")
                                local nextpage_path2 = system.pathForFile( choice_bookcode.."/"..pleft..".png", baseDir )
                                local mode2 = lfs.attributes(nextpage_path2, "mode")
                                ----print("fh===",fh)
                                if mode == nil then
                                  loadpage2(pleft-1,true)
                                elseif mode2 == nil then
                                  if pleft <= maxPage then
                                    loadpage(pleft,true)
                                  else
                                    timer.performWithDelay( 10, arrangPageFn()  )
                                    
                                  end
                                else
                                   timer.performWithDelay( 10, arrangPageFn()  )                              
                                end
                                timer.performWithDelay( 20, makeOutLine )
                            else
                                jumpPagef = false
                                local nextpage_path = system.pathForFile( choice_bookcode.."/"..(pleft-1)..".png", baseDir )
                                local mode = lfs.attributes(nextpage_path, "mode")
                                local nextpage_path2 = system.pathForFile( choice_bookcode.."/"..pleft..".png", baseDir )
                                local mode2 = lfs.attributes(nextpage_path2, "mode")
                                ----print("fh===",fh)
                                if mode == nil then
                                  loadpage2(pleft-1,true)
                                elseif mode2 == nil then
                                  if pleft <= maxPage then
                                    loadpage(pleft,true)
                                  else
                                     timer.performWithDelay( 10, arrangPageFn()  )
                                  end
                                else
                                   timer.performWithDelay( 10, arrangPageFn()  )
                                end
                                timer.performWithDelay( 20, makeOutLine )
                            end
                          end 
                         
                          local dx = 0 
                          local tmpsmallpage = nil
                          if pleft > 1 then
                            dx = smallPageGroup[(pleft-1)*2].x
                            tmpsmallpage = smallPageGroup[(pleft-1)*2]
                          else
                            dx = smallPageGroup[pleft*2].x
                            tmpsmallpage = smallPageGroup[pleft*2]
                          end
                          if dx < scrOrgx + 20 then
                            backRight = true
                           Runtime:addEventListener( "enterFrame", smallPageAutoMoveFn)
                          end
                          if dx > _W*2 - scrOrgx - 20 - tmpsmallpage.contentWidth*0.5  then 
                              backLeft  = true
                              Runtime:addEventListener( "enterFrame", smallPageAutoMoveFn)                             
                          end    

                          Runtime:removeEventListener("enterFrame",autoturnfn )   
                        end
                end

              else
              ----雙頁左右翻
                local pos1 = wetools.getpos2(mask,pageList)
                    
                    local pos = wetools.getpos2( pageList2[p1],pageList)
                    if pos1 < pos-1 then
                      mask:toFront( )
                      pageList2[p1]:toFront()
                    end

                if pageList2[p1].path.x1 + autovx < pageList2[p1].originpagewidth then

                  if pageList2[p1].path.x1 + autovx > 0 then
                     pageList2[p1].path.x1 = pageList2[p1].path.x1 + autovx
                     if mask.alpha == 0 then mask.alpha = 1 end
                     local dx = pageList2[p1].originpagewidth-pageList2[p1].path.x1 
                     local ang = math.acos(dx/pageList2[p1].originpagewidth)*0.3
              
                     pageList2[p1].path.x2 = pageList2[p1].path.x1
            
                     pageList2[p1].path.y1 = -pageList2[p1].originpagewidth*math.sin(ang)                     
                     pageList2[p1].path.y2 = -pageList2[p1].originpagewidth*math.sin(ang)


                    -- pageList2[p2].path.x3 = pageList2[p2].path.x3 + autovx
                    -- pageList2[p2].path.x4 = pageList2[p2].path.x4 + autovx
                    -- pageList2[p2].path.y3 = pageList2[p1].path.y1
                    -- pageList2[p2].path.y4 = pageList2[p1].path.y1
                    pageList2[p2].path.x3 = -pageList2[p2].originpagewidth
                     pageList2[p2].path.x4 = -pageList2[p2].originpagewidth
                     pageList2[p2].path.y3 = 0
                     pageList2[p2].path.y4 = 0
           
                    local mx4 = -pageList2[p1].originpagewidth-(dx)*0.9
                    mratex = mask.orgx/pageList2[p1].originpagewidth
                    mratey = mask.orgy/pageList2[p1].originpageheight
                    mask.path.x4 = mx4*mratex
                    mask.path.x3 = mx4*mratex
                    mask.path.y3 = -mratey*pageList2[p1].originpagewidth*math.sin(ang)/4
                      
                    if math.abs(mask.path.x4 + pageList2[p1].originpagewidth) < 3 then
                       mask.alpha = 0
                       mask:toFront( )
                    
                       pageList2[p2].alpha = 0
                      
                    end
                    ----print("1083")
                     canautof = true
                  else
                   -- ----print("dfdsfsafdsaf")
                    canautof = false
                    ----print("3333333")
                    turnf = false
                    checkdir = true
                    pageList2[p2].path.x4 = -2*pageList2[p2].originpagewidth
                    pageList2[p2].path.x3 = -2*pageList2[p2].originpagewidth
                    pageList2[p2].path.y3 = 0
                    pageList2[p2].path.y4 = 0
                    pageList2[p1].path.x1 = 0
                    pageList2[p1].path.x2 = 0
                    pageList2[p1].path.y1 = 0
                    pageList2[p1].path.y2 = 0
                    autof = false
                    Runtime:removeEventListener("enterFrame",autoturnfn )
                  end
                 else
                  ---過中線
                  -- ----print("eeeee")
                   --mask:toFront( )
                   pageList2[p2]:toFront( )

                   if pageList2[p2].alpha == 0 then pageList2[p2].alpha =1 end
                   if mask.alpha ==0 then mask.alpha =1 end
                   ------print("pageList2[p2].path.x4 ===",pageList2[p2].path.x4)
                   if pageList2[p2].path.x4 +autovx < 0 then
                      pageList2[p2].path.x4 = pageList2[p2].path.x4 +autovx
                      
                      local dx =  pageList2[p2].path.x4 + pageList2[p2].originpagewidth
           
                      local ang = math.acos(dx/pageList2[p2].originpagewidth)*0.3
            
                      pageList2[p2].path.x3 = pageList2[p2].path.x4
                      pageList2[p2].path.y4 = -pageList2[p2].originpagewidth*math.sin(ang)
                      pageList2[p2].path.y3 = -pageList2[p2].originpagewidth*math.sin(ang)
                      pageList2[p1].path.x1 = pageList2[p1].path.x1 + autovx
                      pageList2[p1].path.x2 = pageList2[p1].path.x2 + autovx
                      pageList2[p1].path.y1 = pageList2[p2].path.y3
                      pageList2[p1].path.y2 = pageList2[p2].path.y4

                    --  mask.alpha = 1

                      local mx4 = pageList2[p2].path.x4*1.1
                      mratex = mask.orgx/pageList2[p2].originpagewidth
                        mratey = mask.orgy/pageList2[p2].originpageheight
                    --  ----print("mx4",mx4)
                      if mx4 <-pageList2[p2].originpagewidth then mx4 = -pageList2[p2].originpagewidth end
                     -- ----print("mx4",mx4)
                      mask.path.x4 = mx4*mratex
                      mask.path.x3 = mx4*mratex
                      mask.path.y3 = -mratey*pageList2[p2].originpagewidth*math.sin(ang)/4
                      cnaautof = true
                
                    else
                      --autof = false
                      -- ----print("pageList2[p1].path.x1===",pageList2[p1].path.x1)
                       pageList2[p2].path.x4 = 0
                       pageList2[p2].path.x3 =  0
                       pageList2[p2].path.y4 = 0
                       pageList2[p2].path.y3 = 0
                       pageList2[p1].path.x1 = 2*pageList2[p1].originpagewidth
                       pageList2[p1].path.x2 = 2*pageList2[p1].originpagewidth
                       pageList2[p1].path.y1 = 0
                       pageList2[p1].path.y2 = 0
                       ----print("4444444")
                       -- turnf = false
                       -- canautof = false
                       --  checkdir = true
                      if dir == "right"   then
                          if jumpPagef == false then
                              if pleft -2 >=1 then
                                pleft = pleft -2
                              
                                  pright = pleft -1
                              
                              else
                                pleft = 1
                              end
                              
                              --makeOutLine()

                              if pleft > 1 then
                                  local nextpage_path = system.pathForFile( choice_bookcode.."/"..(pleft-1)..".png", baseDir )
                                  local mode = lfs.attributes(nextpage_path, "mode")
                                  local nextpage_path2 = system.pathForFile( choice_bookcode.."/"..pleft..".png", baseDir )
                                  local mode2 = lfs.attributes(nextpage_path2, "mode")
                                  ----print("fh===",fh)
                                  if mode == nil then
                                    loadpage2(pleft-1,true)
                                  elseif mode2 == nil then
                                    loadpage(pleft,true)
                                  else
                                    timer.performWithDelay( 10, arrangPageFn )
                                    --arrangPageFn()
                                  end
                              else
                                  local nextpage_path = system.pathForFile( choice_bookcode.."/"..(pleft)..".png", baseDir )
                                  local mode = lfs.attributes(nextpage_path, "mode")
                                 
                                  ----print("fh===",fh)
                                  if mode == nil then
                                    loadpage(pleft,true)
                                  else
                                    timer.performWithDelay( 10, arrangPageFn )
                                    --arrangPageFn()
                                  end
                              end
                              smallPageGroup:remove(smallPageGroup.numChildren)
                              smallPageGroup[smallPageGroup.numChildren] = nil
                              timer.performWithDelay( 20, makeOutLine )

                          else
                                jumpPagef = false
                                if pleft > 1 then
                                  local nextpage_path = system.pathForFile( choice_bookcode.."/"..(pleft-1)..".png", baseDir )
                                  local mode = lfs.attributes(nextpage_path, "mode")
                                  local nextpage_path2 = system.pathForFile( choice_bookcode.."/"..pleft..".png", baseDir )
                                  local mode2 = lfs.attributes(nextpage_path2, "mode")
                                  ----print("fh===",fh)
                                  if mode == nil then
                                    loadpage2(pleft-1,true)
                                  elseif mode2 == nil then
                                    loadpage(pleft,true)
                                  else
                                    timer.performWithDelay( 10, arrangPageFn )
                                    --arrangPageFn()
                                  end
                                else
                                  local nextpage_path = system.pathForFile( choice_bookcode.."/"..(pleft)..".png", baseDir )
                                  local mode = lfs.attributes(nextpage_path, "mode")
                                  ----print("fh===",fh)
                                  if mode == nil then
                                    loadpage(pleft,true)
                                  else
                                    timer.performWithDelay( 10, arrangPageFn )
                                    --arrangPageFn()
                                  end
                                end
                                smallPageGroup:remove(smallPageGroup.numChildren)
                                smallPageGroup[smallPageGroup.numChildren] = nil
                                timer.performWithDelay( 20, makeOutLine )

                              --arrangPageFn()
                          end
                      end
                        local dx = 0 
                        local tmpsmallpage = nil
                        if pleft > 1 then
                          dx = smallPageGroup[(pleft-1)*2].x
                          tmpsmallpage = smallPageGroup[(pleft-1)*2]
                        else
                          dx = smallPageGroup[pleft*2].x
                          tmpsmallpage = smallPageGroup[pleft*2]
                        end
                        if dx < scrOrgx + 20 then
                          backRight = true
                         Runtime:addEventListener( "enterFrame", smallPageAutoMoveFn)
                        end
                        if dx > _W*2 - scrOrgx - 20 - tmpsmallpage.contentWidth*0.5  then 
                            backLeft  = true
                            Runtime:addEventListener( "enterFrame", smallPageAutoMoveFn)                             
                        end    
                        
                        Runtime:removeEventListener("enterFrame",autoturnfn )   
                     end
               end

      end
    else
       ----不翻頁
     -- ----print("dir===",dir)
      if dir == "left" then

          local target = nil
          local newpleft = 0

          if jumpPagef == false then
            newpleft = pleft + 2
          else
            newpleft = pleft
          end
          target = pageList[pageList.numChildren] 
         
         if target.no == maxPage then
            if maxPage % 2 ==  1 then
              firstPos = _W
            else
              firstPos = _W - target.contentWidth*0.5 
            end
         else
           firstPos = _W
         end   

          ------print("newpleft===",newpleft)
          -- if newpleft > maxPage then
          --   --newpleft = pleft  -1
          --   target = pageList2[newpleft-1]
          -- else
          --   target = pageList2[newpleft]
          -- end
         
         if target ~= nil and type(target) ~= "number" then
        --  ----print("target.name==",target.name)
          local dx = firstPos - target.x
          dx = dx*0.4
          ------print("dx====",dx)
          if math.abs(dx) < 1 then
            local ddx = firstPos - target.x
            for i = 1,pageList.numChildren do
              pageList[i].x = pageList[i].x + ddx
             
            end
              -- canautof = false
              -- ----print("5555555")
              -- turnf = false
              -- checkdir = true
              -- autof = false
              if jumpPagef == false then
                  if pleft + 2 <= maxPage  then
                   pleft = pleft + 2
                             
                   pright = pleft -1
                            
                  else

                    pright = maxPage
                    pleft = pleft + 2
                  end

              end
              jumpPagef = false

              local dx = 0 
              local tmpsmallpage = nil
              if pleft > 1 then
                dx = smallPageGroup[(pleft-1)*2].x
                tmpsmallpage = smallPageGroup[(pleft-1)*2]
              else
                dx = smallPageGroup[pleft*2].x
                tmpsmallpage = smallPageGroup[pleft*2]
              end
              if dx < scrOrgx + 20 then
                backRight = true
               Runtime:addEventListener( "enterFrame", smallPageAutoMoveFn)
              end
              -- --print("dx=====",dx)
              -- --print(_W*2 - scrOrgx - 20 - tmpsmallpage.contentWidth*0.5)
              if dx > _W*2 - scrOrgx - 20 - tmpsmallpage.contentWidth*0.5  then 
                  backLeft  = true

                  Runtime:addEventListener( "enterFrame", smallPageAutoMoveFn)                             
              end    
              smallPageGroup:remove(smallPageGroup.numChildren)
              smallPageGroup[smallPageGroup.numChildren] = nil
              

             
              local nextpage_path = system.pathForFile( choice_bookcode.."/"..(pleft-1)..".png", baseDir )
              local mode = lfs.attributes(nextpage_path, "mode")
              local nextpage_path2 = system.pathForFile( choice_bookcode.."/"..pleft..".png", baseDir )
              local mode2 = lfs.attributes(nextpage_path2, "mode")
              if mode == nil then
                loadpage2(pleft-1,true)
              elseif mode2 == nil then
                if pleft <= maxPage then
                  loadpage(pleft,true)
                else
                  if oldflipType == 1 then
               
                    if pleft < maxPage then
                      flipType = 1
                      --arrangPageFn()
                      timer.performWithDelay( 10, arrangPageFn )
                    else
                      ----print("aaaaaa")
                      flipType = 0
                      timer.performWithDelay( 10, arrangPageFn2 )
                    end
                  else
                    flipType = 0
                    timer.performWithDelay( 10, arrangPageFn2 )
                  end
                end
              else
                if oldflipType == 1 then
               
                  if pleft < maxPage then
                    flipType = 1
                    --arrangPageFn()
                    timer.performWithDelay( 10, arrangPageFn )
                  else
                    ----print("aaaaaa")
                    flipType = 0
                    timer.performWithDelay( 10, arrangPageFn2 )
                  end
                else
                  flipType = 0
                  timer.performWithDelay( 10, arrangPageFn2 )
                end

              end
              timer.performWithDelay( 20, makeOutLine )
              --makeOutLine()
              --arrangPageFn2()
              Runtime:removeEventListener("enterFrame",autoturnfn )
            
          else
            ----print("dx===",dx)
            --if pleft < maxPage then
              for i = 1,pageList.numChildren do
                pageList[i].x = pageList[i].x + dx
                
              end
            --end
         -- end
          end
          else
              
              turnf = true
              Runtime:removeEventListener("enterFrame",autoturnfn )
          end

      elseif dir == "right" then
        
          local target = nil
          local newpleft = 0
          if jumpPagef == false then
           
            ----print("pleft===",pleft)
            
            if pleft == 3 then
              target = pageList2[1]
              firstPos = _W - pageList2[1].contentWidth*0.5
            else
               target = pageList[2]
              firstPos = _W
            end
          else
            newpleft = pleft           
             if newpleft <= 1 then

              target = pageList2[1]
              firstPos = _W - pageList2[1].contentWidth*0.5
              
            else
              target = pageList2[newpleft]
              firstPos = _W
            end
          end 
          -- if jumpPagef == false then
          --   newpleft = pleft - 2
          -- else
          --   newpleft = pleft
          -- end
          -- ------print("newpleft===",newpleft)
          -- if newpleft < 1 then
          --   --newpleft = pleft  -1
          --   target = pageList2[1]
          -- else
          --   target = pageList2[newpleft]
          -- end
          -- firstPos = _W

          local dx = firstPos - target.x
          dx = dx*0.4
          if math.abs(dx) < 1 then
            local ddx = firstPos - target.x
            for i = 1,pageList.numChildren do
              pageList[i].x = pageList[i].x + ddx
              
            end
              -- canautof = false
              -- ----print("6666666")
              -- turnf = false
              -- checkdir = true
              -- autof = false
              if jumpPagef == false then
                if pleft -2 >=1 then
                  pleft = pleft -2
                  pright = pleft -1
                else
                  pleft = 1
                end
              end
              jumpPagef = false
              
              local dx = 0 
              local tmpsmallpage = nil
              if pleft > 1 then
                dx = smallPageGroup[(pleft-1)*2].x
                tmpsmallpage = smallPageGroup[(pleft-1)*2]
              else
                dx = smallPageGroup[pleft*2].x
                tmpsmallpage = smallPageGroup[pleft*2]
              end
              if dx < scrOrgx + 20 then
                backRight = true
               Runtime:addEventListener( "enterFrame", smallPageAutoMoveFn)
              end
              if dx > _W*2 - scrOrgx - 20 - tmpsmallpage.contentWidth*0.5  then 
                  backLeft  = true
                  Runtime:addEventListener( "enterFrame", smallPageAutoMoveFn)                             
              end    
              smallPageGroup:remove(smallPageGroup.numChildren)
              smallPageGroup[smallPageGroup.numChildren] = nil
              
              -- local nextpage_path = system.pathForFile( choice_bookcode.."/"..(pleft-1)..".png", baseDir )
              -- local fh, errStr = io.open( nextpage_path, "r" )
              -- --print("fh===",fh)
              -- if fh == nil then

              --   loadpage2(pleft-1)
              -- else
              if pleft > 1 then
                local nextpage_path = system.pathForFile( choice_bookcode.."/"..(pleft-1)..".png", baseDir )
                local mode = lfs.attributes(nextpage_path, "mode")
                local nextpage_path2 = system.pathForFile( choice_bookcode.."/"..pleft..".png", baseDir )
                local mode2 = lfs.attributes(nextpage_path2, "mode")
                ----print("fh===",fh)
                if mode == nil then
                  loadpage2(pleft-1,true)
                elseif mode2 == nil then
                  loadpage(pleft,true)
                else
                  if oldflipType == 1 then             
                      if pleft < maxPage then
                        flipType = 1
                        --arrangPageFn()
                        timer.performWithDelay( 10, arrangPageFn )
                      else
                        flipType = 0
                        timer.performWithDelay( 10, arrangPageFn2 )
                      end
                    
                  else
                    timer.performWithDelay( 10, arrangPageFn2 )
                  end
                end
              else
                local nextpage_path = system.pathForFile( choice_bookcode.."/"..(pleft)..".png", baseDir )
                local mode = lfs.attributes(nextpage_path, "mode")
                local nextpage_path2 = system.pathForFile( choice_bookcode.."/"..pleft..".png", baseDir )
                local mode2 = lfs.attributes(nextpage_path2, "mode")
                ----print("fh===",fh)
                if mode == nil then
                  loadpage(pleft,true)
                elseif mode2 == nil then
                  loadpage(pleft,true)
                else
                  flipType = 0
                  timer.performWithDelay( 10, arrangPageFn2 )
                  --arrangPageFn2()
                end
              end
              timer.performWithDelay( 20, makeOutLine )
                --arrangPageFn2()
              --end
              Runtime:removeEventListener("enterFrame",autoturnfn )
          else

            for i = 1,pageList.numChildren do
              pageList[i].x = pageList[i].x + dx
              
            end
          end
      end     
      ----不翻頁
      ------print("dlkjlj;ljl;jd;lajl;")
      end
    end
  else
      -----直
      if autof == true then
    if flipType == 1 then
      -----直向
      --local tarpage =pageList2[p1] 
      if dir == "left" then
        -- --print("autovx===",autovx)
        -- --print("tarpage.path.x4===",pageList2[p1].path.x4)
        -- --print("-pagewidth==",-pagewidth)
        local pos1 = wetools.getpos2(mask,pageList)
                    
        local pos = wetools.getpos2( pageList2[p1],pageList)
        if pos1 < pos-1 then
          mask:toFront( )
          pageList2[p1]:toFront()
        end
        if pageList2[p1].path.x4 + autovx > -pageList2[p1].pagewidth then
          pageList2[p1].path.x4 = pageList2[p1].path.x4 + autovx
          --if pageList(p1)
          local dx = pageList2[p1].pagewidth+pageList2[p1].path.x4 
          local ang = math.acos(dx/pageList2[p1].pagewidth)*0.1
          --  tarpage.path.x4 = x4             
            pageList2[p1].path.y4 = -pageList2[p1].originpagewidth*math.sin(ang)           
            pageList2[p1].path.x3 =  pageList2[p1].path.x4
            pageList2[p1].path.y3 = -pageList2[p1].originpagewidth*math.sin(ang)   
            
            local mx4 = pageList2[p1].path.x4*(pageList2[p1].contentWidth/pageList2[p1].originpagewidth) 
                mratex = pageList2[p1].contentWidth/mask.contentWidth
                mratey = pageList2[p1].contentHeight/mask.contentHeight
                --print("martex==",mratex)
                --print("martey==",mratey)
                if mx4*mratex < -mask.width then
                  mask.path.x3 = -mask.width
                  mask.path.x4 = -mask.width
                else
                  mask.path.x4 = mx4*mratex
                  mask.path.x3 = mx4*mratex
                end
           -- --print("pageList2[p1].contentWidth==",pageList2[p1].contentWidth)
            
            mask.path.y3 = -mratey*mask.contentHeight*math.sin(ang)/4
            ----print("aaaaaa")
        else

          pageList2[p1].path.x4 = -pageList2[p1].originpagewidth
          pageList2[p1].path.x3 = -pageList2[p1].originpagewidth
          pageList2[p1].path.y4 = 0
          pageList2[p1].path.y3 = 0
          local mratex = mask.orgx/pageList2[p1].originpagewidth
                        local mratey = mask.orgy/pageList2[p1].originpagewidth

          if -pageList2[p1].pagewidth*mratex < -mask.orgx then
            --print("11111")
            mask.path.x3 = -mask.orgx
            mask.path.x4 = -mask.orgx
          else
           --print("2222222222222")
            mask.path.x4 = -pageList2[p1].contentWidth*mratex
            mask.path.x3 = -pageList2[p1].contentWidth*mratex
          end
          
          mask.path.y3 = 0
          if jumpPagef == false then
            if p1 < maxPage then
              p1 = p1 + 1
            end
          else
            -- --print("pageList[1].no===",pageList[1].no)
            -- for i = 1,pageList.numChildren do
            --   --print("pagelist.name==",pageList[i].name)
            -- end
            if pageList.numChildren == 3 then
              p1 = pageList[1].no
            else
              p1 = pageList[2].no
            end
            
            jumpPagef = false
          end
          local dx = 0
          dx = smallPageGroup[p1*2-1].x
          if dx < scrOrgx + 20 then
               backRight = true
               Runtime:addEventListener( "enterFrame", smallPageAutoMoveFn)
          end


          if dx > _W*2 - scrOrgx - 20 - smallPageGroup[p1*2-1].contentWidth*0.5 then
              backLeft  = true
              Runtime:addEventListener( "enterFrame", smallPageAutoMoveFn)
          end
          smallPageGroup:remove(smallPageGroup.numChildren)
          smallPageGroup[smallPageGroup.numChildren] = nil
            
           local nextpage_path = system.pathForFile( choice_bookcode.."/"..p1..".png", baseDir )
              local mode = lfs.attributes(nextpage_path, "mode")

              if mode == nil then

                loadpage(p1,true)
              else
                timer.performWithDelay( 10, arrangPageFn )
                --arrangPageFn()
              end
              timer.performWithDelay( 20, makeOutLine )        
            --makeOutLine()                  
          -- canautof = false                
          -- turnf = false
          -- checkdir = true
          mask:toBack( )

          --autof = false
          Runtime:removeEventListener("enterFrame",autoturnfn )
        end
      elseif dir == "right" then
        -- --print("autovx===",autovx)
         ----print("p1==",p1)
         local pos1 = wetools.getpos2(mask,pageList)
                    
                    local pos = wetools.getpos2( pageList2[p1],pageList)
                    if pos1 < pos-1 then
                      mask:toFront( )
                      pageList2[p1]:toFront()
                    end

        -- --print("tarpage.path.x4===",pageList2[p1].path.x4)
        
        if pageList2[p1].path.x4 + autovx < 0 then
          pageList2[p1].path.x4 = pageList2[p1].path.x4 + autovx
          --if pageList(p1)
          local dx = pageList2[p1].pagewidth+pageList2[p1].path.x4 
          local ang = math.acos(dx/pageList2[p1].pagewidth)*0.1

              ------print("event.x===",event.
              pageList2[p1].path.y4 = -pageList2[p1].pagewidth*math.sin(ang)
              pageList2[p1].path.x3 =  pageList2[p1].path.x4
              pageList2[p1].path.y3 = -pageList2[p1].pagewidth*math.sin(ang)
             
                local mx4 = pageList2[p1].path.x4
                ---pageList2[p1].originpagewidth+(pageList2[p1].path.x4+pageList2[p1].originpagewidth)*0.9
                local mratex = mask.orgx/pageList2[p1].width
                local  mratey = mask.orgy/pageList2[p1].height
                if mask.contentWidth > pageList2[p1].contentWidth then
                  mratex = mratex*1.1
                end 
                if mx4*mratex < -mask.orgx then
                  mask.path.x3 = -mask.orgx
                  mask.path.x4 = -mask.orgx
                else            
                  mask.path.x4 = mx4*mratex
                  mask.path.x3 = mx4*mratex
                  ----print("mask.x3==",mask.path.x3)
                end

                mask.path.y3 = -mratey*pageList2[p1].pagewidth*math.sin(ang)/4
                --print("bbbbb")
        else
          pageList2[p1].path.x4 = 0
          pageList2[p1].path.x3 = 0
          pageList2[p1].path.y4 = 0
          pageList2[p1].path.y3 = 0
          mask.path.x4 = 0
          mask.path.x3 = 0
          mask.path.y3 = 0
          mask.path.y4 = 0        
          local dx = 0
          dx = smallPageGroup[p1*2-1].x
          if dx < scrOrgx + 20 then
               backRight = true
               Runtime:addEventListener( "enterFrame", smallPageAutoMoveFn)
          end
          if dx > _W*2 - scrOrgx - 20 - smallPageGroup[p1*2-1].contentWidth*0.5 then
              backLeft  = true
              Runtime:addEventListener( "enterFrame", smallPageAutoMoveFn)
          end
           smallPageGroup:remove(smallPageGroup.numChildren)
                smallPageGroup[smallPageGroup.numChildren] = nil
                
          -- turnf = false
                    
          -- checkdir = true
          -- mask:toBack( )
          -- autof = false
         -- --print("stop......")

         local nextpage_path = system.pathForFile( choice_bookcode.."/"..p1..".png", baseDir )
          local mode = lfs.attributes(nextpage_path, "mode")

          if mode == nil then

            loadpage(p1,true)
          else
            timer.performWithDelay( 10, arrangPageFn )
            --arrangPageFn()
          end
          --makeOutLine()
          timer.performWithDelay( 20, makeOutLine )
          -- arrangPageFn()
          Runtime:removeEventListener("enterFrame",autoturnfn )
        end
      end
    else
      ----不翻頁
      if dir == "left" then

          local target = nil
          local newpleft = 0        
          ------print("newpleft===",newpleft)
          --print("p1===",p1)
          if jumpPagef == false then
            target = pageList2[p1+1]
          else
            target = pageList2[p1]
          end
          if type(target) == "number" then

            target = display.newRect( -100000, 0, _W, _H*2 )
          end
           -- local textnum2 = display.newText(tostring(target),100,400,native.systemFont,50)
           --    textnum2:setFillColor( 1,0,0 )
           --     sceneGroup:insert(textnum2)
         -- ----print("target...",target)
        if target ~= nil then
        --  ----print("target.name==",target.name)
          local dw = _W*2-2*scrOrgx - target.contentWidth
          
          local dx = scrOrgx - target.x + dw/2
          dx = dx*0.4
          ------print("dx====",dx)
          if math.abs(dx) < 1 then
            local ddx = scrOrgx - target.x + dw/2
            for i = 1,pageList.numChildren do
              pageList[i].x = pageList[i].x + ddx              
            end
              -- canautof = false
              -- ----print("5555555")
              -- turnf = false
              -- checkdir = true
              -- autof = false
              if jumpPagef == false then
                  if p1 + 1 <= maxPage  then
                   p1 = p1 + 1
                  end

              end
              jumpPagef = false

              local ddx = 0 
                  ddx = smallPageGroup[p1*2-1].x
                  if ddx < scrOrgx + 20 then
                    backRight = true
                    Runtime:addEventListener( "enterFrame", smallPageAutoMoveFn)
                  end
                  ----print("dxleft ===",ddx)
                 
                  if ddx > _W*2 - scrOrgx - 20 - smallPageGroup[p1*2-1].contentWidth*0.5 then 
                      backLeft  = true
                      Runtime:addEventListener( "enterFrame", smallPageAutoMoveFn)                      
                  end                    
                  smallPageGroup:remove(smallPageGroup.numChildren)
                  smallPageGroup[smallPageGroup.numChildren] = nil
                  

              ----print("p1====",p1)
              --arrangPageFn2()
              local nextpage_path = system.pathForFile( choice_bookcode.."/"..p1..".png", baseDir )
              local mode = lfs.attributes(nextpage_path, "mode")

              if mode == nil then
                
                loadpage(p1,true)
              else

                if oldflipType == 1 then
                  if p1 < maxPage then
                    flipType = 1
                    --arrangPageFn()
                    timer.performWithDelay( 10, arrangPageFn )
                  else
                    flipType = 0
                    timer.performWithDelay( 10, arrangPageFn2 )
                  end
                else
                  flipType = 0
                  timer.performWithDelay( 10, arrangPageFn2 )
                end

                --timer.performWithDelay( 10, arrangPageFn2 )
               -- arrangPageFn2()
              end
              -- makeOutLine()
              timer.performWithDelay( 20, makeOutLine )
              Runtime:removeEventListener("enterFrame",autoturnfn)
            
          else
            ----print("dx===",dx)
            --if pleft < maxPage then
            -- local textnum2 = display.newText("remove333",100,500,native.systemFont,50)
            --   textnum2:setFillColor( 1,0,0 )
            --    sceneGroup:insert(textnum2)
              for i = 1,pageList.numChildren do
                pageList[i].x = pageList[i].x + dx
               
              end
            --end
         -- end
          end
        else
              
              turnf = true
              Runtime:removeEventListener("enterFrame",autoturnfn )
        end

      elseif dir == "right" then
        
         -- local target 
          

          local dw = _W*2-2*scrOrgx - pageList2[p1].originpagewidth*pageList2[p1].rate
          firstPos = scrOrgx + dw/2
          
          pageList2[p1].firstPos = firstPos

          local dx = firstPos - pageList2[p1].x
          dx = dx*0.4
          if math.abs(dx) < 1 then
            local ddx = firstPos - pageList2[p1].x
            for i = 1,pageList.numChildren do
              pageList[i].x = pageList[i].x + ddx
              
            end
              -- canautof = false
              -- ----print("6666666")
              -- turnf = false
              -- checkdir = true
              -- autof = false

              jumpPagef = false
              
              -- local nextpage_path = system.pathForFile( choice_bookcode.."/"..p1..".png", baseDir )
              -- local fh, errStr = io.open( nextpage_path, "r" )

              -- if fh == nil then

              --   loadpage(p1,true)
              -- else

                local ddx 
                ddx = smallPageGroup[p1*2-1].x
                if ddx < scrOrgx + 20 then
                  backRight = true
                  Runtime:addEventListener( "enterFrame", smallPageAutoMoveFn)
                end
                if ddx > _W*2 - scrOrgx - 20 - smallPageGroup[p1*2-1].contentWidth*0.5 then
                      backLeft  = true
                      Runtime:addEventListener( "enterFrame", smallPageAutoMoveFn)
                end   
                smallPageGroup:remove(smallPageGroup.numChildren)
                smallPageGroup[smallPageGroup.numChildren] = nil
                

                local nextpage_path = system.pathForFile( choice_bookcode.."/"..p1..".png", baseDir )
                local mode = lfs.attributes(nextpage_path, "mode")

                if mode == nil then
                  
                  loadpage(p1,true)
                else
                  if oldflipType == 1 then
                    if flipType == 0 then
                      if p1 >1 then
                        flipType = 1
                        --arrangPageFn()
                        timer.performWithDelay( 10, arrangPageFn )
                      else
                        flipType = 0
                        timer.performWithDelay( 10, arrangPageFn2 )
                      end
                    else
                      --arrangPageFn()
                     timer.performWithDelay( 10, arrangPageFn )
                    end
                  else
                    flipType = 0
                    timer.performWithDelay( 10, arrangPageFn2 )
                  end

                  --timer.performWithDelay( 10, arrangPageFn2 )
                  --arrangPageFn2()
                end
                -- makeOutLine()
                timer.performWithDelay( 20, makeOutLine )
              --end
              Runtime:removeEventListener("enterFrame",autoturnfn )
          else
            ----print("dx===",dx)
            for i = 1,pageList.numChildren do
              pageList[i].x = pageList[i].x + dx
              
            end
          end

      end

    end
  end

  end
end





-- local textnum = display.newText("",0,0,native.systemFont,40)
-- textnum:setFillColor( 1,0,0 )
local function bigAutoFlipFn(event)
  if currentOrientation == "landscapeLeft" or currentOrientation == "landscapeRight" then
    if bigautof == false then
     Runtime:removeEventListener("enterFrame",bigAutoFlipFn )
   else
     if dir == "left" then
      --if pleft == 1 then
        local dx

        if pleft ==1 then
           dx = scrOrgx - pageList2[2].x 
        elseif pleft >= maxPage then
           if pleft > maxPage then
            dx = scrOrgx - pageList2[maxPage].x
           else
            dx = scrOrgx - pageList2[pleft-1].x
           end
        else
           ----print("pleft====",pleft)
            if jumpPagef == false then
              dx = scrOrgx - pageList2[pleft+1].x
            else
              dx = scrOrgx - pageList2[pleft-1].x
            end
        end
        ------print("aaaaaaaa")
        dx = dx *0.3
        for i = 1,pageList.numChildren do

          pageList[i].x = pageList[i].x + dx
          ------print("oldpleft===",oldpleft)
       
         
        end
        if math.abs(dx)<=1 then
          bigautof = false
          --print("pleft1===",pleft)
          --print("jumppagef===",jumpPagef)
          if jumpPagef == false then
                if pleft + 2 <= maxPage  then
                   pleft = pleft + 2                          
                   pright = pleft -1                           
                else
                  pright = maxPage
                  pleft = pleft + 2
                end
          end
           --print("pleft2===",pleft)

          jumpPagef = false

           -- local nowpage = 0
           -- if pleft >  maxPage then
           --  nowpage = maxPage
           -- else
           --  nowpage = pleft
           -- end
           local nextpage_path = system.pathForFile( choice_bookcode.."/"..(pleft-1)..".png", baseDir )
            local mode = lfs.attributes(nextpage_path, "mode")
            if mode == nil then
              loadpage2(pleft-1,true)
            else
              arrangBigPageFn()
            end

          Runtime:removeEventListener("enterFrame",bigAutoFlipFn )
        end
 
    elseif dir == "right" then
        local dx
       -- ----print("pleft==",pleft)
        if pleft ==1 then
            ----print("jumpppppppppp")
           dx =  _W*2 -scrOrgx -pageList2[pleft].contentWidth - pageList2[1].x
        elseif pleft > maxPage then
           dx = scrOrgx - pageList2[maxPage-2].x
        else
           ----print("pleft===",pleft)
            if jumpPagef == false then
               if pleft > 3 then
                  dx = scrOrgx - pageList2[pleft-3].x
               else
                  dx = _W*2 -scrOrgx -pageList2[pleft-2].contentWidth - pageList2[pleft-2].x
               end
            else
              ------print("jumpppppppppp")
              dx = scrOrgx - pageList2[pleft-1].x
            end
        end
        ------print("aaaaaaaa")
        dx = dx *0.3
        for i = 1,pageList.numChildren do
          pageList[i].x = pageList[i].x + dx
         
        --  ----print("pagelist[i].x==",pageList[i].x)
        end
      if math.abs(dx)<= 1 then
          bigautof = false
          if jumpPagef == false then
            if pleft -2 >=1 then
              pleft = pleft -2
              pright = pleft -1
            else
              pleft = 1
            end
          end

          jumpPagef = false
          
          
           local nextpage_path = system.pathForFile( choice_bookcode.."/"..pleft..".png", baseDir )
            local mode = lfs.attributes(nextpage_path, "mode")
            if mode == nil then
              loadpage(pleft,true)
            else
              arrangBigPageFn()
            end
          
          Runtime:removeEventListener("enterFrame",bigAutoFlipFn )
      end

      end

                         

      end
  else

     ---直,自動翻頁

    if bigautof == false then
      Runtime:removeEventListener("enterFrame",bigAutoFlipFn )
    else
      if dir == "left" then
      --if pleft == 1 then
        local dx
        --print("p1====",p1)
        if jumpPagef == false then
            --target = pageList2[p1+1]
             --print("pageList2[p1+1].no===",pageList2[p1+1].no)
             --print("pageList2[p1+1].x===",pageList2[p1+1].x)
             dx = scrOrgx - pageList2[p1+1].x
          else
             dx = scrOrgx - pageList2[p1].x
          end
      
        dx = dx *0.3
       
        for i = 1,pageList.numChildren do
         
          pageList[i].x = pageList[i].x + dx

        end
        if math.abs(dx)<=1 then
          bigautof = false
         
          if jumpPagef == false then
                  if p1 + 1 <= maxPage  then
                   p1 = p1 + 1
                  end

          end
          jumpPagef = false

          local nextpage_path = system.pathForFile( choice_bookcode.."/"..p1..".png", baseDir )
            local mode = lfs.attributes(nextpage_path, "mode")
            if mode == nil then
              loadpage(p1,true)
            else
              arrangBigPageFn()
            end
          
          Runtime:removeEventListener("enterFrame",bigAutoFlipFn )
        end
 
      elseif dir == "right" then
        local dx
        if jumpPagef == false then
          dx = scrOrgx - pageList2[p1-1].x
        else
          dx = scrOrgx - pageList2[p1].x
        end
         dx = dx *0.3
     
        for i = 1,pageList.numChildren do
         
          pageList[i].x = pageList[i].x + dx
    
        end
        if math.abs(dx)<=1 then
          bigautof = false
          if jumpPagef == false then
            p1 = p1 -1
          end
          jumpPagef = false

          local nextpage_path = system.pathForFile( choice_bookcode.."/"..p1..".png", baseDir )
            local mode = lfs.attributes(nextpage_path, "mode")
            if mode == nil then
              loadpage(p1,true)
            else
              arrangBigPageFn()
            end
         
          Runtime:removeEventListener("enterFrame",bigAutoFlipFn )
        end      
          --------------------
          -------------------
      end
      end 
  end
end

local function bigPageBackFn(event)
  if currentOrientation == "landscapeLeft" or currentOrientation == "landscapeRight" then
  ------print("back")
    if scalef == false then
      Runtime:removeEventListener("enterFrame",bigPageBackFn )
    else
      if pleft ==1 then
     
        if bigBackRight == true then
      
          local dx = (_W*2-scrOrgx - pageList2[pleft].contentWidth) - pageList2[1].x
          dx = dx * 0.2
          pageList2[1].x = pageList2[1].x + dx
         
          if dx <= 1 then
           bigBackRight = false
           pageList2[1].x = _W*2-scrOrgx - pageList2[pleft].contentWidth
          end
        elseif bigBackLeft == true then
          local tarx = 0
       
          tarx = _W
          local dx = tarx - pageList2[1].x
          dx = dx * 0.2
          pageList2[1].x = pageList2[1].x + dx
          
          if dx >= -1 then
            bigBackLeft = false
            pageList2[1].x = tarx
            
          end
       end

        if bigBackDown == true then
        local dy = scrOrgy +_H*2-pageList2[pleft].contentHeight*0.5 - pageList2[1].y
        dy = dy * 0.2
        pageList2[1].y = pageList2[1].y + dy
       
        if dy <=1 then
          bigBackDown = false
          pageList2[1].y = scrOrgy +_H*2-pageList2[pleft].contentHeight*0.5--pageList2[1].height*0.5
          
        end

        elseif bigBackUp == true then
        local dy = scrOrgy + pageList2[pleft].contentHeight*0.5 - pageList2[1].y
        dy = dy * 0.2
        pageList2[1].y = pageList2[1].y + dy
       
        if dy >=-1 then
          bigBackUp = false
          pageList2[1].y = scrOrgy +pageList2[pleft].contentHeight*0.5-- pageList2[1].height*0.5
          
        end
        end
      elseif pleft >= maxPage then
      ------print("bigBackRight===",bigBackRight)
        local tmp = pageList2[maxPage]

        if bigBackRight == true then
          local dx = 0
          if pleft > maxPage then
            dx = scrOrgx - (_W*2-2*scrOrgx)*0.5 - tmp.x
             dx = dx * 0.2
             tmp.x = tmp.x + dx
              
            if dx <= 1 then
               bigBackRight = false
               tmp.x = scrOrgx - (_W*2-2*scrOrgx)*0.5
           end
          else

            local tmp2 = pageList2[maxPage-1]
            dx = _W*2 - scrOrgx - pageList2[maxPage-1].contentWidth - tmp.x
            dx = dx * 0.2
            tmp.x = tmp.x + dx
            tmp2.x = tmp2.x + dx
           
            if dx <= 1 then
              bigBackRight = false
             tmp.x = (_W*2-scrOrgx - pageList2[maxPage].contentWidth)
             tmp2.x = tmp.x - pageList2[maxPage-1].contentWidth
            end
        end
       
        elseif bigBackLeft == true then
        if pleft > maxPage then
          local dx = scrOrgx - tmp.x
          dx = dx * 0.2
          tmp.x = tmp.x + dx
         local tarx = 0
       
          tarx = scrOrgx
          if dx >= -1 then
           bigBackLeft = false
            tmp.x = tarx
          end
        else
          local tmp2 = pageList2[maxPage-1]
          local tarx = 0
       
           tarx = scrOrgx + pageList2[maxPage].contentWidth
           local dx = tarx - tmp.x
           dx = dx *0.2
           tmp.x = tmp.x + dx
           tmp2.x = tmp2.x + dx
           
          ------print("dx======",dx)
           if dx >= -1 then
          --  ----print("bbbbbbb")
            bigBackLeft = false
            tmp.x = tarx
            tmp2.x = tmp.x - pageList2[maxPage-1].contentWidth
          end
        end
        end

        if bigBackDown == true then
        if pleft > maxPage then
          local dy = scrOrgy +_H*2-pageList2[maxPage].contentHeight*0.5 - tmp.y
          dy = dy * 0.2
         tmp.y = tmp.y + dy
         if dy <=1 then
            bigBackDown = false
           tmp.y = scrOrgy +_H*2-contentHeight*0.5--pageList2[1].height*0.5
         end
        else
          local tmp2 = pageList2[maxPage-1]
          local dy = scrOrgy +_H*2-pageList2[maxPage].contentHeight*0.5 - tmp.y
            dy = dy * 0.2
            tmp.y = tmp.y + dy
            tmp2.y = tmp2.y + dy
            
            if dy <=1 then
              bigBackDown = false
              tmp.y = scrOrgy +_H*2-pageList2[maxPage].contentHeight*0.5--pageList2[1].height*0.5
              tmp2.y = tmp.y
            end
        end

        elseif bigBackUp == true then
          if pleft >  maxPage then
            local dy = scrOrgy + pageList2[maxPage].contentHeight*0.5 - tmp.y
           dy = dy * 0.2
            tmp.y = tmp.y + dy
            if dy >=-1 then
             bigBackUp = false
              tmp.y = scrOrgy +pageList2[maxPage].contentHeight*0.5-- pageList2[1].height*0.5
              
            end
          else
            local tmp2 = pageList2[maxPage-1]
            local dy = scrOrgy + pageList2[maxPage].contentHeight*0.5 - tmp.y
            dy = dy * 0.2
            tmp.y = tmp.y + dy
             tmp2.y = tmp2.y + dy
             

            if dy >=-1 then
              bigBackUp = false
              tmp.y = scrOrgy +pageList2[maxPage].contentHeight*0.5-- pageList2[1].height*0.5
              tmp2.y = tmp.y
            end
          end
        end
      else
      --雙頁
        local tmp = pageList2[pleft]
        local tmp2 = pageList2[pleft-1]

        if bigBackRight == true then
      
          local dx = (_W*2-scrOrgx - pageList2[pleft].contentWidth) - tmp.x
          dx = dx * 0.2
          tmp.x = tmp.x + dx
          tmp2.x = tmp2.x + dx
          

          if dx <= 1 then
            bigBackRight = false
           tmp.x = (_W*2-scrOrgx - pageList2[pleft].contentWidth)
           tmp2.x = tmp.x - pageList2[pleft-1].contentWidth

          end
        elseif bigBackLeft == true then
         local tarx = 0
       
         tarx = scrOrgx + pageList2[pleft-1].contentWidth
         local dx = tarx - tmp.x
         dx = dx *0.2
          tmp.x = tmp.x + dx
          tmp2.x = tmp2.x + dx

          ------print("dx======",dx)
          if dx >= -1 then
          --  ----print("bbbbbbb")
            bigBackLeft = false
           tmp.x = tarx
           tmp2.x = tmp.x - pageList2[pleft-1].contentWidth
 
          end
        end

        if bigBackDown == true then
            local dy = scrOrgy +_H*2-pageList2[pleft].contentHeight*0.5 - tmp.y
            dy = dy * 0.2
            tmp.y = tmp.y + dy
            tmp2.y = tmp2.y + dy
            
            if dy <=1 then
              bigBackDown = false
              tmp.y = scrOrgy +_H*2-pageList2[pleft].contentHeight*0.5--pageList2[1].height*0.5
              tmp2.y = tmp.y

            end

        elseif bigBackUp == true then
            local dy = scrOrgy + pageList2[pleft].contentHeight*0.5 - tmp.y
            dy = dy * 0.2
            tmp.y = tmp.y + dy
             tmp2.y = tmp2.y + dy
          
            if dy >=-1 then
              bigBackUp = false
              tmp.y = scrOrgy +pageList2[pleft].contentHeight*0.5-- pageList2[1].height*0.5
              tmp2.y = tmp.y
          
            end
        end

      end
      if bigBackLeft == false and bigBackRight == false and bigBackUp == false and bigBackDown == false then
        Runtime:removeEventListener("enterFrame",bigPageBackFn )
      end

    end
  else
      -----直，back
    if scalef == false then
      Runtime:removeEventListener("enterFrame",bigPageBackFn )
    else
      
     
        if bigBackRight == true then
      
          local dx = (_W*2-scrOrgx - pageList2[p1].contentWidth) - pageList2[p1].x
          dx = dx * 0.2
          pageList2[p1].x = pageList2[p1].x + dx
         
          if dx <= 1 then
            bigBackRight = false
            pageList2[p1].x = _W*2-scrOrgx - pageList2[p1].contentWidth
 
          end
        elseif bigBackLeft == true then
          local tarx = 0
       
          tarx = scrOrgx
          local dx = tarx - pageList2[p1].x
          dx = dx * 0.2
     
          pageList2[p1].x = pageList2[p1].x + dx
         
          if dx >= -1 then
            bigBackLeft = false
            pageList2[p1].x = tarx
   
          end
        end

        if bigBackDown == true then
          local dy = scrOrgy +_H*2-pageList2[p1].contentHeight*0.5 - 2*scrOrgy - pageList2[p1].y
          dy = dy * 0.2
          
          pageList2[p1].y = pageList2[p1].y + dy
        
          if dy <=1 then
            bigBackDown = false
            pageList2[p1].y = scrOrgy +_H*2-pageList2[p1].contentHeight*0.5 - 2*scrOrgy--pageList2[1].height*0.5
          
          end

        elseif bigBackUp == true then
          local dy = scrOrgy + pageList2[p1].contentHeight*0.5 - pageList2[p1].y
          dy = dy * 0.2
         
          pageList2[p1].y = pageList2[p1].y + dy
        
          if dy >=-1 then
            bigBackUp = false
            pageList2[p1].y = scrOrgy +pageList2[p1].contentHeight*0.5-- pageList2[1].height*0.5
          
          end
        end


      if bigBackLeft == false and bigBackRight == false and bigBackUp == false and bigBackDown == false then
        Runtime:removeEventListener("enterFrame",bigPageBackFn )
      end

    end
  end
end


local function bigPageFloatFn(event)
      if scalef == false then
       Runtime:removeEventListener("enterFrame",bigPageFloatFn )
      else
        ----print("bigVx.....",bigVx)
      
        if math.abs(bigVx) <=1 and math.abs(bigVy) <= 1 then
         
            bigVx = 0
            bigVy = 0
            Runtime:removeEventListener("enterFrame",bigPageFloatFn )
        else
          local leftMax = _W -scrOrgx - (_W*2-2*scrOrgx)*0.33 ---往左最大坐標
            local rightMax = scrOrgx + (_W*2-2*scrOrgx)*0.33 
          if currentOrientation == "landscapeLeft" or currentOrientation == "landscapeRight" then
           
            if pleft == 1 then
              --local tmp = pageList2[1]

              pageList2[1].x = pageList2[1].x + bigVx
              pageList2[1].y = pageList2[1].y + bigVy
             
              local left  = pageList2[1].x + pageList2[1].contentWidth
              local top = pageList2[1].y - pageList2[1].contentHeight*0.5
              -- if left < leftMax then
              --   ----放大換頁
              --   bigautof = true
              --   dir = "left"

              -- else
                
                if left < _W*2-scrOrgx then
                  bigBackRight = true
                  ----print("right=====")
                end
               
                if left > _W*2-scrOrgx + pageList2[1].contentWidth*0.67 then
             
                  bigBackLeft = true
                  ----print("left=====")
                end

                if top > scrOrgy then
                  bigBackUp = true
                  ----print("up=====")
                end

                if top < scrOrgy - (pageList2[1].contentHeight - 2*_H) then
                  bigBackDown  = true
                  ----print("down=====")
                end
                
              --end


            elseif pleft > maxPage then
              --local tmp = pageList2[maxPage]
             -- --print("pleft",pleft)

              pageList2[maxPage].x = pageList2[maxPage].x + bigVx
              pageList2[maxPage].y = pageList2[maxPage].y + bigVy

              local right  = pageList2[maxPage].x 
              local top = pageList2[maxPage].y - pageList2[maxPage].contentHeight*0.5--pageList2[1].height*0.5

                  if right > scrOrgx then
                    bigBackLeft = true
                  end
                  if right < scrOrgx - (_W*2-2*scrOrgx)*0.67 then
                    bigBackRight = true
                  end

                  if top > scrOrgy then
                   -- ----print("top===",top)
                    bigBackUp = true
                   -- ----print("up11111111=========")
                  end

                  if top < scrOrgy - (pageList2[maxPage].contentHeight - 2*_H) then
                    bigBackDown  = true
                   ----up----print("down11111111=========")
                  end
              else
                -- local tmp = pageList2[pleft]
                -- local tmp2 = pageList2[pleft-1]
                 --print("pleft",pleft)
                pageList2[pleft].x = pageList2[pleft].x + bigVx
                pageList2[pleft].y = pageList2[pleft].y + bigVy
                pageList2[pleft-1].x = pageList2[pleft-1].x + bigVx
                pageList2[pleft-1].y = pageList2[pleft-1].y + bigVy
               -- ----print("abcdefghijk")

                local left  = pageList2[pleft].x + pageList2[pleft].contentWidth--pageList2[1].width
                local top = pageList2[pleft].y - pageList2[pleft].contentHeight*0.5--pageList2[1].height*0.5
                local right  = pageList2[pleft].x - pageList2[pleft-1].contentWidth

                  if left < _W*2-scrOrgx then
                    bigBackRight = true
                    ----print("right11111111=========")
                  end

                  if right > scrOrgx then
                    bigBackLeft = true
                    ----print("left11111111=========")
                  end


                  if top > scrOrgy then
                   -- ----print("top===",top)
                    bigBackUp = true
                   ----print("up11111111=========")
                  end

                  if top < scrOrgy - (pageList2[pleft].contentHeight - 2*_H) then
                    bigBackDown  = true
                   ----print("down11111111=========")
                  end

                end
              else
                -----放大直向浮動
                 ----print("bigVx==",bigVx)
                 pageList2[p1].x = pageList2[p1].x + bigVx
                 pageList2[p1].y = pageList2[p1].y + bigVy
                
    
                 local left  = pageList2[p1].x + pageList2[p1].contentWidth
                 local top = pageList2[p1].y - pageList2[p1].contentHeight*0.5

                --if p1 == 1 then
                 
                    if left < _W*2-scrOrgx then
                      bigBackRight = true
                      ----print("right=====")
                    end             
                    if left > pageList2[p1].contentWidth +scrOrgx then            
                      bigBackLeft = true
                      ----print("left=====")
                    end
                    if top > scrOrgy then
                      bigBackUp = true
                      ----print("up=====")
                    end
                    if top < scrOrgy - (pageList2[p1].contentHeight - 2*_H + 2*scrOrgy) then
                      bigBackDown  = true
                      ----print("down=====")
                    end               
                  
                -- elseif p1 == maxPage then

                -- else
                -- end
              end

              if bigBackLeft == true or bigBackRight == true or bigBackDown == true or bigBackUp == true then
           
                 Runtime:addEventListener("enterFrame",bigPageBackFn)  
              end
             bigVx = bigVx*0.9
             bigVy = bigVy*0.9
          end
        
    end
end

local function mutiZoom()
  --print("mutizoom==========")

  if currentOrientation == "landscapeLeft" or currentOrientation == "landscapeRight" then
    -- if nowrate == 1 then
    --   scalef = false
    --   scaleing = false
    --   arrangPageFn2()
    -- else
     

      if pleft == 1 then
         local tmprate = pageList2[1].rate*nowrate
        --local bounds = pageList2[1].contentBounds 
        -- if centerx >= bounds.xMin and centerx <= bounds.xMax and centery >= bounds.yMin and centery <= bounds.yMax then
        --   --local textnum = display.newText(tostring(centerx),200,100,native.systemFont,40)
          
        --   local orgdx = centerx - _W
        --   local orgdy = centery - _H
        --   local dx = orgdx*(tmprate - pageList2[1].rate)
        --   local dy = orgdy*(tmprate - pageList2[1].rate)
        --   local tarx = _W - dx -- orgdx*0.55
        --   local tary = _H - dy -- orgdy*0.55
   
        --     pageList2[1].x = tarx
        --     pageList2[1].y = tary
          
        -- --else

        -- end

        pageList2[1].xScale = tmprate
        pageList2[1].yScale = tmprate
      


        for i = 2,pageList.numChildren do
          
                local tmprate = pageList[i].rate*nowrate
                pageList[i].xScale = tmprate
                pageList[i].yScale = tmprate
                pageList[i].x = _W*2 - scrOrgx + (i-2)*pageList[i].contentWidth          
                pageList[i].y = scrOrgy + pageList[i].contentHeight*0.5
 
          -- end      
        end

      elseif pleft > maxPage then
      
        --local bounds = pageList2[maxPage].contentBounds
         local tmprate = pageList2[maxPage].rate*nowrate
        --  if centerx >= bounds.xMin and centerx <= bounds.xMax and centery >= bounds.yMin and centery <= bounds.yMax then
          
        --   local orgdx = centerx - _W 
        --   local orgdy = centery - _H
        --   local dx = orgdx*(tmprate - pageList2[maxPage].rate)
        --   local dy = orgdy*(tmprate - pageList2[maxPage].rate)
        --   local tarx = _W - dx - pageList2[maxPage].contentWidth -- orgdx*0.55
        --   local tary = _H - dy  -- orgdy*0.55
          
         
         
        --      pageList2[maxPage].x = tarx
        --     pageList2[maxPage].y = tary
          

        -- end
           pageList2[maxPage].xScale = tmprate
           pageList2[maxPage].yScale = tmprate
  
          
          for i = 2,1,-1 do
  
              pageList[i].xScale =  tmprate
              pageList[i].yScale =  tmprate
              pageList[i].x = scrOrgx + (i-3)*pageList[i].contentWidth     
              pageList[i].y = scrOrgy +  pageList[i].contentHeight*0.5  
 
          end
         

      else
       
        --local bounds = pageList2[pleft-1].contentBounds
        --local bounds2 = pageList2[pleft].contentBounds
        local tmprate1 = pageList2[pleft].rate*nowrate
        local tmprate2 = pageList2[pleft-1].rate*nowrate
        -- if centerx >= bounds.xMin and centerx <= bounds2.xMax and centery >= bounds.yMin and centery <= bounds.yMax then
        --   local orgdx = centerx - _W
        --   local orgdy = centery - _H
        --   local dx = orgdx*(tmprate1 - pageList2[pleft].rate)
        --   local dy = orgdy*(tmprate1 - pageList2[pleft].rate)
        --   local tarx = _W - dx -- orgdx*0.55
        --   local tary = _H - dy -- orgdy*0.55
         
        --   local tarx2 = _W - dx -pageList2[pleft-1].contentWidth -- orgdx*0.55
        --   local tary2 = _H - dy -- orgdy*0.55
          
         
        --     pageList2[pleft].x = tarx
        --     pageList2[pleft].y = tary
        --     pageList2[pleft-1].x = tarx2
        --     pageList2[pleft-1].y = tary2
          
        -- end
              -- pageList2[pleft].x= _W
              -- pageList2[pleft].y = _H
              -- pageList2[pleft-1].x = pageList2[pleft].x- pageList2[pleft-1].contentWidth
              -- pageList2[pleft-1].y = _H
              pageList2[pleft-1].xScale = tmprate2
              pageList2[pleft-1].yScale = tmprate2
              pageList2[pleft].xScale = tmprate1
              pageList2[pleft].yScale = tmprate1
             
              --pageList2[pleft-1].x = pageList2[pleft].x - pageList2[pleft-1].contentWidth
            if centerx >= bounds.xMin and centerx <= bounds.xMax and centery >= bounds.yMin and centery <= bounds.yMax then  
              pageList2[pleft].x = pageList2[pleft-1].x + pageList2[pleft].anchorX*pageList2[pleft].contentWidth+ pageList2[pleft-1].contentWidth*(1- pageList2[pleft-1].anchorX)
              pageList2[pleft].y = pageList2[pleft-1].y
            else
              pageList2[pleft-1].x = pageList2[pleft].x - pageList2[pleft].anchorX*pageList2[pleft].contentWidth- pageList2[pleft-1].contentWidth*(1- pageList2[pleft-1].anchorX)
              pageList2[pleft-1].y = pageList2[pleft].y
            
            end

            --end
              

                for i = pleft-3,pleft-2 do     
                  if i <= maxPage and i > 0  then
                   
                      local tmprate = pageList2[i].rate*nowrate
                      pageList2[i].xScale = tmprate
                      pageList2[i].yScale = tmprate
                      pageList2[i].x = scrOrgx + (i-pleft+1)*pageList2[i].contentWidth
                      pageList2[i].y = scrOrgy + pageList2[i].contentHeight*0.5
                      
                    --end
                  end
                end

                for i = pleft+1,pleft+2 do
                  if i <= maxPage then
                    
                        local tmprate = pageList2[i].rate*nowrate
                        pageList2[i].xScale = tmprate
                        pageList2[i].yScale = tmprate
                        pageList2[i].x = _W*2 - scrOrgx + (i-pleft-1)*pageList2[i].contentWidth
                        pageList2[i].y = scrOrgy + pageList2[i].contentHeight*0.5
                        
                     
                  end
                end
          
              
      end
    --end
  else
    ----直向，多點觸控
    
        -- if nowrate == 1 then
        --       --local dw = _W*2-2*scrOrgx - pageList2[p1].originpagewidth*pageList2[p1].rate
        --       scalef = false
        --       scaleing = false
        --       arrangPageFn2()
        -- else
          local tmprate = nowrate*pageList2[p1].rate
          --local bounds = pageList2[p1].contentBounds 
          
          -- if centerx >= bounds.xMin and centerx <= bounds.xMax and centery >= bounds.yMin and centery <= bounds.yMax then
          --    local dw = _W*2-2*scrOrgx - pageList2[p1].originpagewidth
          --   --local orgdx = centerx - scrOrgx - dw/2
          --   local newanchx = (centerx - pageList2[p1].x)/pageList2[p1].contentWidth
          --   local newanchy = (centery - pageList2[p1].y+pageList2[p1].contentHeight*0.5)/pageList2[p1].contentHeight
          --   pageList2[p1].x = pageList2[p1].x - (pageList2[p1].anchorX-newanchx)*pageList2[p1].contentWidth
          --   pageList2[p1].y = pageList2[p1].y - (pageList2[p1].anchorY-newanchy)*pageList2[p1].contentHeight

          --   pageList2[p1].anchorX = newanchx
          --   pageList2[p1].anchorY = newanchy
          --   local orgdx = centerx - pageList2[p1].x
          --   local orgdy = centery - _H 
          --   local dx = orgdx*(tmprate - pageList2[p1].rate)
          --   local dy = orgdy*(tmprate - pageList2[p1].rate)
          --   local tarx = scrOrgx + dw/2 - dx  
          --   local tary = _H - dy 
           
          -- end

          pageList2[p1].xScale = tmprate
          pageList2[p1].yScale = tmprate
         
          if p1 == 1 then

              local tmprate =  pageList[2].rate*nowrate
              pageList[2].xScale = tmprate
              pageList[2].yScale = tmprate
              pageList[2].x = _W*2 - scrOrgx
              pageList[2].y = scrOrgy + pageList[2].contentHeight*0.5  
            
           
          elseif p1 == maxPage then
             
              local tmprate =  pageList[1].rate*nowrate
              pageList[1].xScale = tmprate
              pageList[1].yScale = tmprate
              pageList[1].x = scrOrgx - pageList[1].contentWidth
              pageList[1].y = scrOrgy + pageList[1].contentHeight*0.5  
            
          else
             
              local tmprate =  pageList[1].rate*nowrate
              pageList[1].xScale = tmprate
              pageList[1].yScale = tmprate
              pageList[1].x = scrOrgx - pageList[1].contentWidth
              pageList[1].y = scrOrgy + pageList[1].contentHeight*0.5  
        
 
               local tmprate =  pageList[3].rate*nowrate
              pageList[3].xScale = tmprate
              pageList[3].yScale = tmprate
              pageList[3].x = _W*2 - scrOrgy
              pageList[3].y = scrOrgy + pageList[3].contentHeight*0.5  

          end
       
              
    end
  
end

local function turnPagefn(event)
  if optionItemf == false and loadingf == false then
  if currentOrientation == "landscapeLeft" or currentOrientation == "landscapeRight" then
    local x = event.xStart
    local y = event.yStart
    if optionf == true then
      flipArea[2] =  scrOrgy + optionBoxUp + statusbarHeight----up
  
      flipArea[4] =  -scrOrgy + _H*2 - optionBoxDown --down
    else
      flipArea[2] =  scrOrgy  + statusbarHeight----up
  
      flipArea[4] =  -scrOrgy + _H*2  --down
    end

     
    if x > flipArea[1] and x < flipArea[3] and y > flipArea[2] and y < flipArea[4]  then
  
      local ph = event.phase
      local tmp = {}

      if ph == "began" then       
        -- --print("clickhere========")
        -- --print("numTouches111==",numTouches)
         numTouches = numTouches + 1
           table.insert(idList,event.id)
           table.insert(tmp,event.xStart)
           table.insert(tmp,event.yStart)
           table.insert(mutitouchPos,tmp)

           if bigautof == false then
            if pleft == 1 then
                 bounds = pageList2[1].contentBounds
                  
                 zoomdx = pageList2[1].x - event.x
                 zoomdy = pageList2[1].y - event.y
             
               elseif pleft > maxPage then
                bounds = pageList2[maxPage].contentBounds
                zoomdx = pageList2[maxPage].x - event.x
                zoomdy = pageList2[maxPage].y - event.y
               else
                 bounds = pageList2[pleft-1].contentBounds
                 bounds2 = pageList2[pleft].contentBounds
                 zoomdx = pageList2[pleft].x - event.x
                 zoomdy = pageList2[pleft].y - event.y
               end

           end
          -- ----print("numTouches222222======",numTouches)
        if numTouches == 1 then
          mf = false
          mutitouchf = false
           oldx = event.xStart
          
          if scalef == false then
           -- if flipType == 1 then
              if turnf == false and autof == false then
              
               turnf = true
              
             
              end
            -- else
            --  if turnf == false and autof == false then
            
            --    turnf = true
            --  end
            --end
          else
           -- ----print("77777777")
            turnf = false
         
            if  bigautof == false then
               
                Runtime:removeEventListener("enterFrame",bigPageFloatFn )
                 Runtime:removeEventListener("enterFrame",bigPageBackFn )
                bigBackDown = false
                bigBackUp = false
                bigBackRight = false
                bigBackLeft = false
                bigMovef = false
        
                 starttime = event.time
          
               
              ----print("zoomdx===",zoomdx)
              ----print("zoomdy===",zoomdy)
            end
          end
        end

        if numTouches > 1 and numTouches <=3 and autof == false then
          ------print("mutitouchf == true------1")
          delaytime = system.getTimer( )
          mutitouchf =  true
          local sumx = 0
          local sumy = 0
          local num = #mutitouchPos
          for i =1,num do
            sumx = sumx + mutitouchPos[i][1]
            sumy = sumy + mutitouchPos[i][2]
          end
          centerx = sumx/num
          centery = sumy/num
          touchDistance = 0

          for i = 1,num do
            local x = mutitouchPos[i][1]
            local y = mutitouchPos[i][2]
            x = centerx - x
            y = centery - y
            touchDistance = touchDistance + math.sqrt( x*x + y*y )
          end
          oldDistance = touchDistance
          
                

          if scalef == false then
            scalef = true
            scaleing = true
            onoff.alpha = 0.5
            oldflipType = flipType
               
                nowrate = 1
                if oldflipType == 1 then
                  
                  arrangPageFn2()
                  flipType = 0
                end
                 -- mutirate = oldrate
          else
             if pleft <= maxPage then
                  
                  targetrate = pageList2[pleft].rate

              else
                  
                  targetrate = pageList2[pleft-1].rate
              end
          end
          mutirate = nowrate

          if pleft == 1 then

            if centerx >= bounds.xMin and centerx <= bounds.xMax and centery >= bounds.yMin and centery <= bounds.yMax then
              
              local newanchx = (centerx - pageList2[1].x)/pageList2[1].contentWidth
              local newanchy = (centery - pageList2[1].y+pageList2[1].contentHeight*0.5)/pageList2[1].contentHeight
              pageList2[1].x = pageList2[1].x - (pageList2[1].anchorX-newanchx)*pageList2[1].contentWidth
              pageList2[1].y = pageList2[1].y - (pageList2[1].anchorY-newanchy)*pageList2[1].contentHeight

              pageList2[1].anchorX = newanchx
              pageList2[1].anchorY = newanchy  
            end
          elseif pleft > maxPage then
            if centerx >= bounds.xMin and centerx <= bounds.xMax and centery >= bounds.yMin and centery <= bounds.yMax then

                local newanchx = (centerx - pageList2[maxPage].x)/pageList2[maxPage].contentWidth
                local newanchy = (centery - pageList2[maxPage].y+pageList2[maxPage].contentHeight*0.5)/pageList2[maxPage].contentHeight
                pageList2[maxPage].x = pageList2[maxPage].x - (pageList2[maxPage].anchorX-newanchx)*pageList2[maxPage].contentWidth
                pageList2[maxPage].y = pageList2[maxPage].y - (pageList2[maxPage].anchorY-newanchy)*pageList2[maxPage].contentHeight
                
                

                pageList2[maxPage].anchorX = newanchx
                pageList2[maxPage].anchorY = newanchy  
            end
          else
            if centerx >= bounds2.xMin and centerx <= bounds2.xMax and centery >= bounds2.yMin and centery <= bounds2.yMax then
              
              local newanchx = (centerx - pageList2[pleft].x)/pageList2[pleft].contentWidth
              local newanchy = (centery - pageList2[pleft].y+pageList2[pleft].contentHeight*0.5)/pageList2[pleft].contentHeight
              

              pageList2[pleft].x = pageList2[pleft].x - (pageList2[pleft].anchorX-newanchx)*pageList2[pleft].contentWidth
              pageList2[pleft].y = pageList2[pleft].y - (pageList2[pleft].anchorY-newanchy)*pageList2[pleft].contentHeight
              

              pageList2[pleft-1].x = pageList2[pleft].x - newanchx*pageList2[pleft].contentWidth- pageList2[pleft-1].contentWidth*(1-newanchx)
              -- local textnum2 = display.newText(tostring( pageList2[pleft-1].x) ,250,200,native.systemFont,30)
              --     textnum2:setFillColor( 1,0,0 )
              --     sceneGroup:insert(textnum2)
              pageList2[pleft-1].y = pageList2[pleft].y
              

              pageList2[pleft].anchorX = newanchx
              pageList2[pleft].anchorY = newanchy  
              pageList2[pleft-1].anchorX = newanchx
              pageList2[pleft-1].anchorY = newanchy  
              

            elseif centerx >= bounds.xMin and centerx <= bounds.xMax and centery >= bounds.yMin and centery <= bounds.yMax then
              
              local newanchx = (centerx - pageList2[pleft-1].x)/pageList2[pleft-1].contentWidth
              local newanchy = (centery - pageList2[pleft-1].y+pageList2[pleft-1].contentHeight*0.5)/pageList2[pleft-1].contentHeight
              

              pageList2[pleft-1].x = pageList2[pleft-1].x - (pageList2[pleft-1].anchorX-newanchx)*pageList2[pleft-1].contentWidth
              pageList2[pleft-1].y = pageList2[pleft-1].y - (pageList2[pleft-1].anchorY-newanchy)*pageList2[pleft-1].contentHeight
              pageList2[pleft].x = pageList2[pleft-1].x + newanchx*pageList2[pleft].contentWidth+ pageList2[pleft-1].contentWidth*(1-newanchx)
              pageList2[pleft].y = pageList2[pleft-1].y

              pageList2[pleft].anchorX = newanchx
              pageList2[pleft].anchorY = newanchy  
              pageList2[pleft-1].anchorX = newanchx
              pageList2[pleft-1].anchorY = newanchy  
            end
          end
          --Runtime:addEventListener("enterFrame",mutimoveFn)
        end
      
      elseif ph == "moved" then
          local tmp = {}    
          table.insert(tmp,event.x)
          table.insert(tmp,event.y)
          --table.insert(mutitouchPos,tmp)
          local pos = wetools.getpos(event.id,idList)
          ------print("sacalef ===",scalef)
          mutitouchPos[pos] = tmp
          
        if numTouches > 1 and numTouches <= 3 and autof == false then 
          --local textnum = display.newText(tostring(numTouches),400,50,native.systemFont,40)
            ---多點縮放

            local sumx = 0
            local sumy = 0
            local num = #mutitouchPos
            for i =1,num do
              sumx = sumx + mutitouchPos[i][1]
              sumy = sumy + mutitouchPos[i][2]
            end
            local newcenterx = sumx/num
            local newcentery = sumy/num
            touchDistance = 0
            for i = 1,num do
               local x = mutitouchPos[i][1]
               local y = mutitouchPos[i][2]
               x = newcenterx - x
              y = newcentery - y
              touchDistance = touchDistance + math.sqrt( x*x + y*y ) ----新的距離
            end
            

            local touchrate = touchDistance/oldDistance
            oldDistance = touchDistance
            mutirate = mutirate*touchrate

            -- if textnum2 == nil then
            --   textnum2 = display.newText(tostring(mutirate) ,300,200,native.systemFont,40)
            --   textnum2:setFillColor( 1,0,0 )
            --   sceneGroup:insert(mutirate)
           
            -- end
            -- textnum2.text = tostring(mutirate)

           


            if math.abs(mutirate - nowrate) > 0.001 then
              nowrate = mutirate
              
              if nowrate > maxrate then
                nowrate = maxrate
                mutirate = maxrate
              elseif nowrate < 1 then
                nowrate = 1
                mutirate = 1
              end
              mutiZoom()
            else
              mutirate = nowrate
            end

            
        end

          if mutitouchf == false then
         -----翻頁
                local vx = event.x - event.xStart 
                if math.abs(vx) > 20   then
                      mf = true
                     -- ----print("turnf===",turnf)
                    if scalef == false then
                     -- ----print("turnf===",turnf)
                      if turnf == true then
                      
                          local ddx = event.x - oldx
                          oldx = event.x

                        if checkdir == true then
                    
                          if ddx > 0 then
                              dir = "right"
                            if flipType == 1 then
                              if ddx > 20 then 
                                  ddx = 20 
                              end   
                            end
                            --print("pright===",pright)             
                            if pright > 0 then
                                p1 = pright
                                p2 = p1 - 1
                            
                                -- pageList2[p1].no = p1  

                                if p1 <= 2 then
                                  if oldflipType == 1 then
                                    if flipType == 1 then
                                      flipType = 0 
                                      pageList2[1].anchorX = 0
                                      pageList2[1].path.x3 = 0
                                      pageList2[1].path.x4 = 0
                                      pageList2[1].path.y3 = 0
                                      pageList2[1].path.y4 = 0
                                      pageList2[1].x = pageList2[2].x - pageList2[1].contentWidth - (_W*2 - scrOrgx*2 - pageList2[1].contentWidth) - pageList2[2].contentWidth
                                      --print("page22222.x===",pageList2[1].x)
                                      pageList2[2]:toBack( )
                                      pageList2[1]:toBack( )
                                      mask:toBack( )
                                    end
                                  end
                                end 

                                if flipType == 1 then                 
                                  pageList2[p1]:toFront( )
                                end
                                gof = true               
                                checkdir = false
                            else
                              if flipType ==1 then
                                  checkdir = true
                                  gof = false
                              else
                                if pleft ==1 then
                                  if pageList2[1].x < firstPos then
                                    gof = true
                                    checkdir = false
                                  else
                                       checkdir = true
                                       gof = false
                                  end
                                else
                                    gof = true
                                    checkdir = false
                                end
                              end
                            end
                          end
                          if ddx < 0 then

                            if pleft+2 >= maxPage then
                              if flipType == 1 then
                                oldflipType = 1
                                flipType = 0
                                if maxPage % 2 == 0 then
                                  pageList2[maxPage].anchorX = 0
                                  pageList2[maxPage].x = _W*2-2*scrOrgx + (_W*2 - 2*scrOrgx - pageList2[maxPage].contentWidth)
                                  --print("maxpage.xxxxxxxx==",pageList2[maxPage].x)
                                  pageList2[maxPage].path.x3 = 0
                                  pageList2[maxPage].path.x4 = 0
                                  pageList2[maxPage].path.y3 = 0
                                  pageList2[maxPage].path.y4 = 0
                                  pageList2[maxPage].path.x1 = 0
                                  pageList2[maxPage].path.x2 = 0
                                  pageList2[maxPage].path.y1 = 0
                                  pageList2[maxPage].path.y2 = 0
                                  pageList2[maxPage]:toFront( )
                                else
                                  pageList2[maxPage].anchorX = 0
                                  pageList2[maxPage-1].anchorX = 0
                                  pageList2[maxPage-1].x = _W*2 - scrOrgx
                                  pageList2[maxPage].x = pageList2[maxPage-1].x + pageList2[maxPage-1].contentWidth
                                  
                                  pageList2[maxPage].path.x3 = 0
                                  pageList2[maxPage].path.x4 = 0
                                  pageList2[maxPage].path.y3 = 0
                                  pageList2[maxPage].path.y4 = 0
                                  pageList2[maxPage].path.x1 = 0
                                  pageList2[maxPage].path.x2 = 0
                                  pageList2[maxPage].path.y1 = 0
                                  pageList2[maxPage].path.y2 = 0
                                  pageList2[maxPage-1].path.x3 = 0
                                  pageList2[maxPage-1].path.x4 = 0
                                  pageList2[maxPage-1].path.y3 = 0
                                  pageList2[maxPage-1].path.y4 = 0
                                  pageList2[maxPage-1].path.x1 = 0
                                  pageList2[maxPage-1].path.x2 = 0
                                  pageList2[maxPage-1].path.y1 = 0
                                  pageList2[maxPage-1].path.y2 = 0
                                  pageList2[maxPage-1]:toFront( )
                                  pageList2[maxPage]:toFront( )
                                end
                                mask:toBack( )
                                --arrangPageFn2()
                              end
                             end

                            if flipType ==1 then
                              if ddx < -20 then
                                  ddx = -20
                              end
                            end
                              dir = "left"
                            if pleft < maxPage then                   
                                 p1 = pleft

                                 p2 = p1 + 1                    
                              
                                 ----print("leftleftleftleft")
                        
                                 -- pageList2[p1].no = p1
                                
                                  if flipType == 1 then
                                     pageList2[p1]:toFront( )
                                  end
                         
                                 gof = true
                                 checkdir = false
                            else
                              if flipType ==1 then
                                checkdir = true
                                gof = true
                              else
                                if pleft >= maxPage then
                                  if pageList2[maxPage].x > firstPos then
                                    gof = true   
                                    checkdir = false                     
                                  else  
                                    checkdir = true                  
                                    gof = false
                                  end
                                else
                                  gof = true   
                                  checkdir = false 
                                end
                              end
                            end
                          end
                          ----print("gof1===",gof)
                        else
                          if ddx > 0 then
                       -- autovx = ddx
                            if flipType ==1 then
                              if ddx > 20 then 
                                ddx = 20 
                              end
                            end
                              ----print("right==========")
                              dir = "right"
                          end
                          if ddx < 0 then
                      --  autovx = ddx
                            if flipType == 1 then
                              if ddx < -20 then
                                ddx =-20 
                              end
                            end
                              dir = "left"
                            end
                          end
                        ------print("ddx===",ddx)
                        autovx = ddx*2
                        if flipType == 0 then
                          if autovx == 0 then
                            gof = false
                          else 
                            ------print("pleft===",pleft)
                            if dir == "left" then
                              if pleft < maxPage then
                               gof = true
                              else
                               gof = false
                              end
                            else
                              gof = true
                            end
                          end
                        end
                        --print("gof===",gof)
                        ----print("gof2===",gof)
                        if gof == true then


                          if flipType == 1 then
                       -- ----print("bbbb")
                              ----print("p1====",p1)
                            if p1 % 2 == 1 then

                              

                              mask:toFront()
                              pageList2[p1]:toFront()
                              if pageList2[p1].path.x4 + autovx > -pageList2[p1].originpagewidth then

                                if pageList2[p1].path.x4 + autovx < 0 then
                                  if mask.alpha ==0 then 
                                    mask.alpha =1 
                                  end
                                  pageList2[p1].path.x4 = pageList2[p1].path.x4 + autovx
                                  local dx = pageList2[p1].originpagewidth + pageList2[p1].path.x4
                            
                                  local ang = math.acos(dx/pageList2[p1].originpagewidth)*0.3
                                  pageList2[p1].path.x3 = pageList2[p1].path.x4
                                  pageList2[p1].path.y4 = -pageList2[p1].originpagewidth*math.sin(ang)
                                  pageList2[p1].path.y3 = pageList2[p1].path.y4

                                  -- pageList2[p2].path.x1 = pageList2[p2].path.x1+autovx 
                                  -- pageList2[p2].path.x2 = pageList2[p2].path.x2+autovx
                               
                                  -- pageList2[p2].path.y1 = pageList2[p1].path.y3
                                  -- pageList2[p2].path.y2 = pageList2[p1].path.y3
                                     pageList2[p2].path.x1 = pageList2[p2].originpagewidth
                                     pageList2[p2].path.x2 = pageList2[p2].originpagewidth
                               
                                     pageList2[p2].path.y1 = 0
                                     pageList2[p2].path.y2 = 0
                                 
                                  local mx4 = pageList2[p1].path.x4*1.1
                                 
                                  if mx4 < -pageList2[p1].originpagewidth then 
                                    mx4 = -pageList2[p1].originpagewidth
                                  end
                                  mratex = mask.orgx/pageList2[p1].originpagewidth
                                  mratey = mask.orgy/pageList2[p1].originpageheight
                                  
                                    mask.path.x4 = mx4*mratex
                                    mask.path.x3 = mx4*mratex
                                    mask.path.y3 = -mratey*pageList2[p1].originpagewidth*math.sin(ang)/4
                                  if math.abs(mask.path.x4+pageList2[p1].originpagewidth) < 3 then
                                    mask.alpha = 0
                                    mask:toFront()
                                    pageList2[p2].alpha = 0
                             
                                    pageList2[p2].path.x4=0
                                    pageList2[p2].path.x3=0
                                    pageList2[p2].path.x1=pageList2[p2].originpagewidth
                                    pageList2[p2].path.x2=pageList2[p2].originpagewidth
                                    pageList2[p2].path.y3 = 0
                                    pageList2[p2].path.y4 = 0
                                  end
                                  ----print("2929")
                                  canautof = true
                                else
                             -- ----print("pageList2[p2].path.x1===",pageList2[p2].path.x1)
                                  canautof = false
                                  --print("88888")
                                  turnf = false
                                  checkdir = true
                                  pageList2[p1].path.x4 = 0
                                  pageList2[p1].path.x3 = 0
                                  pageList2[p1].path.y3 = 0
                                  pageList2[p1].path.y4 = 0
                                  pageList2[p2].path.x1 = 2*pageList2[p2].originpagewidth
                                  pageList2[p2].path.x2 = 2*pageList2[p2].originpagewidth
                                  pageList2[p2].path.y1 = 0
                                  pageList2[p2].path.y2 = 0
                                  
                                end

                              else
                               ---過中線
                               --print("pass1====")
                                mask:toFront()
                                ----print("pageList2[p2]===",pageList2[p2])
                                    pageList2[p1].path.x4 = -pageList2[p1].originpagewidth
                                    pageList2[p1].path.x3 = -pageList2[p1].originpagewidth
                                    pageList2[p1].path.y3 = 0
                                    pageList2[p1].path.y4 = 0
                                
                                pageList2[p2]:toFront()
                           
                                if pageList2[p2].alpha == 0 then pageList2[p2].alpha = 1 end
                                if mask.alpha ==0 then mask.alpha =1 end

                                if pageList2[p2].path.x1 +autovx > 0 then
                                   -- ----print("bbbbbbbbbbb")

                                      pageList2[p2].path.x1 = pageList2[p2].path.x1 +autovx
                                      ------print("x1===",pageList2[p2].path.x1)
                                     -- pageList2[p1].path.x4 = pageList2[p1].path.x4 + autovx
                                      
                                      local dx =  pageList2[p2].originpagewidth-pageList2[p2].path.x1 -- -pageList2[p1].path.x4 - originpagewidth
                                      
                                      local ang = math.acos(dx/pageList2[p2].originpagewidth)*0.3
                                      
                                      pageList2[p2].path.y1 = -pageList2[p2].originpagewidth*math.sin(ang)
                                      pageList2[p2].path.x2 = pageList2[p2].path.x1
                                      pageList2[p2].path.y2 = -pageList2[p2].originpagewidth*math.sin(ang)
                                      -- pageList2[p1].path.x4 = -pageList2[p1].originpagewidth
                                      -- pageList2[p1].path.x3 = -pageList2[p1].originpagewidth
                                      -- pageList2[p1].path.y4 = 0
                                      -- pageList2[p1].path.y3 = 0
                                        --print("pageList2[p2]=",pageList2[p2].originpagewidth)
                                        local mx4 = -pageList2[p2].originpagewidth-(dx)*0.9
                                        mask.alpha = 1
                                        
                                        mratex = mask.orgx/pageList2[p2].originpagewidth
                                        mratey = mask.orgy/pageList2[p2].originpageheight
                                       -- --print("mask.width==",mask.width)
                                        ----print("mratex==",mratex)
                                        mask.path.x4 = mx4*mratex
                                 
                                        mask.path.x3 = mx4*mratex
                                    mask.path.y3 = -mratey*pageList2[p2].originpagewidth*math.sin(ang)/4
                                    ----print("2990")
                                    canautof = true
                                else
                                   --print("ccccccc")
                                  --  ----print("pageList2[p1].path.x4===",pageList2[p1].path.x4)
                                    autof = false
                                    pageList2[p2].path.x1 = 0
                                    pageList2[p2].path.x2 =  0
                                    pageList2[p2].path.y1 = 0
                                    pageList2[p2].path.y2 = 0
                                  
                                    pageList2[p2].path.y4 = 0
                                    pageList2[p2].path.y3 = 0
                                    pageList2[p1].path.x4 = -2*pageList2[p1].originpagewidth
                                    pageList2[p1].path.x3 = -2*pageList2[p1].originpagewidth
                                    pageList2[p1].path.y3 = 0
                                    pageList2[p1].path.y4 = 0
                                    ----print("9999999")
                                    turnf = false
                                    checkdir = true
                                    canautof = false
                                    --pageList2[p2].enabled = true
                                    if dir == "left" then
                                      if pleft + 2 <= maxPage then
                                        pleft = pleft + 2
                                       -- if maxPage % 2 == 1 then
                                          pright = pleft -1
                                     
                                      else
                                        pright = maxPage
                                        pleft = pleft+2
                                      end
                                      
                                      local dx = 0 
                                      local tmpsmallpage = nil
                                      if pleft > 1 then
                                        dx = smallPageGroup[(pleft-1)*2].x
                                        tmpsmallpage = smallPageGroup[(pleft-1)*2]
                                      else
                                        dx = smallPageGroup[pleft*2].x
                                        tmpsmallpage = smallPageGroup[pleft*2]
                                      end
                                      if dx < scrOrgx + 20 then
                                        backRight = true
                                       Runtime:addEventListener( "enterFrame", smallPageAutoMoveFn)
                                      end
                                      if dx > _W*2 - scrOrgx - 20 - tmpsmallpage.contentWidth*0.5  then 
                                          backLeft  = true
                                          Runtime:addEventListener( "enterFrame", smallPageAutoMoveFn)                             
                                      end    

                                      local nowpage = 0
                                      if pleft > maxPage then
                                        nowpage = maxPage
                                      else
                                        nowpage = pleft
                                      end

                                      local nextpage_path = system.pathForFile( choice_bookcode.."/"..nowpage..".png", baseDir )
                                      local mode = lfs.attributes(nextpage_path, "mode")
                                      if mode == nil then
                                        loadpage(nowpage,true)
                                      else
                                        arrangPageFn()
                                      end
                                    end          
                                end

                              end

                            else
                              ---偶數頁            
                              mask:toFront()
                              pageList2[p1]:toFront()
                              

                              if pageList2[p1].path.x1 + autovx < pageList2[p1].originpagewidth then
                                ------print("pageList2[p1].name===",pageList2[p1].name)
                          
                                if pageList2[p1].path.x1 + autovx > 0 then
                                  pageList2[p1].path.x1 = pageList2[p1].path.x1 + autovx
                                  if mask.alpha == 0 then 
                                    mask.alpha = 1
                                  end
                                  local dx = pageList2[p1].originpagewidth-pageList2[p1].path.x1 
                                  local ang = math.acos(dx/pageList2[p1].originpagewidth)*0.3
                        
                                  pageList2[p1].path.x2 = pageList2[p1].path.x1
                      
                                  pageList2[p1].path.y1 = -pageList2[p1].originpagewidth*math.sin(ang)                     
                                  pageList2[p1].path.y2 = -pageList2[p1].originpagewidth*math.sin(ang)

                                  -- pageList2[p2].path.x3 = pageList2[p2].path.x3 + autovx
                                  -- pageList2[p2].path.x4 = pageList2[p2].path.x4 + autovx
                                  -- pageList2[p2].path.y3 = pageList2[p1].path.y1
                                  -- pageList2[p2].path.y4 = pageList2[p1].path.y1
                                  --print("pagelist2.y1==",pageList2[p2].path.y4)

                                    pageList2[p2].path.x3 = -pageList2[p2].originpagewidth
                                   pageList2[p2].path.x4 = -pageList2[p2].originpagewidth
                                   pageList2[p2].path.y3 = 0
                                   pageList2[p2].path.y4 = 0

                     
                                  local mx4 = -pageList2[p1].originpagewidth-(dx)*0.9
                                  mratex = mask.orgx/pageList2[p1].originpagewidth
                                  mratey = mask.orgy/pageList2[p1].originpageheight
                                  mask.path.x4 = mx4*mratex
                                  mask.path.x3 = mx4*mratex
                                  mask.path.y3 = -mratey*pageList2[p1].originpagewidth*math.sin(ang)/4
                                 -- --print("mask.paht.x4=",mask.path.x4)
                                  if math.abs(mask.path.x4 + pageList2[p1].originpagewidth) < 3 then
                                    
                                    mask.alpha = 0
                                    mask:toFront( )
                                    mask.path.x3 = -mask.orgx
                                    mask.path.x4 = -mask.orgx
                                    mask.path.y3 = 0
                                    mask.path.y4 = 0


                                    pageList2[p2].alpha = 0
                                
                                  end
                                  ----print("3114")
                                  canautof = true
                                else
                             -- ----print("dfdsfsafdsaf")
                                  canautof = false
                                  --print("10101010101")
                                  turnf = false
                                  checkdir = true
                                 
                                  pageList2[p2].path.x4 = -pageList2[p2].originpagewidth
                                  pageList2[p2].path.x3 = -pageList2[p2].originpagewidth
                                  pageList2[p2].path.y3 = 0
                                  pageList2[p2].path.y4 = 0
                                  pageList2[p1].path.x1 = 0
                                  pageList2[p1].path.x2 = 0
                                  pageList2[p1].path.y1 = 0
                                  pageList2[p1].path.y2 = 0
                                end
                              else
                                ---過中線
                                ----print("eeeee")
                                mask:toFront()
                                --
                                if mask.path.x3 < -mask.orgx+100 then
                                  mask.path.x3 = -mask.orgx+100
                                  mask.path.x4 = -mask.orgx+100
                                  --print("ccccc")
                                  
                                end
                                pageList2[p2]:toFront()

                             --pageList2[p1].alpha = 0
                                if pageList2[p2].alpha == 0 then 
                                  pageList2[p2].alpha =1 
                                end
                                if mask.alpha ==0 then 
                                  --print("aaaa")
                                  mask.alpha =1 
                                end
                             ------print("pageList2[p2].path.x4 ===",pageList2[p2].path.x4)
                                if pageList2[p2].path.x4 +autovx < 0 then
                                  pageList2[p2].path.x4 = pageList2[p2].path.x4 +autovx
                                
                                  local dx =  pageList2[p2].path.x4 + pageList2[p2].originpagewidth
                     
                                  local ang = math.acos(dx/pageList2[p2].originpagewidth)*0.3
                      
                                  pageList2[p2].path.x3 = pageList2[p2].path.x4
                                  pageList2[p2].path.y4 = -pageList2[p2].originpagewidth*math.sin(ang)
                                  pageList2[p2].path.y3 = -pageList2[p2].originpagewidth*math.sin(ang)
                                  -- pageList2[p1].path.x1 = pageList2[p1].path.x1 + autovx
                                  -- pageList2[p1].path.x2 = pageList2[p1].path.x2 + autovx
                                  -- pageList2[p1].path.y1 = pageList2[p2].path.y3
                                  -- pageList2[p1].path.y2 = pageList2[p2].path.y4
                                  pageList2[p1].path.x1 = pageList2[p1].originpagewidth
                                  pageList2[p1].path.x2 = pageList2[p1].originpagewidth
                                  pageList2[p1].path.y1 = 0
                                  pageList2[p1].path.y2 = 0

                                  local mx4 = pageList2[p2].path.x4*1.1
                               -- ----print("mx4",mx4)
                                  if mx4 <-pageList2[p2].originpagewidth then 
                                   mx4 = -pageList2[p2].originpagewidth
                                  end
                                  mratex = mask.orgx/pageList2[p2].originpagewidth
                                  mratey = mask.orgy/pageList2[p2].originpageheight

                                   --print("mx4*mratex",mx4*mratex)
                                  mask.path.x4 = mx4*mratex
                                  mask.path.x3 = mx4*mratex
                                  mask.path.y3 = -mratey*pageList2[p2].originpagewidth*math.sin(ang)/4
                                  cnaautof = true
                          
                                else
                                -- ----print("pageList2[p1].path.x1===",pageList2[p1].path.x1)
                                  pageList2[p2].path.x4 = 0
                                  pageList2[p2].path.x3 =  0
                                  pageList2[p2].path.y4 = 0
                                  pageList2[p2].path.y3 = 0
                                  pageList2[p1].path.x1 = 2*pageList2[p1].originpagewidth
                                  pageList2[p1].path.x2 = 2*pageList2[p1].originpagewidth
                                  pageList2[p1].path.y1 = 0
                                  pageList2[p1].path.y2 = 0
                                  ----print("12121212")
                                  turnf = false
                                  canautof = false
                                  checkdir = true
                                  if dir == "right" then
                                    if pleft -2 >=1 then
                                      pleft = pleft -2
                                      pright = pleft -1
                                    end
                                    
                                    local dx = 0 
                                    local tmpsmallpage = nil
                                    if pleft > 1 then
                                      dx = smallPageGroup[(pleft-1)*2].x
                                      tmpsmallpage = smallPageGroup[(pleft-1)*2]
                                    else
                                      dx = smallPageGroup[pleft*2].x
                                      tmpsmallpage = smallPageGroup[pleft*2]
                                    end
                                    if dx < scrOrgx + 20 then
                                      backRight = true
                                     Runtime:addEventListener( "enterFrame", smallPageAutoMoveFn)
                                    end
                                    if dx > _W*2 - scrOrgx - 20 - tmpsmallpage.contentWidth*0.5  then 
                                        backLeft  = true
                                        Runtime:addEventListener( "enterFrame", smallPageAutoMoveFn)                             
                                    end    

                                    local nextpage_path = system.pathForFile( choice_bookcode.."/"..pleft..".png", baseDir )
                                    local mode = lfs.attributes(nextpage_path, "mode")
                                    if mode == nil then
                                      loadpage(pleft,true)
                                    else
                                      arrangPageFn()
                                    end

                                  end
                                end
                              end
                            end
                        
                          else
                          ------不翻頁


                            canautof = true
                                    ----print("pleft===",pleft)
                                    if dir == "right" and pleft > 1 then                
                                      -- if pleft ==3 then
                                      --    firstPos = _W - pageList2[1].contentWidth*0.5
                                      --    --print("firstPos=",firstPos)
                                      --    if pageList2[1].x + ddx > firstPos then --pageList[1].orgx  then                      
                                      --     ddx = firstPos - pageList2[1].x
                                      --   end
                                      -- end
                                      for i = 1,pageList.numChildren do
                                        pageList[i].x = pageList[i].x + ddx                    
                                      end
                                    
                                    elseif dir == "left"  then  
                                                  
                                      -- if pleft+2 >= maxPage then
                                      --  if maxPage % 2 == 0 then
                                      --     firstPos = _W - pageList2[maxPage].contentWidth*0.5
                                      --  else
                                      --     firstPos = _W
                                      --  end
                                      --  if pageList2[maxPage].x > firstPos  then
                                      --     ddx = firstPos - pageList2[maxPage].x
                                      --  end                  
                                      -- end
                                      -- --print("pageList2[maxPage].===",pageList2[maxPage].x)
                                      for i = 1,pageList.numChildren do
                                        pageList[i].x = pageList[i].x + ddx                    
                                      end
                                    else
                                      canautof = false
                                      autof = false
                                    end        
                            -- canautof = true
                       
                            -- if dir == "right" then
                            
                            --   if pleft ==1 then
                            --    if pageList2[1].x + ddx > firstPos then --pageList[1].orgx  then
                                 
                            --      ddx = firstPos - pageList2[1].x

                            --     end
                            --   end
                            -- end

                            -- if dir == "left" then
                           
                            --   if pleft >= maxPage then
                            --    if pageList2[maxPage].x < firstPos  then
                            --       ddx = firstPos - pageList2[maxPage].x
                            --    end
                              
                            --   end
                            -- end
                            
                            -- for i = 1,pageList.numChildren do
                            --    pageList[i].x = pageList[i].x + ddx
                               
                            -- end
                          end
                        end        
                      end          
                    else
                      ------print("zoomdx===",zoomdx)
                    ---放大時單點滑動
                      if bigautof == false  then
                        bigMovef = true
                        ----print("move..............")
                          
                          if pleft ==1 then
                          --   --print("nowrate===",nowrate)
                          -- --print("pageList2[1].nowrate==",pageList2[1].nowrate)
                            pageList2[1].x = event.x + zoomdx
                           pageList2[1].y = event.y + zoomdy
                          
                          elseif pleft > maxPage then
                          --   --print("nowrate===",nowrate)
                          -- --print("pageList2[maxPage].nowrate==",pageList2[maxPage].nowrate)
                            pageList2[maxPage].x = event.x + zoomdx
                            pageList2[maxPage].y = event.y + zoomdy
                           
                          else
                                             
                            pageList2[pleft].x = event.x + zoomdx
                            pageList2[pleft].y = event.y + zoomdy
                            pageList2[pleft-1].x = event.x + zoomdx - pageList2[pleft-1].contentWidth
                  
                            pageList2[pleft-1].y = event.y + zoomdy

                         end
                      end
                    end
                  end
          end    
      elseif ph == "ended" or ph == "canceled" then    
          --print("滑動距離==",event.x - event.xStart)
          if numTouches > 1 then          
            local pos = 0
            idList,pos = wetools.deleteone(event.id,idList)
            if pos > 0 then
             table.remove(mutitouchPos,pos)
            end
          
          else
            if mutitouchf == true then
             
              --Runtime:removeEventListener("enterFrame",mutimoveFn)
              mutitouchf = false
              if pleft == 1 then
                pageList2[pleft].x = pageList2[pleft].x - pageList2[pleft].anchorX*pageList2[pleft].contentWidth
                pageList2[pleft].y = pageList2[pleft].y - (pageList2[pleft].anchorY-0.5)*pageList2[pleft].contentHeight
                pageList2[pleft].anchorX = 0
                pageList2[pleft].anchorY = 0.5
              elseif pleft > maxPage then
                pageList2[maxPage].x = pageList2[maxPage].x - pageList2[maxPage].anchorX*pageList2[maxPage].contentWidth
                pageList2[maxPage].y = pageList2[maxPage].y - (pageList2[maxPage].anchorY-0.5)*pageList2[maxPage].contentHeight
                pageList2[maxPage].anchorX = 0
                pageList2[maxPage].anchorY = 0.5
              else
                pageList2[pleft].x = pageList2[pleft].x - pageList2[pleft].anchorX*pageList2[pleft].contentWidth
                pageList2[pleft].y = pageList2[pleft].y - (pageList2[pleft].anchorY-0.5)*pageList2[pleft].contentHeight
                pageList2[pleft-1].x = pageList2[pleft].x - pageList2[pleft-1].contentWidth
                pageList2[pleft-1].y = pageList2[pleft].y
                pageList2[pleft].anchorX = 0
                pageList2[pleft].anchorY = 0.5
                pageList2[pleft-1].anchorX = 0
                pageList2[pleft-1].anchorY = 0.5
              end
              if nowrate <= 1.05 then
                
                mutimovefh = true
              --mutimovefv = true

                Runtime:addEventListener("enterFrame",mutimoveFn)

              end
            end
            --mutitouchf = false
            mutitouchPos ={}
            idList = {}
            numTouches = 0
            ------print("cccccccc") 
          end
        --print("水平按下====",numTouches)
        numTouches = numTouches - 1
        if numTouches < 0 then
          numTouches = 0
        end
      if mf == true  then
        if scalef == false and turnf == true then
          if mutitouchf == false then
            ------print("13131313")
            turnf = false
       
            if canautof == true  then
                --pageList2[p1] = pageList2[p1]
              if dir == "left" then  
                --autovx = -100 
                if flipType == 1 then
                  autovx = -220
                else
                  autovx = -140 
                end           
              else
                if flipType == 1 then
                  autovx = 220
                else
                  autovx = 140 
                end   
                --autovx = 100       
              end
                  
                  --print("autoturnfn11111111")  
  --               --print("mask10==",mask.path.x3)    
                  local s = math.abs(event.x - event.xStart)
                  -- local v = s/(event.time/1000)
                  
                  if s > 20 then
                    autof = true
                    print("h___h")
                    Runtime:addEventListener("enterFrame",autoturnfn )
                  end
            end          
          end           
        else
          if mutitouchf == false and bigMovef == true and bigautof == false then 
           bigVx = event.x - event.xStart
           bigVx = bigVx/((event.time - starttime)*0.05)
           bigVy = event.y - event.yStart
           bigVy = bigVy/((event.time - starttime)*0.05)  
          ----print("141141414")       
            turnf = false 
            local leftMax = _W*2 -scrOrgx - (_W*2-2*scrOrgx)*0.33 ---往左最大坐標
            local rightMax = scrOrgx + (_W*2-2*scrOrgx)*0.33  ----往右最大坐標
           
            if pleft ==1 then
              ---只測往左
              local left  = pageList2[1].x + pageList2[1].contentWidth--pageList2[1].width
              local top = pageList2[1].y - pageList2[1].contentHeight*0.5--pageList2[1].height*0.5
            
              if left < leftMax then
                ----放大換頁
                bigautof = true
                dir = "left"
              else
                if left < _W*2-scrOrgx then
                  bigBackRight = true
                --  ----print("right11111111=========")
                end

                if left > _W*2-2*scrOrgx + pageList2[1].contentWidth*0.67 then--pageList2[1].width*0.33 then
                  bigBackLeft = true
                 -- ----print("left11111111=========")
                end

                if top > scrOrgy then
                 -- ----print("top===",top)
                  bigBackUp = true
                 -- ----print("up11111111=========")
                end

                if top < scrOrgy - (pageList2[1].contentHeight - 2*_H) then
                  bigBackDown  = true
                --  ----print("down11111111=========")
                end
                
              end
            elseif pleft >= maxPage then
              --local rightMax = scrOrgx + (_W*2-2*scrOrgx)*0.33  ----往右最大坐標
             -- local left  = pageList2[pleft].x + contentWidth--pageList2[1].width
              --local right  = pageList2[maxPage].x 
              local top = pageList2[maxPage].y - pageList2[maxPage].contentHeight*0.5--pageList2[1].height*0.5
              if pleft > maxPage then
                local left  = pageList2[maxPage].x + pageList2[maxPage].contentWidth--pageList2[1].width
                local right  = pageList2[maxPage].x 
                if right > rightMax then
                   bigautof = true
                   dir = "right"
                   ------print("aaaaa")
                --elseif 
                else  

                  if right > scrOrgx then
                    bigBackLeft = true
                  end
                  if right < scrOrgx - (_W*2-2*scrOrgx)*0.67 then
                    bigBackRight = true
                  end

                  if top > scrOrgy then
                   -- ----print("top===",top)
                    bigBackUp = true
                   -- ----print("up11111111=========")
                  end

                  if top < scrOrgy - (pageList2[maxPage].contentHeight - 2*_H) then
                    bigBackDown  = true
                   ----up----print("down11111111=========")
                  end

                end
              else
                local left  = pageList2[pleft].x + pageList2[pleft].contentWidth--pageList2[1].width
            
                local right  = pageList2[pleft].x - pageList2[pleft].contentWidth
                if right > rightMax then
                  bigautof = true
                  dir = "right"
                 ----print("autoright====")
                else
                  if left < _W*2-scrOrgx then
                    bigBackRight = true
                    ----print("right00000=========")
                  end

                  if right > scrOrgx then
                    bigBackLeft = true
                    ----print("left00000=========")
                  end


                  if top > scrOrgy then
                   -- ----print("top===",top)
                    bigBackUp = true
                   -- ----print("up11111111=========")
                  end

                  if top < scrOrgy - (pageList2[pleft].contentHeight - 2*_H) then
                    bigBackDown  = true
                   ----up----print("down11111111=========")
                  end
                end
              end
            else
              ---雙頁
              local left  = pageList2[pleft].x + pageList2[pleft].contentWidth--pageList2[1].width
              local top = pageList2[pleft].y - pageList2[pleft].contentHeight*0.5--pageList2[1].height*0.5
              local right  = pageList2[pleft].x - pageList2[pleft].contentWidth

              if left < leftMax then
              --  ----print("pageList2[pleft].x===",pageList2[pleft].x)
              --   ----print("leftmax===",leftMax)
                bigautof = true
                ----print("autoleft====")
                dir = "left"
              elseif right > rightMax then
                bigautof = true
                dir = "right"
                ----print("autoright====")
              else
                  if left < _W*2-scrOrgx then
                    bigBackRight = true
                    ----print("right00000=========")
                  end

                  if right > scrOrgx then
                    bigBackLeft = true
                    ----print("left00000=========")
                  end
                  if top > scrOrgy then
                   -- ----print("top===",top)
                    bigBackUp = true
                   -- ----print("up11111111=========")
                  end

                  if top < scrOrgy - (pageList2[pleft].contentHeight - 2*_H) then
                    bigBackDown  = true
                   ----up----print("down11111111=========")
                  end
              end
            end
           
            bigMovef = false
            ----print("bigautof ===== ",bigautof)
            if bigautof == false then

              if bigBackLeft == false and bigBackRight == false and bigBackDown == false and bigBackUp == false then
              -- ----print("float========")
                Runtime:addEventListener( "enterFrame", bigPageFloatFn)
              else
             -- ----print("back=========")
               Runtime:addEventListener( "enterFrame", bigPageBackFn)
             end
            else
              bigBackDown = false
              bigBackUp = false
              bigBackRight = false
              bigBackLeft = false
              bigMovef = false
              ----print("autoooooooooo====")
              Runtime:addEventListener( "enterFrame", bigAutoFlipFn)
            end
          end
        end
        end
        --  mutitouchPos ={}
       end
      return true
    end  
  else
    ---直向翻頁
     local x = event.xStart
    local y = event.yStart
   
  if x > flipArea[1] and x < flipArea[3] and y > flipArea[2] and y < flipArea[4]  then
    ----print("clickaaaaaaa")
      local ph = event.phase
      local tmp = {}
     ------print("tarpage.no====",tarpage.no)
      if ph == "began" then
        ----print("numTouches22222==",numTouches)
        numTouches = numTouches + 1
        table.insert(idList,event.id)
        table.insert(tmp,event.xStart)
        table.insert(tmp,event.yStart)
        table.insert(mutitouchPos,tmp)       
          -- local textnum2 = display.newText(tostring(numTouches ) ,200,300,native.systemFont,80)
          -- textnum2:setFillColor( 1,0,0 )
          -- sceneGroup:insert(textnum2)
        bounds = pageList2[p1].contentBounds 
        if numTouches == 1 then
          mf = false
           mutitouchf = false
           oldx = event.xStart
           if scalef == false then
            --if flipType == 1 then
              ----print("autof===",autof)
              if turnf == false and autof == false then
              --  ----print("turnf===true111111")
               turnf = true
              
               -- pageList2[p1]= pageList2[p1]  
              end
            -- else
            --  if turnf == false and autof == false then
            --    ------print("turnf===true22222")
            --    turnf = true
            --  end
            --end
            ----print("turnf=-===",turnf)
          else
           -- ----print("77777777")
            turnf = false
            if  bigautof == false then
               
                Runtime:removeEventListener("enterFrame",bigPageFloatFn )
                 Runtime:removeEventListener("enterFrame",bigPageBackFn)
                bigBackDown = false
                bigBackUp = false
                bigBackRight = false
                bigBackLeft = false
                bigMovef = false
        
                 starttime = event.time
                zoomdx = pageList2[p1].x - event.x
                zoomdy = pageList2[p1].y - event.y
            end
          end          
        end
        ---多點觸控
        if numTouches > 1 and numTouches <=3 and autof == false then
          ------print("mutitouchf == true------1")
          delaytime = system.getTimer( )
          mutitouchf =  true
          local sumx = 0
          local sumy = 0
          local num = #mutitouchPos
          for i =1,num do
            sumx = sumx + mutitouchPos[i][1]
            sumy = sumy + mutitouchPos[i][2]
          end
          centerx = sumx/num
          centery = sumy/num
          touchDistance = 0
          for i = 1,num do
            local x = mutitouchPos[i][1]
            local y = mutitouchPos[i][2]
            x = centerx - x
            y = centery - y
            touchDistance = touchDistance + math.sqrt( x*x + y*y )
          end
          oldDistance = touchDistance
          bounds = pageList2[p1].contentBounds 
          if scalef == false then
            scalef = true
            scaleing = true
            onoff.alpha = 0.5
            oldflipType = flipType
               nowrate = 1
               if oldflipType == 1 then
                  
                  arrangPageFn2()
                   flipType = 0
               end
                 -- mutirate = oldrate
          end
          targetrate = pageList2[p1].rate
          mutirate = nowrate

          if centerx >= bounds.xMin and centerx <= bounds.xMax and centery >= bounds.yMin and centery <= bounds.yMax then
             local dw = _W*2-2*scrOrgx - pageList2[p1].originpagewidth
            --local orgdx = centerx - scrOrgx - dw/2
            local newanchx = (centerx - pageList2[p1].x)/pageList2[p1].contentWidth
            local newanchy = (centery - pageList2[p1].y+pageList2[p1].contentHeight*0.5)/pageList2[p1].contentHeight
            pageList2[p1].x = pageList2[p1].x - (pageList2[p1].anchorX-newanchx)*pageList2[p1].contentWidth
            pageList2[p1].y = pageList2[p1].y - (pageList2[p1].anchorY-newanchy)*pageList2[p1].contentHeight

            pageList2[p1].anchorX = newanchx
            pageList2[p1].anchorY = newanchy
            
            
          end

         -- pageList2[p1].anchorX = 0.5
           
         -- Runtime:addEventListener("enterFrame",mutimoveFn)
        end

      elseif ph == "moved" then
        local tmp = {}
        table.insert(tmp,event.x)
        table.insert(tmp,event.y)
        local pos = wetools.getpos(event.id,idList)
        mutitouchPos[pos] = tmp
        --print("numTouches===",numTouches)
        if numTouches > 1 and numTouches <= 3 and autof == false then        
            ---多點縮放         
            local sumx = 0
            local sumy = 0
            local num = #mutitouchPos
            for i =1,num do
              sumx = sumx + mutitouchPos[i][1]
              sumy = sumy + mutitouchPos[i][2]
            end

            local newcenterx = sumx/num
            local newcentery = sumy/num
            touchDistance = 0
            for i = 1,num do
               local x = mutitouchPos[i][1]
               local y = mutitouchPos[i][2]
               x = newcenterx - x
              y = newcentery - y
              touchDistance = touchDistance + math.sqrt( x*x + y*y ) ----新的距離
            end
           
           
            --if math.abs(touchDistance-oldDistance)>=5 then
            local touchrate = touchDistance/oldDistance
           
            mutirate = mutirate*touchrate
           
            if math.abs(mutirate - nowrate) > 0.001 then
              nowrate = mutirate

              -- if nowrate > 1 then
              --   if scalef == false then
              --     scalef = true
              --     scaleing = true
              --   end
              -- end

              if nowrate > maxrate then
                nowrate = maxrate
                mutirate = maxrate
              elseif nowrate < 1 then
                nowrate = 1
                mutirate = nowrate
              end
              mutiZoom()
            else
              mutirate = nowrate
            end
            
            
         
            oldDistance = touchDistance
            --delaytime  = system.getTimer( )
          --end
        end
        
        if mutitouchf == false then
                local vx = event.x - event.xStart 
                if math.abs(vx) > 20  then
                    mf = true
                    if scalef == false then
                      --print("turnf===",turnf)
                      if turnf == true then
            
                        local ddx = event.x - oldx
                        oldx = event.x
                        ----print("checkdir====",checkdir)
                        if checkdir == true then
                          --第一次移動             
                          if ddx > 0 then
                            dir = "right"
                            ----print("p1===",p1)
                            if p1 > 1 then
                              p1 = p1 - 1
                            if p1 == 1 then
                              if flipType == 1 then
                                oldflipType = 1
                                flipType = 0
                                pageList2[1].anchorX = 0
                                pageList2[1].x = scrOrgx - pageList2[1].contentWidth
                                pageList2[1].path.x3 = 0
                                pageList2[1].path.x4 = 0
                                pageList2[1].path.y3 = 0
                                pageList2[1].path.y4 = 0
                                mask:toBack( )
                                --arrangPageFn2()
                              end
                            --else
                              -- if oldflipType == 1 then
                              --   flipType = 1
                              -- end
                            end
                            if flipType == 1 then
                              pageList2[p1]:toFront( )
                            end
                              

                              gof = true
                              checkdir = false
                            else
                              checkdir = true
                              gof = false
                            end
                          end
                          if ddx < 0 then
                            dir = "left"
                            if p1 < maxPage then
                              gof = true
                              checkdir = false
                              if p1 == maxPage - 1 then
                                if flipType == 1 then
                                  oldflipType = 1
                                  flipType = 0
                                  pageList2[maxPage].anchorX = 0
                                  pageList2[maxPage].x = _W*2 - scrOrgx 
                                  pageList2[maxPage].path.x3 = 0
                                  pageList2[maxPage].path.x4 = 0
                                  pageList2[maxPage].path.y3 = 0
                                  pageList2[maxPage].path.y4 = 0
                                  mask:toBack( )
                                  --arrangPageFn2()
                                end

                              end

                            else
                              checkdir = true
                              gof = false
                           end
                          end
                        else
                          if ddx > 0 then
                            dir = "right"
                          end
                          if ddx < 0 then
                            dir = "left"
                          end
                        end
                       
                        if flipType == 0 then
                          if ddx == 0 then
                            gof = false
                          else 
                            ------print("pleft===",pleft)
                            if dir == "left" then
                              if p1 < maxPage then
                               gof = true
                              else
                               gof = false
                              end
                            
                              
                            end
                          end
                        end
                        ----print("gof2===",gof)
                        if gof == true then
                          if flipType == 1 then
                            local dx = event.x - pageList2[p1].x + 20 
                            ang = math.acos(dx/pageList2[p1].contentWidth)*0.1
                            ------print("pagewidth==",pagewidth)
                            local x4 = dx - pageList2[p1].contentWidth
                              ------print("x4==",x4)
                              local pos1 = wetools.getpos2(mask,pageList)
                              
                              local pos = wetools.getpos2( pageList2[p1],pageList)
                              if pos1 < pos-1 then
                                
                                ----print("mask.numchildren==",mask.numChildren)
                                --mask:toFront()
                                pageList2[p1]:toFront()
                              end

                              
                              if mask.x ~= pageList2[p1].x then
                                mask.x = pageList2[p1].x
                              end
                              ----print("mask.contentWidth=",mask.contentWidth)
                              ----print("pageList2.conternwidth=",pageList2[p1].contentWidth)
                            if x4 <=0 then
                                  
                                  ----print("-pagewidth*rate==",-originpagewidth)
                                if x4 < -pagewidth  then
                                  pageList2[p1].path.x4 = -pageList2[p1].contentWidth
                                  pageList2[p1].path.x3 = -pageList2[p1].contentWidth
                                  pageList2[p1].path.y4 = 0
                                  pageList2[p1].path.y3 = 0
                                  
                                  mask.path.x4 = -mask.orgx
                                  mask.path.x3 = -mask.orgx
                                  mask.path.y3 = 0
                                  if mask.alpha == 0 then mask.alpha = 1 end
                                  turnf = false
                                  checkdir = true
                                  ----print("canautof1==",canautof)
                                  canautof = false
                                  ----print("canautof2==",canautof)
                                  mask:toBack( )

                                  if dir == "left" then
                                    if p1 < maxPage then
                                      p1 = p1 + 1
                                    end
                                    
                                    local dx = 0
                                    dx = smallPageGroup[p1*2-1].x
                                    if dx < scrOrgx + 20 then
                                         backRight = true
                                         Runtime:addEventListener( "enterFrame", smallPageAutoMoveFn)
                                    end
                                    if dx > _W*2 - scrOrgx - 20 - smallPageGroup[p1*2-1].contentWidth*0.5 then
                                        backLeft  = true
                                        Runtime:addEventListener( "enterFrame", smallPageAutoMoveFn)
                                    end

                                    local nextpage_path = system.pathForFile( choice_bookcode.."/"..p1..".png", baseDir )
                                    local mode = lfs.attributes(nextpage_path, "mode")
                                    if mode == nil then
                                      loadpage(p1,true)
                                    else
                                      arrangPageFn()
                                    end

                                   
                                  end

                                  -- ----print("p1===",p1)
                                  -- ----print("bbbbbbbb")
                                else
                                  ----print("3836")
                                   canautof = true
                                  pageList2[p1].path.x4 = x4             
                                  pageList2[p1].path.y4 = -pageList2[p1].contentWidth*math.sin(ang)           
                                  pageList2[p1].path.x3 =  x4
                                  pageList2[p1].path.y3 = -pageList2[p1].contentWidth*math.sin(ang)  
                                  
                                  local mx4 = x4  
                                  local mratex = mask.orgx/pageList2[p1].width
                                  local mratey = mask.orgy/pageList2[p1].height 

                                   -- --print("mask.contentWidth==",mask.contentWidth)
                                   -- --print("mask.contentHeight==",mask.contentHeight)

                                   --  --print("pageList2[p1].contentWidth==",pageList2[p1].contentWidth)
                                   -- --print("pageList2[p1].contentHeight==",pageList2[p1].contentHeight)
                                 
                                  if mask.contentWidth > pageList2[p1].contentWidth then
                                      mratex = mratex*1.1
                                    end 

                                    if mx4*mratex < -mask.orgx then
                                      mask.path.x3 = -mask.orgx
                                      mask.path.x4 = -mask.orgx
                                    else
                                      mask.path.x4 = mx4*mratex
                                      mask.path.x3 = mx4*mratex
                                    end
                                    
                                   -- --print("pageList2[p1].path.x4=="..pageList2[p1].path.x4)
                                    mask.path.y3 = -mratey*pageList2[p1].pagewidth*math.sin(ang)/4
                                    mask.path.y2 = -mratey*pageList2[p1].pagewidth*math.sin(ang)/4
                                  
                                  --print("ccc")
                                end
                          
                            else
                              --print("aaaaaaaaaa")
                              pageList2[p1].path.x4 = 0
                              pageList2[p1].path.x3 = 0
                              pageList2[p1].path.y4 = 0
                              pageList2[p1].path.y3 = 0
                              mask.path.x4 = 0
                              mask.path.x3 = 0
                              mask.path.y3 = 0
                              
                              if mask.alpha == 0 then mask.alpha = 1 end
                              if dir == "right" then
                                  local dx = 0
                                  dx = smallPageGroup[p1*2-1].x
                                  if dx < scrOrgx + 20 then
                                       backRight = true
                                       Runtime:addEventListener( "enterFrame", smallPageAutoMoveFn)
                                  end
                                  if dx > _W*2 - scrOrgx - 20 - smallPageGroup[p1*2-1].contentWidth*0.5 then
                                      backLeft  = true
                                      Runtime:addEventListener( "enterFrame", smallPageAutoMoveFn)
                                  end

                                
                                  local nextpage_path = system.pathForFile( choice_bookcode.."/"..p1..".png", baseDir )
                                  local mode = lfs.attributes(nextpage_path, "mode")
                                  if mode == nil then
                                    loadpage(p1,true)
                                  else
                                    arrangPageFn()
                                  end
                              end
                              canautof = false
                              turnf = false
                              
                              checkdir = true
                              mask:toBack( )
                            end
                          else
                            ----不翻頁
                            ----print("3885")
                            canautof = true
                            
                            for i = 1,pageList.numChildren do
                               pageList[i].x = pageList[i].x + ddx
                               
                               if pageList[i].no == p1+1 then
                                ----print(pageList[i].x)
                               end
                            end
                          end
                        end
                      end
                    else
                      ---- 直...放大時翻頁 
                      ---放大時單點滑動
                      if bigautof == false  then
                          bigMovef = true
                          --if pleft ==1 then
                            pageList2[p1].x = event.x + zoomdx
                           pageList2[p1].y = event.y + zoomdy
                           
                           ----print("bookmarklist[1].no==",bookmarkList[1].no)
                           ----print("pos==",pos)
                          
                         
                      end
                    end
          end
      end
    elseif ph == "ended" or ph == "canceled" then
      
        -- ----print("ph =======",ph)
      if numTouches > 1 then
           
            local pos = 0

            idList,pos = wetools.deleteone(event.id,idList)
            if pos > 0 then
             table.remove(mutitouchPos,pos)
            end
           -- ----print("ddddddddddddd")
            
            ------print("numTouches3======",numTouches)
      else
          if mutitouchf == true then

            -- Runtime:removeEventListener("enterFrame",mutimoveFn)
            mutitouchf = false
           
            pageList2[p1].x = pageList2[p1].x - pageList2[p1].anchorX*pageList2[p1].contentWidth
            pageList2[p1].y = pageList2[p1].y - (pageList2[p1].anchorY-0.5)*pageList2[p1].contentHeight
            pageList2[p1].anchorX = 0
            pageList2[p1].anchorY = 0.5

            if nowrate <= 1.05 then
              mutimovefh = true
              --mutimovefv = true
              
              Runtime:addEventListener("enterFrame",mutimoveFn)
             
            end
          end
            --mutitouchf = false
            mutitouchPos ={}
            idList = {}
            numTouches = 0
            ------print("cccccccc") 
      end
      ------print("numTouches前===",numTouches)
      numTouches = numTouches - 1
      ----print("numTouches後===",numTouches)
      if  numTouches < 0 then 
        numTouches = 0
      end
    if mf == true  then
      if scalef == false and turnf == true then
        if mutitouchf == false then      
          ----直向
          turnf = false

         -- if pageList2[p1].path.x4 < 0 and pageList2[p1].path.x4 > -pagewidth then
          ----print("canautof===",canautof)
          if canautof == true then
            --tarpage = tarpage
            if dir == "left" then
                if flipType == 1 then
                  autovx = -220
                else
                  autovx = -140 
                end   
                --autovx = -100
            else
              -- if flipType == 1 then
              --   autovx = 220
              -- else
                autovx = 140 
              -- end   
              --autovx = 100
            end
            

            ----print("autoturnfn2222222")
            

            local s = math.abs(event.x - event.xStart)
            -- local v = s/(event.time/1000)
            if s > 20 then
              autof = true
              print("v___v")
              Runtime:addEventListener("enterFrame",autoturnfn )
            end
            --Runtime:addEventListener("enterFrame",autoturnfn )
          else 
            turnf = true
          end  
        end
      else
        ----放大時翻頁--- 直
        if mutitouchf == false and bigMovef == true and bigautof == false then 
           bigVx = event.x - event.xStart
           bigVx = bigVx/((event.time - starttime)*0.05)
           bigVy = event.y - event.yStart
           bigVy = bigVy/((event.time - starttime)*0.05)  
          ----print("141141414")       
            turnf = false 
            local leftMax = _W*2 -scrOrgx - (_W*2-2*scrOrgx)*0.33 ---往左最大坐標
            local rightMax = scrOrgx + (_W*2-2*scrOrgx)*0.33  ----往右最大坐標
            local left  = pageList2[p1].x + pageList2[p1].contentWidth--pageList2[1].width
            local top = pageList2[p1].y - pageList2[p1].contentHeight*0.5--pageList2[1].height*0.5

            if p1 ==1 then
              ---只測往左
              if left < leftMax then
                ----放大換頁
                ------print("changepage")
                bigautof = true
                dir = "left"
              else
                if left < _W*2-scrOrgx then
                  bigBackRight = true
                --  ----print("right11111111=========")
                end

                if left > _W*2-2*scrOrgx + pageList2[p1].contentWidth*0.67 then--pageList2[1].width*0.33 then
                  bigBackLeft = true
                 -- ----print("left11111111=========")
                end

                if top > scrOrgy then
                 -- ----print("top===",top)
                  bigBackUp = true
                 -- ----print("up11111111=========")
                end

                if top < scrOrgy - (pageList2[p1].contentHeight - 2*_H) then
                  bigBackDown  = true
                --  ----print("down11111111=========")
                end
                
              end
            elseif p1== maxPage then
              local rightMax = scrOrgx + (_W*2-2*scrOrgx)*0.33  ----往右最大坐標

             -- local left  = pageList2[pleft].x + contentWidth--pageList2[1].width
              --local right  = pageList2[maxPage].x 
                local right  = pageList2[maxPage].x 
                -- --print("right==",right)
                --  --print("rightmax==",rightMax)
                if right > rightMax then
                   bigautof = true
                   dir = "right"
                   ----print("right")
                else  

                  if right > scrOrgx then
                    bigBackLeft = true
                  end
                  if right < scrOrgx - (_W*2-2*scrOrgx)*0.67 then
                    bigBackRight = true
                  end

                  if top > scrOrgy then
                   -- ----print("top===",top)
                    bigBackUp = true
                   -- ----print("up11111111=========")
                  end

                  if top < scrOrgy - (pageList2[p1].contentHeight - 2*_H) then
                    bigBackDown  = true
                   ----up----print("down11111111=========")
                  end

                end
             
            else
              ---雙頁
              --print("p1===",p1)
              local right  = pageList2[p1].x 

              --print("right==",right)
                 --print("rightmax==",rightMax)
              if left < leftMax then
              --  ----print("pageList2[pleft].x===",pageList2[pleft].x)
              --   ----print("leftmax===",leftMax)
                bigautof = true
                ----print("autoleft====")
                dir = "left"
              elseif right > rightMax then
                bigautof = true
                dir = "right"
                ----print("autoright====")
              else
                  if left < _W*2-scrOrgx then
                    bigBackRight = true
                    ----print("right00000=========")
                  end

                  if right > scrOrgx then
                    bigBackLeft = true
                    ----print("left00000=========")
                  end


                  if top > scrOrgy then
                   -- ----print("top===",top)
                    bigBackUp = true
                   -- ----print("up11111111=========")
                  end

                  if top < scrOrgy - (pageList2[p1].contentHeight - 2*_H) then
                    bigBackDown  = true
                   ----up----print("down11111111=========")
                  end
              end
            end
           
            bigMovef = false
            ----print("bigautof ===== ",bigautof)
            if bigautof == false then

              if bigBackLeft == false and bigBackRight == false and bigBackDown == false and bigBackUp == false then
              -- ----print("float========")
                Runtime:addEventListener( "enterFrame", bigPageFloatFn)
              else
             -- ----print("back=========")
               Runtime:addEventListener( "enterFrame", bigPageBackFn)
             end
            else
              bigBackDown = false
              bigBackUp = false
              bigBackRight = false
              bigBackLeft = false
              bigMovef = false
              --print("autoooooooooo====")
              Runtime:addEventListener( "enterFrame", bigAutoFlipFn)
            end
          end
      end
      end
  --  ----print("ccccccccc")
      end

    return true
  end
   
  end
  end
end

local function htov()
    
    rotate_Dir = "v"
    if pleft == 1 then
      p1 = 1
    else
      p1 = pleft -1
    end
    
    -- for i = 1,sceneGroup.numChildren do
    --   sceneGroup:remove(1)
    --   sceneGroup[1] = nil
    -- end
  
    setupf = true 
    --print("replace.....hhhvvvv")
    ------print("setupFirst==",setupFirst)
    setupFirst = true
    -- Runtime:removeEventListener("enterFrame",closeOptionFn)
    -- Runtime:removeEventListener("touch",turnPagefn)
    -- timer.performWithDelay( 500, replace )
    replace()
       
end

local function vtoh()
    
    rotate_Dir = "h"
     if p1 == 1 then
      pleft =1
     else
      if p1 % 2 == 0  then
        pleft = p1 + 1
      else
        pleft = p1
      end
     end
      pright = pleft -1
    
     if pleft > 1 then
      p1 = pleft - 1
     else
      p1 = 1
     end
     
    -- for i = 1,sceneGroup.numChildren do
    --   sceneGroup:remove(1)
    --   sceneGroup[1] = nil
    -- end

    setupf = true 
    --print("replace.....vvvvhhhh")
    ------print("setupFirst==",setupFirst)
    setupFirst = true
    -- Runtime:removeEventListener("enterFrame",closeOptionFn)
    -- Runtime:removeEventListener("touch",turnPagefn)
    
    replace()

end

local function onOrientationChange( event )
     currentOrientation = event.type
     g_curr_Dir = event.type
     if g_curr_Dir == "faceUp" or g_curr_Dir == "faceDown" then
      g_curr_Dir = g_old_Dir
      currentOrientation = oldorientation
    end
     
   if currentOrientation == "portrait" or currentOrientation == "portraitUpsideDown" then
     if oldorientation == "landscapeLeft" or oldorientation == "landscapeRight" then   
       
       oldorientation = g_curr_Dir
       g_old_Dir = g_curr_Dir
       htov()
     end
   end

   if currentOrientation == "landscapeLeft" or currentOrientation == "landscapeRight" then
     if oldorientation == "portrait" or oldorientation == "portraitUpsideDown" then   
       
       oldorientation = g_curr_Dir
       g_old_Dir = g_curr_Dir
       vtoh()
     end
   end

   -- if currentOrientation == "faceUp" or currentOrientation == "faceDown" then
   --    currentOrientation = oldorientation
   -- end

end



local function contentTextFn(event)
  local ph = event.phase
  local etar = event.target
  if ph == "ended" then
    setContentText(etar)
    if bookmarkscroll.x == bookmarkscroll.orgx then
      bookmarkscroll.x = -10000
    end 
    contscroll.x = contscroll.orgx
  end

end

local function bookmarkTextFn(event)
  local ph = event.phase
  local etar = event.target
  if ph == "ended" then
    setbookmarkText(etar) 
     if contscroll.x == contscroll.orgx then
      contscroll.x = -10000
    end 
    bookmarkscroll.x = bookmarkscroll.orgx
  end
end

local function fliponFn(event)
  
  if flipType == 0 and scalef == false then
    local ph = event.phase
    local etar = event.target
    if ph == "began" then

      --etar:setFillColor( 1,0,0 )
    elseif ph == "ended" or ph == "canceled" then
      --etar:setFillColor( 1,0,1 )
      circel.x = etar.x
      flipType = 1
      --if currentOrientation == "landscapeLeft" or currentOrientation == "landscapeRight" then
        arrangPageFn()
      --else
       -- arrangPageFn2()
      --end
      
    end
  end
  return true
end

local function flipoffFn(event)
  if flipType == 1 and scalef == false then
    local ph = event.phase
    local etar = event.target
    if ph == "began" then

      --etar:setFillColor( 1,0,0 )
    elseif ph == "ended" or ph == "canceled" then
      --etar:setFillColor( 1,0,1 )
      circel.x = etar.x
      flipType = 0
     
        arrangPageFn2()
      
      ----print("44444444444")
    end
  end
  return true

end

local function setOption(ta)
  ta:setFillColor( 1,1,0 )
  if optionItemGroup.numChildren >0 then
    optionItemGroup.y = 0
    if flipType == 1 then
     circel.x = optionItemGroup[3].x
   else
     circel.x = optionItemGroup[4].x
   end
   flipArea[1] =  scrOrgx + optionItemGroup[1].width + 1
  else
    local boxUp = optionGroup[1]
    local contbg = display.newRect( 0, 0, 300, _H*2-(optionGroup[1].height+optionGroup[2].height+statusbarHeight) )
   contbg.x = scrOrgx+contbg.width*0.5
   contbg.y = boxUp.y + (boxUp.height+contbg.height)*0.5 

  --contbg.alpha = 0.5
   contbg:setFillColor( 66/255,66/255,66/255 )

   local fliptext = display.newText( "Flip",0,0,native.systemFont,40)
   fliptext:setFillColor( 220/255,220/255,220/255 )
   fliptext.x = contbg.x
   fliptext.y = boxUp.y + (boxUp.height + fliptext.height)*0.5 + 20
   local ontext = display.newText( "On",0,0,native.systemFont,40)
   ontext:setFillColor( 1,1,0.5 )
   ontext.x = scrOrgx + ontext.width*0.5+50
   ontext.y = fliptext.y + ontext.height

   ontext:addEventListener( "touch", fliponFn )

   local offtext = display.newText( "Off",0,0,native.systemFont,40)
   offtext:setFillColor( 1,1,0.5 )
   offtext.x = scrOrgx + contbg.width -50-offtext.width*0.5
   offtext.y = fliptext.y + offtext.height

   offtext:addEventListener( "touch", flipoffFn )

   circel = display.newImage( path_image.."circel.png" ,true )
   if flipType == 1 then
     circel.x = ontext.x
   else
     circel.x = offtext.x
   end
   circel.y = ontext.y

   flipArea[1] =  scrOrgx + contbg.width + 1

   optionItemGroup:insert(contbg)
   optionItemGroup:insert(fliptext)
   optionItemGroup:insert(ontext)
   optionItemGroup:insert(offtext)
   optionItemGroup:insert(circel)
   sceneGroup:insert(optionItemGroup)
  end
end



local function contscrollListener(event)
  local ph = event.phase
  --print("scroll.ph==",ph)
  if ph == "moved" then
    chaptermove = true
    chapterBlock:setFillColor( 221/255 )
    chapterBlock.isVisible = false
    chapterBlock.isHitTestable = true
  elseif ph == "ended" then
    if chaptermove == true then
    else
      ----跳chapter
      chapterBlock:setFillColor( 221/255 )
      chapterBlock.isVisible = false
      chapterBlock.isHitTestable = true
      if chochapter >0 then
        contentGroup.y = -10000
        optionItemf = false
        flipArea[1] =  scrOrgx
        clickAreaL[3] = scrOrgx + clickWidth
        jumpchapter(chochapter)
        chochapter = 0
      end
    end

    chaptermove = false
  end
end




local function bookmarkscrollListener(event)
  local ph = event.phase
  --print("scrollbook.ph==",ph)
  if ph == "moved" then
    bookmarkmove = true
  elseif ph == "ended" then
     --print("bookmarkmove==",bookmarkmove)
    if bookmarkmove == true then
    else
      ----跳bookmark
      --print("bookmark.no==",chobookmark)
      if chobookmark >0 then
        jumpchapter(chobookmark)
        chobookmark = 0
      end
      if chobookmarkdel > 0 then
         bookmarkNumList = wetools.deleteone(chobookmarkdel,bookmarkNumList)
  
         local status = ""
         for i=1, #bookmarkNumList do
            status = status .. "," .. bookmarkNumList[i]
         end
         gProfile.updatebookmark( choice_bookcode, status )
         --for i = 1,bookmarkscroll.numChildren do
           
           ----print("bookscroll.num1=",bookmarkscroll.numChildren)
         --end
         display.remove( bookmarkscroll)
          bookmarkscroll = nil
         local totalhight_bookmark =  0
         local top = scrOrgy+statusbarHeight+optionBoxUp+contitemheight
          bookmarkscroll = widget.newScrollView
            {            
                left =scrOrgx,
                top =top,
       
                width = contwidth,
                height = contheight-contitemheight,
                
              
                rightPadding  =0,

                id = "bookmarkscroll",
                hideBackground  = true,
                horizontalScrollDisabled = true,
                verticalScrollDisabled = false,
                listener = bookmarkscrollListener,
            }
            bookmarkscroll.orgx = bookmarkscroll.x

         if #bookmarkNumList > 0 then

            for i = 1,#bookmarkNumList do
              --print("bookmarkNumList[i]==",bookmarkNumList[i])
              local marknum = display.newText("Page: "..bookmarkNumList[i],0,totalhight_bookmark,native.systemFont,40 )
              local del = display.newText( "Del",0,0,native.systemFont,40)
             
              --marknum:setFillColor( 1,0,0 )
              marknum.x =  marknum.width*0.5
              marknum.y = totalhight_bookmark + marknum.height*0.5
              del.x = contwidth - del.width*0.5-5
              del.y = marknum.y

              marknum.no = tonumber(  bookmarkNumList[i] )
              del.no = tonumber(  bookmarkNumList[i] )
              totalhight_bookmark = totalhight_bookmark + marknum.height + 20 + marknum.height*0.5
              --print("marknum.x==",marknum.x)
              --print("marknum.y==",marknum.y)
              marknum:addEventListener( "touch", gobookmarkFn )
              del:addEventListener( "touch", delbookmarkFn )
              --print("aaaaaaaa")
              --print("bookmarkscroll==",bookmarkscroll)
              bookmarkscroll:insert(marknum)
              bookmarkscroll:insert(del)
              --print("bbbbbb")
            end
            contentGroup:insert(bookmarkscroll)
         end
         ----print("bookscroll.num22=",bookmarkscroll.numChildren)

        chobookmarkdel = 0
      end
    end

    bookmarkmove = false
  end
end



local function chapterFn(event)
  local ph = event.phase
  local etar = event.target
  --print("ph==",ph)
  if ph == "began" then      
      if chapterBlock ~= nil then
        chapterBlock:setFillColor( 221/255 )
        chapterBlock.alpha = 0.85
        chapterBlock.isVisible = false
        chapterBlock.isHitTestable = true
      end
      chochapter = event.target.no
      chapterBlock = etar
      etar:setFillColor( 182/255)
      etar.alpha = 0.85
      etar.isVisible = true

  end
end


local function setContents(ta)
    --ta:setFillColor( 1,1,0 )
  if contentGroup.numChildren > 0 then
    contentGroup.y = 0
    contscroll.x = contscroll.orgx
    --bookmarkscroll.x = -10000
    flipArea[1] =  scrOrgx + contentGroup[1].width + 1
  else
    local boxUp = optionGroup[1]
    local contbg = display.newRect( 0, 0, contwidth, _H*2-(optionGroup[1].height+optionGroup[2].height+statusbarHeight)-2*scrOrgy )
   contbg.x = scrOrgx+contbg.width*0.5
   contbg.y = boxUp.y + (boxUp.height+contbg.height)*0.5
   contheight = contbg.height

   contbg.alpha = 0.85
   contbg:setFillColor( 221/255 )
   -- local contentBox = display.newRect( 0, 0, contwidth*0.5, contitemheight )
   -- contentBox:setFillColor( 0.5,0.5,0.8 )
   -- contentBox.x = scrOrgx+contentBox.width*0.5
   -- contentBox.y = boxUp.y + (boxUp.height+contentBox.height)*0.5
   -- local contentText = display.newText( "Contents",0,0,native.systemFont,20)
   -- contentText.x = contentBox.x
   -- contentText.y = contentBox.y
   -- contentText:addEventListener( "touch", contentTextFn )
   -- local bookmarkBox = display.newRect( 0, 0, contwidth*0.5, contitemheight )
   -- bookmarkBox:setFillColor( 0.8,0.5,0.5 )
   -- bookmarkBox.x = contentBox.x + (contentBox.width+bookmarkBox.width)*0.5
   -- bookmarkBox.y = contentBox.y
   -- local bookmarkText = display.newText("Bookmark",0,0,native.systemFont,20)
   -- bookmarkText.x = bookmarkBox.x
   -- bookmarkText.y = bookmarkBox.y
   -- bookmarkText:addEventListener( "touch", bookmarkTextFn)
  if contscroll == nil then
     flipArea[1] =  scrOrgx + contbg.width + 1
     local top = scrOrgy+statusbarHeight+optionBoxUp*optionrate
      contscroll = widget.newScrollView
        {            
            left = scrOrgx,
            top =top,
         
            width = contbg.width,
            height = contbg.height,
            
          
            buttomPadding  =0,
            --leftPadding  =0,
            id = "contscroll",
            hideBackground  = true,
            horizontalScrollDisabled = true,
            verticalScrollDisabled = false,
            listener = contscrollListener,
        }
      --print("scrOrgy==",scrOrgy)
      local totalhight =  20--statusbarHeight + scrOrgy*0.15
      --local totalhight_bookmark =  0-- statusbarHeight + scrOrgy*0.15
      local btext = ""
      local textheight = 300
      local fsize = 24
      --print("#chpaterList===",#chapterList)
      if #chapterList > 0 then
        for i = 1,#chapterList do
          local chapterbox = display.newRect( 0, 0, contwidth, 100 )
          chapterbox.x = contbg.x
          chapterbox:setFillColor( 221/255 )
          chapterbox.no = tonumber(chapterpageList[i])
          chapterbox.alpha = 0.85
          chapterbox.isVisible = false
          chapterbox.isHitTestable = true
          contscroll:insert(chapterbox)
          local chapter = display.newText("P "..chapterbox.no,0,totalhight,native.systemFontBold,fontSize)
          chapter.x =  chapter.width*0.5 + 20
          chapter.y = totalhight+2
          chapter:setFillColor( 89/255,85/255,86/255 )
          totalhight = totalhight + chapter.height+chapter.height*0.5
          contscroll:insert(chapter)
          btext = chapterList[i]
          --print("btext==",btext)
          local options = 
          {
                  --parent = groupObj,
              text =btext,     
              x = scrOrgx,
              y = totalhight,
              width = contwidth*0.9,            --required for multiline and alignment
              --height = textheight,           --required for multiline and alignment
              font = native.systemFont,   
              fontSize = fontSize,
              align = "left"          --new alignment field
          }


          local title = display.newText( options )
          title.x = title.width*0.5+20
          
          title.y = chapter.y + (title.height+chapter.height)*0.5 + 6
          title:setFillColor( 89/255,85/255,86/255 )
          --title:addEventListener( "touch", chapterFn )
          title.no = tonumber(chapterpageList[i])
          chapterbox:toBack( )
          --title:setFillColor( 1,0,0 )
          chapterbox:addEventListener( "touch", chapterFn )
          totalhight = totalhight + title.height + 20
        --title:setFillColor( 1,0,0 )
          local high = totalhight - chapter.y+chapter.height*0.5
          print("(i)high==",high)
          if high > 160 then
            high = high + 10
            chapterbox.y = (title.y + chapter.y)*0.5+12
          else
            chapterbox.y = (title.y + chapter.y)*0.5
          end
          chapterbox.height =  high--chapter.height + title.contentHeight + 20
          contscroll:insert(title)
        end
    end
    contscroll.orgx = contscroll.x

    --print("contscroll.x==",contscroll.x)
   end
   contentGroup:insert(contbg)
   contentGroup:insert(contscroll)
   sceneGroup:insert(contentGroup)
 end

end

local function changeArea()
    flipArea[1] = scrOrgx 

    flipArea[2] =  scrOrgy + statusbarHeight ----up
  
    flipArea[4] =  -scrOrgy + _H*2 --down

    clickAreaL[2] = scrOrgy +statusbarHeight
   
    clickAreaL[4] = -scrOrgy + _H*2

    clickAreaR[2] = scrOrgy +statusbarHeight
   
    clickAreaR[4] = -scrOrgy + _H*2
end
local function openOption()
  --print("optionoption..........")
  for i = 1,optionGroup.numChildren do
      transition.to( optionGroup[i], { time=300, y=optionGroup[i].lasty} )
    end
    transition.to(smallPageGroup,{time = 300,y = smallPageGroup.lasty})
    optionf = true
    flipArea[2] =  scrOrgy + optionBoxUp + statusbarHeight----up
  
    flipArea[4] =  -scrOrgy + _H*2 - optionBoxDown --down

    clickAreaL[2] = scrOrgy + optionBoxUp + statusbarHeight
   
    clickAreaL[4] = -scrOrgy + _H*2 - optionBoxDown

    clickAreaR[2] = scrOrgy + optionBoxUp + statusbarHeight
   
    clickAreaR[4] = -scrOrgy + _H*2 - optionBoxDown
    ----print("flipArea[2]==========",flipArea[2])
end

local function closeOption()
  --print("closeoption..........")
  --print("optionGroup.num==",optionGroup.numChildren)
  if optionGroup ~= nil then
    for i = 1,optionGroup.numChildren do
        transition.to( optionGroup[i], { time=300, y=optionGroup[i].orgy} )
    end
      transition.to(smallPageGroup,{time = 300,y = smallPageGroup.orgy})
      optionf = false
      timer.performWithDelay( 300, changeArea )
      

      if optionItemGroup.numChildren > 0 then
        if optionItemGroup.y == 0 then
          option:setFillColor( 1,1,1 )
          optionItemGroup.y = -10000
        end
      end
      if contentGroup.numChildren > 0 then
        if contentGroup.y == 0 then
          contents:setFillColor( 1,1,1 )
          contentGroup.y = -10000
        end
      end
  end
end

function closeOptionFn(event)
  local ot =  system.getTimer( ) -setupt 
  ----print("ot===",ot)
  --local contents = display.newText( tostring(ot),200,300,native.systemFont,80)
  if ot > 1500 then
    ----print("111111111111")
    closeOption()
    setupFirst = false
  --  --print("mmmmmmmmmmmmmmm", last_composer, curr_composer)
    if last_composer ~= nil and last_composer ~= curr_composer then
      -- --print("yyyyyyyyyyyyyyyyyyyyy", last_composer, curr_composer)
        composer.removeScene(last_composer) -- call view_b destory function
        last_composer = curr_composer
        ----composer.removeScene("bookshelf")
     end

    Runtime:removeEventListener("enterFrame",closeOptionFn)
    
  end

end

local function boxUpFn(event)
  if exitf == false then
      local ph = event.phase
      if ph == "ended" or ph == "canceled" then
        if setupFirst == true then
          setupFirst = false
          Runtime:removeEventListener("enterFrame",closeOptionFn)
        end
        
        optionItemf = false
        ----print("3333")
        flipArea[1] =  scrOrgx
        clickAreaL[3] = scrOrgx + clickWidth
        closeOption()
      end
  end
end

-- local function exit(event)
--   print("exitttttttt")
--   local ph = event.phase
--   if ph == "ended" then
--     optionItemf = false
--     exitf = false
--       local lastpage_path = system.pathForFile( choice_bookcode.."/lastpage.txt", baseDir )
--       local fh, errStr = io.open( lastpage_path, "w" )
      
--       if fh then        
--           if currentOrientation == "landscapeLeft" or currentOrientation == "landscapeRight" then
--             if pleft >  maxPage then
--               fh:write( maxPage )
--             else
--               fh:write( pleft )
--             end         
--           else
--             fh:write( p1 )
--           end
--           io.close( fh )    
--       end

--       if last_composer ~= nil and last_composer ~= curr_composer then

--           composer.removeScene(last_composer) -- call view_b destory function
--           last_composer = curr_composer
--           ----composer.removeScene("bookshelf")
--        end
--         gNaviBar.NaviBarShow(true)
--         gOptnBar.OptnBarShow(true)
--         gFootBar.FootBarShow(true)
--       if currentOrientation == "landscapeLeft" or currentOrientation == "landscapeRight" then
          
--         composer.gotoScene("searchresult_h")
--       else
           
--         composer.gotoScene("searchresult")
--       end
--   end
--   return true
-- end

-- local function notexit (event)
--   local ph = event.phase
--   if ph == "ended" then
--     optionItemf = false
--     exitf = false
--     for i=1,noticeGroup.numChildren do
--       display.remove( noticeGroup[1] )
--       noticeGroup[1] = nil
--     end
--   end
--   return true
-- end


    -------------------------------------------------------------
    ---- 取消
    -------------------------------------------------------------
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
            
            label = "Cancel",
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
    
    -----------------------------------------------------------
    -- 確認
    -----------------------------------------------------------
    local function Button_Yes(top)
        -- button event
        local justPressed = function(event)
            if event.phase == "ended" then
                optionItemf = false
                exitf = false
                  local lastpage_path = system.pathForFile( choice_bookcode.."/lastpage.txt", baseDir )
                  local fh, errStr = io.open( lastpage_path, "w" )
                  
                  if fh then        
                      if currentOrientation == "landscapeLeft" or currentOrientation == "landscapeRight" then
                        if pleft >  maxPage then
                          fh:write( maxPage )
                        else
                          fh:write( pleft )
                        end         
                      else
                        fh:write( p1 )
                      end
                      io.close( fh )    
                  end
                  network.cancel( requestId )
                  if last_composer ~= nil and last_composer ~= curr_composer then

                      composer.removeScene(last_composer) -- call view_b destory function
                      last_composer = curr_composer
                      ----composer.removeScene("bookshelf")
                   end
                    gNaviBar.NaviBarShow(true)
                    gOptnBar.OptnBarShow(true)
                    gFootBar.FootBarShow(true)
                    network.cancel( requestId ) 
                  if currentOrientation == "landscapeLeft" or currentOrientation == "landscapeRight" then
                      
                    composer.gotoScene("searchresult_h")
                  else
                       
                    composer.gotoScene("searchresult")
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
        button.name = "Btn_LogoutConfirm"
        --BlockGroup:insert(button)
        return button
     end
    


function arrang_online ()
  -- local text = display.newText( "hpage....",200,200,native.systemFontBold,50 )
  -- text:setFillColor( 1,0,0 )
  if exitf == false then
      optionItemf = true
      local bg = display.newRect( _W, _H, _W*2-scrOrgx*2, _H*2-scrOrgy*2 )
      bg:setFillColor( 0 )
      bg.alpha = 0.7
      exitf = true
      local noticetext = display.newText( "Would you like to close the book ?" ,0,0,native.systemFontBold,40)
      noticetext:setFillColor( 1 )
      noticetext.x = _W
      noticetext.y = _H - 50
      local yestext = Button_Yes(noticetext.y+100)
      local notext  = Button_No(noticetext.y+100)
      noticeGroup:insert(bg)
      noticeGroup:insert(noticetext)
      noticeGroup:insert(yestext)
      noticeGroup:insert(notext)
      sceneGroup:insert(noticeGroup)
  end
end

local function library_onlineFn(event)
  local ph = event.phase
  local etar = event.target
  -- local text = display.newText( "hpage_online....",200,200,native.systemFontBold,50 )
  --               text:setFillColor( 1,0,0 )
  if ph == "began" then
    --etar:setFillColor( 1,0,0 )
    -- optionBtnBase.x = etar.x
    -- optionBtnBase.y = etar.y
    -- optionBtnBase.width = etar.width
  elseif ph == "ended" then
    --etar:setFillColor( 1,1,1 )
    -- if currentOrientation == "landscapeLeft" or currentOrientation == "landscapeRight" then
    --   if pleft > 1 then
    --     gProfile.updatelastpage( choice_bookcode, tostring(pleft-1) )
    --   else
    --     gProfile.updatelastpage( choice_bookcode, tostring(1) )
    --   end
    -- else
    --   gProfile.updatelastpage( choice_bookcode, tostring(p1) )
    -- end
    if exitf == false then
      optionItemf = true
      local bg = display.newRect( _W, _H, _W*2-scrOrgx*2, _H*2-scrOrgy*2 )
      bg:setFillColor( 0 )
      bg.alpha = 0.7
      exitf = true
      local noticetext = display.newText( "Would you like to close the book ?" ,0,0,native.systemFontBold,40)
      noticetext:setFillColor( 1 )
      noticetext.x = _W
      noticetext.y = _H - 50
      local yestext = Button_Yes(noticetext.y+100)
      local notext  = Button_No(noticetext.y+100)
      noticeGroup:insert(bg)
      noticeGroup:insert(noticetext)
      noticeGroup:insert(yestext)
      noticeGroup:insert(notext)
      sceneGroup:insert(noticeGroup)
    end
   
  end
  return true
end
local function contentsFn(event)
  if exitf == false then
      local ph = event.phase
      local etar = event.target
      if ph == "began" then
          -- optionBtnBase.x = etar.x
          -- optionBtnBase.y = etar.y
          -- optionBtnBase.width = etar.width
      elseif ph == "ended" then
        --optionBtnBase.x = -10000
        Runtime:removeEventListener("enterFrame",closeOptionFn)
        if  optionItemGroup.numChildren > 0 then
          if optionItemGroup.y == 0 then
            optionItemGroup.y = -10000
          end
        end
        if contentGroup.numChildren > 0 then
          if contentGroup.y == 0 then
              
              contentGroup.y = -10000
              optionItemf = false

              flipArea[1] =  scrOrgx
              clickAreaL[3] = scrOrgx + clickWidth

          else
            ----print("dddfddddddddddd")
            optionItemf = true
            setContents(etar)
          end
        else
          optionItemf = true
          setContents(etar) 
        end
        
      end
  end
  return true
end
  
local function optionFn(event)
  local ph = event.phase
  local etar = event.target
  if ph == "began" then
     etar:setFillColor( 1,0,0 )
  elseif ph == "ended" then
    --etar:setFillColor( 1,1,1 )
    contents:setFillColor( 1,1,1 )
    Runtime:removeEventListener("enterFrame",closeOptionFn)
    if contentGroup.numChildren > 0 then
      if contentGroup.y == 0 then
        contentGroup.y = -10000
      end
    end
    if  optionItemGroup.numChildren > 0 then
      if optionItemGroup.y == 0 then
        etar:setFillColor( 1,1,1 )
        optionItemGroup.y = -10000
        optionItemf = false
        flipArea[1] =  scrOrgx
        clickAreaL[3] = scrOrgx + clickWidth
      else
        optionItemf = true
        setOption(etar)
      end
    else
      optionItemf = true
      setOption(etar)
    end
    
  end
end

local function onoffFn(event)
  if exitf == false then
        local ph = event.phase
        local etar = event.target
        if ph == "began" then
            -- optionBtnBase.x = etar.x
            -- optionBtnBase.y = etar.y
            -- optionBtnBase.width = etar.contentWidth
        elseif ph == "ended" or ph == "canceled" then
          --optionBtnBase.x = -1000
          if oldflipType == 0 and scalef == false then
            gProfile.setSystemParameter("flipeffect", "on")
            etar:stopAtFrame ( 2 )
            oldflipType = 1
            if currentOrientation == "landscapeLeft" or currentOrientation == "landscapeRight" then
              if pleft == 1  then
                flipType = 0
                arrangPageFn2()
              elseif pleft >= maxPage then
                flipType = 0
                arrangPageFn2()
              else
                flipType = 1       
                arrangPageFn()
              end

            else
              if p1 == 1 or p1 == maxPage then
                flipType = 0
                arrangPageFn2()
              else
                flipType = 1       
                arrangPageFn()
              end
            end
            
          elseif oldflipType == 1 and scalef == false then
              gProfile.setSystemParameter("flipeffect", "off")
              etar:stopAtFrame ( 1 )
              oldflipType = 0
              flipType = 0  
              arrangPageFn2()
          end
        end
  end
  return true
end

local function goPageFn()
  for i = 1,#pageList2 do
    local page = pageList2[i]
    page:toBack( )
    page.x = _W
    page.y = pageH
    if i % 2 ==1 then

      page.anchorX = 0
      page.path.x1 = 0
      page.path.x2 = 0
      page.path.x3 = 0
      page.path.x4 = 0
    end

    if i % 2 == 0 then
      page.anchorX = 1
     
     
      --local tmp = page.width
      ------print("tmp===",tmp)
      page.path.x1 = originpagewidth*2
      page.path.x2 = originpagewidth*2
     -- ----print("page.path.x1====",page.path.x1)
    --  ----print("page.name===",page.name)
      page.x = _W
    
    end
  end
  mask.path.x1 = 0
  mask.path.x2 = 0
  mask.path.x3 = 0
  mask.path.x4 = 0
  if pleft > 1 then
      for i =1,pleft-1 do
        local tmp = pageList2[i]
        if i % 2 == 1 then
           --tmp.anchorX = 0
           tmp.path.x3 = -originpagewidth*2
           tmp.path.x4 = tmp.path.x3
           tmp.path.x1 = 0
           tmp.path.x2 = 0
         
        else

            tmp.path.x1 = 0
            tmp.path.x2 = 0
            tmp.path.x3 = 0
            tmp.path.x4 = 0
            if i == maxPage then
              mask.path.x3 = -originpagewidth*2
              mask.path.x4 = -originpagewidth*2
            end
        end
        
       -- textnum:setFillColor( 1,0,0 )
        tmp:toFront( )
      end
  
      mask:toBack( )

    else
      pageList2[1]:toFront( )
    end
end

local function backsmallpageFn(event)
  if backLeft == true then
    local dx = smallPageGroup[1].orgx - smallPageGroup[1].x
    dx = dx * 0.2
    --print("dx-left======",dx)
    ------print("dx===",dx)
    if math.abs(dx) > 1 then
      for i = 1,smallPageGroup.numChildren do
          smallPageGroup[i].x = smallPageGroup[i].x + dx
      end
    else
      local ddx = smallPageGroup[1].orgx - smallPageGroup[1].x
      for i = 1,smallPageGroup.numChildren do
          smallPageGroup[i].x = smallPageGroup[i].x + ddx
      end
      backLeft = false
      Runtime:removeEventListener("enterFrame",backsmallpageFn)
    end
  end

  if backRight == true then
    ------print(smallPageGroup[smallPageGroup.numChildren].x - scrOrgx)
    local dx = (_W*2 - scrOrgx - 20) - smallPageGroup[smallPageGroup.numChildren-1].x  - smallPageGroup[smallPageGroup.numChildren-1].contentWidth*0.5
    
    dx = dx * 0.2
   -- ----print("dx===",dx)
    if math.abs(dx) > 1 then
      for i = 1,smallPageGroup.numChildren do
          smallPageGroup[i].x = smallPageGroup[i].x + dx
      end
    else
      local ddx = (_W*2 - scrOrgx - 20) - smallPageGroup[smallPageGroup.numChildren-1].x - smallPageGroup[smallPageGroup.numChildren-1].contentWidth*0.5
      for i = 1,smallPageGroup.numChildren do
          smallPageGroup[i].x = smallPageGroup[i].x + ddx
      end
      backRight = false
      Runtime:removeEventListener("enterFrame",backsmallpageFn)
    end
  end

end

local function smallpageMoveFn(event)
   -- ----print("aaaaa")
    if smallpageVX > 0 then
        if smallPageGroup[1].x > smallPageGroup[1].orgx then
          backLeft = true

          Runtime:addEventListener("enterFrame",backsmallpageFn)
           Runtime:removeEventListener("enterFrame",smallpageMoveFn)
        else
          smallpageVX = smallpageVX*0.96 
          for i = 1,smallPageGroup.numChildren do
            smallPageGroup[i].x = smallPageGroup[i].x + smallpageVX*2 
          end
          if smallpageVX < 1 then
            smallpageVX = 0
            Runtime:removeEventListener("enterFrame",smallpageMoveFn)
          end
        end
    end
    if smallpageVX < 0 then
        -- ----print("1111==",smallPageGroup[smallPageGroup.numChildren].x)
        -- ----print("222==",_W*2 - scrOrgx*2)
        -- ----print(smallPageGroup[smallPageGroup.numChildren].x < (_W*2 - scrOrgx*2))
        if smallPageGroup[smallPageGroup.numChildren-1].x < (_W*2 - scrOrgx - 20) then
          backRight = true
          ------print("ccccc")
          Runtime:addEventListener("enterFrame",backsmallpageFn)
           Runtime:removeEventListener("enterFrame",smallpageMoveFn)
        else
          smallpageVX = smallpageVX*0.96 
          for i = 1,smallPageGroup.numChildren do
            smallPageGroup[i].x = smallPageGroup[i].x + smallpageVX*2
          end
          if smallpageVX > -1 then
            smallpageVX = 0
            Runtime:removeEventListener("enterFrame",smallpageMoveFn)
          end
        end
    end

end

local function smallpageFn(event)
  if optionItemf == false and loadingf == false then
    local ph = event.phase
    local etar = event.target
    
    if optionf == true and autof == false then
      if ph == "began" then
        Runtime:removeEventListener("enterFrame",smallpageMoveFn)
        Runtime:removeEventListener( "enterFrame",smallPageAutoMoveFn )
        Runtime:removeEventListener("enterFrame",backsmallpageFn)
        if setupFirst == true then
            setupFirst = false
            Runtime:removeEventListener("enterFrame",closeOptionFn)
        end
        smallpageinf = true
        smallpageMovef = false
        backLeft = false
        backRight = false
        smallpagef = false
        smallpageOldx = event.xStart
         starttime = event.time
         smallpageVX = 0
          ------print("smallpagewidth==",smallpageWidth)
            for i = 1,smallPageGroup.numChildren-1 do
              
              if math.abs(event.x - smallPageGroup[i].x) <= smallPageGroup[i].contentWidth*0.5 then
                smallpagePos = i
                break
              end
            end

        ------print("began===",etar.no)
      elseif ph == "moved" then
        if smallpageinf ==  true then
          local dx = event.x - smallpageOldx
        
          for i = 1,smallPageGroup.numChildren do
            smallPageGroup[i].x = smallPageGroup[i].x + dx
          end
      
          smallpageOldx = event.x
          smallpagef = true
        end
      elseif ph == "ended" or ph == "canceled" then
        if smallpageinf == true then
          smallpageinf = false
          smallpageVX = event.x - event.xStart
        ------print("smallpageVX == ",smallpageVX)
          smallpageVX = smallpageVX/((event.time - starttime)*0.1)
      
          if smallpagef == false then  
                  --print("smallpagePos==",smallpagePos)
              if  smallpagePos > 0   then  --and flipType ==1
                jumpchapter(smallPageGroup[smallpagePos].no)
                
              end
          else

            smallpageMovef = true
            Runtime:addEventListener("enterFrame",smallpageMoveFn)
          end
      end
    end
    end
  end
end

function showOption()
    ----print("1111111111111")
      boxUp = display.newRect( 0, 0, _W*2-scrOrgx*2, optionBoxUp*optionrate )
      boxUp.x = _W
      boxUp.y = -boxUp.height*0.5 + scrOrgy
      boxUp.orgy = boxUp.y
      boxUp.lasty = boxUp.height*0.5+ statusbarHeight + scrOrgy
      
       boxUp:setFillColor(54/255,53/255,55/255)
      ------print("boxUp.x==",boxUp)
     -- boxUp.y = boxUp.height*0.5
      --boxUp:setFillColor( 66/255,66/255,66/255 )
      --boxUp.alpha = 0.5
      boxUp:addEventListener( "touch",boxUpFn )
      boxDown = display.newRect( 0, 0, _W*2-scrOrgx*2, optionBoxDown )
      boxDown.x = _W
      boxDown.y = _H*2 + boxDown.height*0.5 -scrOrgy
      boxDown.orgy = boxDown.y
      boxDown.lasty  = _H*2-boxDown.height*0.5 -scrOrgy
      -- if currentOrientation == "landscapeLeft" or currentOrientation == "landscapeRight" then
      boxDown:addEventListener( "touch", smallpageFn )
     
      boxDown:setFillColor( 66/255,66/255,66/255 )
      boxDown.alpha = 0.5

      -- optionBtnBase = display.newRect( 0, 0, 80, boxUp.height )
      -- optionBtnBase.x = -10000
      -- optionBtnBase.orgy = -boxUp.height*0.5 + scrOrgy
      -- optionBtnBase:setFillColor( 112/255 )

     -- library = display.newText( "Store",0,0,native.systemFont,30 )
      library = display.newImage( path_image.."b_backstore.png" ,resDir,true )
      library:scale( optionrate, optionrate )
      library.x = scrOrgx + library.contentWidth*0.5
      library.y = -boxUp.height*0.5 + scrOrgy
      library.orgy = library.y
      library.lasty = boxUp.height*0.5 + statusbarHeight + scrOrgy
      library:addEventListener( "touch", library_onlineFn )
      --library.y = boxUp.height*0.5
      print("chapterpageList==",#chapterpageList)

      if #chapterpageList > 0 then
        contents = display.newImage( path_image.."b_toc.png" ,resDir,true )
        contents:scale( optionrate, optionrate )
        contents.x = library.x + (library.contentWidth+contents.contentWidth)*0.5
        contents.y = -boxUp.height*0.5 + scrOrgy
        contents.orgy = contents.y 
        contents.lasty = boxUp.height*0.5 + statusbarHeight + scrOrgy
        contents:addEventListener( "touch", contentsFn )
        contents.y = library.y
      end
     
      local pname = {}
      
      pname[1] = path_image.."b_switchpage02.png" 
      pname[2] = path_image.."b_switchpage01.png"
      
      onoff = movieclip.newAnim(pname,resDir)
      onoff:scale( optionrate, optionrate )
      if scalef == true then
        --scaleing = true
        onoff.alpha = 0.5
      end

      if oldflipType == 1 then
        onoff:stopAtFrame(2)
      end
      if flipType == 1 then
        onoff:stopAtFrame(2)
      end
      onoff.x = _W*2 - scrOrgx - onoff.contentWidth*0.5 
      onoff.y = -boxUp.height*0.5 + scrOrgy
      onoff.orgy = onoff.y 
      onoff.lasty = boxUp.height*0.5 + statusbarHeight + scrOrgy
      onoff:addEventListener( "touch", onoffFn )

      local nextpage_path = system.pathForFile( path_thumb.."1.png", baseDir )
      local mode = lfs.attributes(nextpage_path, "mode")
            
      local thumb = nil               ----print("fh===",fh)
      if mode == nil then
           thumb = display.newRect( 0,0, 100, 150 )
      else
          thumb = display.newImage( path_thumb.."1.png",baseDir,true )
      end
       thumb.x = -10000

      smallrate = (boxDown.height-40)/thumb.height
      ----print("smallrate=="..smallrate)

      local dx2 = thumb.width * smallrate + 10
      --local dx = pageList2[1].width * rate + 200
      local dx = thumb.width * smallrate + 10
      local maxNum = math.floor((_W*2 - 2*display.screenOriginX)/(dx+10))
      ------print("maxnum===",maxNum)

      local period = 0
      local dxxx = 0
      if maxPage > maxNum then
        period = thumb.width*smallrate+20
        dxxx = 60
      else
        period = (_W*2 - 2*display.screenOriginX - 2*dx2)/(maxPage-1)
      end

      for i  = 1,maxPage do
        local smallpage = nil
        local nextpage_path = system.pathForFile( path_thumb..i..".png", baseDir )
        local mode = lfs.attributes(nextpage_path, "mode")
            
                  ----print("fh===",fh)
          if mode == nil then
            smallpage = display.newRect( 0,0, 100, 150 )
          else
            smallpage = display.newImage( path_thumb..i..".png",baseDir,true )
          end
      
          smallpage.name = "book"..i

          smallrate = (boxDown.height-40)/smallpage.height
          smallpage:scale( smallrate, smallrate )
          smallpage.smallrate = smallrate

        if i > 1 then
          local pos = (i-1)*2 - 1
          width = (smallpage.contentWidth + smallPageGroup[pos].contentWidth)*0.5
        end
        if i ==1 then
          smallpage.x =  scrOrgx + 20 + smallpage.contentWidth*0.5
        else
          if i % 2 == 0 then
            smallpage.x = smallPageGroup[(i-1)*2].x + smallpage.contentWidth + 20
          else
            smallpage.x = smallPageGroup[(i-1)*2].x + smallpage.contentWidth
          end
        end
        --smallpage.x = dx + (i-1)*period + scrOrgx -20
        smallpage.y = boxDown.lasty  - 10--smallpage.height*rate-45--
        smallpage.no = i
        smallpage.orgx = smallpage.x
        local pagenum = display.newText(tostring(i),0,0,native.systemFont,24)
       -- smallpage:addEventListener( "touch", smallpageFn )
        pagenum.x = smallpage.x
        pagenum.y = smallpage.y + thumb.height*smallrate*0.5+pagenum.height*0.5
        pagenum.no = i
        pagenum.smallrate = smallrate
        pagenum.smallpageWidth = smallpage.smallpageWidth

        smallPageGroup:insert(smallpage)
        smallPageGroup:insert(pagenum)
       ----print("flipArea[2]222222=",flipArea[2])
      end
      
       if currentOrientation == "landscapeLeft" or currentOrientation == "landscapeRight" then
                local dx = 0 
                local tmpsmallpage = nil
                if pleft > 1 then
                  dx = smallPageGroup[(pleft-1)*2].x
                  tmpsmallpage = smallPageGroup[(pleft-1)*2]
                else
                  dx = smallPageGroup[pleft*2].x
                  tmpsmallpage = smallPageGroup[pleft*2]
                end
                if dx < scrOrgx + 20 then
                  backRight = true
                 Runtime:addEventListener( "enterFrame", smallPageAutoMoveFn)
                end
                if dx > _W*2 - scrOrgx - 20 - tmpsmallpage.contentWidth*0.5  then 
                    backLeft  = true
                    Runtime:addEventListener( "enterFrame", smallPageAutoMoveFn)                             
                end    
      else
         local dx = 0
                          --print("p1==",p1)
                         
                          dx = smallPageGroup[p1*2-1].x
                          if dx < scrOrgx + 20 then
                               backRight = true
                               Runtime:addEventListener( "enterFrame", smallPageAutoMoveFn)
                          end
                          if dx > _W*2 - scrOrgx - 20 - smallPageGroup[p1*2-1].contentWidth*0.5 then
                              backLeft  = true
                              Runtime:addEventListener( "enterFrame", smallPageAutoMoveFn)
                          end

      end                    

      
      
      smallpageWidth = thumb.width*smallrate
      smallPageGroup.y = boxDown.height
      smallPageGroup.orgy = smallPageGroup.y
      smallPageGroup.lasty = 0
      ------print("boxup.y===",boxUp.y)
      -- transition.to( boxUp, { time=400, y=boxUp.height*0.5+statusbarHeight +scrOrgy} )
      -- transition.to( boxDown, { time=400, y=_H*2-boxDown.height*0.5-scrOrgy} )
      -- transition.to( library, { time=400, y=boxUp.height*0.5+statusbarHeight+scrOrgy} )
      -- transition.to( contents, { time=400, y=boxUp.height*0.5+statusbarHeight+scrOrgy} )
     
      -- transition.to( onoff, { time=400, y=boxUp.height*0.5+statusbarHeight+scrOrgy} )
      -- transition.to(smallPageGroup,{time = 400,y=0})

      optionGroup:insert(boxUp)
      optionGroup:insert(boxDown)
--      optionGroup:insert(optionBtnBase)
      optionGroup:insert(library)
      if #chapterpageList > 0 then
        optionGroup:insert(contents)
      end
      --optionGroup:insert(markbmp)
      optionGroup:insert(onoff)
      --optionGroup:insert(pageText)
      optionGroup:insert(smallPageGroup)
       --optionGroup:insert(cards)
     -- optionGroup:insert(ball)
      --optionGroup.alpha = 0
      sceneGroup:insert(optionGroup)
      loadthumb()
      

      ------print("aaaa")
      --setupf = false
end

function scene:create(event)
   

end

local function setok()
  ----print("pagelist[1].x===",pageList[1].x)
  mutiscalef = false
end

local function pageZoom(event)
  ----print("pagezoom.....")
  ----print("scalef===",scalef)
  if currentOrientation == "landscapeLeft" or currentOrientation == "landscapeRight" then
    if scaleing == true then
      if pleft == 1 then
       -- local bounds = pageList2[1].contentBounds 
        local tmprate = pageList2[1].rate*maxrate
        local drate = tmprate - zoomrate
        drate = drate*0.3
        zoomrate = zoomrate + drate
        pageList2[1].xScale = zoomrate
        pageList2[1].yScale = zoomrate
        

        if zoomClickx >= bounds.xMin and zoomClickx <= bounds.xMax and zoomClicky >= bounds.yMin and zoomClicky <= bounds.yMax then
          local orgdx = zoomClickx - _W
          local orgdy = zoomClicky - pageH

          local dx = orgdx*(tmprate - pageList2[1].rate)
          local dy = orgdy*(tmprate - pageList2[1].rate)
          local tarx = (_W-pageList2[1].width*tmprate*0.5) - dx  --orgdx*0.56
          local tary = pageH - dy  -orgdy*0.56
          local ddx = tarx - pageList2[1].x
          local ddy = tary - pageList2[1].y
          ddx = ddx*0.3
          ddy = ddy*0.3

          pageList2[1].x = pageList2[1].x + ddx
          pageList2[1].y = pageList2[1].y + ddy
        
          ------print("nowrate - zoomrate===",(nowrate - zoomrate))
          if (tmprate - zoomrate) <= 0.01 then
            pageList2[1].xScale = tmprate
            pageList2[1].yScale = tmprate
            pageList2[1].x = (_W-pageList2[1].contentWidth*0.5) - dx --orgdx*0.56
            pageList2[1].y = pageH - dy -orgdy*0.56
            pageList2[1].nowrate = tmprate
           -- arrangBigPageFn()
            mutiscalef = false
            Runtime:removeEventListener("enterFrame",pageZoom)
          end
        else
         
          if (tmprate - zoomrate) <= 0.01 then
            pageList2[1].xScale = tmprate
            pageList2[1].yScale = tmprate
            pageList2[1].nowrate = tmprate

            --arrangBigPageFn()
            mutiscalef = false
            Runtime:removeEventListener("enterFrame",pageZoom)
          end
        end
       
      elseif pleft > maxPage then

        --local bounds = pageList2[maxPage].contentBounds
        local tmprate = pageList2[maxPage].rate*maxrate
        local drate = tmprate - zoomrate
        drate = drate*0.3
        ----print("zoomrate===",zoomrate)
        zoomrate = zoomrate + drate
        pageList2[maxPage].xScale = zoomrate
        pageList2[maxPage].yScale = zoomrate

        if zoomClickx >= bounds.xMin and zoomClickx <= bounds.xMax and zoomClicky >= bounds.yMin and zoomClicky <= bounds.yMax then
          local orgdx = zoomClickx - _W 
          local orgdy = zoomClicky - pageH
          local dx = orgdx*(tmprate-pageList2[maxPage].rate)
          local dy = orgdy*(tmprate - pageList2[maxPage].rate)
          local tarx = (_W-pageList2[maxPage].width*tmprate*0.5)-dx - pageList2[maxPage].contentWidth - orgdx*0.56
          local tary = pageH - dy - orgdy*0.56
          local ddx = tarx - pageList2[maxPage].x
          local ddy = tary - pageList2[maxPage].y
          ddx = ddx*0.3
          ddy = ddy*0.3
          pageList2[maxPage].x = pageList2[maxPage].x + ddx
          pageList2[maxPage].y = pageList2[maxPage].y + ddy

          if (tmprate - zoomrate) <= 0.01 then
            pageList2[maxPage].xScale = tmprate
            pageList2[maxPage].yScale = tmprate
            pageList2[maxPage].x = (_W-pageList2[maxPage].contentWidth*0.5)- dx - pageList2[maxPage].contentWidth -- orgdx*0.56
            pageList2[maxPage].y =pageH - dy - orgdy*0.56
            pageList2[maxPage].nowrate = tmprate
           -- arrangBigPageFn()
            mutiscalef = false
            Runtime:removeEventListener("enterFrame",pageZoom)
          end

        else
       
          if (nowrate - zoomrate) <= 0.01 then
            pageList2[maxPage].xScale = tmprate
            pageList2[maxPage].yScale = tmprate
             pageList2[maxPage].nowrate = tmprate
           -- arrangBigPageFn()
            mutiscalef = false
            Runtime:removeEventListener("enterFrame",pageZoom)
          end
        end

      else

        --local bounds = pageList2[pleft-1].contentBounds
        --local bounds2 = pageList2[pleft].contentBounds
        local tmprate1 = pageList2[pleft].rate*maxrate
        local tmprate2 = pageList2[pleft-1].rate*maxrate
         local drate = tmprate1 - zoomrate
         local drate2 =tmprate2 - zoomrate2
        drate = drate*0.3
        drate2 = drate2*0.3
        
        zoomrate = zoomrate + drate
        zoomrate2 = zoomrate2 + drate2
        pageList2[pleft-1].xScale = zoomrate2
        pageList2[pleft-1].yScale = zoomrate2
        pageList2[pleft].xScale = zoomrate
        pageList2[pleft].yScale = zoomrate
        
        -- --print("pageList2.conternwidth",pageList2[pleft].contentWidth)
        -- --print("pageList2.orig",pageList2[pleft].originpagewidth*zoomrate)
   --if zoomClickx >= bounds.xMin and zoomClickx <= bounds2.xMax and zoomClicky >= bounds.yMin and zoomClicky <= bounds.yMax then
          local orgdx = zoomClickx - _W
          local orgdy = zoomClicky - pageH
          local dx = orgdx*(tmprate1-pageList2[pleft].rate)
          local dy = orgdy*(tmprate1 - pageList2[pleft].rate)
          local tarx = _W - dx - orgdx*0.56
          local tary = pageH - dy - orgdy*0.56
          local ddx = tarx - pageList2[pleft].x
          local ddy = tary - pageList2[pleft].y
          ddx = ddx*0.3
          ddy = ddy*0.3

          pageList2[pleft].x = pageList2[pleft].x + ddx
          pageList2[pleft].y = pageList2[pleft].y + ddy
          pageList2[pleft-1].x = pageList2[pleft].x - pageList2[pleft-1].contentWidth
          pageList2[pleft-1].y = pageList2[pleft].y

          

          if (tmprate1 - zoomrate) <= 0.01 then
            pageList2[pleft-1].xScale = tmprate2
            pageList2[pleft-1].yScale = tmprate2
            pageList2[pleft].xScale = tmprate1
            pageList2[pleft].yScale = tmprate1
            pageList2[pleft].x = _W - dx - orgdx*0.56
            pageList2[pleft].y = pageH - dy - orgdy*0.56
            pageList2[pleft-1].x = pageList2[pleft].x - pageList2[pleft-1].contentWidth
            pageList2[pleft-1].y = pageList2[pleft].y
            pageList2[pleft].nowrate = tmprate1
            pageList2[pleft-1].nowrate = tmprate2
            ----print("pageList2[pleft].nowrate===",pageList2[pleft].nowrate)
            mutiscalef = false
            Runtime:removeEventListener("enterFrame",pageZoom)
          end

      end
    else
      ---縮小

      if pleft == 1 then
        --local bounds = pageList2[1].contentBounds 
        --local nowrate = rate
        nowrate = 1
        local drate = pageList2[1].rate - zoomrate
        drate = drate*0.3
        --------print("zoomrate===",zoomrate)
        zoomrate = zoomrate + drate
        pageList2[1].xScale = zoomrate
        pageList2[1].yScale = zoomrate
       
                  
          local ddx = (_W-pageList2[1].width*pageList2[1].rate*0.5)- pageList2[1].x
          local ddy = pageH - pageList2[1].y
          ddx = ddx*0.3
          ddy = ddy*0.3
          ------print("ddx===",ddx)
         -- ----print("ddy===",ddy)
          pageList2[1].x = pageList2[1].x + ddx
          pageList2[1].y = pageList2[1].y + ddy
        
          ------print("nowrate - zoomrate===",(nowrate - zoomrate))
          if math.abs(pageList2[1].rate - zoomrate) <= 0.01 then
            pageList2[1].xScale = pageList2[1].rate
            pageList2[1].yScale = pageList2[1].rate
            pageList2[1].x = (_W-pageList2[1].contentWidth*0.5)
            pageList2[1].y = pageH
           
            -- if oldflipType == 1 then    
            --   arrangPageFn()
            -- else
              flipType = 0
              arrangPageFn2()
            --end
            mutiscalef = false

            scalef = false
            onoff.alpha = 1.0
            Runtime:removeEventListener("enterFrame",pageZoom)
          end
      elseif pleft > maxPage then
       
        local drate = pageList2[maxPage].rate - zoomrate
        drate = drate*0.3
        --------print("zoomrate===",zoomrate)
        zoomrate = zoomrate + drate
        pageList2[maxPage].xScale = zoomrate
        pageList2[maxPage].yScale = zoomrate
        

          local ddx = (_W-pageList2[maxPage].width*pageList2[maxPage].rate*0.5)-pagewidth - pageList2[maxPage].x
          local ddy = pageH - pageList2[maxPage].y
          ddx = ddx*0.3
          ddy = ddy*0.3
          ------print("ddx===",ddx)
         -- ----print("ddy===",ddy)
          pageList2[maxPage].x = pageList2[maxPage].x + ddx
          pageList2[maxPage].y = pageList2[maxPage].y + ddy
         

          if math.abs(rate - zoomrate) <= 0.01 then
            pageList2[maxPage].xScale = pageList2[maxPage].rate
            pageList2[maxPage].yScale = pageList2[maxPage].rate
            pageList2[maxPage].x = _W-pageList2[maxPage].contentWidth*0.5
            pageList2[maxPage].y = pageH 
            
            --  if oldflipType == 1 then    
            --   arrangPageFn()
            -- else
              flipType = 0
              arrangPageFn2()
            -- end
            scalef = false
            onoff.alpha = 1.0
            mutiscalef = false
            Runtime:removeEventListener("enterFrame",pageZoom)
          end
      else
        
         local drate = pageList2[pleft].rate - zoomrate
         local drate2 = pageList2[pleft-1].rate - zoomrate2
         --print("zoomrate==",zoomrate)
         --print("zoomrate2==",zoomrate2)
        drate = drate*0.3
        drate2 = drate2*0.3

        --------print("zoomrate===",zoomrate)
        zoomrate = zoomrate + drate
        zoomrate2 = zoomrate2 + drate2

        pageList2[pleft-1].xScale = zoomrate2
        pageList2[pleft-1].yScale = zoomrate2
        pageList2[pleft].xScale = zoomrate
        pageList2[pleft].yScale = zoomrate
      
          local ddx = _W - pageList2[pleft].x
          local ddy = pageH - pageList2[pleft].y
          ddx = ddx*0.3
          ddy = ddy*0.3
          ------print("ddx===",ddx)
         -- ----print("ddy===",ddy)
          pageList2[pleft].x = pageList2[pleft].x + ddx
          pageList2[pleft].y = pageList2[pleft].y + ddy
          pageList2[pleft-1].x = pageList2[pleft].x - pageList2[pleft-1].contentWidth
          pageList2[pleft-1].y = pageList2[pleft].y

          if math.abs(pageList2[pleft].rate - zoomrate) <= 0.01 then
            pageList2[pleft-1].xScale = pageList2[pleft-1].rate
            pageList2[pleft-1].yScale = pageList2[pleft-1].rate
            pageList2[pleft].xScale = pageList2[pleft].rate
            pageList2[pleft].yScale = pageList2[pleft].rate
            pageList2[pleft].x = _W 
            pageList2[pleft].y = pageH 
            pageList2[pleft-1].x = _W-pageList2[pleft-1].contentWidth
            pageList2[pleft-1].y = pageH

            
            if oldflipType == 1 then 
              flipType = 1   
              arrangPageFn()
            else
              flipType = 0
              arrangPageFn2()
            end
            mutiscalef = false
            onoff.alpha = 1.0
            scalef = false
            Runtime:removeEventListener("enterFrame",pageZoom)
          end
      end
      
    end
  else
      ----直
      if scaleing == true then     
        --local bounds = pageList2[p1].contentBounds 
        local tmprate = pageList2[p1].nowrate
        local drate = tmprate - zoomrate
        drate = drate*0.3
        
        zoomrate = zoomrate + drate
        pageList2[p1].xScale = zoomrate
        pageList2[p1].yScale = zoomrate
       

        if zoomClickx >= bounds.xMin and zoomClickx <= bounds.xMax and zoomClicky >= bounds.yMin and zoomClicky <= bounds.yMax then
          local dw = _W*2-2*scrOrgx - pageList2[p1].originpagewidth*pageList2[p1].rate
          ----print("scrOrgx + dw/2==",scrOrgx + dw/2)
          ----print("_W===",_W)
          local orgdx = zoomClickx - scrOrgx - dw/2
          local orgdy = zoomClicky + scrOrgy - _H
          
          dx = orgdx*(nowrate - pageList2[p1].rate)
          dy = orgdy*(nowrate - pageList2[p1].rate)
          
           --local dw2 = _W*2-2*scrOrgx - originpagewidth*zoomrate
          local tarx = scrOrgx + dw/2 - dx 
          local tary = pageH - dy 
          local ddx = tarx - pageList2[p1].x
          local ddy = tary - pageList2[p1].y
           ddx = ddx*0.3
           ddy = ddy*0.3

          pageList2[p1].x = pageList2[p1].x + ddx
          pageList2[p1].y = pageList2[p1].y + ddy

         
          if (tmprate - zoomrate) <= 0.01 then
           -- --print("maxrate==",maxrate)
            pageList2[p1].xScale = tmprate
            pageList2[p1].yScale = tmprate
            pageList2[p1].x = scrOrgx + dw/2 - dx
            pageList2[p1].y = pageH - dy 
            pageList2[p1].nowrate = tmprate
            mutiscalef = false
            --onoff.alpha = 1.0
            Runtime:removeEventListener("enterFrame",pageZoom)
          end
        else

          if (tmprate - zoomrate) <= 0.01 then
            pageList2[p1].xScale = tmprate
            pageList2[p1].yScale = tmprate

            mutiscalef = false
            --onoff.alpha = 1.0
            Runtime:removeEventListener("enterFrame",pageZoom)
          end
        end
    else
      ----直縮小
        local tmprate = pageList2[p1].rate
        local drate = tmprate - zoomrate
        drate = drate*0.3

        zoomrate = zoomrate + drate
        pageList2[p1].xScale = zoomrate
        pageList2[p1].yScale = zoomrate

          local dw = _W*2-2*scrOrgx - pageList2[p1].originpagewidth*pageList2[p1].rate
          local ddx = scrOrgx - pageList2[p1].x + dw/2
          local ddy = pageH - pageList2[p1].y
          ddx = ddx*0.3
          ddy = ddy*0.3

          pageList2[p1].x = pageList2[p1].x + ddx
          pageList2[p1].y = pageList2[p1].y + ddy

          ------print("nowrate - zoomrate===",(nowrate - zoomrate))
          if math.abs(pageList2[p1].rate - zoomrate) <= 0.01 then
            pageList2[p1].xScale = pageList2[p1].rate
            pageList2[p1].yScale = pageList2[p1].rate
            pageList2[p1].x = scrOrgx + dw/2
            pageList2[p1].y = pageH 

            if oldflipType == 1 then    
              if p1 ==1 or p1 == maxPage then
                flipType = 0
                arrangPageFn2()
              else
                flipType = 1
                arrangPageFn()
              end
            else
              flipType = 0
              arrangPageFn2()
            end
            mutiscalef = false
            scalef = false
            onoff.alpha = 1.0
            Runtime:removeEventListener("enterFrame",pageZoom)
          end

    end
  end
end

local function tapFn(tnum,cx,cy)
  --print("mutitouchf==",mutitouchf)
  if mutitouchf == false then
  local x = cx
  local y = cy
  if tnum == 1 then
    tnum = 0

    if x > clickAreaL[3] and x < clickAreaR[1] and y > flipArea[2] and y < flipArea[4] and exitf == false then
     -- local contents = display.newText( tostring(event.numTaps),200,300,native.systemFont,80)
      if optionf == true then
        if setupFirst == true then
          setupFirst = false
          Runtime:removeEventListener("enterFrame",closeOptionFn)
        end       
        optionItemf = false
        flipArea[1] =  scrOrgx
        clickAreaL[3] = scrOrgx + clickWidth
        --print("222222222")
        closeOption()
      else      
        openOption()
      end
    end
    
    if x > clickAreaL[1] and x < clickAreaL[3] and y > clickAreaL[2] and y < clickAreaL[4] and optionItemf == false and loadingf == false then

          if scalef == false and optionItemf == false then
              if currentOrientation == "landscapeLeft" or currentOrientation == "landscapeRight" then
                    if pleft < maxPage then                   
                    
                      dir = "left"              
                      p1 = pleft
                      p2 = p1 + 1                
                      if pleft+2 >= maxPage then
                          if flipType == 1 then
                            oldflipType = 1
                            flipType = 0
                            if maxPage % 2 == 0 then
                              pageList2[maxPage].anchorX = 0
                              pageList2[maxPage].x = _W*2-2*scrOrgx + (_W*2 - 2*scrOrgx - pageList2[maxPage].contentWidth)
                              --print("maxpage.xxxxxxxx==",pageList2[maxPage].x)
                              pageList2[maxPage].path.x3 = 0
                              pageList2[maxPage].path.x4 = 0
                              pageList2[maxPage].path.y3 = 0
                              pageList2[maxPage].path.y4 = 0
                              pageList2[maxPage].path.x1 = 0
                              pageList2[maxPage].path.x2 = 0
                              pageList2[maxPage].path.y1 = 0
                              pageList2[maxPage].path.y2 = 0
                              pageList2[maxPage]:toFront( )
                            else
                              pageList2[maxPage].anchorX = 0
                              pageList2[maxPage-1].anchorX = 0
                              pageList2[maxPage-1].x = _W*2 - scrOrgx
                              pageList2[maxPage].x = pageList2[maxPage-1].x + pageList2[maxPage-1].contentWidth
                              
                              pageList2[maxPage].path.x3 = 0
                              pageList2[maxPage].path.x4 = 0
                              pageList2[maxPage].path.y3 = 0
                              pageList2[maxPage].path.y4 = 0
                              pageList2[maxPage].path.x1 = 0
                              pageList2[maxPage].path.x2 = 0
                              pageList2[maxPage].path.y1 = 0
                              pageList2[maxPage].path.y2 = 0
                              pageList2[maxPage-1].path.x3 = 0
                              pageList2[maxPage-1].path.x4 = 0
                              pageList2[maxPage-1].path.y3 = 0
                              pageList2[maxPage-1].path.y4 = 0
                              pageList2[maxPage-1].path.x1 = 0
                              pageList2[maxPage-1].path.x2 = 0
                              pageList2[maxPage-1].path.y1 = 0
                              pageList2[maxPage-1].path.y2 = 0
                              pageList2[maxPage-1]:toFront( )
                              pageList2[maxPage]:toFront( )
                            end
                            mask:toBack( )
                            --arrangPageFn2()
                          end
                         end

                      if flipType == 1 then
                            pageList2[p1]:toFront( )
                      end
              
                      checkdir = false
                      --print("19")
                      turnf = false
                      -- autovx = -100  
                      if flipType == 1 then
                        autovx = -220
                      else
                        autovx = -140 
                      end           
                      autof = true
                      --print("autoturnfn10")
                     
                      Runtime:addEventListener("enterFrame",autoturnfn )
                    end
              else
                if p1 < maxPage then

                    
                      dir = "left"              

                      -- pageList2[p1].no = p1
                       
                     if p1 ==  maxPage -1 then
                          if flipType == 1 then
                            oldflipType = 1
                            flipType = 0
                            pageList2[maxPage].anchorX = 0
                            pageList2[maxPage].x = _W*2 - scrOrgx 
                            pageList2[maxPage].path.x3 = 0
                            pageList2[maxPage].path.x4 = 0
                            pageList2[maxPage].path.y3 = 0
                            pageList2[maxPage].path.y4 = 0
                            mask:toBack( )
                          end
                        end

                        if flipType == 1 then
                          pageList2[p1]:toFront( )
                        end
              
                      checkdir = false
                      --print("19")
                      turnf = false
                      --if flipType == 0 then
                        -- autovx = -100  
                      -- if flipType == 1 then
                      --   autovx = -220
                      -- else
                        autovx = -140 
                      -- end   
                      --else
                       -- autovx = -60 
                      --end              
                      autof = true
                      --print("autoturnfn11")
                      
                      Runtime:addEventListener("enterFrame",autoturnfn )
                    end
              end
          end
    end

    if x > clickAreaR[1] and x < clickAreaR[3] and y > clickAreaR[2] and y < clickAreaR[4] and optionItemf == false and loadingf == false then
          if scalef == false then
              if currentOrientation == "landscapeLeft" or currentOrientation == "landscapeRight" then
                    if pright > 0 then

                      dir = "right"              
                      
                      p1 = pright
                      p2 = p1 - 1
                      --print("p1===,p1")
                      -- pageList2[p1] = pageList2[p1]
                      -- pageList2[p2] = pageList2[p2]
                 
--                      pageList2[p1].no = p1
                    
                     if p1 <= 2 then
                        if oldflipType == 1 then
                          if flipType == 1 then
                            flipType = 0 
                            pageList2[1].anchorX = 0
                            pageList2[1].path.x3 = 0
                            pageList2[1].path.x4 = 0
                            pageList2[1].path.y3 = 0
                            pageList2[1].path.y4 = 0
                            pageList2[1].x = pageList2[2].x - pageList2[1].contentWidth - (_W*2 - scrOrgx*2 - pageList2[1].contentWidth) - pageList2[2].contentWidth
                            --print("page22222.x===",pageList2[1].x)
                            pageList2[2]:toBack( )
                            pageList2[1]:toBack( )
                            mask:toBack( )
                          end
                        end
                      end 
                      if flipType == 1 then
                        print("mask.contentWidth==",mask.contentWidth)
                        pageList2[p1]:toFront( )
                      end
           
                      checkdir = false
                      --print("20")
                      turnf = false
                     
                        -- autovx = 100  
                      if flipType == 1 then
                        autovx = 220
                      else
                        autovx = 140 
                      end   
                      autof = true
                      --print("autoturnfn12")
                     
                      Runtime:addEventListener("enterFrame",autoturnfn )
                    end
              else
                  if p1 > 1 then
                      p1 = p1 -1
                      dir = "right"              
                 --     pageList2[p1].no = p1
                      
                     -- if flipType
                      

                      if p1 == 1 then
                        if flipType == 1 then
                          oldflipType = 1
                          flipType = 0
                          pageList2[1].anchorX = 0
                          pageList2[1].x = scrOrgx - pageList2[1].contentWidth
                          pageList2[1].path.x3 = 0
                          pageList2[1].path.x4 = 0
                          pageList2[1].path.y3 = 0
                          pageList2[1].path.y4 = 0
                          mask:toBack( )
                        end
                      end
           
                      checkdir = false
                      --print("20")
                      turnf = false
                      if flipType == 0 then
                       autovx = 140  
                        --autovx = 100  
                      else
                        pageList2[p1]:toFront( )
                         pageList2[p1].path.x4=-pageList2[p1].pagewidth
                        pageList2[p1].path.x3=-pageList2[p1].pagewidth
                        autovx = 220 
                      end 
                      -- if flipType == 1 then
                      --   autovx = 220
                      -- else
                        --autovx = 140 
                      --end   

                      autof = true
                      --print("autoturnfn13")
                     
                      Runtime:addEventListener("enterFrame",autoturnfn )
                    end
              end
          end
    end

--tapfn
  elseif tnum == 2 then
    tnum = 0
    ------print(event.numTaps)
    if x > flipArea[1] and x < flipArea[3] and y > flipArea[2] and y < flipArea[4] then
     if mutiscalef == false then
      mutiscalef = true
      --print("scalef==",scalef)
      --print("scaleing==",scaleing)
      if scalef == true and scaleing == true then
       -- scalef = false
        scaleing = false
        onoff.alpha = 1.0
        flipType = oldflipType
        --zoomrate = nowrate
        nowrate = 1 --倍率
        zoomClickx = x
        zoomClicky = y
        -- if currentOrientation == "landscapeLeft" or currentOrientation == "landscapeRight" then
        -- else
        --   pageList2[p1].anchorX = 0
        -- end
        if currentOrientation == "landscapeLeft" or currentOrientation == "landscapeRight" then
          if pleft == 1 then
            zoomrate = pageList2[1].nowrate
            flipType = 0
          elseif pleft > maxPage then
            flipType = 0
            zoomrate = pageList2[maxPage].nowrate
          else
            zoomrate = pageList2[pleft].nowrate
            zoomrate2 = pageList2[pleft-1].nowrate
            ----print("zoomrate===",zoomrate)
          end
        else
          if p1 == 1 or p1 == maxPage then
            flipType = 0
          end
          zoomrate = pageList2[p1].nowrate
          pageList2[p1].anchorX = 0
        end

        
        Runtime:addEventListener("enterFrame",pageZoom)
        --pageZoom(x,y,rate,rate)
      
      elseif scalef == false and scaleing == false then
        scalef = true
        scaleing = true
        onoff.alpha = 0.5
        --oldflipType = flipType
        

          if flipType == 1 then
     -- ----print("oldfiletype===============1")
            flipType = 0
           arrangPageFn2()
           --nowrate = tarwidth
          end
          
          zoomrate = pageList2[p1].rate
          targetrate = pageList2[p1].rate
          zoomClickx = x
          zoomClicky = y
          nowrate = maxrate
          Runtime:addEventListener("enterFrame",pageZoom)
        if currentOrientation == "landscapeLeft" or currentOrientation == "landscapeRight" then
          if pleft == 1 then
            targetrate = pageList2[1].rate
            zoomrate = pageList2[1].rate
            --maxrate = targetrate*2
            pageList2[1].nowrate = pageList2[1].rate*maxrate
            bounds = pageList2[1].contentBounds
            for i = 2,pageList.numChildren do
              -- if pageList[i].rate ~= targetrate then
              --   local nowrate2 = nowrate*(pageList[i].rate/targetrate)
              --   pageList[i].nowrate = nowrate2
              -- else
              --   pageList[i].nowrate = nowrate
              -- end
                local tmprate = pageList[i].rate*maxrate
                pageList[i].xScale = tmprate
                pageList[i].yScale = tmprate
                pageList[i].x = _W*2 - scrOrgx + (i-2)*pageList[i].contentWidth      
                pageList[i].y = scrOrgy + pageList[i].contentHeight*0.5
                
                   
            end
          elseif pleft > maxPage then
            bounds = pageList2[maxPage].contentBounds
            pageList2[maxPage].nowrate = pageList2[maxPage].rate*maxrate
            zoomrate = pageList2[maxPage].rate
            for i = 2,1,-1 do
              -- if pageList[i].rate ~= targetrate then
              --   local nowrate2 = nowrate*(pageList[i].rate/targetrate)
              --   pageList[i].nowrate = nowrate2
              -- else
              --   pageList[i].nowrate = nowrate
              -- end
              local tmprate = pageList[i].rate*maxrate
              pageList[i].nowrate = tmprate
              pageList[i].xScale =  tmprate
              pageList[i].yScale =  tmprate
              pageList[i].x = scrOrgx + (i-3)*pageList[i].contentWidth      
              pageList[i].y = scrOrgy +  pageList[i].contentHeight*0.5  
             
            end  
          else
             bounds = pageList2[pleft-1].contentBounds
             bounds2 = pageList2[pleft].contentBounds
             zoomrate = pageList2[pleft].rate
             zoomrate2 = pageList2[pleft-1].rate
             pageList2[pleft-1].nowrate = pageList2[pleft-1].rate*maxrate
             pageList2[pleft].nowrate = pageList2[pleft].rate*maxrate
            for i = pleft-3,pleft-2 do     
              if i <= maxPage and i > 0  then
                -- if pageList2[i].rate ~= targetrate then
                --   local nowrate2 = nowrate*(pageList2[i].rate/targetrate)
                --   pageList2[i].nowrate = nowrate2
                -- else
                --   pageList2[i].nowrate = nowrate
                -- end
                local tmprate = pageList2[i].rate*maxrate
                pageList2[i].nowrate = tmprate

                pageList2[i].xScale = tmprate
                pageList2[i].yScale = tmprate
                pageList2[i].x = scrOrgx + (i-pleft+1)*pageList2[i].contentWidth
                pageList2[i].y = scrOrgy + pageList2[i].contentHeight*0.5
                
              end
            end

            for i = pleft+1,pleft+2 do
              -- if pageList2[i].rate ~= targetrate then
              --   local nowrate2 = nowrate*(pageList2[i].rate/targetrate)
              --   pageList2[i].nowrate = nowrate2
              -- else
              --   pageList2[i].nowrate = nowrate
              -- end
              if i <= maxPage then
                local tmprate = pageList2[i].rate*maxrate
                pageList2[i].nowrate = tmprate

                pageList2[i].xScale = tmprate
                pageList2[i].yScale = tmprate
                pageList2[i].x = _W*2 - scrOrgx + (i-pleft-1)*pageList2[i].contentWidth
                pageList2[i].y = scrOrgy + pageList2[i].contentHeight*0.5
                
              end
            end
          end
        --pageZoom(x,y,nowrate,nowrate)
        else
          ---直
          bounds = pageList2[p1].contentBounds 
          pageList2[p1].nowrate = pageList2[p1].rate*maxrate
          zoomrate = pageList2[p1].rate
          if p1 == 1 then
             
              pageList[2].nowrate = pageList[2].rate*maxrate
              pageList[2].xScale = pageList[2].nowrate
              pageList[2].yScale = pageList[2].nowrate
              pageList[2].x = _W*2-scrOrgx
              --pageList[1].x + pageList[1].contentWidth

              pageList[2].y = scrOrgy + pageList[2].contentHeight*0.5  
              
          elseif p1 == maxPage then
              
              pageList[1].nowrate = pageList[1].rate*maxrate
              pageList[1].xScale = pageList[1].nowrate
              pageList[1].yScale = pageList[1].nowrate
              pageList[1].x = scrOrgx - pageList[1].contentWidth
              pageList[1].y = scrOrgy + pageList[1].contentHeight*0.5  
             
          else
              
               pageList[1].nowrate = pageList[1].rate*maxrate

              pageList[1].xScale = pageList[1].nowrate
              pageList[1].yScale = pageList[1].nowrate
              pageList[1].x = scrOrgx - pageList[1].contentWidth
              pageList[1].y = scrOrgy + pageList[1].contentHeight*0.5  

              pageList[3].nowrate = pageList[3].rate*maxrate

              pageList[3].xScale = pageList[3].nowrate
              pageList[3].yScale = pageList[3].nowrate
              pageList[3].x = _W*2 - scrOrgy
              pageList[3].y = scrOrgy + pageList[3].contentHeight*0.5  
 
          end
        end
      end
    end
   end
  end
  return true
  end
end

local function contTime(event)
  if touchnum ==1 then
    local ot = system.getTimer( ) - touchtime
    ----print("ot===",ot)
    if ot > 300 then
      touchnum = 0
     -- --print("tapfn1111===")
      tapFn(1,tapx,tapy)
      Runtime:removeEventListener("enterFrame",contTime)
    end  
  end
end

local function testTimeFn(event)
  local ph = event.phase
  ----print("ph===",ph)
  local x = event.xStart
  local y = event.yStart

      if ph == "began" then
        mf = false
      elseif ph == "moved" then
        mf = true
      elseif ph == "ended" then
        ----print("mf===",mf)
        if mf == false   then
        ----print("11111111")

          tapx = event.xStart
          tapy = event.yStart
          if touchnum == 0  then
            touchnum = touchnum +1
            touchtime = system.getTimer( )
            ----print("conttiem")
            Runtime:addEventListener("enterFrame",contTime)
          else
            Runtime:removeEventListener("enterFrame",contTime)

            if optionItemf == false and loadingf == false then
              tapFn(2,tapx,tapy)
            end
            touchnum = 0

          end
        end

      end
  --end
end

function replace()

    local lastpage_path = system.pathForFile( choice_bookcode.."/lastpage.txt", baseDir )
    local fh, errStr = io.open( lastpage_path, "w" )
    
    if fh then        
        if currentOrientation == "landscapeLeft" or currentOrientation == "landscapeRight" then
          if pleft >  maxPage then
            fh:write( maxPage )
          else
            fh:write( pleft )
          end         
        else
          fh:write( p1 )
        end
        io.close( fh )    
    end

    Runtime:removeEventListener("enterFrame",mutimoveFn)
    Runtime:removeEventListener("enterFrame",closeOptionFn)
    Runtime:removeEventListener("enterFrame", smallPageAutoMoveFn)
    Runtime:removeEventListener("enterFrame",mutiZoom)
    Runtime:removeEventListener("enterFrame",bigPageBackFn)
    Runtime:removeEventListener("enterFrame", bigPageFloatFn)            
    Runtime:removeEventListener("enterFrame", bigAutoFlipFn)
    Runtime:removeEventListener("orientation", onOrientationChange )
    Runtime:removeEventListener("enterFrame",backsmallpageFn)
    Runtime:removeEventListener("enterFrame",smallpageMoveFn)
    Runtime:removeEventListener("enterFrame",autoturnfn )
    Runtime:removeEventListener("enterFrame",pageZoom)
    Runtime:removeEventListener("enterFrame",contTime)
    Runtime:removeEventListener("touch",turnPagefn)
    composer.gotoScene( "trans_online")

end

function start()
  if scalef ==  false then
    
    -- if flipType == 1 then
    --     arrangPageFn()
    --    else
        
    --     arrangPageFn2()
    --    end
    -- else
      
    --   arrangBigPageFn()
    -- end
    if flipType == 1 then
          
        if pleft == 1 then
          oldflipType = 1
          flipType = 0
          arrangPageFn2()
        elseif pleft>= maxPage then
           oldflipType = 1
          flipType = 0
          arrangPageFn2()
        else
          arrangPageFn()
        end
    else
      if oldflipType == 1 then
        if flipType == 0 then
            if pleft == 1 or pleft >= maxPage then
              arrangPageFn2()
            else
              flipType = 1
              arrangPageFn()
            end
        end
      else
        arrangPageFn2()
      end
    end
  else
      -- if currentOrientation == "landscapeLeft" or currentOrientation == "landscapeRight" then
      --   rate = rateh
      -- else
      --   rate = ratev
      -- end
      arrangBigPageFn()
  end
  
    if optionf == true then
      table.insert(flipArea, scrOrgx ) ---left
      table.insert(flipArea, scrOrgy + optionBoxUp + statusbarHeight) ----up
      table.insert(flipArea, -scrOrgx  + _W*2) --right
      table.insert(flipArea, -scrOrgy - optionBoxDown + _H*2) --down

      table.insert(clickAreaL,scrOrgx)
      table.insert(clickAreaL,scrOrgy + optionBoxUp+statusbarHeight)
      table.insert(clickAreaL,scrOrgx+clickWidth)
      table.insert(clickAreaL,-scrOrgy - optionBoxDown + _H*2)

      table.insert(clickAreaR, -scrOrgx - clickWidth + _W*2)
      table.insert(clickAreaR,scrOrgy + optionBoxUp+statusbarHeight)
      table.insert(clickAreaR,-scrOrgx + _W*2)
      table.insert(clickAreaR,-scrOrgy - optionBoxDown + _H*2)

      -- for i = 1,4 do
      --   ----print(clickAreaR[i])
      -- end
    else
      table.insert(flipArea, scrOrgx  ) ---left
      table.insert(flipArea, scrOrgy ) ----up
      table.insert(flipArea, -scrOrgx  + _W*2 ) --right
      table.insert(flipArea, -scrOrgy + _H*2) --down

      table.insert(clickAreaL,scrOrgx)
      table.insert(clickAreaL,scrOrgy )
      table.insert(clickAreaL,scrOrgx+clickWidth)
      table.insert(clickAreaL,-scrOrgy  + _H*2)

      table.insert(clickAreaR, -scrOrgx  + _W*2 - clickWidth)
      table.insert(clickAreaR,scrOrgy )
      table.insert(clickAreaR,-scrOrgx + _W*2)
      table.insert(clickAreaR,-scrOrgy  + _H*2)
    end
    ----print("flipArea[2]111111=",flipArea[2])
    table.insert(allArea,scrOrgx)
    table.insert(allArea,scrOrgy)
    table.insert(allArea,-scrOrgx + _W*2)
    table.insert(allArea,-scrOrgy + _H*2)
   
    sceneGroup:insert(pageList) 
    sceneGroup:insert(bookmarkList) 

    sceneGroup:insert(bookmarkTextlist)

   -- sceneGroup:insert(textnum2)
   -- sceneGroup:insert(textnum1)

    if setupf == true then
      timer.performWithDelay( 10, showOption )
      --showOption()
    end
    loadpageList(1)

      bg:addEventListener("touch",testTimeFn)
      Runtime:addEventListener("touch",turnPagefn)
      Runtime:addEventListener( "orientation", onOrientationChange )
    

end

  local function split(pString, pPattern)
    local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
    local fpat = "(.-)" .. pPattern
    local last_end = 1
    local s, e, cap = pString:find(fpat, 1)
    while s do
      if s ~= 1 or cap ~= "" then
          table.insert(Table,cap)
        end
      last_end = e+1
      s, e, cap = pString:find(fpat, last_end)
    end

    if last_end <= #pString then
      cap = pString:sub(last_end)
      table.insert(Table, cap)
    end

    return Table
  end

function scene:show(event)

  gNaviBar.NaviBarShow(false)
  gOptnBar.OptnBarShow(false)
  gFootBar.FootBarShow(false)

  local ph = event.phase
  ------print("show_ph===",ph)
  if "will" == ph then
    ----print("99999999999999",last_composer,curr_composer)

    if  curr_composer ~= "hpage_online" then
      last_composer = curr_composer
      curr_composer = "hpage_online"
    end

     optionBoxUp = 88
    optionBoxDown = 150
    rota_composer = "hpage_online"
    local size = gSystem.calculateSize()
    fontSize = 25
    if size > 6 and size < 8 then
      optionrate = 1
      
    elseif size > 8 then
      fontSize = 20
      optionrate = 55/optionBoxUp
    else
      optionrate = 120/optionBoxUp
    end


  elseif "did" == ph then
   -- composer.removeScene("vpage")

    sceneGroup = self.view

  _W = display.contentWidth * 0.5
  _H = display.contentHeight * 0.5 
  pageH = _H + statusbarHeight*0.5
  --print("_H=",_H)
  scrOrgx = display.screenOriginX
  scrOrgy = display.screenOriginY

  bg = display.newRect( 0, 0, _W*2-scrOrgx*2, _H*2 - scrOrgy*2 )
  bg.x = _W
  bg.y = _H
  bg:setFillColor( 1 )
  bg.name = "bg"
  sceneGroup:insert(bg)

  flipArea = {}
  clickAreaL = {}
  clickAreaR = {}
  allArea = {}
  numTouches = 0
  mutitouchPos = {}
  centerx = 0 --多點觸控中心點
  centery = 0
  touchDistance = 0 ---每點到中心點距離
  mutitouchf = false
  touchnum = 0
  pname = {}
  bookmarkf = false
  numTouches = 0
  setupFirst = true
  scaleing = scalef
  chochapter = 0
  chobookmark = 0
  chobookmarkdel = 0
  chaptermove = false
  bookmarkmove = false
  mutimovefh = false
  mutimovefv = false
  markbmp = nil
  --nowrate = 1
  contscroll = nil
  bookmarkscroll = nil
  loadnum = 0
  pageList2 = wetools.creatonelist(0,maxPage)
  if _W == 640 then
    contwidth = (_W*2 -2*scrOrgx)*0.35
  else
    contwidth  = _W
  end
  thumbpage = 1

  chapterList = {}
  chapterpageList = {}

  loadingImg = gSystem.getLoading()
  loadingImg.x = display.contentWidth*0.5
  loadingImg.y = display.contentHeight*0.5
  loadingImg:scale( 0.6, 0.6 )
  loadingImg.isVisible = false
  loadingImg.alpha = 0.6

  clickWidth = math.max(150,(_W*2-2*scrOrgx)/8)
  
    ----print("bkcodebkcodebkcode", bkcode)
    
    local contents = {}
    if gProfile.BookInfo["chapter"] > 0 then
      for i = 1,gProfile.BookInfo["chapter"] do
        local tmp = "chapter"..i
        ----print("Field===",bookinfo.field[tmp])
       table.insert( contents,gProfile.BookInfo.field[tmp])
      end
    end
      
        
    for i = 1,#contents do
        local blist = split( contents[i] , "|" )

        table.insert( chapterList, blist[4] )
        table.insert(chapterpageList,blist[2])
    end   


  --chapterList ,chapterpageList =   gProfile.readchapter(choice_bookcode,baseDir)


  -- if bookmarkNumList == nil then
  
  --   bookmarkNumList = {}
  -- end
  
 --  _W = display.contentWidth * 0.5
 -- _H = display.contentHeight * 0.5
 -- scrOrgx = display.screenOriginX
 -- scrOrgy = display.screenOriginY

 _X = display.contentCenterX
 _Y = display.contentCenterY
 statusbarHeight = display.topStatusBarContentHeight

  -- local textnum2 = display.newText("pleft="..pleft ,100,100,native.systemFont,40)
  --     textnum2:setFillColor( 1,0,0 )
      
  --     local textnum1 = display.newText("p1="..p1 ,100,200,native.systemFont,40)
  --     textnum1:setFillColor( 1,0,0 )
       --sceneGroup:insert(textnum2)
  
  --- 下載第一頁

   sceneGroup:insert(loadingImg)


  local page = 0
  local pagenum = 0 ---下載數量

    local lastpage_path = system.pathForFile( choice_bookcode.."/lastpage.txt", baseDir )
    local fh, errStr = io.open( lastpage_path, "r" )
    
    if fh then
        page = fh:read("*a")
        page = tonumber(page)
        io.close(fh)

        if page % 2 == 1 then
          pleft = page
        else
          pleft = page+1
        end
          
        if currentOrientation == "landscapeLeft" or currentOrientation == "landscapeRight" then
          if pleft > 1 then
              p1 = pleft - 1
          else
              p1 = 1
          end
          
        else
          p1 = page
        end
       
    else
        local temp_path = system.pathForFile( "", baseDir )

            -- change current working directory
          local success = lfs.chdir( temp_path ) -- returns true on success
          --local new_folder_path
          
          if success then
             lfs.mkdir( choice_bookcode )
             lfs.mkdir(choice_bookcode.."thumb")
             --lfs.mkdir( bookinfo["bookcode"].."thumb" )
            -- new_folder_path = lfs.currentdir() .. "/" .. choice_bookcode
          end

        fh = io.open(lastpage_path, "w" )
        fh:write( "1" )
        
        io.close( fh )
        p1 = 1
        pleft = 1
        --print("l22222222")
    end

      if currentOrientation == "landscapeLeft" or currentOrientation == "landscapeRight" then
         

          if pleft == 1 then
            local nextpage_path = system.pathForFile( choice_bookcode.."/"..p1..".png", baseDir )
            local mode = lfs.attributes(nextpage_path, "mode")
            if mode == nil then
              loadpage(p1,false)
            else
              start()
            end
            --print("l333333")
          elseif pleft > maxPage then
            local nextpage_path = system.pathForFile( choice_bookcode.."/"..maxPage..".png", baseDir )
            local mode = lfs.attributes(nextpage_path, "mode")
            if mode == nil then
              loadpage(maxPage,false)
            else
              start()
            end
           
          else
            
            local nextpage_path = system.pathForFile( choice_bookcode.."/"..(pleft-1)..".png", baseDir )
            local mode = lfs.attributes(nextpage_path, "mode")

            local nextpage_path2 = system.pathForFile( choice_bookcode.."/"..(pleft)..".png", baseDir )
            local mode2 = lfs.attributes(nextpage_path2, "mode")
            
            ----print("fh===",fh)
            if mode == nil and mode2 == nil then
              loadpage2(pleft-1,false)
            elseif mode == nil then
              loadpage(pleft-1,false)
            elseif mode2 == nil then
              loadpage(pleft,false)
            else
              start()
            end

            -- if mode == nil then
            --    --print("l44444")
              
            -- elseif mode2 == nil then
            --   --print("l55555")
            --   loadpage(pleft,false)

            -- else
            --   --print("l666666")
            --   start()
            -- end

          end


      else
        local nextpage_path = system.pathForFile( choice_bookcode.."/"..p1..".png", baseDir )
          local mode = lfs.attributes(nextpage_path, "mode")
          if mode == nil then
            --print("load2")
            loadpage(p1,false)
          else

            start()
          end
      end
    
    
  end
end

function scene:hide(event)
  -- local ph = event.phase
  if "will" == ph then
    --print("hide......")
   
  end
end

--function scene:destroy( event )
function scene:destroy(event)

    print("destory")
    Runtime:removeEventListener("enterFrame",mutimoveFn)
    Runtime:removeEventListener("enterFrame",closeOptionFn)
    Runtime:removeEventListener("enterFrame", smallPageAutoMoveFn)
    Runtime:removeEventListener("enterFrame",mutiZoom)
    Runtime:removeEventListener("enterFrame",bigPageBackFn)
    Runtime:removeEventListener("enterFrame", bigPageFloatFn)            
    Runtime:removeEventListener("enterFrame", bigAutoFlipFn)
    Runtime:removeEventListener("orientation", onOrientationChange )
    Runtime:removeEventListener("enterFrame",backsmallpageFn)
    Runtime:removeEventListener("enterFrame",smallpageMoveFn)
    Runtime:removeEventListener("enterFrame",autoturnfn )
    Runtime:removeEventListener("enterFrame",pageZoom)
    Runtime:removeEventListener("enterFrame",contTime)
    Runtime:removeEventListener("touch",turnPagefn)
  --end
end


scene:addEventListener( "create",scene)
scene:addEventListener( "show",scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
