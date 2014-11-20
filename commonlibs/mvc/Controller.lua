
local Controller = class("Controller")

--用来注册所有的command类,command是proxy和view之前的桥，用来解耦
Controller.commandMap = {
}

--执行命令	
function Controller:executeCommand(notification)
	local commandClass=self.commandMap[notification.name]
	if commandClass then
		local commandObj = commandClass:execute(notification)
	end
end

--注册command
function Controller:registerCommand(command)
	command.facade = self.facade;
	local names = command:listCommands()
	for i=1,#names do
		local name = string.upper(names[i])
		if not self.commandMap[name] then
			 self.facade.observer:addObserver(name,self,self.executeCommand)
			 self.commandMap[name]=command
		 end
	end 
end

--判断某个command是否存在
function Controller:hasCommand(notificationName)
	return self.commandMap[notificationName] ~= nil
end
 
--删除某个Command
function Controller:removeCommand(notificationName)
	if self:hasCommand(notificationName) then
		View:removeAllObserverByName(notificationName)
		self.commandMap[notificationName]=nil
	end
end

return Controller