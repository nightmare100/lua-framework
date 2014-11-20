-- lua PureMvc思想

local model = require("commonlibs.mvc.Model").new();
local controller = require("commonlibs.mvc.Controller").new();
MVC_View = require("commonlibs.mvc.MvcView");
MVC_Proxy = require("commonlibs.mvc.Proxy");
local Facade = class("Facade")

function Facade:ctor()
	self.observer = require("commonlibs.mvc.Observer").new();
	controller.facade = self;
	model.facade = self;
	MVC_View.facade = self;
	MVC_View.observer = self.observer
end

--发送通知
function Facade:sendNotification(name,body)
	self.observer:sendNotification({name=name,data=body})
end
--别名类
function Facade:notify(name,body)
	self:sendNotification(name,body)
end

--注册command相关
function Facade:registerCommand(command)
	controller:registerCommand(command)
end

--删除command
function Facade:removeCommand(name)
	controller:removeCommand(name)
end

function Facade:hasCommand(name)
	return controller:hasCommand(name)
end

function Facade:registerProxy(proxy)
	model:registerProxy(proxy)
end

function Facade:retrieveProxy(name)
	return model:retrieveProxy(name)
end

function Facade:hasProxy(name)
	return model:hasProxy(name)
end

function Facade:removeProxy(name)
	model:removeProxy(name)
end


return Facade