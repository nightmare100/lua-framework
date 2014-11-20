local scale =  CCDirector:sharedDirector():getContentScaleFactor()

local BaseBMLabel = class("BaseBMLabel", function(parms)
	scale =  CCDirector:sharedDirector():getContentScaleFactor();
	local box = ui.newBMFontLabel(parms)
	
	if parms.scale then
		box:setScale(parms.scale)
	end
	
	if ((parms.x and parms.y)  == nil) and parms.file and box:getCustomPosition(parms.file) ~= nil then
			local posInfo = box:getCustomPosition(parms.file)
			box.cuAlign = parms.align or ui.TEXT_ALIGN_LEFT
			box.cuFile = parms.file
			if parms.isRelative then
				box:setPosition(posInfo.x / scale, posInfo.y / scale);
			else
				box:setPosition(display.cx + posInfo.x / scale, display.cy + posInfo.y / scale);
			end
			
			
			box.posX = parms.posX
			box.posY = parms.posY
			if box.posX then
				box:setPositionX(box.posX)
			end
			
			if box.posY then
				box:setPositionY(box.posY)
			end
	end
	
	return box
end)

return BaseBMLabel