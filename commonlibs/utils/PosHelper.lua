--坐标工具辅助
PosHelper = {}

function PosHelper.getPosRect(name, posTable)
	local scale = CCDirector:sharedDirector():getContentScaleFactor()
	local posInfo = posTable[name]
	return CCRectMake(display.cx + posInfo.x / scale - posInfo.width / scale / 2, display.cy + posInfo.y / scale - posInfo.height / scale / 2, posInfo.width / scale, posInfo.height / scale)
end

function PosHelper.getPosSize(name, posTable)
	local scale = CCDirector:sharedDirector():getContentScaleFactor()
	local posInfo = posTable[name]
	return CCSizeMake(posInfo.width / scale, posInfo.height / scale)
end

function PosHelper.getPosInfo(name, posTable)
	local scale = CCDirector:sharedDirector():getContentScaleFactor()
	local posInfo = posTable[name]
	return posInfo.x / scale, posInfo.y / scale;
end

--4定点初始坐标转换  return x, y
function PosHelper.getTransformPoint(node, type)
	node:setPosition(0, 0);
	local rect = node:getCascadeBoundingBox(false);
	if type == display.LEFT_TOP then
		return rect.origin.x, rect.origin.y + rect.size.height
	elseif type == display.RIGHT_TOP then
		return rect.origin.x + rect.size.width, rect.origin.y + rect.size.height
	elseif type == display.LEFT_BOTTOM then
		return rect.origin.x, rect.origin.y
	elseif type == display.BOTTOM_RIGHT then
		return rect.origin.x + rect.size.width, rect.origin.y
	end
end

function PosHelper.getNodeCenterPt(node, dir)
	local size = node:getContentSize();
	local wordPos = node:convertToWorldSpace(ccp(0, 0));
	return ccp(wordPos.x + size.width / 2, wordPos.y)
end

--获取 ccbnode 矩形区域
function PosHelper.getNodeRect(touchNode)
	  local worldCCp = touchNode:convertToWorldSpace(ccp(0, 0));
	  return CCRectMake(worldCCp.x, worldCCp.y, touchNode:getContentSize().width, touchNode:getContentSize().height);
end

--计算2点之间形成直线的角度
function PosHelper.getAngleByPoints(stpt, endpt)
	local wid = endpt.x - stpt.x;
	local hei = endpt.y - stpt.y;
	local rad = math.atan(wid / hei);
	return NumberUtil.radToAngle(rad);
end