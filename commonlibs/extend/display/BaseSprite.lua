local BaseSprite = class("BaseSprite", function(file, x, y, isRelative,condFileName)
	local spr = display.newSprite(file,x,y);
	if (x and y) == nil and file then
		local fileName  
		if condFileName then
			fileName = (string.sub(condFileName,1, 1) == "#" and string.sub(condFileName,2)) or condFileName
		else 
			fileName =(string.sub(file,1, 1) == "#" and string.sub(file,2)) or file
		end
		if isRelative then
			local info = spr:getCustomPosition(fileName)
			local scale =  CCDirector:sharedDirector():getContentScaleFactor()
			spr:setPosition(info.x / scale, info.y / scale);
		else
			spr:setCustomPosition(fileName);
		end 
	end
	return spr
end)


return BaseSprite