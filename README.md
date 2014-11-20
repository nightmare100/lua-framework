lua-framework
=============

lua framework for cocos

				
				
			

commonlibs -> init  	初始化类库引入类包	
		   -> ccb  		cocosbuilder UI相关封装
					   CCBCell  	cocosbuild 元素
					   CCBPopUpViewController:CCBCell	cocosbuilder弹窗
		   ->constant   各类常量定义
		   ->csvsupport  自写csv 读表支持
		   ->data		一些数据模型
		   ->desine 	命令模式 基类 and 派发器
		   ->error		错误常量定义
		   ->event		事件常量定义
		   ->extend 	cocos2dx ui扩展
		   		->display 	基础面板扩展  BaseMessageView(弹窗面板基类):BaseView(普通面板基类)
		   					远程图片加载器(容器 远程代理) WebBitmapProxy
		   		->event ui相关事件
		   		->ui     一些UI组件 扩展
		   			->layout布局器
		   			->scroll 各种支持滚动的自定义控件。
		   			->button 各种扩展的按钮 
		   			SimpleProgresssBar 建议进度条组件
		   ->item 		游戏物品相关
		   		->Inventory  物品迭代器
		   ->managers	层级管理 系统管理 和 model 管理
		   		->AlertManager 	系统级弹窗管理 
		   		->CCNotifyListener 监听设备前后台切换
		   		->ClientManager  记录客户端相关内容
		   		->ItemManager		物品管理 (派发物品变更 等事件)
		   		->MainPushNotifyManager  IOS通知中心接口管理
		   		->NotifyManager 	各种消息管理 (界面 消息 聊天消息  等  观察者模式)
		   		->PopupManager		弹窗管理 (接口封装)
		   		->SoundManager		声音管理。
		   	-> mvc		puremvc lua实现
		   		任何面板 使用MvcView.extend 扩展后  即可使用 puremvc框架事件
		   	-> net 		网络通信
		   		->filedownload 文件下载管理
		   		->parse 	协议解析器 (可按 协议号 RPC名等 自定义 解析类 )
		   			->CardGameParse 	socket 卡牌游戏 解析器
		   			->JsonDataParse 	普通Json格式协议解析器
		   			->PbDataParse		PB协议解析器
		   		->socket		socket 收发器(实现观察者)
		   		->HttpServerConnection		http 收发器(实现观察者)
		   	->notify 	消息定义 对应NotifyManager
		   	->pbc 		谷歌PB协议支持
		   	->tick		定时器类 和 事件格式解析器
		   	->utils		各种辅助方法类封装
