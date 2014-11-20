--单选按钮的实现
local RadioButton = class("RadioButton", function(frames, idx, proity, enabled, useSound)
	local spr = display.newSprite();
	spr.frames = frames
	spr.index = idx;
	spr.proity = proity == nil and TouchProity.Lobby or proity;
	spr.useSound = useSound == nil and true or useSound;
	eventDispatcher.extend(spr);
	
	spr.touchEnabled = (enabled == nil) and true or enabled;
	
	return spr
end)

function RadioButton:ctor()
	self.enabled = true;
	self:setSelected(false)
    self:setContentSize(self:getContentSize())
    
    if self.touchEnabled then
		self:addTouchEventListener(function(event, x, y)
	        -- event: began, moved, ended
	        -- x, y: world coordinate
	        
	        local touchInSprite = self:getCascadeBoundingBox():containsPoint(CCPoint(x, y))
	        if event == "began" and touchInSprite then
	            self:onTouchRightNow();
	            return cc.TOUCH_BEGAN;
	        end
	        return cc.TOUCH_BEGAN_NO_SWALLOWS
	    end, false, self.proity, true)
	    self:setTouchEnabled(true);
	 end
end

function RadioButton:onExit()
	self:removeAllEventListeners();
end

function RadioButton:onTouchRightNow()
	if not self.isSelected and self.enabled then
		if self.useSound then
			SoundMgr.playSound("SIMPLE_CLICK")
		end	
			
		self:dispatchEvent({name = "onRadioSelected", data = self.index})
	end
end

function RadioButton:customEnabled(value)
	self.enabled = value;
	if #self.frames > 2 then
		self:setDisplayFrame(self.frames[not self.enabled and 3 or (self.isSelected and 2 or 1)]);
	end 
end

function RadioButton:setData(value)
	self.data = value
end

function RadioButton:setSelected(value)
	self.isSelected = value;
	self:setDisplayFrame(self.frames[value and 2 or 1]);
end

function RadioButton:onTouch(event, x, y)
end

function RadioButton:onTap(x, y)
	self:dispatchEvent({name = "onTap", data = self.info})
end

function RadioButton:onExit()
    self:removeAllEventListeners()
end

return RadioButton;