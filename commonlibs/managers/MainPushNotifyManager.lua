--通知中心封装

local MainPushNotifyManager = {};



function MainPushNotifyManager.open()
	if NotifyCenterManager then
		MainPushNotifyManager.checkNotifyList();
		NotifyCenterManager:open()
	end
end

function MainPushNotifyManager.checkNotifyList()
	for k, v in pairs(MainPushNotifyManager.notifyList) do
		local delay = type(v.delay) == "number" and v.delay or v.delay(); 
		if delay > 0 then
			MainPushNotifyManager.addNotify(k, v.text, v.actWord, delay)
		else
			MainPushNotifyManager.removeNotify(k);
		end
	end
end

function MainPushNotifyManager.checkDayLogin()
	local nowTime = os.time();
	local loginTime = BasicUserDefault:getIntegerForKey(DefaultKeyDefined.loginTime);
	local delay = loginTime + 60 * 60 * 24 - nowTime;
	return delay;
end

function MainPushNotifyManager.checkGift()
	local giftLen = NotifyMgr:getNotifyLen(NotifyType.NOTIFY_MARK, NotifyDefined.MSG_GIFT_MARK);
	
	if giftLen > 0 then
		return 60 * 60 * 8;
	else
		return 60 * 60 * 8;
	end
end


function MainPushNotifyManager.close()
	if NotifyCenterManager then
		NotifyCenterManager:close()
	end
end


function MainPushNotifyManager.addNotify(key, content, act, delay)
	if NotifyCenterManager then
		NotifyCenterManager:addNotify(key, content, act, delay);
	end
end


function MainPushNotifyManager.removeNotify(key)
	if NotifyCenterManager then
		NotifyCenterManager:removeNotify(key);
	end
end

MainPushNotifyManager.notifyList = {
	hourlyBonus = {text = "Your hourly bonus is ready!", actWord = "ok", delay = 3600},
	daylogin = {text = "We missed you! Come back and try your luck." ,actWord =  "ok", delay = MainPushNotifyManager.checkDayLogin},
	giftBonus = {text = "Your gift is ready to be collected!" ,actWord =  "ok", delay = MainPushNotifyManager.checkGift}
}

return MainPushNotifyManager;