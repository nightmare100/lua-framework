--物品管理 Model 除了 包括物品迭代器 还实现观察者 来派发物品变更事件

local ItemManager = class("ItemManager")

function ItemManager:ctor()
	eventDispatcher.extend(self);
	self.inventory = require("commonlibs.item.Inventory").new();
end

function ItemManager:addItem(id, num, type)
	type = type and type or ItemType.ITEM_PROP
	local item = self.inventory:addItem(id, num, type)
	self:dispatchEvent({name = ItemEvent.ON_ITEM_CHANGED, item = item});
end


function ItemManager:removeItem(id, num)
	local item = self.inventory:removeItem(id, num)
	self:dispatchEvent({name = ItemEvent.ON_ITEM_CHANGED, item = item});
end


function ItemManager:getItemById(id)
	return self.inventory:getItemById(id)
end


function ItemManager:getItemNum(id)
	local item = self.inventory:getItemById(id)
	return item and item.itemNum or 0;
end

function ItemManager:getItemByType(type)
	return self.inventory:getItemByType(type)
end



return ItemManager