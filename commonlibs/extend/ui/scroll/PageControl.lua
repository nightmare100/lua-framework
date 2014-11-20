--页面控制 滚动到页面最大显示元素 不滚动到元素

local PageControl = class("PageControl", UI_ScrollView)
local socket = require("socket")
function PageControl:customSetting()
	self.dragThreshold = 20
    self.bouncThreshold = 20
    self.minSpeed = 300
end

function PageControl:onTouchEndedWithoutTap(x, y)
	local dur = socket:gettime() - self.startTime;
	local dir;
	local targetOffset, speed, time;
	
	local ox,oy
	
    transition.stopTarget(self.view)
	--dir: 1 left/down 2 right/up
	if self.direction == self.DIRECTION_HORIZONTAL then
		local maxX = 0;
		local minX = -self.view:getContentSize().width  + self.touchRect.size.width
	
		dir = self.startX - x > 0 and 1 or 2
		targetOffset = math.abs(self.startX - x)
		speed = targetOffset / dur
		local curOffset = (speed < self.minSpeed) and 0 or (speed - self.minSpeed) * self.defaultAnimateTime
		
		targetOffset = self.offsetX + (dir == 1 and -(speed) or speed);
		targetOffset = NumberUtil.max(minX, targetOffset)
		targetOffset = NumberUtil.min(maxX, targetOffset)
		if speed < self.minSpeed then
			if targetOffset == minX or targetOffset == maxX then
				self.view:setPosition(targetOffset, self.offsetY)
			end
			return;
		end
		
		time = curOffset / speed < self.defaultAnimateTime and self.defaultAnimateTime or (curOffset / speed)
		oy = self.offsetY;
	    transition.moveTo(self.view, {
	            x = targetOffset,
	            y = oy,
	            time = time,
	            easing = self.defaultAnimateEasing,
	        })
	    self.offsetX = targetOffset
	else
		local maxY = self.view:getContentSize().height  - self.touchRect.size.height  < 0 and 0 or (self.view:getContentSize().height  - self.touchRect.size.height)
        local minY = 0
        
		dir = self.startY - y > 0 and 1 or 2
		targetOffset = math.abs(self.startY - y)
		speed = targetOffset / dur;
		local curOffset = (speed < self.minSpeed) and 0 or (speed - self.minSpeed) * self.defaultAnimateTime
		
		targetOffset = self.offsetY + (dir == 1 and -curOffset or curOffset);
		targetOffset = NumberUtil.max(minY, targetOffset)
		targetOffset = NumberUtil.min(maxY, targetOffset)
		
		if speed < self.minSpeed then
			self.offsetY = targetOffset
			self.view:setPosition(self.offsetX, self.offsetY)
			return;
		end
		
		time = curOffset / speed < self.defaultAnimateTime and self.defaultAnimateTime or (curOffset / speed)
		ox = self.offsetX;
    	transition.moveTo(self.view, {
            x = ox,
            y = targetOffset,
            time = time,
            easing = self.defaultAnimateEasing,
        })
	    self.offsetY = targetOffset
	    
	end
    
end

function PageControl:onTouchBegan(x, y)
	self.startX = x;
	self.startY = y;
	self.startTime = socket:gettime();
	return UI_ScrollView.onTouchBegan(self, x, y)
end

--获取当前可能点击的CELL
function PageControl:getCurrentTappedCell(nx, ny)
	local offsetX, offsetY = self.offsetX, self.offsetY
    local index = 0
    local count = #self.cells
    if self.direction == self.DIRECTION_HORIZONTAL then
        local x = self.touchRect.origin.x
        local tapOffset = x - nx;
    	offsetX = x - offsetX - tapOffset
        local i = 1
        while i <= count do
            local cell = self.cells[i]
            local size = cell:getContentSize()
            if offsetX > x - size.width then
                index = i
                break
            end
            x = x + size.width + self:getMargin()
            i = i + 1
        end
        if index == 0 then
        	return nil
        end
        index = NumberUtil.max(1, index)
        index = NumberUtil.min(count, index)
        
        return self.cells[index]
    else 
       local y = self.touchRect.origin.y + self.touchRect.size.height
        local tapOffset = y - ny;
    	offsetY = y - offsetY - tapOffset
        local i = 1
        while i <= count do
            local cell = self.cells[i]
            local size = cell:getContentSize()
            if offsetY > y - size.height then
                index = i
                break
            end
            y = y - size.height - self:getMargin()
            i = i + 1
        end
        if index == 0 then
        	return nil
        end
        index = NumberUtil.max(1, index)
        index = NumberUtil.min(count, index)
        
        return self.cells[index]
    end
end

return PageControl