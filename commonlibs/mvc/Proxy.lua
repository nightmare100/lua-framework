--数据层 Proxy 只抛 不收
local Proxy = class("Proxy");

function Proxy:sendNotification(name, body)
	if self.facade then
		self.facade:sendNotification(name, body)
	end
end

return Proxy