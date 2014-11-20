local NumbericControl = class("NumbericControl", function()
	return display.newLayer();
end)

function NumbericControl:ctor(rect,skin, color, minVal, maxVal, default, proity, sound, fontSize)
	eventDispatcher.extend(self);
	self:registerNodeEvent();
	self.rect = rect;
	self.addButton = UI_HoldButton.new(self:getFrames(skin.addBtn), nil, 0.5, proity, sound)
	self.minButton = UI_HoldButton.new(self:getFrames(skin.minBtn), nil, 0.5, proity, sound)
	
	self.minButton:setPosition(self.rect.origin.x  - self.minButton:getWidth() / 2, self.rect.origin.y +  self.rect.size.height / 2)
	self.addButton:setPosition(self.rect.origin.x  + self.rect.size.width + self.addButton:getWidth() / 2, self.rect.origin.y +  self.rect.size.height / 2)
	
	self.txt = cocoExtend.newTTFLabel({
		text = default,
		align = ui.TEXT_ALIGN_CENTER,
		color = color,
		size = fontSize,
		font = "Eras Bold ITC",
		x = self.rect.origin.x + self.rect.size.width / 2,
		y = self.rect.origin.y + self.rect.size.height / 2
	})
	
	self.currentValue = default;
	self.minValue = minVal;
	self.maxValue = maxVal;
	
	self:addChild(self.addButton)
	self:addChild(self.minButton)
	self:addChild(self.txt)
	
	self.addButton:addEventListener(ExtendEvent.ON_CLICK, function() self:onSingleClick(true) end);
	self.minButton:addEventListener(ExtendEvent.ON_CLICK, function() self:onSingleClick(false) end);
	self.addButton:addEventListener(ExtendEvent.ON_HOLD, function() self:onHold(true) end);
	self.minButton:addEventListener(ExtendEvent.ON_HOLD, function() self:onHold(false) end);
	self.addButton:addEventListener(ExtendEvent.ON_HOLD_OUT, handler(self, self.holdOut));
	self.minButton:addEventListener(ExtendEvent.ON_HOLD_OUT, handler(self, self.holdOut));
	
	self.addButton:addEventListener(ExtendEvent.ON_TOUCH_BEGIN, handler(self, self.onTouched))
	self.addButton:addEventListener(ExtendEvent.ON_TOUCH_END, handler(self, self.onTouched))
	self.minButton:addEventListener(ExtendEvent.ON_TOUCH_BEGIN, handler(self, self.onTouched))
	self.minButton:addEventListener(ExtendEvent.ON_TOUCH_END, handler(self, self.onTouched))
end

function NumbericControl:onTouched(evt)
	self:dispatchEvent({name = string.upper(evt.name)})
end

function NumbericControl:setTextVAlgin(align, extraY)
	extraY = extraY == nil and 0 or extraY;

	if align == ui.TEXT_VALIGN_TOP then
		self.txt:setPositionY(self.rect.origin.y + self.rect.size.height / 2 + self.txt:getHeight() / 2 + extraY);
	elseif align == ui.TEXT_VALIGN_BOTTOM then
		self.txt:setPositionY(self.rect.origin.y + self.rect.size.height / 2 - self.txt:getHeight() / 2 + extraY);
	else
		self.txt:setPositionY(self.rect.origin.y + self.rect.size.height / 2 + extraY);
	end
end

function NumbericControl:onSingleClick(isAdded)
	self:addCount(isAdded, true);
end

function NumbericControl:onHold(isAdded)
	self:addCount(isAdded);
end

function NumbericControl:holdOut()
	self:dispatchEvent({name = ExtendEvent.ON_CHANGED, value =  self.currentValue});
end

function NumbericControl:addCount(isAdded, resvert)
	if isAdded then
		self.currentValue = self.currentValue + 1;
	else
		self.currentValue = self.currentValue - 1;
	end
	self:checkValue(resvert);
end

function NumbericControl:checkValue(resvert)
	if resvert then
		self.currentValue = self.currentValue > self.maxValue and self.minValue or self.currentValue
		self.currentValue = self.currentValue < self.minValue and self.maxValue or self.currentValue
	else
		self.currentValue = NumberUtil.max(self.minValue, self.currentValue)
		self.currentValue = NumberUtil.min(self.maxValue, self.currentValue)
	end
	self.txt:setString(self.currentValue);
end

function NumbericControl:setCustomEnabled(value)
	self.addButton:setEnabled(value)
	self.minButton:setEnabled(value)
end

function NumbericControl:onExit()
	if self.addButton then
		self.addButton:removeAllEventListeners();
	end
	
	if self.minButton then
		self.minButton:removeAllEventListeners();
	end
	
	self:removeAllEventListeners();
end

function NumbericControl:setData(value)
	self.currentValue = value;
	self:checkValue();
end

function NumbericControl:getFrames(skins)
	local arr = {}
	for i = 1, #skins do
		table.insert(arr, display.newSpriteFrame(skins[i]));
	end
	return arr;
end

return NumbericControl