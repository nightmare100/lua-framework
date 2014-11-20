--卡牌游戏 解析器 按类解析 每个命令返回的数据包
local ByteArray = require("commonlibs.utils.ByteArray")
local parser = class("parser")

function parser:ctor()
	self.dic = {}
	self.reqDic = {};
end

function parser:registerCommand(req, reqCmd, resCmd)
	self.reqDic[req] = {reqCmd = reqCmd, resCmd = resCmd};
end

function parser:addCmd(cmd, cls)
	self.dic[cmd] = cls;
end

function parser:getReqCmd(req)
	return self.reqDic[req].reqCmd;
end

function parser:getResCmd(req)
	return self.reqDic[req].resCmd;
end

function parser:getResCmdRequestName(cmd)
	for k, v in pairs(self.reqDic) do
		if v.resCmd == cmd then
			return k;
		end
	end
	return nil
end

function parser:parseRequestData(req, data)
	local cls = self.dic[req];
	if cls then
		local clsIns = type(cls) == "string" and require(cls).new() or cls;
		self.dic[req] = clsIns;
		data = clsIns:transformReqData(req, data);
	end
	
	
	local jsonStar = jsonParse.encode(data)
	local postData = ByteArray.new(ByteArray.ENDIAN_BIG);
	postData:writeStringBytes(jsonStar);
	
	local bytes = ByteArray.new(ByteArray.ENDIAN_BIG);
	bytes:writeShort(self:getReqCmd(req));
	bytes:writeUInt(postData:getLen());
	bytes:writeBytes(postData);
	
	return bytes;
end

function parser:parseResonseData(req, data)
	local cls = self.dic[req];
	if cls then
		cls:executeResponse(req, data);
	end
end

return parser