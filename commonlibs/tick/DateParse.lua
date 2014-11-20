--时间解析器 能解析 一个timetick
require("commonlibs.utils.DateUtil")

local DateParse = class("DateParse")

--time  秒
function DateParse:ctor(time)
	if time then
		self:setTotalSeconds(time)
	end
end

function DateParse:setTotalSeconds(val)
	self.totalSeconds = val
	self:parseTime()
end

function DateParse:parseTime()
	self.days = math.floor(self.totalSeconds / 86400)
	self.hours = math.floor((self.totalSeconds - self.days * 86400) / 3600)
	self.minutes = math.floor((self.totalSeconds - self.days * 86400 - self.hours * 3600) / 60)
	self.seconds = math.floor(self.totalSeconds - self.days * 86400 - self.hours * 3600 - self.minutes * 60)
end

function DateParse:getHours()
	return DateUtil.getZeroFill(self.hours, 2)
end

function DateParse:getMinutes()
	return DateUtil.getZeroFill(self.minutes, 2)
end

function DateParse:getSeconds()
	return DateUtil.getZeroFill(self.seconds, 2)
end

function DateParse:getDays()
	return DateUtil.getZeroFill(self.days, 2)
end

return DateParse