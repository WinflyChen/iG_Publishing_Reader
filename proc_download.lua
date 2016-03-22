json = require ("json")
local wetools = require("wetools")
local sysFunction = require("systeminfo")
local loadingImg = nil
local _txt = nil

module(..., package.seeall)

    local isDownloading = false
    function getisDownloading()     return isDownloading  end
    function setisDownloading(flag) isDownloading = flag end

	local Para
    local JSON_convertstatus = nil  function getJSON_convertstatus() return JSON_convertstatus end
	local JSON_metadata = nil       function getJSON_metadata()      return JSON_metadata end

    -----------------------------------------------------------
    --  
    -----------------------------------------------------------
    function jsonParse(paraString)
       
    	print("json parse", paraString, paraString:sub( 13 ))
 	

    	Para = sysFunction.split(paraString:sub( 13 ), ":")
    	print("server url", Para[1])
    	print("ticket    ", Para[2])
    	print("spotkey   ", Para[3])
    	print("expiration", Para[4])
        loadInfo[1] = Para[1]
        loadInfo[2] = Para[2]
        loadInfo[3] = Para[3]
        loadInfo[4] = Para[4]

    	-- 若有參數就回傳 ok
    	if  Para[1] ~= ""  and Para[2] ~= ""  and Para[3] ~= ""  and Para[4] ~= ""
    	and Para[1] ~= nil and Para[2] ~= nil and Para[3] ~= nil and Para[4] ~= nil then
    		return "ok", Para[4]
    	end

    end


    -----------------------------------------------------------
    --  確認是否已經轉好書
    -----------------------------------------------------------
    local function networkListenerConvertStatus(event)
        
        if ( event.isError ) then
            print( "Network error!")

        else
            --native.setActivityIndicator( false )
            print( "event.response = " .. event.response );
            
            JSON_convertstatus = json.decode(event.response)
            --print("JSON_convertstatus number = ", table.getn(JSON_convertstatus))

            if JSON_convertstatus == nil then
                print( "network JSON_convertstatus = nil" ) 
            else
                print( "JSON_convertstatus cvtpage = " ,JSON_convertstatus[1].cvtpage)
                print( "JSON_convertstatus status  = " ,JSON_convertstatus[1].status)
                print( "JSON_convertstatus allpage = " ,JSON_convertstatus[1].allpage)

                print( "JSON_convertstatus message = " ,JSON_convertstatus[1].message)
            end

        end

    end

    -----------------------------------------------------------
    --  檢查是否已經轉檔完成
    -----------------------------------------------------------
    function getBookConvertStatus()        
        
        local URL = "http://" .. Para[1] .. "convertstatusmobile/" .. Para[2] .. "/" .. Para[3]
        print("URL" , URL)
        network.request( URL, "GET", networkListenerConvertStatus)
    
        return true
    end


    -----------------------------------------------------------
    --  確認是否已經轉好書
    -----------------------------------------------------------
    local function networkListenerMetadata(event)
        
        if ( event.isError ) then
            print( "Network error!")

        else
            --native.setActivityIndicator( false )
            print( "event.response = " .. event.response );
            
            JSON_metadata = json.decode(event.response)
            --print("JSON_metadata number = ", table.getn(JSON_metadata))

            if JSON_metadata == nil then
                print( "network JSON_metadata = nil" ) 
            else
                print( "JSON_metadata author = ",    JSON_metadata[1].author)
                print( "JSON_metadata title  = ",    JSON_metadata[1].title)
                print( "JSON_metadata pages = ",     JSON_metadata[1].pages)
                print( "JSON_metadata year = ",      JSON_metadata[1].year)
                print( "JSON_metadata publisher = ", JSON_metadata[1].publisher)
                print( "JSON_metadata bookcode = ",  JSON_metadata[1].bookcode)
                print( "JSON_metadata chapter = ",   JSON_metadata[1].chapter)
                print( "JSON_metadata docid = ",   JSON_metadata[1].docid)
                print( "JSON_metadata pubid = ",   JSON_metadata[1].pubid)
            end

        end

    end

    -----------------------------------------------------------
    --  檢查是否已經轉檔完成
    -----------------------------------------------------------
    function getBookMatadata()        
        
        local URL = "http://" .. Para[1] .. "metadata/" .. Para[2] .. "/" .. Para[3]
        print("URL" , URL)
        network.request( URL, "GET", networkListenerMetadata)
    
        return true
    end

    -----------------------------------------------------------
    --  
    -----------------------------------------------------------
    function downloadBook(DownloadPageScene, bookcode, totalPage)
        local targetPage = math.min( 10, tonumber(totalPage))
         loadingImg = gSystem.getLoading()
            loadingImg.x = display.contentWidth*0.5
            loadingImg.y = display.contentHeight*0.5
            loadingImg:scale( 0.6, 0.6 )
        --local hintText = display.newText( display.contentWidth*0.5, display.contentHeight*0.3 ,  native.systemFont, 30 )
        --hintText.text = "It will enter the book content, but unfinished book download, keep the network connection!!"

            local fontSize = 50
            print("svreensize = ",gSystem.calculateSize( ))
            if gSystem.calculateSize( ) < 7 then
                fontSize = 58
            --inputWidth = 300
            end

            local options = 
                {
                            --parent = groupObj,
                    text ="initializing...",     
                    x = display.contentWidth*0.5,
                    y = display.contentHeight*0.3,
                    width = 760,            --required for multiline and alignment
                    height = 250,           --required for multiline and alignment
                    font = native.systemFontBold,   
                    fontSize = fontSize,
                    align = "center"          --new alignment field
                }

            _txt = display.newText( options)
            _txt:setFillColor( 1)
            --loadingImg.alpha = 0.6
            _txt:toFront( )
            loadingImg:toFront( )

        page   = 1  -- initial
        errpage = {} -- initial
        thumbpage = 1
        thumberrpage = {}

        -------------[[ thumbnail ]]------------------
        local function thumbnailListener( event )
            if ( event.isError ) then

                print( "Network error - download failed thumbnail = ", thumbpage )
                table.insert( thumberrpage,  thumbpage)
                thumbpage = thumbpage+1
                netThumbnail()
                

            elseif ( event.phase == "began" ) then
                --print( "Progress Phase: began" )
            elseif ( event.phase == "ended" ) then
                --print( "displaying response image file" )
                --print( "filename = ", event.response.filename )
                --print( "docDirectory = ", event.response.docDirectory )
                thumbpage = thumbpage+1
                --print("current download thumbnail = ", thumbpage)
                netThumbnail()
                
            end
        end

        function netThumbnail()
            
            --
            local pagescene = require (tostring(DownloadPageScene))

            --tonumber(totalPage)
            if thumbpage <= targetPage  then 
                
                
                --pagescene.setPercentPage(nil, page, thumbpage, tonumber(totalPage))
                --pagescene.setPercentPage(nil, page, thumbpage, targetPage)
                local params = {}  params.progress = true
                network.download(
                                --"https://s1.yimg.com/rz/d/yahoo_zh-Hant-TW_f_p_bestfit.png",
                                "http://" .. Para[1]  .. Para[2] .. "/" .. Para[3] .. "/" .. thumbpage .. "/thumbnail.png",
                                "GET",
                                thumbnailListener,
                                params,
                                bookcode.."thumb/"..thumbpage..".png", -- put subfolder path here
                                system.DocumentsDirectory 
                                )
            end

        end


        -------------[[ content ]]------------------
        local function networkListener( event )
            if ( event.isError ) then

                --print( "Network error - download failed page = ", page )
                table.insert( errpage,  page)
                page = page+1
                netContent()

            elseif ( event.phase == "began" ) then
                --print( "Progress Phase: began" )
            elseif ( event.phase == "ended" ) then
                --print( "displaying response image file" )
                --print( "filename = ", event.response.filename )
                --print( "docDirectory = ", event.response.docDirectory )
                --table.insert( errpage,  page)
                
                print("current download page = ", page)
                page = page+1
                
                netContent()
            end
        end

        function netContent()
            --
            local pagescene = require (tostring(DownloadPageScene))

            --tonumber(totalPage)
            if page <= targetPage then
                
                
                pagescene.setPercentPage(nil, page, thumbpage, tonumber(totalPage))
                --pagescene.setPercentPage(nil, page, thumbpage, targetPage)


                local params = {}  params.progress = true
                local dpi = "150"
                network.download(
                                --"https://s1.yimg.com/rz/d/yahoo_zh-Hant-TW_f_p_bestfit.png",
                                --http://211.75.254.216/igpspot/content/da0b5daaa12c4b59972a677da4ecef4feafb95afc6474c36bc4d3939663cfe5e/fe02f9de2e124547a91fd4a165e3919f/1/150/content.png
                                "http://" .. Para[1]  .. Para[2] .. "/" .. Para[3] .. "/" .. page .. "/" .. dpi .. "/content.png",
                                "GET",
                                networkListener,
                                params,
                                bookcode .. "/" .. page..".png", -- put subfolder path here
                                system.DocumentsDirectory 
                                )

                print("Content Url = ".."http://" .. Para[1]  .. Para[2] .. "/" .. Para[3] .. "/" .. page .. "/" .. dpi .. "/content.png")
            else
                -- 下載完成

                local idPath = JSON_metadata[1].bookcode .. "/"
                local path = system.pathForFile( idPath.."id.txt", system.DocumentsDirectory )
                local fh, errStr = io.open( path, "r" )
                print("idPath=",idPath)
                print("fh===",fh)
                if fh then
                     
                else
                    contents = {gDocid,gPubid}
                    fh = io.open(path, "w" )
            
                    for i = 1,#contents do
                        if i < #contents then
                            fh:write(contents[i], "\n")
                        else
                            fh:write(contents[i])
                        end         
                    end

                    print("write gdocid")
                    --fh:write( "0" )
                    io.close( fh )
                end

                --記錄每頁資訊
                local path = system.pathForFile( idPath.."check.txt", system.DocumentsDirectory )
                local fh, errStr = io.open( path, "r" )
                if fh then
                    checkOver = tonumber(fh:read("*a"))
                    io.close(fh)
                else
                    fh = io.open(path, "w" )
                    fh:write( 0 )
                    io.close( fh )
                end

                local path = system.pathForFile( idPath.."precent.txt", system.DocumentsDirectory )
                local fh, errStr = io.open( path, "r" )
                if fh then
                    --checkOver = tonumber(fh:read("*a"))
                    --io.close(fh)
                else
                    fh = io.open(path, "w" )
                    fh:write( 0 )
                    io.close( fh )
                end
                
                for i = targetPage+1 , tonumber(totalPage) do
                    local path = system.pathForFile( idPath..i..".txt", system.DocumentsDirectory )
                    local fh, errStr = io.open( path, "r" )
                    if fh then
                        --checkOver = fh:read("*a")
                        io.close(fh)
                    else
                        fh = io.open(path, "w" )
                        fh:write( 0 )
                        io.close( fh )
                    end
                end

                local path = system.pathForFile( idPath.."checkThumb.txt", system.DocumentsDirectory )
                local fh, errStr = io.open( path, "r" )
                if fh then
                    checkThumbOver = tonumber(fh:read("*a"))
                    io.close(fh)
                else
                    fh = io.open(path, "w" )
                    fh:write( 0 )
                    io.close( fh )
                end

                for i = targetPage+1 , tonumber(totalPage) do
                    local path = system.pathForFile( idPath.."thumb"..i..".txt", system.DocumentsDirectory )
                    local fh, errStr = io.open( path, "r" )
                    if fh then
                        --checkOver = fh:read("*a")
                        io.close(fh)
                    else
                        fh = io.open(path, "w" )
                        fh:write( 0 )
                        io.close( fh )
                    end
                end

                -- --local checkData = wetools.creatlist(targetPage+1,tonumber(totalPage))
                -- local checkData = wetools.creatlist(1,tonumber(totalPage))
                -- for i = 1,targetPage do
                --     checkData[i] = 0
                -- end
                -- table.insert( checkData, 1, 0 )
               
                -- local path = system.pathForFile( idPath.."check.txt", system.DocumentsDirectory )
                -- local fh, errStr = io.open( path, "r" )
                -- if fh then
                --   --checkOver = fh:read("*a")
                --   --io.close(fh)
                -- else
                --     fh = io.open(path, "w" )
                --     for i = 1,#checkData do
                --         if i < #checkData then
                --             fh:write(checkData[i], "\n")
                --         else
                --             fh:write(checkData[i])
                --         end         
                --     end

                --   io.close( fh )
                -- end

                -- local path = system.pathForFile( idPath.."checkThumb.txt", system.DocumentsDirectory )
                -- local fh, errStr = io.open( path, "r" )
                -- if fh then
                --   --checkThumbOver = fh:read("*a")
                --   --io.close(fh)
                -- else
                --   fh = io.open(path, "w" )
                --     for i = 1,#checkData do
                --         if i < #checkData then
                --             fh:write(checkData[i], "\n")
                --         else
                --             fh:write(checkData[i])
                --         end         
                --     end
                --   io.close( fh )
                -- end

                display.remove( _txt )
                _txt = nil
                display.remove( loadingImg)
                loadingImg = nil
                
                pagescene.Done(nil, errpage)
                print("download completion")
            end
        end
        netThumbnail()
        netContent()
    end

function changeDir()
        if loadingImg ~= nil then
            loadingImg.x = display.contentWidth*0.5
            loadingImg.y = display.contentHeight*0.5
            _txt.x = display.contentWidth*0.5
            _txt.y = display.contentHeight*0.3
            loadingImg:toFront( )
            _txt:toFront( )
        end
    end
    function checkLoadingImg()
        local tmp = false
        if loadingImg ~= nil then
            tmp = true
        end

        print("ttttttttttmmmmmmmmmppppppppppp====",tmp)
        return tmp
    end

function setJSON_convertstatus(value)
    JSON_convertstatus = value
end
