
--display.setStatusBar( display.HiddenStatusBar )

--module(..., package.seeall)

--os.execute('clear')
system.activate( "multitouch" )

--gConServ = require( "proc_download_number")
local composer = require "composer"
local wetools = require("wetools")
local scene = composer.newScene()
local movieclip = require("movieclip")
local widget = require( "widget" )
--physics.start()
--physics.setGravity( 0, 0 )
--local loadFile = nil
_W = display.contentWidth * 0.5
_H = display.contentHeight * 0.5 
_X = display.contentCenterX
_Y = display.contentCenterY
scrOrgx = display.screenOriginX
scrOrgy = display.screenOriginY
print("scrOrgx=",scrOrgx)
local optionrate = 1
local resumef = false
--local touchx = 0
--local touchy = 0
--local centx = 0
--local centy = 0
--local hx = 0
--local hy = 0
--local vx = 0
--local vy = 0
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
local dir = ""
local checkdir = true
local gof = false
local oldx = 0
local canautof= false
local textgroup = display.newGroup()
local optionGroup = display.newGroup( )
local sceneGroup = display.newGroup( ) 
local pageText = display.newText("",-10000,0,native.systemFont,30)
local contentGroup = display.newGroup( )
local optionItemGroup = display.newGroup( )
local smallPageGroup = display.newGroup()
local optionBoxUp = 88
local optionBoxDown = 150
local contwidth = (_W*2 -2*scrOrgx)*0.35
local clickWidth = 100
local flipArea = {}
--local clickAreaR
--local clickAreaL
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
local zoomrate2 = 0
----放大時彈回開關
local bigBackRight = false
local bigBackLeft = false
local bigBackUp = false
local bigBackDown = false
local bigautof = false
local bigVx = 0
local bigVy = 0
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
local delaytime = 0
local tapx = 0
local tapy = 0
local mf = false
local touchtime = 0
local numTouches = 0
local movieclip = require("movieclip")
local pname = {}
baseDir = system.DocumentsDirectory
resDir = system.ResourceDirectory
local path = choice_bookcode.."/"
local pngPath = system.pathForFile( path,baseDir )
local changeDir = lfs.chdir(pngPath)
--print("changedir=",changeDir)
local path_thumb = choice_bookcode.."thumb/"

local path_image = [[image/]]
local bookmarkf = false

local bookmarkNumList = nil
local scaleing = false
local bounds = 0
local bounds2 = 0
local bookinfoGroup = nil
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
local reloadBmp = nil
local helpBmp = nil
local thumbpage =1
local boxDown
local thumb
local backpage = nil
local pageH = _H + statusbarHeight*0.5
local loadnum = 0
--local optionBtnBase = nil
local fontSize = 25
local chapterBlock = nil
local bookinfoBox = nil
local contentBox = nil
local bookmarkBox = nil
--local bookmarkBack = nil
local bookmarkBlock = nil
local loadingImg = nil
local loadingf = false
local noticeGroup = display.newGroup( )
local exitf = false
local period = 300
--local missPageList = {}
local loadedNum = 20
local posNum = 0
local posThumbNum = 0

local loadTimePeriod = 19
local loadTimePeriod2 = 39

local checkMaxNum = maxPage
thumbPage = 1
loadThumbBmpf = false

--local loadedPageNum = 0
--local loadedThumbNum = 0
--local checkThumbList = {}
loadingBtn = nil
gWarning = nil
addPrecent = 0
--percentText = nil
local reloadf = false
local oldPrecent = 0

pageLong = 0.0

oldBallx = 0

--local alertf = false



--local del_dx = 0
function changeThumbMenu(page)
  local integer = 0
  if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then

     -- if pleft < smallPageGroup[1].no or pleft > smallPageGroup[smallPageGroup.numChildren-1].no then
        --changef = true
        integer = math.floor((page-1)/11)
        print("integer=====",integer)
      --end
  else
    --if p1 < smallPageGroup[1].no or p1 > smallPageGroup[smallPageGroup.numChildren-1].no then
       -- changef = true
        integer = math.floor((page-1)/11)
        print("integer=====",integer)
     -- end
  end

  --if changef == true then
    for i = 1,smallPageGroup.numChildren do
      display.remove( smallPageGroup[1])
      smallPageGroup[1] = nil
    end
    for i  = 1, 11 do
        

        local smallpage = nil
       
            local num = integer*11 + i
            print("num==",num)
          if num <= maxPage then
              local nextpage_path = system.pathForFile( path_thumb..num..".png", baseDir )
                local mode = lfs.attributes(nextpage_path, "mode")
                --
                if mode == nil then
                  smallpage = display.newRect( 0, 0, 100, 150 )
                  smallpage.alpha = 0.5
                else
                  smallpage = display.newImage( path_thumb..num..".png",baseDir)
                end   
            smallpage.orgwidth = smallpage.width
            smallpage.orgheight = smallpage.height
            smallpage.name = "book"..num   
            smallrate = (boxDown.height-60)/smallpage.height   
            smallpage:scale( smallrate, smallrate )
            smallpage.smallrate = smallrate  
            
            local width = (_W*2 - 40 - 11*smallpage.contentWidth- 2*scrOrgx)/10
            -- print("smallpage.width= ",smallpage.width)
            -- print("smallpage.contentWidth= ",smallpage.contentWidth)
            if i > 1 then
              local pos = (i-1)*2 - 1
              --width = (smallpage.contentWidth + smallPageGroup[pos].contentWidth)*0.5
            end
            if i ==1 then
              smallpage.x =   scrOrgx + 20 + smallpage.contentWidth*0.5
            else
              --if i % 2 == 0 then
                --smallpage.x = smallPageGroup[(i-1)*2].x + width 
                smallpage.x = scrOrgx + 20 + smallpage.contentWidth*0.5  + (i-1)*(smallpage.contentWidth+width)
              -- else
              --   smallpage.x = smallPageGroup[(i-1)*2].x + width
              -- end
            end
            smallpage.y = boxDown.lasty  - 20--smallpage.height*rate-45--
            smallpage.no = num
            smallpage.orgx = smallpage.x
            local pagenum = display.newText(tostring(num),0,0,native.systemFont,24)
            pagenum.x = smallpage.x
            pagenum.y = smallpage.y + smallpage.contentHeight*0.5+pagenum.height*0.5 + 10
            pagenum.no = num
            pagenum.smallrate = smallrate
            pagenum.smallpageWidth = smallpage.smallpageWidth
            smallPageGroup:insert(smallpage)
            smallPageGroup:insert(pagenum)
          end
      end
      for i = 1,11 do
    local pos = 2*i-1
    if pos <= smallPageGroup.numChildren then
      smallPageGroup[pos].width = smallPageGroup[pos].orgwidth
      smallPageGroup[pos].height = smallPageGroup[pos].orgheight
    end
  end
  --print("aaaaaaaaaa")
   if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
      --local smallpageOutline
      if pleft == 1  then
        -- if wetools.findone(pleft,bookmarkNumList) == false then
        --   markbmp:stopAtFrame(1)
        -- else
        --   markbmp:stopAtFrame(2)
        -- end 
        local tmp = smallPageGroup[1]
        if tmp.no == 1 then
          tmp.width = tmp.width*1.2
            tmp.height = tmp.height*1.2
        end
        -- local x1 = tmp.x-tmp.contentWidth*0.5
        -- local y1 = tmp.y-tmp.contentHeight*0.5
        -- local x2 = tmp.x+tmp.contentWidth*0.5
        -- local y2 = tmp.y+tmp.contentHeight*0.5
        -- smallpageOutline = display.newLine( x1-2, y1, x2, y1,x2,y2,x1,y2,x1,y1 )
        -- smallpageOutline:setStrokeColor( 1, 0, 0, 1 )
        -- smallpageOutline.strokeWidth = 6
      elseif pleft >= maxPage then
        local num = 0
        if pleft >= maxPage + 2 then
          pleft = pleft -2
        end
        if pleft > maxPage then
          -- if wetools.findone(pleft-1,bookmarkNumList) == false then
          --   markbmp:stopAtFrame(1)
          -- else
          --   markbmp:stopAtFrame(2)
          -- end
          local num0  = pleft%11
          if num0 == 0 then 
            num0 = 11
          end
          num = (num0-1)*2 - 1

          
           local tmp = smallPageGroup[num]
           if tmp.no == maxPage then
          
            tmp.width = tmp.width*1.2
            tmp.height = tmp.height*1.2
          end
          -- local x1 = tmp.x-tmp.contentWidth*0.5
          -- local y1 = tmp.y-tmp.contentHeight*0.5
          -- local x2 = tmp.x+tmp.contentWidth*0.5
          -- local y2 = tmp.y+tmp.contentHeight*0.5
          -- smallpageOutline = display.newLine( x1-2, y1, x2, y1,x2,y2,x1,y2,x1,y1 )
        else
          -- if wetools.findone(pleft,bookmarkNumList) == false and wetools.findone(pleft-1,bookmarkNumList) == false then
          --   markbmp:stopAtFrame(1)
          -- else
          --   markbmp:stopAtFrame(2)
          -- end
          local num = pleft%11
          if num == 0 then 
            num = 11
          end
          local num1 = num*2-1
          local num2 = (num-1)*2-1

          local tmp = smallPageGroup[num1]
          local tmp2 = smallPageGroup[num2]
         
            
             if tmp ~= nil then
              if tmp.no == pleft then
                tmp.width = tmp.width*1.2
                tmp.height = tmp.height*1.2
              end
            end
            if tmp2~= nil then
              if tmp2.no == pleft-1 then
                tmp2.width = tmp2.width*1.2
                tmp2.height = tmp2.height*1.2
              end
            end
          
          -- local x1 = tmp.x-tmp.contentWidth*0.5
          -- local y1 = tmp.y-tmp.contentHeight*0.5
          -- local x2 = tmp2.x+tmp2.contentWidth*0.5
          -- local y2 = tmp2.y+tmp2.contentHeight*0.5
          -- smallpageOutline = display.newLine( x1-2, y1, x2, y1,x2,y2,x1,y2,x1,y1 )
        end
        -- smallpageOutline:setStrokeColor( 1, 0, 0, 1 )
        -- smallpageOutline.strokeWidth = 6
      else
        -- if wetools.findone(pleft,bookmarkNumList) == false and wetools.findone(pleft-1,bookmarkNumList) == false then
        --   markbmp:stopAtFrame(1)
        -- else
        --   markbmp:stopAtFrame(2)
        -- end
        local num = pleft%11
        if num == 0 then 
          num = 11
        end
        local num1 = num*2-1
        local num2 = (num-1)*2-1

        local tmp = smallPageGroup[num1]
        local tmp2 = smallPageGroup[num2]
         
        if tmp ~= nil then
              if tmp.no == pleft then
                tmp.width = tmp.width*1.2
                tmp.height = tmp.height*1.2
              end
            end
            if tmp2~= nil then
              if tmp2.no == pleft-1 then
                tmp2.width = tmp2.width*1.2
                tmp2.height = tmp2.height*1.2
              end
            end
      end
      --smallPageGroup:insert(smallpageOutline)
  else
    -- if wetools.findone(p1,bookmarkNumList) == false then
    --   markbmp:stopAtFrame(1)
    -- else
    --   markbmp:stopAtFrame(2)
    -- end
    local smallpageOutline
    local pos = 0
    local num = p1%11
    if num == 0 then 
      num = 11
    end
    pos = (num*2-1)
    local tmp = smallPageGroup[pos]
    if tmp.no == p1 then
      tmp.width = tmp.width*1.2
            tmp.height = tmp.height*1.2
    end
  end

  
  if smallPageGroup.alpha == 0  then
      transition.to( smallPageGroup, { time=600, alpha = 1.0} )
  end
end

local function makeOutLine()
  -- local changef = false
  -- local integer = 0
  -- if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then

    
  --       integer = math.floor((pleft-1)/11)
  --       print("integer=====",integer)
     
  -- else
   
  --       integer = math.floor((p1-1)/11)
  --       print("integer=====",integer)
     
  -- end

  
  --   for i = 1,smallPageGroup.numChildren do
  --     display.remove( smallPageGroup[1])
  --     smallPageGroup[1] = nil
  --   end
  --   for i  = 1, 11 do
        

  --       local smallpage = nil
      
  --           local num = integer*11 + i
  --           print("num==",num)
  --         if num <= maxPage then
  --             local nextpage_path = system.pathForFile( path_thumb..num..".png", baseDir )
  --               local mode = lfs.attributes(nextpage_path, "mode")
  --               --
  --               if mode == nil then
  --                 smallpage = display.newRect( 0, 0, 100, 150 )
  --                 smallpage.alpha = 0.5
  --               else
  --                 smallpage = display.newImage( path_thumb..num..".png",baseDir)
  --               end   
  --           smallpage.orgwidth = smallpage.width
  --           smallpage.orgheight = smallpage.height
  --           smallpage.name = "book"..num   
  --           smallrate = (boxDown.height-60)/smallpage.height   
  --           smallpage:scale( smallrate, smallrate )
  --           smallpage.smallrate = smallrate  
            
  --           local width = (_W*2 - 40 - 11*smallpage.contentWidth- 2*scrOrgx)/10
           
  --           if i > 1 then
  --             local pos = (i-1)*2 - 1
  --             --width = (smallpage.contentWidth + smallPageGroup[pos].contentWidth)*0.5
  --           end
  --           if i ==1 then
  --             smallpage.x =   scrOrgx + 20 + smallpage.contentWidth*0.5
  --           else
  --             --if i % 2 == 0 then
  --               --smallpage.x = smallPageGroup[(i-1)*2].x + width 
  --               smallpage.x = scrOrgx + 20 + smallpage.contentWidth*0.5  + (i-1)*(smallpage.contentWidth+width)
  --             -- else
  --             --   smallpage.x = smallPageGroup[(i-1)*2].x + width
  --             -- end
  --           end
  --           smallpage.y = boxDown.lasty  - 20--smallpage.height*rate-45--
  --           smallpage.no = num
  --           smallpage.orgx = smallpage.x
  --           local pagenum = display.newText(tostring(num),0,0,native.systemFont,24)
  --           pagenum.x = smallpage.x
  --           pagenum.y = smallpage.y + smallpage.contentHeight*0.5+pagenum.height*0.5 + 10
  --           pagenum.no = num
  --           pagenum.smallrate = smallrate
  --           pagenum.smallpageWidth = smallpage.smallpageWidth
  --           smallPageGroup:insert(smallpage)
  --           smallPageGroup:insert(pagenum)
          
  --           smallpageWidth = smallpage.contentWidth
  --         end
  --   end

  --end
  -- for i = 1,11 do
  --   local pos = 2*i-1
  --   if pos <= smallPageGroup.numChildren then
  --     smallPageGroup[pos].width = smallPageGroup[pos].orgwidth
  --     smallPageGroup[pos].height = smallPageGroup[pos].orgheight
  --   end
  -- end
  --print("aaaaaaaaaa")

   if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
      --local smallpageOutline
      if pleft == 1  then
        if wetools.findone(pleft,bookmarkNumList) == false then
          markbmp:stopAtFrame(1)
        else
          markbmp:stopAtFrame(2)
        end 
        -- local tmp = smallPageGroup[1]
        -- tmp.width = tmp.width*1.2
        --     tmp.height = tmp.height*1.2
      
      elseif pleft >= maxPage then
        local num = 0
        if pleft >= maxPage + 2 then
          pleft = pleft -2
        end
        if pleft > maxPage then
          if wetools.findone(pleft-1,bookmarkNumList) == false then
            markbmp:stopAtFrame(1)
          else
            markbmp:stopAtFrame(2)
          end
          -- local num0  = pleft%11
          -- if num0 == 0 then 
          --   num0 = 11
          -- end
          -- num = (num0-1)*2 - 1

          
          --  local tmp = smallPageGroup[num]
          --  --local tmp2 = smallPageGroup[num+2]
          -- tmp.width = tmp.width*1.2
          --   tmp.height = tmp.height*1.2
        
        else
          if wetools.findone(pleft,bookmarkNumList) == false and wetools.findone(pleft-1,bookmarkNumList) == false then
            markbmp:stopAtFrame(1)
          else
            markbmp:stopAtFrame(2)
          end
          -- local num = pleft%11
          -- if num == 0 then 
          --   num = 11
          -- end
          -- local num1 = num*2-1
          -- local num2 = (num-1)*2-1
          -- local tmp = smallPageGroup[num1]
          -- local tmp2 = smallPageGroup[num2]
          --  if tmp ~= nil then
          --  tmp.width = tmp.width*1.2
          --   tmp.height = tmp.height*1.2
          -- end
          --   if tmp2~= nil then
          --     tmp2.width = tmp2.width*1.2
          --     tmp2.height = tmp2.height*1.2
          --   end
         
        end
       
      else
        if wetools.findone(pleft,bookmarkNumList) == false and wetools.findone(pleft-1,bookmarkNumList) == false then
          markbmp:stopAtFrame(1)
        else
          markbmp:stopAtFrame(2)
        end
        -- local num = pleft%11
        -- if num == 0 then 
        --   num = 11
        -- end
        -- local num1 = num*2-1
        -- local num2 = (num-1)*2-1

        -- local tmp = smallPageGroup[num1]
        -- local tmp2 = smallPageGroup[num2]
        --   if tmp ~= nil then
        --    tmp.width = tmp.width*1.2
        --     tmp.height = tmp.height*1.2
        --   end
        --     if tmp2~= nil then
        --       tmp2.width = tmp2.width*1.2
        --       tmp2.height = tmp2.height*1.2
        --     end
       
      end
      --smallPageGroup:insert(smallpageOutline)
      local tmpNum = pleft
      if tmpNum > maxPage then
        tmpNum = maxPage
      end
      smallPageGroup[4].text = tostring( tmpNum )
      smallPageGroup[2].x = smallPageGroup[2].orgx + (pleft - 1)*pageLong
  else
    if wetools.findone(p1,bookmarkNumList) == false then
      markbmp:stopAtFrame(1)
    else
      markbmp:stopAtFrame(2)
    end
    smallPageGroup[4].text = tostring( p1)
    smallPageGroup[2].x = smallPageGroup[2].orgx + (p1 - 1)*pageLong
    -- local smallpageOutline
    -- local pos = 0
    -- local num = p1%11
    -- if num == 0 then 
    --   num = 11
    -- end
    -- pos = (num*2-1)
    -- local tmp = smallPageGroup[pos]

    -- tmp.width = tmp.width*1.2
    --         tmp.height = tmp.height*1.2
   
  end

  if loadingf == true then
    loadingImg.isVisible = false
    optionItemf = false
    loadingf = false
  end


  -- if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
  --       if wetools.findone(pleft,bookmarkNumList) == false and wetools.findone(pleft-1,bookmarkNumList) == false then
  --         markbmp:stopAtFrame(1)
  --       else
  --         markbmp:stopAtFrame(2)
  --       end
  -- else
  --   if wetools.findone(p1,bookmarkNumList) == false then
  --     markbmp:stopAtFrame(1)
  --   else
  --     markbmp:stopAtFrame(2)
  --   end
  -- end
end

function smallPageAutoMoveFn(event)
  if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
    local dx = 0
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
  --直
    local dx = 0
    if backLeft == true then
      dx = _W*2 - scrOrgx - 20 -smallPageGroup[p1*2-1].contentWidth*0.5 - smallPageGroup[p1*2-1].x +scrOrgx
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

function gobookmarkFn(event)
  local ph = event.phase 
  local etar = event.target
  if ph == "began" then   
    -- if bookmarkBlock ~= nil then
    --   bookmarkBlock:setFillColor( 221/255 )
    --   --bookmarkBlock.alpha = 0.05
    --   bookmarkBlock.isVisible = false
    --   bookmarkBlock.isHitTestable = true
    -- end
    --print("")
    -- etar.width = contwidth
    -- etar.x =  etar.contentWidth*0.5
    -- etar:setFillColor( 182/255 )
    -- etar.alpha = 0.85
    -- etar.isVisible = true
    bookmarkBlock = etar
    chobookmark = event.target.no
  end
end

function delbookmarkFn(event)
  local ph = event.phase
  local etar = event.target 
  if ph == "began" then
    display.remove( bookmarkBlock )
    bookmarkBlock = nil
    chobookmarkdel = etar.no 
  end
end

function nextPageLoad(event)
  loadAllPageFn(posNum)
end
function nextThumbLoad(event)
  loadAllThumbFn(posThumbNum)
end

local idPath = choice_bookcode .. "/"
local pagePath = system.pathForFile( idPath.."check.txt", system.DocumentsDirectory )
local thumbPath = system.pathForFile( idPath.."checkThumb.txt", system.DocumentsDirectory )
function loadAllPageFn(page)
        -- print("page=",page)
        -- print("pos=",pos)
       -- print("下載第幾頁=",page)
        local params = {}  params.progress = true
        local dpi = "150"
        local function networkListener( event )
          if ( event.isError ) then
            local alert = native.showAlert( "Network Error !!", "Please make sure internet connected and try again", { "OK" }, onComplete )
            --gNetworkStatus = false
          elseif ( event.phase == "began" ) then
            --checkList[pos] = 0
            --print("thumbPos=",pos,checkThumbList[pos])
           

          elseif ( event.phase == "ended" ) then
            --loadedNum = loadedNum + 1
            --print("loadednum2=",loadedNum)
            
            -- addPrecent = addPrecent + 1
              local currScene = composer.getSceneName( "current" )
              if currScene == "hpage" or currScene == "trans" then
                posNum = posNum + 1
                print("posNum===",posNum)
                if posNum <= maxPage then
                  gNowPrecent  =  math.floor((posNum/maxPage)*100)
                  
                 -- local path = system.pathForFile( idPath.."check.txt", system.DocumentsDirectory )
                    
                  local fh, errStr = io.open( pagePath, "w" )
                  if fh then
                    fh:write( posNum )
                    io.close( fh )
                  end
                  timer.performWithDelay( 200, nextPageLoad, 1 )
                  --loadAllPageFn(posNum)
                else
                  checkOver = 1
                  loadingBtn.isVisible = false
                  loadingText.isVisible = false
                  gLoading = false
                end
                if gNowPrecent > 100 then
                  gNowPrecent = 100
                end

                local idPath = choice_bookcode .. "/"
           print("gNowPrecent======== ",gNowPrecent)
              local path = system.pathForFile( idPath.."precent.txt", baseDir )
              local fh, errStr = io.open( path, "w" )
              if fh then
                fh:write( gNowPrecent )
                io.close( fh )
              else
                fh:write( gNowPrecent )
                io.close( fh )
              end

                loadingText.text = gNowPrecent.."%"
              end
         
            
          end
        end
         
                    local nextpage_path = system.pathForFile( path..page..".png", baseDir )
                    local mode = lfs.attributes(nextpage_path, "mode")                                          
          if mode ==  nil then
            network.download(
              --gConServ.getURL()  .. page .. "/" .. dpi .. "/content.png",
              "http://license.acs.igpublish.com/igpspot/bkdoor/" ..gPubid.. "/" ..gDocid.. "/" .. page.."/"..dpi .. "/content.png",
              "GET",
              networkListener,
              params,
              choice_bookcode.."/"..page..".png", -- put subfolder path here
              system.DocumentsDirectory
              )
          else
            local currScene = composer.getSceneName( "current" )
            if currScene == "hpage" or currScene == "trans" then
              posNum = posNum + 1
              --print("posNum")
              -- if posNum < maxPage then
              --   timer.performWithDelay( 200, nextPageLoad, 1 )

              -- end

              if posNum <= maxPage then
                 -- gNowPrecent  =  math.floor((posNum/maxPage)*100)
                  
                 -- local path = system.pathForFile( idPath.."check.txt", system.DocumentsDirectory )
                    
                  -- local fh, errStr = io.open( pagePath, "w" )
                  -- if fh then
                  --   fh:write( posNum )
                  --   io.close( fh )
                  -- end
                  timer.performWithDelay( 200, nextPageLoad, 1 )
                  --loadAllPageFn(posNum)
                else
                  checkOver = 1
                  loadingBtn.isVisible = false
                  loadingText.isVisible = false
                  gLoading = false
                end
                -- if gNowPrecent > 100 then
                --   gNowPrecent = 100
                -- end

           --      local idPath = choice_bookcode .. "/"
           -- print("gNowPrecent======== ",gNowPrecent)
           --    local path = system.pathForFile( idPath.."precent.txt", baseDir )
           --    local fh, errStr = io.open( path, "w" )
           --    if fh then
           --      fh:write( gNowPrecent )
           --      io.close( fh )
           --    else
           --      fh:write( gNowPrecent )
           --      io.close( fh )
           --    end

           --      loadingText.text = gNowPrecent.."%"
          end
        end
      
       
      
  
end

function loadAllThumbFn(page)
  
        local params = {}  params.progress = true
        --local pageNum = checkThumbNum
        local function networkListener( event )
          if ( event.isError ) then
            local alert = native.showAlert( "Network Error !!", "Please make sure internet connected and try again", { "OK" }, onComplete )
           -- gNetworkStatus = false
          elseif ( event.phase == "began" ) then
            
            --checkThumbList[pos] = 0
            --print("thumbPos=",pos,checkThumbList[pos])
          elseif ( event.phase == "ended" ) then
            --print("page = ",page)
              local currScene = composer.getSceneName( "current" )
              if currScene == "hpage" or currScene == "trans" then
                posThumbNum = posThumbNum + 1
                -- if txt == nil then
                --   txt = display.newText( "nowpage=:"..tostring(posThumbNum).."/"..tostring(maxPage), _X, _Y, native.systemFontBold, 50 )
                -- else 
                --   txt.text = "nowpage=:"..tostring(posThumbNum).."/"..tostring(maxPage)
                -- end

                if posThumbNum <= maxPage then
                 
                  --local idPath = choice_bookcode .. "/"
                  --local path = system.pathForFile( idPath.."checkThumb.txt", system.DocumentsDirectory )
                  --print("loadthumb.....",posThumbNum)
                  local fh, errStr = io.open( thumbPath, "w" )
                  if fh then
                    fh:write( posThumbNum )
                    io.close( fh )
                  end

                  -- if posThumbNum-1 >= smallPageGroup[1].no and posThumbNum-1 <= smallPageGroup[smallPageGroup.numChildren-1].no then
                   
                  --   changeThumbMenu(posThumbNum-1)
                  
                  --   timer.performWithDelay( 200, nextThumbLoad, 1 )
                  -- else
                    timer.performWithDelay( 100, nextThumbLoad, 1 )
                  --end
                  -- thumbPage = 1
                  -- loadThumbBmpf = false

                  -- if posThumbNum - thumbPage > 10 then
                  --   if loadThumbBmpf == false then
                  --     loadThumbBmpf = true
                  --     loadThumbBmp(thumbPage)
                  --   end
                  -- end


                 --  local smallpage = nil
                 --  local nextpage_path = system.pathForFile( path_thumb..page..".png", baseDir )

                 --  smallpage = display.newImage( path_thumb..page..".png",baseDir)
                 --  --print("smallpage.width=",smallpage.widht)
                 --  --if smallpage.width == 0 or smallpage.width == nil then
                 --  if smallpage == nil then
                 --    display.remove( smallpage )
                 --    smallpage = nil
                 --    smallpage = display.newRect( 0, 0, 100, 150 )
                  
                   
                 --  end

                 --  smallpage.x = -100000
                 --   --下載thumb完成
                 --  smallpage.name = "book"..page   
                 --  smallrate = (boxDown.height-40)/smallpage.height   
                 --  smallpage:scale( smallrate, smallrate )
                 --  smallpage.smallrate = smallrate  
                 --  local nowPos = 2*page - 1
                 -- -- print("nowPos=",nowPos)
                 --  local width = 0 
                 --  if page > 1 then
                 --    local pos = (page-1)*2 - 1
                 --    width = (smallpage.contentWidth + smallPageGroup[pos].contentWidth)*0.5
                 --  end
                 --  if page ==1 then
                 --    smallpage.x =   scrOrgx + 20 + smallpage.contentWidth*0.5
                 --  else
                 --    if page % 2 == 0 then
                 --      smallpage.x = smallPageGroup[(page-1)*2].x + width + 20
                 --    else
                 --      smallpage.x = smallPageGroup[(page-1)*2].x + width
                 --    end
                 --  end
                 --  smallpage.y = boxDown.lasty  - 10--smallpage.height*rate-45--
                 --  smallpage.no = page
                 --  smallpage.orgx = smallpage.x
                 --  smallPageGroup:remove( nowPos )
                 --  smallPageGroup:insert( nowPos, smallpage  )
                

                  --loadAllThumbFn(posThumbNum)
                  
                else
                 
                  -- if posThumbNum-1 >= smallPageGroup[1].no and posThumbNum-1 <= smallPageGroup[smallPageGroup.numChildren-1].no then
                   
                  --   changeThumbMenu(posThumbNum-1)
                  -- end
                  checkThumbOver = 1
                end
              end
            
          end
        end

          local nextpage_path = system.pathForFile( path_thumb..page..".png", baseDir )
          local mode = lfs.attributes(nextpage_path, "mode")
          if mode == nil then
            network.download(
              --gConServ.getURL()  .. page .. "/thumbnail.png",
              "http://license.acs.igpublish.com/igpspot/bkdoor/" ..gPubid.. "/" ..gDocid.. "/" .. page.."/" .. "/thumbnail.png",
              "GET",
              networkListener,
              params,
              choice_bookcode.."thumb/"..page..".png", -- put subfolder path here
              system.DocumentsDirectory
            )
          else
              local currScene = composer.getSceneName( "current" )
              if currScene == "hpage" or currScene == "trans" then
                posThumbNum = posThumbNum + 1
                if posThumbNum < maxPage then
                  timer.performWithDelay( 200, nextThumbLoad, 1 )
                end
              end
          end
        --Runtime:removeEventListener("enterFrame",loadAllThumbFn)
 
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

local function Button_No2(top)
        -- button event
        local justPressed = function(event)
            if event.phase == "ended" then
                  optionItemf = false
                  exitf = false
                  
                  for i=1,noticeGroup.numChildren do
                    display.remove( noticeGroup[1] )
                    noticeGroup[1] = nil
                  end
                  if gLastPage > 1 then
                    if gEnterBookf == false then
                      gEnterBookf = true
                      jumpLastPageConfirm()
                    end
                  end
                 -- jumpLastPageConfirm()
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

function downProcess()
  loadingBtn.isVisible = true
               loadingText.isVisible = true
               gLoading = true
             
               loadAllPageFn(posNum)
               if checkThumbOver == 0 then
              
               loadAllThumbFn(posThumbNum)
              end
            

              if reloadf == true then
                reloadf = false
                loadingBtn.isVisible = true
                loadingText.isVisible = true
                gLoading = true
                if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
                  if pleft == 1 then
                    local nextpage_path = system.pathForFile( choice_bookcode.."/"..p1..".png", baseDir )
                    local mode = lfs.attributes(nextpage_path, "mode")
                    if mode == nil then
                      loadpage(p1)
                      
                    end
                  elseif pleft > maxPage then
                    local nextpage_path = system.pathForFile( choice_bookcode.."/"..maxPage..".png", baseDir )
                    local mode = lfs.attributes(nextpage_path, "mode")
                    if mode == nil then
                      loadpage(maxPage)
                      
                      
                    end    
                  else   
                    local nextpage_path = system.pathForFile( choice_bookcode.."/"..(pleft-1)..".png", baseDir )
                    local mode = lfs.attributes(nextpage_path, "mode")
                    local nextpage_path2 = system.pathForFile( choice_bookcode.."/"..(pleft)..".png", baseDir )
                    local mode2 = lfs.attributes(nextpage_path2, "mode")
                    if mode == nil and mode2 == nil then
                      loadpage2(pleft-1)
                      
                    elseif mode == nil then
                      loadpage(pleft-1)
                      
                    elseif mode2 == nil then
                      loadpage(pleft)   
                      
                    end
                  end
                else
                  local nextpage_path = system.pathForFile( choice_bookcode.."/"..p1..".png", baseDir )
                  local mode = lfs.attributes(nextpage_path, "mode")
                  if mode == nil then
                   -- print("reload......")
                    loadpage(p1)  
                    
                  end
                end
              end
              --gTransf
              --gEnterBookf
              optionItemf = false
              exitf = false
              for i=1,noticeGroup.numChildren do
                    display.remove( noticeGroup[1] )
                    noticeGroup[1] = nil
              end

              if gLastPage > 1  then
                if gEnterBookf == false then
                  gEnterBookf = true
                  jumpLastPageConfirm()
                end
              end
              
            --end
end


local function Button_Yes2(top)
        -- button event
        local justPressed = function(event)
            if event.phase == "ended" then
              

            
               loadingBtn.isVisible = true
               loadingText.isVisible = true
               gLoading = true
               print("load...........")
               loadAllPageFn(posNum)
                
              if checkThumbOver == 0 then
              
               loadAllThumbFn(posThumbNum)
              end
            

              if reloadf == true then
                reloadf = false
                loadingBtn.isVisible = true
                loadingText.isVisible = true
                gLoading = true
                if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
                  if pleft == 1 then
                    -- local nextpage_path = system.pathForFile( choice_bookcode.."/"..pleft..".png", baseDir )
                    -- local mode = lfs.attributes(nextpage_path, "mode")
                    -- if mode == nil then
                      loadpage(pleft)
                      
                    --end
                  elseif pleft > maxPage then
                    -- local nextpage_path = system.pathForFile( choice_bookcode.."/"..maxPage..".png", baseDir )
                    -- local mode = lfs.attributes(nextpage_path, "mode")
                    -- if mode == nil then
                      loadpage(maxPage)
                      
                      
                    --end    
                  else   
                    -- local nextpage_path = system.pathForFile( choice_bookcode.."/"..(pleft-1)..".png", baseDir )
                    -- local mode = lfs.attributes(nextpage_path, "mode")
                    -- local nextpage_path2 = system.pathForFile( choice_bookcode.."/"..(pleft)..".png", baseDir )
                    -- local mode2 = lfs.attributes(nextpage_path2, "mode")
                    -- if mode == nil and mode2 == nil then
                      loadpage2(pleft-1)
                      
                    -- elseif mode == nil then
                    --   loadpage(pleft-1)
                      
                    -- elseif mode2 == nil then
                    --   loadpage(pleft)   
                      
                    -- end
                  end
                else
                  -- local nextpage_path = system.pathForFile( choice_bookcode.."/"..p1..".png", baseDir )
                  -- local mode = lfs.attributes(nextpage_path, "mode")
                  -- if mode == nil then
                   -- print("reload......")
                    loadpage(p1)  
                    
                  --end
                end
              end
              --gTransf
              --gEnterBookf
              optionItemf = false
              exitf = false
              for i=1,noticeGroup.numChildren do
                    display.remove( noticeGroup[1] )
                    noticeGroup[1] = nil
              end

              if gLastPage > 1  then
                if gEnterBookf == false then
                  gEnterBookf = true
                  jumpLastPageConfirm()
                end
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
        button.name = "Btn_confirm"
        --BlockGroup:insert(button)
        return button
    end

local function Button_Yes3(top)

  local justPressed = function(event)
      if event.phase == "ended" then
      optionItemf = false
      exitf = false
        jumpchapter(gLastPage)
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
        button.name = "Btn_lastpageconfirm"
        --BlockGroup:insert(button)
        return button
end

local function downloadConfirm()
  if exitf == false then
    print("_W==",_W)
    local bg = display.newRect( _W, _H, _W*2-display.screenOriginX*2, _H*2-display.screenOriginY*2 )
        bg:setFillColor( 0 )
        bg.alpha = 0.7
        exitf = true
        local text = "You have downloaded "..gNowPrecent .."% pages, do you like to continue the loading process?"
        local noticetext = display.newText( text ,0,0,_W*1.6,0,native.systemFontBold,40)
        noticetext:setFillColor( 1)
        noticetext.x = _W
        noticetext.y = _H - 100

        local yestext = Button_Yes2(noticetext.y+150)
        local notext  = Button_No2(noticetext.y+150)


        noticeGroup:insert(bg)
        noticeGroup:insert(noticetext)
        noticeGroup:insert(yestext)
        noticeGroup:insert(notext)
        noticeGroup:toFront( )
  end
end

function jumpLastPageConfirm()
    local bg = display.newRect( _W, _H, _W*2-display.screenOriginX*2, _H*2-display.screenOriginY*2 )
        bg:setFillColor( 0 )
        bg.alpha = 0.7
       -- print("aaaaaaaaaa")
        exitf = true
        local noticetext = display.newText( "Do you like to start reading from last viewed page ?" ,0,0,display.contentWidth*0.8,0,native.systemFontBold,40)
        noticetext:setFillColor( 1)
        noticetext.x = _W
        noticetext.y = _H - 100

        local yestext = Button_Yes3(noticetext.y+150)
        local notext  = Button_No(noticetext.y+150)


        noticeGroup:insert(bg)
        noticeGroup:insert(noticetext)
        noticeGroup:insert(yestext)
        noticeGroup:insert(notext)
        noticeGroup:toFront( )
end


local function startLoadFn()
  

  --   local function networkListener( event )
  --     if ( event.isError ) then
       
  --     else
  --       if checkOver == 0 then
  --         posNum = 2
  --         Runtime:addEventListener("enterFrame",contLoadFn)
  --       end
  --       if checkThumbOver == 0 then
  --         posThumbNum = 2
  --         Runtime:addEventListener("enterFrame",contThumbLoadFn)
  --       end
  --     end
  --   end

  -- network.request( "https://www.google.com", "GET", networkListener )
  
    
  --  print("沒有連線了")
    if checkOver == 0  then 
      loadingText.isVisible = true
    end
    if gNetworkStatus == true then
     -- print("連線了")


      if checkOver == 0 then
        if gFirstEnterBook == true then
          downProcess()
        else
         -- network.setStatusListener( "www.google.com", networkListener )
          -- if showtext == nil then
          --       showtext = display.newText( tostring( gWifi ), _W, _H, native.systemFontBold, 50 )
          --       showtext:setFillColor( 0 )
          --   else
          --     showtext.text = tostring(tostring( gWifi))
          --   end
          --   showtext:toFront( )

          if gWifi == true then
            downProcess()
          else
            downloadConfirm()
            
          end
        end
        --   loadingBtn.isVisible = true
        --   print("loadingBtn.x=",loadingBtn.x)
        --   print("loadingBtn.y=",loadingBtn.y)
        --   posNum = 21
        --   Runtime:addEventListener("enterFrame",contLoadFn)

        -- end
        -- if checkThumbOver == 0 then
        --   posThumbNum = 21
        --   Runtime:addEventListener("enterFrame",contThumbLoadFn)
        -- end
      else
        --檢查最後一頁

        

        if gLastPage > 1 then
          if gEnterBookf == false then
            gEnterBookf = true
            jumpLastPageConfirm()
          end
        end
      end

    end
  
  
end

function loadThumbBmpOne(smallpage,page)
  --local smallpage = nil
                  -- local nextpage_path = system.pathForFile( path_thumb..page..".png", baseDir )

                  -- smallpage = display.newImage( path_thumb..page..".png",baseDir)
                  -- --print("smallpage.width=",smallpage.widht)
                  -- --if smallpage.width == 0 or smallpage.width == nil then
                  -- if smallpage == nil then
                  --   display.remove( smallpage )
                  --   smallpage = nil
                  --   smallpage = display.newRect( 0, 0, 100, 150 )
                  --   smallpage.alpha = 0.5
                   
                  -- end

                  --smallpage.x = -100000
                   --下載thumb完成
                  smallpage.name = "book"..page 
                 -- print("smallpage.height=",smallpage.height)
                  if smallpage.height ~= nil and boxDown.height~= nil then  
                    smallrate = (boxDown.height-60)/smallpage.height   
                    smallpage:scale( smallrate, smallrate )
                    smallpage.smallrate = smallrate  
                    local nowPos = 2*page - 1
                   -- print("nowPos=",nowPos)
                    local width = 0 
                    if page > 1 then
                      local pos = (page-1)*2 - 1
                      width = (smallpage.contentWidth + smallPageGroup[pos].contentWidth)*0.5
                    end
                    if page ==1 then
                      smallpage.x =   scrOrgx + 20 + smallpage.contentWidth*0.5
                    else
                      if page % 2 == 0 then
                        smallpage.x = smallPageGroup[(page-1)*2].x + width + 20
                      else
                        smallpage.x = smallPageGroup[(page-1)*2].x + width
                      end
                    end
                    smallpage.y = boxDown.lasty  - 10--smallpage.height*rate-45--
                    smallpage.no = page
                    smallpage.orgx = smallpage.x
                    smallPageGroup:remove( nowPos )
                    smallPageGroup:insert( nowPos, smallpage  )
                    --if pleft == page then
                      makeOutLine()
                    --end
                end
end

function loadThumbBmp()
  local page = thumbPage
  --print("thumbPage=====",thumbPage)
  if page <= posThumbNum then
      --local pos = (page-1)*2 - 1
      --if smallPageGroup[pos].alpha ~= nil and smallPageGroup[pos].alpha == 0.5 then
            local smallpage = nil
                  local nextpage_path = system.pathForFile( path_thumb..page..".png", baseDir )

                  smallpage = display.newImage( path_thumb..page..".png",baseDir)
                  --print("smallpage.width=",smallpage.widht)
                  --if smallpage.width == 0 or smallpage.width == nil then
                 -- print("smallpage=",smallpage.width)
                  if smallpage == nil or smallpage.width == nil or smallpage.width == 0 then
                    -- display.remove( smallpage )
                    -- smallpage = nil
                    -- smallpage = display.newRect( 0, 0, 100, 150 )
                    -- smallpage.alpha = 0.5
                    --timer.performWithDelay( 5000, startLoadThumb)
                  else

                      smallpage.x = -100000
                       --下載thumb完成
                      smallpage.name = "book"..page 
                      if smallpage.height ~= nil and boxDown.height~= nil then  
                        smallrate = (boxDown.height-40)/smallpage.height   
                        smallpage:scale( smallrate, smallrate )
                        smallpage.smallrate = smallrate  
                        local nowPos = 2*page - 1
                       -- print("nowPos=",nowPos)
                        local width = 0 
                        if page > 1 then
                          local pos = (page-1)*2 - 1
                          width = (smallpage.contentWidth + smallPageGroup[pos].contentWidth)*0.5
                        end
                        if page ==1 then
                          smallpage.x =   scrOrgx + 20 + smallpage.contentWidth*0.5
                        else
                          if page % 2 == 0 then
                            smallpage.x = smallPageGroup[(page-1)*2].x + width + 20
                          else
                            smallpage.x = smallPageGroup[(page-1)*2].x + width
                          end
                        end
                        smallpage.y = boxDown.lasty  - 10--smallpage.height*rate-45--
                        smallpage.no = page
                        smallpage.orgx = smallpage.x
                        smallPageGroup:remove( nowPos )
                        smallPageGroup:insert( nowPos, smallpage  )
                        if pleft == page then
                          makeOutLine()
                        end
                        thumbPage = thumbPage + 1
                      timer.performWithDelay( 100, startLoadThumb)
                    end
              end
          --end
  else
    loadThumbBmpf = false
  end
  
end
function startLoadThumb(e)
  loadThumbBmp(thumbPage)
end

jumpNum = 1
--ballMovef = false
function boxDownFn(e)
  if mutitouchf == false and gBackToScale == false then
            local ph = e.phase
            print("smallpagePh=",ph)
            --local tmpNum = 1
            if ph == "began" then
              oldBallx = e.xStart
              smallPageGroup[2].moved = true
              if e.xStart >= smallPageGroup[2].orgx and e.xStart <= smallPageGroup[2].lastx then
                smallPageGroup[2].x = e.xStart
                     jumpNum = (smallPageGroup[2].x - smallPageGroup[2].orgx)/pageLong
                      jumpNum = math.round( jumpNum) + 1
                      if jumpNum < 1 then
                        jumpNum = 1
                      end
                      if jumpNum > maxPage then
                        jumpNum = maxPage
                      end
                      
              else
                  if e.xStart < smallPageGroup[2].orgx then
                      jumpNum = 1
                      smallPageGroup[2].x = smallPageGroup[2].orgx
                    end
                    if e.xStart > smallPageGroup[2].lastx then
                      jumpNum = maxPage
                      smallPageGroup[2].x = smallPageGroup[2].lastx
                    end
              end

              smallPageGroup[4].text = tostring(jumpNum)
                      if thumbImg ~= nil then
                          display.remove(thumbImg)
                          thumbImg = nil
                        end
                        local nextpage_path = system.pathForFile( path_thumb..jumpNum..".png", baseDir )
                          local mode = lfs.attributes(nextpage_path, "mode")
                          --
                          local img = nil
                          local back = nil
                          if mode == nil then
                            img = display.newRect( 0, 0, 150, 200 )
                            img.alpha = 0.5
                            back = display.newRect(  0, 0, 170, 220 )
                            back:setFillColor(0.7)
                          else
                            img = display.newImage( path_thumb..jumpNum..".png",baseDir)
                            back = display.newRect(  0, 0, img.width + 20, img.height + 20 )
                            back:setFillColor(0.7)
                          end   
                          thumbImg= display.newGroup( )
                          thumbImg:insert(back)
                          thumbImg:insert( img )
                          thumbImg:scale( 2, 2 )
                          thumbImg.x = _X
                          thumbImg.y = _Y
                          sceneGroup:insert( thumbImg )
            elseif ph == "moved" then
                local x = e.x + smallPageGroup[2].dx
                
                  if x >= smallPageGroup[2].orgx and x <= smallPageGroup[2].lastx then
                    smallPageGroup[2].x = x
                     jumpNum = (smallPageGroup[2].x - smallPageGroup[2].orgx)/pageLong
                      jumpNum = math.round( jumpNum) + 1
                      if jumpNum < 1 then
                        jumpNum = 1
                      end
                      if jumpNum > maxPage then
                        jumpNum = maxPage
                      end
                      
                      
                  else
                    print("bbbbbbb")
                    --local x = e.x + smallPageGroup[2].dx
                    if x < smallPageGroup[2].orgx then
                      jumpNum = 1
                      smallPageGroup[2].x = smallPageGroup[2].orgx
                    end
                    if x > smallPageGroup[2].lastx then
                      smallPageGroup[2].x = smallPageGroup[2].lastx
                      jumpNum = maxPage
                    end
                  end
                  smallPageGroup[4].text = tostring(jumpNum)
                      if math.abs(e.x - oldBallx) <= 10 then
                        if thumbImg ~= nil then
                          display.remove(thumbImg)
                          thumbImg = nil
                        end
                          local nextpage_path = system.pathForFile( path_thumb..jumpNum..".png", baseDir )
                          local mode = lfs.attributes(nextpage_path, "mode")
                          --
                          local img = nil
                          local back = nil
                          if mode == nil then
                            img = display.newRect( 0, 0, 150, 200 )
                            img.alpha = 0.5
                            back = display.newRect(  0, 0, 170, 220 )
                            back:setFillColor(0.7)
                          else
                            img = display.newImage( path_thumb..jumpNum..".png",baseDir)
                            back = display.newRect(  0, 0, img.width + 20, img.height + 20 )
                            back:setFillColor(0.7)
                          end   
                          thumbImg= display.newGroup( )
                          thumbImg:insert(back)
                          thumbImg:insert( img )
                          thumbImg:scale( 2, 2 )
                          thumbImg.x = _X
                          thumbImg.y = _Y
                          sceneGroup:insert( thumbImg )
                      end
                      oldBallx = e.x
            elseif ph == "ended" or ph == "canceled" then
            
                if thumbImg ~= nil then
                          display.remove(thumbImg)
                          thumbImg = nil
                        end
                smallPageGroup[2].moved = false
                jumpNum = (smallPageGroup[2].x - smallPageGroup[2].orgx)/pageLong
                      jumpNum = math.round( jumpNum) + 1
                      if jumpNum < 1 then
                        jumpNum = 1
                      end
                      if jumpNum > maxPage then
                        jumpNum = maxPage
                      end
                      smallPageGroup[4].text = tostring(jumpNum)

                   if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
                      if pleft ~= jumpNum then
                        --pleft = tmpNum
                        jumpchapter(jumpNum)
                      end
                   else
                      if p1 ~= jumpNum then
                        jumpchapter(jumpNum)
                      end
                   end
            end
  end
  return true
end
thumbImg = nil
newBallx = 0

function ballTouchFn(e)
  if optionItemf == false and exitf == false and optionf == true and autof == false and mutitouchf == false and gBackToScale == false then
        local ph = e.phase
        local etar = e.target
        print("ballph=",ph)
       -- local stage = display.getCurrentStage()
        if ph == "began" then
          etar.dx = etar.x - e.xStart 
          --etar.dy = etar.y - e.yStart 
          --etar.isFoucs = true
          etar.moved = true
          oldBallx = e.xStart

        elseif ph == "moved" then
          if etar.moved == true then
            local x = e.x + etar.dx
            if x >= etar.orgx and x <= etar.lastx then
              etar.x = x
              local tmpNum = (etar.x - etar.orgx)/pageLong
              tmpNum = math.round( tmpNum) + 1
              if tmpNum < 1 then
                tmpNum = 1
              end
              if tmpNum > maxPage then
                tmpNum = maxPage
              end
              smallPageGroup[4].text = tostring(tmpNum)
              print("math.abs(e.x - oldBallx)===",math.abs(e.x - oldBallx))
              if math.abs(e.x - oldBallx) <= 10 then
                if thumbImg ~= nil then
                  display.remove(thumbImg)
                  thumbImg = nil
                end
                  local nextpage_path = system.pathForFile( path_thumb..tmpNum..".png", baseDir )
                  local mode = lfs.attributes(nextpage_path, "mode")
                  --
                  local img = nil
                  local back = nil
                  if mode == nil then
                    img = display.newRect( 0, 0, 150, 200 )
                    img.alpha = 0.5
                    back = display.newRect(  0, 0, 170, 220 )
                    back:setFillColor(0.7)
                  else
                    img = display.newImage( path_thumb..tmpNum..".png",baseDir)
                    back = display.newRect(  0, 0, img.width + 20, img.height + 20 )
                    back:setFillColor(0.7)
                  end   
                  thumbImg= display.newGroup( )
                  thumbImg:insert(back)
                  thumbImg:insert( img )
                  print("thumbImg.width111= ",thumbImg.contentWidth)
                  thumbImg:scale( 2, 2 )
                  print("thumbImg.width= ",thumbImg.contentWidth)
                  thumbImg.x = _X
                  thumbImg.y = _Y

                  sceneGroup:insert( thumbImg )
              else
                if thumbImg ~= nil then
                  display.remove(thumbImg)
                  thumbImg = nil
                end
              end
              oldBallx = e.x
            end
          end
          --etar.y = e.y + etar.dy
        elseif ph == "ended" then

           etar.moved = false
           local tmpNum = (etar.x - etar.orgx)/pageLong
              tmpNum = math.round( tmpNum) + 1
              if tmpNum < 1 then
                tmpNum = 1
              end
              if tmpNum > maxPage then
                tmpNum = maxPage
              end
              smallPageGroup[4].text = tostring(tmpNum)
              if thumbImg ~= nil then
                  display.remove(thumbImg)
                  thumbImg = nil
                end
           if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
              if pleft ~= tmpNum then
                --pleft = tmpNum
                jumpchapter(tmpNum)
              end
           else
              if p1 ~= tmpNum then
                jumpchapter(tmpNum)
              end
           end

        end
  end
  return true
end

function loadthumb()
    --   local loadNum = 1
    --   local integer = 0
    --   --print("smallPageGroup.numChildren=",smallPageGroup.numChildren)
    --   if smallPageGroup.numChildren > 0 then
    --       if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
    --           if pleft < smallPageGroup[1].no or pleft > smallPageGroup[smallPageGroup.numChildren-1].no then                
    --             integer = math.floor((pleft-1)/11)             
    --           end
    --       else        
    --           if p1 < smallPageGroup[1].no or p1 > smallPageGroup[smallPageGroup.numChildren-1].no then               
    --               integer = math.floor((p1-1)/11)
    --               print("integer=====",integer)
    --             end
    --       end
    --   else

    --     if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
    --       if pleft > 11 then 
    --         integer = math.floor((pleft-1)/11)
    --       end
    --     else
    --       if p1 > 11 then
    --         integer = math.floor((p1-1)/11)
    --       end
    --     end
    --   end

    --    print("integer=====",integer)
    --    for i  = 1, 11 do
    --     local smallpage = nil
       
    --     local num = integer*11 + i
    --     if num <= maxPage then
    --         local nextpage_path = system.pathForFile( path_thumb..num..".png", baseDir )
    --             local mode = lfs.attributes(nextpage_path, "mode")
    --            -- 
    --             if mode == nil then
    --               smallpage = display.newRect( 0, 0, 100, 150 )
    --               smallpage.alpha = 0.5
    --             else
    --               smallpage = display.newImage( path_thumb..num..".png",baseDir)
    --             end   
    --         smallpage.orgwidth = smallpage.width
    --         smallpage.orgheight = smallpage.height
    --         smallpage.name = "book"..num 
    --         smallrate = (boxDown.height-60)/smallpage.height   
    --         smallpage:scale( smallrate, smallrate )
    --         smallpage.smallrate = smallrate  
            
    --         local width = (_W*2 - 40 - 11*smallpage.contentWidth - 2*scrOrgx)/10
            
    --         if i > 1 then
    --           local pos = (i-1)*2 - 1
              
    --         end
    --         if i ==1 then
    --           smallpage.x =   scrOrgx + 20 + smallpage.contentWidth*0.5
    --         else
    --           --if i % 2 == 0 then
    --             --smallpage.x = smallPageGroup[(i-1)*2].x + width 
    --             smallpage.x = scrOrgx + 20 + smallpage.contentWidth*0.5  + (i-1)*(smallpage.contentWidth+width)
    --           -- else
    --           --   smallpage.x = smallPageGroup[(i-1)*2].x + width
    --           -- end
    --         end
    --         smallpage.y = boxDown.lasty  - 20--smallpage.height*rate-45--
    --         smallpage.no = num
    --         smallpage.orgx = smallpage.x
    --         local pagenum = display.newText(tostring(num),0,0,native.systemFont,24)
    --         pagenum.x = smallpage.x
    --         pagenum.y = smallpage.y + smallpage.contentHeight*0.5+pagenum.height*0.5 + 10
    --         pagenum.no = num
    --         pagenum.smallrate = smallrate
    --         pagenum.smallpageWidth = smallpage.smallpageWidth
    --         smallPageGroup:insert(smallpage)
    --         smallPageGroup:insert(pagenum)
          
    --         smallpageWidth = smallpage.contentWidth
    --       end
    -- end

    local bar = display.newRoundedRect( smallPageGroup, _X,boxDown.orgy-boxDown.height*1.15, _W*2 - 90 , 10, 4 )
    bar:setFillColor( 0.7 )
    local ball = display.newCircle( smallPageGroup, bar.x-bar.width*0.5, bar.y, 20 )
    ball.orgx = ball.x
    ball.lastx = ball.x + bar.width --第二個
    --ball:addEventListener( "touch", ballTouchFn )
    ball.moved = false
    pageLong = bar.width/maxPage
    local allpage = "   / "..tostring(maxPage)
    local totalPageText = display.newText( smallPageGroup, allpage, 0, bar.y+60,  native.systemFontBold, 40 )
    totalPageText.x = _X  + totalPageText.width/2 - 45

    local nowPage = display.newText( smallPageGroup, "1", 0, bar.y+60, native.systemFontBold, 40 )
    nowPage.x = totalPageText.x - (nowPage.width + totalPageText.width)*0.5  ---第四個


    
    --Runtime:addEventListener("enterFrame",ballMoveFn)
    ball.dx = 0
    ball.dy = 0
    if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
        local ddx = 0 
        --local tmpsmallpage = nil
        if pleft > 1 then
          -- ddx = smallPageGroup[(pleft-1)*2].x
          -- tmpsmallpage = smallPageGroup[(pleft-1)*2]
          if pleft > maxPage then
            if wetools.findone(pleft-1,bookmarkNumList) == false then
              markbmp:stopAtFrame(1)
            end 
          else
            if wetools.findone(pleft-1,bookmarkNumList) == false and wetools.findone(pleft,bookmarkNumList) == false then
             markbmp:stopAtFrame(1)
            end 
          end
        else
          if wetools.findone(pleft,bookmarkNumList) == false then
             markbmp:stopAtFrame(1)
          end 
          --=====================================
        --   ddx = smallPageGroup[pleft*2].x
        --    tmpsmallpage = smallPageGroup[pleft*2]
         end
        -- if ddx < scrOrgx + 20 then
        --   backRight = true
        --   Runtime:addEventListener( "enterFrame", smallPageAutoMoveFn)
        -- end
        -- if ddx > _W*2 - scrOrgx - 20 - tmpsmallpage.contentWidth*0.5 then
        --       backLeft  = true
        --       Runtime:addEventListener( "enterFrame", smallPageAutoMoveFn)
        -- end 
        --===================================== 

        local tmpNum = pleft
      if tmpNum > maxPage then
        tmpNum = maxPage
      end

      nowPage.text = tostring( tmpNum )
      ball.x = ball.orgx + (pleft - 1)*pageLong
    else
        local dx = 0
        if wetools.findone(p1,bookmarkNumList) == false then
              --markbmp.alpha = 0.5
              markbmp:stopAtFrame(1)
        end 
        --=====================================
        -- dx = smallPageGroup[p1*2-1].x
        -- if dx < scrOrgx + 20 then
        --      backRight = true
        --      Runtime:addEventListener( "enterFrame", smallPageAutoMoveFn)
        -- end
        -- if dx > _W*2 - scrOrgx - 20 - smallPageGroup[p1*2-1].contentWidth*0.5 then
        --     backLeft  = true
        --     Runtime:addEventListener( "enterFrame", smallPageAutoMoveFn)
        -- end
        --=====================================

      nowPage.text = tostring( p1 )
      ball.x = ball.orgx + (p1 - 1)*pageLong
    end                    
    -- makeOutLine()

    if gTransf == false then
      print("startLoadFn=================")
      timer.performWithDelay( 100, startLoadFn )
    else
      if gLoading == true then
        loadingBtn.isVisible = true
               loadingText.isVisible = true
               --gLoading = true
             -- posNum = 21
              --Runtime:addEventListener("enterFrame",contLoadFn)

              
              --if checkThumbOver == 0 then
               -- posThumbNum = 21
                --Runtime:addEventListener("enterFrame",contThumbLoadFn)
              --end
      end
    end
    --loadThumbBmpf = true
    --timer.performWithDelay( 500, startLoadThumb)
end

function jumpchapter(no)
    local nowpleft = 0
    local oldpleft = 0 
    --print("lastpage===",no)
    if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
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
    ----print("dir=",dir)
    if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
      pleft = nowpleft
      pright = pleft - 1
    end    

    if dir == "left" then                
        if  flipType ==1 then
            if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then  
                for i = 1,pageList.numChildren do               
                  pageList:remove(1)
                  pageList[1] = nil
                end                      
                for i = pleft-1,pleft do
                  if i > 0 and i <= maxPage then
                    local page = nil --display.newImage(path..i..".png",baseDir,true) 
                    local nextpage_path = system.pathForFile( path..i..".png", baseDir )
                    local mode = lfs.attributes(nextpage_path, "mode")                                          
                    if mode ==  nil then
                      page = display.newRect( 0, 0, _W, _H*2 )
                      page.name="blank"
                    else
                      page = display.newImage(path..i..".png",baseDir,true)
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
                    local page = nil --display.newImage(path..i..".png",baseDir,true) 
                    local nextpage_path = system.pathForFile( path..i..".png", baseDir )
                    local mode = lfs.attributes(nextpage_path, "mode")                                          
                    if mode ==  nil then
                      page = display.newRect( 0, 0, _W, _H*2 )
                      page.name="blank"
                    else
                      page = display.newImage(path..i..".png",baseDir,true)
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
                mask = display.newImage( path_image.."mask1.png",true )
                mask.orgx = mask.width
                mask.orgy = mask.height
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

                if pleft >= maxPage then
                  if flipType == 1 then
                    oldflipType = 1
                    flipType = 0
                    if maxPage % 2 == 0 then
                      pageList2[maxPage].anchorX = 0
                      pageList2[maxPage].x = _W*2-2*scrOrgx + (_W*2 - 2*scrOrgx - pageList2[maxPage].contentWidth)+_W
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

                local page = nil --display.newImage(path..i..".png",baseDir,true) 
                local nextpage_path = system.pathForFile( path..nowpleft..".png", baseDir )
                local mode = lfs.attributes(nextpage_path, "mode")                                          
                if mode ==  nil then
                  page = display.newRect( 0, 0, _W*2, _H*2 )
                  page.name="blank"
                else
                  page = display.newImage(path..nowpleft..".png",baseDir,true)
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
                --page.x = scrOrgx
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
              autovx = -200          
              autof = true        
              Runtime:addEventListener("enterFrame",autoturnfn )
        else
        ----不翻頁，左    
            if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
                for i = 1,2 do
                  pageList:remove(pageList.numChildren)
                  pageList[pageList.numChildren] = nil
                end

                for i = pleft-1,pleft do
                  if i <= maxPage then
                    local page = nil --display.newImage(path..i..".png",baseDir,true) 
                    local nextpage_path = system.pathForFile( path..i..".png", baseDir )
                    local mode = lfs.attributes(nextpage_path, "mode")                                          
                    if mode ==  nil then
                      page = display.newRect( 0, 0, _W, _H*2 )
                      page.name="blank"
                    else
                      page = display.newImage(path..i..".png",baseDir,true)
                      page.name="book"..i
                    end 
                    page.anchorX = 0
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
                    page.nowrate = rate*nowrate
                    originpagewidth = page.width
                    originpageheight = page.height
                    page.originpagewidth = page.width
                    page.originpageheight = page.height
                    page.pagewidth = originpagewidth*rate
                    page.pageheight = originpageheight*rate

                    if scalef == false then
                      page:scale( rate, rate )
                      page.y = pageH
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
                    firstPos = leftpos
                  end
                end
              
                p1 = oldpleft
                p2 = pleft - 1                      
                if scalef == false then
                  checkdir = false
                  jumpPagef = true
                  turnf = false
                  if flipType == 1 then
                    autovx = -220
                  else
                    autovx = -200 
                  end    
                  autof = true
                  Runtime:addEventListener("enterFrame",autoturnfn )
                else
                  jumpPagef = true
                  bigautof = true
                  Runtime:addEventListener("enterFrame",bigAutoFlipFn )
                end

            else
              ----直 不翻頁,左

              --print("aaaaaaaaaaaaaaaaa")
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

                local page = nil --display.newImage(path..i..".png",baseDir,true) 
                local nextpage_path = system.pathForFile( path..p1..".png", baseDir )
                local mode = lfs.attributes(nextpage_path, "mode")                                          
                if mode ==  nil then
                  page = display.newRect( 0, 0, _W*2, _H*2)
                  page.name="blank"
                else
                  page = display.newImage(path..p1..".png",baseDir,true)
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
                page.originpagewidth = page.width
                page.originpageheight = page.height
                originpagewidth = page.width
                originpageheight = page.height
                page.pagewidth = originpagewidth*rate
                page.pageheight = originpageheight*rate
                page.anchorX = 0
                page.no = p1
                pageList2[p1] = page

                if scalef == false then
                    page:scale( rate, rate )                  
                    page.nowrate = rate
                    page.y = pageH
                    page.x = _W*2-scrOrgx                 
                else
                    ------放大時點頁              
                    page:scale(nowrate*page.rate,nowrate*page.rate)                  
                    page.x =  pageList[1].x + page.contentWidth
                    page.y = scrOrgy + page.contentHeight*0.5                                          
                end     
                pageList:insert(page)
                 
                if scalef == false then
                  checkdir = false
                  jumpPagef = true
                  turnf = false
                  if flipType == 1 then
                    autovx = -220
                  else
                    autovx = -200 
                  end             
                  autof = true
                  --print("aaaaaaaaaaaaa")
                  Runtime:addEventListener("enterFrame",autoturnfn )
                else
                  jumpPagef = true
                  bigautof = true
                  Runtime:addEventListener("enterFrame",bigAutoFlipFn )
                end
            end
          end
        end

        if dir == "right" then                                     
            if  flipType ==1 then 
                if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
                    if pageList.numChildren > 6 then                 
                        pageList:remove(2)
                        pageList[2] = nil
                        pageList:remove(2)
                        pageList[2] = nil
                    else
                        if pleft > maxPage then
                            pageList:remove(2)
                            pageList[2] = nil
                        end
                    end
                    if oldpleft - 3 > 0 then
                        for i = 1,pageList.numChildren do
                            if pageList[i].no == oldpleft-3 then
                                pageList:remove(i)
                                pageList[i] = nil
                                break
                            end
                        end
                    elseif oldpleft - 2 > 0 then            
                        for i = 1,pageList.numChildren do
                            if pageList[i].no == oldpleft-2 then
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
                    end
                    if pos > 0 then
                        display.remove(pageList[pos])
                        pageList[pos] = nil
                    end
                    for i = pleft,pleft-1,-1 do
                        if i > 0 and i <= maxPage then

                        local page = nil --display.newImage(path..i..".png",baseDir,true) 
                        local nextpage_path = system.pathForFile( path..i..".png", baseDir )
                        local mode = lfs.attributes(nextpage_path, "mode")                                          
                        if mode ==  nil then
                          page = display.newRect( 0, 0, _W, _H*2 )
                          page.name="blank"
                        else
                          page = display.newImage(path..i..".png",baseDir,true)
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
                        pageList2[i] = page
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
                    end                 
                    p1 = oldpleft -1
                    p2 = pleft
                    mask:toFront( )
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
                      autovx = 200
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
                      pageList:remove(pos)
                      pageList[pos] = nil
                    end
                    local page = nil --display.newImage(path..i..".png",baseDir,true) 
                    local nextpage_path = system.pathForFile( path..nowpleft..".png", baseDir )
                    local mode = lfs.attributes(nextpage_path, "mode")                                          
                    if mode ==  nil then
                      page = display.newRect( 0, 0, _W*2, _H*2)
                      page.name="blank"
                    else
                      page = display.newImage(path..nowpleft..".png",baseDir,true)
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
                turnf = false
                autovx = 200          
                autof = true
                Runtime:addEventListener("enterFrame",autoturnfn )
          else
              --不翻頁，右
              if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
                  p1 = oldpleft -1
                  p2 = pleft
                  local num = pageList.numChildren
                  if num ==  6 then
                    pageList:remove(1)
                    pageList[1] = nil
                    pageList:remove(1)
                    pageList[1] = nil                
                  else
                    pageList:remove(1)
                    pageList[1] = nil                  
                  end                
                      for i = pleft,pleft-1,-1 do
                          if i > 0 then
                              local page = nil --display.newImage(path..i..".png",baseDir,true) 
                              local nextpage_path = system.pathForFile( path..i..".png", baseDir )
                              local mode = lfs.attributes(nextpage_path, "mode")                                          
                              if mode ==  nil then
                                page = display.newRect( 0, 0, _W, _H*2 )
                                page.name="blank"
                              else
                                page = display.newImage(path..i..".png",baseDir,true)
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
                              pageList2[i] = page
                              if scalef == false then
                                  page:scale( rate, rate )
                                  page.nowrate = rate
                                  page.y = pageH
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
                        pageList:remove(1)
                        pageList[1] = nil                      
                      elseif num == 3 then                       
                        pageList:remove(1)
                        pageList[1] = nil
                        pageList:remove(2)
                        pageList[2] = nil                     
                      end
                      
                      local page = display.newImage(path..p1..".png",baseDir,true) 
                    --  print("1301:p1:page = "..p1..":"..tostring(page))
                      if page ~= nil then
                          if page.width == 0 or page.width == nil  then
                            page = nil
                            display.remove( page )                          
                            --loadpage(p1)
                           
                          end 
                      end             
                      if page ==  nil then
                        page = display.newRect(0,0,_W*2,_H*2)                                         
                      end
                      page.name="book"..p1
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
                        --放大時點頁
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
                      if flipType == 1 then
                        autovx = 220
                      else
                        autovx = 200 
                      end                  
                      autof = true                       
                      Runtime:addEventListener("enterFrame",autoturnfn )
                  else                       
                      jumpPagef = true
                      bigautof = true
                      Runtime:addEventListener("enterFrame",bigAutoFlipFn )
                  end
              end
          end
end

local function bookmarkscrollListener(event)
  local ph = event.phase
  if ph == "moved" then
    bookmarkmove = true
    -- if bookmarkBlock ~= nil then
    --   bookmarkBlock:setFillColor( 221/255 )
    --   bookmarkBlock.width = bookmarkBlock.orgwidth
    --   bookmarkBlock.x = scrOrgx + bookmarkBlock.contentWidth*0.5
    --   bookmarkBlock.isVisible = false
    --   bookmarkBlock.isHitTestable = true
    -- end
  elseif ph == "ended" then    
    if bookmarkmove == true then
    else
      ----跳bookmark      
      if chobookmark >0 then
        jumpchapter(chobookmark)
        chobookmark = 0
        contentGroup.y = -10000
        optionItemf = false
        
        flipArea[1] =  scrOrgx
          --clickAreaL[3] = scrOrgx + clickWidth
          clickAreaL[3] = -10000

        
        -- if bookmarkBlock ~= nil then
        --   bookmarkBlock:setFillColor( 221/255 )
        --   bookmarkBlock.width =bookmarkBlock.orgwidth
        --   bookmarkBlock.x = scrOrgx + bookmarkBlock.contentWidth*0.5
        --   bookmarkBlock.isVisible = false
        --   bookmarkBlock.isHitTestable = true
        -- end
      end
      if chobookmarkdel > 0 then
          bookmarkNumList = wetools.deleteone(chobookmarkdel,bookmarkNumList)
          local status = ""
          for i=1, #bookmarkNumList do
            status = status .. "," .. bookmarkNumList[i]
          end
          gProfile.updatebookmark( choice_bookcode, status )
            if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
              if chobookmarkdel == pleft or chobookmarkdel == pleft - 1 then
                if wetools.findone(pleft,bookmarkNumList) == false and wetools.findone(pleft-1,bookmarkNumList) ==  false then
                  markbmp:stopAtFrame(1)
              end
            end
          else
            if p1 == chobookmarkdel then
              markbmp:stopAtFrame(1)
            end
          end    
          local totalhight_bookmark =  20
          local top = scrOrgy+statusbarHeight+optionBoxUp+contitemheight
          if bookmarkscroll == nil then
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
          else         
              for i = 1,bookmarkscroll[2][1].numChildren do
                  display.remove(bookmarkscroll[2][1][1])
                  bookmarkscroll[2][1][1] = nil
              end        
          end
          if #bookmarkNumList > 0 then
              for i = 1,#bookmarkNumList do       
              local marknum = display.newText("P "..bookmarkNumList[i],0,totalhight_bookmark,native.systemFontBold,fontSize )
              --local del = display.newText( "Del",0,0,native.systemFont,fontSize)  
              local del = display.newImage( "button/b_cencel02.png" ,resDir  )   

              local nextpage_path = system.pathForFile( path_thumb..bookmarkNumList[i]..".png", baseDir )
                          local mode = lfs.attributes(nextpage_path, "mode")
                          --
                          local img = nil
                          
                          if mode == nil then
                            img = display.newRect( 0, 0, 150, 200 )
                            img.alpha = 0.5
                            --back = display.newRect(  0, 0, 170, 220 )
                            --back:setFillColor(0.7)
                          else
                            img = display.newImage( path_thumb..bookmarkNumList[i]..".png",baseDir)
                            --back = display.newRect(  0, 0, img.width + 20, img.height + 20 )
                            --back:setFillColor(0.7)
                          end 
                  if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
                    local dx = ((_W*2 - 2*scrOrgx) - 6*img.contentWidth)/7
                    local dw = img.contentWidth*0.5
                   
                    local num = i%6
                    if num == 0  then
                      num = 6
                    end
                    img.x = num*dx + ((num-1)*2+1)*dw
                    img.y = 160 + math.floor( (i-1)/6 )*(img.contentHeight+80)
                  else
                    local dx = ((_W*2 - 2*scrOrgx) - 4*img.contentWidth)/5
                    local dw = img.contentWidth*0.5
                    
                    local num = i%4
                    if num == 0 then
                      num = 4
                    end
                    img.x = num*dx + ((num-1)*2+1)*dw
                    img.y = 160 + math.floor( (i-1)/4 )*(img.contentHeight+80)
                  end

        --marknum:setFillColor( 1,0,0 )
        img.no = tonumber(  bookmarkNumList[i] )
        img:addEventListener( "touch", gobookmarkFn )
        marknum.x =  img.x--marknum.width*0.5 + 20
        marknum.y =  img.y + (marknum.height+img.height)/2 + 10--totalhight_bookmark + 2
        marknum:setFillColor( 89/255,85/255,86/255 )
        del.x = img.x + img.width/2--contwidth - del.width*0.5-5
        del.y = img.y - img.height/2--marknum.y
        print("fontSize==",fontSize)
        del:scale( 0.5, 0.5 ) 
        --local dx = contwidth*0.5+(del.x-(scrOrgx+contwidth*0.5)-del.contentHeight*0.5)  
        -- if contwidth == 640 then
        --   dx = contwidth - 80

        -- end    
        -- soh
        marknum.no = tonumber(  bookmarkNumList[i] )
        del.no = tonumber(  bookmarkNumList[i] )
        --totalhight_bookmark = totalhight_bookmark + marknum.height  + marknum.height*0.5
        -- bookmarkBack.no = del.no
        -- bookmarkBack.orgwidth = bookmarkBack.contentWidth
        -- bookmarkBack:addEventListener( "touch", gobookmarkFn )
        totalhight_bookmark = totalhight_bookmark  + marknum.height + 40
        del:addEventListener( "touch", delbookmarkFn )
        --bookmarkscroll:insert(bookmarkBack)
        bookmarkscroll:insert(marknum)
        
        bookmarkscroll:insert(img) 
        bookmarkscroll:insert(del)        
          end      
        end        
        chobookmarkdel = 0
      end
    end
    bookmarkmove = false
  end
end

local function bookmarkFn(event)
  if exitf == false then
      local ph = event.phase
      local etar = event.target
      if ph == "began" then
          bookmarkf = true
          -- optionBtnBase.x = etar.x
          -- optionBtnBase.y = etar.y
          -- optionBtnBase.width = etar.contentWidth
      elseif ph == "ended" or ph == "canceled" then
          --optionBtnBase.x= -10000
        local no = 0
        if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
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
        if wetools.findone(no,bookmarkNumList) == false then
          markbmp:stopAtFrame(2)
          table.insert( bookmarkNumList,no)
          table.sort( bookmarkNumList, compare )  
        else 
          markbmp:stopAtFrame(1)
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
              local totalhight_bookmark =  20
              local top = scrOrgy+statusbarHeight+optionBoxUp+contitemheight
              if bookmarkscroll == nil then
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
              else
                for i = 1,bookmarkscroll[2][1].numChildren do
                  display.remove(bookmarkscroll[2][1][1])
                  bookmarkscroll[2][1][1] = nil
                end
              end

             if #bookmarkNumList > 0 then
                for i = 1,#bookmarkNumList do             
                  local marknum = display.newText("P "..bookmarkNumList[i],0,totalhight_bookmark,native.systemFontBold,fontSize )
                  --local del = display.newText( "Del",0,0,native.systemFont,fontSize)--40)  
                  local del = display.newImage( "button/b_cencel02.png" ,resDir  )  

                  local nextpage_path = system.pathForFile( path_thumb..bookmarkNumList[i]..".png", baseDir )
                          local mode = lfs.attributes(nextpage_path, "mode")
                          --
                          local img = nil
                          
                          if mode == nil then
                            img = display.newRect( 0, 0, 150, 200 )
                            img.alpha = 0.5
                            --back = display.newRect(  0, 0, 170, 220 )
                            --back:setFillColor(0.7)
                          else
                            img = display.newImage( path_thumb..bookmarkNumList[i]..".png",baseDir)
                            --back = display.newRect(  0, 0, img.width + 20, img.height + 20 )
                            --back:setFillColor(0.7)
                          end 
                  if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
                    local dx = ((_W*2 - 2*scrOrgx) - 6*img.contentWidth)/7
                    local dw = img.contentWidth*0.5
                   
                    local num = i%6
                    if num == 0  then
                      num = 6
                    end
                    img.x = num*dx + ((num-1)*2+1)*dw
                    img.y = 160 + math.floor( (i-1)/6 )*(img.contentHeight+80)
                  else
                    local dx = ((_W*2 - 2*scrOrgx) - 4*img.contentWidth)/5
                    local dw = img.contentWidth*0.5
                    
                    local num = i%4
                    if num == 0 then
                      num = 4
                    end
                    img.x = num*dx + ((num-1)*2+1)*dw
                    img.y = 160 + math.floor( (i-1)/4 )*(img.contentHeight+80)
                  end

        --marknum:setFillColor( 1,0,0 )
        img.no = tonumber(  bookmarkNumList[i] )
        img:addEventListener( "touch", gobookmarkFn )
        marknum.x =  img.x--marknum.width*0.5 + 20
        marknum.y =  img.y + (marknum.height+img.height)/2 + 10--totalhight_bookmark + 2
        marknum:setFillColor( 89/255,85/255,86/255 )
        del.x = img.x + img.width/2--contwidth - del.width*0.5-5
        del.y = img.y - img.height/2--marknum.y
        print("fontSize==",fontSize)
        del:scale( 0.5, 0.5 ) 
        --local dx = contwidth*0.5+(del.x-(scrOrgx+contwidth*0.5)-del.contentHeight*0.5)  
        -- if contwidth == 640 then
        --   dx = contwidth - 80

        -- end    
        -- soh
        marknum.no = tonumber(  bookmarkNumList[i] )
        del.no = tonumber(  bookmarkNumList[i] )
        --totalhight_bookmark = totalhight_bookmark + marknum.height  + marknum.height*0.5
        -- bookmarkBack.no = del.no
        -- bookmarkBack.orgwidth = bookmarkBack.contentWidth
        -- bookmarkBack:addEventListener( "touch", gobookmarkFn )
        totalhight_bookmark = totalhight_bookmark  + marknum.height + 40
        del:addEventListener( "touch", delbookmarkFn )
        --bookmarkscroll:insert(bookmarkBack)
        bookmarkscroll:insert(marknum)
        
        bookmarkscroll:insert(img) 
        bookmarkscroll:insert(del)          
                end    
             end
          end
      end
  end
  return true
end

local function arrangPageFn2()
      -- loadingImg.x = display.contentWidth*0.5
      -- loadingImg.y = display.contentHeight*0.5
      -- loadingImg.isVisible = true
      -- loadingImg:toFront( )
      -- loadingf = true
      -- optionItemf = true
  if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
    for i = 1,pageList.numChildren do
        pageList:remove(1)
        pageList[1] = nil
    end
    for i = pleft-3,pleft+2 do
      if i > 0 and i <= maxPage then
          local page = display.newImage(path..i..".png",baseDir,true)
         -- print("1614:i:page = "..i..":"..tostring(page))
          if page ~= nil then
            if page.width == 0  or page.width == nil then
              page = nil
              display.remove( page )           
              --loadpage(i)
            end 
          end  
          if page ==  nil then
              page = display.newRect(0,0,_W,_H*2)
              --loadpage(i)           
          end
          page.name="book"..i
          originpagewidth = page.width
          originpageheight = page.height
          page.originpagewidth = page.width
          page.originpageheight = page.height
          page.anchorX = 0
          page.no = i
          pageList2[i] = page
          local rate1 = (_H*2-scrOrgy*2 - statusbarHeight)/page.height
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
                  page.x = scrOrgx - (pleft-1-i)*page.contentWidth              
              elseif i > pleft-2 and i <= pleft then
                  page.x = _W - (pleft-i)*page.contentWidth
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
                  page.firstPos = page.x
              end
          end
              page.orgx = page.x
              page.y = pageH
              pageList:insert(page)
      end
    end
    if pleft -2 == 1 then   
        pageList2[1].x = pageList2[2].x - pageList2[1].contentWidth - (_W*2 - scrOrgx*2 - pageList2[1].contentWidth)
    end
    if pleft + 1 == maxPage then
        pageList2[maxPage].x = _W*2-2*scrOrgx + (_W*2 - 2*scrOrgx - pageList2[maxPage].contentWidth)
    end
    if pleft - 1 == maxPage then
        pageList2[maxPage].x = _W - pageList2[maxPage].contentWidth*0.5
    end
    mutiscalef = false
  else
    ---直，正常安排
    for i = 1,pageList.numChildren do
        pageList:remove(1)
        pageList[1] = nil     
    end
    for i = p1-1,p1+1 do
      if i > 0 and i <= maxPage then
          local page = nil     
          page = display.newImage(path..i..".png",baseDir,true) 
         -- print("2271:i:page = "..i..":"..tostring(page))
          if page ~= nil then
            if page.width == 0  or page.width == nil then
              page = nil
              display.remove( page )           
              --loadpage(i)
            end 
          end  
          if page ==  nil then
              page = display.newRect(0,0,_W*2,_H*2)
              --loadpage(i)           
          end
          page.name="book"..i
          originpagewidth = page.width
          originpageheight = page.height
          page.originpagewidth = page.width
          page.originpageheight = page.height
          page.anchorX = 0
          page.no = i
          local rate1 = (_H*2 -scrOrgy*2 - statusbarHeight)/page.height
          local rate2 = (_W*2-scrOrgx*2)/page.width        
          if rate1 <= rate2 then
            rate = rate1
          else
            rate = rate2
          end
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
          end
          page.orgx = page.x
          page.y = pageH   
        --  print("page.y==",page.y)  
          pageList:insert(page)  
      end
    end    
        mutiscalef = false
  end  

  mutiscalef = false
  autof = false
  turnf = false
  checkdir = true
  canautof = false
  gBackToScale = false
end

local function arrangPageFn()
      -- loadingImg.x = display.contentWidth*0.5
      -- loadingImg.y = display.contentHeight*0.5
      -- loadingImg.isVisible = true
      -- loadingImg:toFront( )
      -- loadingf = true
      -- optionItemf = true
  if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
      for i = 1,pageList.numChildren do
        pageList:remove(1)
        pageList[1] = nil      
      end 
    for i = pleft+2,pleft-3,-1 do
      if i > 0 and i <= maxPage then     
          local page = display.newImage(path..i..".png",baseDir,true) 
          --print("1821:i:page = "..i..":"..tostring(page))
          if page ~= nil then
            if page.width == 0  or page.width == nil then
              page = nil
              display.remove( page )           
              --loadpage(i)
            end 
          end  
          if page ==  nil then
              page = display.newRect(0,0,_W,_H*2)
              --loadpage(i)           
          end
          page.name="book"..i
           originpagewidth = page.width
          originpageheight = page.height
          page.no = i
          page.originpagewidth = page.width
          page.originpageheight = page.height
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
          page.nowrate = rate
          page:scale( rate, rate )  
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
          pageList:insert(page)      
      end
  end 
    mask = display.newImage( path_image.."mask1.png",true )
    mask.orgx = mask.width
    mask.orgy = mask.height
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
    mask:scale( 0.98*rate1, 0.98*rate2)
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
      mask.path.x4 = -pageList2[maxPage].originpagewidth
      mask.path.x3 = -pageList2[maxPage].originpagewidth
    end     
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
          if i % 2 == 1 then
            pageList2[i].anchorX = 0
            pageList2[i].path.x3 = 0
            pageList2[i].path.x4 = 0
            pageList2[i].path.x1 = 0
            pageList2[i].path.x2 = 0          
          else
            pageList2[i].anchorX = 1
            if i == pleft + 1 then           
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
  else
    --直
    for i = 1,pageList.numChildren do
        pageList:remove(1)
        pageList[1] = nil    
    end
      for i = p1+1,p1-1,-1 do
        if i > 0 and i <= maxPage then 
          local page = display.newImage(path..i..".png",baseDir) 
         -- print("2010:i:page = "..i..":"..tostring(page))
          if page ~= nil then
            if page.width == 0  or page.width == nil then
              page = nil
              display.remove( page )           
              --loadpage(i)
            end 
          end  
          if page ==  nil then
              page = display.newRect(0,0,_W*2,_H*2)
              --loadpage(i)           
          end
          page.name="book"..i
          originpagewidth = page.width
          originpageheight = page.height
          page.originpagewidth = page.width
          page.originpageheight = page.height       
          page.anchorX = 0
          local rate1 = (_H*2-scrOrgy*2- statusbarHeight)/page.height         
          local rate2 = (_W*2-scrOrgx*2)/page.width       
          if rate1 <= rate2 then
            rate = rate1
          else
            rate = rate2
          end
          page.rate = rate        
          page.nowrate = rate
          page:scale( rate, rate )
          page.no = i   
          pageList2[i] = page 
          local dx = _W*2-2*scrOrgx - page.width*rate
          if i == 1 or i == maxPage then

            page.x = -1000
          else
            page.x = scrOrgx + dx/2
          end
          page.y = pageH          
          pagewidth = originpagewidth*rate
          pageheight = originpageheight*rate
          page.pagewidth = originpagewidth*rate
          page.pageheight = originpagewidth*rate
          pageList:insert(page)
          if i == p1-1 then
            page:toBack( )           
          end
      end
    end
      local dx = _W*2-2*scrOrgx - pageList2[p1].originpagewidth*pageList2[p1].rate
      mask = display.newImage( pageList,path_image.."mask1.png",true )
      mask.orgx = mask.width
      mask.orgy = mask.height    
      local rate1 = pageList2[p1].contentWidth/mask.width
      local rate2 = pageList2[p1].contentHeight/mask.height
      local maskrate = 0
      if rate1 > rate2 then
        maskrate = rate2
      else
        maskrate = rate1
      end
      mask:scale( 0.98*rate1, 0.98*rate2)    
      mask.anchorX = 0
      mask.x =scrOrgx + dx/2
      mask.y = pageH
      mask:toFront( )
      pageList2[p1]:toFront( )
      mutiscalef = false
      autof = false
      turnf = false
      checkdir = true
      canautof = false
  end
  gBackToScale = false
end

local function mutimoveFn()
    
  if mutimovefh == true then
    if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then       
        if pleft == 1 then
          -- local dx = (_W-pageList2[1].contentWidth*0.5) - pageList2[1].x
          -- local dy = pageH - pageList2[1].y 
          -- dx = dx/3
          -- dy = dy/3
          -- pageList2[1].x = pageList2[1].x + dx
          -- pageList2[1].y = pageList2[1].y + dy
          -- if math.abs(dx) < 1 then
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
            flipType = 0
            arrangPageFn2()
            --Runtime:removeEventListener("enterFrame",mutimoveFn)
            
           -- Runtime:addEventListener("touch",turnPagefn)
          -- end
        elseif pleft > maxPage then
          -- local dx = (_W-pageList2[maxPage].contentWidth*0.5) - pageList2[maxPage].x
          -- local dy = pageH - pageList2[maxPage].y
          -- dx = dx/3
          -- dy = dy/3
          -- pageList2[maxPage].x = pageList2[maxPage].x + dx
          -- pageList2[maxPage].y = pageList2[maxPage].y + dy
          -- if math.abs(dx) < 1 then
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
            flipType = 0
            arrangPageFn2()
            --gBackToScale = false
            --Runtime:removeEventListener("enterFrame",mutimoveFn)
            --Runtime:addEventListener("touch",turnPagefn)
          -- end
        else
          -- local dx = _W - pageList2[pleft].x
          -- local dy = pageH - pageList2[pleft].y
          -- dx = dx/3
          -- dy = dy/3
          -- pageList2[pleft].x = pageList2[pleft].x + dx
          -- pageList2[pleft].y = pageList2[pleft].y + dy 
          -- pageList2[pleft-1].x = pageList2[pleft].x - pageList2[pleft-1].contentWidth
          -- pageList2[pleft-1].y = pageList2[pleft].y         
          -- if math.abs(dx) < 1 then
            nowrate = 1
            pageList2[pleft].x = _W
            pageList2[pleft].y = pageHpagh
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
            --gBackToScale = false        
            --Runtime:removeEventListener("enterFrame",mutimoveFn)
           -- Runtime:addEventListener("touch",turnPagefn)
          --end
        end
    else
      local dw = _W*2-2*scrOrgx - pageList2[p1].originpagewidth*pageList2[p1].rate
      -- local dx = scrOrgx - pageList2[p1].x + dw/2 
      -- local dy = pageH- pageList2[p1].y 
      -- dx = dx/3
      -- dy = dy/3
      -- pageList2[p1].x = pageList2[p1].x + dx
      -- pageList2[p1].y = pageList2[p1].y + dy   
      -- if math.abs(dx) < 1 then


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
          --gBackToScale = false  
          -- Runtime:removeEventListener("enterFrame",mutimoveFn)
           --Runtime:addEventListener("touch",turnPagefn)
      --end    
    end
  end
end

local function updatepage()
  if scalef == false then
    if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then        
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
end

local function loadpage2(pa)
  print("page..............=",pa)

  if gNetworkStatus == true then
    local params = {}  params.progress = true
    local dpi = "150" 
    local function networkListener( event )
      if ( event.isError ) then
        if loadnum == 1 then
          loadnum = 0
             display.remove( loadingImg)
            loadingImg = nil
            updatepage()
            loadingBtn.isVisible = false
            loadingText.isVisible = false
            gLoading = false
        else
          loadnum = loadnum +  1
          if pa+loadnum <= maxPage then
             --display.remove( loadingImg)
            --loadingImg = nil
            loadpage2(pa)
          else
             display.remove( loadingImg)
            loadingImg = nil
            loadnum = 0
            loadingBtn.isVisible = false
            loadingText.isVisible = false
            gLoading = false
            updatepage()
          end
        end
        
              
            
      elseif ( event.phase == "began" ) then
          --gNetworkStatus = true
      elseif ( event.phase == "ended" ) then
       -- addPrecent = addPrecent + 1
       -- gNowPrecent  = oldPrecent + math.floor((addPrecent/maxPage)*100)
            --if gNowPrecent > 100 then
             -- gNowPrecent = 100
            --end
       
            --loadingText.text = gNowPrecent.."%"
           -- print("gNowPrecent=",gNowPrecent)
            

        if loadnum == 1 then
          loadnum = 0
             display.remove( loadingImg)
            loadingImg = nil
            updatepage()
            if checkOver == 1 then
              loadingBtn.isVisible = false
              loadingText.isVisible = false
              gLoading = false
            end
        else
          loadnum = loadnum +  1
          if pa + loadnum <= maxPage then
             --display.remove( loadingImg)
            --loadingImg = nil
            loadpage2(pa + loadnum)
          else
             display.remove( loadingImg)
            loadingImg = nil
            loadnum = 0
            updatepage()
            if checkOver == 1 then
              loadingBtn.isVisible = false
              loadingText.isVisible = false
              gLoading = false
            end
          end
        end
      end
    end

    local function thumbNetworkListener( event )
      
        if ( event.isError ) then
             
            
        elseif ( event.phase == "began" ) then
            
        elseif ( event.phase == "ended" ) then
            --local page = pa + loadnum
            -- local smallpage = display.newImage( event.response.filename, event.response.baseDirectory, -100000, 100 )
            --         smallpage.name = "book"..page
                    --loadThumbBmpOne(smallpage,(posThumbNum-1))
                    
                   -- changeThumbMenu(page)
            
          
        end
      end

    --if(gConServ ~= nil) then
      network.download(
        "http://license.acs.igpublish.com/igpspot/bkdoor/" ..gPubid.. "/" ..gDocid.. "/" .. pa.."/"..dpi .. "/content.png",
        "GET",
        networkListener,
        params,
        choice_bookcode.."/"..pa..".png", -- put subfolder path here
        system.DocumentsDirectory
      )

      -- local nextpage_path = system.pathForFile( path_thumb..pa..".png", baseDir )
      -- local mode = lfs.attributes(nextpage_path, "mode")
      --   if mode == nil then
          network.download( 
              "http://license.acs.igpublish.com/igpspot/bkdoor/" ..gPubid.. "/" ..gDocid.. "/" .. pa.."/" .. "/thumbnail.png",
              "GET",
              thumbNetworkListener,
              params,
              choice_bookcode.."thumb/"..pa..".png", -- put subfolder path here
              system.DocumentsDirectory
          )
       -- end

      if loadingImg == nil  then
        loadingImg = gSystem.getLoading()
         loadingImg.x = display.contentWidth*0.5
        loadingImg.y = display.contentHeight*0.5
        loadingImg:scale( 0.6, 0.6 )
        --loadingImg.alpha = 0.6
        loadingImg:toFront( )
      end
  else
      updatepage()
      local alert = native.showAlert( "Network Error !!", "Please make sure internet connected and try again", { "OK" } )
      --gNetworkStatus = false
     
  end

end





function loadpage(pa)
  print("loadpage............")

  if gNetworkStatus == true then
    local params = {}  params.progress = true
    local dpi = "150"
      local function networkListener( event )
        if ( event.isError ) then
             display.remove( loadingImg)
            loadingImg = nil
            updatepage()
            local alert = native.showAlert( "Network Error !!", "Please make sure internet connected and try again", { "OK" } )
            --gNetworkStatus = false
            display.remove( loadingImg)
            loadingImg = nil

            loadingBtn.isVisible = false
            gLoading = false
            
        elseif ( event.phase == "began" ) then
            --gNetworkStatus = true
        elseif ( event.phase == "ended" ) then
            display.remove( loadingImg)
            loadingImg = nil
           -- addPrecent = addPrecent + 1
            --gNowPrecent  = oldPrecent + math.floor((addPrecent/maxPage)*100)
            --if gNowPrecent > 100 then
              --gNowPrecent = 100
            --end
            -- gNowPrecent  = gNowPrecent + math.floor((addPrecent/maxPage)*100)
            --loadingText.text = gNowPrecent.."%"
            --print("gNowPrecent=",gNowPrecent)
            
            if checkOver == 1 then
              loadingBtn.isVisible = false
              loadingText.isVisible = false
              gLoading = false
            end
            updatepage()
          
        end
      end
      
      local function thumbNetworkListener( event )
        if ( event.isError ) then
             
            
        elseif ( event.phase == "began" ) then
            
        elseif ( event.phase == "ended" ) then
        --local smallpage = display.newImage( event.response.filename, event.response.baseDirectory, -100000, 100 )
                    --smallpage.name = "book"..pa
                    --loadThumbBmpOne(smallpage,(posThumbNum-1))
                    --changeThumbMenu(pa)
                    
       
          
        end
      end
      
        network.download(
          "http://license.acs.igpublish.com/igpspot/bkdoor/" ..gPubid.. "/" ..gDocid.. "/" .. pa.."/"..dpi .. "/content.png",
          "GET",
          networkListener,
          params,
          choice_bookcode.."/"..pa..".png", -- put subfolder path here
          system.DocumentsDirectory
        )
        -- local nextpage_path = system.pathForFile( path_thumb..pa..".png", baseDir )
        -- local mode = lfs.attributes(nextpage_path, "mode")
        -- if mode == nil then
          network.download( 
            "http://license.acs.igpublish.com/igpspot/bkdoor/" ..gPubid.. "/" ..gDocid.. "/" .. pa.."/" .. "/thumbnail.png",
            "GET",
            thumbNetworkListener,
            params,
            choice_bookcode.."thumb/"..pa..".png", -- put subfolder path here
            system.DocumentsDirectory
           )
        -- end
      
      if loadingImg == nil  then
        loadingImg = gSystem.getLoading()
         loadingImg.x = display.contentWidth*0.5
        loadingImg.y = display.contentHeight*0.5
        loadingImg:scale( 0.6, 0.6 )
        --loadingImg.alpha = 0.6
        loadingImg:toFront( )
      end
  else
    updatepage()
    local alert = native.showAlert( "Network Error !!", "Please make sure internet connected and try again", { "OK" } )
  end
end


function autoturnfn(event)
  ----print("autovx==",autovx)

  if autof == false then
    Runtime:removeEventListener("enterFrame",autoturnfn)
  end
  if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
    if autof == true then
    ---橫向
      if flipType == 1 then
        if dir == "left" then
          if autovx ~= -220 then
            autovx = -220
          end
        else
          if autovx ~= 220 then
            autovx = 220
          end
        end
        if p1 % 2 == 1 then
              ----單頁左右翻
              local pos1 = wetools.getpos2(mask,pageList)            
              local pos = wetools.getpos2( pageList2[p1],pageList)
              if pos1 < pos-1 then
                mask:toFront( )
                pageList2[p1]:toFront()
              end
              if pageList2[p1].path.x4 + autovx > -pageList2[p1].originpagewidth then
                  if pageList2[p1].path.x4 + autovx < 0 then
                      if mask.alpha ==0 then mask.alpha =1 end
                      pageList2[p1].path.x4 = pageList2[p1].path.x4 + autovx
                      local dx = pageList2[p1].originpagewidth + pageList2[p1].path.x4                  
                      local ang = math.acos(dx/pageList2[p1].originpagewidth)*0.3
                      pageList2[p1].path.x3 = pageList2[p1].path.x4
                      pageList2[p1].path.y4 = -pageList2[p1].originpagewidth*math.sin(ang)
                      pageList2[p1].path.y3 = pageList2[p1].path.y4
                      pageList2[p2].path.x1 = pageList2[p2].originpagewidth
                      pageList2[p2].path.x2 = pageList2[p2].originpagewidth                  
                      pageList2[p2].path.y1 = 0
                      pageList2[p2].path.y2 = 0                       
                      -- local mx4 = pageList2[p1].path.x4*1.2                      
                      -- mratex = mask.orgx/pageList2[p1].originpagewidth
                      -- mratey = mask.orgy/pageList2[p1].originpageheight
                      -- print("mask.contentWidth222===",mask.contentWidth)
                      -- print("pagelist.contentWidth222===",pageList2[p1].contentWidth)
                      -- if mx4 < -pageList2[p1].originpagewidth then mx4 = -pageList2[p1].originpagewidth end
                      --    mask.path.x4 = mx4*mratex
                      --    mask.path.x3 = mx4*mratex
                      --   mask.path.y3 = -mratey*pageList2[p1].originpagewidth*math.sin(ang)/4
                      --mask.width = pageList2[p1].contentWidth
                       local mx4 = pageList2[p1].path.x4*1.1                       
                                  if mx4 < -pageList2[p1].originpagewidth then 
                                    mx4 = -pageList2[p1].originpagewidth
                                  end
                                  mratex = mask.orgx/pageList2[p1].originpagewidth
                                  mratey = mask.orgy/pageList2[p1].originpageheight                        
                                  mask.path.x4 = mx4*mratex
                                  mask.path.x3 = mx4*mratex
                                  mask.path.y3 = -mratey*pageList2[p1].originpagewidth*math.sin(ang)/4
                                   print("mask.contentWidth222===",mask.contentWidth)
                     -- print("mask.path.x3===",mask.path.x3)
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
                      canautof = true
                  else                                      
                      pageList2[p1].path.x4 = 0
                      pageList2[p1].path.x3 = 0
                      pageList2[p1].path.y3 = 0
                      pageList2[p1].path.y4 = 0
                      pageList2[p2].path.x1 = 2*pageList2[p2].originpagewidth
                      pageList2[p2].path.x2 = 2*pageList2[p2].originpagewidth
                      pageList2[p2].path.y1 = 0
                      pageList2[p2].path.y2 = 0
                      autof = false
                      canautof = false                  
                      turnf = false
                      checkdir = true
                      Runtime:removeEventListener("enterFrame",autoturnfn )
                  end
              else
                  ---過中線
                    pageList2[p2]:toFront( )              
                    if pageList2[p2].alpha == 0 then pageList2[p2].alpha = 1 end
                    if mask.alpha ==0 then mask.alpha =1 end
                    if pageList2[p2].path.x1 +autovx > 0 then                          
                        pageList2[p2].path.x1 = pageList2[p2].path.x1 +autovx                                                     
                        local dx =  pageList2[p2].originpagewidth-pageList2[p2].path.x1 -- -pageList2[p1].path.x4 - originpagewidth                           
                        local ang = math.acos(dx/pageList2[p2].originpagewidth)*0.3                                        
                        pageList2[p2].path.y1 = -pageList2[p2].originpagewidth*math.sin(ang)
                        pageList2[p2].path.x2 = pageList2[p2].path.x1
                        pageList2[p2].path.y2 = -pageList2[p2].originpagewidth*math.sin(ang)                       
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
                        canautof = true
                    else
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
                      

                      if dir == "left"   then
                        --=====================================
                        -- smallPageGroup:remove(smallPageGroup.numChildren)
                        -- smallPageGroup[smallPageGroup.numChildren] = nil
                        --=====================================
                          if jumpPagef == false  then
                            if pleft + 2 <= maxPage  then
                              pleft = pleft + 2                               
                                pright = pleft -1                                  
                            else
                              pright = maxPage
                              pleft = pleft + 2
                            end
                            
                            local nextpage_path = system.pathForFile( choice_bookcode.."/"..(pleft-1)..".png", baseDir )
                            local mode = lfs.attributes(nextpage_path, "mode")
                            local nextpage_path2 = system.pathForFile( choice_bookcode.."/"..(pleft)..".png", baseDir )
                            local mode2 = lfs.attributes(nextpage_path2, "mode")
                            ----print("fh===",fh)
                            if mode == nil then

                              loadpage2(pleft-1)
                            elseif mode2 == nil then
                              if pleft<= maxPage then
                                loadpage(pleft)
                              else
                                timer.performWithDelay( 10, arrangPageFn )
                              end
                            else
                              
                              timer.performWithDelay( 10, arrangPageFn )
                              
                            end

                            --timer.performWithDelay( 10, arrangPageFn )
                            
                            
                          else
                             jumpPagef = false
                             local nextpage_path = system.pathForFile( choice_bookcode.."/"..(pleft-1)..".png", baseDir )
                              local mode = lfs.attributes(nextpage_path, "mode")
                              local nextpage_path2 = system.pathForFile( choice_bookcode.."/"..(pleft)..".png", baseDir )
                              local mode2 = lfs.attributes(nextpage_path2, "mode")
                              ----print("fh===",fh)
                              if mode == nil then

                                loadpage2(pleft-1)
                              elseif mode2 == nil then
                                if pleft<= maxPage then
                                  loadpage(pleft)
                                else
                                  timer.performWithDelay( 10, arrangPageFn )
                                end
                              else
                               
                                timer.performWithDelay( 10, arrangPageFn )
                                
                              end                     
                            
                            --timer.performWithDelay( 10, arrangPageFn )
                          end
                          timer.performWithDelay( 20, makeOutLine )
                      end  
                      --=====================================
                      -- local dx = 0 
                      -- local tmpsmallpage = nil
                      -- if pleft > 1 then
                      --   dx = smallPageGroup[(pleft-1)*2].x
                      --   tmpsmallpage = smallPageGroup[(pleft-1)*2]
                      -- else
                      --   dx = smallPageGroup[pleft*2].x
                      --   tmpsmallpage = smallPageGroup[pleft*2]
                      -- end
                      -- if dx < scrOrgx + 20 then
                      --   backRight = true
                      --  Runtime:addEventListener( "enterFrame", smallPageAutoMoveFn)
                      -- end
                      -- if dx > _W*2 - scrOrgx - 20 - tmpsmallpage.contentWidth*0.5  then 
                      --     backLeft  = true
                      --     Runtime:addEventListener( "enterFrame", smallPageAutoMoveFn)                             
                      -- end    
                      --=====================================
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
                      pageList2[p2].path.x3 = -pageList2[p2].originpagewidth
                      pageList2[p2].path.x4 = -pageList2[p2].originpagewidth
                      pageList2[p2].path.y3 = 0
                      pageList2[p2].path.y4 = 0   


                      --print("aaaaaaa")
                      local mx4 = -pageList2[p1].originpagewidth-(dx)*0.9
                      
                                  mratex = mask.orgx/pageList2[p1].originpagewidth
                                  mratey = mask.orgy/pageList2[p1].originpageheight
                                  mask.path.x4 = mx4*mratex
                                  mask.path.x3 = mx4*mratex
                                  mask.path.y3 = -mask.orgy*math.sin(ang)/4        
                      mask:toBack( )
                      
                      if math.abs(mask.path.x4 + pageList2[p1].originpagewidth) < 3 then
                          mask.alpha = 0
                          mask:toFront( )     
                          pageList2[p2].alpha = 0                        
                      end
                      canautof = true
                  else
                    canautof = false
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
                   pageList2[p2]:toFront( )
                   if pageList2[p2].alpha == 0 then pageList2[p2].alpha =1 end
                   if mask.alpha ==0 then mask.alpha =1 end                  
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

                      local mx4 = pageList2[p2].path.x4*1.1
                      mratex = mask.orgx/pageList2[p2].originpagewidth
                      mratey = mask.orgy/pageList2[p2].originpageheight               
                      if mx4 <-pageList2[p2].originpagewidth then mx4 = -pageList2[p2].originpagewidth end
                      mask.path.x4 = mx4*mratex
                      mask.path.x3 = mx4*mratex
                      mask.path.y3 = -mratey*pageList2[p2].originpagewidth*math.sin(ang)/4
                      cnaautof = true               
                    else
                      pageList2[p2].path.x4 = 0
                      pageList2[p2].path.x3 =  0
                      pageList2[p2].path.y4 = 0
                      pageList2[p2].path.y3 = 0
                      pageList2[p1].path.x1 = 2*pageList2[p1].originpagewidth
                      pageList2[p1].path.x2 = 2*pageList2[p1].originpagewidth
                      pageList2[p1].path.y1 = 0
                      pageList2[p1].path.y2 = 0                      
                      if dir == "right"  then
                          if jumpPagef == false then 
                            if pleft -2 >=1 then
                              pleft = pleft -2                           
                              pright = pleft -1                           
                            else
                              pleft = 1
                            end
                           
                            -- timer.performWithDelay( 10, arrangPageFn )
                           
                            if pleft > 1 then
                                local nextpage_path = system.pathForFile( choice_bookcode.."/"..(pleft-1)..".png", baseDir )
                                local mode = lfs.attributes(nextpage_path, "mode")
                                local nextpage_path2 = system.pathForFile( choice_bookcode.."/"..(pleft)..".png", baseDir )
                                local mode2 = lfs.attributes(nextpage_path2, "mode")
                                --print("mode===",mode)
                                if mode == nil then
                                  loadpage2(pleft-1)
                                elseif mode2 == nil then
                                  
                                    loadpage(pleft)
                                  
                                else
                                  
                                    timer.performWithDelay( 10, arrangPageFn )
                                end
                                --timer.performWithDelay( 10, arrangPageFn )
                            else
                                local nextpage_path = system.pathForFile( choice_bookcode.."/"..(pleft)..".png", baseDir )
                                local mode = lfs.attributes(nextpage_path, "mode")
                                ----print("fh===",fh)
                                if mode == nil then

                                  loadpage(pleft)
                                else
                                  timer.performWithDelay( 10, arrangPageFn )
                                  
                                end
                                --timer.performWithDelay( 10, arrangPageFn )
                            end

                          else                      
                            jumpPagef = false
                                if pleft > 1 then

                                  local nextpage_path = system.pathForFile( choice_bookcode.."/"..(pleft-1)..".png", baseDir )
                                  local mode = lfs.attributes(nextpage_path, "mode")
                                  local nextpage_path2 = system.pathForFile( choice_bookcode.."/"..(pleft)..".png", baseDir )
                                  local mode2 = lfs.attributes(nextpage_path2, "mode")
                                  ----print("fh===",fh)
                                  --print("mode===",mode)
                                  if mode == nil then

                                    loadpage2(pleft-1)
                                  elseif mode2 == nil then
                                    
                                      loadpage(pleft)
                                    
                                  else
                                    timer.performWithDelay( 10, arrangPageFn )
                                   
                                  end
                                  --timer.performWithDelay( 10, arrangPageFn )
                                else
                                  local nextpage_path = system.pathForFile( choice_bookcode.."/"..(pleft)..".png", baseDir )
                                  local mode = lfs.attributes(nextpage_path, "mode")
                                 -- print("mode===",mode)
                                  if mode == nil then

                                    loadpage(pleft)
                                  else
                                    timer.performWithDelay( 10, arrangPageFn )
                                    
                                  end
                                  --timer.performWithDelay( 10, arrangPageFn )
                                end                           
                           -- arrangPageFn()
                          end
                           -- smallPageGroup:remove(smallPageGroup.numChildren)
                           --  smallPageGroup[smallPageGroup.numChildren] = nil
                             timer.performWithDelay( 20, makeOutLine )
                      end 
                    
                      Runtime:removeEventListener("enterFrame",autoturnfn )   
                    end
                end
        end
    else
      ----不翻頁---橫
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
         --print("target.x===",target.x)    
         if target ~= nil then
            local dx = firstPos - target.x
            dx = dx*0.5  
            if math.abs(dx) < 2 then
              local ddx = firstPos - target.x
              for i = 1,pageList.numChildren do

                pageList[i].x = pageList[i].x + ddx 

              end
              -- canautof = false
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
              local ddx = 0 
              local tmpsmallpage = nil
            

              timer.performWithDelay( 20, makeOutLine )
              local nextpage_path = system.pathForFile( choice_bookcode.."/"..(pleft-1)..".png", baseDir )
              local mode = lfs.attributes(nextpage_path, "mode")
              local nextpage_path2 = system.pathForFile( choice_bookcode.."/"..(pleft)..".png", baseDir )
              local mode2 = lfs.attributes(nextpage_path2, "mode")
              if mode == nil then

                loadpage2(pleft-1)
              elseif mode2 == nil then
                if pleft<= maxPage then
                  loadpage(pleft)
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
              
              Runtime:removeEventListener("enterFrame",autoturnfn )      
            else
                for i = 1,pageList.numChildren do
                  pageList[i].x = pageList[i].x + dx  
                  if pageList[i].no == maxPage-1 then
                    --print("maxpage-1.x==",pageList[i].x)
                  end                
                end

            end
          else          
              turnf = true
              Runtime:removeEventListener("enterFrame",autoturnfn )
          end
      elseif dir == "right" then       
          local target = nil
          local newpleft = 0
          -- for i = 1,pageList.numChildren do
          --   --print("page = ",pageList[i].name)
          -- end
         -- --print("jumpPagef==",jumpPagef)
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
          
          ----print("target.x====",target.x)
          local dx = firstPos - target.x
          dx = dx*0.5
          ----print("dx====",dx)
          if math.abs(dx) < 2 then
            local ddx = firstPos - target.x
            for i = 1,pageList.numChildren do
              pageList[i].x = pageList[i].x + ddx             
            end
              -- canautof = false          
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
              local ddx = 0 
              local tmpsmallpage = nil
              
             
              if pleft > 1 then
                local nextpage_path = system.pathForFile( choice_bookcode.."/"..(pleft-1)..".png", baseDir )
                local mode = lfs.attributes(nextpage_path, "mode")
                local nextpage_path2 = system.pathForFile( choice_bookcode.."/"..(pleft)..".png", baseDir )
                local mode2 = lfs.attributes(nextpage_path2, "mode")
                ----print("fh===",fh)
                if mode == nil then

                  loadpage2(pleft-1)
                elseif mode2 == nil then
                  
                    loadpage(pleft)
                  

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
                ----print("fh===",fh)
                if mode == nil then

                  loadpage(pleft)
                else
                  flipType = 0
                  timer.performWithDelay( 10, arrangPageFn2 )
                  
                end
              end
              timer.performWithDelay( 20, makeOutLine )
              -- makeOutLine()
              -- if oldflipType == 1 then
              --     --print("pleft==",pleft)
              --     if pleft == 1 then
              --       arrangPageFn2()
              --     elseif pleft < maxPage then
              --       flipType = 1

              --       arrangPageFn()
              --     else
              --       arrangPageFn2()
              --     end
                
              -- else
              --   arrangPageFn2()
              -- end

              
              Runtime:removeEventListener("enterFrame",autoturnfn )
          else
            for i = 1,pageList.numChildren do
              pageList[i].x = pageList[i].x + dx            
            end
          end
        end     
      end
    end
  else

      -----直
      if autof == true then
        if flipType == 1 then
           -----直向翻頁    

          if dir == "left" then

              local pos1 = wetools.getpos2(mask,pageList)                 
              local pos = wetools.getpos2( pageList2[p1],pageList)
              if pos1 < pos-1 then
                mask:toFront( )
                pageList2[p1]:toFront()
              end
              ----print("autovx===",autovx)
              if pageList2[p1].path.x4 + autovx > -pageList2[p1].pagewidth then
                pageList2[p1].path.x4 = pageList2[p1].path.x4 + autovx         
                local dx = pageList2[p1].pagewidth+pageList2[p1].path.x4 
                local ang = math.acos(dx/pageList2[p1].pagewidth)*0.1         
                pageList2[p1].path.y4 = -pageList2[p1].pagewidth*math.sin(ang)           
                pageList2[p1].path.x3 =  pageList2[p1].path.x4
                pageList2[p1].path.y3 = -pageList2[p1].pagewidth*math.sin(ang)             
                local mx4 = pageList2[p1].path.x4*1.1  
                mratex = mask.orgx/pageList2[p1].originpagewidth
                mratey = mask.orgy/pageList2[p1].originpageheight 
                if mx4*mratex < -mask.orgx then
                  mask.path.x3 = -mask.orgx
                  mask.path.x4 = -mask.orgx
                else
                  mask.path.x4 = mx4*mratex
                  mask.path.x3 = mx4*mratex
                end
                mask.path.y3 = -mratey*pageList2[p1].pagewidth*math.sin(ang)/4          
              else
                pageList2[p1].path.x4 = -pageList2[p1].originpagewidth
                pageList2[p1].path.x3 = -pageList2[p1].originpagewidth
                pageList2[p1].path.y4 = 0
                pageList2[p1].path.y3 = 0
                local mratex = mask.orgx/pageList2[p1].pagewidth
                local mratey = mask.orgy/pageList2[p1].pagewidth
                if -pageList2[p1].pagewidth*mratex < -mask.orgx then
                  mask.path.x3 = -mask.orgx
                  mask.path.x4 = -mask.orgx
                else
                  mask.path.x4 = -pageList2[p1].pagewidth*mratex
                  mask.path.x3 = -pageList2[p1].pagewidth*mratex
                end          
                mask.path.y3 = 0
                if jumpPagef == false then
                  if p1 < maxPage then
                    p1 = p1 + 1
                  end
                else             
                  if pageList.numChildren == 3 then
                    p1 = pageList[1].no
                  else
                    p1 = pageList[2].no
                  end           
                  jumpPagef = false
                end
                

                if mode == nil then
                  loadpage(p1)
                else
                  timer.performWithDelay( 10, arrangPageFn )
                 
                end
                
                timer.performWithDelay( 20, makeOutLine )
                -- makeOutLine()              
                -- arrangPageFn()         
                mask:toBack( )
                Runtime:removeEventListener("enterFrame",autoturnfn )
              end
          elseif dir == "right" then
              local pos1 = wetools.getpos2(mask,pageList)                   
              local pos = wetools.getpos2( pageList2[p1],pageList)
              if pos1 < pos-1 then
                mask:toFront( )
                pageList2[p1]:toFront()
              end
              
              if pageList2[p1].path.x4 + autovx < 0 then
                pageList2[p1].path.x4 = pageList2[p1].path.x4 + autovx
                local dx = pageList2[p1].pagewidth+pageList2[p1].path.x4 
                local ang = math.acos(dx/pageList2[p1].pagewidth)*0.1
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
              else
                pageList2[p1].path.x4 = 0
                pageList2[p1].path.x3 = 0
                pageList2[p1].path.y4 = 0
                pageList2[p1].path.y3 = 0
                mask.path.x4 = 0
                mask.path.x3 = 0
                mask.path.y3 = 0
                mask.path.y4 = 0
               
                mask:toBack( )
                

                local nextpage_path = system.pathForFile( choice_bookcode.."/"..p1..".png", baseDir )
                local mode = lfs.attributes(nextpage_path, "mode")

                if mode == nil then

                  loadpage(p1)
                else
                  timer.performWithDelay( 10, arrangPageFn )
                  
                end

                --timer.performWithDelay( 10, arrangPageFn )
                 timer.performWithDelay( 20, makeOutLine )
                -- makeOutLine()
                -- arrangPageFn()
                turnf = false                    
                checkdir = true
                autof = false
                Runtime:removeEventListener("enterFrame",autoturnfn )
              end
          end
        else

          ----不翻頁...直
          if dir == "left" then

            ----print("jumpPagef==",jumpPagef)

              local target = nil
              local newpleft = 0   
              --print("p1 = ",p1)
              if jumpPagef == false then
                target = pageList2[p1+1]
              else
                target = pageList2[p1]
              end
              --print("p1===",p1)
              --print("target===",target)
              if target ~= nil then
                local dw = _W*2-2*scrOrgx - target.contentWidth
                local dx = scrOrgx - target.x + dw/2
                dx = dx*0.5
                if math.abs(dx) < 2 then
                  local ddx = scrOrgx - target.x
                  for i = 1,pageList.numChildren do
                    pageList[i].x = pageList[i].x + ddx                    
                  end
                  -- canautof = false
                  -- turnf = false
                  -- checkdir = true
                  -- autof = false
                  if jumpPagef == false then
                      if p1 + 1 <= maxPage  then
                       p1 = p1 + 1
                      end
                  end
                  jumpPagef = false
                  local ddx 
                 
                  
                  local nextpage_path = system.pathForFile( choice_bookcode.."/"..p1..".png", baseDir )
                  local mode = lfs.attributes(nextpage_path, "mode")

                  if mode == nil then
                   -- print("aaaaaa")
                    loadpage(p1)
                  else

                    if oldflipType == 1 then
                      if p1 < maxPage then
                        flipType = 1
                        --arrangPageFn()
                        timer.performWithDelay( 10, arrangPageFn )
                      else

                        flipType = 0
                        arrangPageFn2()
                      end
                    else
                      --print("left========")
                      --print("11111111111")
                      flipType = 0
                      arrangPageFn2()
                    end
                  end
                  timer.performWithDelay( 20, makeOutLine )
                  
                   Runtime:removeEventListener("enterFrame",autoturnfn)           
                else
                  for i = 1,pageList.numChildren do
                    pageList[i].x = pageList[i].x + dx                
                  end
                end
              else           
                turnf = true
                Runtime:removeEventListener("enterFrame",autoturnfn )
              end
          elseif dir == "right" then

              local dw = _W*2-2*scrOrgx - pageList2[p1].originpagewidth*pageList2[p1].rate
              firstPos = scrOrgx + dw/2
              pageList2[p1].firstPos = firstPos
              local dx = firstPos - pageList2[p1].x
              dx = dx*0.5
              if math.abs(dx) < 2 then
                local ddx = firstPos - pageList2[p1].x
                for i = 1,pageList.numChildren do
                  pageList[i].x = pageList[i].x + ddx                  
                end
                -- canautof = false
                -- turnf = false
                -- checkdir = true
                -- autof = false
                jumpPagef = false
              

                local nextpage_path = system.pathForFile( choice_bookcode.."/"..p1..".png", baseDir )
                local mode = lfs.attributes(nextpage_path, "mode")

                if mode == nil then
                  
                  loadpage(p1)
                else
                  if oldflipType == 1 then
                    if flipType == 0 then
                      if p1 >1 then
                        flipType = 1
                        --arrangPageFn()
                        timer.performWithDelay( 10, arrangPageFn )
                      else
                        flipType = 0
                        arrangPageFn2()
                      end
                    else
                      timer.performWithDelay( 10, arrangPageFn )
                    end
                  else
                    flipType = 0
                    arrangPageFn2()
                  end
                end
                 
                  timer.performWithDelay( 20, makeOutLine() )
                
                Runtime:removeEventListener("enterFrame",autoturnfn )
              else          
                for i = 1,pageList.numChildren do
                  pageList[i].x = pageList[i].x + dx                 
                end
              end
          end
        end
      end
    end
end

function arrangBigPageFn()
      -- loadingImg.x = display.contentWidth*0.5
      -- loadingImg.y = display.contentHeight*0.5
      -- loadingImg.isVisible = true
      -- loadingImg:toFront( )
      -- loadingf = true
      -- optionItemf = true
  if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
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
          page.nowrate = rate * nowrate

          page:scale( page.nowrate, page.nowrate )
          if i <= pleft-2 then
            page.x = scrOrgx - (pleft-1-i)*originpagewidth*page.nowrate
          elseif i > pleft-2 and i <= pleft then
            if pleft > 1 then
              page.x = scrOrgx + (i-(pleft- 1))*originpagewidth*page.nowrate
            else           
              page.x =  _W*2 -scrOrgx - originpagewidth*page.nowrate
            end
          else       
            --page.x = _W*2-scrOrgx + (i-pleft-1)*originpagewidth*page.nowrate
            if i == (pleft + 1) then
              page.x = _W*2 - scrOrgx
            else               
                page.x = pageList2[pleft+1].x + pageList2[pleft+1].contentWidth                 
            end
          end
            page.y = scrOrgy + originpageheight*page.nowrate*0.5
            pageList2[i] = page
            pageList:insert(page)
      end
    end    
  else
    ---直 , 放大安排     
    for i = 1,pageList.numChildren do

        pageList:remove(1)
        pageList[1] = nil     
    end
    tmppage= display.newImage( path.."2.png",baseDir,true )
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
          local rate1 = (_H*2 -scrOrgy*2- statusbarHeight)/page.height
          local rate2 = (_W*2-scrOrgx*2)/page.width          
          if rate1 <= rate2 then
            rate = rate1
          else
            rate = rate2
          end
          page.rate = rate
          page.nowrate = rate*nowrate
          originpagewidth = page.width
          originpageheight = page.height
          page.originpagewidth = page.width
          page.originpageheight = page.height     
          page.anchorX = 0        
          page.no = i
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
          else
            page.x = scrOrgx + originpagewidth*page.nowrate
          end
            page.orgx = page.x
            page.y = scrOrgy + originpageheight*page.nowrate*0.5                   
            pageList2[i] = page
            pageList:insert(page)
      end
    end     
    mutiscalef = false 
    display.remove( tmppage )
      tmppage = nil
  end
end

 function bigAutoFlipFn(event)
  if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
    if bigautof == false then
      Runtime:removeEventListener("enterFrame",bigAutoFlipFn )
    else
      if dir == "left" then
        local dx = 0
        if pleft ==1 then
            dx = scrOrgx - pageList2[2].x 
        elseif pleft >= maxPage then
            if pleft > maxPage then
              dx = scrOrgx - pageList2[maxPage].x
            else
              dx = scrOrgx - pageList2[pleft-1].x
            end
        else
            if jumpPagef == false then
              dx = scrOrgx - pageList2[pleft+1].x
            else
              dx = scrOrgx - pageList2[pleft-1].x
            end
        end
        dx = dx *0.3
        for i = 1,pageList.numChildren do
          pageList[i].x = pageList[i].x + dx
        end
        if math.abs(dx)<=1 then
          bigautof = false         
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
          --arrangBigPageFn()
          
          makeOutLine()

          if pleft > 1 then

                                  local nextpage_path = system.pathForFile( choice_bookcode.."/"..(pleft-1)..".png", baseDir )
                                  local mode = lfs.attributes(nextpage_path, "mode")
                                  local nextpage_path2 = system.pathForFile( choice_bookcode.."/"..(pleft)..".png", baseDir )
                                  local mode2 = lfs.attributes(nextpage_path2, "mode")
                                  ----print("fh===",fh)
                                  --print("mode===",mode)
                                  if mode == nil then

                                    loadpage2(pleft-1)
                                  elseif mode2 == nil then
                                    
                                      loadpage(pleft)
                                    
                                  else
                                    arrangBigPageFn()
                                   
                                  end
                                  --timer.performWithDelay( 10, arrangPageFn )
                                else
                                  local nextpage_path = system.pathForFile( choice_bookcode.."/"..(pleft)..".png", baseDir )
                                  local mode = lfs.attributes(nextpage_path, "mode")
                                 -- print("mode===",mode)
                                  if mode == nil then

                                    loadpage(pleft)
                                  else
                                    arrangBigPageFn()
                                    
                                  end
                                  --timer.performWithDelay( 10, arrangPageFn )
                                end             

          Runtime:removeEventListener("enterFrame",bigAutoFlipFn )
        end
    elseif dir == "right" then
        local dx
        if pleft ==1 then
           dx =  _W*2 -scrOrgx -pageList2[pleft].contentWidth - pageList2[1].x
        elseif pleft > maxPage then
           dx = scrOrgx - pageList2[maxPage-2].x
        else
            if jumpPagef == false then
                if pleft > 3 then
                  dx = scrOrgx - pageList2[pleft-3].x
                else
                  dx = _W*2 -scrOrgx -pageList2[pleft-2].contentWidth - pageList2[pleft-2].x
                end
            else
              dx = scrOrgx - pageList2[pleft-1].x
            end
        end
        dx = dx *0.3
        for i = 1,pageList.numChildren do
          pageList[i].x = pageList[i].x + dx
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
           -- arrangBigPageFn()
           
            makeOutLine()

            if pleft > 1 then
                local nextpage_path = system.pathForFile( choice_bookcode.."/"..(pleft-1)..".png", baseDir )
                local mode = lfs.attributes(nextpage_path, "mode")
                local nextpage_path2 = system.pathForFile( choice_bookcode.."/"..(pleft)..".png", baseDir )
                local mode2 = lfs.attributes(nextpage_path2, "mode")
                ----print("fh===",fh)
                if mode == nil then

                  loadpage2(pleft-1)
                elseif mode2 == nil then
                  
                    loadpage(pleft)
                  

                else
                    arrangBigPageFn()
                
                 end
               
              else
                local nextpage_path = system.pathForFile( choice_bookcode.."/"..(pleft)..".png", baseDir )
                local mode = lfs.attributes(nextpage_path, "mode")
                ----print("fh===",fh)
                if mode == nil then

                  loadpage(pleft)
                else
                  arrangBigPageFn()
                  
                end
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
        local dx = 0    
        if jumpPagef == false then  
            if p1+1 <= maxPage then         
              dx = scrOrgx - pageList2[p1+1].x
            else
              dx = scrOrgx - pageList2[p1].x
            end
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
          makeOutLine()
          local nextpage_path = system.pathForFile( choice_bookcode.."/"..p1..".png", baseDir )
                  local mode = lfs.attributes(nextpage_path, "mode")

                  if mode == nil then
                   -- print("aaaaaa")
                    loadpage(p1)
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
          makeOutLine()
          local nextpage_path = system.pathForFile( choice_bookcode.."/"..p1..".png", baseDir )
                local mode = lfs.attributes(nextpage_path, "mode")

                if mode == nil then
                  
                  loadpage(p1)
                else
                  arrangBigPageFn()
                end
          Runtime:removeEventListener("enterFrame",bigAutoFlipFn )
        end      

      end
    end 
  end
end

local function bigPageBackFn(event)
  if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
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
            if dx >= -1 then
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
          if dx >= -1 then
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
        if math.abs(bigVx) <=1 and math.abs(bigVy) <= 1 then        
            bigVx = 0
            bigVy = 0
            Runtime:removeEventListener("enterFrame",bigPageFloatFn )
        else
          local leftMax = _W -scrOrgx - (_W*2-2*scrOrgx)*0.33 ---往左最大坐標
            local rightMax = scrOrgx + (_W*2-2*scrOrgx)*0.33 
          if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then          
            if pleft == 1 then
              pageList2[1].x = pageList2[1].x + bigVx
              pageList2[1].y = pageList2[1].y + bigVy            
              local left  = pageList2[1].x + pageList2[1].contentWidth
              local top = pageList2[1].y - pageList2[1].contentHeight*0.5
              if left < _W*2-scrOrgx then
                bigBackRight = true
              end            
              if left > _W*2-scrOrgx + pageList2[1].contentWidth*0.67 then         
                bigBackLeft = true
              end
              if top > scrOrgy then
                bigBackUp = true
              end
              if top < scrOrgy - (pageList2[1].contentHeight - 2*_H) then
                bigBackDown  = true
              end
            elseif pleft > maxPage then
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
                bigBackUp = true
              end
              if top < scrOrgy - (pageList2[maxPage].contentHeight - 2*_H) then
                bigBackDown  = true
              end
            else
                pageList2[pleft].x = pageList2[pleft].x + bigVx
                pageList2[pleft].y = pageList2[pleft].y + bigVy
                pageList2[pleft-1].x = pageList2[pleft-1].x + bigVx
                pageList2[pleft-1].y = pageList2[pleft-1].y + bigVy
                local left  = pageList2[pleft].x + pageList2[pleft].contentWidth--pageList2[1].width
                local top = pageList2[pleft].y - pageList2[pleft].contentHeight*0.5--pageList2[1].height*0.5
                local right  = pageList2[pleft].x - pageList2[pleft-1].contentWidth
                if left < _W*2-scrOrgx then
                  bigBackRight = true
                end
                if right > scrOrgx then
                  bigBackLeft = true
                end
                if top > scrOrgy then
                  bigBackUp = true
                end
                if top < scrOrgy - (pageList2[pleft].contentHeight - 2*_H) then
                  bigBackDown  = true
                end
            end
          else
                -----放大直向浮動
                pageList2[p1].x = pageList2[p1].x + bigVx
                pageList2[p1].y = pageList2[p1].y + bigVy
                local left  = pageList2[p1].x + pageList2[p1].contentWidth
                local top = pageList2[p1].y - pageList2[p1].contentHeight*0.5
                if left < _W*2-scrOrgx then
                  bigBackRight = true
                end             
                if left > pageList2[p1].contentWidth +scrOrgx then            
                  bigBackLeft = true
                end
                if top > scrOrgy then
                  bigBackUp = true
                end
                if top < scrOrgy - (pageList2[p1].contentHeight - 2*_H + 2*scrOrgy) then
                  bigBackDown  = true
                end                                 
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
  if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
      if pleft == 1 then
         local tmprate = pageList2[1].rate*nowrate
          pageList2[1].xScale = tmprate
          pageList2[1].yScale = tmprate
          pageList2[1].nowrate = tmprate
          for i = 2,pageList.numChildren do      
            local tmprate = pageList[i].rate*nowrate
            pageList[i].xScale = tmprate
            pageList[i].yScale = tmprate

            pageList[i].x = _W*2 - scrOrgx + (i-2)*pageList[i].contentWidth          
            pageList[i].y = scrOrgy + pageList[i].contentHeight*0.5    
          end
      elseif pleft > maxPage then
          local tmprate = pageList2[maxPage].rate*nowrate       
          pageList2[maxPage].xScale = tmprate
          pageList2[maxPage].yScale = tmprate   
          pageList2[maxpage].nowrate = tmprate     
          for i = 2,1,-1 do
              pageList[i].xScale =  tmprate
              pageList[i].yScale =  tmprate
              pageList[i].x = scrOrgx + (i-3)*pageList[i].contentWidth     
              pageList[i].y = scrOrgy +  pageList[i].contentHeight*0.5  
          end
      else
        local tmprate1 = pageList2[pleft].rate*nowrate
        local tmprate2 = pageList2[pleft-1].rate*nowrate
        pageList2[pleft-1].xScale = tmprate2
        pageList2[pleft-1].yScale = tmprate2
        pageList2[pleft].xScale = tmprate1
        pageList2[pleft].yScale = tmprate1
        pageList2[pleft].nowrate = tmprate1
        pageList2[pleft-1].nowrate = tmprate2
        if centerx >= bounds.xMin and centerx <= bounds.xMax and centery >= bounds.yMin and centery <= bounds.yMax then  
          pageList2[pleft].x = pageList2[pleft-1].x + pageList2[pleft].anchorX*pageList2[pleft].contentWidth+ pageList2[pleft-1].contentWidth*(1- pageList2[pleft-1].anchorX)
          pageList2[pleft].y = pageList2[pleft-1].y
        else
          pageList2[pleft-1].x = pageList2[pleft].x - pageList2[pleft].anchorX*pageList2[pleft].contentWidth- pageList2[pleft-1].contentWidth*(1- pageList2[pleft-1].anchorX)
          pageList2[pleft-1].y = pageList2[pleft].y        
        end
          for i = pleft-3,pleft-2 do     
            if i <= maxPage and i > 0  then            
                local tmprate = pageList2[i].rate*nowrate
                pageList2[i].xScale = tmprate
                pageList2[i].yScale = tmprate
                pageList2[i].x = scrOrgx + (i-pleft+1)*pageList2[i].contentWidth
                pageList2[i].y = scrOrgy + pageList2[i].contentHeight*0.5
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
  else
    ----直向，多點觸控
          local tmprate = nowrate*pageList2[p1].rate
          pageList2[p1].xScale = tmprate
          pageList2[p1].yScale = tmprate
          pageList2[p1].nowrate = tmprate         
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

function turnPagefn(event)
  --print("aaa")
  --print("clickAreaL[3]=",clickAreaL[3])
  --print("exitf=",exitf)
  print("event.phase = ",event.phase)
  if smallPageGroup.numChildren > 1 then
      if smallPageGroup[2].moved == true then
        smallPageGroup[2].moved = false
        if thumbImg ~= nil then
                  display.remove(thumbImg)
                  thumbImg = nil
                end

        local tmpNum = (smallPageGroup[2].x - smallPageGroup[2].orgx)/pageLong
                  tmpNum = math.round( tmpNum) + 1
                  if tmpNum < 1 then
                    tmpNum = 1
                  end
                  if tmpNum > maxPage then
                    tmpNum = maxPage
                  end
                  smallPageGroup[4].text = tostring(tmpNum)

               if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
                  if pleft ~= tmpNum then
                    --pleft = tmpNum
                    jumpchapter(tmpNum)
                  end
               else
                  if p1 ~= tmpNum then
                    jumpchapter(tmpNum)
                  end
               end

      end
  end
  if optionItemf == false and exitf == false   then
    --if loadingf == false then
      if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
        local x = event.xStart
        local y = event.yStart 
        print("optionf222222==",optionf)
        -- if optionf == true then
        --   flipArea[2] =  scrOrgy + optionBoxUp + statusbarHeight----up
      
        --   flipArea[4] =  -scrOrgy + _H*2 - optionBoxDown --down
        -- else
        --   flipArea[2] =  scrOrgy  + statusbarHeight----up
      
        --   flipArea[4] =  -scrOrgy + _H*2  --down
        -- end
      
        if x > flipArea[1] and x < flipArea[3] and y > flipArea[2] and y < flipArea[4]  then

          local ph = event.phase
          local tmp = {}
          if ph == "began" then            
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
                --if period > 300 then
                --local vx = evnet.x - event.xStart
                --if math.abs(vx) > 20 then
                   mutitouchf = false
                   mf = false
                   oldx = event.xStart         
                  if scalef == false then
                    --if flipType == 1 then
                      if turnf == false and autof == false then

                        turnf = true
                      end
                    -- else
                    --  if turnf == false and autof == false  then      
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
                    end
                  end
                --end

            elseif numTouches > 1 and numTouches <=3 and autof == false then 
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
              if nowrate == 1 then
                scalef = false
                              scaleing = false
              end
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
                

                local touchrate = touchDistance/oldDistance
                oldDistance = touchDistance
                mutirate = mutirate*touchrate
                  if nowrate <= 1.1  and mutirate < nowrate and gBackToScale == false then 
                        
                          if mutitouchf == true then
                            mutitouchf = false

                            -- if pleft == 1 then
                            --   pageList2[pleft].x = pageList2[pleft].x - pageList2[pleft].anchorX*pageList2[pleft].contentWidth
                            --   pageList2[pleft].y = pageList2[pleft].y - (pageList2[pleft].anchorY-0.5)*pageList2[pleft].contentHeight
                            --   pageList2[pleft].anchorX = 0
                            --   pageList2[pleft].anchorY = 0.5
                            -- elseif pleft > maxPage then
                            --   pageList2[maxPage].x = pageList2[maxPage].x - pageList2[maxPage].anchorX*pageList2[maxPage].contentWidth
                            --   pageList2[maxPage].y = pageList2[maxPage].y - (pageList2[maxPage].anchorY-0.5)*pageList2[maxPage].contentHeight
                            --   pageList2[maxPage].anchorX = 0
                            --   pageList2[maxPage].anchorY = 0.5
                            -- else
                            --   pageList2[pleft].x = pageList2[pleft].x - pageList2[pleft].anchorX*pageList2[pleft].contentWidth
                            --   pageList2[pleft].y = pageList2[pleft].y - (pageList2[pleft].anchorY-0.5)*pageList2[pleft].contentHeight
                            --   pageList2[pleft-1].x = pageList2[pleft].x - pageList2[pleft-1].contentWidth
                            --   pageList2[pleft-1].y = pageList2[pleft].y
                            --   pageList2[pleft].anchorX = 0
                            --   pageList2[pleft].anchorY = 0.5
                            --   pageList2[pleft-1].anchorX = 0
                            --   pageList2[pleft-1].anchorY = 0.5
                            -- end
                            --
                                         
                              mutimovefh = true
                              nowrate = 1
                              --Runtime:addEventListener("enterFrame",mutimoveFn)
                              mutimoveFn()
                              scalef = false
                              scaleing = false
                          end
                        
                          mutitouchPos ={}
                          idList = {}
                          numTouches = 0
                          gBackToScale = true
                         -- Runtime:removeEventListener("touch",turnPagefn)
                       
                  else
                    if gBackToScale == false then
                        scalef = true
                              scaleing = true
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
                       

                        -- 
                        --   
                         mutirate = nowrate
                      end
                    end
                end


                

               
            end

            if mutitouchf == false then
             -----翻頁
                local vx = event.x - event.xStart 
                if math.abs(vx) > 20  then
                  mf = true
                  local canturnf = false
                  if flipType == 1 and autof == true then
                    canturnf = false
                  else
                    canturnf = true
                  end

                  if scalef == false  then
                    if canturnf == true then
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
                                  ----print("p1===",p1)            
                                  --pageList2[p1].no = p1 
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


                              ----print("p1-===",p1)
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
                          else
                            if ddx > 0 then
                              if flipType ==1 then
                                if ddx > 20 then 
                                  ddx = 20 
                                end
                              end
                                dir = "right"
                            end
                            if ddx < 0 then
                              if flipType == 1 then
                                if ddx < -20 then
                                  ddx =-20 
                                end
                              end
                                dir = "left"
                              end
                            end
                            autovx = ddx*2
                            if flipType == 0 then
                              if autovx == 0 then
                                gof = false
                              else 
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
                           -- print("gof===",gof)
                            if gof == true then
                              if flipType == 1 then
                                if autof == false then
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
                                          canautof = true
                                        else
                                          canautof = false
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
                                        mask:toFront()
                                        pageList2[p1].path.x4 = -pageList2[p1].originpagewidth
                                        pageList2[p1].path.x3 = -pageList2[p1].originpagewidth
                                        pageList2[p1].path.y3 = 0
                                        pageList2[p1].path.y4 = 0                      
                                        pageList2[p2]:toFront()                 
                                        if pageList2[p2].alpha == 0 then pageList2[p2].alpha = 1 end
                                        if mask.alpha ==0 then mask.alpha =1 end
                                        if pageList2[p2].path.x1 +autovx > 0 then
                                            pageList2[p2].path.x1 = pageList2[p2].path.x1 +autovx
                                            local dx =  pageList2[p2].originpagewidth-pageList2[p2].path.x1 -- -pageList2[p1].path.x4 - originpagewidth                           
                                            local ang = math.acos(dx/pageList2[p2].originpagewidth)*0.3                            
                                            pageList2[p2].path.y1 = -pageList2[p2].originpagewidth*math.sin(ang)
                                            pageList2[p2].path.x2 = pageList2[p2].path.x1
                                            pageList2[p2].path.y2 = -pageList2[p2].originpagewidth*math.sin(ang)
                                            local mx4 = -pageList2[p2].originpagewidth-(dx)*0.9
                                            mask.alpha = 1                              
                                            mratex = mask.orgx/pageList2[p2].originpagewidth
                                            mratey = mask.orgy/pageList2[p2].originpageheight
                                            mask.path.x4 = mx4*mratex                      
                                            mask.path.x3 = mx4*mratex
                                            mask.path.y3 = -mratey*pageList2[p2].originpagewidth*math.sin(ang)/4
                                            canautof = true
                                        else
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
                                            turnf = false
                                            checkdir = true
                                            canautof = false
                                            if dir == "left" then
                                              if pleft + 2 <= maxPage then
                                                pleft = pleft + 2
                                                pright = pleft -1                           
                                              else
                                                pright = maxPage
                                                pleft = pleft+2
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
                                                loadpage(nowpage)
                                              else
                                                arrangPageFn()
                                              end

                                              --arrangPageFn()
                                            end          
                                        end
                                      end
                                    else
                                      ---偶數頁            
                                      mask:toFront()
                                      pageList2[p1]:toFront()                    
                                      if pageList2[p1].path.x1 + autovx < pageList2[p1].originpagewidth then                
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
                                          pageList2[p2].path.x3 = -pageList2[p2].originpagewidth
                                          pageList2[p2].path.x4 = -pageList2[p2].originpagewidth
                                          pageList2[p2].path.y3 = 0
                                          pageList2[p2].path.y4 = 0           
                                          local mx4 = -pageList2[p1].originpagewidth-(dx)*0.9
                                          print("mask.contentWidth1111===",mask.contentWidth)
                                          mratex = mask.orgx/pageList2[p1].originpagewidth
                                          mratey = mask.orgy/pageList2[p1].originpageheight
                                          mask.path.x4 = mx4*mratex
                                          mask.path.x3 = mx4*mratex
                                          mask.path.y3 = -mratey*pageList2[p1].originpagewidth*math.sin(ang)/4                      
                                          if math.abs(mask.path.x4 + pageList2[p1].originpagewidth) < 3 then                         
                                            mask.alpha = 0
                                            mask:toFront( )
                                            mask.path.x3 = -mask.orgx
                                            mask.path.x4 = -mask.orgx
                                            mask.path.y3 = 0
                                            mask.path.y4 = 0
                                            pageList2[p2].alpha = 0                     
                                          end
                                          canautof = true
                                        else
                                          canautof = false                      
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
                                        mask:toFront()
                                        if mask.path.x3 < -mask.orgx+100 then
                                          mask.path.x3 = -mask.orgx+100
                                          mask.path.x4 = -mask.orgx+100
                                        end
                                        pageList2[p2]:toFront()
                                        if pageList2[p2].alpha == 0 then 
                                          pageList2[p2].alpha =1 
                                        end
                                        if mask.alpha ==0 then 
                                          mask.alpha =1 
                                        end
                                        if pageList2[p2].path.x4 +autovx < 0 then
                                          pageList2[p2].path.x4 = pageList2[p2].path.x4 +autovx                     
                                          local dx =  pageList2[p2].path.x4 + pageList2[p2].originpagewidth          
                                          local ang = math.acos(dx/pageList2[p2].originpagewidth)*0.3           
                                          pageList2[p2].path.x3 = pageList2[p2].path.x4
                                          pageList2[p2].path.y4 = -pageList2[p2].originpagewidth*math.sin(ang)
                                          pageList2[p2].path.y3 = -pageList2[p2].originpagewidth*math.sin(ang)
                                          pageList2[p1].path.x1 = pageList2[p1].originpagewidth
                                          pageList2[p1].path.x2 = pageList2[p1].originpagewidth
                                          pageList2[p1].path.y1 = 0
                                          pageList2[p1].path.y2 = 0
                                          local mx4 = pageList2[p2].path.x4*1.1
                                          if mx4 <-pageList2[p2].originpagewidth then 
                                            mx4 = -pageList2[p2].originpagewidth
                                          end
                                          mratex = mask.orgx/pageList2[p2].originpagewidth
                                          mratey = mask.orgy/pageList2[p2].originpageheight
                                          mask.path.x4 = mx4*mratex
                                          mask.path.x3 = mx4*mratex
                                          mask.path.y3 = -mratey*pageList2[p2].originpagewidth*math.sin(ang)/4
                                          cnaautof = true                
                                        else
                                          pageList2[p2].path.x4 = 0
                                          pageList2[p2].path.x3 =  0
                                          pageList2[p2].path.y4 = 0
                                          pageList2[p2].path.y3 = 0
                                          pageList2[p1].path.x1 = 2*pageList2[p1].originpagewidth
                                          pageList2[p1].path.x2 = 2*pageList2[p1].originpagewidth
                                          pageList2[p1].path.y1 = 0
                                          pageList2[p1].path.y2 = 0
                                          turnf = false
                                          canautof = false
                                          checkdir = true
                                          if dir == "right" then
                                            if pleft -2 >=1 then
                                              pleft = pleft -2
                                              pright = pleft -1
                                            end
                                            
                                            local nextpage_path = system.pathForFile( choice_bookcode.."/"..pleft..".png", baseDir )
                                            local mode = lfs.attributes(nextpage_path, "mode")
                                            if mode == nil then
                                              loadpage(pleft)
                                            else
                                              arrangPageFn()
                                            end

                                              --arrangPageFn()
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
                                    
                                  
                              end
                            end        
                          end
                        end          
                    else
                    ---放大時單點滑動
                      if bigautof == false  then
                          bigMovef = true               
                          if pleft ==1 then             
                            pageList2[1].x = event.x + zoomdx
                            pageList2[1].y = event.y + zoomdy             
                          elseif pleft > maxPage then      
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
          elseif (ph == "ended" or ph == "canceled")  then    
              if numTouches > 1 then  
                autof = false     
                local pos = 0
                idList,pos = wetools.deleteone(event.id,idList)
                if pos > 0 then
                  table.remove(mutitouchPos,pos)
                end        
              else
                if mutitouchf == true then
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
                  -- if nowrate <= 1.05 and mutimovefh == false then 
                               
                  --   mutimovefh = true
                  --   nowrate = 1
                  --   Runtime:addEventListener("enterFrame",mutimoveFn)
                  -- end
                end
                mutitouchPos ={}
                idList = {}
                numTouches = 0
              end
              numTouches = numTouches - 1
              if numTouches < 0 then
                numTouches = 0
              end
          if mf == true  then
            if scalef == false and turnf == true then
              canturnf = true
              if flipType == 1 and autof == true then
                canturnf = false       
              end

              
              if canturnf == true then
                    if mutitouchf == false  then
                      turnf = false       
                      if canautof == true  then
                        if dir == "left" then  
                          if flipType == 1 then
                            autovx = -220
                          else
                            autovx = -200 
                          end        
                        else
                          if flipType == 1 then
                            autovx = 220
                          else
                            autovx = 200 
                          end               
                        end
                        if autof == false then

                            local s = math.abs(event.x - event.xStart)
                            -- local v = s/(event.time/1000)
                            
                            if s > 0 then
                              autof = true
                              Runtime:addEventListener("enterFrame",autoturnfn )
                            end
                           
                           --Runtime:addEventListener("enterFrame",autoturnfn ) 
                        else
                          if dir == "left" then
                            if pleft +2 <= maxPage+1 then
                              pleft = pleft + 2  
                              for i = pleft+1,pleft+2 do
                                if i <= maxPage then
                                  local page = display.newImage(path..i..".png",baseDir,true)                       
                                  page.name = "book"..i
                                  page.originpagewidth = page.width
                                  page.originpageheight = page.height
                                  page.anchorX = 0
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
                                  --rateh = rate
                                  page.rate = rate
                                  page.nowrate = rate
                                  page.rateh = rate
                                  page:scale( rate, rate )
                                  if i % 2 == 0 then
                                    page.x = _W*2 - scrOrgx
                                    -- local dx = _W-scrOrgx - pageList2[i-1].contentWidth
                                    -- page.x = pageList2[i-1].x + pageList2[i-1].contentWidth + dx
                                    -- if i == maxPage then
                                    --   firstPos = _W - page.contentWidth
                                    -- end
                                  else
                                    page.x = pageList2[i-1].x + pageList2[i-1].contentWidth
                                  end
                                  page.y = pageList2[i-1].y
                                  pageList:insert(page)
                                  -- local no = pageList[1].no
                                  -- if no ~= nil then
                                  --   pageList2[no] = 1
                                  -- end
                                  display.remove( pageList[1])
                                  pageList[1] = nil                                            
                                end
                              end
                            else
                                Runtime:removeEventListener("enterFrame",autoturnfn )
                                autof = false
                            end
                          else
                            if pleft - 2 >= 1 then
                              pleft = pleft -2
                              for i = pleft-2,pleft-3,-1 do
                                if i > 0 then
                                  local page = display.newImage(path..i..".png",baseDir,true)                     
                                  page.name = "book"..i
                                  page.originpagewidth = page.width
                                  page.originpageheight = page.height
                                  page.anchorX = 0
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
                                  --rateh = rate
                                  page.rate = rate
                                  page.nowrate = rate
                                  page.rateh = rate
                                  page:scale( rate, rate )
                                  if i % 2 == 0 then                       
                                    page.x = pageList[1].x - page.contentWidth
                                  else                      
                                    page.x = scrOrgx - page.contentWidth
                                  end
                                  page.y = pageList2[i+1].y
                                  pageList:insert(page)
                                  page:toBack( )
                                  -- local no = pageList[pageList.numChildren].no
                                  -- if no ~= nil then
                                  --   pageList2[no] = 1
                                  -- end
                                  display.remove( pageList[pageList.numChildren])
                                  pageList[pageList.numChildren] = nil                       
                                end
                              end
                            else
                                Runtime:removeEventListener("enterFrame",autoturnfn )
                                autof = false
                            end
                          end
                        end
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
        --print("flipArea[1]=",flipArea[1])
        --print("flipArea[3]=",flipArea[3])
       -- print("flipArea[2]=",flipArea[2])
        --print("flipArea[4]=",flipArea[4])
        --print("optionItemf==",optionItemf)
        --print("clickarea1=",clickarea1)
       -- if x > clickAreaL[3] and x < clickAreaR[1] and y > flipArea[2] and y < flipArea[4] then
          --local aa = clickAreaL[3]
          --local bb = clickAreaL[1]
          --local aa = 2
          --local bb = 3

          --print("clickAreaL[3]=",clickAreaL)
        --if x > clickarea3 and x < clickarea1 and y > flipArea[2] and y < flipArea[4]  then
        --if x > flipArea[1] and x < flipArea[3] and y > flipArea[2] and y < flipArea[4] then
          --print("x==",x)
          --print("x=="+x)
          --print("clickAreaL[3]=",clickAreaL[3])
          --print("clickAreaL[1]=",clickAreaL[1])
          if x > clickAreaL[3] and x < clickAreaR[1] and y > flipArea[2] and y < flipArea[4] then
          --if x > flipArea[1] and x < flipArea[3] and y > flipArea[2] and y < flipArea[4]  then
          --print("直的翻頁")
          local ph = event.phase
          local tmp = {}
         ------print("tarpage.no====",tarpage.no)
          if ph == "began" then
            numTouches = numTouches + 1

            table.insert(idList,event.id)
            table.insert(tmp,event.xStart)
            table.insert(tmp,event.yStart)
            table.insert(mutitouchPos,tmp)       

            bounds = pageList2[p1].contentBounds 
            if numTouches == 1 then
               mutitouchf = false
               mf = false
               oldx = event.xStart
               if scalef == false then
                --if flipType == 1 then
                  ----print("autof===",autof)
                  if turnf == false and autof == false then
                  --  ----print("turnf===true111111")
                    turnf = true
                  
                   -- pageList2[p1]= pageList2[p1]  
                  end

                  print("turnf===",turnf)
                -- else
                --  if turnf == false  then
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


            end

          elseif ph == "moved" then
            local tmp = {}
            table.insert(tmp,event.x)
            table.insert(tmp,event.y)
            local pos = wetools.getpos(event.id,idList)
            mutitouchPos[pos] = tmp

            --  if showtext == nil then
            --     showtext = display.newText( tostring( nowrate ), _W, _H, native.systemFontBold, 50 )
            --     showtext:setFillColor( 0 )
            -- else
            --   showtext.text = tostring(tostring( nowrate))
            -- end

            if nowrate == 1 then
              scalef = false
              scaleing = false
              gBackToScale = false
            end
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
               

                if nowrate < 1.1 and gBackToScale == false and mutirate < nowrate then
                      
                          if mutitouchf == true then

                            -- Runtime:removeEventListener("enterFrame",mutimoveFn)
                            mutitouchf = false
                           
                            -- pageList2[p1].x = pageList2[p1].x - pageList2[p1].anchorX*pageList2[p1].contentWidth
                            -- pageList2[p1].y = pageList2[p1].y - (pageList2[p1].anchorY-0.5)*pageList2[p1].contentHeight
                            -- pageList2[p1].anchorX = 0
                            -- pageList2[p1].anchorY = 0.5

                            --
                              mutimovefh = true
                              --mutimovefv = true
                              nowrate = 1
                              --Runtime:addEventListener("enterFrame",mutimoveFn)
                              scalef = false
                              scaleing = false
                              mutimoveFn()

                          end

                           mutitouchf = false
                            mutitouchPos ={}
                            idList = {}
                            numTouches = 0
                            gBackToScale = true
                           -- Runtime:removeEventListener("touch",turnPagefn)
                        

                else
                  if gBackToScale == false then
                    scalef =  true
                    scaleing = true
                    if math.abs(mutirate - nowrate) > 0.001 then
                      nowrate = mutirate
                      

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
                  end
                
                end
                  oldDistance = touchDistance
                --delaytime  = system.getTimer( )
              --end
            end

            
            -- if showtext2 == nil then
            --     showtext2 = display.newText( tostring( scalef ), _W, _H+50, native.systemFontBold, 50 )
            --     showtext2:setFillColor( 0 )
            -- else
            --   showtext2.text = tostring(tostring( scalef))
            -- end

            if mutitouchf == false then
              local vx = event.x - event.xStart
              
              if math.abs(vx) > 20  then
                  mf = true
                  local canturnf = false
                  if flipType == 1 and autof == true then
                    canturnf = false
                  else
                    canturnf = true
                  end

                  if scalef == false  then

                      if canturnf == true then

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
                                    --mask:toFront( )

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
                              -- if ddx == 0 then
                              --   gof = false
                              -- end
                              ----print("gof1===",gof)
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
                              print("gof========",gof)
                              if gof == true then

                                if flipType == 1 then

                                    if autof == false then
                                              local dx = event.x - pageList2[p1].x + 20 
                                              ang = math.acos(dx/pageList2[p1].pagewidth)*0.1
                                              ------print("pagewidth==",pagewidth)
                                              local x4 = dx - pageList2[p1].pagewidth
                                                ------print("x4==",x4)
                                                local pos1 = wetools.getpos2(mask,pageList)
                                                
                                                local pos = wetools.getpos2( pageList2[p1],pageList)
                                                if pos1 < pos-1 then
                                                  mask:toFront( )
                                                  pageList2[p1]:toFront()
                                                end


                                                
                                                if mask.x ~= pageList2[p1].x then
                                                  mask.x = pageList2[p1].x
                                                end
                                                ----print("mask.contentWidth=",mask.contentWidth)
                                                ----print("pageList2.contentwidth=",pageList2[p1].contentWidth)
                                              if x4 <=0 then
                                                    
                                                    ----print("-pagewidth*rate==",-originpagewidth)
                                                  if x4 < -pagewidth  then
                                                    pageList2[p1].path.x4 = -pageList2[p1].pagewidth
                                                    pageList2[p1].path.x3 = -pageList2[p1].pagewidth
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
                                                      
                                                      local nextpage_path = system.pathForFile( choice_bookcode.."/"..p1..".png", baseDir )
                                                      local mode = lfs.attributes(nextpage_path, "mode")
                                                      if mode == nil then
                                                        loadpage(p1)
                                                      else
                                                        arrangPageFn()
                                                      end
                                                      --arrangPageFn()
                                                    end

                                                    -- ----print("p1===",p1)
                                                    -- ----print("bbbbbbbb")
                                                  else
                                                    ----print("3836")
                                                     canautof = true
                                                    pageList2[p1].path.x4 = x4             
                                                    pageList2[p1].path.y4 = -pageList2[p1].pagewidth*math.sin(ang)           
                                                    pageList2[p1].path.x3 =  x4
                                                    pageList2[p1].path.y3 = -pageList2[p1].pagewidth*math.sin(ang)  
                                                    
                                                    local mx4 = x4  
                                                    local mratex = mask.orgx/pageList2[p1].width
                                                    local mratey = mask.orgy/pageList2[p1].height 

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
                                                    --print("mask.path.x4=="..mask.path.x4)
                                                   -- --print("pageList2[p1].path.x4=="..pageList2[p1].path.x4)
                                                    mask.path.y3 = -mratey*pageList2[p1].pagewidth*math.sin(ang)/4
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
                                                  
                                                  local nextpage_path = system.pathForFile( choice_bookcode.."/"..p1..".png", baseDir )
                                                  local mode = lfs.attributes(nextpage_path, "mode")
                                                  if mode == nil then
                                                    loadpage(p1)
                                                  else
                                                    arrangPageFn()
                                                  end
                                                  --arrangPageFn()
                                                end
                                                canautof = false
                                                turnf = false
                                                
                                                checkdir = true
                                                mask:toBack( )
                                              end
                                      end
                                else
                                  ----不翻頁
                                  ----print("3885")
                                  canautof = true
                                  
                                  for i = 1,pageList.numChildren do
                                     pageList[i].x = pageList[i].x + ddx
                                     
                                     -- if pageList[i].no == p1+1 then
                                     --  ----print(pageList[i].x)
                                     -- end
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
        elseif (ph == "ended" or ph == "canceled" )  then
          
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

               
                mutitouchf = false
               
                pageList2[p1].x = pageList2[p1].x - pageList2[p1].anchorX*pageList2[p1].contentWidth
                pageList2[p1].y = pageList2[p1].y - (pageList2[p1].anchorY-0.5)*pageList2[p1].contentHeight
                pageList2[p1].anchorX = 0
                pageList2[p1].anchorY = 0.5

                -- if nowrate <= 1.05 and mutimovefh == false then
                --   mutimovefh = true
                --   --mutimovefv = true
                --   nowrate = 1
                --   Runtime:addEventListener("enterFrame",mutimoveFn)
                  
                -- end
              end
                
                mutitouchPos ={}
                idList = {}
                numTouches = 0
                
          end
          ----print("numTouches前===",numTouches)
          numTouches = numTouches - 1
          ----print("numTouches後===",numTouches)
          if  numTouches < 0 then 
            numTouches = 0
          end
          canturnf = true
          if flipType == 1 and autof == true then
            canturnf = false
         
            
          end
          if mf == true  then
          if scalef == false and turnf == true then
            if canturnf == true then
                if mutitouchf == false then      
                  ----直向
                  turnf = false

                 -- if pageList2[p1].path.x4 < 0 and pageList2[p1].path.x4 > -pagewidth then
                  ----print("canautof===",canautof)
                  if canautof == true then
                    --tarpage = tarpage
                    if dir == "left" then
                      autovx = -100
                    else
                      autovx = 100
                    end

                      if autof == false then
                        local s = math.abs(event.x - event.xStart)
                        -- local v = s/(event.time/1000)                       
                        if s > 0 then
                          autof = true
                          Runtime:addEventListener("enterFrame",autoturnfn )
                        end
                      else
                        if dir == "left" then
                          if p1 +1 <= maxPage then
                            
                            p1 = p1 + 1  
                            
                              if p1+1 <= maxPage then
                                local page = display.newImage(path..(p1+1)..".png",baseDir,true)
                                
                                page.name = "book"..(p1+1)
                                page.originpagewidth = page.width
                                page.originpageheight = page.height
                                page.anchorX = 0
                                page.no = p1+1
                                pageList2[p1+1] = page
                                local rate1 = (_H*2-scrOrgy*2- statusbarHeight)/page.height
                                local rate2 = (_W*2-scrOrgx*2)/page.width

                                if rate1 <= rate2 then
                                  rate = rate1
                                else
                                  rate = rate2
                                end

                                page.rate = rate
                                page.nowrate = rate
                                page.rateh = rate
                                page:scale( rate, rate )
                                
                                page.x = _W*2 -scrOrgx

                                page.y = pageList2[p1].y
                                pageList:insert(page)
                                display.remove( pageList[1])
                                pageList[1] = nil
                                

                              end
                    
                          else
                              ----print("aaaaa")
                              Runtime:removeEventListener("enterFrame",autoturnfn )

                               autof = false
                          end
                        else
                          if p1 -1 >= 1 then
                            --print("p1-1===",p1-1)
                            p1 = p1 - 1  
                            
                              if p1 >= 1 then
                                local page = display.newImage(path..(p1)..".png",baseDir,true)
                                
                                page.name = "book"..(p1)
                                page.originpagewidth = page.width
                                page.originpageheight = page.height
                                page.anchorX = 0
                                page.no = p1
                                pageList2[p1] = page
                                local rate1 = (_H*2-scrOrgy*2- statusbarHeight)/page.height
                                local rate2 = (_W*2-scrOrgx*2)/page.width

                                if rate1 <= rate2 then
                                  rate = rate1
                                else
                                  rate = rate2
                                end

                                page.rate = rate
                                page.nowrate = rate
                                page.rateh = rate
                                page:scale( rate, rate )
                                --print("p1===",p1)                       
                                  --local dx = _W-scrOrgx - pageList2[i-1].contentWidth
                                page.x = -scrOrgx - page.contentWidth

                                page.y = pageList2[p1+1].y
                                pageList:insert(page)
                                page:toBack( )
                                display.remove( pageList[pageList.numChildren])
                                pageList[pageList.numChildren] = nil
                                

                              end
                    
                          else
                              ----print("aaaaa")
                              Runtime:removeEventListener("enterFrame",autoturnfn )

                               autof = false
                          end

                        end
                    -- autof = true
                      end
                    -- --print("autoturnfn2222222")
                    -- Runtime:addEventListener("enterFrame",autoturnfn )
                  else 
                    turnf = true
                  end  
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
                  local leftMax = scrOrgx + (_W*2-2*scrOrgx)*0.33  ----往右最大坐標

                 -- local left  = pageList2[pleft].x + contentWidth--pageList2[1].width
                  --local right  = pageList2[maxPage].x 
                    local left  = pageList2[maxPage].x 
                    local right = left + pageList2[maxPage].contentWidth
                    

                    if left > leftMax then
                       bigautof = true
                       dir = "right"
                       ----print("right")
                       
                    else  

                      if left > scrOrgx then
                        bigBackLeft = true

                        


                      end
                      if right < _W*2 - scrOrgx then
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
                  
                  local right  = pageList2[p1].x 

                 
                  if left < leftMax then
                
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

function htov()
    
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
    print("replace.....hhhvvvv")
    ------print("setupFirst==",setupFirst)
    setupFirst = true
    -- Runtime:removeEventListener("enterFrame",closeOptionFn)
    -- Runtime:removeEventListener("touch",turnPagefn)
    -- timer.performWithDelay( 500, replace )

    replace()
       
end

function vtoh()
    
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
    print("replace.....vvvvhhhh")
    ------print("setupFirst==",setupFirst)
    setupFirst = true
    -- Runtime:removeEventListener("enterFrame",closeOptionFn)
    -- Runtime:removeEventListener("touch",turnPagefn)
    
    replace()

end

local function onOrientationChange( event )
     g_curr_Dir = event.type

     g_curr_Dir = event.type
     local msg2 = display.newText( ("hpage = ".. g_curr_Dir), 300, 300, native.systemFont, 60 )

     msg2:setFillColor(0)
     -- local msg1 = display.newText( ("old = ".. g_old_Dir), 300, 200, native.systemFont, 60 )
     -- msg1:setFillColor(0)
     -- local msg2 = display.newText( ("new = ".. g_curr_Dir), 300, 300, native.systemFont, 60 )

     -- msg2:setFillColor(0)
     if g_curr_Dir == "faceUp" or g_curr_Dir == "faceDown" then
      g_curr_Dir = g_old_Dir
      --g_curr_Dir = g_old_Dir
    end
     
   if g_curr_Dir == "portrait" or g_curr_Dir == "portraitUpsideDown" then
     if g_old_Dir == "landscapeLeft" or g_old_Dir == "landscapeRight" then   
       
       --g_old_Dir = g_curr_Dir
       g_old_Dir = g_curr_Dir
       htov()
     end
   end

   if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
     if g_old_Dir == "portrait" or g_old_Dir == "portraitUpsideDown" then   
       
       --g_old_Dir = g_curr_Dir
       g_old_Dir = g_curr_Dir
       vtoh()
     end
   end

   -- if g_curr_Dir == "faceUp" or g_curr_Dir == "faceDown" then
   --    g_curr_Dir = g_old_Dir
   -- end

end


local function bookinfoTextFn(event)
  local ph = event.phase
  local etar = event.target
  if ph == "ended" then
    bookmarkBox:setFillColor( 239/255 )
    contentBox:setFillColor( 239/255 )
    bookmarkscroll.x = -10000
    contscroll.x = -10000
    bookinfoGroup.x = bookinfoGroup.orgx
    bookinfoBox:setFillColor( 221/255 )
  end
end

local function contentTextFn(event)
  local ph = event.phase
  local etar = event.target
  if ph == "ended" then
    bookmarkBox:setFillColor( 239/255 )
    bookinfoBox:setFillColor( 239/255 )
    clickAreaL[3] = bookmarkBox.x + bookmarkBox.contentWidth*0.5
    --setContentText(etar)
    --if bookmarkscroll.x == bookmarkscroll.orgx then
      bookmarkscroll.x = -10000
      
    --end 
    --if bookinfoGroup.x == bookinfoGroup.orgx then
      bookinfoGroup.x = -10000
    --end
    contentBox:setFillColor( 221/255 )
    contscroll.x = contscroll.orgx
  end

end

local function bookmarkTextFn(event)
  local ph = event.phase
  local etar = event.target
  if ph == "ended" then

   
    clickAreaL[3] = bookmarkBox.x + bookmarkBox.contentWidth*0.5
    print("bookmark.....")
    contentBox:setFillColor( 239/255 )
    bookinfoBox:setFillColor( 239/255 )
    --if #chapterpageList > 0 then
        --if contscroll.x == contscroll.orgx then
           contscroll.x = -10000
           bookinfoGroup.x = -10000
           
        --end

    --end 
    bookmarkBox:setFillColor( 221/255 )
    bookmarkscroll.x = bookmarkscroll.orgx
  end
end

local function fliponFn(event)
  
  if oldflipType == 0 and scalef == false then
    local ph = event.phase
    local etar = event.target
    if ph == "began" then
      
      --etar:setFillColor( 1,0,0 )
    elseif ph == "ended" or ph == "canceled" then
      --etar:setFillColor( 1,0,1 )
      -- optionBtnBase.x = -10000
      circel.x = etar.x
      oldflipType = 1
      --print("pleft===",pleft)
      if pleft == 1 then
        flipType = 0
        arrangPageFn2()
      else
        flipType = 1
        arrangPageFn()
      end
      --else
       -- arrangPageFn2()
      --end
      
    end
  end
  return true
end

local function flipoffFn(event)
  if oldflipType == 1 and scalef == false then
    local ph = event.phase
    local etar = event.target
    if ph == "began" then

      --etar:setFillColor( 1,0,0 )
    elseif ph == "ended" or ph == "canceled" then
      --etar:setFillColor( 1,0,1 )
      circel.x = etar.x
      flipType = 0
      oldflipType = 0
     
        arrangPageFn2()
      
      ----print("44444444444")
    end
  end
  return true

end

-- local function setOption(ta)
--   ta:setFillColor( 1,1,0 )
--   if optionItemGroup.numChildren >0 then
--     optionItemGroup.y = 0
--     if flipType == 1 then
--      circel.x = optionItemGroup[3].x
--    else
--      circel.x = optionItemGroup[4].x
--    end
--    flipArea[1] =  scrOrgx + optionItemGroup[1].width + 1
--   else
--     local boxUp = optionGroup[1]
--     local contbg = display.newRect( 0, 0, 300, _H*2-(optionGroup[1].height+optionGroup[2].height+statusbarHeight) )
--    contbg.x = scrOrgx+contbg.width*0.5
--    contbg.y = boxUp.y + (boxUp.height+contbg.height)*0.5 

--   --contbg.alpha = 0.5
--    contbg:setFillColor( 66/255,66/255,66/255 )

--    local fliptext = display.newText( "Flip",0,0,native.systemFont,40)
--    fliptext:setFillColor( 220/255,220/255,220/255 )
--    fliptext.x = contbg.x
--    fliptext.y = boxUp.y + (boxUp.height + fliptext.height)*0.5 + 20
--    local ontext = display.newText( "On",0,0,native.systemFont,40)
--    ontext:setFillColor( 1,1,0.5 )
--    ontext.x = scrOrgx + ontext.width*0.5+50
--    ontext.y = fliptext.y + ontext.height

--    ontext:addEventListener( "touch", fliponFn )

--    local offtext = display.newText( "Off",0,0,native.systemFont,40)
--    offtext:setFillColor( 1,1,0.5 )
--    offtext.x = scrOrgx + contbg.width -50-offtext.width*0.5
--    offtext.y = fliptext.y + offtext.height

--    offtext:addEventListener( "touch", flipoffFn )

--    circel = display.newImage( path_image.."circel.png" ,true )
--    if flipType == 1 then
--      circel.x = ontext.x
--    else
--      circel.x = offtext.x
--    end
--    circel.y = ontext.y

--    flipArea[1] =  scrOrgx + contbg.width + 1

--    optionItemGroup:insert(contbg)
--    optionItemGroup:insert(fliptext)
--    optionItemGroup:insert(ontext)
--    optionItemGroup:insert(offtext)
--    optionItemGroup:insert(circel)
--    sceneGroup:insert(optionItemGroup)
--   end
-- end


local function contscrollListener(event)
  local ph = event.phase
 
  if ph == "moved" then
    chaptermove = true
    if chapterBlock ~= nil then
      chapterBlock:setFillColor( 221/255 )
      chapterBlock.isVisible = false
      chapterBlock.isHitTestable = true
    end
  elseif ph == "ended" then
    if chaptermove == true then
    else
      ----跳chapter
      if chapterBlock ~= nil then
        chapterBlock:setFillColor( 221/255 )
        chapterBlock.isVisible = false
        chapterBlock.isHitTestable = true
        if chochapter >0 then
          contentGroup.y = -10000
          optionItemf = false
          -- display.remove( bookmarkBlock )
          -- bookmarkBlock = nil
          flipArea[1] =  scrOrgx
          --clickAreaL[3] = scrOrgx + clickWidth
          clickAreaL[3] = -10000
          jumpchapter(chochapter)
          chochapter = 0
        end
      end
    end

    chaptermove = false
  end
end








local function chapterFn(event)

  local ph = event.phase
  local etar = event.target

  if ph == "began" then
        
        if chapterBlock ~= nil then
          chapterBlock:setFillColor( 221/255 )
          chapterBlock.isVisible = false
          chapterBlock.isHitTestable = true
        end
        chochapter = event.target.no
        etar:setFillColor( 182/255)
        etar.alpha = 0.85
        etar.isVisible = true
        chapterBlock = etar
  end
end


local function infoMoreFn(event)
  local ph = event.phase
  if ph == "ended" then
  --http://portal.igpublish.com/iglibrary/public/BEPB0000002.html
    local path = "http://portal.igpublish.com/iglibrary/public/"..choice_bookcode..".html"
    system.openURL( path )
  end
  return true
end



local function setContents(ta)
  
  --print(contentGroup.numChildren)
  if contentGroup.numChildren > 0 then
    contentGroup.y = 0
    --if #chapterpageList > 0 then
    if bookinfoGroup ~= nil then
      bookinfoGroup.x = bookinfoGroup.orgx
    end
      --contscroll.x = contscroll.orgx
      contscroll.x = -100000
      bookmarkscroll.x = -10000
      contentBox:setFillColor( 239/255 )
      bookmarkBox:setFillColor( 239/255 )
      bookinfoBox:setFillColor( 221/255 )
    --end
    flipArea[1] =  scrOrgx + contentGroup[1].width + 1

  else

    local boxUp = optionGroup[1]
    local contbg = display.newRect( 0, 0, contwidth, _H*2-(optionGroup[1].height+optionGroup[2].height+statusbarHeight)-2*scrOrgy )
   contbg.x = scrOrgx+contbg.width*0.5
   contbg.y = boxUp.y + (boxUp.height+contbg.height)*0.5
   contheight = contbg.height
   contbg.alpha = 0.9
  --contbg.alpha = 0.5
   contbg:setFillColor( 221/255)--66/255,66/255,66/255 )
   --contbg:setFillColor( 0.6 )
   
   flipArea[1] =  scrOrgx + contbg.width + 1
   clickAreaL[3] = scrOrgx + contbg.width + 1
    local bookinfoText = nil
    local contentText = nil
    local bookmarkText = nil
   -- if #chapterpageList > 0  then
       bookinfoBox = display.newRect(  0, 0, contwidth/3, optionBoxUp*optionrate )
       bookinfoBox:setFillColor( 211/255 )
       bookinfoBox.x = scrOrgx + bookinfoBox.contentWidth*0.5
       bookinfoBox.y = boxUp.y + (boxUp.height + bookinfoBox.height)*0.5
       bookinfoText = display.newText("Book Info", 0, 0, native.systemFont, fontSize+12 )
       bookinfoText.x = bookinfoBox.x
       bookinfoText.y = bookinfoBox.y
       bookinfoText:setFillColor( 89/255,85/255,86/255 )
       bookinfoText:addEventListener( "touch", bookinfoTextFn)

       contentBox = display.newRect( 0, 0, contwidth/3, optionBoxUp*optionrate )
       contentBox:setFillColor( 239/255)--0.5,0.5,0.8 )
       contentBox.x = bookinfoBox.x + (bookinfoBox.width+contentBox.width)*0.5
       contentBox.y = boxUp.y + (boxUp.height+contentBox.height)*0.5
       contentText = display.newText( "Table of Content",0,0,native.systemFont,fontSize + 12)
       contentText.x = contentBox.x
       contentText.y = contentBox.y
       contentText:setFillColor( 89/255,85/255,86/255 )
       contentBox:addEventListener( "touch", contentTextFn )
       --contwidth-bookinfoBox.contentWidth - contentBox.contentWidth
       bookmarkBox = display.newRect( 0, 0, contwidth/3, optionBoxUp*optionrate )
       bookmarkBox:setFillColor( 239/255)--0.8,0.5,0.5 )
       bookmarkBox.x = contentBox.x + (contentBox.width+bookmarkBox.width)*0.5
       bookmarkBox.y = contentBox.y
       bookmarkText = display.newText("Bookmark",0,0,native.systemFont,fontSize + 12)
       bookmarkText.x = bookmarkBox.x
       bookmarkText.y = bookmarkBox.y
       bookmarkText:setFillColor( 89/255,85/255,86/255 )
       bookmarkBox:addEventListener( "touch", bookmarkTextFn)
    --end
    


    --book info content
    local infoPeriod = 40
    local infoTop = 0
    local infoFontSize = 58

    if g_curr_Dir == "portrait" or g_curr_Dir == "portraitUpsideDown" then
      infoPeriod = 60
      infoTop = 40
      --infoFontSize = 58
    end

    local top1 =  scrOrgy+statusbarHeight+optionBoxUp*optionrate+contentBox.height

    bookinfoGroup = widget.newScrollView
    {
      left = scrOrgx,
      top =top1 + 20,
           
      width = contbg.width,
      height = contbg.height -contentBox.height - 20,
              
      
              --leftPadding  =0,
      id = "bookinfogroup",
      hideBackground  = true,
      horizontalScrollDisabled = true,
      verticalScrollDisabled = false,
      listener = bookinfoListener,
    }

    local infoTitle = display.newText(  gBookInfo.title, 0, 0, contwidth - 60,0,native.systemFont, infoFontSize )
    infoTitle:setFillColor( 89/255,85/255,86/255 )
    infoTitle.anchorX = 0 
    infoTitle.x =  30
    --infoTitle.y = bookinfoBox.y + (bookinfoBox.height + infoTitle.contentHeight)/2 + infoTop
    infoTitle.y = infoTitle.height/2 
    local infoAuthor = display.newText(  gBookInfo.author, 0, 0 , contwidth - 60,0,native.systemFont, infoFontSize - 20 )
    infoAuthor.anchorX = 0
    infoAuthor.x = infoTitle.x
    infoAuthor.y = infoTitle.y + infoTitle.height/2 + infoPeriod
    infoAuthor:setFillColor( 89/255,85/255,86/255 )

    local infoPublisher = display.newText(  gBookInfo.publisher, 0, 0 ,contwidth - 60,0, native.systemFont, infoFontSize - 20 )
    infoPublisher.anchorX = 0
    infoPublisher.x = infoTitle.x
    infoPublisher.y = infoAuthor.y + (infoAuthor.height + infoAuthor.height)/2 + infoPeriod - 10
    infoPublisher:setFillColor( 89/255,85/255,86/255 )

    local infoPage = display.newText(  "Page "..gBookInfo.page, 0, 0 ,contwidth - 60,0, native.systemFont, infoFontSize - 20 )
    infoPage.anchorX = 0
    infoPage.x = infoTitle.x
    infoPage.y = infoPublisher.y + (infoPublisher.height + infoPage.height)/2 + infoPeriod - 10
    infoPage:setFillColor( 89/255,85/255,86/255 )

    local infoMore = display.newText(  "More...", 0, 0,  native.systemFont, infoFontSize -10 )
    infoMore.x = scrOrgx + contwidth*0.5
    infoMore.y = infoPage.y + (infoPage.height + infoMore.height-40)*0.5 + infoPeriod - 10
    infoMore:setFillColor( 0 ) 
    infoMore:addEventListener( "touch", infoMoreFn)

    bookinfoGroup:insert(infoTitle)
    bookinfoGroup:insert(infoAuthor)
    bookinfoGroup:insert(infoPublisher)
    bookinfoGroup:insert(infoPage )
    bookinfoGroup:insert(infoMore)

    local bookinfoHieght = 0
    bookinfoHieght = bookinfoHieght + infoTitle.height
    bookinfoHieght = bookinfoHieght + infoAuthor.height
    bookinfoHieght = bookinfoHieght + infoPublisher.height
    bookinfoHieght = bookinfoHieght + infoPage.height
    bookinfoHieght = bookinfoHieght + infoMore.height
    print("bookinfoHieght1=",bookinfoHieght)
    print("contbg.height=",contbg.height)
    bookinfoHieght = math.max( contbg.height, bookinfoHieght )
    print("bookinfoHieght2=",bookinfoHieght)
    bookinfoGroup:setScrollHeight( bookinfoHieght  )
    bookinfoGroup.orgx = bookinfoGroup.x
    print("bookinfoGroup.y=",bookinfoGroup.y)
    -- table of content
    local totalhight =  20--statusbarHeight + scrOrgy*0.15
    local totalhight_bookmark =  20-- statusbarHeight + scrOrgy*0.15
    local btext = ""
    local textheight = 30
    local fsize = 30

    local top =  scrOrgy+statusbarHeight+optionBoxUp*optionrate


    
    if #chapterpageList > 0 then
        top = scrOrgy+statusbarHeight+optionBoxUp*optionrate+contentBox.height
        contscroll = widget.newScrollView
          {            
              left = scrOrgx,
              top =top + 20,
           
              width = contbg.width,
              height = contbg.height-contentBox.height -20,
              
              upPadding = 60,
              buttomPadding  =0,
              --leftPadding  =0,
              id = "contscroll",
              hideBackground  = true,
              horizontalScrollDisabled = true,
              verticalScrollDisabled = false,
              listener = contscrollListener,
          }
        
        
        for i = 1,#chapterList do
          local chapterbox = display.newRect( 0, 0, contwidth, 100 )
          chapterbox.x = contbg.x
          chapterbox:setFillColor( 221/255)
          chapterbox.alpha = 0.85
          chapterbox.isVisible = false
          chapterbox.isHitTestable = true
          chapterbox.no = tonumber(chapterpageList[i])
          chapterbox.anchorY = 0
          contscroll:insert(chapterbox)
          local chapter = display.newText("P "..chapterbox.no,0,totalhight,native.systemFontBold,fontSize + 10)--36)
          chapter.x =  chapter.width*0.5 + 20
          chapter.y = totalhight+20 - chapter.contentHeight
          chapter:setFillColor( 89/255,85/255,86/255 )
          chapter.anchorY = 0
          ----print("chapter.x==",chapter.x)
          --chapter:setFillColor( 1,0,0 )
          --totalhight = totalhight + chapter.height+chapter.height*0.5
          contscroll:insert(chapter)
          btext = chapterList[i]
          --print("btext==",btext)
          local options = 
          { 
                  --parent = groupObj,
              text =btext,     
              x = scrOrgx,
              y = totalhight,
              width = contwidth*0.82,            --required for multiline and alignment
              --height = textheight,           --required for multiline and alignment
              font = native.systemFont,   
              fontSize = fontSize+10,
              align = "left"          --new alignment field
          }

          local title = display.newText( options )
          title.anchorY = 0
          title.x = title.width*0.5+20 + chapter.contentWidth + 20
          title.y = chapter.y 
          --+ (title.height+chapter.height)*0.5 + 6
          title:setFillColor( 89/255,85/255,86/255 )
          title.no = tonumber(chapterpageList[i])
         
          chapterbox:toBack( )
      
          chapterbox:addEventListener( "touch", chapterFn )
          totalhight = totalhight + title.height + 20
          
          --local high = totalhight - chapter.y+chapter.height*0.5
          local high = title.contentHeight + 10
          -- if high > 160 then
          --   high = high + 10
            
          --   chapterbox.y = chapter.y + 12
          -- else
            
          --   chapterbox.y = chapter.y
          -- end
          chapterbox.y = chapter.y - 5
          chapterbox.height =  high--chapter.height + title.contentHeight + 20
        
          contscroll:insert(title)


        end

        contscroll:setScrollHeight( totalhight +20 )
        contscroll.orgx = contscroll.x
        contscroll.x = -100000
    end
    

    local hight = contbg.height
    if #chapterpageList > 0 then
        hight = contbg.height-contentBox.height
    end

    --bookmark content
    bookmarkscroll = widget.newScrollView
      {            
          left =scrOrgx,
          top =top,
       
          width = contbg.width,
          height = hight,
          
        
          rightPadding  =0,
          buttomPadding  =0,
          id = "bookmarkscroll",
          hideBackground  = true,
          horizontalScrollDisabled = true,
          verticalScrollDisabled = false,
          listener = bookmarkscrollListener,
      }
    bookmarkscroll.orgx = bookmarkscroll.x
    --if #chapterpageList > 0 then
      bookmarkscroll.x = -1000000
    --end
    if #bookmarkNumList > 0 then
      
      for i = 1,#bookmarkNumList do
        
        local marknum = display.newText("P "..bookmarkNumList[i],0,totalhight_bookmark,native.systemFontBold,fontSize )
        --local del = display.newText( "Del",0,0,native.systemFont,40)
        local del = display.newImage( "button/b_cencel02.png" ,resDir  )

        local nextpage_path = system.pathForFile( path_thumb..bookmarkNumList[i]..".png", baseDir )
                          local mode = lfs.attributes(nextpage_path, "mode")
                          --
                          local img = nil
                          
                          if mode == nil then
                            img = display.newRect( 0, 0, 150, 200 )
                            img.alpha = 0.5
                            --back = display.newRect(  0, 0, 170, 220 )
                            --back:setFillColor(0.7)
                          else
                            img = display.newImage( path_thumb..bookmarkNumList[i]..".png",baseDir)
                            --back = display.newRect(  0, 0, img.width + 20, img.height + 20 )
                            --back:setFillColor(0.7)
                          end 

                  if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
                    local dx = ((_W*2 - 2*scrOrgx) - 6*img.contentWidth)/7
                    local dw = img.contentWidth*0.5
                   
                    local num = i%6
                    if num == 0  then
                      num = 6
                    end
                    img.x = num*dx + ((num-1)*2+1)*dw
                    img.y = 160 + math.floor( (i-1)/6 )*(img.contentHeight+80)
                  else
                    local dx = ((_W*2 - 2*scrOrgx) - 4*img.contentWidth)/5
                    local dw = img.contentWidth*0.5
                    
                    local num = i%4
                    if num == 0 then
                      num = 4
                    end
                    img.x = num*dx + ((num-1)*2+1)*dw
                    img.y = 160 + math.floor( (i-1)/4 )*(img.contentHeight+80)
                  end

        --marknum:setFillColor( 1,0,0 )
        img.no = tonumber(  bookmarkNumList[i] )
        img:addEventListener( "touch", gobookmarkFn )
        marknum.x =  img.x--marknum.width*0.5 + 20
        marknum.y =  img.y + (marknum.height+img.height)/2 + 10--totalhight_bookmark + 2
        marknum:setFillColor( 89/255,85/255,86/255 )
        del.x = img.x + img.width/2--contwidth - del.width*0.5-5
        del.y = img.y - img.height/2--marknum.y
        print("fontSize==",fontSize)
        del:scale( 0.5, 0.5 ) 
        --local dx = contwidth*0.5+(del.x-(scrOrgx+contwidth*0.5)-del.contentHeight*0.5)  
        -- if contwidth == 640 then
        --   dx = contwidth - 80

        -- end    
        -- soh
        marknum.no = tonumber(  bookmarkNumList[i] )
        del.no = tonumber(  bookmarkNumList[i] )
        --totalhight_bookmark = totalhight_bookmark + marknum.height  + marknum.height*0.5
        -- bookmarkBack.no = del.no
        -- bookmarkBack.orgwidth = bookmarkBack.contentWidth
        -- bookmarkBack:addEventListener( "touch", gobookmarkFn )
        totalhight_bookmark = totalhight_bookmark  + marknum.height + 40
        del:addEventListener( "touch", delbookmarkFn )
        --bookmarkscroll:insert(bookmarkBack)
        bookmarkscroll:insert(marknum)
        
        bookmarkscroll:insert(img) 
        bookmarkscroll:insert(del)    
        ----print("bookmarkscroll[2][1].numChildren======",bookmarkscroll[2][1].numChildren)
      end
     
    end
    print()
    contentGroup:insert(contbg)
    --if #chapterpageList > 0 then
      contentGroup:insert(bookinfoBox)
      contentGroup:insert(bookinfoText)
      contentGroup:insert(contentBox)
      contentGroup:insert(contentText)
      contentGroup:insert(bookmarkBox)
      contentGroup:insert(bookmarkText)
      contentGroup:insert(bookinfoGroup)
    --end
    
    contentGroup:insert(contscroll)
    contentGroup:insert(bookmarkscroll)
    sceneGroup:insert(contentGroup)
  end

end

local function changeArea()
    --flipArea[1] = scrOrgx 

    flipArea[2] =  scrOrgy + statusbarHeight ----up
  
    flipArea[4] =  -scrOrgy + _H*2 --down

   -- clickAreaL[2] = scrOrgy +statusbarHeight
   
    --clickAreaL[4] = -scrOrgy + _H*2

    --clickAreaR[2] = scrOrgy +statusbarHeight
   
    --clickAreaR[4] = -scrOrgy + _H*2
    ----print("smallPageGroup.y==",smallPageGroup.y)
end
local function openOption()
   print("openOption.......")
  for i = 1,optionGroup.numChildren do
      transition.to( optionGroup[i], { time=300, y=optionGroup[i].lasty} )
    end
    transition.to(smallPageGroup,{time = 300,y = smallPageGroup.lasty})
    optionf = true
    -- flipArea[2] =  scrOrgy + optionBoxUp + statusbarHeight----up
  
    -- flipArea[4] =  -scrOrgy + _H*2 - optionBoxDown --down

    --clickAreaL[2] = scrOrgy + optionBoxUp + statusbarHeight
   
    --clickAreaL[4] = -scrOrgy + _H*2 - optionBoxDown

    --clickAreaR[2] = scrOrgy + optionBoxUp + statusbarHeight
   
    --clickAreaR[4] = -scrOrgy + _H*2 - optionBoxDown
    ----print("flipArea[2]==========",flipArea[2])
end

local function closeOption()
  print("closeOption...")

  if optionGroup ~= nil  then
    if type(optionGroup.numChildren) == "number" then
      for i = 1,optionGroup.numChildren do
          transition.to( optionGroup[i], { time=300, y=optionGroup[i].orgy} )
      end
      transition.to(smallPageGroup,{time = 300,y = smallPageGroup.orgy})
      optionf = false
      timer.performWithDelay( 500, changeArea )

      


      if optionItemGroup.numChildren > 0 then
        if optionItemGroup.y == 0 then
          --option:setFillColor( 1,1,1 )
          optionItemGroup.y = -10000
        end
      end
    end 
  end
  if type(contentGroup.numChildren) == "number" then
    if contentGroup.numChildren > 0 then
      if contentGroup.y == 0 then
        
        optionItemf = false

       flipArea[1] =  scrOrgx
          --clickAreaL[3] = scrOrgx + clickWidth
          clickAreaL[3] = -10000
        contentGroup.y = -10000
      end
    end
  end
end



function closeOptionFn(event)
  local ot =  system.getTimer( ) -setupt 
  --print("ot===",ot)
  --local contents = display.newText( tostring(ot),200,300,native.systemFont,80)
  if ot > 1500 then
    print("close")

    

    closeOption()
    setupFirst = false
    
    last_composer = composer.getSceneName( "previous" )
    if last_composer ~= nil and last_composer ~= curr_composer then
        
        composer.removeScene(last_composer) -- call view_b destory function
        last_composer = curr_composer
        ----composer.removeScene("bookshelf")
     end
     --print("remove222222")
    Runtime:removeEventListener("enterFrame",closeOptionFn)
    
  end

end

local function boxUpFn(event)
  if exitf == false then
      local ph = event.phase
      if ph == "ended" or ph == "canceled" then
        if setupFirst == true then
          setupFirst = false
         --print("remove3333333")
          Runtime:removeEventListener("enterFrame",closeOptionFn)
        end
        
        optionItemf = false
        flipArea[1] =  scrOrgx
           -- clickAreaL[3] = scrOrgx + clickWidth
           clickAreaL[3] = -10000
        display.remove( bookmarkBlock )
            bookmarkBlock = nil
        ----print("3333")
        print("boxup")
        closeOption()
      end
  end
end
local function exit(event)
  print("exitttttttt")
  local ph = event.phase
  if ph == "ended" then
    optionItemf = false
    exitf = false
      if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
          if pleft > 1 then
            gProfile.updatelastpage( choice_bookcode, tostring(pleft-1) )
          else
            gProfile.updatelastpage( choice_bookcode, tostring(1) )
          end
        else
          gProfile.updatelastpage( choice_bookcode, tostring(p1) )
        end
       
        last_composer = composer.getSceneName( "previous" )
        if last_composer ~= nil and last_composer ~= curr_composer then

            composer.removeScene(last_composer) -- call view_b destory function
            last_composer = curr_composer
            ----composer.removeScene("bookshelf")
         end
          gNaviBar.NaviBarShow(true)
          
           -- writeData()
        

           local idPath = choice_bookcode .. "/"
           print("gNowPrecent======== ",gNowPrecent)
              local path = system.pathForFile( idPath.."precent.txt", baseDir )
              local fh, errStr = io.open( path, "w" )
              if fh then
                fh:write( gNowPrecent )
                io.close( fh )
              else
                fh:write( gNowPrecent )
                io.close( fh )
              end
        gFirstEnterBook = false
        if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
            
          composer.gotoScene("scene_bookshelf_h")
        else
             
          composer.gotoScene("scene_bookshelf")
        end
  end
  return true
end

local function notexit (event)
  local ph = event.phase
  if ph == "ended" then
    optionItemf = false
    exitf = false
    for i=1,noticeGroup.numChildren do
      display.remove( noticeGroup[1] )
      noticeGroup[1] = nil
    end
  end
  return true
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
                local lastpage
                if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
                    if pleft > 1 then
                      lastpage = tostring( pleft-1 )
                      --gProfile.updatelastpage( choice_bookcode, tostring(pleft-1) )
                    else
                      lastpage = tostring(1)
                      --gProfile.updatelastpage( choice_bookcode, tostring(1) )
                    end
                  else
                    lastpage = tostring( p1)
                    --gProfile.updatelastpage( choice_bookcode, tostring(p1) )
                  end
                 
                  local idPath = choice_bookcode .. "/"
                  local path = system.pathForFile( idPath.."lastpage.txt", baseDir )
                  local fh, errStr = io.open( path, "w" )
                  fh:write( lastpage )
                  io.close( fh )

                  last_composer = composer.getSceneName( "previous" )
                  if last_composer ~= nil and last_composer ~= curr_composer then

                      composer.removeScene(last_composer) -- call view_b destory function
                      last_composer = curr_composer
                      ----composer.removeScene("bookshelf")
                   end
                    gNaviBar.NaviBarShow(true)
                   
                      --writeData()
                   gTransf = false
                   gEnterBookf = false
                   --local idPath = choice_bookcode .. "/"
           print("gNowPrecent======== ",gNowPrecent)
                  gFirstEnterBook = false
                  if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
                      
                    composer.gotoScene("scene_bookshelf_h")
                  else
                       
                    composer.gotoScene("scene_bookshelf")
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

    
    

function arrang()
    -- local text = display.newText( tostring(exitf),200,200,native.systemFontBold,50 )
    -- text:setFillColor( 1,0,0 )
    if exitf == false then
        optionItemf = true
        local bg = display.newRect( _W, _H, _W*2-scrOrgx*2, _H*2-scrOrgy*2 )
        bg:setFillColor( 0 )
        bg.alpha = 0.7
        exitf = true
        local word = "Would you like to close the book ?"
        print("checkover===",checkOver)
        if checkOver == 0 then
          word = "The book download process not complete, would you like to close the book ?"
          noticetext = display.newText( word ,0,0,_W*1.8,0,native.systemFontBold,40)
        else
          noticetext = display.newText( word ,0,0,native.systemFontBold,40)
        end
        noticetext:setFillColor( 1)
        noticetext.x = _W
        noticetext.y = _H - 50

        local yestext = Button_Yes(noticetext.y+100)
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
        sceneGroup:insert(noticeGroup)
    end
end



local function libraryFn(event)
  local ph = event.phase
  local etar = event.target
  
  if ph == "began" then
    --etar:setFillColor( 1,0,0 )
    --optionBtnBase.x = etar.x
    --optionBtnBase.y = etar.y
    --optionBtnBase.width = etar.width
  elseif ph == "ended" then
    --etar:setFillColor( 1,1,1 )
    if exitf == false then
      optionItemf = true
      local bg = display.newRect( _W, _H, _W*2-scrOrgx*2, _H*2-scrOrgy*2 )
      bg:setFillColor( 0 )
      bg.alpha = 0.7
      exitf = true
      local noticetext = nil
      local word = "Would you like to close the book ?"
        print("checkover===",checkOver)
        if checkOver == 0 then
          word = "The book download process not complete, would you like to close the book ?"
          noticetext = display.newText( word ,0,0,_W*1.8,0,native.systemFontBold,40)
        else
          noticetext = display.newText( word ,0,0,native.systemFontBold,40)
        end

  
      noticetext:setFillColor(1)
      --noticetext.align = "right"
      noticetext.x = _W
      noticetext.y = _H - 80




      local yestext = Button_Yes(noticetext.y+100)
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
      sceneGroup:insert(noticeGroup)
    end
    -- if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
    --   if pleft > 1 then
    --     gProfile.updatelastpage( choice_bookcode, tostring(pleft-1) )
    --   else
    --     gProfile.updatelastpage( choice_bookcode, tostring(1) )
    --   end
    -- else
    --   gProfile.updatelastpage( choice_bookcode, tostring(p1) )
    -- end
   
    -- if last_composer ~= nil and last_composer ~= curr_composer then

    --     composer.removeScene(last_composer) -- call view_b destory function
    --     last_composer = curr_composer
    --     ----composer.removeScene("bookshelf")
    --  end
    --   gNaviBar.NaviBarShow(true)
    --   gOptnBar.OptnBarShow(true)
    --   gFootBar.FootBarShow(true)
    -- if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
        
    --   composer.gotoScene("bookshelf_h")
    -- else
         
    --   composer.gotoScene("bookshelf")
    -- end
  end
  return true
end
local function contentsFn(event)
  if exitf == false then
      local ph = event.phase
      local etar = event.target
      if ph == "began" then
         --etar:setFillColor( 1,0,0 )
          -- optionBtnBase.x = etar.x
          -- optionBtnBase.y = etar.y
          -- optionBtnBase.width = etar.width
      elseif ph == "ended" then
        --print("remove444444")
        --optionBtnBase.x = -10000
        Runtime:removeEventListener("enterFrame",closeOptionFn)
        if  optionItemGroup.numChildren > 0 then
          if optionItemGroup.y == 0 then

            optionItemGroup.y = -10000
          end
        end
        if contentGroup.numChildren > 0 then
          if contentGroup.y == 0 then
            --etar:setFillColor( 1,1,1 )
              
              contentGroup.y = -10000
              optionItemf = false

              display.remove( bookmarkBlock )
            bookmarkBlock = nil
              flipArea[1] =  scrOrgx
            --clickAreaL[3] = scrOrgx + clickWidth
            clickAreaL[3] = -10000
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
  
-- local function optionFn(event)
--   local ph = event.phase
--   local etar = event.target
--   if ph == "began" then
--      --etar:setFillColor( 1,0,0 )
--   elseif ph == "ended" then
--     --etar:setFillColor( 1,1,1 )
--     --contents:setFillColor( 1,1,1 )
--     --print("remove5555555")
--     Runtime:removeEventListener("enterFrame",closeOptionFn)
--     if contentGroup.numChildren > 0 then
--       if contentGroup.y == 0 then
--         contentGroup.y = -10000
--       end
--     end
--     if  optionItemGroup.numChildren > 0 then
--       if optionItemGroup.y == 0 then
--         --etar:setFillColor( 1,1,1 )
--         optionItemGroup.y = -10000
--         optionItemf = false
--         -- display.remove( bookmarkBlock )
--         -- bookmarkBlock = nil
--         flipArea[1] =  scrOrgx
--         clickAreaL[3] = scrOrgx + clickWidth
--       else
--         optionItemf = true
--         setOption(etar)
--       end
--     else
--       optionItemf = true
--       setOption(etar)
--     end
    
--   end
-- end

local function reloadFn(event)
  if exitf == false then
    local ph = event.phase
    local etar = event.target
    local orgW = etar.contentWidth
    local orgH = etar.contentHeight
    print("orgw=",orgW)
    print("orgh=",orgH)
    if ph == "began" then
      
      etar.width = orgW*1.1
      etar.height = orgH*1.1
    elseif ph == "ended" or ph == "canceled" then
      print("orgw2=",orgW)
      print("orgh2=",orgH)
      etar.width = orgW/1.1
      etar.height = orgH/1.1
      reloadf = true

      
          if gNetworkStatus == false then
              -------沒有網路
              print("沒有網路")
                  local function onComplete( event )
                     if event.action == "clicked" then
                          local i = event.index
                          if i == 1 then
                              -- Do nothing; dialog will simply dismiss
                          
                          end
                      end
                  end
                  reloadf = false
                  -- Show alert with two buttons
                  local alert = native.showAlert( "Network Error !!", "Please make sure internet connected and try again", { "OK" } )
          else
            --print("有網路")
            if loadingBtn.isVisible == false then
                if gNowPrecent < 100 then
                  startLoadFn()
                else
                    if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
                  if pleft == 1 then
                    -- local nextpage_path = system.pathForFile( choice_bookcode.."/"..pleft..".png", baseDir )
                    -- local mode = lfs.attributes(nextpage_path, "mode")
                    -- if mode == nil then
                      loadpage(pleft)
                      
                    --end
                  elseif pleft > maxPage then
                    -- local nextpage_path = system.pathForFile( choice_bookcode.."/"..maxPage..".png", baseDir )
                    -- local mode = lfs.attributes(nextpage_path, "mode")
                    -- if mode == nil then
                      loadpage(maxPage)
                      
                      
                    --end    
                  else   
                    -- local nextpage_path = system.pathForFile( choice_bookcode.."/"..(pleft-1)..".png", baseDir )
                    -- local mode = lfs.attributes(nextpage_path, "mode")
                    -- local nextpage_path2 = system.pathForFile( choice_bookcode.."/"..(pleft)..".png", baseDir )
                    -- local mode2 = lfs.attributes(nextpage_path2, "mode")
                    -- if mode == nil and mode2 == nil then
                      loadpage2(pleft-1)
                      print("dfadfsfsafadfafa")
                    -- elseif mode == nil then
                    --   loadpage(pleft-1)
                      
                    -- elseif mode2 == nil then
                    --   loadpage(pleft)   
                      
                    -- end
                  end
                else
                  -- local nextpage_path = system.pathForFile( choice_bookcode.."/"..p1..".png", baseDir )
                  -- local mode = lfs.attributes(nextpage_path, "mode")
                  -- if mode == nil then
                   -- print("reload......")
                    loadpage(p1)  
                    
                  --end
                end
                end
                
            end
          end
          
    
        print("aaaaaa")
    end
  end
  return true
end

local function onoffFn(event)
  if exitf == false then
      local ph = event.phase
      local etar = event.target

      if ph == "began" then
          --optionBtnBase.x = etar.x
          --optionBtnBase.y = etar.y
          --optionBtnBase.width = etar.contentWidth
      elseif ph == "ended" or ph == "canceled" then
          --optionBtnBase.x = -10000
        if oldflipType == 0 and scalef == false then
          gProfile.setSystemParameter("flipeffect", "on")
          etar:stopAtFrame ( 2 )
          oldflipType = 1
          if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
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
     

      page.path.x1 = originpagewidth*2
      page.path.x2 = originpagewidth*2

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

        tmp:toFront( )
      end
  
      mask:toBack( )

    else
      pageList2[1]:toFront( )
    end
end







function exitHelpFn(event)
  local ph = event.phase
  if ph == "ended" then
                  optionItemf = false
                  exitf = false
                  for i=1,noticeGroup.numChildren do
                    display.remove( noticeGroup[1] )
                    noticeGroup[1] = nil
                  end
            end
  return true
end

function arrangHelp()

  if exitf == false then
    local bg = display.newRect( _W, _H, _W*2-display.screenOriginX*2, _H*2-display.screenOriginY*2 )
        bg:setFillColor( 0 )
        bg.alpha = 0.7
        exitf = true
        
    local helpbg = display.newImage(  "image/help.png" ,system.ResourceDirectory )
    helpbg.x = _X
    helpbg.y = _Y

    local noBtn = display.newImage(  "button/b_no.png" ,system.ResourceDirectory  )
    noBtn.width = 80
    noBtn.height = 80
    noBtn.x = noBtn.width*0.5 + display.screenOriginX + 40
    noBtn.y = noBtn.height*0.5 + display.screenOriginY + 40
    noBtn:addEventListener( "touch", exitHelpFn )
        --local yestext = Button_Yes2(noticetext.y+100)
        --local notext  = Button_No2(noticetext.y+100)


        noticeGroup:insert(bg)
        noticeGroup:insert(helpbg)
        noticeGroup:insert(noBtn)
        --noticeGroup:insert(notext)
        noticeGroup:toFront( )
  end

end

function helpFn(event)
  local ph = event.phase
  if ph == "ended" then
    --arrangHelp()
    local path = "http://www.igpublish.com/guides/iglibrary/en/html/igpreader.html"
    system.openURL( path )
  end
  return true
end

function showOption()
      local boxUp = display.newRect( 0, 0, _W*2-scrOrgx*2, optionBoxUp*optionrate )
      boxUp.x = _W
      boxUp.y = -boxUp.height*0.5 + scrOrgy
      boxUp.orgy = boxUp.y
      boxUp.lasty = boxUp.height*0.5+ statusbarHeight + scrOrgy
      boxUp:setFillColor(54/255,53/255,55/255)--0.8)
      boxUp:addEventListener( "touch",boxUpFn )
      boxDown = display.newRect( 0, 0, _W*2-scrOrgx*2, optionBoxDown )
      boxDown.x = _W
      boxDown.y = _H*2 + boxDown.height*0.5 -scrOrgy
      boxDown.orgy = boxDown.y
      boxDown.lasty  = _H*2-boxDown.height*0.5 -scrOrgy
      --boxDown:addEventListener( "touch", smallpageFn ) 
      boxDown:addEventListener( "touch", boxDownFn )   
      boxDown:setFillColor( 66/255,66/255,66/255 )
      boxDown.alpha = 0.5
     
      library = display.newImage( path_image.."b_backbookshelf.png" ,resDir,true )
      library:scale( optionrate, optionrate )
      library.x = scrOrgx + library.contentWidth*0.5
      library.y = -boxUp.height*0.5 + scrOrgy
      library.orgy = library.y
      library.lasty = boxUp.height*0.5 + statusbarHeight + scrOrgy
      library:addEventListener( "touch", libraryFn )

      contents = display.newImage( path_image.."b_toc.png" ,resDir,true )
      contents:scale( optionrate, optionrate )
      contents.x = library.x + (library.contentWidth+contents.width)*0.5 
      contents.y = -boxUp.height*0.5 + scrOrgy
      contents.orgy = contents.y 
      contents.lasty = boxUp.height*0.5 + statusbarHeight + scrOrgy
      contents:addEventListener( "touch", contentsFn )

      local markpname = {}
      markpname[1] = path_image.."i_bookmark01.png"
      markpname[2] = path_image.."i_bookmark03.png"
      markbmp = movieclip.newAnim(markpname,resDir)
      markbmp:scale( optionrate, optionrate )
      markbmp.y = contents.y
      markbmp.orgy = contents.y
      markbmp.lasty = contents.lasty
      markbmp.x = _W*2 - scrOrgx - markbmp.contentWidth*0.5 
      markbmp:addEventListener( "touch", bookmarkFn)
      markbmp:stopAtFrame(2)



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
      onoff.x = markbmp.x - (onoff.contentWidth+markbmp.contentWidth)*0.5 
      onoff.y = -boxUp.height*0.5 + scrOrgy
      onoff.orgy = onoff.y 
      onoff.lasty = boxUp.height*0.5 + statusbarHeight + scrOrgy
      onoff:addEventListener( "touch", onoffFn )
     
      reloadBmp = display.newImage(  "button/b_reload.png" ,system.ResourceDirectory )
      local reloadRate = onoff.contentHeight/reloadBmp.height
      reloadBmp.width =  reloadBmp.width * reloadRate * 0.68
      reloadBmp.height = reloadBmp.height * reloadRate * 0.68
      reloadBmp.x = onoff.x - (reloadBmp.contentWidth + onoff.contentWidth + 30)*0.5
      reloadBmp.y = -boxUp.height*0.5  + scrOrgy
      reloadBmp.orgy = reloadBmp.y
      reloadBmp.lasty = boxUp.height*0.5 + statusbarHeight + scrOrgy
      reloadBmp:addEventListener( "touch", reloadFn )

      helpBmp = display.newImage(  "image/b_help.png" ,system.ResourceDirectory )
      local helpRate = onoff.contentHeight/helpBmp.height
      helpBmp.width =   helpBmp.width * helpRate *0.82
      helpBmp.height =  helpBmp.height * helpRate *0.82
      --helpBmp:scale( optionrate, optionrate )
      helpBmp.x = reloadBmp.x - (helpBmp.contentWidth + reloadBmp.contentWidth + 50)*0.5
      helpBmp.y = reloadBmp.y---boxUp.height*0.5 + scrOrgy
      helpBmp.orgy = helpBmp.y
      helpBmp.lasty = boxUp.height*0.5 + statusbarHeight + scrOrgy
      helpBmp:addEventListener("touch",helpFn)


      --loadingBtn.x = reloadBmp.x - (loadingBtn.contentWidth + reloadBmp.contentWidth + 30)*0.5

      loadingBtn.x = contents.x + (contents.contentWidth+loadingBtn.width)*0.5 
      loadingBtn.y = reloadBmp.y
      loadingBtn.orgy = loadingBtn.y
      loadingBtn.lasty = reloadBmp.lasty
      loadingBtn.isVisible = false
      loadingText.x = loadingBtn.x + loadingBtn.width/2 + 10
      loadingText.y = reloadBmp.y
      loadingText.orgy = loadingText.y
      loadingText.lasty = reloadBmp.lasty
      loadingText.text = gNowPrecent.."%"

      gWarning.x = loadingBtn.x
      gWarning.y = loadingBtn.y
      gWarning.orgy = gWarning.y
      gWarning.lasty = loadingBtn.lasty
      

      print("gNowPrecent====",gNowPrecent)
      if gNowPrecent == 100 then
        loadingText.isVisible = false
      else
        loadingText.isVisible = true
      end


      smallPageGroup.y = boxDown.height
      smallPageGroup.orgy = smallPageGroup.y
      smallPageGroup.lasty = 0

      transition.to( boxUp, { time=400, y=boxUp.height*0.5+statusbarHeight +scrOrgy} )
      transition.to( boxDown, { time=400, y=_H*2-boxDown.height*0.5-scrOrgy} )
      transition.to( library, { time=400, y=boxUp.height*0.5+statusbarHeight+scrOrgy} )
      transition.to( contents, { time=400, y=boxUp.height*0.5+statusbarHeight+scrOrgy} )
      transition.to( markbmp, { time=400, y=boxUp.height*0.5+statusbarHeight+scrOrgy} )
      transition.to( option, { time=400, y=boxUp.height*0.5+statusbarHeight+scrOrgy} )
      transition.to( reloadBmp, { time=400, y=boxUp.height*0.5+statusbarHeight+scrOrgy} )
      transition.to( onoff, { time=400, y=boxUp.height*0.5+statusbarHeight+scrOrgy} )
      transition.to(helpBmp,{time = 400 , y=boxUp.height*0.5+statusbarHeight+scrOrgy })
      transition.to( loadingBtn, { time=400, y=boxUp.height*0.5+statusbarHeight+scrOrgy} )
      transition.to( loadingText, { time=400, y=boxUp.height*0.5+statusbarHeight+scrOrgy} )
      transition.to( gWarning, { time=400, y=boxUp.height*0.5+statusbarHeight+scrOrgy} )
      transition.to(smallPageGroup,{time = 400,y=0})

      optionGroup:insert(boxUp)
      optionGroup:insert(boxDown)
      --optionGroup:insert(optionBtnBase)
      optionGroup:insert(library)
      optionGroup:insert(contents)
      optionGroup:insert(markbmp)
      optionGroup:insert(onoff)
      optionGroup:insert(reloadBmp)
      optionGroup:insert(helpBmp)
      optionGroup:insert(pageText)
      optionGroup:insert(smallPageGroup)
      
      optionGroup:insert(loadingBtn)
      optionGroup:insert(loadingText)
     -- print("gWarning..............=",gWarning)

      optionGroup:insert(gWarning)
      

      sceneGroup:insert(optionGroup)
      if setupFirst == true then
        setupt = system.getTimer( )
        
       -- Runtime:addEventListener("enterFrame",closeOptionFn)
      end
      if loadingImg ~= nil then
        loadingImg.x = display.contentWidth*0.5
        loadingImg.y = display.contentHeight*0.5
        --loadingImg.isVisible = false
        loadingImg:toFront( )
      end
      --loadingf = true
      --optionItemf = true

      --Runtime:addEventListener( "enterFrame",loadthumb )
      loadthumb()

     -------沒縮圖時
    --   if gTransf == false then
    --   timer.performWithDelay( 100, startLoadFn )
    -- else
    --   if gLoading == true then
    --     loadingBtn.isVisible = true
    --            loadingText.isVisible = true
             
    --   end
    -- end
     -------
end

function scene:create(event)
   

end

local function setok()
  mutiscalef = false
end

local function pageZoom(event)

  if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
    if scaleing == true then
      if pleft == 1 then 
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

          if (tmprate - zoomrate) <= 0.01 then
            pageList2[1].xScale = tmprate
            pageList2[1].yScale = tmprate
            pageList2[1].x = (_W-pageList2[1].contentWidth*0.5) - dx --orgdx*0.56
            pageList2[1].y = pageH - dy -orgdy*0.56
            pageList2[1].nowrate = tmprate
            mutiscalef = false
            Runtime:removeEventListener("enterFrame",pageZoom)
          end
        else        
          if (tmprate - zoomrate) <= 0.01 then
            pageList2[1].xScale = tmprate
            pageList2[1].yScale = tmprate
            pageList2[1].nowrate = tmprate
            mutiscalef = false
            Runtime:removeEventListener("enterFrame",pageZoom)
          end
        end       
      elseif pleft > maxPage then
        local tmprate = pageList2[maxPage].rate*maxrate
        local drate = tmprate - zoomrate
        drate = drate*0.3
        zoomrate = zoomrate + drate
        pageList2[maxPage].xScale = zoomrate
        pageList2[maxPage].yScale = zoomrate

        if zoomClickx >= bounds.xMin and zoomClickx <= bounds.xMax and zoomClicky >= bounds.yMin and zoomClicky <= bounds.yMax then
          local orgdx = zoomClickx - _W 
          local orgdy = zoomClicky - pageH
          local dx = orgdx*(tmprate-pageList2[maxPage].rate)
          local dy = orgdy*(tmprate - pageList2[maxPage].rate)
          local tarx = (_W-pageList2[maxPage].width*tmprate*0.5) - dx
          local tary = pageH - dy - orgdy*0.56
          local ddx = tarx - pageList2[maxPage].x
          local ddy = tary - pageList2[maxPage].y
          --print("tarx===",tarx)
          ddx = ddx*0.3
          ddy = ddy*0.3
          pageList2[maxPage].x = pageList2[maxPage].x + ddx
          pageList2[maxPage].y = pageList2[maxPage].y + ddy

          if (tmprate - zoomrate) <= 0.01 then
            pageList2[maxPage].xScale = tmprate
            pageList2[maxPage].yScale = tmprate
            pageList2[maxPage].x = (_W-pageList2[maxPage].width*tmprate*0.5) - dx -- orgdx*0.56
            pageList2[maxPage].y = pageH - dy - orgdy*0.56
            pageList2[maxPage].nowrate = tmprate
            mutiscalef = false
            Runtime:removeEventListener("enterFrame",pageZoom)
          end
        else      
          if (nowrate - zoomrate) <= 0.01 then
            pageList2[maxPage].xScale = tmprate
            pageList2[maxPage].yScale = tmprate
             pageList2[maxPage].nowrate = tmprate
            mutiscalef = false
            Runtime:removeEventListener("enterFrame",pageZoom)
          end
        end
      else
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
       -- nowrate = 1
        local drate = pageList2[1].rate - zoomrate
        drate = drate*0.3
        zoomrate = zoomrate + drate
        pageList2[1].xScale = zoomrate
        pageList2[1].yScale = zoomrate
                       
          local ddx = (_W-pageList2[1].width*pageList2[1].rate*0.5)- pageList2[1].x
          local ddy = pageH - pageList2[1].y
          ddx = ddx*0.3
          ddy = ddy*0.3

          pageList2[1].x = pageList2[1].x + ddx
          pageList2[1].y = pageList2[1].y + ddy
          if math.abs(pageList2[1].rate - zoomrate) <= 0.01 then
            pageList2[1].xScale = pageList2[1].rate
            pageList2[1].yScale = pageList2[1].rate
            pageList2[1].x = (_W-pageList2[1].contentWidth*0.5)
            pageList2[1].y = pageH 

            flipType = 0
            arrangPageFn2()

            mutiscalef = false
            scalef = false
            Runtime:removeEventListener("enterFrame",pageZoom)
          end
      elseif pleft > maxPage then      
        local drate = pageList2[maxPage].rate - zoomrate
        drate = drate*0.3
        zoomrate = zoomrate + drate
        pageList2[maxPage].xScale = zoomrate
        pageList2[maxPage].yScale = zoomrate     
          local ddx = (_W-pageList2[maxPage].width*pageList2[maxPage].rate*0.5)-pageList2[maxPage].x
          local ddy = pageH - pageList2[maxPage].y
          --print("ddx===",ddx)
          ddx = ddx*0.3
          ddy = ddy*0.3

          pageList2[maxPage].x = pageList2[maxPage].x + ddx
          pageList2[maxPage].y = pageList2[maxPage].y + ddy
          if math.abs(rate - zoomrate) <= 0.01 then
            pageList2[maxPage].xScale = pageList2[maxPage].rate
            pageList2[maxPage].yScale = pageList2[maxPage].rate
            pageList2[maxPage].x = _W-pageList2[maxPage].contentWidth*0.5
            pageList2[maxPage].y = pageH 

            flipType = 0
            arrangPageFn2()
            scalef = false
            mutiscalef = false
            Runtime:removeEventListener("enterFrame",pageZoom)
          end
      else
        
        local drate = pageList2[pleft].rate - zoomrate
        local drate2 = pageList2[pleft-1].rate - zoomrate2
        drate = drate*0.3
        drate2 = drate2*0.3

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
            if pleft == maxPage then
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
          Runtime:removeEventListener("enterFrame",pageZoom)
        end
      end     
    end
  else
      ----直
      if scaleing == true then     
        local tmprate = pageList2[p1].nowrate
        local drate = tmprate - zoomrate
        drate = drate*0.3      
        zoomrate = zoomrate + drate
        pageList2[p1].xScale = zoomrate
        pageList2[p1].yScale = zoomrate
       
        if zoomClickx >= bounds.xMin and zoomClickx <= bounds.xMax and zoomClicky >= bounds.yMin and zoomClicky <= bounds.yMax then
          local dw = _W*2-2*scrOrgx - pageList2[p1].originpagewidth*pageList2[p1].rate
          local orgdx = zoomClickx - scrOrgx - dw/2
          local orgdy = zoomClicky + scrOrgy - _H
          
          dx = orgdx*(nowrate - pageList2[p1].rate)
          dy = orgdy*(nowrate - pageList2[p1].rate)

          local tarx = scrOrgx + dw/2 - dx 
          local tary = pageH - dy 
          local ddx = tarx - pageList2[p1].x
          local ddy = tary - pageList2[p1].y
          ddx = ddx*0.3
          ddy = ddy*0.3

          pageList2[p1].x = pageList2[p1].x + ddx
          pageList2[p1].y = pageList2[p1].y + ddy
       
          if (tmprate - zoomrate) <= 0.01 then
            pageList2[p1].xScale = tmprate
            pageList2[p1].yScale = tmprate
            pageList2[p1].x = scrOrgx + dw/2 - dx
            pageList2[p1].y = pageH - dy 
            pageList2[p1].nowrate = tmprate
            mutiscalef = false
           
            Runtime:removeEventListener("enterFrame",pageZoom)
          end
        else
          if (tmprate - zoomrate) <= 0.01 then
            pageList2[p1].xScale = tmprate
            pageList2[p1].yScale = tmprate
            mutiscalef = false
           
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

            Runtime:removeEventListener("enterFrame",pageZoom)
          end
    end
  end
end



local function tapFn(tnum,cx,cy)
  if mutitouchf == false then
  local x = cx
  local y = cy
  print("tnum===",tnum)
  if tnum == 1 then
    tnum = 0
    --clickarea3 = clickAreaL[3]
    --clickarea1 = clickAreaR[1]
    --print("clickAreaL[3]=",clickAreaL[3])
    --if x > flipArea[1] and x < flipArea[3]
    print("exitf == ",exitf)
    print("optionf=====",optionf)

    
        print("y===",y)
       
    if x > clickAreaL[3] and x < clickAreaR[1] and y > flipArea[2] and y < flipArea[4] and exitf == false then
     -- print("optionf=====",optionf)
      if optionf == true then
        if setupFirst == true then
          setupFirst = false
          Runtime:removeEventListener("enterFrame",closeOptionFn)
        end       
        optionItemf = false
        -- display.remove( bookmarkBlock )
        -- bookmarkBlock = nil
        --print("tapppppp")
        closeOption()
        print("close1111111") 
        flipArea[2] =  scrOrgy  + statusbarHeight----up
      
          flipArea[4] =  -scrOrgy + _H*2  --down
           print("flipArea[2]===",flipArea[2])
        print("flipArea[4]===",flipArea[4])
      else  
        print("open1111111") 
        openOption()
        flipArea[2] =  scrOrgy + optionBoxUp + statusbarHeight----up
      
          flipArea[4] =  -scrOrgy + _H*2 - optionBoxDown --down
           print("flipArea[2]===",flipArea[2])
        print("flipArea[4]===",flipArea[4])
      end

     
    end
    
  elseif tnum == 2 then
    tnum = 0
    if x > flipArea[1] and x < flipArea[3] and y > flipArea[2] and y < flipArea[4] and exitf == false then
     --if mutiscalef == false then
      --mutiscalef = true
      -- if showtext == nil then
      --           showtext = display.newText( tostring( scaleing ), _W, _H, native.systemFontBold, 50 )
      --           showtext:setFillColor( 0 )
      --       else
      --         showtext.text = tostring(tostring( scaleing))
      --       end
      if scalef == true and scaleing == true then
        scaleing = false
        onoff.alpha = 1.0
       
        --showtext:toFront( )
        flipType = oldflipType
        nowrate = 1 --倍率
        zoomClickx = x
        zoomClicky = y
        if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
          if pleft == 1 then
            zoomrate = pageList2[1].nowrate
            flipType = 0
          elseif pleft > maxPage then
            flipType = 0
            zoomrate = pageList2[maxPage].nowrate
          else
            zoomrate = pageList2[pleft].nowrate
            zoomrate2 = pageList2[pleft-1].nowrate
          end
        else
          if p1 == 1 or p1 == maxPage then
            flipType = 0
          end
          zoomrate = pageList2[p1].nowrate
          pageList2[p1].anchorX = 0
        end
        Runtime:addEventListener("enterFrame",pageZoom)
      elseif scalef == false and scaleing == false then
        
    end
   end
  end
  return true
  end
end


local function contTime(event)
  if touchnum ==1 then
    local ot = system.getTimer( ) - touchtime
    if ot > 200 then
      touchnum = 0
     -- print("tap1111111")
      tapFn(1,tapx,tapy)
      Runtime:removeEventListener("enterFrame",contTime)
    end  
  end
end

local function testTimeFn(event)
  if mutitouchf == false then
    local ph = event.phase
    local x = event.xStart
    local y = event.yStart
    if ph == "began" then
      mf = false
    elseif ph == "moved" then
      local vx = event.x - x
      if math.abs(vx) > 20 then
        mf = true
      end
    elseif ph == "ended" then
      if mf == false   then
        tapx = x
        tapy = y
       -- print("touchnum=",touchnum)
        if touchnum == 0  then
          touchnum = touchnum +1
          touchtime = system.getTimer( )
          Runtime:addEventListener("enterFrame",contTime)
        else
          Runtime:removeEventListener("enterFrame",contTime)
          if optionItemf == false and exitf == false then
            tapFn(2,tapx,tapy)
          end
          touchnum = 0        
        end
      end
    end
  else
    touchnum = 0
    Runtime:removeEventListener("enterFrame",contTime)
  end
end

function replace()
    --print("trans.................................")
    --writeData()
    --Runtime:removeEventListener("enterFrame",mutimoveFn)
    Runtime:removeEventListener("enterFrame",closeOptionFn)
   -- Runtime:removeEventListener("enterFrame", smallPageAutoMoveFn)
    Runtime:removeEventListener("enterFrame",mutiZoom)
    Runtime:removeEventListener("enterFrame",bigPageBackFn)
    Runtime:removeEventListener("enterFrame", bigPageFloatFn)            
    Runtime:removeEventListener("enterFrame", bigAutoFlipFn)
    Runtime:removeEventListener("enterFrame",contLoadFn)
    Runtime:removeEventListener("enterFrame",contThumbLoadFn)
    Runtime:removeEventListener("enterFrame",ballMoveFn)
    --Runtime:removeEventListener("orientation", onOrientationChange )
    --Runtime:removeEventListener("enterFrame",backsmallpageFn)
    --Runtime:removeEventListener("enterFrame",smallpageMoveFn)
    Runtime:removeEventListener("enterFrame",autoturnfn )
    Runtime:removeEventListener("enterFrame",pageZoom)
    Runtime:removeEventListener("enterFrame",contTime)
    --Runtime:removeEventListener( "system", onSystemEvent )
    --Runtime:removeEventListener("tap",tapFn)
    Runtime:removeEventListener("touch",turnPagefn)
    print("atrans......")
    composer.gotoScene( "trans")

end

function onResume( ty )
    --print( "System event name and type: " .. event.name, event.type )
    if ( ty == "applicationResume" and resumef == false) then
      setupf = true 
      
      setupFirst = true
      resumef = true
      replace()
    end
end


function start()
  --if scalef ==  false then
    
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
  --else
     -- arrangBigPageFn()
  --end
  
  if optionf == true then
    table.insert(flipArea, scrOrgx ) ---left
    table.insert(flipArea, scrOrgy + optionBoxUp + statusbarHeight) ----up
    table.insert(flipArea, -scrOrgx  + _W*2) --right
   -- print("right1111====",(-scrOrgx  + _W*2))
    table.insert(flipArea, -scrOrgy - optionBoxDown + _H*2) --down

    table.insert( clickAreaL, -200 )
    table.insert(clickAreaL,-1000)
    table.insert( clickAreaL, -100 )
    table.insert(clickAreaL,100000)

    table.insert(clickAreaR, 100000)
    table.insert(clickAreaR,-1000)
    table.insert(clickAreaR,100100)
    table.insert(clickAreaR,100000)

    --table.insert(clickAreaL,scrOrgx)
    --table.insert(clickAreaL,scrOrgy + optionBoxUp+statusbarHeight)
    --table.insert(clickAreaL,scrOrgx+clickWidth)
    --table.insert(clickAreaL,-scrOrgy - optionBoxDown + _H*2)

    -- table.insert(clickAreaR, -scrOrgx - clickWidth + _W*2)
    -- table.insert(clickAreaR,scrOrgy + optionBoxUp+statusbarHeight)
    -- table.insert(clickAreaR,-scrOrgx + _W*2)
    -- table.insert(clickAreaR,-scrOrgy - optionBoxDown + _H*2)

  else
    table.insert(flipArea, scrOrgx  ) ---left
    table.insert(flipArea, scrOrgy ) ----up
    table.insert(flipArea, -scrOrgx  + _W*2 ) --right
    table.insert(flipArea, -scrOrgy + _H*2) --down
   -- print("right2222====",(-scrOrgx  + _W*2))
    table.insert( clickAreaL, -200 )
    table.insert(clickAreaL,-1000)
    table.insert( clickAreaL, -100 )
    table.insert(clickAreaL,100000)

    table.insert(clickAreaR, 100000)
    table.insert(clickAreaR,-1000)
    table.insert(clickAreaR,100100)
    table.insert(clickAreaR,100000)
    -- table.insert(clickAreaL,scrOrgx)
    -- table.insert(clickAreaL,scrOrgy )
    -- table.insert(clickAreaL,scrOrgx+clickWidth)
    -- table.insert(clickAreaL,-scrOrgy  + _H*2)

    -- table.insert(clickAreaR, -scrOrgx  + _W*2 - clickWidth)
    -- table.insert(clickAreaR,scrOrgy )
    -- table.insert(clickAreaR,-scrOrgx + _W*2)
    -- table.insert(clickAreaR,-scrOrgy  + _H*2)
  end
  table.insert(allArea,scrOrgx)
  table.insert(allArea,scrOrgy)
  table.insert(allArea,-scrOrgx + _W*2)
  table.insert(allArea,-scrOrgy + _H*2)
 
  sceneGroup:insert(pageList) 
  sceneGroup:insert(bookmarkList) 
  sceneGroup:insert(bookmarkTextlist)
  sceneGroup:insert(loadingImg)
  --loadingImg.isVisible = true  
  --print("localingImg.visible=",loadingImg.isVisible)
  --print("localingImg.y=",loadingImg.y)

  if setupf == true then
    print("showOption===============")
    --timer.performWithDelay( 10, showOption )
    showOption()
  end

  bg:addEventListener("touch",testTimeFn)
  Runtime:addEventListener("touch",turnPagefn)
  --Runtime:addEventListener( "orientation", onOrientationChange )
end

function scene:show(event)
  gNaviBar.NaviBarShow(false)
  --gOptnBar.OptnBarShow(false)
  --gFootBar.FootBarShow(false)

  local ph = event.phase
  if "will" == ph then

      --gNetworkStatus = true
    if  curr_composer ~= "hpage" then
      last_composer = curr_composer
      curr_composer = "hpage"
    end
    optionBoxUp = 88
    optionBoxDown = 150
    rota_composer = "hpage"
    local size = gSystem.calculateSize()
    fontSize = 28
    if size > 6 and size < 8 then
      optionrate = 1 
    elseif size > 8 then
      fontSize = 23
      optionrate = 55/optionBoxUp
    else
      optionrate = 120/optionBoxUp
    end

   

     local idPath = choice_bookcode .. "/"
              
              
   
    
    --   --local contents = {}
    --   for line in fh:lines() do 
    --     table.insert(checkThumbList,tonumber(line))
    --   end
    --   checkThumbOver = checkThumbList[1]
    --   --checkThumbNum = tonumber(contents[2])
    --   io.close( fh )
    -- end

    
    --checkNum = 1
    --if checkOver == "0" then
      --checkList = wetools.creatlist(1,maxPage)
      --Runtime:addEventListener("enterFrame",checkMissPageFn)
    --end 
  elseif "did" == ph then

    print("ininininininininininininini")
    system.setIdleTimer( false )
    sceneGroup = self.view
    _W = display.contentWidth * 0.5
    _H = display.contentHeight * 0.5 
    scrOrgx = display.screenOriginX
    scrOrgy = display.screenOriginY
    pageH = _H + statusbarHeight*0.5
    print("_WWWWWWWWW=",_W)
     bg = display.newRect( 0, 0, _W*2-scrOrgx*2, _H*2 - scrOrgy*2 )
    bg.x = _W
    bg.y = _H 
    bg:setFillColor( 153/255 )
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
    gBackToScale = false

    markbmp = nil
    loadnum = 0
    
      zoomrate = 0
      zoomrate2 = 0
    
    bookinfoGroup = nil
    contscroll = nil
    bookmarkscroll = nil
    pageList2 = wetools.creatonelist(0,maxPage)
    thumbpage = 1
    exitf = false
    optionItemf = false
    period = 0
    nowrate = 1
    scalef = false
    noticeGroup = display.newGroup( )
    --if _W == 640 then
      contwidth = (_W*2 -2*scrOrgx)
      --contwidth = contwidth*1.7
    --else
      --contwidth  = _W*2
      --contwidth = contwidth*1.5
    --end
    clickWidth = math.max(150,(_W*2-2*scrOrgx)/6)
    chapterList ,chapterpageList =   gProfile.readchapter(choice_bookcode)
    bookmarkNumList = gProfile.readbookmark(choice_bookcode)
    if bookmarkNumList == nil then
      bookmarkNumList = {}
    end

   

    _X = display.contentCenterX
    _Y = display.contentCenterY


    local pname = {}
        local path_load =  [[image/loading/]]
        for i = 1,24 do
            pname[i] = path_load.."loading"..math.floor((i+1)/2)..".png"
        end
         loadingImg = movieclip.newAnim(pname,system.ResourceDirectory)

    --loadingImg = gSystem.getLoading()
    loadingImg.x = display.contentWidth*0.5
    loadingImg.y = display.contentHeight*0.5
    loadingImg:scale( 0.6, 0.6 )
    loadingImg.isVisible = false
    loadingImg.alpha = 0.6
    if loadingBtn == nil then
        local pname = {}
        local path_load =  [[image/loading/]]
        for i = 1,34 do
            pname[i] = path_load.."load_btn"..math.floor((i+1)/2)..".png"
        end
         loadingBtn = movieclip.newAnim(pname,system.ResourceDirectory)
         loadingBtn.isVisible = false

         loadingBtn:scale( 0.9, 0.9 )
        loadingBtn:play()
        local txt = math.floor((2000/maxPage)).."%"
        loadingText = display.newText( txt , 0 ,0 ,native.systemFont, 32)
        loadingText.isVisible = false
        loadingText.anchorX = 0
    end

    if gWarning == nil  then
      gWarning = display.newImage(  "button/warning.png"  )
      gWarning.x = _X
      gWarning.y = _Y
      gWarning:scale(0.6,0.6)
      if gNetworkStatus == false then
        gWarning.isVisible = true
      else
        gWarning.isVisible = false
      end
    end

    print("gWarning=====",gWarning)

    local idPath = choice_bookcode .. "/"
    local path = system.pathForFile( idPath.."id.txt", baseDir )
    local fh, errStr = io.open( path, "r" )
  --print("fh=====",fh)
      local contents = {}
      for line in fh:lines() do
      --print("line====",tonumber(line))
        table.insert(contents,line)
      -- --print( line )  -- display the line in the terminal
      end
      io.close(fh)
      gDocid = contents[1]
      gPubid = contents[2]

    local path2 = system.pathForFile( idPath.."lastpage.txt",system.DocumentsDirectory)
    local fh, errStr = io.open( path2, "r" )
    if fh  then
      gLastPage = tonumber(fh:read("*a"))
      io.close(fh)
    else
       fh = io.open(path2,"w")
       fh:write("1")
       gLastPage = 1
       io.close(fh)
    end

    local path = system.pathForFile( idPath.."check.txt", baseDir )
      local fh, errStr = io.open( path, "r" )
      if fh then
        local tmp = tonumber(fh:read("*a"))
        posNum = tmp
        print("posNum====",posNum)
        if posNum < maxPage then
          checkOver = 0
          
          --loadedPageNum = tmp 
          gNowPrecent = math.floor( (tmp/maxPage)*100 )
        else
          gNowPrecent = 100
          checkOver = 1
        end
        io.close( fh )
      end

   print("posNum=-=========== ",posNum)
    

    local path = system.pathForFile( idPath.."checkThumb.txt", baseDir )
    local fh, errStr = io.open( path, "r" )
    if fh then
      local tmp = tonumber(fh:read("*a"))
      posThumbNum = tmp
      --print("tmp=",tmp)
        if tmp < maxPage then
          checkThumbOver = 0
          
          --loadedPageNum = tmp
        else
          checkThumbOver = 1
        end
        io.close( fh )

     
    end
    
    print("posThumbNum ============ ",posThumbNum )
    --checkThumbOver = 1
    start()
    -- if g_curr_Dir == "landscapeLeft" or g_curr_Dir == "landscapeRight" then
    --   if pleft == 1 then
       
    --       start()
       
    --   elseif pleft > maxPage then
       
    --       start()
           
    --   else   
       
    --       start()
        
    --   end
    -- else
     
    --     start()
     
    -- end   
  end 


  --Runtime:addEventListener( "system", onSystemEvent ) 
end

function scene:hide(event)
  if "will" == ph then
  end
end

function scene:destroy(event)
   -- print("destory")

    if loadingImg ~= nil then
      display.remove( loadingImg)
          loadingImg = nil
    end
    sceneGroup:insert( noticeGroup )
    system.setIdleTimer( true )
    --Runtime:removeEventListener("enterFrame",mutimoveFn)
    --Runtime:removeEventListener("enterFrame",closeOptionFn)
    --Runtime:removeEventListener("enterFrame", smallPageAutoMoveFn)
    Runtime:removeEventListener("enterFrame",contLoadFn)
    Runtime:removeEventListener("enterFrame",contThumbLoadFn)
    Runtime:removeEventListener("enterFrame",mutiZoom)
    Runtime:removeEventListener("enterFrame",bigPageBackFn)
    Runtime:removeEventListener("enterFrame", bigPageFloatFn)            
    Runtime:removeEventListener("enterFrame", bigAutoFlipFn)
    Runtime:removeEventListener("enterFrame",ballMoveFn)
    --Runtime:removeEventListener("orientation", onOrientationChange )
   -- Runtime:removeEventListener("enterFrame",backsmallpageFn)
   -- Runtime:removeEventListener("enterFrame",smallpageMoveFn)
    Runtime:removeEventListener("enterFrame",autoturnfn )
    Runtime:removeEventListener("enterFrame",pageZoom)
    Runtime:removeEventListener("enterFrame",contTime)
    --Runtime:removeEventListener( "system", onSystemEvent )
    --Runtime:removeEventListener("tap",tapFn)
    Runtime:removeEventListener("touch",turnPagefn)
end


-- function onKeyEvent( event )
   
--       if event.phase == "up" then
         
                      
--                 arrang()
             

--               return true
          
--       end

--       return false
-- end


scene:addEventListener( "create",scene)
scene:addEventListener( "show",scene )
scene:addEventListener( "hide", scene )
scene:addEventListener( "destroy", scene )

return scene
