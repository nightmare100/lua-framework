--滚动条

local scrollBar = class("ScrollBar", function()
	return display.newNode();
end)

function scrollBar:ctor(type, size, rect, minSize, isOutSide)
	self.minSize = minSize and minSize or 50
	self.parentRect = rect
	self.type = type;
	self.maxRange = type == "ver" and rect.size.height or rect.size.width;
	self.view = display.newScale9Sprite("#scrollbar.png");
	self.view:align(display.LEFT_TOP)
	if self.type == "ver" then
		self.sourceHeight = self.view:getHeight();
		self.view:setScaleY(size / self.sourceHeight)
		self:setPosition(isOutSide and (rect.origin.x + rect.size.width + self.view:getWidth()) or (rect.origin.x + rect.size.width - self.view:getWidth()), rect.origin.y + rect.size.height);
		self.range = {rect.origin.y + rect.size.height, rect.origin.y + size}
	else
		self.sourceWidth = self.view:getHeight();
		self.view:setRotation(-90);
		self.view:setScaleY(size / self.sourceWidth);
		self:setPosition(rect.origin.x, isOutSide and (rect.origin.y - self.view:getWidth()) or (rect.origin.y + self.view:getWidth()));
		self.range = {rect.origin.x, rect.origin.x + rect.size.width - size}
	end
	
	self:addChild(self.view);
	self:setVisible(false);
end

function scrollBar:updateBarSetting(size)
	size = size < self.minSize and self.minSize or size
	if self.type == "ver" then
		self.view:setScaleY(size / self.sourceHeight)
		self.range = {self.parentRect.origin.y + self.parentRect.size.height, self.parentRect.origin.y + size}
	else
		self.view:setScaleX(size / self.sourceWidth);
		self.range = {self.parentRect.origin.x, self.parentRect.origin.x + self.parentRect.size.width - size}
	end
end

function scrollBar:update(progress)
	progress = NumberUtil.min(1, progress)
	progress = NumberUtil.max(0, progress)
	
	if self.type == "ver" then
		local dis = (self.range[1] - self.range[2]) * progress;
		self:setPositionY(self.range[1] - dis);
	else
		local dis = (self.range[2] - self.range[1]) * progress;
		self:setPositionX(self.range[1] + dis);
	end
	self:setVisible(true);
end

return scrollBar;