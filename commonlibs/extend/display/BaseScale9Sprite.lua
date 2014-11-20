--

local BaseScale9Sprite = class("BaseScale9Sprite", function(file, x, y)
	local spr = display.newScale9Sprite(file,x , y)
	if (x and y) == nil then
		local fileName = (string.sub(file,1, 1) == "#" and string.sub(file,2)) or file
		spr:setCustomPosition(fileName);
	end
	return spr
end)


return BaseScale9Sprite