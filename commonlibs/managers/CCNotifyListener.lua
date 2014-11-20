--CCNotificationCenter lUA层封装

CCNotifyListener = {};
local noticeCenter = CCNotificationCenter:sharedNotificationCenter();
eventDispatcher.extend(CCNotifyListener);

--应用程序挂起 恢复
function CCNotifyListener.registerAppHangEvent(target)
	noticeCenter:registerScriptObserver(target, CCNotifyListener.onBackFontChanged, "APP_ENTER_FOREGROUND");
	noticeCenter:registerScriptObserver(target, CCNotifyListener.onBackFontChanged, "APP_ENTER_BACKGROUND");
end

function CCNotifyListener.onBackFontChanged(type)
	if type == "APP_ENTER_FOREGROUND" then
		local nowTick = os.time() - CCNotifyListener.timeTick;
		CCNotifyListener:dispatchEvent({name = AppEvent.ON_ENTER_FOREGROUND, second = nowTick})
	elseif type == "APP_ENTER_BACKGROUND" then
		CCNotifyListener.timeTick = os.time();
		CCNotifyListener:dispatchEvent({name = AppEvent.ON_ENTER_BACKGROUND, tick = CCNotifyListener.timeTick})
	end
	
end

function CCNotifyListener.removeAppHangEvent(target)
	noticeCenter:unregisterScriptObserver(target, "APP_ENTER_FOREGROUND")
	noticeCenter:unregisterScriptObserver(target, "APP_ENTER_BACKGROUND")
end

