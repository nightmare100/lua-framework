local scale =  CCDirector:sharedDirector():getContentScaleFactor()

local BaseTTFShandowLabel = class("BaseTTFShandowLabel", function(parms)
	scale =  CCDirector:sharedDirector():getContentScaleFactor();
	if parms.size then
		parms.size = parms.size / scale
	end 
	

	local px, py = parms.x, parms.y;
	
	local box = ui.newTTFLabelWithShadow(parms)
	box.x = px;
	box.y = py;
	if ((box.x and box.y)  == nil) and parms.file and box:getCustomPosition(parms.file) ~= nil then
			local posInfo = box:getCustomPosition(parms.file)
			box.cuAlign = parms.align or ui.TEXT_ALIGN_LEFT
			box.cuFile = parms.file
			box.isRelative = parms.isRelative
			if parms.isRelative then
				box:customAlign(posInfo.x / scale, posInfo.y / scale);
			else
				box:customAlign(display.cx + posInfo.x / scale, display.cy + posInfo.y / scale);
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

function BaseTTFShandowLabel:setText(txt)
	self:setString(txt)
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

function BaseTTFShandowLabel:setFontSize(size)
	 self.label:setFontSize(size)
     self.shadow1:setFontSize(size)
end

return BaseTTFShandowLabel