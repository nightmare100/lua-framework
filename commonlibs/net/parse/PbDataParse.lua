--Mason
--pb 协议解析器 按类解析PB返回的数据
require("commonlibs.pbc.protobuf");

local pbClsRef = require("commonlibs.net.PbReffrence")

local PbDataParse = {}
PbDataParse.parseMap = {}

local parser = require "commonlibs.pbc.parser"
parser.register("addressbook.proto", GAME_LUA_ROOT.."/pbc/test/pb/msg/")

function PbDataParse:addParseCmd(cmd, parse)
	self.parseMap[cmd] = parse
end


function PbDataParse:getParseCmd(req)
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


function PbDataParse:execute(req, data)
	data = protobuf.decode(pbClsRef:getPbClass(req),data)
	local cmd = self:getParseCmd(req)
	if cmd ~= nil then
		cmd.execute(req, data)
	end
	return data
end

function PbDataParse:transferData(req, data)
	local cmd = self:getParseCmd(req)
	if cmd ~= nil then
		return protobuf.encode(pbClsRef:getPbClass(req),cmd.transferData(req, data))
	else
		return protobuf.encode(pbClsRef:getPbClass(req), data);
	end
end


return PbDataParse