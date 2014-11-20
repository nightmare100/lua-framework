--弹窗消息管理
local AlertManager = class("AlertManager");

local maskLayer = require("commonlibs.managers.layer.MaskLayer").new(ccc4(0, 0, 0, 125), TouchProity.Alert, true);
function AlertManager:ctor()
	self.winLists = {};
	self.currentWindow = nil;
end

--Alert弹窗
function AlertManager:showAlert(tips, callBack, obj)
	self.winLists[#self.winLists + 1] = {word = tips, sure = callBack, type = "Alert", parms = obj}
	if not self.currentWindow then
		self:showNext();
	end
end

function AlertManager:showNext()
	if #self.winLists > 0 then
		local item = self.winLists[1];
		self.currentWindow = require("commonlibs.notify.alert." .. item.type).new()
		self.currentWindow:show(item.word, item.sure, item.cancel, item.parms);
		table.remove(self.winLists, 1);
		if not maskLayer:getParent() then
			if LayerManager.alertLayer then
				LayerManager.alertLayer:addChild(maskLayer, 0);
			else
				local scene = display.getRunningScene();
				scene:addChild(maskLayer, 0)
			end
		end
	else
		self.currentWindow = nil;
		maskLayer:removeSelf();
	end
end

--Confirm 弹窗
function AlertManager:showConfirm(tips, onSure, onCancel)
	self.winLists[#self.winLists + 1] = {word = tips, sure = onSure, cancel = onCancel, type = "Confirm"}
	if not self.currentWindow then
		self:showNext();
	end
end

function AlertManager:clear()
	self.winLists = {};
	self.currentWindow = nil;
end


AlertMgr = AlertManager.new();

return AlertManager;