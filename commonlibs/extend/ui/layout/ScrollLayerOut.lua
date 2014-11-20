--全局滚动 特征扩展 针对非layer容器的滚动 扩展 
--方便灵活 的用于 多层滚动

ScrollLayerOut = {};


function ScrollLayerOut.extend(layout, proity, size, needScrollBar)
	layout.dragThreshold = 60
	layout.scrollSize = size;
	layout.sourceX = layout:getPositionX();
	layout.sourceY = layout:getPositionY();
	local layerOutSize = layout.dir == "hor" and layout:getWidth(true) or layout:getHeight(true)
	if needScrollBar and size < layerOutSize then
		local layerOutRect = layout:getCascadeBoundingBox(false);
		if layout.dir == "hor" then
			layerOutRect.size.width = size;
		else
			layerOutRect.size.height = size;
		end
		layout.scrollbar = require("commonlibs.extend.ui.scroll.Scrollbar").new(layout.dir, size / layerOutSize * size, layerOutRect, nil, true)
		layout:getParent():addChild(layout.scrollbar);
	end
	function layout:onTouch(event, x, y)
		--转换点坐标 为 元件左下角
		local rect = self:getCascadeBoundingBox()
		if event == "began" and rect:containsPoint(ccp(x, y)) then
			self.drag = {
				startX = x,
				startY = y,
			}
			return true;
		elseif event == "moved" then
			local dis;
			local finalPos;
			local prefect;
			if self.dir == "ver" then
				dis = y - (self.drag.lastY and self.drag.lastY or self.drag.startY);
				finalPos = self:getPositionY() + dis;
				finalPos = NumberUtil.max(self.sourceY - self.dragThreshold, finalPos);
				finalPos = NumberUtil.min(self.sourceY + NumberUtil.max((rect.size.height - self.scrollSize), 0) + self.dragThreshold , finalPos);
				self:setPositionY( finalPos)
				prefect = (finalPos - self.sourceY) / (rect.size.height - self.scrollSize)
			else
				dis = x - (self.drag.lastX and self.drag.lastX or self.drag.startX);
				finalPos = self:getPositionX() + dis;
				finalPos = NumberUtil.min(self.sourceX + self.dragThreshold, finalPos);
				finalPos = NumberUtil.max(self.sourceX - NumberUtil.max((rect.size.width - self.scrollSize), 0) - self.dragThreshold, finalPos);
				self:setPositionX(finalPos)
				prefect = (self.sourceX - finalPos) / (rect.size.width - self.scrollSize)
			end
			self.drag.lastY = y;
			self.drag.lastX = x;
			
			if self.scrollbar then
				print(prefect)
				self.scrollbar:update(prefect)
			end
		elseif event == "ended" then
			self:onDragEnd();
			self.drag = nil;
			if self.scrollbar then
				self.scrollbar:setVisible(false);
			end
		end
		return false;
	end

	function layout:onDragEnd()
		local rect = self:getCascadeBoundingBox();
		local ox, oy;
		if self.dir == "ver" then
			if self:getPositionY() < self.sourceY then
				oy = self.sourceY;
			elseif self:getPositionY() > self.sourceY + (rect.size.height - self.scrollSize) then
				oy = self.sourceY + NumberUtil.max((rect.size.height - self.scrollSize), 0);
			end
		else
			if self:getPositionX() > self.sourceX then
				ox = self.sourceX;
			elseif self:getPositionX() < self.sourceX - (rect.size.width - self.scrollSize) then
				ox = self.sourceX - NumberUtil.max((rect.size.width - self.scrollSize), 0);
			end
		end
	
		if ox or oy then
			local args = {
				time = 0.25,
				easing = "SINEOUT",
			}
			if ox then
				args.x = ox; 
			end
			
			if oy then
				args.y = oy;
			end
			
			args.onComplete = handler(self, self.onViewMovComplete);
			transition.moveTo(self, args)
		end
		
	end
	
	function layout:onViewMovComplete()
		--self.isScrolling = false;
		--self:showScrollBar(false)
	end

	layout:addTouchEventListener(function(event, x, y)
        return layout:onTouch(event, x, y)
    end, false, proity, true)
    layout:setTouchEnabled(true)

end