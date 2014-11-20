--滚动的数字文本 

local BaseTTFText = require("commonlibs.extend.ui.BaseTTFLabel");
local MeterWord = class("MeterWord", function(parmas)
	return BaseTTFText.new(parmas);
end)

local schedulerMgr = CCDirector:sharedDirector():getScheduler()

function MeterWord:ctor()
	self:registerNodeEvent();
	self.currentValue = 0;
end

function MeterWord:onExit()
	self:reset();
end

--使文本 在指定的 秒内 滚动到指定的 值
function MeterWord:meterToNumber(n, sec, sound)
	self:reset();
	self.targetNum = n;
	self.preAddNum = self.targetNum / (sec / FRAME_RATE) ;
	self.scheduleID = schedulerMgr:scheduleScriptFunc(handler(self, self.onMeter), 0, false);
	
	SoundMgr.playSound(sound)
	self.soundID = sound;
end

--直接显示 目标数字 结束滚动
function MeterWord:directToTarget()
	self:reset();
	if self.targetNum then
		self.currentValue = self.targetNum;
		self:setText(self.currentValue)
	end
end

function MeterWord:onMeter()
	if self.currentValue >= self.targetNum then
		self.currentValue = self.targetNum;
		if self.scheduleID then
			schedulerMgr:unscheduleScriptEntry(self.scheduleID);
		end
		BaseTTFText.setText(self, self.currentValue);
	else
		self.currentValue = self.currentValue + self.preAddNum;
		BaseTTFText.setText(self, math.floor(self.currentValue));
	end
end

function MeterWord:reset()
	if self.scheduleID then
		schedulerMgr:unscheduleScriptEntry(self.scheduleID);
	end
	
	if self.soundID then
		SoundMgr.stopSound(self.soundID);
	end
end

function MeterWord:setText(txt)
	self.currentValue = tonumber(txt);
	self:reset();
	self.targetNum = self.currentValue;
	BaseTTFText.setText(self, self.currentValue);
end

return MeterWord;