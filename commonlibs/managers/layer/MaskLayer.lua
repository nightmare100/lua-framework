--遮罩层

local MaskLayer = class("MaskLayer", function(color, proity)
	return CCLayerColor:create(color);
end);

function MaskLayer:ctor(color, proity, needRetain)
	self.proity = proity;
	CCLayerExtend.extend(self);
	self:registerNodeEvent();
	if needRetain then
		self:retain();
	end
	
	
end

function MaskLayer:onEnter()
	self:addTouchEventListener(function(event,x,y)
			return true;
		end, false, self.proity, true)
	self:setTouchEnabled(true)
end

return MaskLayer;