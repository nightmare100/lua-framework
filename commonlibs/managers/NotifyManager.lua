--Mason
--消息管理 消息缓存
local NotifyManager = class("NotifyManager");

--每种消息的缓存最大数量
NotifyManager.MAX_CACHE_COUNT = 100;

function NotifyManager:ctor()
	self.notifyMap = {};
	self.notifyMap[NotifyType.NOTIFY_MARK] = {};
	self.notifyMap[NotifyType.NOTIFY_SCROLL] = {};
	self.notifyMap[NotifyType.NOTIFY_CHAT] = {};
	eventDispatcher.extend(self);
end

--添加一条消息
function NotifyManager:addMessage(info)
	local notices = self.notifyMap[info.type];
	assert(notices ~= nil, string.format("the message type %s is not vaild", info.type));
	table.insert(notices, info);
	table.sort(notices, handler(self, self.onCellSort))
	self:dispatchEvent({name = Event.ON_NOTIFY .. info.notifyType, messageName = info.notifyName, data = info.data});
end

--添加一群消息
function NotifyManager:addMessageList(type, name, lists)
	assert(self.notifyMap[type] ~= nil, string.format("the message type %s is not vaild", type));
	self.notifyMap[type] = table.link(self.notifyMap[type], lists)
	table.sort(self.notifyMap[type], handler(self, self.onCellSort))
--	if #lists > 0 then
	self:dispatchEvent({name = Event.ON_NOTIFY .. type, messageName = name});
--	end
end

--取每类消息总数
function NotifyManager:getNotifyLen(type, name)
	local list = self.notifyMap[type];
	if (name == nil) then
		return #list;
	else
		local n = 0;
		for k, v in pairs(list) do
			if v.notifyName == name then
				n = n + 1;
			end
		end
		return n;
	end
end

function NotifyManager:getNotifyList(type, name)
	local list = self.notifyMap[type];
	if (name == nil) then
		return list;
	else
		local result = {};
		for k, v in pairs(list) do
			if v.notifyName == name then
				table.insert(result, v);
			end
		end
		return result;
	end
end


--删除一条消息
function NotifyManager:deleteSingle(info)
	local list = self.notifyMap[info.notifyType];
	for k, v in pairs(list) do
		if v.messageTimer == info.messageTimer then
			list[k] = nil;
			self:dispatchEvent({name = Event.ON_NOTIFY_DEL .. info.notifyType, messageName = info.notifyName});
			return;
		end
	end
end

--从列表中获取最前一条 该类型数据 并删除
function NotifyManager:getSingleNotice(type)
	local list = self.notifyMap[type];
	if list and #list > 0 then
		local info = list[1];
		list[1] = nil;
		self:dispatchEvent({name = Event.ON_NOTIFY_DEL .. info.notifyType, messageName = info.notifyName});
		return info;
	else
		return nil;
	end
end

--删除某一类消息
function NotifyManager:clearNotifyByType(type, name)
	local list = self.notifyMap[type];
	if list then
		if name then
			for k, v in pairs(list) do
				if v.notifyName == name then
					list[k] = nil;
				end
			end
		else
			self.notifyMap[type] = {};
		end
	end
end

--清除所有
function NotifyManager:clear()
	self:removeAllEventListeners();
	self.notifyMap = {};
	self.notifyMap[NotifyType.NOTIFY_MARK] = {};
	self.notifyMap[NotifyType.NOTIFY_SCROLL] = {};
	self.notifyMap[NotifyType.NOTIFY_CHAT] = {};
end

function NotifyManager:onCellSort(o1, o2)
	if o1.proity > o2.proity then
		return false;
	elseif o1.proity == o2.proity then
		if o1.messageTimer > o2.messageTimer then
			return true;
		else
			return false;
		end
	else
		return true;
	end
	
end

NotifyMgr = NotifyManager.new();


return NotifyManager;