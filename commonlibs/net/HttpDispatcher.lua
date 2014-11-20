--自定义 Http收发器封装 解决 lua 对象metatable新增属性 被 C++ 对象清空
--组合
local httpDispatcher = class("httpDispatcher")

function httpDispatcher:ctor(req, callback, url, method, reqtmpdata)
	self.httpRequest = network.createHTTPRequest(handler(self, self.onData), url, method);
	self.requestName = string.lower( req );
	self.callBack = callback;
	self.timeTick = require("socket").gettime();
	self.reqtmpdata = reqtmpdata
end

function httpDispatcher:getTickMsg()
	return self.requestName .. self.timeTick
end

function httpDispatcher:onData(e)
	self.callBack({request = e.request, requestName = self.requestName, parm = self.requestData, name = e.name, tickmsg = self:getTickMsg(), reqtmpdata = self.reqtmpdata});
end

return  httpDispatcher