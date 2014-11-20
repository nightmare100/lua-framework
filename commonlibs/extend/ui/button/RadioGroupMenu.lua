--event : onRadioGroupChanged
--RadioCCMenuItem  版

local RadioGroupMemuItem = class("RadioGroupMemuItem")

RadioGroupMemuItem.DIRECTION_VERTICAL   = 1
RadioGroupMemuItem.DIRECTION_HORIZONTAL = 2

function RadioGroupMemuItem:ctor(radios, defaultIndex, proxy)
	eventDispatcher.extend(self);
	self.radios = radios
	self.selectedIndex = defaultIndex and defaultIndex or -1;
	for i = 1, #self.radios do
		self.radios[i]:setTag(i);
		proxy:setCallback(self.radios[i], handler(self, self.onNodeClicked))
	end
	self:setIndex(self.selectedIndex)
end

function RadioGroupMemuItem:onNodeClicked(evt, target)
	local tag = target:getTag();
	local ischanged = self.selectedIndex ~= tag;
	self.selectedIndex = tag;
	for i = 1, #self.radios do
		if self.radios[i]:getTag() == self.selectedIndex then
			self.radios[i]:selected();
		else
			self.radios[i]:unselected();
		end
	end
	if ischanged then
		self:dispatchEvent({name = "onRadioGroupMemuItemChanged"});
	end
end

function RadioGroupMemuItem:setEnabled(val)
	for i = 1, #self.radios do
		self.radios[i]:setEnabled(val);
	end
end

function RadioGroupMemuItem:setResetRadios(radios, defaultIndex)
	self:clear();
	self.radios = radios
	self.selectedIndex = defaultIndex and defaultIndex or -1;
	self:drawLayout()
	self:setIndex(self.selectedIndex)
end

function RadioGroupMemuItem:setIndex(idx)
	for i = 1, #self.radios do
		if (idx ~= self.radios[i]:getTag()) then
			self.radios[i]:unselected()
		else
			self.radios[i]:selected();
		end
	end
	self.selectedIndex = idx
end

function RadioGroupMemuItem:getSelectedInedx()
	return self.selectedIndex
end

function RadioGroupMemuItem:getSelectedValue()
	if self.radios[self.selectedIndex] then
		return self.radios[self.selectedIndex].data
	else
		return nil
	end
end

return RadioGroupMemuItem