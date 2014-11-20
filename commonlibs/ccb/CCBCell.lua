--CCB NODE 包装器

local CCBCell = class("CCBCell");

--初始化一个UI
function CCBCell:ctor(ccbFile, ccbClass, proity)
	self.viewData = {};
	self:addViewListener();
	self.ccbClass = ccbClass;
	self.viewData,self.view, self.proxy = CCBCustomLoad(ccbFile, ccbClass, self.viewData);
	eventDispatcher.extend(self.view);
	self:initView();

	proity = proity and proity or TouchProity.Lobby;
	self:resetTouchProity(proity, self.view);
	
	self.view.controller = self;
	CCNodeExtend.extend(self.view);
	
	self:initData();
end

--UI的控制器 可重写
function CCBCell:setData(info)
	self.view.data = info
	if type(self.view.setData) == "function" then
		self.view:setData(info);
	end
end

--UI初始化状态操作
function CCBCell:initData()

end

function CCBCell:initView()
	for k, v in pairs(self.viewData) do
		if type(v) ~= "function" then
			self.view[k] = v;
		end
	end
	CCNodeExtend.extend(self.view)
	
	local children = self.view:getChildren();
	self:resetPosition(children);
end


--解决UI不自动缩放的问题
function CCBCell:resetPosition(children)
	local scale = CCDirector:sharedDirector():getContentScaleFactor();
	if children then
		for i = 0,children:count() - 1 do
			local obj = children:objectAtIndex(i);
			
			obj:setPosition(obj:getPositionX() / scale, obj:getPositionY() / scale);
			self:resetPosition(obj:getChildren());
		end 
	end
end

function CCBCell:addViewListener()
	
end

--重设CCB中 ccmenu 触摸级别
function CCBCell:resetTouchProity(proity, node)
	local children = node:getChildren();
	if children and children:count() > 0 then
		for i = 0,children:count() - 1 do
			local obj = children:objectAtIndex(i);
			if tolua.type(obj) == "CCMenu" then
				obj:setTouchPriority(proity);
			else
				self:resetTouchProity(proity, obj);
			end
		end 
	end
end

--销毁 controller 和 view
function CCBCell:dispose()
	if type(self.view.removeAllEventListeners) == "function" then
		self.view:removeAllEventListeners();
	end	
	if type(self.removeAllMvcEventListeners) == "function" then
		self:removeAllMvcEventListeners();
	end
		
	ccb[self.ccbClass] = nil;
	self.viewData = nil;
	if self.view then
		self.view:removeSelf(true);
	end
end

--单独销毁controller  用于view 被加载到自定义控件 自动销毁的情况 无需再次处理view 导致重复清理 引起的异常
function CCBCell:diposeControler()
	if type(self.view.removeAllEventListeners) == "function" then
		self.view:removeAllEventListeners();
	end	
	if type(self.removeAllMvcEventListeners) == "function" then
		self:removeAllMvcEventListeners();
	end
		
	ccb[self.ccbClass] = nil;
	self.viewData = nil;
end

--retain
function CCBCell:retain()
	self.view:retain()
end

--release
function CCBCell:release()
	self.view:release()
end

function CCBCell:setVisible(bool)
	self.view:setVisible(bool)
end

return CCBCell;