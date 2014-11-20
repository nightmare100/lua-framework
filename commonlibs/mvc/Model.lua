local Model = class("Model")

Model.proxyMap={
}

function Model:registerProxy(proxy)
	proxy.facade = self.facade;
	self.proxyMap[proxy.name]=proxy
end

function Model:retrieveProxy(name)
	return self.proxyMap[name]
end

function Model:hasProxy(name)
	return not self.proxyMap[name]
end

function Model:removeProxy(name)
	local proxy=self.proxyMap[name]
	if proxy then
		self.proxyMap[name]=nil
	end
	return proxy
end

return Model