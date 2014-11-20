--confirm面板
local Confirm = class("Confirm", DISPLAY_BASEVIEW)

function Confirm:ctor()
	local scale = CCDirector:sharedDirector():getContentScaleFactor();
	self.bg = display.newBackgroundSprite("#popbg_s_bg.png");
	self:addChild(self.bg);
	
	local okbtn = ui.newImageMenuItem({
		image = "#pop_ok_nor.png",
		imageSelected = "#pop_ok_dow.png",
		sound = SoundMgr.getSoundPath("SIMPLE_CLICK"),
        listener = function()
            self:onSure();
        end,
        x = display.cx - 135 / scale,
        y = display.cy - self.bg:getHeight() / 2 + 50 / scale;
	});
	local cancelBtn = ui.newImageMenuItem({
		image = "#pop_cancel_nor.png",
		imageSelected = "#pop_cancel_dow.png",
		sound = SoundMgr.getSoundPath("SIMPLE_CLICK"),
        listener = function()
            self:onCancel();
        end,
        x = display.cx + 135 / scale,
        y = display.cy - self.bg:getHeight() / 2 + 50 / scale;
	});
	
	self.text = cocoExtend.newShandowTTFLabel({
		x = display.cx,
		y = display.cy + okbtn:getHeight() / 2,
		size = 36,
		font = "Eras Bold ITC",
		align = ui.TEXT_ALIGN_CENTER,
		dimensions = CCSizeMake(self.bg:getWidth() * 0.8, self.bg:getHeight() * 0.5);
	})
	
	self:addChild(self.text)
	
	self.menu = cocoExtend.newMenu({okbtn, cancelBtn}, TouchProity.Notice - 1)
	self:addChild(self.menu);
end

function Confirm:onSure()
	if self.onSureFunc then
		self.onSureFunc();
	end
	 self:dispose();
end

function Confirm:onCancel()
	if self.onCancelFunc then
		self.onCancelFunc();
	end
	 self:dispose();
end

function Confirm:show(tips, onSure, onCancel)
	self.onSureFunc = onSure;
	self.onCancelFunc = onCancel;
	
	self.text:setText(tips);
	DISPLAY_BASEVIEW.show(self, LayerManager.alertLayer, 1);
end

function Confirm:dispose()
	DISPLAY_BASEVIEW.dispose(self);
	AlertMgr:showNext();
end

return Confirm;