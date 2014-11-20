--全局层级管理 用于大厅
local LayerMgr = class("LayerMgr");

function LayerMgr:ctor()
	self.rootRect = require("commonlibs.data.RectInfo").new();
end

function LayerMgr:addMask()
	if not self.maskLayer then
		self.maskLayer = require("commonlibs.managers.layer.MaskLayer").new(ccc4(0,0,0, 255 * 0.5), TouchProity.Notice + 1, true);
	end
	
	if not self.maskLayer:getParent() then
		self.noticeLayer:addChild(self.maskLayer, 0);
		GlobalDispatcher:dispatchEvent({name = Event.ON_POPUP_OPEN});
	end
end

function LayerMgr:removeMask()
	if self.maskLayer then
		self.noticeLayer:removeChild(self.maskLayer);
		GlobalDispatcher:dispatchEvent({name = Event.ON_POPUP_CLOSE});
	end
end


function LayerMgr:onAdded(event)
	if self.noticeLayer:getChildrenCount() > 0 then
		self.lobbyLayer:setTouchEnabled(false)
		self.gameLayer:setTouchEnabled(false)
		self.uiLayer:setTouchEnabled(false)
		self.topLayer:setTouchEnabled(false)
		self:addMask();
	end
end

function LayerMgr:onRemoved(event)
	if self.noticeLayer:getChildrenCount() <= 1 then
		self.lobbyLayer:setTouchEnabled(true)
		self.gameLayer:setTouchEnabled(true)
		self.uiLayer:setTouchEnabled(true)
		self.topLayer:setTouchEnabled(true)
		self:removeMask()
	end
end

--设置大厅 跟级层
function LayerMgr:setup(layer)
	self.root = layer;
	self.bgLayer = display.newLayer();
	self.lobbyLayer = display.newLayer();
	self.gameLayer = display.newLayer();
	self.uiLayer = display.newLayer();
	self.skillLayer = display.newLayer();
	self.topLayer = display.newLayer();
	self.noticeLayer = require("commonlibs.managers.layer.NoticeLayer").new();
	self.alertLayer = display.newLayer();
	
	self.root:addChild(self.bgLayer);
	self.root:addChild(self.lobbyLayer);
	self.root:addChild(self.gameLayer);
--	self:checkClipRect()
	self.root:addChild(self.uiLayer);
	self.root:addChild(self.skillLayer);
	self.root:addChild(self.topLayer);
	self.root:addChild(self.noticeLayer);
	self.root:addChild(self.alertLayer);
	
	
	self.noticeLayer:addEventListener(Event.ON_ADD_CHILD, handler(self, self.onAdded))
	self.noticeLayer:addEventListener(Event.ON_REMOVE_CHILD, handler(self, self.onRemoved))
end

-- 针对IPAD 剪切区域
function LayerMgr:checkClipRect()
	if CCApplication:sharedApplication():getTargetPlatform() ~= kTargetIphone then
		local accHeight = (display.size.height - FIX_HEIGHT) / 2;
		
		local topRect = display.newRect(CCRectMake(0, display.size.height - accHeight / 2, display.size.width, accHeight));
		local bottomRect = display.newRect(CCRectMake(0, accHeight / 2, display.size.width, accHeight))
		
		topRect:setPositionX(display.cx)
		bottomRect:setPositionX(display.cx)
		topRect:setFill(true)
		bottomRect:setFill(true)
		topRect:setColor(ccc3(0,0,0))
		bottomRect:setColor(ccc3(0,0,0))
		
		self.root:addChild(topRect);
		self.root:addChild(bottomRect);
		
	end
end

function LayerMgr:getPopUpNum()
	if self.noticeLayer then
		local count = self.noticeLayer:getChildrenCount() - 1;
		return count < 0 and 0 or count;
	else
		return 0
	end
end

return LayerMgr;