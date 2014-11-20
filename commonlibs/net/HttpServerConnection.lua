--Http 收发器
require("commonlibs.net.ServerEvent")
local customRequest = class("customRequest", function(cb, url, method, rpc)
	local request = network.createHTTPRequest(cb, url, method)
	request.requestRpc = rpc
	return request;
end)


local connection = class("HttpConnection");

function connection:ctor()
	eventDispatcher.extend(self)
	
	self.serverUrl = "";
	
	-- parse proto
	self.parse = nil;
	
	--log func
	self.logFunc = nil;	
end

function connection:setServerUrl(url)
	self.serverUrl = url;
end

function connection:clearCookie()
	local cookiePath = CCFileUtils:sharedFileUtils():getWritablePath() .. "cookie.txt";
	if io.exists(cookiePath) then
		io.writefile(cookiePath, "");
	end
end

--初始化服务器  url 服务器地址 par 解析器 log 服务器日志方法
function connection:initServer(url, par, log, filterArr)
	self.serverUrl = url
	self.parse = par
	self.logFunc = log
	
	if filterArr then
		for k, v in pairs(filterArr) do
			filterArr[k] = string.upper(v);
		end
	end
	
	self.filterArr = filterArr
end

function connection:requestMade(req, parm)
	return self.serverUrl .. "?rpc=" .. req .. "&ra=" .. math.random()
end


--收到数据
function connection:onData(event)
	local request = event.request
	local requestName = event.requestName
	--请求超时
	if not Tick.getInstance():hasTimeout(string.lower(event.tickmsg)) then
		return false;
	end

	local code;
	
	xpcall(function()
		code = request:getResponseStatusCode();
	end,function(msg)
		Tick.getInstance():kill(string.lower(event.tickmsg));
		__G__TRACKBACK__(msg, true, requestName)
		return false;
	end)

	if (event.name == Event.COMPLETE and code == 200) then
		local response = request:getResponseString();
		if (self.logFunc ~= nil) then
			self.logFunc(response)
		end

		local backData;
		if (self.parse ~= nil) then
			backData, requestName = self.parse:execute(requestName, response, event.parm)
		end
		
		Tick.getInstance():kill(string.lower(event.tickmsg));

		CCLuaLog("request:")
		CCLuaLog(requestName and requestName or "")
		CCLuaLog("response:" .. (response and response or ""))
		CCLuaLog("responseLength:" .. (request:getResponseDataLength() and request:getResponseDataLength() or "0"));
		
		if (request:getResponseDataLength() == 0 or backData and backData.retCode and backData.retCode ~= ErrorMap.NO_ERROR and backData.retCode < 10000) and self:filiterReq(requestName) then
			self:dispatchEvent({name = ServerEvent.RequestError, reqName = requestName})
			return false;
		elseif backData and backData.errorcode and backData.errorcode ~= ErrorMap.NO_ERROR and self:filiterReq(requestName) then
			device.showAlert("服务器异常", backData.errormsg);
			return false;
		end
		
		if requestName then
			self:dispatchEvent({name = requestName, data = backData, reqtmpdata = event.reqtmpdata})
			return true;
		end
	else
		Tick.getInstance():kill(string.lower(event.tickmsg));
		self:dispatchEvent({name = ServerEvent.RequestError, code = request:getErrorCode(), msg = request:getErrorMessage(), reqName = requestName})
		return false;
	end
end

--过滤请求(异常处理)
function connection:filiterReq(req)
	if not req then
		return true;
	end
	
	if self.filterArr then
		return not table.find(self.filterArr, string.upper(req));
	else
		return true;
	end
end

--超时 抛异常
function connection:onTimeout()
	self:dispatchEvent({name = ServerEvent.RequestError, code = 0, msg = "", reqName = ""})
	self:removeAllEventListeners();
end

--发送HTTP协议 数据 给服务端
function connection:sendRequest(req, parm, reqtmpdata)
	
	if not network.isInternetConnectionAvailable() then
		self:dispatchEvent({name = ServerEvent.RequestError, reqName = req})
		return false;
	end

	print(self:requestMade(req));
	local request = require("commonlibs.net.HttpDispatcher").new(req, handler(self, self.onData), self:requestMade(req, parm), kCCHTTPRequestMethodPOST, reqtmpdata) 
--	network.createHTTPRequest(handler(self, self.onData), self:requestMade(req, parm), kCCHTTPRequestMethodPOST);
	request.httpRequest:addRequestHeader("Content-Type:text/json");
	request.requestData = parm;
	
	if (self.parse ~= nil) then
		parm = self.parse:transferData(req, parm)
	end

	if parm and parm ~= "null" then
		request.httpRequest:setPOSTData(parm);
	else
		request.httpRequest:setPOSTData("");
	end

	CCLuaLog("request send:")
	if parm then
		CCLuaLog(parm)
	end

	request.httpRequest:start()
	Tick.getInstance():addTimeout(handler(self, self.onTimeout), 10, string.lower(request:getTickMsg()));
	return true;
end

return connection