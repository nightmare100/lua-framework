-- progressbar

local progressBar = class("progressBar", function(node, progress)
	local clipNode = display.newClippingRegionNode(CCRectMake(node:getPositionX() - node:getContentSize().width / 2, node:getPositionY() - node:getContentSize().height / 2, node:getContentSize().width, node:getContentSize().height))
	clipNode.progress = progress
	clipNode.width = node:getContentSize().width
	clipNode.height = node:getContentSize().height
	clipNode:addChild(node);
	return clipNode;
end)

function progressBar:update(progress)
	self.progress = progress < 0 and 0 or progress;
	local rect = self:getClippingRegion();
	rect.size.width = self.progress * self.width
	self:setClippingRegion(rect);
end

function progressBar:getContentSize()
	return CCSizeMake(self.width, self.height)
end

return progressBar;