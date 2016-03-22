

module(..., package.seeall)

----抓前面n個字元
function gettwowords(txt,n)
	local tmp = ""
	if n > 1 then
		
	 	local leng = txt:len()
		 for i=1,n do
		 	tmp = tmp..txt:sub(i,i)
		 end
		
	end
	return tmp
end

---抓後面n個字元
function getbacktwowords(txt,n)
	local tmp = ""
	if n > 1 then
		 local leng = txt:len()
		for i=leng-n+1,leng do
	 		tmp = tmp..txt:sub(i,i)
	 	end
	end
	return tmp
end

--取小數點後幾位
function setpoint (cont,mn) 
	 if type(cont) ~= "string" then
	 	cont = tostring ( cont )
	 end
	 print("cont====",cont)
	 local leng = cont:len()
	 local f = false
	 local n = 0
	 local contents2 = ""
	  for i=1,leng do
            local chars = cont:sub(i,i)
            if chars == "." then
            	f = true
            end
            if f == true then
            	n = n + 1
            end         
            
        	contents2 = contents2..chars    
        	if n > mn then
        		break
        	end
        end
        --print("contents4=",contents2)
        return tonumber(contents2)
end

--讀json檔
function jsonFile(fi,dir)
    local path = system.pathForFile( fi,dir)
        local contents = ""
        --myTable = {}
        local ofile = io.open( path, "r" )
        if ofile then
            contents = ofile:read( "*a" )
            ofile:close()
            print("contents====================",contents)
        end      
        return contents
end


--寫json檔
function writejsonFile(fi,data)
	local wfilePath = system.pathForFile(fi,system.DocumentsDirectory)
	--print(wfilePath)
	local wfile = io.open ( wfilePath ,"w" )
	if wfile then
		--print("write data ====")
		wfile:write( data )
		wfile:close()
	end	
end

--copy檔案
function copyFile( srcName, srcPath, dstName, dstPath, overwrite )
    local results = true                -- assume no errors

    local rfilePath = system.pathForFile( srcName, srcPath )
    local wfilePath = system.pathForFile( dstName, dstPath )

    local rfh = io.open( rfilePath, "rb" )              
    local wfh = io.open( wfilePath, "wb" )

    if  not wfh then
        --print( "writeFileName open error!" )
        results = false                 -- error
    else
        -- Read the file from the Resource directory and write it to the destination directory
        local data = rfh:read( "*a" )

        if not data then
            --print( "read error!" )
            results = false     -- error
        else
            if not wfh:write( data ) then
                ----print( "write error!" ) 
                results = false -- error
            end
        end
    end
        rfh:close()
        wfh:close()
        return results  
end

--刪除數字字元
function delnum(txt)
	local leng = txt:len()
	local contents2 = ""
	for i=1,leng do
		local changechar = ""
		local tmp = txt:byte(i)
		if tmp < 48 or tmp > 57 then
			changechar = string.char(tmp)
		end
		contents2 = contents2..changechar
	end
	return contents2
end

--建立movieclip連續圖檔陣列
function createpname(file,n)
	local pname = {}
	for j=1,n do  
		  
 	 	pname[j] = file..j..".png"
	 -- --print(pname[j])
	end
	return pname
end

---讀檔
function readfile(pa)
	local tmp
	local fh, errStr = io.open( pa, "r" )
	if fh then
   -- read all contents of file into a string
    	tmp = fh:read( "*a" )
   	--print( "Contents of " .. pa .. "\n" .. tmp )
   	  io.close( fh )
	end  
    return tmp
end

------陣列處理

---亂數陣列
function randomlist(array)
	 local num = #array
	 local l
  if num>1 then
    for  l = 1 , 2*num do
      local first = array[1]
      local n = math.random(num-1) + 1
      local sec = array[n]
      array[1] = sec
      array[n] = first
    end 
  end 
  return array
end

---建立連續陣列
function creatlist(m,n)
	
	local tmp = {}
	if n > m then
		for i = 1,n-m+1 do
			tmp[i] = m+i-1
		end
	else
		for i = 1,m-n+1 do
			tmp[i] = m-i+1
		end
	end

	return tmp
	
end

--建立同值陣列
function creatonelist(t,n)
	if n > 0 then
		local tmp = {}
		for i = 1,n do
			tmp[i] = t
		end
		return tmp
	end
end

--建立文字和數字結合陣列
function strNumlist(str,num)
        local tmp = {}
    if num>0 then        
        local i
        local n
        for i=1,num do
            if i < 10 then
               n = "0"..i
            else
                n = i
            end
            table.insert(tmp,str..n)
        end
    end
    return tmp
end

--刪除某個陣列值
function deleteone(one,list)
    
    local num = #list
    local pos = 0
    for i=1,num do
        if(one == list[i]) then
            table.remove(list,i)
            pos = i
            break
        end
    end
    return list,pos
end

--是否有某個值
function findone(one,list)
    local num = #list   
    local have = false
    
    for i=1,num do
        if(one == list[i]) then
            have = true
            break
        end
    end
    return have
end

--抓取某個值的位置
function  getpos(one,list)
	--local f = false
	local pos = 0
	if #list>0  then
		for i = 1,#list do	
			if list[i]== one then
			--	f = true
				pos = i
				break
			end
		end
	end
	return pos
end

function getpos2(one,list)
  local pos = 0
  if list.numChildren>0  then
    for i = 1,list.numChildren do  
      if list[i]== one then
      --  f = true
        pos = i
        break
      end
    end
  end
  return pos
end




--產生列表
--[[
on KTListGen s,e,ofs
  case the paramcount of
    1:
      e=s
      s=1
      ofs=1
    2:
      ofs=1
  end case
  
  lst=[]
  repeat with i=s to e
    append lst,i
    i=i+ofs-1
  end repeat
  return lst
end
--]]

--列表取左邊幾位
function WEListLeft (lst,n)
  local rlst={}
  if n>#lst then 
  	return lst
  else
 	 for i = 1,n do
  	  --rlst.append(lst[i])
  	  table.insert( rlst, lst[i] )
 	 end
  	return rlst
  end
end

--列表取右邊幾位
function WEListRight (lst, n)
  rlst = {}
  if n > #lst then 
  	return lst
  else
 	 local c = #lst
 	 local u = c - n + 1
 	 for i = u , c do
 	 	table.insert( rlst, lst[i] )
 	   --rlst.append(lst[i])
 	 end 
 	 return rlst
  end
end

--[[
function WEItemToList (str)
  rl={}
  _player.itemDelimiter=","
  repeat with i=1 to the number of items of str
    dat=KTSTRZip(str.item[i])
    rl.append(dat)
  end repeat
  return rl
end
--]]

---聲音處理，channel 1 為背景音樂
--停止所有聲音(不含背景音樂)
function stopallsound()
	for i=2,32 do
		audio.stop(i)         
	end
end

--停止背景音樂
function stopmu()
	audio.stop(1)
end

--設定背景音樂音量
function setmu(vo)
	audio.setVolume(vo, {channel=1})
end

--設定聲音音量
function setos(vo)
	for i=2,32 do
		audio.setVolume(vo, {channel=i})
	end
end

--Math


--求兩點中路徑: a,b 兩點之間,位移為 sft,傳回每點的值
function WEMathPathListDP (a,b,sft)
  local sx=a[1]
  local sy=a[2]
  
  local d=WEMathGetDegree(a,b)
  local xyd=WEMathDL2XY(d,sft)
  local dx=xyd[1]
  local dy=xyd[2]
  local c
  if dx ~= 0 then
    c=math.floor(math.abs((sx-b[1])/dx))
  elseif dy ~= 0 then
    c=math.floor(math.abs((sy-b[2])/dy))
  else
    return {a,b}
  end
  local rlst={}
  for i = 1,c-1 do
  --repeat with i=1 to c-1
    --append rlst,point(integer(sx+dx*i),integer(sy+dy*i))
    table.insert(rlst,{math.floor(sx+dx*i),math.floor(sy+dy*i)})
  end
  --append rlst,b
  table.inssert(rlst,b)
  return rlst
end


--求兩點中路徑: a,b 兩點之間,分割成 c 段,傳回每點的值(2D)
function WEMathPathListP (a,b,c)
  local sx=a[1]
  local sy=a[2]
  
  local cf=math.float(c)
  local dx=(b[1]-sx)/cf
  local dy=(b[2]-sy)/cf
  local rlst={}
  for i = 0,c do
  	table.insert( rlst, {math.floor(sx+dx*i),math.floor(sy+dy*i)} )
  end
  --repeat with i=0 to c
  --  append rlst,point(integer(sx+dx*i),integer(sy+dy*i))
  --end repeat
  
  return rlst
end


--求兩點中路徑: a,b 兩值之間,分割成 c 段,傳回每點的值
--on KTMathPathList a,b,c
--  --  a=a.float
--  --  b=b.float
--  --  d=(b-a)/c
--  
--  yy=[]
--  repeat with i=0 to c
--    yy.append((a+d*i).integer)
--  end repeat
--  return yy
--end

function WEMathBetween(low,v,high)
  return (low<=v and v<=high)
end

function WEMathOffset(srcx, srcy, dstx, dsty)
  local xx = dstx - srcx
  local yy = dsty - srcy
  return xx*xx+yy*yy
end


--由點求距離比較值: 由兩個點,傳回距離比較值
function WEMathOffsetP(p1,p2)
  local xx=p1[1]-p2[1]
  local yy=p1[2]-p2[2]
  return xx*xx+yy*yy
end


--求拋物線: 由兩個點座標值,分成 c 段,求出每一點座標
function WEMathParabolla(x1,y1,x2,y2,h,c)
  local r={}
  local Vy=math.sqrt(2*9.8*h)
  
  --利用逼近法求 Tc
  local T1=Vy/9.8
  local T2=T1*10
  local H=y1-y2
  local t=1
  local Tm = 0
  local Vx = 0

  --repeat while TRUE
  while t <= 50 do
    t=t+1
    Tm=(T1+T2)/2
    local nH=Vy*Tm-4.9*Tm*Tm
    if math.abs(nH-H)<1 then
      break
    else
      if nH<H then
        T2=Tm
      else
        T1=Tm
      end
    end
   -- if t>50 then exit repeat
  end
  
  if Tm==0 then 
    Vx=0 
  else
    Vx=(x2-x1)/Tm
  end
  
  local TmS=Tm/c
  for i =0,c do
  --repeat with i=0 to c
   local  T=Tms*i
   local xx=math.floor(x1+Vx*T)
   local yy=math.floor(y1-Vy*T+4.9*T*T)
   -- append r,point(xx,yy)
   table.insert( r, {xx,yy} )
 -- end repeat
  end

  r[#r]={x2,y2}
  return r  
end


--計算兩點角度,Director專用角度
function  WEMathGetDegree (p1,p2)
  local pDegree ={0,0}
  local xx =math.floor(p2[1]-p1[1])
  local yy =math.floor(p1[2]-p2[2])--對調,
  local yybak=yy
  local xxbak=xx
  if xx==0 then 
  	xx=1 
  end
  if yy==0 then 
  	yy=1 
  end
  local dir=(xx/xx)/(yy/yy)
  local d = 0
  yy=yybak
  xx=xxbak
  if yy ~= 0 then
    if xx>0 then
      if dir then
        d=90-math.atan((yy)/(xx))*180.0/PI
      else
        d=90+math.atan((yy)/(xx))*180.0/PI  
      end
    elseif xx<0 then
      if dir then
        d=270-math.atan((yy)/(xx))*180.0/PI
      else
        d=270+math.atan((yy)/(xx))*180.0/PI
      end
    else
      if yy<0 then 
        d=180
      else
        d=0
      end 
    end
  else
    if xx>0 then 
      d=90
    else
      d=270
    end
  end
  return d
end

--徑度量轉度度量
function  WEMathS2D (s)
  return 180*s/pi
end

--度度量轉徑度量
function WEMathD2S (d)
  return d*pi/180
end


--用角度和長度傳回 x,y 值(數學,如需螢幕座標 y 請取負值)
function WEMathDL2XY (d,l)
  local d2=math.floor(d)
  if d2 == 0 then
    
      return {0,-l}
  elseif d2 == 90 then
    
      return {l,0}
  elseif d2 == 180 then
  
      return {0,l}
  elseif d2 == 270 then
 
      return {-l,0}
  else
    
      local zone=math.floor((d2+90)/90)
      if zone == 1 then
          s=WEMathD2S(d2)
          x=math.sin(s)*l
          y=-math.cos(s)*l
      elseif zone == 2 then
          s=WEMathD2S(180-d2)
          x=math.sin(s)*l
          y=math.cos(s)*l
      elseif zone == 3 then
          s=WEMathD2S(d2-180)
          x=-math.sin(s)*l
          y=math.cos(s)*l
      elseif zone == 4 then
          s=WEMathD2S(360-d2)
          x=-math.sin(s)*l
          y=-math.cos(s)*l
      end
      --      if x.voidp then
      --        nothing
      --      end if
      return {x,y}
  end 
end


--用角度和長度傳回 x,y 值(數學,如需螢幕座標 y 請取負值)
function WEMathEllipseDL2XY (d,w,h)
  local d2=math.floor(d)
  local x = 0
  local y = 0
  local s = 0
  if d2 == 0 then
   
      return {0,h}
  elseif d2 == 90 then
      return {w,0}
  elseif d2 == 180 then
      return {0,-h}
  elseif d2 == 270 then
      return {-w,0}
  else
      local z=d2/90
      local zone=math.floor(z+.5)
      if zone == 1 then
       
          s=WEMathD2S(d2)
          x=math.sin(s)*w
          y=math.cos(s)*h
      elseif zone == 2 then
          s=WEMathD2S(180-d2)
          x=math.sin(s)*w
          y=-math.cos(s)*h
      elseif zone == 3 then
          s=KTMathD2S(d2-180)
          x=-math.sin(s)*w
          y=-math.cos(s)*h
      elseif zone == 4 then
          s=KTMathD2S(360-d2)
          x=-math.sin(s)*w
          y=math.cos(s)*h
      end
      --      if x.voidp then
      --        nothing
      --      end if
      return {x,y}
  end
end



function WEMathLimit (mi,v,mx)
  if v>mx then v=mx end
  if v<mi then v=mi end
  return v
end

---string

--KTStr Functions

----某字元在字串中的位置
function WESTRgetpos(one,str)
	local pos = 0
	local len = str:len()
	for i = 1 , len do
		if str:sub(i,i) == one then
			pos = i
			break
			
		end
	end
	return pos
end

----大寫
function WESTRuppercase (str)
  --str uppercase
  local rt=""
  local len=str:len()
  for i=1 , len do
    --local c=str:byte(i)
    --local char = ""
    local n=str:byte(i)
    if n>96 and n<123 then
    	n = n - 32
      --put numtochar(bitand(n,95)) after rt  
      
    end
    rt = rt..string.char(n)

  end
  return rt
end

function WESTRlowercase (str)
  --str lowercase
  local rt=""
  local len=str:len()
  for i=1 , len do
    local n=str:byte(i)
    if n>64 and n<91 then
      n = n + 32
    end
    rt = rt..string.char(n)
  end
  return rt
end

--產生字串
function WESTRSpc (c,n)
  local rt=""
  for i=1 , n do
    rt=rt..c
  end
  return rt
end

function WESTRDelCtrl (str)
	local rt = ""
  if str:sub(1,1)==string.char(10) then
  	for i = 2,str:len() do
  		rt = rt..str:sub(i,i)
  	end
    --return chars(str,2,length(str))
    return rt
  else
    return str
  end
end

--on KTn2s(n)
--  n=integer(value(n))
--  if n<10 then n="0"&n
--  return string(n)
--end
--
--on KTn3s(n)
--  n=integer(value(n))
--  if n<100 then n="0"&n
--  if n<10 then n="0"&n
--  return string(n)
--end
--
--on KTn4s(n)
--  n=integer(value(n))
--  if n<1000 then n="0"&n
--  if n<100 then n="0"&n
--  if n<10 then n="0"&n
--  return string(n)
--end
--
--on KTn8s(n)
--  n=integer(value(n))
--  if n<10000000 then n="0"&n
--  if n<1000000 then n="0"&n
--  if n<100000 then n="0"&n
--  if n<10000 then n="0"&n
--  if n<1000 then n="0"&n
--  if n<100 then n="0"&n
--  if n<10 then n="0"&n
--  return string(n)
--end

----前面加l個零的n值
function  WEnls(n,l)
  if l== nil then
   l=2
  end
  local s=tostring(n)
  while s:len() < l do
    	s="0"..s
  end 
  return s
end

-----前面加l個空白的n值
function WEnps(n,l)
  local s=tostring(n)
  while s:len() <l do
    s=" "..s
  end
  return s
end

--字串壓縮(頭尾去英文空白)
function WESTRZip (str)
  --string compress
  local l=str:len()
  local s=1
  local e=l
  local tmp = ""
  for i=1 , l do
    if str:sub(i,i) ~= " " then
      s=i
      break
    end 
  end
  for i=l , 1,-1 do
    if str:sub(i,i) ~= " " then 
      e=i
      break
    end
  end 

  for i = s,e do
  	tmp = tmp .. str:sub(i,i)
  end

  return tmp
end

--字串壓縮(頭尾去中英文空白)
function WESTRZipC (str)
  --string compress w c
  local TrimChar={" ","　"}
  local l=str:len()
  local s=1
  local e=l
  local tmp = ""
  for i=1 , l do
    if WESTRgetpos(str:sub(i,i),str)==0 then
      s=i
      break
    end
  end
  for i=l ,1,-1 do
    if WESTRgetpos(str:sub(i,i),str)==0 then 
      e=i
      break
    end
  end
   for i = s,e do
  	tmp = tmp .. str:sub(i,i)
  end
  return tmp
end

--字元取代
function WESTRCharReplace (str,ochar,nchar)
  local rtxt=""
  local len=str:len()
  for i=1 ,len do
    local c=str:sub(i,i)
    if c== ochar then
      rtxt=rtxt..nchar
    else
      rtxt=rtxt..c
    end
  end
  return rtxt
end

--字串取代

--[[ 無offset功能，無法轉換
function WESTRSTRReplace (str,ostr,nstr)
  local ostrlen=ostr:len()
  p=offset(ostr,str)
  
  if p then
    rtstr=""
    repeat while p
      rtstr=rtstr&chars(str,1,p-1)&nstr
      str=chars(str,p+ostrlen,length(str))
      p=offset(ostr,str)
      if p=0 then rtstr=rtstr&str
    end repeat
    return rtstr
  else
    return str
  end
end
--]]
--字串比較(分大小寫)
--[[
function WESTRSentiveCompare (s1,s2)
  local ln=s1:len()
  if s2:len() ~= ln then return false
  repeat with i=1 to ln
    if chartonum(chars(s1,i,i)) <> chartonum(chars(s2,i,i)) then return false
  end repeat
  return true
end
--]]

--[[
function WEStrPrint ch,s,l,prefix
  repeat with i=1 to l
    sprite(ch+i-1).member=prefix&chars(s,i,i)
  end repeat
end
--]]
--[[
function WEstrenc (str,ckey)
  local ckey=tostring(ckey)
  local nstr=""
  local idx=1
  for i=1 , str:len() do
    --a=chartonum(chars(str,i,i))

    b=chartonum(chars(ckey,idx,idx))
    c=bitxor(a,b)
    nstr=nstr&numtochar(c)
    idx=idx+1
    if idx>ckey.length then idx=1
  end repeat
  
  return ktstr2hex(nstr)
end
--]]
--[[
function WEstrdec str,ckey
  ckey=string(ckey)
  str=kthex2str(str)
  nstr=""
  idx=1
  repeat with i=1 to length(str)
    a=chartonum(chars(str,i,i))
    b=chartonum(chars(ckey,idx,idx))
    c=bitxor(a,b)
    nstr=nstr&numtochar(c)
    idx=idx+1
    if idx>ckey.length then idx=1
  end repeat
  return nstr
end
--]]
--[[
function WEstr2hex(str)
  local sen="0123456789abcdef"
  local nstr=""
  for i=1 , str:len()
   local n = str:byte(i)
   --  n=chartonum(chars(str,i,i))
    local a=n/16
    local b=n % 16
    a=chars(sen,a+1,a+1)
    b=chars(sen,b+1,b+1)
    nstr=nstr..a..b
  end
  return nstr
end

function WEhex2str(hex)
  sen="0123456789abcdef"
  nstr=""
  repeat with i=1 to hex.length
    a=offset(chars(hex,i,i),sen)-1
    b=offset(chars(hex,i+1,i+1),sen)-1
    nstr=nstr&numtochar(a*16+b)
    i=i+1
  end repeat
  return nstr
end

--計算字串長度(中文為2)
function WESTRisDoubleByte (str)
  LEN = length(str)
  repeat with i = 1 to LEN
    if chartonum(chars(str,i,i)) > 256 then
      return true
    end if
  end repeat
  return false
end

function WEStrGenKey l
  s=""
  repeat with i=1 to l
    s=s&numtochar(random(chartonum("a"),chartonum("z")))
  end repeat
  return s
end

--文字壓縮(頭去換行字元)
function WETXTDelCtrl TXT
  --del head ASCII(10)
  len = the number of lines of TXT
  rtxt = ""
  repeat with i = 1 to len
    str = line i of txt
    if char 1 of str = numtochar(10) then str = char 2 to length(str) of str
    put str into line i of rtxt
  end repeat
  return rtxt
end


--]]