--支持Mousedown事件
--支持长按的 按钮
local HoldButton = class("HoldButton", UI_PressButton)

function HoldButton:onTouchRightNow()
	if self.enabled then
		audio.playSound(self.sound);
		Tick:getInstance():kill("pressButton");
		self:setDisplayFrame(self.frames[2]);
		self.tick = self.timeTick:gettime()
		Tick:getInstance():addInterval(handler(self, self.onHold), 0, "pressButton")
	end
end

function HoldButton:onHold()
	if self.timeTick:gettime() - self.tick >= self.hold then
		self:dispatchEvent({name = ExtendEvent.ON_HOLD})
	end
end

function HoldButton:pressUp()
	Tick:getInstance():kill("pressButton");
	self:setDisplayFrame(self.frames[1]);
	self:dispatchEvent({name = ExtendEvent.ON_HOLD_OUT})
end



function HoldButton:checkClickAndHold()
	if self.timeTick:gettime() - self.tick < self.hold then
		self:dispatchEvent({name = ExtendEvent.ON_CLICK})
	end
	self:pressUp();
end


return HoldButton;