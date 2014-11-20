--帧动画播放器 

local MovieClip = class("MovieClip", function(frames, file, x, y, autoPlay, frameRate, loop, autoDispose)
	local spr = cocoExtend.newSprite(file,x,y)
	spr.frames = frames
	spr.frameRate = frameRate

	if loop ~= nil then
		spr.loop = loop
	else
		spr.loop = true;
	end	

	spr.autoPlay = autoPlay
	spr.autoDispose = autoDispose
	return spr
end)

function MovieClip:ctor()
	self:registerNodeEvent();
end

--默认停止在第一帧
function MovieClip:onEnter()
	if not self.autoPlay then
		self:setDisplayFrame(self.frames[1])
	else
		self:play()
	end
end

--停止播放
function MovieClip:stop()
	if self.isPlaying then
		self:stopAllActions();
		self.isPlaying = false
	end
end


--播放
function MovieClip:play()
	if not self.isPlaying then
		local animation = display.newAnimation(self.frames, self.frameRate)
		local animate = display.newAnimate(animation)
		
		if self.loop then
			transition.playAnimationForever(self, animation)
		else
			if self.autoDispose then
				local callAct = CCCallFunc:create(handler(self, self.onAniComplete));
				self:runAction(transition.sequence({animate, callAct}));
			else
				self:runAction(animate)
			end
		end
		self.isPlaying = true
	end
end

function MovieClip:onAniComplete()
	self:removeSelf(true);
end

--指定 停止到 第几帧
function MovieClip:gotoAndStop(frame)
	if (frame < self:getTotalFrame()) then
		self:stop();
		self:setDisplayFrame(self.frames[frame])
	end
end

--获取播放完整时间
function MovieClip:getCompleteTime()
	return self:getTotalFrame() * self.frameRate
end

--获取帧数
function MovieClip:getTotalFrame()
	return table.getn(self.frames)
end

return MovieClip 