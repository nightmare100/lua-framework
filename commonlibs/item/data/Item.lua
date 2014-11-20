--物品结构
local item = class("Item")

function item:ctor(id)
	self.itemID = id;
	self.desc = ""
	self.itemPrice = 0
	self.itemNum = 0;
end

return item