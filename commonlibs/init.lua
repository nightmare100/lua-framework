--初始化         quick lua 加载完 先require这个


function reload(packageName)
	package.loaded[packageName] = nil;
	return require(packageName);
end



reload("config")
require("framework.init")
reload("commonlibs.Event")
reload("commonlibs.error.ErrorMap")
reload("commonlibs.constant.TouchProity");
reload("commonlibs.constant.GameTouchProity");
reload("commonlibs.constant.GameSpeedDefined");
reload("commonlibs.constant.DefaultKeyDefined");
reload("commonlibs.item.ItemType");--reload("commonlibs.constant.ItemType"); -- change by anson dec 13 after update of play

reload("commonlibs.event.GlobalEvent");
reload("commonlibs.event.AppEvent");


eventDispatcher = reload("framework.api.EventProtocol")

reload("commonlibs.extend.CocosExtend")

reload("commonlibs.utils.DateUtil")
reload("commonlibs.utils.NumberUtil")
reload("commonlibs.utils.UrlUtil")
reload("commonlibs.utils.PosHelper")
reload("commonlibs.utils.LuaHelper")
Tick = reload("commonlibs.tick.Tick")

LayerMgr = reload("commonlibs.managers.LayerManager")
reload("commonlibs.managers.ClientManager")
reload("commonlibs.managers.PopupManager")
reload("commonlibs.managers.AlertManager")
reload("commonlibs.managers.SoundManager")


reload("commonlibs.notify.NotifyDefined")
reload("commonlibs.notify.NotifyInfo")
reload("commonlibs.notify.NotifyProity")
reload("commonlibs.notify.NotifyType")

reload("commonlibs.managers.CCNotifyListener")
reload("commonlibs.managers.NotifyManager")
reload("commonlibs.extend.ui.layout.ScrollLayerOut")

--全局事件派发器 目前用于大厅事件 和 命令
GlobalDispatcher = reload("commonlibs.desine.CommandDispatcher").new()


serverJsonConnection = reload("commonlibs.net.HttpServerConnection").new()
jsonParse = reload("framework.json")

reload("commonlibs.net.filedownload.FileDownLoadManager")

Store = require("framework.api.Store")

require("commonlibs.ccb.CCBReaderLoad");
require("commonlibs.csvsupport.csv");
CCB_CELL = require("commonlibs.ccb.CCBCell");
CCB_POPUP = require("commonlibs.ccb.CCBPopUpViewController");