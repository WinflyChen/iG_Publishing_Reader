
module(..., package.seeall)

local movieclip = require("movieclip")
    -----------------------------------------------------------
    --  
    -----------------------------------------------------------
    -- local function split(pString, pPattern)
    --     local Table = {}  -- NOTE: use {n = 0} in Lua-5.0
    --     local fpat = "(.-)" .. pPattern
    --     local last_end = 1
    --     local s, e, cap = pString:find(fpat, 1)
    --     while s do
    --         if s ~= 1 or cap ~= "" then
    --             table.insert(Table,cap)
    --         end
    --         last_end = e+1
    --         s, e, cap = pString:find(fpat, last_end)
    --     end

    --     if last_end <= #pString then
    --         cap = pString:sub(last_end)
    --         table.insert(Table, cap)
    --     end

    --     return Table
    -- end

    function split(pString, pPattern)

        -- if string.find(pString,".") then
        --     pString = string.gsub(pString,"%.","'.'")
        -- end

        -- if pPattern == "." then
        --     pPattern = "'.'"
        -- end

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


    -- function string:split( inSplitPattern, outResults )

    --    if not outResults then
    --       outResults = { }
    --    end
    --    local theStart = 1
    --    local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
    --    while theSplitStart do
    --       table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
    --       theStart = theSplitEnd + 1
    --       theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
    --    end
    --    table.insert( outResults, string.sub( self, theStart ) )
    --    return outResults
    -- end
   
    -----------------------------------------------------------
    -- 取得 IP 資訊
    -----------------------------------------------------------
    function getIP_info()
        --[[ method 1 ]]--
        require("socket")
        local someRandomIP = "1.2.3.4" --This address you make up
        local someRandomPort = "3102" --This port you make up  
        local mySocket = socket.udp() --Create a UDP socket like normal
        --This is the weird part, we need to set the peer for some reason
        mySocket:setpeername(someRandomIP,someRandomPort) 
        --I believe this binds the socket
        --Then we can obtain the correct ip address and port
        local myDevicesIpAddress, somePortChosenByTheOS = mySocket:getsockname()-- returns IP and Port 
        

        print(myDevicesIpAddress, somePortChosenByTheOS)
        local ipInfo = split(tostring( myDevicesIpAddress ), "." )
        -- print("#ipInfo", #ipInfo)

        -- for i=1, #ipInfo do
        --     print(ipInfo[i])
        -- end

        -- 回傳網段 ex: 192.168.2.
        return ipInfo[1].."."..ipInfo[2].."."..ipInfo[3].."."

        --[[ method 2 ]]--
        -- local socket = require( "socket" )
        -- -- Connect to the client
        -- local client = socket.connect( "192.168.1.122", 80 )
        -- -- Get IP and port from client
        -- local ip, port = client:getsockname()
        -- -- Print the IP address and port to the terminal
        -- print( "IP Address:", ip )
        -- print( "Port:", port )

    end


	-----------------------------------------------------------
	-- 取得系統各項資訊
	-----------------------------------------------------------
	function sys_info()
        print("========= display info =========")
        print(string.format("pixel: %dx%d, ratio: %.02f", 
                            display.pixelWidth,
                            display.pixelHeight,
                            display.pixelHeight/display.pixelWidth))
        print(string.format("content: %dx%d, ratio: %.02f", 
                            display.contentWidth,
                            display.contentHeight,
                            display.contentHeight/display.contentWidth))
        print(string.format("actual: %dx%d",
                            display.actualContentWidth,
                            display.actualContentHeight
                            ))
        print(string.format("scale: (%.02f, %.02f)",
                             display.contentScaleX,
                             display.contentScaleY
                            ))
        print(string.format("origin: (%d, %d)",
                             display.screenOriginX,
                             display.screenOriginY
                            ))
        print("-------- system.getInfo --------")
        local prop = {
            "model",
            "platformName",
            "platformVersion",
            "environment",
            "architectureInfo",
            "build",
            "name",
            "appname",
            "appVersionString",
            "deviceID",
            "maxTexturueSize",
            "maxTextureUnits",
            "textureMemoryUsed",
            "targetAppStore",
            "iosAdvertisingIdentifier",
            "iosAdvertisingTrackingEnabled",
            "iosIdentifierForVendor",
            "androidDisplayApproximateDpi",
            "androidDisplayDensityName",
            "androidDisplayXDpi",
            "androidDisplayYDpi",
        }
        local i = 1
        for _,v in pairs(prop) do
            print (string.format("%s: %s", v, system.getInfo(v) or "nil"))

            local MSG = display.newText( string.format("%s: %s", v, system.getInfo(v) or "nil"), 
            	                         display.contentWidth*0.5, 
            	                         display.contentHeight*0.1+i*25, 
            	                         native.systemFont, 20 )
            MSG:setFillColor(1, 0, 0)
            i = i+1
        end
        print("--------- language ----------")
        print(string.format("locale.country: %s", 
                            system.getPreference( "locale", "country" )))
        print(string.format("locale.idettifier: %s",
                            system.getPreference( "locale", "identifier" )))
        print(string.format("locale.language: %s",
                            system.getPreference( "locale", "language" )))
        print(string.format("ui.language: %s",
                            system.getPreference( "ui", "language" )))
        print("===============================")
    end


    -----------------------------------------------------------
    --  計算裝置尺寸
    -----------------------------------------------------------
    function  calculateSize( )
        -- 
        local deviceSize = 0
        if system.getInfo("platformName") == "Android" then
            deviceSize = math.sqrt( 
                                    display.pixelWidth/system.getInfo("androidDisplayXDpi")*
                                    display.pixelWidth/system.getInfo("androidDisplayXDpi")
                                    +
                                    display.pixelHeight/system.getInfo("androidDisplayYDpi")*
                                    display.pixelHeight/system.getInfo("androidDisplayYDpi")
                                )

        elseif system.getInfo("platformName") == "iPhone OS" then
            if 
                system.getInfo("model") == "iPhone" then return 5
            else 
                return 9
            end
        end

        --return 9
        --return 7
        --return 5
        if(deviceSize == 0) then
            deviceSize = 7
        end

        return math.round(deviceSize)
    end

    -----------------------------------------------------------
    --建立Loading動畫
    ----------------------------------------------------------- 
    function getLoading()
        local pname = {}
        local path_load =  [[image/loading/]]
        for i = 1,24 do
            pname[i] = path_load.."loading"..math.floor((i+1)/2)..".png"
        end
        local loading = movieclip.newAnim(pname,system.ResourceDirectory)
        loading:play()
        return loading
    end


    -----------------------------------------------------------
    --  
    ----------------------------------------------------------- 
    function nil2String(value)
        if value == nil then
            return ""
        else
            return value
        end
    end

    -----------------------------------------------------------
    --  
    ----------------------------------------------------------- 
    function format_thousand(v)
        local s = string.format("%d", math.floor(v))
        local pos = string.len(s) % 3
        if pos == 0 then pos = 3 end
        return string.sub(s, 1, pos)
            .. string.gsub(string.sub(s, pos+1), "(...)", ",%1")
            --.. string.sub(string.format("%.2f", v - math.floor(v)), 2)
    end



-- print( os.date("!%Y-%m-%dT%XZ") )
-- print( os.time() )  -- outputs something like: 1358015442
-- print(os.date("%c",1410330646.123))

-- 到期時間
--local temp = os.date("*t",tonumber(books[i+add].expirytime))
-- local hint = display.newText( "Until ".. temp.year .. "-" .. temp.month .. "-" .. temp.day, 
--                               100, 200, native.systemFont, 25 )


    -----------------------------------------------------------
    --  建立 subfolder
    -----------------------------------------------------------
    function createFolder(folder_name)
                
        -- get raw path to app's Temporary directory
        local temp_path = system.pathForFile( "", system.DocumentsDirectory )

        -- change current working directory
        local success = lfs.chdir( temp_path ) -- returns true on success
        local new_folder_path
        
        if success then
           lfs.mkdir( folder_name )
           lfs.mkdir( folder_name.."thumb" )
           new_folder_path = lfs.currentdir() .. "/" .. folder_name
        end
        print("create folder path", new_folder_path)
    end