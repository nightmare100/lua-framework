local RectInfo = class("RectInfo")

function RectInfo:ctor(rect)
	if rect then
		self:parse(rect);
	end
end


function RectInfo:parse(rect)
	self.rect = rect;
	self.leftTopPt = self:parsePt(1)
	self.rightTopPt = self:parsePt(2)
	self.leftBottomPt = self:parsePt(3)
	self.rightBottomPt = self:parsePt(4)
end

function RectInfo:parsePt(type)
	if type == 1 then
		return ccp(self.rect.origin.x, self.rect.origin.y + self.rect.size.height)
	elseif type == 2 then
		return ccp(self.rect.origin.x + self.rect.size.width, self.rect.origin.y + self.rect.size.height)
	elseif type == 3 then
		return ccp(self.rect.origin.x + self.rect.size.width, self.rect.origin.y + self.rect.size.height)
	else
		return ccp(self.rect.origin.x + self.rect.size.width, self.rect.origin.y + self.rect.size.height)
	end
end



return RectInfo