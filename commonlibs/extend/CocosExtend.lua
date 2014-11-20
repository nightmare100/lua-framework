--对cocos 节点功能扩展
require("commonlibs.extend.event.ExtendEvent")
require("commonlibs.extend.event.ViewEvent")


function CCNodeExtend:setCustomPosition(fileName)
	local scale =  CCDirector:sharedDirector():getContentScaleFactor()
	if GamePosInfo and GamePosInfo[fileName] ~= nil then
		self:setPosition(display.cx + GamePosInfo[fileName].x / scale , display.cy + GamePosInfo[fileName].y / scale)
	elseif SlotGamePosInfo and SlotGamePosInfo[fileName] ~= nil then
		self:setPosition(display.cx + SlotGamePosInfo[fileName].x / scale , display.cy + SlotGamePosInfo[fileName].y / scale)
	end
end

function CCNodeExtend:getCustomPosition(name)
	if GamePosInfo and GamePosInfo[name] ~= nil then
		return GamePosInfo[name]
	elseif SlotGamePosInfo and SlotGamePosInfo[name] ~= nil then
		return SlotGamePosInfo[name]
	end
	
	return nil
end


function CCNodeExtend:getWidth(useCascadeBoundingBox)
	if useCascadeBoundingBox then
		local rect = self:getCascadeBoundingBox()
		return rect.size.width;
	else

		local size = self:getContentSize();
		if size then
			return size.width
		else 
			return 0;
		end
	end
end

function CCNodeExtend:getTickID()
	if not self.tickID then
		self.tickID =  require("socket").gettime();
	end
	return self.tickID;
end


function CCNodeExtend:setWidth(val)
	local size = self:getContentSize();
	if size then
		self:setContentSize(CCSizeMake(val, self:getHeight()))
	end
end

function CCNodeExtend:setHeight(val)
	local size = self:getContentSize();
	if size then
		self:setContentSize(CCSizeMake(self:getWidth(), val))
	end
end

function CCNodeExtend:registerNodeEvent()
	self:setNodeEventEnabled(true);
end

function CCNodeExtend:getHeight(useCascadeBoundingBox)
	if useCascadeBoundingBox then
		local rect = self:getCascadeBoundingBox()
		return rect.size.height;
	else
		local size = self:getContentSize();
		if size then
			return size.height
		else 
			return 0;
		end
	end
end

--[[
	以上代码简写
]]

--for label text
function CCNodeExtend:customAlign( x, y)
	if self.cuAlign == ui.TEXT_ALIGN_LEFT then
        self:setPosition(x + math.round(self:getContentSize().width / 2), y)
    elseif self.cuAlign == ui.TEXT_ALIGN_RIGHT then
        self:setPosition(x - math.round(self:getContentSize().width / 2), y)
    else
        self:setPosition(x, y)
    end
end

--修改layer扩展 保证多点触摸 只有一个可操作layer受响应
--function CCLayerExtend:addTouchEventListener(listener, isMultiTouches, priority, swallowsTouches)
--    if type(isMultiTouches) ~= "boolean" then isMultiTouches = false end
--    if type(priority) ~= "number" then priority = 0 end
--    if type(swallowsTouches) ~= "boolean" then swallowsTouches = false end
--    local emptyFunc = function() end
--    
--    if isMultiTouches then
--    	self:registerScriptTouchHandler(function(event, touchs) 
--    		if event == "began" then
--    			if MUTPLE_TOUCH_OBJECT and MUTPLE_TOUCH_OBJECT ~= self then
--    				return emptyFunc()
--    			else
--    				local customFunc = function()
--    					local isBegan = listener(event, touchs)
--    					if  isBegan then
--    						MUTPLE_TOUCH_OBJECT = self
--    					else
--    						MUTPLE_TOUCH_OBJECT = nil
--    					end
--    				end
--    				return customFunc()
--    			end
--    		end
--    		
--    		if event == "ended" and MUTPLE_TOUCH_OBJECT == self then
--    			MUTPLE_TOUCH_OBJECT = nil
--    		end
--    	
--    		return listener(event, touchs)
--    	end, isMultiTouches, priority, swallowsTouches)
--    else
--    	self:registerScriptTouchHandler(listener, isMultiTouches, priority, swallowsTouches)
--    end
--end
setmetatable(CCSpriteExtend, CCNodeExtend)
setmetatable(CCLayerExtend, CCNodeExtend)

cocoExtend = {};

function cocoExtend.newSprite(fileName, x, y, isRelative,condFileName)
	local spr = require("commonlibs.extend.display.BaseSprite").new(fileName, x, y, isRelative,condFileName)
	return spr
end

function cocoExtend.newScale9Sprite(fileName, x, y)
	local spr = require("commonlibs.extend.display.BaseScale9Sprite").new(fileName, x, y)
	return spr
end

function cocoExtend.newEditBox(parmas)
	local spr = require("commonlibs.extend.ui.BaseEditBox").new(parmas)
	return spr
end

function cocoExtend.newImageMenuItem(parmas)
	local spr = require("commonlibs.extend.ui.BaseImageMenu").new(parmas)
	return spr
end

function cocoExtend.newTTFLabel(parmas)
	local spr = require("commonlibs.extend.ui.BaseTTFLabel").new(parmas)
	return spr
end

function cocoExtend.newBMFontLabel(parmas)
	local spr = require("commonlibs.extend.ui.BaseBmLabel").new(parmas)
	return spr
end


function cocoExtend.newShandowTTFLabel(parmas)
	local spr = require("commonlibs.extend.ui.BaseTTFShandowLabel").new(parmas)
	return spr
end



function cocoExtend.newMenu(items, proity)
	local menu = ui.newMenu(items)
	if proity then
		menu:setTouchPriority(proity);
	end
	return menu
end

-- old version compact--
display.newBackgroundSprite = function(file)
	local spr = display.newSprite(file);
	spr:setPosition(display.cx, display.cy);
	return spr;
end

display.newAnimate = function(animation)
	return CCAnimate:create(animation);
end

display.newFrame = display.newSpriteFrame;

--------------------------


UI_ScrollView = require("commonlibs.extend.ui.scroll.ScrollView")
UI_ListView = require("commonlibs.extend.ui.layout.ListView")
UI_PageControl = require("commonlibs.extend.ui.scroll.PageControl")
UI_ScrollViewCell = require("commonlibs.extend.ui.scroll.ScrollViewCell")
UI_ScrollPageView = require("commonlibs.extend.ui.scroll.ScrollPageView");
UI_RadioGroup = require("commonlibs.extend.ui.button.RadioGroup")
UI_CheckBoxGroup = require("commonlibs.extend.ui.button.CheckBoxGroup")
UI_RadioButton = require("commonlibs.extend.ui.button.RadioButton")
UI_CheckButton = require("commonlibs.extend.ui.button.CheckBoxButton")
UI_SimpleProgressBar = require("commonlibs.extend.ui.SimpleProgressBar")
UI_SwitchButton = require("commonlibs.extend.ui.button.SwitchButton")
UI_PressButton = require("commonlibs.extend.ui.button.PressButton")
UI_HoldButton = require("commonlibs.extend.ui.button.HoldButton")
UI_RadioGroupMenu = require("commonlibs.extend.ui.button.RadioGroupMenu");

DISPLAY_MOVIECLIP = require("commonlibs.extend.display.MovieClip")
DISPLAY_BASESCENE = require("commonlibs.extend.display.BaseScene")
DISPLAY_BASEVIEW = require("commonlibs.extend.display.BaseView")
DISPLAY_BASEMESSAGEVIEW = require("commonlibs.extend.display.BaseMessageView")
DISPLAY_BITMAP_PROXY = require("commonlibs.extend.display.WebBitmapProxy")
DISPLAY_GAMELAYER = require("commonlibs.managers.layer.GameLayer");
DISPLAY_MASKLAYER = require("commonlibs.managers.layer.MaskLayer");


CONTROL_NUMERICCONTROL = require("commonlibs.extend.ui.control.NumericControl")
CONTROL_METERWORD = require("commonlibs.extend.ui.control.MeterWord");