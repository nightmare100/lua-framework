--Mason
--卡牌游戏 SOKCET 扩展
local SocketTCP = require("commonlibs.net.socket.SocketTCP")
local ByteArray = require("commonlibs.utils.ByteArray")

local CardSocketServer = class(CardSocketServer, SocketTCP)

function CardSocketServer:ctor(__host, __port, __retryConnectWhenFailure, parse)
	self.serverBuff = ByteArray.new(ByteArray.ENDIAN_BIG);
	self.headLen = 6
	self.isHeadReaded = false;
	self.cmd = nil;
	self.bodyLen = 0;
	self.parser = parse
	SocketTCP.ctor(self, __host, __port, __retryConnectWhenFailure);
end

function CardSocketServer:send(cmd, obj)
	print("[socket send] cmd " .. cmd);
	print("[socket send] cmdnum " .. self.parser:getReqCmd(cmd));
	print("[socket send parms]");
	print(jsonParse.encode(obj));
	local byteArr = self.parser:parseRequestData(cmd, obj);
	SocketTCP.send(self, byteArr:getPack());
end

function CardSocketServer:onData()
	-- if use "*l" pattern, some buffer will be discarded, why?
	local __body, __status, __partial = self.tcp:receive("*a")	-- read the package body
	--print("body:", __body, "__status:", __status, "__partial:", __partial)
    if __status == STATUS_CLOSED or __status == STATUS_NOT_CONNECTED then
    	self:close()
    	if self.isConnected then
    		self:_onDisconnect()
    	else 
    		self:_connectFailure()
    	end
   		return
	end
    if 	(__body and string.len(__body) == 0) or
		(__partial and string.len(__partial) == 0)
	then return end
	if __body and __partial then __body = __body .. __partial end
	
	__body = __body and __body or __partial;
	self.serverBuff:writeBuf(__body);
	if not self.isHeadReaded then
		print(self.serverBuff:getLen());
		if self.serverBuff:getLen() > self.headLen then
			--包头处理
			self.serverBuff:setPos(1);
			self.cmd = self.serverBuff:readUShort();
			self.bodyLen = self.serverBuff:readUInt();
			self.isHeadReaded = true;
			self.serverBuff:clearByPos();
			print("[response cmd]", self.cmd);
			print("[response bodyLen]", self.bodyLen);
		else
			return;
		end
	end
	
	--包头已读完
	if self.serverBuff:getLen() >= self.bodyLen then
		local backBytes = ByteArray.new(ByteArray.ENDIAN_BIG);
		self.serverBuff:setPos(1);
		self.serverBuff:readBytes(backBytes, 1, self.bodyLen);
		self.serverBuff:clearByPos();
		self.isHeadReaded = false
		backBytes:setPos(1);
		local str = backBytes:readString(self.bodyLen);
		local backData = jsonParse.decode(str);
		print("[response content] ", str);
		local req = self.parser:getResCmdRequestName(self.cmd)
		self.parser:parseResonseData(req, backData);
		self:doExtra(req);
		self:dispatchEvent({name = req, data = backData, cmd = self.cmd})
	end
end

function CardSocketServer:doExtra(cmd)
	
end

return CardSocketServer