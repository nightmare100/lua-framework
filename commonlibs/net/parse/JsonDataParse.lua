--Json 协议解析器
local JsonDataParse = class("JsonDataParse")
JsonDataParse.parseMap = {}

--添加解析命令
function JsonDataParse:addParseCmd(cmd, parse)
	cmd = string.lower(cmd)
	self.parseMap[cmd] = parse
end


function JsonDataParse:getParseCmd(req)
	req = string.lower(req)
	if (self.parseMap[req] ~= nil) then
		local parseCmd = self.parseMap[req];
		if (type(parseCmd) ~= "table") then
			self.parseMap[req] = require(parseCmd)
		end
	
		return self.parseMap[req]
	else
		return nil	
	end
end

--reqparm 请求信息
function JsonDataParse:execute(req, data, reqparm)
	if not data then
		return data, req
	end
	data = jsonParse.decode(data)
	if data then
		req = req and req or string.lower( string.sub(data.msgId, 1, -4) )
		local cmd = self:getParseCmd(req)
		if cmd and data  then
			cmd.execute(req, data, reqparm)
		end
		return data, req;
	else
		return nil, req
	end
end

function JsonDataParse:transferData(req, data)
	local cmd = self:getParseCmd(req)
	if cmd ~= nil then
		return jsonParse.encode(cmd.transferData(req, data))
	else
		if data then
			return jsonParse.encode(data);
		else
			return nil;
		end
	end
end

return JsonDataParse