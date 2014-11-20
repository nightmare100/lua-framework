--游戏层级基类

local GameLayer = class("GameLayer", function()
	return display.newLayer();
end);

function GameLayer:ctor()
	eventDispatcher.extend(self);
	self:addTouchEventListener(function(event,x,y)
			return true;
		end, false, TouchProity.Game + 1, true)
	self:setTouchEnabled(true)
	self:registerNodeEvent();
end

return GameLayer;