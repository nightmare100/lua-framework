
--滚动界面组件 基类
local ScrollView = class("ScrollView", function(rect)
    if not rect then rect = CCRect(0, 0, 0, 0) end
    local node = display.newClippingRegionNode(rect)
    node:registerNodeEvent()
    eventDispatcher.extend(node)
    return node
end)

ScrollView.DIRECTION_VERTICAL   = 1
ScrollView.DIRECTION_HORIZONTAL = 2

local beganCell;

function ScrollView:ctor(rect, direction, onePageShow, cellMargin, proity, disableClipping, banMutipTouch)
    assert(direction == ScrollView.DIRECTION_VERTICAL or direction == ScrollView.DIRECTION_HORIZONTAL,
           "ScrollView:ctor() - invalid direction")
           
    self.banMutipTouch = banMutipTouch ~= nil and banMutipTouch or false;

	if disableClipping then
		self:setClippingRegion(CCRect(0, 0, display.width, display.height))
	end

    self.dragThreshold = 40
    self.bouncThreshold = 140
    self.defaultAnimateTime = 0.4
    self.defaultAnimateEasing = "backOut"
    self.onePageShow = onePageShow

    self.direction = direction
    self.touchRect = rect
    self.useFixedTap = false;		--是否使用 精确点击 对于 scrollpage类型的滚动 请设为true
    self.offsetX = 0
    self.offsetY = 0
    self.cells = {}
    self.currentIndex = 0
    self.cellMargin = cellMargin and cellMargin or 0
    self.scrollPrefect = 0.5
    self.includeMargin = false

    self:registerScriptHandler(function(event)
        if event == "enter" then
            self:onEnter()
        elseif event == "exit" then
            self:onExit()
        end
    end)

    -- create container layer
    self.view = display.newLayer()
    self:addChild(self.view)

	self.view:setTouchEnabled(true)
    self.view:addTouchEventListener(function(event, x, y)
        return self:onTouch(event, x, y)
    end, false, proity, true)
    
    self:customSetting();
end

--使用循环显示 2013.11.1新增 循环显示功能
--该方法在 所有元素 addCell完成后调用 
function ScrollView:startLoop()
	self.useLoop = true;
	self.currentLoopTick = 0;		--循环标记  往右正 往左负
	self.sourceCellLen = #self.cells;	--原始原件长度
end


--是否支持子元件反向滚动 操作
function ScrollView:setCellMovingEnabled(val)
	self.enabledCellMoving = val;
end

--添加循环元素
function ScrollView:addLoopCell(isLeft)
	
	local newtb = {};
	for i = 1, self.sourceCellLen do
		local newCell = self.cells[i]:cloneSelf();
		table.insert(newtb, newCell);
		self.view:addChild(newCell)
   		newCell:addEventListener("onTap", function(event) return self:onTap(event) end)
	end
	self.cells = isLeft and table.link(newtb, self.cells) or table.link(self.cells, newtb);
end

function ScrollView:setEnabled(value)
	self.view:setTouchEnabled(value)
end

function ScrollView:customSetting()
	
end

function ScrollView:getAllCell()
	return self.cells;
end

function ScrollView:getCurrentCell()
    if self.currentIndex > 0 then
        return self.cells[self.currentIndex]
    else
        return nil
    end
end

function ScrollView:getCellCount()
	return #self.cells
end

function ScrollView:getCurrentIndex()
	if self.useLoop then
    	return self.currentIndex + self.sourceCellLen * self.currentLoopTick;
    else
    	return self.currentIndex
    end
end

function ScrollView:setCurrentIndex(index)
	if self.useLoop then
		index = index - self.currentLoopTick * self.sourceCellLen;
	end
    self:scrollToCell(index)
end

function ScrollView:addCell(cell)
    self.view:addChild(cell)
    cell:addEventListener("onTap", function(event) return self:onTap(event) end)
    self.cells[#self.cells + 1] = cell
    cell.childIndex = #self.cells;
    self:reorderAllCells()
    self:dispatchEvent({name = "addCell", count = #self.cells})
end

function ScrollView:insertCellAtIndex(cell, index)
    self.view:addChild(cell)
    cell:addEventListener("onTap", function(event) return self:onTap(event) end)
    table.insert(self.cells, index, cell)
    self:reorderAllCells()
    self:dispatchEvent({name = "insertCellAtIndex", index = index, count = #self.cells})
end

function ScrollView:onTap(evt)
	evt.name =  "onCellTap";
	self:dispatchEvent(evt)
end

function ScrollView:removeCellAtIndex(index)
    local cell = self.cells[index]
    cell:removeSelf()
    table.remove(self.cells, index)
    self:reorderAllCells()
    self:dispatchEvent({name = "removeCellAtIndex", index = index, count = #self.cells})
end

function ScrollView:removeCell(item)
	local index;
	for i = 1, #self.cells do
		if self.cells[i] == item then
			index = i;
			self.cells[i]:removeSelf(true)
    		table.remove(self.cells, index);
			break;
		end
	end
    
    
    self:reorderAllCells()
    self:dispatchEvent({name = "removeCellAtIndex", index = index, count = #self.cells})
end

--干所有
function ScrollView:removeAll()
	for k,v in pairs(self.cells) do
		v:removeSelf(true)
	end
	self.offsetX = 0
    self.offsetY = 0
    self.cells = {}
    self.currentIndex = 0
    self.view:setPosition(0, 0)
end

function ScrollView:getView()
    return self.view
end

function ScrollView:getTouchRect()
	local rect = CCRectMake(self.touchRect.origin.x, self.touchRect.origin.y, self.touchRect.size.width, self.touchRect.size.height)
	
    return self:getRealRect(rect, self)
end

--递归取 矩形区域
function ScrollView:getRealRect(rect, target)
	local parent = target:getParent()
	if parent then
		rect.origin.x = rect.origin.x + parent:getPositionX()
		rect.origin.y = rect.origin.y + parent:getPositionY()
		return self:getRealRect(rect, parent)
	else
		return rect
	end
end

function ScrollView:setTouchRect(rect)
    self.touchRect = rect
    self:dispatchEvent({name = "setTouchRect", rect = rect})
end

function ScrollView:getClippingRect()
    return self:getClippingRegion()
end

function ScrollView:setClippingRect(rect)
    self:setClippingRegion(rect)
    self:dispatchEvent({name = "setClippingRect", rect = rect})
end

--isOutCall 是否为外部调用
function ScrollView:scrollToCell(index, animated, time, easing, isOutCall)
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
    for i = 2, index do
        local cell = self.cells[i - 1]
        local size = cell:getContentSize()
        if self.direction == ScrollView.DIRECTION_HORIZONTAL then
            offset = offset - size.width - (self.includeMargin and self:getMargin() or 0)
        else
            offset = offset + size.height + (self.includeMargin and self:getMargin() or 0)
        end
    end

    self:setContentOffset(offset, animated, time, easing)
    self:dispatchEvent({name = "scrollToCell", animated = animated, time = time, easing = easing})
end

function ScrollView:isTouchEnabled()
    return self.view:isTouchEnabled()
end

function ScrollView:setTouchEnabled(enabled)
    self.view:setTouchEnabled(enabled)
    self:dispatchEvent({name = "setTouchEnabled", enabled = enabled})
end

---- events

function ScrollView:onTouchBegan(x, y)
    self.drag = {
        currentOffsetX = self.offsetX,
        currentOffsetY = self.offsetY,
        startX = x,
        startY = y,
        isTap = true,
    }

    beganCell = self:getCurrentTappedCell(x, y)
    if beganCell then
    	beganCell:onTouch("began", x, y)
    end
    self:dispatchEvent({name = "onTouchBegan"})

    return true
end

function ScrollView:getCurrentTappedCell(x, y)
	return self:getCurrentCell();
end

function ScrollView:onTouchMoved(x, y)
    local cell = self:getCurrentTappedCell(self.drag.startX, self.drag.startY)
    if not self.drag then
    	return
    end 
    
    if self.direction == ScrollView.DIRECTION_HORIZONTAL then
        if self.drag.isTap and math.abs(x - self.drag.startX) >= self.dragThreshold then
            self.drag.isTap = false
            if cell then
            	cell:onTouch("cancelled", x, y)
            end
            
            if beganCell and beganCell ~= cell then
            	beganCell:onTouch("cancelled", x, y)
            end
        end
        
        
        
        
        if math.abs(self.drag.startY - y) > math.abs(self.drag.startX - x) and not self.drag.isScMoving and self.enabledCellMoving then
        	self.drag.isCellMoving = true
        	if cell then
        		cell:doSlide(self.drag.startY - y);
        	end	
        	
        	return;
        end

        if not self.drag.isTap and not self.drag.isCellMoving then
        	self.drag.isScMoving = true
            self:setContentOffset(x - self.drag.startX + self.drag.currentOffsetX)
        end
    else
        if self.drag.isTap and math.abs(y - self.drag.startY) >= self.dragThreshold then
            self.drag.isTap = false
            if cell then
            	cell:onTouch("cancelled", x, y)
            end
            
            if beganCell and beganCell ~= cell then
            	beganCell:onTouch("cancelled", x, y)
            end
        end
        
        
        if math.abs(self.drag.startX - x) > math.abs(self.drag.startY - y) and self.enabledCellMoving and not self.drag.isScMoving or self.drag.isCellMoving then
        	self.drag.isCellMoving = true
        	if cell then
        		cell:doSlide(self.drag.startX - x);
        	end
        	return;
        end

        if not self.drag.isTap and not self.drag.isCellMoving then
        	self.drag.isScMoving = true
            self:setContentOffset(y - self.drag.startY + self.drag.currentOffsetY)
        end
    end
end

function ScrollView:onTouchEnded(x, y)

	if not self.drag then
		return
	end

	if self.drag.isCellMoving then
		 local cell = self:getCurrentTappedCell(self.drag.startX, self.drag.startY);
		 if cell then
			cell:checkSlide();
		 end
    elseif self.drag.isTap then
        self:onTouchEndedWithTap(x, y)
    else
        self:onTouchEndedWithoutTap(x, y)
    end
    self.drag = nil
end

function ScrollView:onTouchEndedWithTap(x, y)
    local cell = self:getCurrentTappedCell(x, y)
    if cell then
	   cell:onTouch("ended", x, y)
	   cell:onTap(x, y)
	end
end


function ScrollView:onTouchEndedWithoutTap(x, y)
    local offsetX, offsetY = self.offsetX, self.offsetY
    local index = 0
    local count = #self.cells
    local dir;
    if self.direction == self.DIRECTION_HORIZONTAL then
    	-- 1 left 2 right
    	dir = self.drag.startX > x and 1 or 2;
        offsetX = -offsetX
        local x = 0
        local i = 1
        while i <= count do
            local cell = self.cells[i]
            local size = cell:getContentSize()
            if (dir == 1 and offsetX < x + size.width * self.scrollPrefect) or (dir == 2 and offsetX < x + size.width * (1 - self.scrollPrefect)) then
                index = i
                break
            end
            x = x + size.width
            i = i + 1
        end
       
        if index > count or index == 0 then index = count end
    else
    	-- 1down 2 up
    	dir = self.drag.startY > y and 1 or 2;
        local y = 0
        local i = 1
        while i <= count do
            local cell = self.cells[i]
            local size = cell:getContentSize()
            if (dir == 1 and offsetY < y + size.height * self.scrollPrefect) or (dir == 2 and offsetY < y + size.height * (1 - self.scrollPrefect)) then
                index = i
                break
            end
            y = y + size.height
            i = i + 1
        end
        if i > count then index = count end
    end

    self:scrollToCell(index, true)
end

function ScrollView:onTouchCancelled(x, y)
    self.drag = nil
end

function ScrollView:onTouch(event, x, y)
    if self.currentIndex < 1 then return end

    if event == "began" then
        if not self:getTouchRect():containsPoint(ccp(x, y)) then return false end
        if self.isScrolling and self.banMutipTouch then
        	return false;
        end
        return self:onTouchBegan(x, y)
    elseif event == "moved" then
        self:onTouchMoved(x, y)
    elseif event == "ended" then
        self:onTouchEnded(x, y)
    else -- cancelled
        self:onTouchCancelled(x, y)
    end
end



function ScrollView:reorderAllCells()
    local count = #self.cells
    local x = self.touchRect.origin.x + self.touchRect.size.width / 2;
    local y = self.touchRect.origin.y + self.touchRect.size.height
    local maxWidth, maxHeight = 0, 0
    for i = 1, count do
        local cell = self.cells[i]
        cell:setPosition(x, y - cell:getHeight() / 2)
        if self.direction == ScrollView.DIRECTION_HORIZONTAL then
            local width = cell:getContentSize().width
            if cell:getHeight() > maxHeight then maxHeight = cell:getHeight() end
            x = x + width + self:getMargin()
        else
            local height = cell:getContentSize().height
            	
            if cell:getWidth() > maxWidth then maxWidth = cell:getWidth() end
            y = y - height - self:getMargin()
            
            if i == count then y = y + self:getMargin() end
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
    if self.direction == ScrollView.DIRECTION_HORIZONTAL then
        size = CCSize(x - (self.touchRect.origin.x + self.touchRect.size.width / 2), maxHeight)
    else
        size = CCSize(maxWidth, math.abs(y - (self.touchRect.origin.y + self.touchRect.size.height)))
    end
    self.view:setContentSize(size)
end

function ScrollView:getMargin()
	return self.cellMargin / CCDirector:sharedDirector():getContentScaleFactor()
end

function ScrollView:setContentOffset(offset, animated, time, easing)
    local ox, oy = self.offsetX, self.offsetY
    local x, y = ox, oy
    if self.direction == ScrollView.DIRECTION_HORIZONTAL then
    	self.offsetX = offset
        x = offset

        local maxX = self.bouncThreshold
        local minX = (-self.view:getContentSize().width + self.touchRect.size.width > 0 and 0 or (-self.view:getContentSize().width + self.touchRect.size.width)) - self.bouncThreshold
        if x > maxX then
            x = maxX
        elseif x < minX then
            x = minX
        end
        
        if self.useFixedTap then
        	self.offsetX = x + self:getCurrentCell():getWidth() / 2;
        end
    else
    	self.offsetY = offset
        y = offset

        local maxY = (self.view:getContentSize().height - self.touchRect.size.height < 0 and 0 or (self.view:getContentSize().height - self.touchRect.size.height)) + self.bouncThreshold 
        local minY = -self.bouncThreshold
        if y > maxY then
            y = maxY
        elseif y < minY then
            y = minY
        end
        
        if self.useFixedTap then
        	self.offsetY = y + self:getCurrentCell():getHeight() / 2;
        end
    end
    

    if animated then
        transition.stopTarget(self.view)
        transition.moveTo(self.view, {
            x = x,
            y = y,
            time = time or self.defaultAnimateTime,
            easing = easing or self.defaultAnimateEasing,
            onComplete = handler(self, self.onViewMovComplete)
        })
    else
        self.view:setPosition(x, y)
		self.isScrolling = false;
    end
end

function ScrollView:onViewMovComplete()
	self.isScrolling = false;
end

function ScrollView:onComplete()
	
end

function ScrollView:onExit()
    self:removeAllEventListeners()
end

function ScrollView:onMoveComplete(oldIdx)
	if self.useLoop then
		local oldarea = math.floor( (oldIdx - 1) / self.sourceCellLen );
		local cuarea = math.floor((self.currentIndex - 1) / self.sourceCellLen);
		if oldarea < cuarea then
			self:removeLoopCell(true);
			self:addLoopCell(false);
			self.currentIndex = self.currentIndex - self.sourceCellLen;
			self:reorderAllCells();
		elseif oldarea > cuarea then
			self:removeLoopCell(false);
			self:addLoopCell(true);
			self.currentIndex = self.currentIndex + self.sourceCellLen;
			self:reorderAllCells();
		end
	end
	
	
    self:dispatchEvent({name = "scrollToCell"})
end

function ScrollView:removeLoopCell(isBegin)
	for i = 1, self.sourceCellLen do
		if isBegin then
			self.cells[1]:removeSelf();
			table.remove(self.cells, 1)
		else
			self.cells[#self.cells]:removeSelf();
			table.remove(self.cells, #self.cells)
		end
	end
end

return ScrollView
