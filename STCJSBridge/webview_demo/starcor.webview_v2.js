/**
 * Created by 15196 on 2017/5/26.
 */
starcor("Webview",["log"],function (log)
{
    var oldStarcorExt = window.starcorExt || {};
    var Webview = {};
    var starcorExt = {
        _execFunc: function(func,args) {
            // APK的版本由于以前的老标准使用的方法为_execAndroidFunc,但不影响整理的交互逻辑。做兼容处理
            if (typeof oldStarcorExt._execFunc === "function")
            {
                return oldStarcorExt._execFunc(func,args);
            }
            else
            {
                return oldStarcorExt._execAndroidFunc(func,args);
            }
        }
    };
    var callbacks = {};
    var callback_counter = 0;
    function addCallback(callback)
    {
        var callbackIdx = String(callback_counter++);
        callbacks[callbackIdx] = callback;
        return callbackIdx;
    }

    /**
     * 生成参数
     * @param type 事件类型
     * @param value 参数
     * @param callbackidx 回调索引
     */
    function factory_value(type,value,callbackidx)
    {
        var arr = [];
        arr.push({
            type : "string",
            value : type
        });
        arr.push({
            type : "object",
            value : value || {}
        });
        if(callbackidx)
        {
            arr.push({
                type : "callback",
                value : callbackidx
            });
        }
        return JSON.stringify(arr);
    }
    starcorExt._invokeCallback = function (name, data, callbackidx)
    {
        $("show_c").innerHTML += "_invokeCallback-----------：name="+name+";data="+data+";callbackidx="+callbackidx+"</br>";
        var func = callbacks[name];
        if (typeof func == "function")
        {
            func(data, function(data){
                if(typeof data == "object")
                {
                    data = JSON.stringify(data);
                }
                return starcorExt._execFunc(callbackidx,data);
            });
        }
    };
    // 打开子浏览器（弹出方式）
    // 同时只能打开一个子浏览器
    Webview.openBrowser = function (url)
    {
        return starcorExt._execFunc("openBrowser", url);
    };
    // 关闭浏览器或浏览器所在的页面
    Webview.closeBrowser = function (reason)
    {
        return starcorExt._execFunc("closeBrowser", reason || "");
    };
    //获取token信息
    Webview.getTokenInfo = function ()
    {
        return starcorExt._execFunc("getTokenInfo");
    };
    //获取终端同步时间
    Webview.getServerTime = function ()
    {
        return starcorExt._execFunc("getServerTime");
    };
    //获取N1下行参数
    Webview.getEpgInterfaceData = function ()
    {
        return starcorExt._execFunc("getEpgInterfaceData");
    };
    //读取系统属性
    Webview.readSystemProp = function (propName)
    {
        return starcorExt._execFunc("readSystemProp", propName);
    };
    //发送广播
    Webview.sendBroadcast = function (params)
    {
        return starcorExt._execFunc("sendIntent", factory_value("sendBroadcast",params));
    };
    //跳转页面
    Webview.startActivity = function (params)
    {
        return starcorExt._execFunc("sendIntent", factory_value("startActivity",params));
    };
    //启动服务
    Webview.startService = function (params)
    {
        return starcorExt._execFunc("sendIntent", factory_value("startService",params));
    };
    //设置消息通知回调
    Webview.setMessageHandler = function (data, callback)
    {
        starcorExt._execFunc("setHandler",  factory_value("Message",data,addCallback(callback)));
    };
    //设置第三方登录回调
    Webview.setThirdLoginHandler = function (data, callback)
    {
        starcorExt._execFunc("setHandler", factory_value("thirdLogin",data,addCallback(callback)));
    };
    //登录成功发送消息到终端
    Webview.onLoginSendMessage = function (params)
    {
        starcorExt._execFunc("sendMessage", factory_value("onLogin",params));
    };
    //订购成功发送消息到终端
    Webview.onPurchasesSendMessage = function (params)
    {
        starcorExt._execFunc("sendMessage", factory_value("onPurchases",params));
    };
    Webview.resizeBrowser = function (width,height)
    {
        var params = {
            width:width,
            height:height
        };
        starcorExt._execFunc("resizeBrowser",JSON.stringify(params));
    };
    window.starcorExt = starcorExt;
    return Webview;
});