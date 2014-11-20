--[[数据层 Proxy基类 只抛 不收 用于做数据管理
	当数据变更时 可派发事件  MVC view 或者 Controller 可直接收听
]]
local Proxy = class("Proxy");

function Proxy:sendNotification(name, body)
	if self.facade then
		self.facade:sendNotification(name, body)
	end
end

return Proxy