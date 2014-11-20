--Mason
--弹窗管理
PopUpManager = {};

local popUpList = {};
local currentPopup;
local popUpCacheList = {};

local function setCache(cls, ins)
	popUpCacheList[cls] = ins;
end

local function getCacheInstance(cls)
	if popUpCacheList[cls] then
		return popUpCacheList[cls]
	else
		return require(cls).new();
	end
end

--弹窗 IpopupCls 弹窗类 addToList 是否加入弹窗队列 data 弹窗后所传递的参数
function PopUpManager.showPopWindow(IPopUpCls, addToList, data)
	if addToList then
		table.insert(popUpList, {cls = IPopUpCls, info = data})
		if not currentPopup then
			PopUpManager.nextShow()
		end
	else
		local popUp = getCacheInstance(IPopUpCls);
		if popUp.isSingleButNew and popUp:getParent() then
			return;
		end
		--先设置数据，再显示
		popUp:setData(data)
		popUp:autoShow()
		if popUp.needCache then
			setCache(IPopUpCls, popUp)
		end
	end
end

--获取弹窗实列
function PopUpManager.getPopUpInstance(popCls, isClear)
	local popWindow = popUpCacheList[popCls];
	if popWindow and isClear then
		popUpCacheList[popCls] = nil;
	end
	return popWindow;
end

--清除缓存对象
function PopUpManager.clearPopUp(ins)
	for k, v in pairs(popUpCacheList) do
		if v == ins then
			popUpCacheList[k] = nil;
			return;
		end
	end
end

function PopUpManager.nextShow()
	if #popUpList > 0 then
		local viewInfo = popUpList[1]
		currentPopup = getCacheInstance(viewInfo.cls);
		currentPopup:autoShow()
		currentPopup:setData(viewInfo.info);
		if currentPopup.needCache then
			setCache(viewInfo.cls, currentPopup)
		end
		table.remove(popUpList,1)
	else
		currentPopup = nil;
	end
end

--关闭指定POPUP needCache为true
function PopUpManager.closePopup(cls)
	if popUpCacheList[cls] then
		popUpCacheList[cls]:dispose();
		popUpCacheList[cls] = nil;
	end
end

--清除所有弹窗
function PopUpManager.clear()
	for k, v in pairs(popUpList) do
		if v and type(v) ~= "string" then
			v:dispose();
		end
	end
	popUpList = {}
	popUpCacheList= {}
	currentPopup = nil
end