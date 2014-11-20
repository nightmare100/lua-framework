--simple tick mashine
--简易定时器 有timeout and timeInterval功能

local tick = class("Tick");
local instance
local schedulerMgr = CCDirector:sharedDirector():getScheduler()
local socket = require("socket")

function tick.getInstance()
	if not instance then
		instance = Tick.new()
	end
	
	return instance 
end

function tick:ctor()
	self.tickMap = {}
end

--timeout s
function tick:addTimeout(callback, timeout, key)
	key = key and key or "func" .. math.random(10000);
	local func = function(dt)
		self:kill(key)
		callback();
	end
	if self.isPause then
		self.tickMap[key] = {timeout = timeout, callback = func}
	else
		self.tickMap[key] = {key = schedulerMgr:scheduleScriptFunc(func, timeout, false), timeout = timeout, callback = func}
	end
end

--interval s
function tick:addInterval(callback, interval, key)
	if self.isPause then
		self.tickMap[key] = {timeout = interval, callback = callback}
	else
		self.tickMap[key] = {key = schedulerMgr:scheduleScriptFunc(callback, interval, false), timeout = interval, callback = callback}
	end
end

function tick:hasTimeout(key)
	return self.tickMap[key];
end

function tick:kill(key)
	if self.tickMap[key] then
		if self.tickMap[key].key then
			schedulerMgr:unscheduleScriptEntry(self.tickMap[key].key)
		end
		self.tickMap[key] = nil;
	end
end

--暂停
function tick:pause()
	if not self.isPause then
		self.isPause = true
		for k, v in pairs(self.tickMap) do
			if v.key then
				schedulerMgr:unscheduleScriptEntry(v.key)
			end
		end
	end
end

--继续
function tick:unpause()
	if self.isPause then
		self.isPause = false
		for k, v in pairs(self.tickMap) do
			print("[key value]" , k);
			v.key = schedulerMgr:scheduleScriptFunc(v.callback, v.timeout, false)
		end
	end
end

function tick:clear()
	for k, v in pairs(self.tickMap) do
		if v.key then
			schedulerMgr:unscheduleScriptEntry(v.key)
		end
	end
	self.tickMap = {};
end

return tick;