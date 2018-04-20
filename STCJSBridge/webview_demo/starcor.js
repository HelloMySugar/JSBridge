/**
 * Created by yongbai on 2016/10/31.
 * modify by xuelong on 2016/11/7. 基础函数增加配置依赖引入。
 * 当声明中模块未引入时，通过配置去进行引入，如果未配置，则通过log进行报错处理
 */
(function (window)
{
    var DEFAULT_TIMEOUT = 10000;
    var log_func = null;//自定义logo方法
    var log_switch = true;////日志模块，日志为最最基本模块，所以直接写在starcor里面
    var mod_container = {};//模块容器存放所有模块
    var mod_path_config = {};

    function add_mod(name, func, _ags)
    {
        var _new_mod = func.apply(window, _ags);
        if (typeof _new_mod !== "undefined")
        {
            //抽象了两层
            if( name === "page" )
            {
                Starcor[name] = _new_mod;
            }
            else
            {
                mod_container[name] = _new_mod;
            }
        }
        else
        {
            log("err", "starcor： '" + name + "' 模块返回值必须为object不能为undefined");
        }
    }

    /***
     * 往starcor上面定义新模块.或者定义挂着抽象静态方法。
     * @param name 要定义的模块名称
     * @param arr  定义模块依赖模块数组，没有依赖为空数组
     * @param func 定义模块函数，返回模块对象
     */
    function Starcor(name, arr, func)
    {
        if (arguments.length === 1)
        {
            if (mod_container[name])
            {
                return mod_container[name];
            }
            else
            {
                return null;
            }
        }
        else if (arguments.length === 3)
        {
            if (typeof mod_container[name] === "undefined" && typeof Starcor[name] === "undefined")
            {
                var _ags = [];
                for (var i = 0; i < arr.length; i++)
                {
                    var _tmp_name = arr[i];
                    var _tmp_mod = mod_container[_tmp_name]; //模块对象与函数相互互斥。
                    if (typeof _tmp_mod === "undefined")
                    {
                        req_mod(name, function (_name_, _arr_, _func_)
                        {
                            return function ()
                            {
                                Starcor(_name_, _arr_, _func_);
                            }
                        }(name, arr, func));
                        return;
                    }
                    _ags.push(_tmp_mod);
                }
                add_mod(name, func, _ags);
            }
            else
            {
                log("err", "starcor: '" + name + "'模块已经存在");
            }
        }
        else if( arguments.length === 2 && typeof arguments[1] === "function")
        {
            req_mod(name, function ()
            {
                var __o = starcor(name);
                arguments[1].call(__o);
            });
        }
        else
        {
            log("err", "starcor: 参数个数错误");
        }
    }

    /**
     * 标准库，模块配置设置函数，可以通过配置，进行模块依赖时的加载行为。
     * 增加该配置后，对于JS合并来说并没有什么好处。合并文件时，需要去修改对应的配置文件。
     * 如果不合并，对于按需进行加载模块来说，使用该种模式比较有效
     * @param config
     */
    Starcor.config = function (config)
    {
        mod_path_config = config || {};
        if( !mod_path_config.base_dir ) mod_path_config.base_dir = "/";
    }

    /**
     * 动态按需加载JS依赖模块，标准选择通过配置文件路径地址进行JS模块的加载，如果没有配置，则同级目录进行加载
     * @param mod_name 需要依赖的模块名
     * @param callback 回调函数
     */
    function req_mod(mod_name, callback)
    {
        //如果有配置，则通过配置去引入对应的模块JS。否则取页面同级目录进行JS的引入
        var __url = (mod_path_config[mod_name] && typeof mod_path_config[mod_name] == "string") ? mod_path_config[mod_name] : mod_path_config.base_dir+"starcor."+mod_name + ".js";
        load_js(__url, function (status)
        {
            if (status === "timeout")
            {
                log("err", "starcor：'" + name + "' 模块的依赖模块'" + _tmp_name + "'不存在");
            }
            else
            {
                callback();
            }
        });
    }

    /**
     * JS模块依赖，只会存在于JS文件，不会存在其他，所以该标准模块之中，只增加JS load的行为
     * 默认JS请求字符集都是UTF-8
     * @param url 需要加载的JS 路径地址
     * @param callback JS加载完成后执行的回调函数。
     */
    function load_js(url, callback)
    {
        var script_obj = document.createElement('script');
        script_obj.type = "text/javascript";
        script_obj.src = url;
        script_obj.charset = 'utf-8';
        var is_loaded = false;
        script_obj.onload = function (event)
        {
            clearTimeout(this._timeout_);
            if (!is_loaded)
            {
                document.head.removeChild(script_obj);
                is_loaded = true;
                callback();
            }
        };
        script_obj.onreadystatechange = function (event)
        {
            if (this.readyState == 'loaded')
            {
                document.head.removeChild(script_obj);
                clearTimeout(this._timeout_);
                if (!is_loaded)
                {
                    is_loaded = true;
                    callback();
                }
            }
        };

        script_obj._timeout_ = setTimeout(function ()
        {
            document.head.removeChild(script_obj);
            callback("timeout");
        }, DEFAULT_TIMEOUT);
        document.head.appendChild(script_obj);
        return script_obj;
    }

    //日志函数
    function log()
    {
        if (log_switch === false)
        {
            return;
        }
        if (typeof log_func === "function")
        {
            var ags = window.Array.prototype.slice.call(arguments);
            log_func(ags.join(","));
        }
        else if (window.console && typeof window.console.log === "function")
        {
            window.console.log.apply(window.console, arguments);
        }
        else
        {

        }
    }

    //打开日志
    log.open = function ()
    {
        log_switch = true;
    };
    //关闭日志
    log.close = function ()
    {
        log_switch = false;
    };
    //自定义logo
    log.define = function (func)
    {
        if (typeof func === "function")
        {
            log_func = func;
        }
    };
    mod_container.log = log;//starcor方法必须要先依赖一个简单日志模块，后面这个模块可以被重写
    window.starcor = Starcor;
})(window);

