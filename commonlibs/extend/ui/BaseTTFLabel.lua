local scale =  CCDirector:sharedDirector():getContentScaleFactor()

local BaseTTFLabel = class("BaseTTFLabel", function(parms)
	local fixScale = CCDirector:sharedDirector():getContentScaleFactor();
	if parms.size then
		parms.size = parms.size / fixScale
	end 
	local box = ui.newTTFLabel(parms)
	box.x = parms.x
	box.y = parms.y
	box.cuAlign = parms.align or ui.TEXT_ALIGN_LEFT
	if ((parms.x and parms.y)  == nil) and parms.file and box:getCustomPosition(parms.file) ~= nil then
			box.posX = parms.posX
			box.posY = parms.posY
	
			local posInfo = box:getCustomPosition(parms.file)
			box.cuFile = parms.file
			box.isRelative = parms.isRelative
			if parms.isRelative then
				box:customAlign(posInfo.x / fixScale, posInfo.y / fixScale);
			else
				box:customAlign(display.cx + posInfo.x / fixScale, display.cy + posInfo.y / fixScale);
			end
			
			if box.posX then
				box:setPositionX(box.posX)
			end
			
			if box.posY then
				box:setPositionY(box.posY)
			end
	end
	
	return box
end)

function BaseTTFLabel:setText(txt)
	self:setString(txt);
	if self.cuFile then
		local posInfo = self:getCustomPosition(self.cuFile)
		if self.isRelative then
			self:customAlign(posInfo.x / scale, posInfo.y / scale);
		else
			self:customAlign(display.cx + posInfo.x / scale, display.cy + posInfo.y / scale);
		end
		
		
			
		if self.posX then
			self:setPositionX(self.posX)
		end
		
		if self.posY then
			self:setPositionY(self.posY)
		end
	else
		self:customAlign(self.x, self.y);
	end
		
end

return BaseTTFLabel