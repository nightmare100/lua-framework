--数字处理
require("commonlibs.utils.LuaHelper")

NumberUtil = {}

NumberUtil.NUMBER_SOURCE = 0;
NumberUtil.NUMBER_TOOGLE = 1;

NumberUtil.MILLION_TAG = "M";
NumberUtil.BILLION_TAG = "B";
NumberUtil.MILLION_NUM = 6;
NumberUtil.BILLION_NUM = 9;

function NumberUtil.getNumberByStyle(n, type, tag, needZeroTag,keepDec)
	if keepDec then keepNumResult="."..string.sub(string.format("%.02f", n),-2) end
	n = string.format("%.0f", math.floor(n)) 
	tag = (tag ~= nil and tag) or ""
	local result = ""
	if (type == NumberUtil.NUMBER_SOURCE) then
	
		result = NumberUtil.getSourceNumber(n)
		if keepDec then
			return tag .. result .. keepNumResult
		else 
			return tag .. result .. (needZeroTag and ".00" or "")
		end
	else
		if string.len(n) > NumberUtil.BILLION_NUM then
			result = NumberUtil.getBillionNumber(n)
		elseif string.len(n) > NumberUtil.MILLION_NUM then
			result = NumberUtil.getShortNumber(n)
		else
			result = NumberUtil.getSourceNumber(n)
			return tag .. result
		end
	end
	
	return (string.len(result) > 8 and result ) or (tag .. result) 
end

function NumberUtil.disableScno(n)
	return string.format("%.0f", math.floor(n)) 
end

function NumberUtil.getSourceNumber(n)
	local arr = LuaHelper.stringToTable(n)
	arr = LuaHelper.resverTable(arr)
	local loop = math.floor((table.getn(arr) - 1) / 3)
	local num = 1;
	for i = 1,loop do
		table.insert(arr, i * 3 + num, ",")
		num = num + 1
	end
	
	arr = LuaHelper.resverTable(arr)
	return LuaHelper.tableToString(arr)
end

function NumberUtil.getShortNumber(n)
	local arr = LuaHelper.stringToTable(n)
	arr = LuaHelper.resverTable(arr)
	local result = {}
	for i = NumberUtil.MILLION_NUM / 2 + 2, #arr do
		if ((i - 1) % 3 == 0 and i ~= NumberUtil.MILLION_NUM / 2 + 2) then
			if (i <= NumberUtil.MILLION_NUM + 1) then
				table.insert(result, ".")
			else
				table.insert(result, ",")
			end
		end
		table.insert(result, arr[i])
	end
	
	return LuaHelper.tableToString( LuaHelper.resverTable(result) ) .. NumberUtil.MILLION_TAG
end

function NumberUtil.getBillionNumber(n)
	local arr = LuaHelper.stringToTable(n)
	arr = LuaHelper.resverTable(arr)
	local result = {}
	for i = 7, table.getn(arr) do
		if ((i - 7) % 3 == 0 and i ~= 7) then
			if (i <= NumberUtil.BILLION_NUM + 1) then
				table.insert(result, ".")
			else
				table.insert(result, ",")
			end
		end
		table.insert(result, arr[i])
	end
	
	return LuaHelper.tableToString( LuaHelper.resverTable(result) ) .. NumberUtil.BILLION_TAG
end

function NumberUtil.centToDollar(n)
	return n / 100
end

function NumberUtil.dollarToCent(n)
	return n * 100
end

function NumberUtil.min(a, b)
	if a > b then
		return b
	else
		return a
	end
end

function NumberUtil.max(a, b)
	if a > b then
		return a
	else
		return b
	end	
end

function NumberUtil.getSmallPointWithTag(pn, tag, n)
	local fstr = "%.0" .. pn .. "f"
	local strnum = string.format(fstr, n)
	return NumberUtil.getNumberByStyle(math.floor(n), 0, tag) .. string.sub(strnum, string.len(strnum) - pn)
end

local hexTable = {
	["0"] = "0000",
	["1"] = "0001",
	["2"] = "0010",
	["3"] = "0011",
	["4"] = "0100",
	["5"] = "0101",
	["6"] = "0110",
	["7"] = "0111",
	["8"] = "1000",
	["9"] = "1001",
	["A"] = "1010",
	["B"] = "1011",
	["C"] = "1100",
	["D"] = "1101",
	["E"] = "1110",
	["F"] = "1111"
}
local function getHex(label)
	return hexTable[label];
end

--十进制 - 二进制
function NumberUtil.transferNumberToBinary(n)
	local hex = NumberUtil.transferNumberToHex(n);
	local result = "";
	for i = 1, string.len(hex) do
		local m_char = string.sub(hex, i, i);
		result = result .. getHex(m_char);
	end
	
	while string.sub(result,1,1) == "0" do
		result = string.sub(result,2 , string.len(result));
	end
	
	return result;
end

--十进制 - 十六
function NumberUtil.transferNumberToHex(n)
	return string.format("%X", n);
end

function NumberUtil.angleToRad(angle)
	return math.pi / 180 * angle; 
end

function NumberUtil.radToAngle(rad)
	return 180 / math.pi * rad; 
end