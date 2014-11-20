local MvcCommand = class("command")

function MvcCommand:sendNotification(name, body)
	if self.facade then
		self.facade:sendNotification(name, body)
	end
end

function MvcCommand:listCommands(name)
	return {};
end

return MvcCommand