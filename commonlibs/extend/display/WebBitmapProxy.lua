--网络图片 远程代理
local WebBitmapProxy = class("WebBitmapProxy", function()
	return display.newNode();
end)

function WebBitmapProxy:ctor(url, fileName, isRelative, proity, isSupportClick)
	eventDispatcher.extend(self);
	local scale = CCDirector:sharedDirector():getContentScaleFactor();
	self:registerNodeEvent();
	if fileName then
		self:setCustomPosition(fileName);
	end
	self.rectInfo = self:getCustomPosition(fileName);
	
	if isRelative then
		self:setPosition(self.rectInfo.x / scale, self.rectInfo.y / scale)
	end
	
	self.picName = FileDownLoadManager:saveFile(url, handler(self, self.onLoad));
	self.proity = proity;

	if isSupportClick then
		self:addTouchEventListener(function(event, x, y)
	        if event == "began" then
	            self:onTouchRightNow();
	            return cc.TOUCH_BEGAN -- catch touch event, stop event dispatching
	        end
	        return cc.TOUCH_BEGAN_NO_SWALLOWS
	    end, false, self.proity, true)
		self:setTouchEnabled(true);
	end
end

function WebBitmapProxy:onLoad(event)
	--checkAndroid 
	if device.platform == "ios" then
		self:onPicTransComplete(event)
	else
		
	end
end

function WebBitmapProxy:onPicTransComplete(event)
	local scale = CCDirector:sharedDirector():getContentScaleFactor();
	local spr = display.newSprite(event.fileName);
	self:addChild(spr);
	
	if self.rectInfo then
		self:setScaleX(self.rectInfo.width / scale / spr:getWidth())
		self:setScaleY(self.rectInfo.height / scale / spr:getHeight())
	end
	
	self:dispatchEvent({name = ExtendEvent.ON_LOAD, content = self});
end

function WebBitmapProxy:onTouchRightNow()
	self:dispatchEvent({name = ExtendEvent.ON_CLICK})
end

function WebBitmapProxy:onExit()
	FileDownLoadManager:removeKey(self.picName);
	self:removeAllEventListeners();
end

return WebBitmapProxy;