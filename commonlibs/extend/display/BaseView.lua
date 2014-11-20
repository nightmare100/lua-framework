local BaseView = class("BaseView", function()
	return display.newLayer()
end)

function BaseView:addEvent()

end

function BaseView:removeEvent()

end

function BaseView:show(parNode, zorder)
	zorder = zorder and zorder or 0
	if not self:getParent() then
		parNode:addChild(self, zorder)
	end
	
	self:addEvent();
end

function BaseView:hide()
	self:removeEvent();
	self:retain();
	self:removeSelf();
end

function BaseView:dispose()
	self:removeEvent();
	self:removeSelf(true)
end

return BaseView