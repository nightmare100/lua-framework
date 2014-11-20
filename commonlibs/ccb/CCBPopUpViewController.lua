--CCB PopUp面板基类控制器支持

local CCBPopUp = class("CCBPopUp", CCB_CELL)

function CCBPopUp:ctor()
	self.proity = self.proity and self.proity or TouchProity.Notice - 1;
	CCB_CELL.ctor(self, self.ccbFile, self.ccbCls, self.proity)
end

--弹窗始终在屏幕中间
function CCBPopUp:initView()
	CCB_CELL.initView(self);
	self.view:setPosition(display.cx, display.cy);
end

--弹窗公共关闭事件
function CCBPopUp:addViewListener()
	self.viewData["onClose"] = handler(self, self.dispose);
end

function CCBPopUp:setData(info)
	CCB_CELL.setData(self, info);
	self.data = info;
	self:processData();
end

--控制器 拿到Model 之后 可重写此方法 render UI
function CCBPopUp:processData()
	
end

--PopupManager 弹窗管理自动调用
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