local equipItem = class("EquipItem", require("commonlibs.item.data.Item"))

function equipItem.ctor(id)
	require("commonlibs.item.data.Item").ctor(self, id)
	self.itemType = ItemType.ITEM_EQUIP
end

return equipItem;