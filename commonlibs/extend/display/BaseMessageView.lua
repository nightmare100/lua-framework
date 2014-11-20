local BaseMessageView = class("BaseMessageView", DISPLAY_BASEVIEW)

function BaseMessageView:ctor(needCloseBtn,customImg,customImgSlt)
	--self.isSingleButNew	  保持单列 但是 每次都会 new 一个实例 当实例存在的情况下 不会再次创建
	self.menus = {};
	if needCloseBtn then
		self.closeBtn  = cocoExtend.newImageMenuItem({
			
			image = customImg and customImg or "#close_nor.png",
			imageSelected = customImgSlt and customImgSlt or "#close_dow.png",
			sound = SoundMgr.getSoundPath("SIMPLE_CLICK"),
	        listener = function()
	            self:onClose()
	        end
		})
		table.insert(self.menus, self.closeBtn);
	end
	
	self:registerNodeEvent()
end

function BaseMessageView:initView()
	if self.closeBtn then
		local size = self.bg:getContentSize()
		self.closeBtn:setPosition(self.bg:getPositionX() + size.width / 2, self.bg:getPositionY() + size.height / 2);
	end
	if self.menus and #self.menus > 0 then
		local popUpNum = LayerManager and LayerManager:getPopUpNum() or 0;
		popUpNum = popUpNum <= 0 and 1 or  popUpNum
		self.menu = cocoExtend.newMenu(self.menus, TouchProity.PopUp - popUpNum);
		self:addChild(self.menu, 10)
	end
end

function BaseMessageView:onClose()
	--clear instance
	if self.isSingleButNew and self.needCache then
		PopUpManager.clearPopUp(self);
	end
	
	self:kill();
	
end

function BaseMessageView:setData(value)
	self.data = value
end


function BaseMessageView:addEvent()
	if self.menu then
		self.menu:setTouchEnabled(true)
	end
end

function BaseMessageView:removeEvent()
	if self.menus then
		for i = 1, #self.menus do
			self.menus[i]:setTouchEnabled(false);
		end
	end
end

function BaseMessageView:autoShow()
	if not self:getParent() then
		local parentNode = (LayerManager and LayerManager.noticeLayer) and LayerManager.noticeLayer or display.getRunningScene()
		parentNode:addChild(self, 1)
		self:initView()
	end

	self:setVisible(true)
	self:addEvent();
end

function BaseMessageView:kill()
	if self.needCache then
		self:hide()
	else
		self:dispose()
	end
	PopUpManager.nextShow();
end

return BaseMessageView;