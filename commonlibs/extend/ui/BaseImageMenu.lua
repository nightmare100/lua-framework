local BaseImageMenuItem = class("BaseImageMenuItem", function(parms)
	local box = ui.newImageMenuItem(parms)
	
	if ((parms.x and parms.y) == nil) and parms.image then
	
		local fileName = (string.sub(parms.image,1, 1) == "#" and string.sub(parms.image,2)) or parms.image
		
		if parms.isRelative then
			local info = box:getCustomPosition(fileName)
			
			local scale =  CCDirector:sharedDirector():getContentScaleFactor()
			box:setPosition(info.x / scale, info.y / scale);
		else
			box:setCustomPosition(fileName);
		end 
	end
	
	return box
end)

return BaseImageMenuItem