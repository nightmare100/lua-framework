--Mason
--lua audio 类 功能还是太简陋 所以再封一层
SoundMgr = {}
SoundMgr.cache = {}
function SoundMgr.enable()
	audio.setSoundsVolume(1)
	audio.setMusicVolume(1)
	audio.resumeBackgroundMusic();
end

function SoundMgr.disable()
	audio.setSoundsVolume(0)
	audio.setMusicVolume(0)
	if audio.isMusicPlaying() then
		audio.pauseBackgroundMusic();
	end
	audio.stopAllSounds();
end

function SoundMgr.preLoad(sound, key, type)
	SoundMgr.cache[key] = {path = sound, type = type}
	if type == 1 then
		--背景
--		audio.preloadMusic(sound);
	else
		--音效
		audio.preloadEffect(sound);
	end
end

function SoundMgr.unload(key)
	local sound = SoundMgr.cache[key];
	if sound and sound.type == 2 then
		audio.unloadEffect(sound.path);
	end
end

function SoundMgr.unloadAllSound()
	for k, v in pairs(SoundMgr.cache) do
		if v.type == 2 then
			audio.unloadEffect(v.path);
		end
	end
	audio.stopMusic(true);
end

function SoundMgr.playSound(key, isLoop)
	local sound = SoundMgr.cache[key];
	if sound then
		if sound.type == 2 then
			sound.uid = audio.playEffect(sound.path, isLoop);
		else
			audio.playBackgroundMusic(sound.path, isLoop);
		end
	end
end

--直接播放
function SoundMgr.playSoundDirect(url, isbg)
	if isbg then
		audio.playBackgroundMusic(url, true);
	else
		audio.playEffect(url, false);
	end
end

function SoundMgr.stopSound(key)
	local sound = SoundMgr.cache[key];
	if sound then
		if sound.type == 2 then
			if sound.uid then
				audio.stopEffect(sound.uid);
			end
		else
			audio.stopBackgroundMusic(true);
		end
	end
end

function SoundMgr.getSoundPath(key)
	local sound = SoundMgr.cache[key];
	return sound and sound.path or "";
end

--todo be added