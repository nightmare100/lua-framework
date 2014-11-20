--普通面板 基类

local BaseView = class("BaseView", function()
	return display.newLayer()
end)

function BaseView:addEvent()

end

function BaseView:removeEvent()

end

--显示面板
function BaseView:show(parNode, zorder)
	zorder = zorder and zorder or 0
	if not self:getParent() then
		parNode:addChild(self, zorder)
	end
	
	self:addEvent();
end

--隐藏面板
function BaseView:hide()
	self:removeEvent();
	self:retain();
	self:removeSelf();
end

--销毁面板
function BaseView:dispose()
	self:removeEvent();
	self:removeSelf(true)
end

return BaseView