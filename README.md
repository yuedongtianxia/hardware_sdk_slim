#悦动圈硬件开放平台轻量版SDK
##背景&目的
现有基于插件化方式，接入一款新硬件需要硬件厂商基于sdk对现有App进行裁剪修改、与我们联调测试，双方需要开发量依然很大。  
所以提出新的方案，更加开放，同时接入新硬件双方需要的开发量更少，联调更快
##架构思想
硬件商自主App上增加想悦动圈请求授权操作，获得授权之后，每次在他们同步硬件数据的时候调用sdk向悦动圈写入数据
##使用准备
需要提前向悦动圈申请Appid，用以授权等操作

##Android sdk
###YDHardwareSDK
主要操作类

    YDHardwareSDK
	    public static YDHardwareSDK instance() 
    	获取sdk单例
    	
	    public void config(Context appContext, String appId)
    	首次使用需要进行配置，设置appContent,appId
	    
	    public SDKStatus getStatus()
    	获取sdk授权状态
	    
	    public void tryAuth(Activity activity, int requestCode, YDHardwareAuthListener listener)
    	尝试拉取授权，如果安装悦动圈会跳转到悦动圈App进行授权，否则会跳转悦动圈网页，引导下载
	    
	    public void onActivityResult(int requestCode, int resultCode, Intent data)
	    在进行授权的Activity需要在onActivityResult中调用sdk的该方法，用于获取授权结果
    	
    	public boolean insertRecord(String did, int stepCount, float disM, int calorie, long startTimeMs, long endTimeMs)
	    插入计步数据，需要授权之后才能进行
    	
    	public YDRecordSyncTool getSyncTool()
	    获取同步工具类
    
    SDKStatus sdk授权状态 
    	有三种状态  kUnAuthenticate(0),未授权 kAuthenticated(1),已授权 kExpiration(2); 授权过期
    
    YDHardwareAuthListener 授权回调
    	void onYDAuthFail(String errorMsg);
	    void onYDAuthSucc();
    	void onYDAuthUserCancel();
	
	YDRecordSyncTool 数据同步工具类
	public boolean needInit() 
	判断是否需要初始化
	public void init(YDNetInterface netInterface)
	进行初始化操作
	public void trySyncRecords(YDRecordSyncCallback callback)
	尝试进行同步数据，操作结果会通过callback回调
	
	YDNetInterface 网络操作接口 异步
	设计目的，未避免sdk中插入网络框架等，将网络操作提炼未一个接口，由接入sdk方基于原有网络框架实现
	Cancelable asyncPost(String url, HashMap<String, String> params, YDNetCallback callback);
	
	YDNetCallback 网络操作回调接口
    void onNetFinished(int code, JSONObject netRes, String errorMsg);