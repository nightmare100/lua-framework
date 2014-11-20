local ScrollViewPage = class("ScrollViewPage", UI_ScrollView)

function ScrollViewPage:customSetting()
	 self.scrollPrefect = 0.15
	 self.includeMargin = true
end

function ScrollViewPage:startLoop()
	self.sourceCellLen = #self.cells;	--原始原件长度
	self:adjustCell();
end

function ScrollViewPage:sortByPosition(cellA, cellB)
	if (cellA:getPositionX() >= cellB:getPositionX()) then
		return false
	else
		return true
	end
end

--isToLeft 是否加在左面
function ScrollViewPage:adjustCell()
	local item = self:getCurrentCell();
	local idx = 1;
	
	
	
	if self.currentIndex == 1 then
		self.cells[#self.cells]:setPositionX(0);
		for i = 1,#self.cells - 1 do
			self.cells[i]:setPositionX((item:getWidth() + self:getMargin()) * idx);
			idx = idx + 1;
		end
	elseif self.currentIndex == #self.cells then
		for i = 2,#self.cells do
			self.cells[i]:setPositionX((item:getWidth() + self:getMargin()) * (idx - 1));
			idx = idx + 1;
		end
		self.cells[1]:setPositionX(self:getCurrentCell():getPositionX() + item:getWidth() + self:getMargin());
	else
		for i = 1,#self.cells do
			self.cells[i]:setPositionX((item:getWidth() + self:getMargin()) * (idx - 1));
			idx = idx + 1;
		end
	end
	
	self.offsetX = 0 - self:getCurrentCell():getPositionX();
	
	self.view:setPositionX(self.offsetX);


--	local item = self.cells[cellID];
--	
--	local tmpCells = clone(self.cells);
--	table.sort(tmpCells, handler(self, self.sortByPosition));
--	
--	local idx = 1;
--	
--	if isToLeft then 
--		for i = 1,#tmpCells do
--			if tmpCells[i] ~= item then
--				tmpCells[i]:setPositionX((item:getWidth() + self:getMargin()) * (idx - 1));
--				idx = idx + 1;
--				if tmpCells[i] == self:getCurrentCell() then
--					tmpCells[i]:setPositionX((item:getWidth() + self:getMargin()) * (idx - 1));
--					idx = idx + 1;
--				end
--			end
--			if tmpCells[i].childIndex == self.currentIndex then
--				self.offsetX = 0 - tmpCells[i]:getPositionX();
--			end
--		end
--		item:setPositionX(self:getCurrentCell():getPositionX() - (item:getWidth() + self:getMargin()));
--	else
--		item:setPositionX(self:getCurrentCell():getPositionX() + item:getWidth() + self:getMargin());
--	end
--	
--	self.view:setPositionX(self.offsetX);
end

function ScrollViewPage:onTouchEndedWithoutTap(x, y)
	if self.sourceCellLen then
		local offsetX, offsetY = self.offsetX, self.offsetY
	    local index = 0
	    local count = #self.cells
	    local dir;
	    if self.direction == self.DIRECTION_HORIZONTAL then
	    	-- 1 left 2 right
	    	dir = self.drag.startX > x and 1 or 2;
	        offsetX = -offsetX
	        local x;
	        local i = 1
	        
	        local tmpCells = clone(self.cells);
			table.sort(tmpCells, handler(self, self.sortByPosition));
			
			
	        while i <= count do
	            local cell = tmpCells[i]
	        	x = tmpCells[i]:getPositionX();
	            local size = cell:getContentSize();
	            
	            
	            
	            
				if (dir == 1 and offsetX < x + size.width * self.scrollPrefect) or (dir == 2 and offsetX < x + size.width * (1 - self.scrollPrefect)) then
	                
	                index = cell.childIndex;
	                break
            	end
	            i = i + 1
	        end
	       
	        if index > count or index == 0 then index = count end
	    else
	    	-- 1down 2 up
	    	dir = self.drag.startY > y and 1 or 2;
	        local y;
	        local i = 1
	        while i <= count do
	            local cell = self.cells[i]
	        	y = self.cells[i]:getPositionY();
	            local size = cell:getContentSize()
	            if (dir == 1 and offsetY < y + size.height * self.scrollPrefect) or (dir == 2 and offsetY < y + size.height * (1 - self.scrollPrefect)) then
	                index = i
	                break
	            end
	            i = i + 1
	        end
	        if i > count then index = count end
	    end
		
	    self:scrollToCell(index, true)
	else
		UI_ScrollView.onTouchEndedWithoutTap(self, x, y);
	end
end

function ScrollViewPage:scrollToCell(index, animated, time, easing, isOutCall)
	if self.sourceCellLen then
		self.isScrolling = true;
		if self.useLoop and isOutCall then
			index = index - self.currentLoopTick * self.sourceCellLen;
		end
		
	    local count = #self.cells
	    if count < 1 then
	        self.currentIndex = 0
	        return
	    end
	
	    if index < 1 then
	        index = 1
	    elseif index > count then
	        index = count
	    end
	    self.currentIndex = index
	
	    local offset = 0
	    for i = 1, count do
	        local cell = self.cells[i]
	        if cell.childIndex == index then
	        	offset = 0 - cell:getPositionX();
	        	break;
	        end
	    end
	
	    self:setContentOffset(offset, animated, time, easing)
	    self:dispatchEvent({name = "scrollToCell", animated = animated, time = time, easing = easing})
	 else
	 	UI_ScrollView.scrollToCell(self, index, animated, time, easing, isOutCall);
	 end
end

function ScrollViewPage:onViewMovComplete()
	UI_ScrollView.onViewMovComplete(self);
	if self.sourceCellLen then
		self:adjustCell();
	end
end

function ScrollViewPage:reorderAllCells()
    local count = #self.cells
    local x = 0;
    local y = 0;
    local maxWidth, maxHeight = 0, 0
    for i = 1, count do
        local cell = self.cells[i]
        cell:setPosition(x, y)
        if self.direction == UI_ScrollView.DIRECTION_HORIZONTAL then
            local width = cell:getContentSize().width
            if width > maxWidth then maxWidth = width end
            x = x + width + self:getMargin()
        else
            local height = cell:getContentSize().height
            	
            if height > maxHeight then maxHeight = height end
            y = y - height - self:getMargin()
            
            if i == count then y = y + cell:getHeight() / 2 end
        end
    end

    if count > 0 then
        if self.currentIndex < 1 then
            self.currentIndex = 1
        elseif self.currentIndex > count then
            self.currentIndex = count
        end
    else
        self.currentIndex = 0
    end

    local size
    if self.direction == UI_ScrollView.DIRECTION_HORIZONTAL then
        size = CCSize(x , maxHeight)
    else
        size = CCSize(maxWidth, math.abs(y - (self.touchRect.origin.y + self.touchRect.size.height)))
    end
    self.view:setContentSize(size)
end

return ScrollViewPage