--CCControlSwitch TOLUA 后 有点问题 改用这个 灵活

local SwitchButton = class("SwitchButton", function()
	return display.newLayer();
end)

function SwitchButton:ctor(onSprite, offSprite, bottomSprite, proity, file, useSound)
	eventDispatcher.extend(self);
	self.enabled = true;
	self.useSound = useSound == nil and true or useSound;

	self:addTouchEventListener(function(event, x, y)
        return self:onTouch(event, x, y)
    end, false, proity)
    self:setTouchEnabled(true)
    
    self.bottomSpr = bottomSprite;
    self.onSprite = display.newSprite(onSprite .. "nor.png");
    self.offSprite = display.newSprite(offSprite .. "nor.png");
    self.onDis = display.newSprite(onSprite .. "dis.png");
    self.offDis = display.newSprite(offSprite .. "dis.png");
    
    if self.bottomSpr then
    	self:addChild(self.bottomSpr)
    end
    self:addChild(self.onDis)
    self:addChild(self.offDis)
    self:addChild(self.onSprite)
    self:addChild(self.offSprite)
    
    self.onDis:setPositionX(0 - self.onDis:getWidth() / 2)
    self.offDis:setPositionX(self.offDis:getWidth() / 2)
    self.onSprite:setPositionX(0 - self.onSprite:getWidth() / 2)
    self.offSprite:setPositionX(self.offSprite:getWidth() / 2)
    
    if file then
    	self:setCustomPosition(file)
    end
    
    self.touchRect = CCRectMake(self:getPositionX() - self.onSprite:getWidth(), self:getPositionY() - self.onSprite:getHeight() / 2, self.onSprite:getWidth() + self.offSprite:getWidth(), self.onSprite:getHeight())
    self:checkButton()
end

function SwitchButton:checkButton()
	if self.enabled then
		self.onSprite:setVisible(true)
		self.offSprite:setVisible(false)
	else
		self.onSprite:setVisible(false)
		self.offSprite:setVisible(true)
	end
end

function SwitchButton:onTouch(event,x, y)
	if event == "began" and self.touchRect:containsPoint(ccp(x, y)) then
		return true;
	end
	
	if event == "ended" and self.touchRect:containsPoint(ccp(x, y)) then
		self:toggle();
	end
	
	return false;
end

function SwitchButton:toggle()
	if self.useSound then
		SoundMgr.playSound("SIMPLE_CLICK")
	end	
		
	self.enabled = not self.enabled;
	self:checkButton();
	self:dispatchEvent({name = ExtendEvent.ON_SWITCH_CHANGED, enabled = self.enabled})
end

return SwitchButton