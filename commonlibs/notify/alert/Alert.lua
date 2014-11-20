--alert 面板
local Alert = class("Alert", CCB_CELL)

function Alert:ctor()
	CCB_CELL.ctor(self, "juese_cuowutishi.ccbi", "ErrorTipsView", TouchProity.NoticeCell);
end

function Alert:addViewListener()
	self.viewData["onClose"] = handler(self, self.onClose);
	self.viewData["onSure"] = handler(self, self.onSure);
end

function Alert:onSure(evt)
	SoundMgr.playSoundDirect(SoundRes.EFFECT_SUB);
	if self.callFunc then
		self.callFunc();
	end
	 self:dispose();
end

function Alert:onClose(evt)
	self:onSure(evt);
end

function Alert:show(tips, callBack,cancel, parms)
	self.callFunc = callBack;
	self.view:setPosition(display.cx, display.cy);
	if LayerManager.alertLayer then
		LayerManager.alertLayer:addChild(self.view, 1);
	else
		display.getRunningScene():addChild(self.view, 1);
	end
	self.viewData["errorText"]:setString(tips);
end

function Alert:dispose()
	CCB_CELL.dispose(self);
	AlertMgr:showNext();
end

return Alert;