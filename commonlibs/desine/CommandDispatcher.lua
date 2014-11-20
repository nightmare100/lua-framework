--Command Mode
--命令模式收发器

local CommandDispatcher = class("CommandDispatcher");

function CommandDispatcher:ctor()
	self.map = {};
	eventDispatcher.extend(self)
end


--执行一个注册过的命令
function CommandDispatcher:execute(cmd, parms)
	if type(self.map[cmd]) == "string" then
		self.map[cmd] = reload(self.map[cmd]).new(cmd, self)
	end
	if self.map[cmd] then
		self.map[cmd]:execute(parms);
	end
end

function CommandDispatcher:removeEventListener(eventName, listener)
    eventName = string.upper(eventName)
    if self.listeners[eventName] == nil then return end
    local listenersForEvent = self.listeners[eventName]
    
    if (type(listener) == "string") then
    	if (listenersForEvent[listener]) then
    		listenersForEvent[listener] = nil
    	end
    else
        for i = #listenersForEvent, 1, -1 do
            if listenersForEvent[i] == listener then
                table.remove(listenersForEvent, i)
                return
            end
        end
    end
    if #listenersForEvent == 0 then self.listeners[eventName] = nil end
end

function CommandDispatcher:dispatchEvent(event)
    event.name = string.upper(event.name)
    local eventName = event.name
    if self.listeners[eventName] == nil then return end

    event.target = self
    local listenersForEvent = self.listeners[eventName]
    
    for k, v in pairs(listenersForEvent) do
    	if v then
    		if type(v) == "table" then
	            ret = v[2](v[1], event)
	        else
	            ret = v(event)
	        end
	    	if ret == false then break end
    	end
    end
end

function CommandDispatcher:addEventListener(eventName, listener, key)
    eventName = string.upper(eventName)
    if self.listeners[eventName] == nil then
        self.listeners[eventName] = {}
    end
    local listenersForEvent = self.listeners[eventName]
    listenersForEvent[(key and key) or (#listenersForEvent + 1)] = listener
end

--注册一个命令
function CommandDispatcher:registerCommand(cmd, ref)
	self.map[cmd] = ref
end

--销毁收发器
function CommandDispatcher:dispose()
	self:removeAllEventListeners();
	self.map = nil;
end

return CommandDispatcher
