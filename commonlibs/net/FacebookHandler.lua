--facebook处理 代理
FacebookHandler = {}


--facebook登陆
function FacebookHandler.login(cb)
	if device.platform == "ios" then
		FacebookProxy:login(handler(self, self.onFacebookStatueCheck));
	else
	
	end
end

--获取自己信息
function FacebookHandler.getSelfInfo(cb)
	if device.platform == "ios" then
		FacebookProxy:getSelfInfo(cb);
	else
	
	end
end

--获取好友信息
function FacebookHandler.getUserFriend(cb)
	if device.platform == "ios" then
		FacebookProxy:getUserFriend(cb);
	else
	
	end
end

--发送APP请求
function FacebookHandler.sendAppRequest(cb, arr)
	if device.platform == "ios" then
		FacebookProxy:sendAppRequest(cb, arr);
	else
	
	end
end

--发送FEED 请求
function FacebookHandler.shareToFeed(cb, arr)
	if device.platform == "ios" then
		FacebookProxy:shareToFeed(cb, arr);
	else
	
	end
end