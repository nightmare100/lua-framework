--Url管理

UrlUtil = {};
UrlUtil.FaceBookHeaderUrl = "http://graph.facebook.com/";
UrlUtil.HeadSquare = "square";		--50 x 50
UrlUtil.HeadSmall = "small";
UrlUtil.HeadNormal = "normal";		-- 100 x 100
UrlUtil.HeadLarge = "large";		-- near 200 x 200

function UrlUtil.getFaceBookHeaderUrl(playId, type)
	if not type then
		type = UrlUtil.HeadSquare;
	end
 	return UrlUtil.FaceBookHeaderUrl .. playId .. "/picture?type=" .. type;
end

function UrlUtil.getRemoteAssetUrl(itemPath)
	return RemoteAsset .. CURRENT_LANG .. itemPath .. "?version=" .. ClientManager.version; 
end

function UrlUtil.getFileName(name)
	local arr = string.split(name, "/")
	return arr[#arr];
end