--简化 中介器 直接 对view 进行扩展

local MvcView = {};

function MvcView.extend(view)
    view._listenerMap = {};

    function view:addMvcListener(eventName, listener)
        eventName = string.upper(eventName)

		self._listenerMap[eventName] = listener;      
        MvcView.observer:addEventListener(eventName, listener);
    end

    function view:removeMvcListener(eventName, listener)
        eventName = string.upper(eventName);
    	MvcView.observer:removeEventListener(eventName, listener);
		self._listenerMap[eventName] = nil
    end

    function view:removeAllMvcEventListeners()
    	for k, v in pairs(self._listenerMap) do
    		MvcView.observer:removeEventListener(k, v);
    	end
        self._listenerMap = {}
    end
    
    function view:sendNotification(name, body)
		MvcView.facade:sendNotification(name, body)
	end
	
	function view:dispose()
    	self:removeAllMvcEventListeners();
		if self.class and type(self.class.dispose) == "function" then
    		self.class.dispose(self);
    	end
	end
    
    function view:onExit()
    	self:removeAllMvcEventListeners();
    	if self.class and type(self.class.onExit) == "function" then
    		self.class.onExit(self);
    	end
    end
    
    function view:initListener()
    	if type(self.listenerCommand) == "function" then
	    	local cmds = self:listenerCommand()
	    	for i = 1, #cmds do
	    		self:addMvcListener(cmds[i], handler(self, self.onNotify))
	    	end
	    end
    end
    
    view:initListener();

    return view
end


return MvcView;