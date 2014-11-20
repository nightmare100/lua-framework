-- 错误定义
ErrorMap = {}

--无措
ErrorMap.NO_ERROR = 1;

--培养潜力不够
ErrorMap.NOT_ENOUGH_CAPACITY = 90006;

--培养丹不足
ErrorMap.NOT_ENOUGH_ITEM = 90007;

--进阶没有足够的材料
ErrorMap.ADV_NOT_ENOUGH_ITEM = 90008;

--传功错误
ErrorMap.NOT_ENOUGH_EXP = 90002;
ErrorMap.NOT_ENOUGH_DIMAOND = 90003;

--装备相关
ErrorMap.ERR_EQUIP_LEVEL_IS_HEIGHTEST = 10003
ErrorMap.ERR_GOLD_LESS = 100
ErrorMap.ERR_ITEM_IS_NOT_EXISTS = 202
ErrorMap.ERR_STAR_IS_MAX_VAL = 103
ErrorMap.ERR_DIAMOND_LESS = 101
ErrorMap.ERR_SYNTHESIS_CARD_LESS_MATERIAL = 30000

ErrorMap.ERR_EQUIP_LEVEL_NO_MORE_THAN_PLAYRE_LEVEL = 10000
ErrorMap.ERR_TEMP_SYNTHESIS_IS_NOT_EXISTS = 304

ErrorMap.ERR_MSG = {}
ErrorMap.ERR_MSG[ErrorMap.ERR_GOLD_LESS] = "金币不足"
ErrorMap.ERR_MSG[ErrorMap.ERR_EQUIP_LEVEL_IS_HEIGHTEST] = "装备已达最高等级"
ErrorMap.ERR_MSG[ErrorMap.ERR_ITEM_IS_NOT_EXISTS] = "道具不存在"
ErrorMap.ERR_MSG[ErrorMap.ERR_STAR_IS_MAX_VAL] = "已达最高星级"
ErrorMap.ERR_MSG[ErrorMap.ERR_DIAMOND_LESS] = "钻石不足"
ErrorMap.ERR_MSG[ErrorMap.ERR_SYNTHESIS_CARD_LESS_MATERIAL] = "材料不足"
ErrorMap.ERR_MSG[ErrorMap.ERR_EQUIP_LEVEL_NO_MORE_THAN_PLAYRE_LEVEL] = "装备不能超过玩家等级"
ErrorMap.ERR_MSG[ErrorMap.ERR_TEMP_SYNTHESIS_IS_NOT_EXISTS] = "卡牌合成材料配置表不存在，该装备不能进阶"
ErrorMap.ERR_MSG[ErrorMap.NOT_ENOUGH_CAPACITY] = "潜力点不够"
ErrorMap.ERR_MSG[ErrorMap.NOT_ENOUGH_ITEM] = "培养丹不足"

ErrorMap.ERR_MSG[ErrorMap.NOT_ENOUGH_EXP] = "经验不足"
ErrorMap.ERR_MSG[ErrorMap.NOT_ENOUGH_DIMAOND] = "钻石不足"

function ErrorMap.getMsgByCode(code)
	local msg = ErrorMap.ERR_MSG[code]
	if not msg then
		return "未知错误"
	else
		return msg
	end
end