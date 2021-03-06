--消息层 自动锁定 下级层功能

local NoticeLayer = class("NoticeLayer", function() 
	return display.newLayer()
end)

function NoticeLayer:ctor()
	eventDispatcher.extend(self)
	self.numChildren = self:getChildrenCount();
	self:scheduleUpdate(function(dt) self:enterFrame(dt) end)
	self:registerNodeEvent();
end

--这个曾 根据自身的 子元素数量 来调整 自己的 优先级 从而达到模态窗口的用途。
function NoticeLayer:enterFrame(dt)
	local newCount = self:getChildrenCount();
	if newCount > self.numChildren then
		self:dispatchEvent({name = Event.ON_ADD_CHILD})
	elseif newCount < self.numChildren then
		self:dispatchEvent({name = Event.ON_REMOVE_CHILD})
	end
	
	self.numChildren = newCount
end

function NoticeLayer:onExit()
	self:removeAllEventListeners();
	self:unscheduleUpdate();
end

return NoticeLayer