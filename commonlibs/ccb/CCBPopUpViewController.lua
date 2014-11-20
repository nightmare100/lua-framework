--CCB PopUp面板基类控制器支持

local CCBPopUp = class("CCBPopUp", CCB_CELL)

function CCBPopUp:ctor()
	self.proity = self.proity and self.proity or TouchProity.Notice - 1;
	CCB_CELL.ctor(self, self.ccbFile, self.ccbCls, self.proity)
end

function CCBPopUp:initView()
	CCB_CELL.initView(self);
	self.view:setPosition(display.cx, display.cy);
end

function CCBPopUp:addViewListener()
	self.viewData["onClose"] = handler(self, self.dispose);
end

function CCBPopUp:setData(info)
	CCB_CELL.setData(self, info);
	self.data = info;
	self:processData();
end

--处理界面逻辑
function CCBPopUp:processData()
	
end

function CCBPopUp:autoShow()
	if not self.view:getParent() then
		local parentNode = (LayerManager and LayerManager.noticeLayer) and LayerManager.noticeLayer or display.getRunningScene()
		parentNode:addChild(self.view, 1);
	end

	self.view:setVisible(true)
end

function CCBPopUp:dispose()
	CCB_CELL.dispose(self);
	PopUpManager.nextShow();
end


return CCBPopUp;