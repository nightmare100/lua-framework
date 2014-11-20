--LUA 功能扩展
LuaHelper = {}

-- string 转换为table
function LuaHelper.stringToTable(str)
	local result = {}
	for i = 1, string.len(str) do
		table.insert(result, string.sub(str,i , i))
	end
	
	return result
end

--反转table序列
function LuaHelper.resverTable(t)
	local result = {}
	
	for i = table.getn(t), 1, -1 do
		table.insert(result, t[i])
	end

	return result
end

--table数组 转换为string   t table对象  tag 分隔符
function LuaHelper.tableToString(t, tag)
	tag = tag and tag or "";
	local str = ""
	for i = 1, table.getn(t) do
		str = str .. t[i]
		if i < table.getn(t) then
			str = str .. tag
		end
	end
	return str
end

--获取table中 object的 索引
function LuaHelper.getItemIndexInTable(t , item)
	for i = 1, table.getn(t) do
		if t[i] == item then
			return i
		end
	end
	return -1
end

--连接合并 2个 数组TABLE
function table.link(a, b)
	local result = {}
	for i = 1, #a do
		table.insert(result, a[i])
	end
	for i = 1, #b do
		table.insert(result, b[i])
	end
	
	return result;
end

--移除CCARRAY 中 x坐标最 大 或 最小的值
function LuaHelper.removeLastObjX(ccArr, isMax)
	isMax = isMax ~= nil and isMax or true;
	local childIdx;
	local currentX = 0;
	for i = 0, ccArr:count() - 1 do
		local spr = tolua.cast(ccArr:objectAtIndex(i), "CCNode");
		if isMax and spr:getPositionX() > currentX or (not isMax and spr:getPositionX() < currentX) then
			childIdx = i;
			currentX = spr:getPositionX();
		end
	end
	ccArr:removeObjectAtIndex(childIdx, true);
end

--判断2个table数组内容是否相同
function LuaHelper.isTableEquip(tableA, tableB)
	if tableA and tableB and #tableA > 0 and #tableB > 0 and #tableA == #tableB then
		for i = 1, #tableA do
			if tableA[i] ~= tableB[i] then
				return false;
			end
		end
		return true;
	end
	
	return false;
end