--csv解析


-- 去掉字符串左空白
local function trim_left(s)
	return string.gsub(s, "^%s+", "");
end


-- 去掉字符串右空白
local function trim_right(s)
	return string.gsub(s, "%s+$", "");
end

-- 解析一行
local function parseline(line)
	local ret = {};

	local s = line .. ",";  -- 添加逗号,保证能得到最后一个字段

	while (s ~= "") do
		--print(0,s);
		local v = "";
		local tl = true;
		local tr = true;

		while(s ~= "" and string.find(s, "^,") == nil) do
			--print(1,s);
			if(string.find(s, "^\"")) then
				local _,_,vx,vz = string.find(s, "^\"(.-)\"(.*)");
				--print(2,vx,vz);
				if(vx == nil) then
					return nil;  -- 不完整的一行
				end

				-- 引号开头的不去空白
				if(v == "") then
					tl = false;
				end

				v = v..vx;
				s = vz;

				--print(3,v,s);

				while(string.find(s, "^\"")) do
					local _,_,vx,vz = string.find(s, "^\"(.-)\"(.*)");
					--print(4,vx,vz);
					if(vx == nil) then
						return nil;
					end

					v = v.."\""..vx;
					s = vz;
					--print(5,v,s);
				end

				tr = true;
			else
				local _,_,vx,vz = string.find(s, "^(.-)([,\"].*)");
				--print(6,vx,vz);
				if(vx~=nil) then
					v = v..vx;
					s = vz;
				else
					v = v..s;
					s = "";
				end
				--print(7,v,s);

				tr = false;
			end
		end

		if(tl) then v = trim_left(v); end
		if(tr) then v = trim_right(v); end

		ret[table.getn(ret)+1] = v;
		--print(8,"ret["..table.getn(ret).."]=".."\""..v.."\"");

		if(string.find(s, "^,")) then
			s = string.gsub(s,"^,", "");
		end

	end

	return ret;
end



--解析csv文件的每一行
local function getRowContent(file)
	local content;

	local check = false
	local count = 0
	while true do
		local t = file:read();
		if not t then  if count==0 then check = true end  break end

		if not content then
			content = t
		else
			content = content..t
		end

		local i = 1
		while true do
			local index = string.find(t, "\"", i)
			if not index then break end
			i = index + 1
			count = count + 1
		end

		if count % 2 == 0 then check = true break end
	end

	if not check then  assert(1~=1) end
	return content
end



--解析csv文件
function LoadCsv(fileName)
	local ret = {};

	local file = io.open(fileName, "r")
	assert(file)
	
	local content = {}
	while true do
		local line = getRowContent(file)
		if not line then break end
		table.insert(content, line)
	end

	for k,v in pairs(content) do
		ret[table.getn(ret)+1] = v;
		--parseline(v);
	end


	file:close()

	return ret
end

local function processCVSJSON(data)
	return string.gsub(data,'""',"\\\"");
end

--CsvTo LuaObject
--startRow 开始读取数据行 
--keyRow 关键字段所在行
--qute 以关键字为KEY
function CsvHoleLoad_other(fileName, startRow, keyRow, qute)
	startRow = startRow and startRow or 2;
	keyRow = keyRow and keyRow or 2;
	local t = LoadCsv(CCFileUtils:sharedFileUtils():getWritablePath() .. CSV_DIRECTORY .. fileName);
	
	
	local list;
	if #t > 1 then
		list = {};
		for i = 1, #t do
			table.insert(list, t[i]);
		end
	else
		local tt = t[1][1];
		list = string.split(tt, "\13");
	end	
	
	--列表第一列无效
	local content = {}
	local keyList;
	for i = startRow, #list do
		if i == keyRow then
			keyList = string.split(list[i], ";");
			break;
		end
	end
	
	if keyList then
		for i = startRow, #list do
			if i ~= keyRow then
				local vals = string.split(list[i], ";");
				local obj = {}
				for j = 1, #vals do
					local jsonVal = jsonParse.decode(processCVSJSON(vals[j]))
					if jsonVal then
						obj[keyList[j]] = jsonVal == "table" and jsonVal or jsonParse.decode(jsonVal);
					else
						obj[keyList[j]] = vals[j];
					end
				end	
				table.insert(content, obj);
			end
		end
	end
	
	--关键字为KEY
	if qute then
		local quteTable = {};
		for i = 1, #content do
			quteTable[tostring(content[i][qute])] = content[i]
		end
		content = quteTable;
	end
	
	return content;
end


--将键值和value反转
local function parse_title(titles)
	local class_mt = {}
	for k, v in ipairs(titles) do
		class_mt[v] = k
	end
	class_mt.__index = function(t, k) if class_mt[k] then return t[class_mt[k]] else return nil end end
	class_mt.__newindex = function(t, k, v) 
		--判断重复
		if class_mt[k] then
			table.remove(t, class_mt[k]);
			table.insert(t,class_mt[k], v);
		else
			--新的属性
			table.insert(t,v)
			class_mt[k] = #t
		end
 	end
	return class_mt
end

--
local function parse_line(linedata,mt)
	 setmetatable(linedata, mt)
	 return linedata
end

function CsvHoleLoad(fileName, startRow, keyRow, qute)
	local data = {}
	local title = {}
	startRow = startRow and startRow or 2
	keyRow = keyRow and keyRow or 2
	local fullFilePath = CCFileUtils:sharedFileUtils():fullPathForFilename(CSV_DIRECTORY .. fileName);
	local csvFile = require("commonlibs.csvsupport.csvfile").new(fullFilePath, "r", ";")
	local index = 1
	local line = csvFile:read()
	while(line ~=nil) do
		if index == keyRow then
			title = parse_title(line)
		elseif index > startRow then
			local linedata = parse_line(line, title)
			local quteIndex = -1
			if qute then
				quteIndex = title[qute]
			end
			for i = 1,#linedata do 
				if i ~= quteIndex then
					local datadecode = jsonParse.decode(linedata[i])
					if datadecode then
						linedata[i] = datadecode
					end
				end
			end
			if qute then
				data[linedata[qute]] = linedata
			else
				table.insert(data, linedata)
			end
		end
		index = index + 1
		line = csvFile:read()
	end
	csvFile:close()
	return data
end