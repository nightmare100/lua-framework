--event : onRadioGroupChanged
--单选按钮组

local RadioGroup = class("RadioGroup", function(radios, dir, margin, defaultIndex)
	return display.newNode();
end)

RadioGroup.DIRECTION_VERTICAL   = 1
RadioGroup.DIRECTION_HORIZONTAL = 2

function RadioGroup:ctor(radios, dir, margin, defaultIndex)
	self:registerNodeEvent();
	eventDispatcher.extend(self);
	self.radios = radios
	self.dir = dir;
	self.margin = margin;
	self.selectedIndex = defaultIndex and defaultIndex or -1;
	self:drawLayout()
	self:setIndex(self.selectedIndex)
end

function RadioGroup:onExit()
	self:removeAllEventListeners();
end

function RadioGroup:setEnabled(val)
	for i = 1, #self.radios do
		self.radios[i]:customEnabled(val);
	end
end

function RadioGroup:drawLayout()
	local scaleFactor = CCDirector:sharedDirector():getContentScaleFactor()
	local width,height = 0, 0
	local offsetX,offsetY = 0 , 0
	for i = 1, #self.radios do
		local margin = (i == 1 and 0 or self.margin / scaleFactor)
		if (self.dir == self.DIRECTION_HORIZONTAL) then
			width = width + self.radios[i]:getContentSize().width + (i == #self.radios and 0 or self.margin / scaleFactor);
			offsetX = offsetX + self.radios[i]:getContentSize().width + margin
			self.radios[i]:setPosition(offsetX - self.radios[i]:getContentSize().width / 2 , 0)
			
			height = NumberUtil.max(height, self.radios[i]:getContentSize().height)
		else
			height = height + self.radios[i]:getContentSize().height + (i == #self.radios and 0 or self.margin / scaleFactor);
			offsetY = offsetY - self.radios[i]:getContentSize().height - margin
			self.radios[i]:setPosition(0, offsetY + self.radios[i]:getContentSize().height / 2)
			width = NumberUtil.max(width, self.radios[i]:getContentSize().width)
		end	
			
		self:addChild(self.radios[i])
	end

	
	self:addChildListener()
	self:setContentSize(CCSizeMake(width, height))
end

function RadioGroup:addChildListener()
	for i = 1, #self.radios do
		self.radios[i]:addEventListener("onRadioSelected", function(event) 
			return self:onSelectedChanged(event)
		end)
	end
end

function RadioGroup:onSelectedChanged(evt)
	if evt.data ~= self.selectedIndex then
		self:setIndex(evt.data)
		self:dispatchEvent({name = "onRadioGroupChanged"})
	end
end

function RadioGroup:clear()
	for i = 1, #self.radios do
		self.radios[i]:removeAllEventListeners();
		self.radios[i]:removeSelf(true);
	end
end

function RadioGroup:setResetRadios(radios, defaultIndex)
	self:clear();
	self.radios = radios
	self.selectedIndex = defaultIndex and defaultIndex or -1;
	self:drawLayout()
	self:setIndex(self.selectedIndex)
end

function RadioGroup:setIndex(idx)
	for i = 1, #self.radios do
		if (idx ~= self.radios[i].index) then
			self.radios[i]:setSelected(false)
		else
			self.radios[i]:setSelected(true)
		end
	end
	self.selectedIndex = idx
end

function RadioGroup:getSelectedInedx()
	return self.selectedIndex
end

function RadioGroup:getSelectedValue()
	if self.radios[self.selectedIndex] then
		return self.radios[self.selectedIndex].data
	else
		return nil
	end
end

return RadioGroup