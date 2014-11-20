--游戏层次管理
local GameLayerMgr = class("GameLayerMgr");

function GameLayerMgr:addMask()
	if not self.maskLayer then
		self.maskLayer = require("commonlibs.managers.layer.MaskLayer").new(ccc4(0,0,0, 0), GameTouchProity.PopUp, true);
	end
	
	if not self.maskLayer:getParent() then
		self.noticeLayer:addChild(self.maskLayer, 0);
	end
end

function GameLayerMgr:removeMask()
	if self.maskLayer then
		self.noticeLayer:removeChild(self.maskLayer);
	end
end


function GameLayerMgr:onAdded(event)
	if self.noticeLayer:getChildrenCount() > 0 then
		self.masedLayer:setTouchEnabled(false)
		self.bgLayer:setTouchEnabled(false)
		self.uiLayer:setTouchEnabled(false)
		self.buttonLayer:setTouchEnabled(false)
		self.topLayer:setTouchEnabled(false)
		self.noticeLayer:setTouchEnabled(false)
		self:addMask();
	end
end



function GameLayerMgr:onRemoved(event)
	if self.noticeLayer:getChildrenCount() <= 1 then
		self.masedLayer:setTouchEnabled(true)
		self.bgLayer:setTouchEnabled(true)
		self.uiLayer:setTouchEnabled(true)
		self.buttonLayer:setTouchEnabled(true)
		self.topLayer:setTouchEnabled(true)
		self.noticeLayer:setTouchEnabled(true)
		self:removeMask()
	end
end

--设置当前游戏层次所在的 父级层
function GameLayerMgr:setup(layer)
	self.root = layer;
	self.masedLayer = display.newLayer();
	self.bgLayer = display.newLayer();
	self.uiLayer = display.newLayer();
	self.buttonLayer = display.newLayer();
	self.topLayer = display.newLayer();
	self.noticeLayer = require("commonlibs.managers.layer.NoticeLayer").new();
	
	self.root:addChild(self.masedLayer);
	self.root:addChild(self.bgLayer);
	self.root:addChild(self.uiLayer);
	self.root:addChild(self.buttonLayer);
	self.root:addChild(self.topLayer);
	self.root:addChild(self.noticeLayer);
	
	self.noticeLayer:addEventListener(Event.ON_ADD_CHILD, handler(self, self.onAdded))
	self.noticeLayer:addEventListener(Event.ON_REMOVE_CHILD, handler(self, self.onRemoved))
end

return GameLayerMgr;