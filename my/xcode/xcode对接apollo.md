## cte配置

1. 抽出setting

   1. 配置项归类结构体

2. 去掉无效代码

   1. config.xml. config.res

   2. CONF_****

      

```c
struct system{
    g_daemonize = 1;
      <Path>/CTEConfig/Server/Public/Daemonize</Path>
        <Comment>is program run on background  0: not run on background 1: run on background</Comment>
        <Default>1</Default>

	g_imedia_log_level = INFORMATIONAL;
        <Path>/CTEConfig/Server/Log/iMediaLogLevel</Path>
        <Comment>the lowest log level to print, 0:DEBUG 1:INFORMATIONAL 2:WARNING  3:ERRING</Comment>
        <Default>1</Default>

}

g_iframe_intervel = 5;	
        <Path>/CTEConfig/Server/Public/IFrameInterval</Path>
        <Comment>i frame interval for offline transcode task, range 1~60, default:5</Comment>
        <Default>5</Default>

g_h264_conf_switch = 0;	// 废弃
g_h264_conf_switch = 0;	// 废弃
g_h265_conf_switch = 0;// 废弃
g_encry_comm_switch = 0;// ctm与cte加密通道，建议去掉
g_encry_media_switch = 1;// 加密由任务参数控制，没必要再加一个开关
g_media_prev_switch = 0;
        <Path>/CTEConfig/Server/Public/MediaPrevSwitch</Path>
        <Comment>media data preview switch, range 0: close 1:open, default:0</Comment>
        <Default>1</Default>
g_imedia_cpu_core_num = 4; //若获取获取CPU默认核数失败, 则取改值，用于初始化imedia
        <Path>/CTEConfig/Server/Public/TransCoreNum</Path>
        <Comment>cpu core number reserved for imedia transcode process, range 1~65535, default:4</Comment>
        <Default>4</Default>

g_ftp_download_timeout = 10;// 废弃
g_task_retry_switch = 1; // 重试开关，ctm重试次数可配，建议去掉
	<Path>/CTEConfig/Server/Public/TaskRetrySwitch</Path>
	<Comment>task failed need retry switch,0: close  1: open default:1</Comment>
	<Default>1</Default>

g_dash_encry_data_size = 104857600;// 100M Dash单次加密数据块大小
       <Path>/CTEConfig/Server/Public/PerDashEncryDataSize</Path>
        <Comment>dash data encrypt block size in Bytes, range 1~4294967295, default:100MB</Comment>
        <Default>104857600</Default>

g_dash_encry_perf_switch = 1;
        <Path>/CTEConfig/Server/Public/HighPerformanceSwitch</Path>
        <Comment>dash data encrypt high performance switch, range 0: close 1:open, default:1</Comment>
        <Default>1</Default>

g_support_remove_switch = 1;
        <Path>/CTEConfig/Server/Public/SupportRemove</Path>
        <Comment>cte support remove task, default:1</Comment>
        <Default>1</Default>

g_read_write_timeout = 120;
        <Path>/CTEConfig/Server/Public/RWtimeout</Path>
        <Comment>read/write thread timeout limit, range 5~120, default:120</Comment>
        <Default>120</Default>

g_ringbuf_switch = 300; // 开关阈值，命名不好
        <Path>/CTEConfig/Server/Public/RingbufSwitch</Path>
        <Comment>default ringbuf switch size(MB), range 1~1024, default:300</Comment>
        <Default>300</Default>

g_ringbuf_size = 120;
        <Path>/CTEConfig/Server/Public/RingbufSize</Path>
        <Comment>default ringbuf total size(MB), range 5~200, default:80</Comment>
        <Default>120</Default>

g_ringbuf_write_threshold = 80;
        <Path>/CTEConfig/Server/Public/RingbufWriteThreshold</Path>
        <Comment>default ringbuf write threshold(percentage), range 20~100, default:50</Comment>
        <Default>80</Default>


g_obs_upload_acl = 5;
        <Path>/CTEConfig/Server/OBS/UploadObjectAcl</Path>
        <Comment>default obs upload object canned acl, 0:private, 1:public-read, 2:public-read-write, 3:authenticated-read, 4:bucket-owner-read, 5:bucket-owner-full-control, 6:log-delivery-write,  default:5</Comment>
        <Default>5</Default>

g_obs_retry_times = 5;
        <Path>/CTEConfig/Server/OBS/UploadObjectAcl</Path>
        <Comment>default obs upload object canned acl, 0:private, 1:public-read, 2:public-read-write, 3:authenticated-read, 4:bucket-owner-read, 5:bucket-owner-full-control, 6:log-delivery-write,  default:5</Comment>
        <Default>5</Default>

g_obs_lowBitRate_timeout = 120;
        <Path>/CTEConfig/Server/OBS/LowBitRateTimeout</Path>
        <Comment>default obs timeout(s) less than 1KB/s, range 0~300, default:120</Comment>
        <Default>120</Default>

g_obs_upload_part_size = 30; 
        <Path>/CTEConfig/Server/OBS/UploadPartSize</Path>
        <Comment>default obs upload part size(MB), range 5~500, default:30</Comment>
        <Default>30</Default>

g_nal_length_size = 4; // 废弃
g_enc_iv_length = 16;// 废弃
g_cenc_enc_switch = 1;
        <Path>/CTEConfig/Server/Public/CencSwitch</Path>
        <Comment>cenc encryption switch, range {0, 1}, default:1</Comment>
        <Default>1</Default>

g_irdeto_debug = 0; // 数字水印可视开关
        <Path>/CTEConfig/Server/Public/IrdetoDebug</Path>
        <Comment>Irdeto Debug 0 close 1 open</Comment>
        <Default>0</Default>

g_xformat_timeout = 3600;
        <Path>/CTEConfig/Server/Public/XformatTimeout</Path>
        <Comment>default xformat timeout(s), range 60s~36000s, default:3600</Comment>
        <Default>3600</Default>



0513：
1. 有些配置还没补齐，例如nfs地址，log配置
2.http等一些环境变量也用apollo配置
3.守护进程开关
4.动态配置？不做了吧

1.cte访问华东apollo首次会失败，需要重试
2.为了方便调试，CTM和CTE地址优先取环境变量：
HTTP_SERVER_IP 		 //default：0.0.0.0
HTTP_SERVER_PORT，	//default：16703
CTM_SERVER_IP，		//default：0.0.0.0
CTM_SERVER_PORT		 //default：16710

export APOLLO_ADDRESS="http://119.3.74.169:8080" //apollo地址为空或者连不上，则使用默认配置
export APOLLO_APPID="xcode" 	// default: "xcode"
export APOLLO_NAMESPACENAME="application" // default："application"
exprot APOLLO_CLUTER="cte"            // default: "cte" 

3.mpc6的apollo不支持动态配置通知接口，华东的apollo支持
4.动态配置逻辑：一次性初始化使用的配置没有动态配置，例如ctm地址，cte地址，其他支持
```
