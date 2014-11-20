--Mason
--图片文件下载器
FileDownLoadManager = {}

--保存一个Web图片 callback 图片保存完成时回调callBack({fileName = xxx, url = xxx})
function FileDownLoadManager:saveFile(url, callBack)
	if not self.fileMgr then
		self.fileMgr = WebPictureDownload:new(CACHE_DIRCTORY);
	end 

	local tempIdx = string.find(url, "?");
--	print(string.format("saveFileUrl:%s", url));
	
	local tempUrl = string.sub(url, 1, tempIdx and (tempIdx - 1) or -1);
	local s,e = string.find(tempUrl, "/[%w_]*%.[%w_]*$");
	s = s and (s + 1) or 1;
	e = e and e or -1;
	local name = string.sub(tempUrl, s, e);
	if name == tempUrl then
		name = crypto.md5(name);
		name = string.sub(name,1, 8) .. ".png";
	end
	
	if not self.maps then
		self.maps = {}
	end
	if tempIdx then
		url = url .. "&ra=" .. math.random(); 
	else
		url = url .. "?ra=" .. math.random();
	end
	self.maps[url] = {callBack, name};
	
	self.fileMgr:saveWebImage(url, name, handler(self, self.onLoad));
	return url;
end

function FileDownLoadManager:onLoad(event)
	if self.maps[event.url] then
		self.maps[event.url][1](event);
		self.maps[event.url][1] = nil;
	else
		for k,v in pairs(self.maps) do
			if v[2] == event.fileName then
				v[1](event);
			end
		end
	end
end

function FileDownLoadManager:removeKey(url)
	self.maps[url] = nil;
end