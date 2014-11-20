
local ScrollViewCell = class("ScrollViewCell", function(contentSize)
    local node = display.newNode()
    if contentSize then node:setContentSize(contentSize) end
    node:registerNodeEvent()
    eventDispatcher.extend(node)
    return node
end)

function ScrollViewCell:addCloseButton(proity)
	self.menus = {};
		self.closeBtn  = cocoExtend.newImageMenuItem({
			image = "#close_nor.png",
			imageSelected = "#close_dow.png",
		    listener = function()
		         self:onClose()
		    end
		})
		table.insert(self.menus, self.closeBtn);
		self:registerNodeEvent()
		local size = self.bg:getContentSize()
		self.closeBtn:setPosition(self.bg:getPositionX() + size.width / 2, self.bg:getPositionY() + size.height / 2);
	if self.menus and #self.menus > 0 then
		self.menu = cocoExtend.newMenu(self.menus, proity);
		self:addChild(self.menu, 10)
	end
end

function ScrollViewCell:onClose()
	CCLuaLog("------ScrollViewCell:onClose--")
end
function ScrollViewCell:onTouch(event, x, y)
end

function ScrollViewCell:onTap(x, y)
	self:dispatchEvent({name = "onTap", data = self.info})
end

function ScrollViewCell:onExit()
    self:removeAllEventListeners()
end

function ScrollViewCell:setScalePosition(x, y, scaleDis)
	self:setPosition(x + scaleDis, y)
	self.scaleDis = scaleDis
end

--图标放大
function ScrollViewCell:moveToReg(timetick, pos, callback)
	if self.scaleDis then
		transition.moveTo(self, {time = timetick, x = self:getPositionX() - self.scaleDis, y = pos, onComplete = callback})
		self.scaleDis = nil
	else
		transition.moveTo(self, {time = timetick, y = pos, onComplete = callback})
	end
	
end

function ScrollViewCell:setBigIconPosition(x, y)
	self:setPosition(x, y)
end

function ScrollViewCell:moveToDis(timetick,scale, pos, isLeft, margin)
	margin = margin and margin or 0
	local currentDis = isLeft and (self:getContentSize().width * (1 - scale) / 2 - margin) or (-self:getContentSize().width * (1 - scale) / 2 + margin)
	local movedDis;
	if not self.scaleDis then
		movedDis = currentDis
	else
		movedDis = -self.scaleDis + currentDis
	end
	transition.moveTo(self, {time = timetick, x = self:getPositionX() + movedDis,y = pos + scale * self:getContentSize().height  / 2})
	self.scaleDis = currentDis
end

--滑动接口
function ScrollViewCell:doSlide(dis)
	
end

--滑动接口
function ScrollViewCell:checkSlide()
	
end

return ScrollViewCell
