--可长按按钮
local PressButton = class("PressButton", function(frames, name, holdTime, proity, sound)
	local spr = display.newSprite()
	spr:setDisplayFrame(frames[1]);
	spr.frames = frames
	spr.symblo = spr
	spr.proity = proity;
	spr.hold = holdTime;
	spr.sound = sound;
	eventDispatcher.extend(spr);
    spr:registerNodeEvent();
	if name then
		spr:setCustomPosition(name);
	end
	return spr
end)

function PressButton:ctor()
	self:setTouchPriority(self.proity);
	self:addTouchEventListener(function(event, x, y)
        return self:onTouch(event, x, y)
    end, false, self.proity, true)
    self:setTouchEnabled(true)

	self.timeTick = require("socket");
	self.enabled = true;
	self.tick = 0;
end

function PressButton:onTouch(evt,x,y)

	--转换点坐标 为 元件左下角
	local pt = self:convertToNodeSpace(ccp(x, y))
	pt.x = pt.x - self:getContentSize().width / 2
	pt.y = pt.y - self:getContentSize().height / 2
	local box = self.symblo:boundingBox();
	box.origin.x = box.origin.x - self.symblo:getPositionX()
	box.origin.y = box.origin.y - self.symblo:getPositionY()
	if evt == "began" and box:containsPoint(pt) then
		self:onTouchRightNow();
		self:dispatchEvent({name = ExtendEvent.ON_TOUCH_BEGIN})
		return true;
	elseif evt == "ended" and self.enabled then
		if box:containsPoint(pt) then
			self:checkClickAndHold()
		else
			self:pressUp()
		end
	end
	return false;
end

function PressButton:onExit()
	self:removeAllEventListeners();
	Tick:getInstance():kill("pressButton");
end

function PressButton:onTouchRightNow()
	if self.enabled then
		Tick:getInstance():kill("pressButton");
		self:setDisplayFrame(self.frames[2]);
		self.tick = self.timeTick:gettime()
		Tick:getInstance():addInterval(handler(self, self.onHold), 0, "pressButton")
	end
end

function PressButton:onHold()
	if self.timeTick:gettime() - self.tick >= self.hold then
		audio.playSound(self.sound);
		Tick:getInstance():kill("pressButton");
		self:dispatchEvent({name = ExtendEvent.ON_HOLD})
		self:dispatchEvent({name = ExtendEvent.ON_TOUCH_END})
	end
end

function PressButton:pressUp()
	self:setDisplayFrame(self.frames[1]);
	Tick:getInstance():kill("pressButton");
	
	self:dispatchEvent({name = ExtendEvent.ON_TOUCH_END})
end

function PressButton:checkClickAndHold()
	Tick:getInstance():kill("pressButton");
	if self.timeTick:gettime() - self.tick < self.hold then
		audio.playSound(self.sound);
		self:dispatchEvent({name = ExtendEvent.ON_CLICK})
	end
	self:pressUp();
end

function PressButton:setEnabled(value)
	self:setDisplayFrame(value and self.frames[1] or  self.frames[3]);
	
	self:setTouchEnabled(value);
end

return PressButton;