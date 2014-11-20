--列表布局界面


local ListView = class("ListView", function()
	return display.newNode();
end)

ListView.DIR_VER = "ver"
ListView.DIR_HOR = "hor"

--[[构造 dir 列表方向 横纵
	margin 元素之间的间距
]]
function ListView:ctor(dir, margin, marginFrame)
	self.dir = dir;
	self.margin = margin;
	self.marginFrame = marginFrame;
	
	self.cells = {};
	eventDispatcher.extend(self);
	self:setNodeEventEnabled(true);
end

function ListView:enabledTouch(proity)
    self:addTouchEventListener(function(event, x, y)
        return self:onTouch(event, x, y)
    end, false, proity, true)
	self:setTouchEnabled(true)
end

function ListView:onTouch(event, x, y)
    if event == "began" then
        self:onTap(x, y);
		return cc.TOUCH_BEGAN
	end
	return cc.TOUCH_BEGAN_NO_SWALLOWS
end

--设置排列模式(使listview 支持 多行多列)
--列 marginh横向 间隔 marginv 纵向间隔
function ListView:setLayoutMode(cloume, marginh, marginv)
	self.isMutle = true;
	self.cloume = cloume;
	self.marginH = marginh;
	self.marginV = marginv;
end

--触摸时间 抛出 layerout中 被点到的CELL 值内容 等 
function ListView:onTap(x, y)
	for i = 1, #self.cells do
		if self.cells[i]:getCascadeBoundingBox():containsPoint(ccp(x, y)) then
			if type(self.cells[i].onTap) == "function" and not self.cells[i].dir then
				self.cells[i]:onTap();
			end
			self:dispatchEvent({name = ViewEvent.ON_VIEW_CELL_TAP, data = self.cells[i].data, index = self.cells[i].index, targetCell = self.cells[i]});
			return;
		end
	end
end

--重新排列内部元素
function ListView:resetPos(clearBonuds)
	local lastCell;
	for i = 1, #self.cells do
		local cell = self.cells[i];
		if i == 1 then
			cell:setPosition(0, 0);
			if clearBonuds then
				self:setPosition(0 - cell:getCascadeBoundingBox(false).origin.x, cell:getCascadeBoundingBox(false).origin.y);
			end
		else
			local rect = lastCell:getCascadeBoundingBox(false);
			
			if self.dir == ListView.DIR_HOR  then
				local leftPos = lastCell:getPositionX() +  lastCell:getCascadeBoundingBox(false).size.width - (lastCell:getPositionX() - rect.origin.x);
				cell:setPositionX(leftPos - cell:getCascadeBoundingBox(false).origin.x + self.margin * 2);
			else
				local topPos = lastCell:getPositionY() - (lastCell:getCascadeBoundingBox().size.height - (rect.origin.y + rect.size.height - lastCell:getPositionY()));
				cell:setPositionY(topPos - (cell:getCascadeBoundingBox(false).origin.y + cell:getCascadeBoundingBox(false).size.height) - self.margin * 2);
				
			end
		end
		
		lastCell = cell;
	end
end

--在使用 LayeroutMode 之后 使用这个Api 去添加CELL
function ListView:addMutleCell(cell)
	local horIdx = #self.cells % self.cloume
	local verIdx = math.floor(#self.cells / self.cloume);

	if #self.cells == 0 then
		cell:setPosition(0, 0)
	else

		local lastCell = self.cells[#self.cells];
		local rect = lastCell:getCascadeBoundingBox(false);
		
		local leftPos = lastCell:getPositionX() +  lastCell:getCascadeBoundingBox().size.width - (lastCell:getPositionX() - rect.origin.x);
		
		if horIdx == 0 then
			cell:setPositionX(0);
		else
			print("horIndex", horIdx)
			print("leftpos" , leftPos);
			print("cellPos" , cell:getCascadeBoundingBox(false).origin.x);
			print("szie" , cell:getCascadeBoundingBox(false).size.width , cell:getCascadeBoundingBox(false).size.height);
			cell:setPositionX(leftPos - cell:getCascadeBoundingBox(false).origin.x + self.marginH);
		end
		
		if verIdx == 0 then
			cell:setPositionY(0);
		else
			if horIdx > 0 then
				cell:setPositionY(lastCell:getPositionY());
			else
				local topPos = lastCell:getPositionY() - (lastCell:getCascadeBoundingBox().size.height - (rect.origin.y + rect.size.height - lastCell:getPositionY()));
				cell:setPositionY(topPos - (cell:getCascadeBoundingBox(false).origin.y + cell:getCascadeBoundingBox(false).size.height) - self.marginV);
			end
		end


	end
	
	self:addChild(cell);
	
	table.insert(self.cells, cell);
	cell.index = #self.cells
	self:dispatchEvent({name = ViewEvent.ON_VIEW_CHANGED})
end

--默认添加CELL方法
function ListView:addCell(cell, needAdjust, needSize)
	if self.isMutle then
		self:addMutleCell(cell);
		return;
	end

	needSize = needSize == nil and true or needSize
	
	if not needSize then
		cell:align(display.LEFT_TOP);
	end
	
	if #self.cells == 0 then
		cell:setPosition(0, 0);
		self.cellSize = self.dir == "hor" and cell:getCascadeBoundingBox(false).size.width or cell:getCascadeBoundingBox(false).size.height;
		self.cellSize = self.cellSize + self.margin;
	else
		local lastCell = self.cells[#self.cells];
		local rect = lastCell:getCascadeBoundingBox(false);
		
		if self.dir == ListView.DIR_HOR  then
			local leftPos = lastCell:getPositionX() +  lastCell:getCascadeBoundingBox().size.width - (lastCell:getPositionX() - rect.origin.x);
			cell:setPositionX(leftPos - cell:getCascadeBoundingBox(false).origin.x + self.margin);
			if needAdjust then
				cell:setPositionY(cell:getCascadeBoundingBox(false).origin.y)
			end
		else
			local topPos = lastCell:getPositionY() - (lastCell:getCascadeBoundingBox().size.height - (rect.origin.y + rect.size.height - lastCell:getPositionY()));
			cell:setPositionY(topPos - (cell:getCascadeBoundingBox(false).origin.y + cell:getCascadeBoundingBox(false).size.height) - self.margin);
			if needAdjust then
				cell:setPositionX(0 - cell:getCascadeBoundingBox(false).origin.x)
			end
		end
	end
	
	self:addChild(cell);
	
	if needSize then
		table.insert(self.cells, cell);
		cell.index = #self.cells
		self:dispatchEvent({name = ViewEvent.ON_VIEW_CHANGED})
	end
end

--移除所有 元素
function ListView:removeAllCell()
	for i = 1, #self.cells do
		local cell = self.cells[i]
		if type(cell.dispose) == "function" then
			cell:dispose();
		else
			cell:removeSelf(true);
		end
	end
	self.cells = {};
end

--销毁
function ListView:onExit()
	for i = 1, #self.cells do
		local cell = self.cells[i]
		if cell.controller and type(cell.controller.diposeControler) == "function" then
			cell.controller:diposeControler();
		end
	end
	self:removeAllEventListeners();
end


return ListView