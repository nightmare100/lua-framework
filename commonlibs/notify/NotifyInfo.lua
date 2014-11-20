--消息体
NotifyInfo = class("NotifyInfo")
local socket = require("socket")

--type 消息种类 见notifyType
--name 消息名称 见notifyDefined
function NotifyInfo:ctor(type, name, info, proity)
	self.notifyType = type;
	self.notifyName = name;
	self.data = info;
	self.proity = proity or 0;
	self.messageTimer = socket:gettime();
end