--处理事件相关辅助
DateUtil = {}
DateUtil.ZERO_WORD = "0"
function DateUtil.getZeroFill(n, len, isLeft)
	isLeft = (isLeft == nil and true) or isLeft 
	local s = tostring(n)
	if string.len(s) >= len then
		return s
	else
		local zeroWord = ""
		local zeroNum = len - string.len(s)
		for i = 0, zeroNum - 1 do
			zeroWord = zeroWord .. DateUtil.ZERO_WORD
		end
		
		return (isLeft and (zeroWord .. s)) or (s .. zeroWord)
	end
end

function DateUtil.madeTimeToEFormat(str)
	local month = tonumber( string.sub(str, 1, 2) );
	local date = tonumber( string.sub(str, 4, 5));
	local year = tonumber( string.sub(str, 7));
	local time = os.time({year = year, month = month, day = date})
	return os.date("%B.%d",time);

--	print(os.date("%B", "05/31/2013"))
--	print(os.date("%B") .. "." .. os.date("%d"))
end

--获取文本事件的 time tick
function DateUtil.getHoleTimeTick(str)
	local month = tonumber( string.sub(str, 6, 7) );
	local date = tonumber( string.sub(str, 9, 10));
	local year = tonumber( string.sub(str, 1, 4));
	local hour = tonumber( string.sub(str, 12, 13));
	local min = tonumber( string.sub(str, 15, 16));
	local sec = tonumber( string.sub(str, 18, 19));
	
	return os.time({year = year, month = month, day = date, hour = hour, min = min, sec= sec})
end

