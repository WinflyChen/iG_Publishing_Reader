local json = require ("json")
local lfs  = require "lfs"

module(..., package.seeall)

	BookInfo = {
				   ["bookcode"]   = "",
		           ["bookmark"]   = "false",
		           ["page"]       = "",
		           ["purchase"]   = "false",
		           ["title"]      = "",
				   ["year"]       = "",
				   ["author"]     = "",
				   ["publisher"]  = "",
				   ["lastpage"]   = "",
				   ["expirytime"] = "0",
				   ["expired"]    = "false",
				   ["loancount"]  = "1",
				   ["download"]   = "false",
				   ["chapter"]    = "",
				   field = nil
				}


	-----------------------------------------------------------
	--  取得 各項參數
	-----------------------------------------------------------
	local function loadSystemParameter()
		local path = system.pathForFile( "syspara.txt", system.DocumentsDirectory )

		local fh, errStr = io.open(path, "r" )	
		if fh then
			--讀檔
			local syspara = fh:read("*a")
			io.close( fh )	

			return syspara

		else
			-- 若是檔案不存在 就寫入預設的資料
			local initialData = "{\"flipeffect\":\"on\"}"
			fh = io.open(path, "w" )
			fh:write( initialData )
			io.close( fh )
			print( "Reason open failed: " .. errStr )  -- display failure message in terminal

			return nil
		end

	end
	-----------------------------------------------------------
	--  解析 syspara.txt 內的資料
	-----------------------------------------------------------
	function getSystemParameter(key)
		local value = nil
		local syspara = loadSystemParameter()
		--print("sysparasysparasysparasysparasyspara", syspara)		
		if syspara ~= nil then
			local decode = json.decode( syspara )

			if decode ~= nil then
				value = decode[key]
			end
		else
			print("syspara is nil")
		end

		--print("valuevaluevaluevalue", value)
		return value
	end

	-----------------------------------------------------------
	--  設定 各項參數
	-----------------------------------------------------------
	function setSystemParameter(key, value)
		
		local syspara = loadSystemParameter()

		if syspara ~= nil then
			local decode = json.decode( syspara )
			decode[key]  = value 

			local contents = json.encode(decode)
			local path     = system.pathForFile( "syspara.txt", system.DocumentsDirectory )
			local file     = io.open(path, "w")
			
			if file then
		        file:write( contents )
		        io.close( file )
		    else
		        print("open file error")
		    end			--
		end
	end

    -----------------------------------------------------------
    --  
    -----------------------------------------------------------
	function initial_bookprofile()
		local path = system.pathForFile( "bookprofile.txt", system.DocumentsDirectory )

		local fh, errStr = io.open(path, "r" )	
		if fh then
			--讀檔
			local BookProfile = fh:read("*a")
			--print( "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
			--print( "get book profile")
			--print( "Contents of " .. path .. "\n" .. BookProfile )
			--print( "~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~")
			io.close( fh )	
		else
			-- 若是檔案不存在 就寫入預設的資料
			--local initialData = "{\"email\":\"\", \"pwd\":\"\", \"nickname\":\"\", \"gender\":\"\", \"age_group\":\"\", \"birth_month\":\"\", \"birth_date\":\"\", \"occupation\":\"\", \"industry\":\"\"}"
			local initialData = "[{\"bookcode\":\"\", \"bookmark\" : \"\", \"page\" : \"\", \"purchase\" :  \"\", \"title\":\"\", \"author\":\"\", \"publisher\":\"\", \"year\":\"\", \"lastpage\":\"\", \"expirytime\":\"0\", \"expired\": \"true\", \"loancount\":\"\", \"download\":\"\", \"chapter\":\"\" }]"
			fh = io.open(path, "w" )
			fh:write( initialData )
			io.close( fh )
			print( "Reason open failed: " .. errStr )  -- display failure message in terminal
		end		
	end

	-----------------------------------------------------------
	--  將已存在檔案的 json 全部讀出
	-----------------------------------------------------------
	function getBooksJSON()

		local books
		local path = system.pathForFile( "bookprofile.txt", system.DocumentsDirectory )
		local fh, errStr = io.open(path, "r" )	

		if fh then
			--讀檔
			local BookProfile = fh:read("*a")
			io.close( fh )	

			-- 將 json 資料存到  books
			if BookProfile ~= nil then 
				books = json.decode(BookProfile)
				-- for i=1, #books do
				-- 	print("books profile(json)", books[i].bookcode)
				-- end
			else
				print("BookProfile data is nil")
			end
		else
			print( "Reason open bookprofile.txt failed: " .. errStr )  -- display failure message in terminal
		end	

		return books
	end


	-----------------------------------------------------------
	--  
	-----------------------------------------------------------
	function writeRecord(JSON_metadata, expiration)
		
		local existProfile = getBooksJSON()

		local rentFlag = false
		local rentNo   
		if existProfile ~= nil then
		for i=1, #existProfile do

			-- 代表曾經有借過
			if JSON_metadata["bookcode"] == existProfile[i].bookcode then
				print("rent this book before")
				rentNo   = i
				rentFlag = true
				break
			end
		end
	else
		existProfile = {}
	end
		print("PPPPPPPPPPPPPaaaaaaaa", JSON_metadata["pages"])

		--  代表沒有借過，要將這筆寫入
		if rentFlag == false then
			local t = {
					   ["bookcode"]   = JSON_metadata["bookcode"],
			           ["bookmark"]   = "false",
			           ["page"]       = JSON_metadata["pages"], -- 右邊的 page 有 s
			           ["purchase"]   =  "true/false",
			           ["title"]      = JSON_metadata["title"],
					   ["year"]       = JSON_metadata["year"],
					   ["author"]     = JSON_metadata["author"],
		   			   ["publisher"]  = JSON_metadata["publisher"],
					   ["lastpage"]   = "1",
					   ["expirytime"] = expiration,
					   ["expired"]    = "false",
					   ["loancount"]  = "1",
					   ["download"]   = false,
					   ["chapter"]    = JSON_metadata["chapter"]
					  }

			table.insert(existProfile, t)
		
		else -- 代表有借過, 要更新欄位
			existProfile[rentNo].page       = JSON_metadata["pages"]
			existProfile[rentNo].expirytime = expiration 
			existProfile[rentNo].expired    = "false"
			existProfile[rentNo].lastpage   = "1"
			existProfile[rentNo].loancount  = existProfile[rentNo].loancount+1
			
		end

		-- 回寫到 bookprofile.txt
		local contents = json.encode(existProfile)  --print("contents", contents)
		local path     = system.pathForFile( "bookprofile.txt", system.DocumentsDirectory )
		local file     = io.open(path, "w")
		
		if file then
	        file:write( contents )
	        io.close( file )
	    else
	        print("writeRecord file error")
	    end

	    --
	    --	chapter 的另外處理
	    --
	    local bookpath = system.pathForFile( JSON_metadata["bookcode"] .. "/".. JSON_metadata["bookcode"] .. ".txt", system.DocumentsDirectory )
	    local bookfile = io.open(bookpath, "w")
		if bookfile then

	        if JSON_metadata["chapter"] > 0 then
	        	for i = 1, JSON_metadata["chapter"] do
	        		local tmp = "chapter"..i
	        		print("Field===",JSON_metadata[tmp])
	        		bookfile:write( JSON_metadata[tmp] .."\n" )
	        	end
	        end

	        io.close( bookfile )
	    else
	        print("open file error")
	    end
	end

	-----------------------------------------------------------
	--  
	-----------------------------------------------------------
	function DeleteBook(delBookCode)
		
		local existFlag = false
		local books = getBooksJSON()
		print("deletebookcode============",delBookCode)
		-- 檢查每本書的到期時間
		local pos = 0
		if books ~= nil then
		
		for i=1, #books do
			-- 
			if delBookCode == books[i].bookcode then
				existFlag = true
				pos = i
				print("pos===",pos)
				books[i].expired = "true"
				--print("@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@", delBookCode, books[i].expired)
			end
		end
		end
		if pos > 0 then
			print("books.num===",#books)
			table.remove( books,pos )
			print("books.num===",#books)
		end
		-- 如果有存在才更新

		if existFlag == true then
			--
			local contents = json.encode(books)  --print("contents", contents)
			local path     = system.pathForFile( "bookprofile.txt", system.DocumentsDirectory )
			local file     = io.open(path, "w")
			
			if file then
		        file:write( contents )
		        io.close( file )
		    else
		        print("open file error")
		    end
		end
	end

	
	-----------------------------------------------------------
	--  驗證所借閱的書是否到期
	-----------------------------------------------------------
	function verifyExpired()
		local books = getBooksJSON()
		
		-- 檢查每本書的到期時間
		for i=1, #books do
			-- 
			if "false" == books[i].expired then


				local diff = os.time() - math.modf(books[i].expirytime)
				
				-- 604800 = 7 days
				if math.abs( diff ) > 604800 
				and math.modf(books[i].expirytime) < os.time() then
				
					print(books[i].bookcode .. " was expired.")
					books[i].expired = "true"
				end
			end
		end

		--
		local contents = json.encode(books)  --print("contents", contents)
		local path     = system.pathForFile( "bookprofile.txt", system.DocumentsDirectory )
		local file     = io.open(path, "w")
		
		if file then
	        file:write( contents )
	        io.close( file )
	    else
	        print("open file error")
	    end		
	end

	-----------------------------------------------------------
	--  判斷 bookcode 是否逾期  
	--  false:若不存在或者逾期  true:存在且還未逾期
	-----------------------------------------------------------
	function checkBookExpired(bookcode)
		local books = getBooksJSON()
		
		-- 檢查每本書的到期時間
		for i=1, #books do
			-- 
			if bookcode == books[i].bookcode then
				if books[i].expired == "false" then
					return true
				end
			end
		end

		return false
	end

	-----------------------------------------------------------
	-- 更新bookmark
	-----------------------------------------------------------
 	function updatebookmark( bookcode, status )
		local books    = getBooksJSON()
		local rentFlag = false
		local rentNo

		for i=1, #books do
			-- 找出在第幾本書
			if bookcode == books[i].bookcode then
				--print("update download status")
				rentNo   = i
				rentFlag = true
				break
			end
		end

		-- 代表書本資訊有存在該筆
		if rentFlag == true then
			-- local downlaodstatus = json.encode(status)
			 books[rentNo].bookmark = status

			local contents = json.encode(books)  --print("contents", contents)
			local path     = system.pathForFile( "bookprofile.txt", system.DocumentsDirectory )
			local file     = io.open(path, "w")
			
			if file then
		        file:write( contents )
		        io.close( file )
		    else
		        print("open file error")
		    end		
		end

	end

	-----------------------------------------------------------
	--  讀取bookmark
	-----------------------------------------------------------
	function readbookmark( bookcode )

		local books    = getBooksJSON()
		local rentFlag = false
		local rentNo
		local blist = nil
		local tmp = {}

		for i=1, #books do
			-- 找出在第幾本書
			if bookcode == books[i].bookcode then
				--print("reDownload get")
				rentNo   = i
				rentFlag = true
				break
			end
		end
		--print("rentno==",rentNo)
		-- 代表書本資訊有存在該筆
		if rentFlag == true then
			print("books[rentNo].bookmark", books[rentNo].bookmark)
			
			if books[rentNo].bookmark == "false" then
				--print("@@@@@@@")
				--downloadBook(books[rentNo])
			else	
				--print("DDDDDDDDDDDDD")		
				blist = split( books[rentNo].bookmark , "," )
				
				for i = 1,#blist do
					table.insert( tmp, tonumber(blist[i]) )
				end
				--print("#blist", #blist)
				--reDownloadNet(bookcode, lostPage)
			end
		end
		return tmp

	end

	-----------------------------------------------------------
	-- 更新booklastpage
	-----------------------------------------------------------
 -- 	function updatelastpage( bookcode, status )
 		
	-- 	local books    = getBooksJSON()
	-- 	local rentFlag = false
	-- 	local rentNo
	-- 	if books ~= nil then
	-- 	for i=1, #books do
	-- 		-- 找出在第幾本書
	-- 		if bookcode == books[i].bookcode then
	-- 			print("update download status")
	-- 			rentNo   = i
	-- 			rentFlag = true
	-- 			break
	-- 		end
	-- 	end
	-- end
	-- 	-- 代表書本資訊有存在該筆
	-- 	if rentFlag == true then
	-- 		-- local downlaodstatus = json.encode(status)
	-- 		 books[rentNo].lastpage = status

	-- 		local contents = json.encode(books)  --print("contents", contents)
	-- 		local path     = system.pathForFile( "bookprofile.txt", system.DocumentsDirectory )
	-- 		local file     = io.open(path, "w")
			
	-- 		if file then
	-- 	        file:write( contents )
	-- 	        io.close( file )
	-- 	    else
	-- 	        print("open file error")
	-- 	    end		
	-- 	end

	-- end

	-----------------------------------------------------------
	--讀取chapter
	-----------------------------------------------------------
	function readchapter( bookcode )

		local books    = getBooksJSON()
		local rentFlag = false
		local rentNo
		local blist = nil
		local tmp = {}
		local tmp2 = {}

		for i=1, #books do
			-- 找出在第幾本書
			if bookcode == books[i].bookcode then
				--print("reDownload get")
				rentNo   = i
				rentFlag = true
				break
			end
		end
		--print("rentno==",rentNo)
		-- 代表書本資訊有存在該筆
		if rentFlag == true then
			local chapter_path = system.pathForFile( bookcode.."/"..bookcode..".txt", system.DocumentsDirectory )
			--print("chapter_path==",chapter_path)
			local ofile = io.open( chapter_path, "r" )

        	if ofile then
            	local contents = {}
            	
            	for line in ofile:lines() do
					
					table.insert(contents,line)
		   		
				end
				
				for i = 1,#contents do
					 blist = split( contents[i] , "|" )

						table.insert( tmp, blist[4] )
						table.insert(tmp2,blist[2])
				end		
        	end      

			ofile:close()
			
		end
		return tmp,tmp2

	end

  
	-----------------------------------------------------------
	--  
	-----------------------------------------------------------
	function split(pString, pPattern)
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