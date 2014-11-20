local propItem = class("PropItem", require("commonlibs.item.data.Item"))

function propItem.ctor(id)
	require("commonlibs.item.data.Item").ctor(self, id)
	self.itemType = ItemType.ITEM_PROP
end

return propItem;