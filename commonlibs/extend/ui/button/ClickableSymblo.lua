--可点击元件

local ClickAbleSymblo = class("ClickAbleSymblo", function(proity)
	return display.newLayer()
end)

function ClickAbleSymblo:ctor(proity)
	self:addTouchEventListener(function(event, x, y)
        return self:onTouch(event, x, y)
    end, false, proity, true)
    self:setTouchEnabled(true)
    self:registerNodeEvent();
    eventDispatcher.extend(self);
end

function ClickAbleSymblo:onExit()	
	
end

function ClickAbleSymblo:onTouch(evt,x,y)
	--转换点坐标 为 元件左下角
	local pt = self.symblo:convertToNodeSpace(ccp(x, y))
	pt.x = pt.x - self.symblo:getContentSize().width / 2
	pt.y = pt.y - self.symblo:getContentSize().height / 2
	local box = self.symblo:boundingBox();
	box.origin.x = box.origin.x - self.symblo:getPositionX()
	box.origin.y = box.origin.y - self.symblo:getPositionY()
	if evt == "began" and box:containsPoint(pt) then
		self:onTouchRightNow();
		return true;
	end
	return false;
end

function ClickAbleSymblo:onTouchRightNow()
	
	self:dispatchEvent({name = ExtendEvent.ON_CLICK})
end

return ClickAbleSymblo;