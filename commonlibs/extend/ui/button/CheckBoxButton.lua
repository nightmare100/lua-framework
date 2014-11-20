local CheckBoxButton = class("CheckBoxButton", UI_RadioButton)

function CheckBoxButton:onTouchRightNow()
	if self.isSelected then
		self:dispatchEvent({name = "onCheckUnBoxSelected", data = self.index})
	else
		self:dispatchEvent({name = "onCheckBoxSelected", data = self.index})
	end
--	self:setSelected(not self.isSelected)
end

return CheckBoxButton;