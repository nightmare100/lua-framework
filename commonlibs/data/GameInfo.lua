--游戏信息类
local gameInfo = class("gameInfo");

function gameInfo:ctor(o)
	if o then
		self:setData(o);
	else
		self.gameServer = "";
		self.gameName = "";
		self.gameID = "";
		self.playerID = "";
		self.lang = "";
		self.isFreeSpin = false;
		self.freeSpinCount = 0;
		self.isVip = false;				--目前没用貌似
		self.range = "";
		self.waitTime = 0;				--等待时间
		self.customPic = nil;
	end
end

function gameInfo:setData(o)
	self.gameServer = o.gameServer;
	self.gameName = o.gameName;
	self.gameID = o.gameid;
	self.playerID = o.playerID;
	self.lang = o.lang;
	self.isFreeSpin = o.isFreeSpin;
	self.freeSpinCount = o.freeSpinCount;
	self.isVip = o.isVip;				--目前没用貌似
	self.range = o.range;
	self.waitTime = o.waitTime;			--等待时间
	self.customPic = o.customName;
	if not self.customPic then
		self.sex = math.random(2);
	end 
end

return gameInfo;