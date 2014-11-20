--单页滚动组件 可以和 任何NODE通用

local ScrollSinglePage = class("ScrollSinglePage", function(rect)
    if not rect then rect = CCRect(0, 0, 0, 0) end
    local node = display.newClippingRegionNode(rect)
    node:registerNodeEvent()
    eventDispatcher.extend(node)
    return node
end)

ScrollSinglePage.SCROLL_BAR_AUTO = "auto"
ScrollSinglePage.SCROLL_BAR_NONE = "none"
ScrollSinglePage.SCROLL_VER_ONLY = "ver"
ScrollSinglePage.SCROLL_HOR_ONLY = "hor"

--添加一个面板 node 节点容器 ， includeSpace 是否需要调整 node的偏移位置
function ScrollSinglePage:addView(node, includeSpace)
	self.subView = node;
	self.includeSpace = includeSpace;
	includeSpace = includeSpace ~= nil and includeSpace or false
	self:checkSourceRange(includeSpace);
	
	self.view:addChild(node);
	self.view:setPosition(self.maxX, self.minY);
	print(self.maxX, self.minY);
	
	if type(self.subView.addEventListener) == "function" then
		self.subView:addEventListener(ViewEvent.ON_VIEW_CHANGED, handler(self, self.onViewChange));
	end	
		
    self:initScrollBar();
end

--重置view位置 到初始位
function ScrollSinglePage:resetPosition()
	self.view:setPosition(self.maxX, self.minY);
end

--判断滚动最大点 和 最小点
function ScrollSinglePage:checkSourceRange()
	self.sourceRect = self.subView:getCascadeBoundingBox(false);
--	print("x,y" , self.sourceRect.origin.x, self.sourceRect.origin.y)
--	print("width,height" , self.sourceRect.size.width, self.sourceRect.size.height)
	
	self.sourceRect.origin.x = self.sourceRect.origin.x - self.subView:getPositionX()
	self.sourceRect.origin.y = self.sourceRect.origin.y - self.subView:getPositionY()
	
	if self.includeSpace then
		self.maxX = self.touchRect.origin.x 
		self.minY = self.touchRect.origin.y + self.touchRect.size.height;
		
		self.minX = self.maxX - ((self.sourceRect.size.width - self.touchRect.size.width) > 0 and (self.sourceRect.size.width - self.touchRect.size.width) or 0)
		self.maxY = self.minY + ((self.sourceRect.size.height - self.touchRect.size.height) > 0 and (self.sourceRect.size.height - self.touchRect.size.height) or 0)
	else
		self.maxX = self.touchRect.origin.x - self.sourceRect.origin.x
		self.minY = self.touchRect.origin.y + self.touchRect.size.height - (self.sourceRect.origin.y + self.sourceRect.size.height);
		
		self.minX = self.maxX - ((self.sourceRect.size.width - self.touchRect.size.width) > 0 and (self.sourceRect.size.width - self.touchRect.size.width) or 0)
		self.maxY = self.minY + ((self.sourceRect.size.height - self.touchRect.size.height) > 0 and (self.sourceRect.size.height - self.touchRect.size.height) or 0)
	end
	
end

--当内部 view 变更时 重新设置 滚动区域
function ScrollSinglePage:onViewChange(evt)
	transition.stopTarget(self.view);
	self.isScrolling = false;
	self:checkSourceRange();
	
	if self.horBar then
		self.horBar:updateBarSetting(self.touchRect.size.width / self.sourceRect.size.width * self.touchRect.size.width)
		self.horBar:update((self.maxX - self.view:getPositionX()) / (self.maxX - self.minX))
	end
	
	if self.verBar then
		self.verBar:updateBarSetting(self.touchRect.size.height / self.sourceRect.size.height * self.touchRect.size.height)
		self.verBar:update((self.view:getPositionY() - self.minY) / (self.maxY - self.minY))
	end
	self:showScrollBar(false);
end

--[[
	构造
	rect 显示区域 举行
	proity 触摸优先级
	disableclipping 是否要根据显示区域剪切
	barPolice 滚动条显示策略
	scrollProlice 滚动策略
	useBackgrond 是否使用背景
]]
function ScrollSinglePage:ctor(rect, proity, disableClipping, barPoilce, scrollProlice, useBackGround)
    self.barPolice = barPoilce and barPoilce or ScrollSinglePage.SCROLL_BAR_AUTO;
    self.scrollProlice = scrollProlice and scrollProlice or "both";
    self.supportSlide = false;	--是否支持惯性滑动
    local idx = table.indexOf({ScrollSinglePage.SCROLL_BAR_AUTO, ScrollSinglePage.SCROLL_BAR_NONE, ScrollSinglePage.SCROLL_VER_ONLY, ScrollSinglePage.SCROLL_HOR_ONLY}, self.barPolice)

    assert(idx ~= -1, "scrollPolice Error");

	if disableClipping then
		self:setClippingRegion(CCRect(0, 0, display.width, display.height))
	end

    self.dragThreshold = 60
    self.tapDistance = 40
    self.defaultAnimateTime = 0.4
    self.defaultAnimateEasing = "backOut"
    self.touchRect = rect

    self:registerScriptHandler(function(event)
        if event == "enter" then
            self:onEnter()
        elseif event == "exit" then
            self:onExit()
        end
    end)
    
    if useBackGround then
    	local bg = display.newRect(CCSizeMake(self.touchRect.size.width, self.touchRect.size.height))
    	bg:setFill(true)
		bg:setLineColor(ccc4f(255, 255, 255, 255))
		bg:setPosition(self.touchRect.origin.x + self.touchRect.size.width / 2,self.touchRect.origin.y + self.touchRect.size.height / 2)
    	self:addChild(bg);
    end

    -- create container layer
    self.view = display.newLayer()
    self:addChild(self.view)

	self.view:setTouchEnabled(true)
    self.view:addTouchEventListener(function(event, x, y)
        return self:onTouch(event, x, y)
    end, false, proity, true)
    
    
end

--初始化滚动条
function ScrollSinglePage:initScrollBar()
	if self.barPolice ~= ScrollSinglePage.SCROLL_BAR_NONE then
		if self.barPolice ~= ScrollSinglePage.SCROLL_VER_ONLY then
			self.horBar = require("commonlibs.extend.ui.scroll.Scrollbar").new(ScrollSinglePage.SCROLL_HOR_ONLY, self.touchRect.size.width / self.sourceRect.size.width * self.touchRect.size.width, self.touchRect)
			self:addChild(self.horBar);
		end
		
		if self.barPolice ~= ScrollSinglePage.SCROLL_HOR_ONLY then
			self.verBar = require("commonlibs.extend.ui.scroll.Scrollbar").new(ScrollSinglePage.SCROLL_VER_ONLY, self.touchRect.size.height / self.sourceRect.size.height * self.touchRect.size.height, self.touchRect)
			self:addChild(self.verBar);
		end
	end
end

function ScrollSinglePage:setEnabled(value)
	self.view:setTouchEnabled(value)
end


function ScrollSinglePage:onTap(evt)
	evt.name =  "onCellTap";
	self:dispatchEvent(evt)
end

function ScrollSinglePage:getView()
    return self.view
end

function ScrollSinglePage:getTouchRect()
	local rect = CCRectMake(self.touchRect.origin.x, self.touchRect.origin.y, self.touchRect.size.width, self.touchRect.size.height)
	
    return self:getRealRect(rect, self)
end

--递归取 矩形区域
function ScrollSinglePage:getRealRect(rect, target)
	local parent = target:getParent()
	if parent then
		rect.origin.x = rect.origin.x + parent:getPositionX()
		rect.origin.y = rect.origin.y + parent:getPositionY()
		return self:getRealRect(rect, parent)
	else
		return rect
	end
end

function ScrollSinglePage:setTouchRect(rect)
    self.touchRect = rect
    self:dispatchEvent({name = "setTouchRect", rect = rect})
end

function ScrollSinglePage:getClippingRect()
    return self:getClippingRegion()
end

function ScrollSinglePage:setClippingRect(rect)
    self:setClippingRegion(rect)
    self:dispatchEvent({name = "setClippingRect", rect = rect})
end


function ScrollSinglePage:isTouchEnabled()
    return self.view:isTouchEnabled()
end

function ScrollSinglePage:setTouchEnabled(enabled)
    self.view:setTouchEnabled(enabled)
    self:dispatchEvent({name = "setTouchEnabled", enabled = enabled})
end

function ScrollSinglePage:showScrollBar(hor, ver)
	if self.verBar then
		self.verBar:setVisible(ver)
	end
	
	if self.horBar then
		self.horBar:setVisible(hor)
	end
end

function ScrollSinglePage:updateScrollBar(hor, ver)
	if self.verBar and ver ~= -1 then
		self.verBar:update(ver)
	end
	
	if self.horBar and hor ~= -1 then
		self.horBar:update(hor)
	end
end

---- events

function ScrollSinglePage:onTouchBegan(x, y)
    self.drag = {
        startX = x,
        startY = y,
    }
 	
    self:dispatchEvent({name = "onTouchBegan"})

    self:showScrollBar(self:needHorScrollBar(), self:needVerScrollBar())

    return true
end

function ScrollSinglePage:onTouchMoved(x, y)
    if not self.drag then
    	return
    end 
    
    local lastX,lastY;
    lastX = self.drag.lastX and self.drag.lastX or self.drag.startX
    lastY = self.drag.lastY and self.drag.lastY or self.drag.startY

	if self.drag.lastY then
   		self.drag.disY = y - self.drag.lastY;
   		self.drag.disX = x - self.drag.lastX;
   	end
   	
    self.drag.lastX = x;
   	self.drag.lastY = y;
   	
    	
    self:setContentOffset(x - lastX, y - lastY)
end

function ScrollSinglePage:onTouchEnded(x, y)

	if not self.drag then
		return
	end
	
	local ox,oy;
	if self.view:getPositionX() < self.minX then
		ox = self.minX;
	elseif self.view:getPositionX() > self.maxX then
		ox = self.maxX;
	end
	
	if self.view:getPositionY() < self.minY then
		oy = self.minY;
	elseif self.view:getPositionY() > self.maxY then
		oy = self.maxY;
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
		self.isScrolling = true;
		transition.moveTo(self.view, args)
		
		self:checkEvent(ox, oy)
	else
    	local isTap = self:checkTap(x, y);
    	
    	if isTap or not self.supportSlide then
    		self:showScrollBar(false)
    		self.subView:onTap(x, y);
    	else
    		self:checkSlide();
    	end
	end

    self.drag = nil
end



--检查 是否 这次滚动需要弹性
function ScrollSinglePage:checkSlide()
	local slideMinSpeed = 15;
	if self.drag.disX then
		if (self.scrollProlice =="ver" or self.scrollProlice == "both") and math.abs(self.drag.disY) > slideMinSpeed then
			self:beginSlide(self.drag.disY, "ver");
			return;
		elseif (self.scrollProlice =="hor" or self.scrollProlice == "both") and math.abs(self.drag.disX) > slideMinSpeed then
			self:beginSlide(self.drag.disX, "hor");
			return;
		end
		
	end

	self:showScrollBar(false)
end

--弹性动画
function ScrollSinglePage:beginSlide(spd, dir)
	local dis = spd * 25; --惯性距离
	local endDis;
	local args = {}
	if dir == "ver" then
		endDis = NumberUtil.max(self.view:getPositionY() + dis, self.minY)
		endDis = NumberUtil.min(endDis, self.maxY);
		args.y = endDis;
	else
		endDis = NumberUtil.max(self.view:getPositionX() + dis, self.minX)
		endDis = NumberUtil.min(endDis, self.maxX);
		args.x = endDis;
	end
	
	args.time = 0.5;
	args.easing = "SINEOUT";
	args.onComplete = handler(self, self.onViewMovComplete);
	
	
	self.isScrolling = true;
	transition.moveTo(self.view, args)
	Tick.getInstance():addInterval(handler(self, self.updateScroll), 0, self:getTickID());
end

function ScrollSinglePage:checkTap(x, y)
	if math.abs(x - self.drag.startX) < self.tapDistance and math.abs(y - self.drag.startY) < self.tapDistance then
		return true
	end
	
	return false;
end 

--检查和事件
function ScrollSinglePage:checkEvent(ox, oy)
	if ox then
		if ox == self.maxX then
			self:dispatchEvent({name = ViewEvent.ON_VIEW_SCROLL_END, direction = display.LEFT_TO_RIGHT})
		else
			self:dispatchEvent({name = ViewEvent.ON_VIEW_SCROLL_END, direction = display.RIGHT_TO_LEFT})
		end
	elseif oy then
		if oy == self.minY then
			self:dispatchEvent({name = ViewEvent.ON_VIEW_SCROLL_END, direction = display.BOTTOM_TO_TOP})
		else
			self:dispatchEvent({name = ViewEvent.ON_VIEW_SCROLL_END, direction = display.TOP_TO_BOTTOM})
		end
	end	
end

function ScrollSinglePage:needHorScrollBar()
	return self.maxX > self.minX
end


function ScrollSinglePage:needVerScrollBar()
	return self.maxY > self.minY
end

function ScrollSinglePage:onTouchCancelled(x, y)
    self.drag = nil
end

--上下左右 移动一段距离 0, 1, 2, 3
function ScrollSinglePage:turnDirection(dir)
	if self.subView.cellSize and not self.isScrolling then
		local movedSize;
		local ox, oy;
		if dir == 0 or dir == 1 then
			movedSize = dir == 0 and self.subView.cellSize or (0 - self.subView.cellSize);
			oy = self.view:getPositionY() + movedSize;
			oy = NumberUtil.max(self.minY, oy);
			oy = NumberUtil.min(self.maxy, oy);
		else
			movedSize = dir == 3 and self.subView.cellSize or (0 - self.subView.cellSize);
			ox = self.view:getPositionX() + movedSize;
			ox = NumberUtil.max(self.minX, ox);
			ox = NumberUtil.min(self.maxX, ox);
		end
		
		local args = {};
		if ox then
			args.x = ox;
		end
		
		if oy then
			args.y = oy;
		end
		args.time = 0.5;
		args.easing = "SINEOUT";
		args.onComplete = handler(self, self.onViewMovComplete);
		self.isScrolling = true
		transition.moveTo(self.view, args)
	end
end

function ScrollSinglePage:onTouch(event, x, y)
    if event == "began" then
        if not self:getTouchRect():containsPoint(ccp(x, y)) or self.isScrolling then return false end

        return self:onTouchBegan(x, y)
    elseif event == "moved" then
        self:onTouchMoved(x, y)
    elseif event == "ended" then
        self:onTouchEnded(x, y)
    else -- cancelled
        self:onTouchCancelled(x, y)
    end
end

--设置滚动区域
function ScrollSinglePage:setContentOffset(x, y)

	if self.view:getPositionX() + x > self.maxX + self.dragThreshold  then
		x = self.maxX + self.dragThreshold
	elseif self.view:getPositionX() + x < self.minX - self.dragThreshold then
		x = self.minX - self.dragThreshold
	else
		x = self.view:getPositionX() + x;
	end

	if self.view:getPositionY() + y > self.maxY + self.dragThreshold  then
		y = self.maxY + self.dragThreshold
	elseif self.view:getPositionY() + y < self.minY - self.dragThreshold then
		y = self.minY - self.dragThreshold
	else
		y = self.view:getPositionY() + y
	end

	if self.scrollProlice == "both" then
    	self.view:setPosition(x, y);
    elseif self.scrollProlice == "hor" then
    	self.view:setPositionX(x);
    elseif  self.scrollProlice == "ver" then
    	self.view:setPositionY(y);
    end
    
	local progressHor = (self.maxX - x) / (self.maxX - self.minX)
	local progressVer = (y - self.minY) / (self.maxY - self.minY)

    self:updateScrollBar(self:needHorScrollBar() and progressHor or -1, self:needVerScrollBar() and progressVer or -1);
end

--更新滚动
function ScrollSinglePage:updateScroll()
	local progressHor = (self.maxX - self.view:getPositionX()) / (self.maxX - self.minX)
	local progressVer = (self.view:getPositionY() - self.minY) / (self.maxY - self.minY)
	
    self:updateScrollBar(self:needHorScrollBar() and progressHor or -1, self:needVerScrollBar() and progressVer or -1);
end

--当界面滚动完时调用
function ScrollSinglePage:onViewMovComplete()
	self.isScrolling = false;
	self:showScrollBar(false)
	
	Tick.getInstance():kill(self:getTickID());
end

--销毁
function ScrollSinglePage:onExit()
    self:removeAllEventListeners()
	Tick.getInstance():kill(self:getTickID());
end


return ScrollSinglePage
