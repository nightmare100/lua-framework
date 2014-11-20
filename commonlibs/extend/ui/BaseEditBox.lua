local BaseEditBox = class("BaseEditBox", function(parms)
	local box = ui.newEditBox(parms)
	
	if ((parms.x and parms.y)  == nil) and parms.file then
		box:setCustomPosition(parms.file);
	end
	
	return box
end)

return BaseEditBox