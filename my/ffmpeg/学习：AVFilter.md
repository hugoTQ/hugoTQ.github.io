

## 1. 常用命令

```shell
#	查看ffmpeg支持的filter
ffmpeg -filters 

Filters:
  T.. = Timeline support	//？
  .S. = Slice threading		//？
  ..C = Command support		//？
  A = Audio input/output
  V = Video input/output
  N = Dynamic number and/or type of input/output
  | = Source or sink filter
 ... abench            A->A       Benchmark part of a filtergraph.
 ... acompressor       A->A       Audio compressor.
 ... acontrast         A->A       Simple audio dynamic range compression/expansion filter.
 ... acopy             A->A       Copy the input audio unchanged to the output.
 ... acrossfade        AA->A      Cross fade two input audio streams.
 ... acrusher          A->A       Reduce audio bit resolution.
 .S. adeclick          A->A       Remove impulsive noise from input audio.
 .S. adeclip           A->A       Remove clipping from input audio.
 T.. adelay            A->A       Delay one or more audio channels.
 ... aderivative       A->A       Compute derivative of input audio.
 ... aecho             A->A       Add echoing to the audio.
 ... aemphasis         A->A       Audio emphasis.
 ... aeval             A->A       Filter audio signal according to a specified expression.
 T.. afade             A->A       Fade in/out input audio.
 
 #具体某个filter用法
 ffmpeg -h filter=filter_name
 
# 去logo，语法 -vf delogo=x:y:w:h[:t[:show]]，x:y 离左上角的坐标 w:h logo的宽和高 t: 矩形边缘的厚度默认值4 show：若设置为1有一个绿色的矩形，默认值0。
ffmpeg -i input.mp4 -vf delogo=0:0:220:90:100:1 output.mp4

## 画中画
./ffmpeg -re -i input.mp4 -vf "movie=input.mp4 ,scale=480x320[test]; [in][test]overlay=x=main_w-480:y=main_h-320 [out]" -vcodec libx264 output.flv

# 动态画中画
./ffmpeg -re -i input.mp4 -vf "movie=input.mp4 ,scale=480x320[test]; [in][test]overlay=x='if(gte(t,2), -w+(t-2)*20, NAN)':y=0 [out]" -vcodec libx264 output.flv

1、加字幕
         命令：ffmpeg -i <input> -filter_complex subtitles=filename=<SubtitleName>-y <output>

         说明：利用libass来为视频嵌入字幕，字幕是直接嵌入到视频里的硬字幕。

         参考资料：http://ffmpeg.org/ffmpeg-filters.html#subtitles-1

2、剪切
         命令：ffmpeg -i <input>-ss 0 -t 10 -y <output>

         说明：ss跟的是起始时间，t为持续时间，上面命令意思为从0秒开始截取10秒的时间。

         参考资料：http://ffmpeg.org/ffmpeg.html

3、缩放
         命令： ffmpeg -i<output> -filter_complex scale=320:240  -y <output>

         说明：scale参数为宽高。

4、剪裁
         命令：ffmpeg -i <input>-filter_complex crop=320:240:0:0 -y <output>

         说明：其中的 crop=320:240:0:0为裁剪参数，具体含义是 crop=width:height:x:y，其中 width 和 height 表示裁剪后的尺寸，x:y 表示裁剪区域的左上角坐标。

5、加水印
命令：ffmpeg -i src.avi -vf "movie=<LogoName>[logo];[in][logo]overlay=100:100[out]"-y <output>
         说明：LogoName为图片名，overlay=100:100意义为overlay=x:y，在(x,y)坐标处开始添加水印。

         左上角：overlay=10:10 

         右上角：overlay=main_w-overlay_w-10:10

         左下角：overlay=10:main_h-overlay_h-10 

         右下角：overlay=main_w-overlay_w-10:main_h-overlay_h-10

6、拼接视频
         第一种命令：

                   第一步：ffmpeg  -i INPUT -fmpeg  OUTPUT

                   第二步：copy /b INPUT+INPUT OUTPUT

                   第三步：ffmpeg -i INPUT -f FORMAT OUTPUT

         说明：第一步把输入文件转为相同格式，第二步利用copy命令把文件合并，第三步把合并文件转为最终结果视频。

         例：把名为test.avi、test1_2.mp4 两个视频合并为resu.avi。

         第一步：ffmpeg -itest1.avi test1.mpg

                            ffmpeg-i test1_2.mp4 test2.mpg

         第二步：copy /btest1.mpg+test2.mpg resu.mpge

         第三步：ffmpeg -iresu.mpge -y resu.avi

第二种命令：

ffmpeg -i 1.mov -i 2.wmv -filter_complex "[0:0] [0:1] [1:0] [1:1]  concat=n=2:v=1:a=1 [v] [a]" -map [v] -map [a] output.mp4

7、旋转
         命令： ffmpeg -i <input> -filter_complex transpose=X -y <output>

         说明：transpose=1为顺时针旋转90°，transpose=2逆时针旋转90°。

8、镜像
         上下镜像

                   命令：

ffmpeg -i src.avi -vf "split[mian][tmp];[tmp]crop=iw:ih/2:0:0,vflip[flip];[mian][flip]overlay=0:H/2"-y GHO.avi

                  说明：从命令中可以看出crop和vflip在一条流水线上，他们的处理流程如下图所示：



 

                   可以利用此filter来做上下颠倒，命令如下： ffmpeg-i src.avi -vf "split [main][tmp

]; [tmp] crop=iw:ih:0:0, vflip [flip];[main][flip] overlay=0:0" GHO2.avi处理效果和命令ffmpeg -isrc.avi -vf vflip GHO_v_1.avi一样，这样写只是为了更好的理解filter处理链。

         左右镜像

                  命令： ffmpeg -i src.avi-vf "split [main][tmp]; [tmp] crop=iw/2:ih:0:0, hflip [flip]; [main][flip]overlay=W/2:0" GHO_H.avi

                   说明：流程和上下镜像一样，只是把坐标换了，并且指定用名为hfilp的filter。

                   可以利用此filter来做左右颠倒，命令如下： ffmpeg-i src.avi -vf "split [main][tmp

]; [tmp] crop=iw:ih:0:0, hflip [flip];[main][flip] overlay=W:0" GHO_H_1.avi和命令ffmpeg -i src.avi-vf hflip GHO_H_1.avi一样的效果，这样写只是为了更好的理解filter处理链。

         小结：split过滤器把输入分裂为2路输出，crop过滤器为翻转选取图像范围，vflip和hflip过滤器把crop切下的图像翻转（垂直、水平），overlay过滤器指定坐标来贴经过翻转处理的图像。

                  

9、加黑边
         命令： ffmpeg -isrc.avi -vf pad=1280:800:0:40:black -y test_pad.avi

         说明：pad=width:high:x:y:coler，这里的宽和高指的是结果视频尺寸（包含加黑边的尺寸），XY指的是源视频添加到结果视频所在位置，coler为填充颜色。

10、调音量
         命令：ffmpeg -i<input> -vol X <output>
         
```

具体使用说明常见 [官网](http://ffmpeg.org/ffmpeg-filters.html) ，上面有所有filer使用说明

##2. 初始化filter

### avfilter_register_all

## 3. 关键结构体

```c
typedef struct AVFilter
typedef struct AVFilterContext AVFilterContext;
typedef struct AVFilterLink    AVFilterLink;
typedef struct AVFilterPad     AVFilterPad;
typedef struct AVFilterFormats AVFilterFormats;
```

 









## REFERENCE

[DirectShow Filter 开发典型例子分析 ——字幕叠加 （FilterTitleOverlay）1](https://blog.csdn.net/leixiaohua1020/article/details/12498975)

[开源DirectShow分析器和解码器： LAV Filter](https://blog.csdn.net/leixiaohua1020/article/details/11862265)

[最简单的基于FFmpeg的AVfilter的例子-纯净版](https://blog.csdn.net/leixiaohua1020/article/details/50618190)

[FFmpeg文档解读](https://www.jianshu.com/p/2eccd79b93f1)