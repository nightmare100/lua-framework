local ShandowText = class("ShandowText");

function ShandowText:ctor(label, shandowColor, originColor)
	self.label = label;
	self.shandowColor = shandowColor
	self.originColor = originColor;
end

function ShandowText:setText(txt, needShandow)
	needShandow = needShandow ~= nil and needShandow or false;
	local oldText = self.label:getString();
	if type(self.label.setText) == "function" then
		self.label:setText(txt);
	else
		self.label:setString(txt);
	end
	
	if oldText ~= txt  and oldText ~= "" and needShandow then
		self:doShandow();
	end
end

function ShandowText:doShandow()
	transition.stopTarget(self.label);
	self.label:setColor(self.shandowColor)
	local fadeOut = CCFadeTo:create(0.3, 50)
	local fadeIn = CCFadeTo:create(0.3, 255)
	local fadeOut2 = CCFadeTo:create(0.3, 50)
	local fadeIn2 = CCFadeTo:create(0.3, 255)
	local fadeOut3 = CCFadeTo:create(0.3, 50)
	local fadeIn3 = CCFadeTo:create(0.3, 255)
	local onComplete = CCCallFunc:create(handler(self, self.onShandowComplete))
	local seq = transition.sequence({fadeOut, fadeIn, fadeOut2, fadeIn2, fadeOut3, fadeIn3, onComplete})

	self.label:runAction(seq);
end

function ShandowText:onShandowComplete()
	self.label:setColor(self.originColor)
end

return ShandowText;