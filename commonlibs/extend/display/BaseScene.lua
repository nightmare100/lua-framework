
local BaseScene = class("BaseScene", function(name)
	return display.newScene(name)
end)

function BaseScene:ctor(name, layer)
	if layer then
		self.layer = layer;
	else
		self.layer = display.newLayer();
	end
	self:addChild(self.layer)
	
	self:registerNodeEvent();
end


return BaseScene