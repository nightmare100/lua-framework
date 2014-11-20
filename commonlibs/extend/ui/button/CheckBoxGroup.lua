local CheckBoxGroup = class("CheckBoxGroup", UI_RadioGroup)

function CheckBoxGroup:ctor(radios, dir, margin, defaultIndex)
	self:registerNodeEvent();
	eventDispatcher.extend(self);
	self.radios = radios
	self.dir = dir;
	self.margin = margin;
	self.selectedIndex = defaultIndex and defaultIndex or {};
	self:drawLayout()
	self:setIndex(self.selectedIndex)
end

function CheckBoxGroup:addChildListener()
	for i = 1, #self.radios do
		self.radios[i]:addEventListener("onCheckUnBoxSelected", function(event) 
			self:onSelectedChanged(event, false)
		end)
		self.radios[i]:addEventListener("onCheckBoxSelected", function(event) 
			print("selected!!")
			self:onSelectedChanged(event, true)
		end)
	end
end

function CheckBoxGroup:onSelectedChanged(evt, isSelected)
	if self:isInSelected(evt.data, self.selectedIndex) then
		if not isSelected then
			table.remove(self.selectedIndex, LuaHelper.getItemIndexInTable(self.selectedIndex, evt.data))
		end
	else
		if isSelected then
			table.insert(self.selectedIndex, evt.data)
		end
	end

	self:setIndex(self.selectedIndex)
	self:dispatchEvent({name = "onCheckBoxChanged", index = evt.data})
end

function CheckBoxGroup:setIndex(idx)
	self.selectedIndex = idx and idx or {}
	for i = 1, #self.radios do
		if (self:isInSelected(self.radios[i].index, idx)) then
			self.radios[i]:setSelected(true)
		else
			self.radios[i]:setSelected(false)
		end
	end
	self.selectedIndex = idx
end

function CheckBoxGroup:isInSelected(id, ids)
	for i = 1, #ids do
		if ids[i] == id then
			return true;
		end
	end
	return false;
end

return CheckBoxGroup