# DWD

## 精准曝光表dwd_evt_hispace_exposure_log_hm 

## 下载安装表 dwd_evt_hispace_down_install_log_hm

## 精准爆光表 dwd_evt_hispace_exposure_log_hm

## 广告话单表 dwd_cam_adv_bill_log_hm

## APP信息表 dwd_onl_disting_ver_app_ds



# search

ads_noah_searchadv_prepare2train_first_common_dm.sh

## ads_noah_searchadv_prepare2train_first_common_dm



```sql
CREATE EXTERNAL TABLE IF NOT EXISTS biads.$tabname
(
    imei                       STRING COMMENT  '设备编号'
   ,search_words               STRING COMMENT  '搜索词'
   ,app_id                     STRING COMMENT  '应用编号'
   ,app_name                   STRING COMMENT  '应用名称'
   ,app_type                   STRING COMMENT  '应用类型'
   ,third_tag                  STRING COMMENT  '三级标签'
   ,app_tags                   STRING COMMENT  '应用标签'
   ,dev_up_id                  STRING COMMENT  '开发者编号'
   ,dlnum                      STRING COMMENT  '下载量'
   ,position                   STRING COMMENT  '位置'
   ,list_id                    STRING COMMENT  '榜单编号'
   ,oper_time                  STRING COMMENT  '操作时间'
   ,oper_src                   STRING COMMENT  '操作来源'
   ,hispace_oper_type_cd       STRING COMMENT  '应用市场操作类型代码'
   ,city                       STRING COMMENT  '城市'
   ,device                     STRING COMMENT  '机型'
   ,click_app_list             STRING COMMENT  '点击列表'
   ,down_app_list              STRING COMMENT  '下载列表'
   ,use_app_list               STRING COMMENT  '使用字段'
   ,ext_field                  STRING COMMENT  '扩展字段'
   ,click_app_type_oneweek     STRING COMMENT  '过去一周点击应用类型'
   ,click_app_list_oneweek     STRING COMMENT  '过去一周点击应用列表'
   ,down_app_type_oneweek      STRING COMMENT  '过去一周下载应用类型'
   ,down_app_list_oneweek      STRING COMMENT  '过去一周下载应用列表'
   ,down_app_type              STRING COMMENT  '过去两周下载应用类型'
   ,click_app_3rd_oneweek      STRING COMMENT  '过去一周点击应用三级分类'
   ,down_app_3rd_oneweek       STRING COMMENT  '过去一周下载应用三级分类'
   ,down_app_3rd               STRING COMMENT  '过去两周下载应用三级分类'
)
COMMENT '搜索推广精准曝光客户端下载去重表'
PARTITIONED BY(pt_d STRING)
ROW FORMAT DELIMITED FIELDS TERMINATED BY '\001'
LINES TERMINATED BY '\n'
STORED AS ORC
LOCATION 'hdfs://nsads2/AppData/BIProd/ADS/AdsNoah/SearchAdv/$tabname'
TBLPROPERTIES('orc.compress'='ZLIB');
```



```sql
INSERT OVERWRITE TABLE biads.$tabname PARTITION(pt_d='$date')
SELECT
    t_exposure_download.imei as exposure_imei
   ,t_exposure_download.search_words as exposure_search_words
   ,t_exposure_download.app_id as exposure_app_id
   ,t_app.app_cn_name as app_name
   ,t_app.app_type as app_type
   ,t_app.third_app_type as third_app_type
   ,t_app.app_tags as app_tags
   ,t_app.dev_up_id as dev_up_id
   ,t_app.last14days_download_num as last14days_download_num
   ,t_exposure_download.position as exposure_position
   ,t_exposure_download.list_id as list_id
   ,t_exposure_download.oper_time as exposure_oper_time
   ,t_exposure_download.oper_src as exposure_oper_src
   ,t_exposure_download.hispace_oper_type_cd as exposure_oper_type
   ,t_user.city as city
   ,t_user.device_name as device_name
   ,t_user.click_app_list_twoweek as click_app_list_twoweek
   ,t_user.down_app_list_twoweek as down_app_list_twoweek
   ,t_user.use_app_list_twoweek as use_app_list_twoweek
   ,t_exposure_download.ext_field as exposure_exfield
   ,t_user.click_app_type_oneweek as click_app_type_oneweek
   ,t_user.click_app_list_oneweek as click_app_list_oneweek
   ,t_user.down_app_type_oneweek as down_app_type_oneweek
   ,t_user.down_app_list_oneweek as down_app_list_oneweek
   ,t_user.down_app_type_twoweek as down_app_type
   ,t_user.click_third_app_list_oneweek as click_third_app_list_oneweek
   ,t_user.down_third_app_list_oneweek as down_third_app_list_oneweek
   ,t_user.down_third_app_list_twoweek as down_third_app_list_twoweek
FROM
(
    SELECT
        exposure_imei as imei
        ,exposure_search_words as search_words
        ,exposure_app_id as app_id
        ,exposure_position as position
        ,exposure_list_id as list_id
        ,max(exposure_oper_time) as oper_time
        ,exposure_oper_src as oper_src
        ,exposure_oper_type as hispace_oper_type_cd
        ,max(exposure_exfield) as ext_field
    FROM ads_noah_searchadv_exposure_client_download_distinct_dm
    WHERE pt_d=$date AND download_flag='0'
    GROUP BY exposure_imei,exposure_search_words,exposure_app_id,exposure_position,exposure_list_id,exposure_oper_src,exposure_oper_type
    UNION ALL
    SELECT
         download_imei as imei
        ,download_search_words as search_words
        ,download_app_id as app_id
        ,download_position as position
        ,download_list_id as list_id
        ,max(download_oper_time) as oper_time
        ,download_oper_src as oper_src
        ,download_oper_type as hispace_oper_type_cd
        ,max(download_exfield) as ext_field
    FROM ads_noah_searchadv_exposure_client_download_distinct_dm
    WHERE pt_d=$date AND download_flag='1'
    GROUP BY download_imei,download_search_words,download_app_id,download_position,download_list_id,download_oper_src,download_oper_type
)t_exposure_download
JOIN
(SELECT * FROM ads_noah_searchadv_query_topn_dm WHERE pt_d='$date' AND !bicoredata.IsEmpty(query) ORDER BY cnt DESC limit 50000)t_hot_word
ON t_hot_word.query = t_exposure_download.search_words
LEFT JOIN
(
    SELECT
        imei as imei
        ,city as city
        ,device_name as device_name
        ,click_app_list_twoweek as click_app_list_twoweek
        ,down_app_list_twoweek as down_app_list_twoweek
        ,use_app_list_twoweek as use_app_list_twoweek
        ,click_app_type_oneweek as click_app_type_oneweek
        ,click_app_list_oneweek as click_app_list_oneweek
        ,down_app_type_oneweek as down_app_type_oneweek
        ,down_app_list_oneweek as down_app_list_oneweek
        ,down_app_type_twoweek as down_app_type_twoweek
        ,click_third_app_list_oneweek as click_third_app_list_oneweek
        ,down_third_app_list_oneweek as down_third_app_list_oneweek
        ,down_third_app_list_twoweek as down_third_app_list_twoweek
    FROM biads.ads_noah_common_user_info_big_table_dm
    WHERE pt_d='$date'
)t_user
ON t_exposure_download.imei=t_user.imei
LEFT JOIN
(
    SELECT
        app_id as app_id
        ,app_cn_name as app_cn_name
        ,app_type as app_type
        ,third_app_type as third_app_type
        ,tags as app_tags
        ,dev_up_id as dev_up_id
        ,last14days_download_num as last14days_download_num
    FROM biads.ads_noah_common_app_info_dm
    WHERE pt_d='$date'
)t_app
ON t_exposure_download.app_id=t_app.app_id
```



# feature-data-common

## 1. BillLogTable

### 广告话单用户下载曝光统计公共表 ads_noah_common_bill_log_user_count_info_dm

### 曝光后的广告话单日志表 ads_noah_common_bill_log_browse_with_bill_log_download_dm

### 曝光后的广告话单日志表 ads_noah_common_bill_log_dm

### 广告话单最近30天用户实时下载公共表 ads_noah_common_bill_log_join_realtime_user_download_dm





## 2. ExposureBigTable 

### 精准曝光广告话单公共大宽表  ads_noah_common_big_table_exposure_bill_log_dm

### 精准曝光客户端下载公共大宽表 ads_noah_common_big_table_exposure_client_download_dm

包含了曝光于用户历史下载统计信息，每条数据都是。

联合ads_noah_common_exposure_client_download_dm与app表和user表



### 精准曝光广告话单公共大宽表 ads_noah_common_big_table_bill_log_dm



## 3. ExposureLogTable 

### 精准曝光会话及榜单信息公共表 ads_noah_common_exposure_session_list_info_dm

```sql
    imei                    STRING COMMENT '设备编号'
    ,session_id              STRING COMMENT '会话编号'
    ,list_id                 STRING COMMENT '榜单编号'
    ,force_exposure          STRING COMMENT '是否强制曝光'
    
 from
 bicoredata.dwd_evt_hispace_exposure_log_hm
```



### 广告话单会话及榜单信息公共表 ads_noah_common_bill_log_session_list_info_dm



### 精准曝光组合广告话单公共表 ads_noah_common_exposure_with_adv_bill_log_dm



### 精准曝光联合广告话单下载公共表 biads.ads_noah_common_exposure_with_adv_bill_log_dm



### 精准曝光联合广告话单下载当天用户实时下载公共表 ads_noah_common_exposure_adv_bill_log_join_realtime_user_download_dm



### 精准曝光联合客户端下载公共表 ads_noah_common_exposure_client_download_dm





### 精准曝光联合客户端曝光与下载公共表 ads_noah_common_exposure_with_client_download_dm

曝光表 left join下载表。

一条数据是曝光的app，若没有下载则download字段都为空



## 4.UserFeature 

### 精准曝光用户原始设备编号公共表 ads_noah_common_exposure_imei_dm 

```sql
(
     imei                    STRING COMMENT '设备编号'
    ,imei_orgi               STRING COMMENT '原始设备编号'
)
from bicoredata.dwd_evt_hispace_exposure_log_hm
```

![1578279518880](../../../../projectdocsmyimages/1578279518880.png)



### 日活用户静态信息表 ads_noah_common_user_info_dm 



## 5.AppFeature

### 应用静态信息表 ads_noah_common_app_info_dm

```sql
(
    app_id VARCHAR(128) COMMENT '应用编号'
   ,dev_up_id VARCHAR(128) COMMENT '开发者编号'
   ,app_type VARCHAR(256) COMMENT '应用类型'
   ,third_app_type VARCHAR(256) COMMENT '应用子类型'
   ,app_size VARCHAR(256) COMMENT '应用大小'
   ,app_class_id VARCHAR(128) COMMENT '应用分类编号'
   ,on_shelf_time VARCHAR(30) COMMENT '上架时间'
   ,tags VARCHAR(256) COMMENT '标签'
   ,app_cn_name VARCHAR(256) COMMENT '应用中文名称'
   ,package_name VARCHAR(256) COMMENT '包名'
   ,app_level_cd VARCHAR(16) COMMENT '应用级别代码'
   ,star_rate INT COMMENT '星级'
   ,credible_flg SMALLINT COMMENT '可信标志'
   ,game_type_cd VARCHAR(16) COMMENT '游戏类型代码'
   ,last30days_download_num INT COMMENT '月下载量'
   ,last30days_download_ratio FLOAT COMMENT '月下载率'
   ,last14days_download_num INT COMMENT '最近两周下载量'
   ,last14days_download_ratio FLOAT COMMENT '最近两周下载率'
   ,last7days_download_num INT COMMENT '最近一周下载量'
   ,last7days_download_ratio FLOAT COMMENT '最近一周下载率'
   ,last2days_download_num INT COMMENT '最近两天下载量'
   ,last2days_download_ratio FLOAT COMMENT '最近两天下载率'
   ,last1days_download_num INT COMMENT '最近一天下载量'
   ,last1days_download_ratio FLOAT COMMENT '最近一天下载率'
   ,app_avg_score_oneday FLOAT COMMENT '平均评分'
   ,app_comment_num_oneday INT COMMENT '评论数'
   ,init_release_star_rate INT COMMENT '首发评级'
   ,app_unique_id VARCHAR(128) COMMENT '应用唯一编号'
   ,app_avg_score FLOAT COMMENT '历史平均评分'
   ,app_comment_num INT COMMENT '历史评论数'
)
```



### 应用当天下载展示统计表 ads_noah_common_app_download_show_count

```sql
(
    app_id VARCHAR(128) COMMENT '应用编号'
   ,download_count INT COMMENT '下载量'
   ,show_count BIGINT COMMENT '展示量'
)
```





## 6.TabFeature

### 标签页映射公共表 ads_noah_common_tabs_ds



## 7.DeviceFeature

### 客户端版本映射公共表 ads_noah_common_client_version_ds



## 8.bytedance.App

### 头条推送应用信息表 ads_noah_bytedance_push_app_disting_ver_ds

### 头条推送应用安装表 ads_noah_bytedance_push_app_all_stat_dm