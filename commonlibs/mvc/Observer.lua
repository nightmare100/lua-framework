--
local EventProtocol = require("framework.api.EventProtocol")
local Observer = class("Observer")

EventProtocol.extend(Observer)

--发送通知
function Observer:sendNotification(event)
	self:dispatchEvent(event)
end

--添加 监听的命令事件
function Observer:addObserver(name,target,notifyMethod)
	self:addEventListener(name,handler(target,notifyMethod))
end

--删除观察者命令事件
function Observer:removeObserver(name,key)
	self:removeEventListener(name,key)
end


return Observer