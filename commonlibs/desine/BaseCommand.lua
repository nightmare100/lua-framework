--命令基类

local BaseCommand = class("BaseCommand", function(cmd, dispatcher)
	local o = {}
	o.cmd = cmd;
	o.dispatcher = dispatcher
	return o;
end)

function BaseCommand:onComplete(parms)
	self.dispatcher:dispatchEvent({name = self.cmd, data = parms})
end

return BaseCommand;