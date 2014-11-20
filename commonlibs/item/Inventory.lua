local Inventory = class("Inventory")

function Inventory:ctor()
	self.itemDic = {};
	self.itemDic[ItemType.ITEM_EQUIP] = {}
	self.itemDic[ItemType.ITEM_PROP] = {}
end

function Inventory:addItem(id, num, type)
	if self.itemDic[type][id] then
		self.itemDic[type][id].itemNum = self.itemDic[type][id].itemNum + num;
		return self.itemDic[type][id];
	end
	self.itemDic[type][id] = require("commonlibs.item.data.Item").new(id);
	self.itemDic[type][id].itemNum = num;
	return self.itemDic[type][id];
	
end

function Inventory:removeItem(id, num)
	for k, v in pairs(self.itemDic) do
		if self.itemDic[key][id] then
			self.itemDic[key][id].itemNum = self.itemDic[key][id].itemNum - num;
			return self.itemDic[key][id]
		end
	end
	return nil;
end

function Inventory:getItemById(id)
	for k, v in pairs(self.itemDic) do
		if self.itemDic[key] and self.itemDic[key][id] then
			return self.itemDic[key][id]
		end
	end
	return nil;
end

function Inventory:getItemByType(type)
	local result = {};
	for k, v in pairs(self.itemDic) do
		if self.itemDic[key] then
			for _,itemValue in pairs(self.itemDic[key]) do
				table.insert(result, itemValue);
			end
		end
	end
	return result;
end

return Inventory;