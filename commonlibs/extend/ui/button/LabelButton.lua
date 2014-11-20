--标签按钮
local LabelButton = class("LabelButton", function()
	return display.newNode();
end)

function LabelButton:ctor(info, align, color,size)
	align = align and align or ui.TEXT_ALIGN_LEFT
	self.data = info;
	self.label = ui.newTTFLabel({
		text = info,
		align = align,
		color = color,
		dimensions = size,
		x = (display.size.width - size.width) / 2,
		y = 0,
		size = 20
	})
	self.label:align(display.LEFT_TOP)
	self:addChild(self.label);
end

function LabelButton:addClickHandler(proity, cb)
	self:addTouchEventListener(function(event, x, y)
	        if event == "began" then
	        	cb();
	            return cc.TOUCH_BEGAN
	        end
	        return cc.TOUCH_BEGAN_NO_SWALLOWS
	    end, false, proity);
	self:setTouchEnabled(true);
end

function LabelButton:setData(info)
	self.data = info
	if info then
		self.label:setString(info);
	end
end


function LabelButton:onTap()
	
end



return LabelButton