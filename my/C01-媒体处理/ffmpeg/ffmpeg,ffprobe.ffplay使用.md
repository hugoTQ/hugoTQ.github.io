# ffprobe![img](file:///C:/Users/h00379181/AppData/Roaming/eSpace_Desktop/UserData/h00379181/imagefiles/originalImgfiles/1D00E803-FA54-445C-9D5E-BB58CDE027EE.png)

常用：

1. 计算帧数

   `ffprobe -v error -count_frames -select_streams v:0  -show_entries stream=nb_read_frames -of default=nokey=1:noprint_wrappers=1  /tmp/1280x720.mp4`

2. 输出每帧信息到cvs

   `ffprobe -show_frames -select_streams v infilePath -print_format csv > output.csv >&1`



[TOC]

## 0 前言

---

本文主要参考 [ffprobe documentation](http://www.ffmpeg.org/ffprobe-all.html)，以及《FFMPEG入门到精通》一书。

本文中的示例将尽量详尽，每个示例也将经过实测。

ffprobe版本4.1  2019年3月5日记之。

## 1 语法 Synopsis

------

ffprobe [options] [input_url]

## 2 描述 Description

---

ffprobe收集多媒体流信息然后以人和机器都可读的方式打印出来。

例如可以用之来检查多媒体文件容器封装格式以及每个流中存储数据的编码格式。

如果输入文件的url被指定，ffprobe将试图打开和探测url指定的内容。如果url打开失败或者无法识别为多媒体文件，将返回一个正的返回码。

ffprobe可以作为一个单独的应用，或者作为一个文本滤镜，这个文理滤镜可以执行更复杂的处理，比如数据统计和画图。

选项用于列举一些ffprobe支持的文件格式，或者指定哪些信息将被显示，或者指定信息如何被显示

ffprobe的输出被设计为容易被文本滤镜所解析的格式，由一个或多个Section组成，每个Section的格式由selected writer所决定，而selected writer可以由print_format选项来指定。

Section可以嵌套包含其他Section，通过唯一的名称来区分。详情见输出sections章节

metadata元数据标签存储在容器或者存储在流中将被识别并打印在相应的"FORMAT"， "STREAM"，或者 "PROGRAM_STREAM" section下。

## 3 选项 Options

---

所有数字选项，如果没有特别指明的话，接受一个字符串来替代数字作为输入，一般是数字后跟随一个SI单位，比如‘K’，‘M’，‘G’。

如果‘i’跟随在SI单位之后出现，那么数字大小将被解释为以1024为基础的而非1000。如果'B'跟随在SI单位后出现，那么值将乘以8。将会出现‘KB’， ‘MiB’， ‘G’ 和 ‘B’作为数字的后缀。

没有参数的选项是bool选项，将设置相关的参数为true。相关参数可以被设置为false，通过在相应的选项前加个‘no’。比如，使用‘-nofoo’选项，将会使得‘-foo’选项设置的参数为false。

详情参见ffprobe documentation

### 3.1 流指定器 Stream specifiers

---

一些选项可以应用于每个流。流指定器用来精确指定选项作用于哪个流。



流指定器一般是跟随选项的字符串，用‘：’来隔开。比如 “-codec: a:1 ac3”包含了流指定器 a:1，匹配第二个音频流。因此作用是对第二个音频流使用ac3的编解码器。

一个流指定器可以匹配多个流，因此选项可以应用到这些多个流中。比如，“-b:a 128k”中的流指定器匹配所有的音频流。

一个空的流指定器匹配所有流。比如，-codec copy 或者 -codec: copy将会匹配所有的流。

流指定器可能的格式：

- stream_index   匹配流序号。比如，-threads:1 4 将设置处理第二个流的线程数为4。如果stream_index用于指定器的追加参数，那么将会选择匹配的相应序号的流
- stream_type[:additional_stream_specifier]    stream_type是指：音频流类型使用'a'，字幕流类型使用's'，数据流类型使用'd'，附加类型使用't'，视频流类型使用'v'或者'V'，小'v'匹配所有的视频流，大'V'仅匹配非附加图片，视频缩略图，艺术封面图。当additional_stream_specifier被使用的，那么将匹配type:index一致的单个流，如果不使用additional_stream_specifier，那么将匹配所有和type一致的流。
- p:program_id[:additional_stream_specifier]    匹配节目id相应的流。
- #stream_id or i:stream_id    匹配流通过流id（比如MPEG-TS容器中的PID）
- m:key[:value]     匹配流的metadata中相应tag(key)含有指定值的流。如果value没有给出，那么匹配所有含有指定tag的所有流
- u     匹配具有可用配置的流，必须定义编解码器，并且必须提供诸如视频维度或音频采样率等基本信息。
  注意，在ffmpeg中匹配meatdata只会对输入文件工作正常。

### 3.2 通用选项 Generic options

通用选项在ffplay ffprobe ffmpeg中是共享的，因此，这些命令只会在ffprobe中介绍一遍。以下命令在win10上运行并拷贝结果，linux或者mac上运行结果类似，不同的地方会在各个端运行出结果，并展示区别。

#### 3.2.1  -h， -？， -help，--help [arg]

- func： Show help. An optional parameter may be specified to print help about a specific item. If no argument is specified, only basic (non advanced) tool options are shown.

Possible values of arg are:

long ： Print advanced tool options in addition to the basic tool options.

full ：Print complete list of options, including shared and private options for encoders, decoders, demuxers, muxers, filters, etc.

decoder=decoder_name ： Print detailed information about the decoder named decoder_name. Use the -decoders option to get a list of all decoders.

encoder=encoder_name ： Print detailed information about the encoder named encoder_name. Use the -encoders option to get a list of all encoders.

demuxer=demuxer_name ： Print detailed information about the demuxer named demuxer_name. Use the -formats option to get a list of all demuxers and muxers.

muxer=muxer_name ： Print detailed information about the muxer named muxer_name. Use the -formats option to get a list of all muxers and demuxers.

filter=filter_name ： Print detailed information about the filter name filter_name. Use the -filters option to get a list of all filters.

- example：ffprobe -h > ffprobe_help.txt； ffprobe -h long > ffprobe_long.txt; ffprobe -h full> ffprobe_full.txt;

上述3个命令行输出都是一样的，将获取ffprobe的命令所有的帮助信息，并输出到文件中，帮助行数居然达到可观的1900行。

![1564642405413](E:\project\docs2\my\ffmpeg\ffmpeg.ffprobe.assets\1564642405413.png)

ffprobe -h decoder=vorbis -hide_banner将显示音频解码器vorbis的详细信息：

![1564642421840](E:\project\docs2\my\ffmpeg\ffmpeg.ffprobe.assets\1564642421840.png)

#### 3.2.2  -L 
- func: show license

-  example： ffprobe -L -hide_banner           

 显示版权信息，告知ffprobe是开源免费软件，但是遵循GNU GPL/LGPL版权规范，任何基于此的应用也应该遵循同样的规范。

![1564642441060](E:\project\docs2\my\ffmpeg\ffmpeg.ffprobe.assets\1564642441060.png)

#### 3.2.3  -version
- func  : show version  

- example： ffprobe -version 显示ffprobe的banner信息，包括版本信息，版权信息，由什么编译器编译的，编译ffmpeg时使用的配置参数，编译后产生的库文件，子模块的版本(ffprobe的功能将依赖这些库)。这些信息在运行所有ffprobe ffmpeg ffplay命令时默认都会显示，若在执行其他命令时要隐藏banner信息，那么可以像3.3.2中示例那样在命令行中加入-hide_banner这个选项。
- ![1564642452436](E:\project\docs2\my\ffmpeg\ffmpeg.ffprobe.assets\1564642452436.png)

#### 3.2.4 -formats
- func: Show available formats (including devices).

- example：ffprobe -formats > formats.txt

由于输出内容较多，大约350行，此处只展示前10行。使用ffmpeg转码时，有时候会遇到无法解析的视频文件或者无法生成视频文件，报错提示不支持生成对应的视频文件，这时候可以使用ffprobe -formats或者ffmpeg -formats或者ffplay -fromats来查看是否支持对应的视频文件格式，即封装或者容器格式。

输出信息分为3个部分：

第一列是多媒体文件封装格式的解封装(Demuxing)支持与封装(Muxing)支持

第二列是媒体文件格式

第三列是文件格式的详细说明

注意：对于某种格式可能只支持解封装，但不支持封装成这种格式，第一列只有D；也可能只支持封装成某种格式，而无法解封装这种格式，也就是无法解析该类文件，第一列只有E；或者封装解封装同时支持，第一列D E均有。

```powershell
File formats:
 D. = Demuxing supported
 .E = Muxing supported
 --
 D  3dostr          3DO STR
  E 3g2             3GP2 (3GPP2 file format)
  E 3gp             3GP (3GPP file format)
 D  4xm             4X Technologies
  E a64             a64 - video for Commodore 64
 D  aa              Audible AA format files
 D  aac             raw ADTS AAC (Advanced Audio Coding)
 DE ac3             raw AC-3
 D  acm             Interplay ACM
 D  act             ACT Voice file format
```



#### 3.2.5 -muxers
- func  : show available muxers

- example：ffprobe -muxers > muxers.txt

由于输出内容较多，大约170行，此处只展示前10行。使用ffmpeg -muxers 或者ffplay -muxers将得到同样的输出。我们会发现其实就是把ffprobe -formats内容中第一列含有E的内容抽取出来，表征ffmpeg支持将音视频打包成什么封装格式的多媒体文件。其中有单独的音频，如mp3，wav格式；有字幕srt，ass；有常用的视音频格式mp4，flv等等。

```powershell
File formats:
 D. = Demuxing supported
 .E = Muxing supported
 --
  E 3g2             3GP2 (3GPP2 file format)
  E 3gp             3GP (3GPP file format)
  E a64             a64 - video for Commodore 64
  E ac3             raw AC-3
  E adts            ADTS AAC (Advanced Audio Coding)
  E adx             CRI ADX
  E aiff            Audio IFF
  E alaw            PCM A-law
  E amr             3GPP AMR
  E apng            Animated Portable Network Graphics
  E aptx            raw aptX (Audio Processing Technology for Bluetooth)
  E aptx_hd         raw aptX HD (Audio Processing Technology for Bluetooth)
  E asf             ASF (Advanced / Active Streaming Format)
  E asf_stream      ASF (Advanced / Active Streaming Format)
  E ass             SSA (SubStation Alpha) subtitle
```

#### 3.2.6 -demuxers
- func  : show available demuxers

- example： ffprobe -demuxers > demuxers.txt

由于输出内容较多，大约630行+，此处只展示前10行。我们会发现其实就是把ffprobe -formats内容中第一列含有D的内容抽取出来，表征ffmpeg支持解析哪些格式的多媒体文件。

```powershell
File formats:
 D. = Demuxing supported
 .E = Muxing supported
 --
 D  3dostr          3DO STR
 D  4xm             4X Technologies
 D  aa              Audible AA format files
 D  aac             raw ADTS AAC (Advanced Audio Coding)
 D  ac3             raw AC-3
 D  acm             Interplay ACM
 D  act             ACT Voice file format
 D  adf             Artworx Data Format
 D  adp             ADP
 D  ads             Sony PS2 ADS
 D  adx             CRI ADX
 D  aea             MD STUDIO audio
 D  afc             AFC
 D  aiff            Audio IFF
 D  aix             CRI AIX
```

#### 3.2.7 -devices
- func: show available devices

- example：ffprobe -devices

命令将列举平台相关的输入输出设备支持，输入设备指的是音视频采集设备类型，输出设备指的是渲染设备类型。

输出信息分为3个部分：

第一列是设备类型 D表示输入设备，即采集设备类型；E表示输出设备，即渲染设备类型。

第二列是设备类型名称

第三列是设备类型的详细介绍

注意：在不同的平台上，设备采集与渲染采用不同的技术，因此，对于此命令在不同的平台执行结果将不相同

Windows：支持dshow，lavfi，vfwcap设备采集。其中vfwcap是video for windows capture的缩写，这个是相对比较老的技术；dshow即DirecrShow capture，这个是windows上目前采用的先进的采集技术；lavfi是虚拟的采集设备；sdl && sdl2是渲染技术（simple direct layer）。

```powershell
Devices:
 D. = Demuxing supported
 .E = Muxing supported
 --
 D  dshow           DirectShow capture
 D  lavfi           Libavfilter virtual input device
  E sdl,sdl2        SDL2 output device
 D  vfwcap          VfW video capture	
```



进一步，如果要查看本机(windows)所支持的dshow设备，可以使用ffmpeg -list_devices true -f dshow -i dummy。本人机器上将输出：

![1564642607209](E:\project\docs2\my\ffmpeg\ffmpeg.ffprobe.assets\1564642607209.png)

- Mac：avfoundation 是苹果设备上音视频设备采集的独有技术.

```powershell
Devices:
 D. = Demuxing supported
 .E = Muxing supported
 --
 D  avfoundation    AVFoundation input device
 D  lavfi           Libavfilter virtual input device
  E sdl,sdl2        SDL2 output device	
```



进一步，如果要查看本机(mac)所支持的avfoundation设备，可以使用ffmpeg -list_devices true -f avfoundation -i dummy。本人机器上将输出：

```shell
[AVFoundation input device @ 0x7fa37f51b680] AVFoundation video devices:
[AVFoundation input device @ 0x7fa37f51b680] [0] FaceTime HD Camera
[AVFoundation input device @ 0x7fa37f51b680] [1] Capture screen 0
[AVFoundation input device @ 0x7fa37f51b680] AVFoundation audio devices:
[AVFoundation input device @ 0x7fa37f51b680] [0] Built-in Microphone
```



Linux:  alsa 是Advanced Linux Sound Architecture，高级Linux声音架构的简称,它在Linux操作系统上提供了音频和MIDI（Musical Instrument Digital Interface，音乐设备数字化接口）的支持。在2.6系列内核中，ALSA已经成为默认的声音子系统，用来替换2.4系列内核中的OSS（Open Sound System，开放声音系统）；vdieo4linux2是linux上的视频采集渲染接口，简称为v4l2；x11grab可实现linux x11窗口的抓屏操作。

```powershell
Devices:
 D. = Demuxing supported
 .E = Muxing supported
 --
 DE alsa            ALSA audio output
 DE fbdev           Linux framebuffer
 D  lavfi           Libavfilter virtual input device
 DE oss             OSS (Open Sound System) playback
 DE video4linux2,v4l2 Video4Linux2 output device
 D  x11grab         X11 screen capture, using XCB
```



#### 3.2.8 -codecs
- func : show available codecs

- example： ffprobe -codecs > codecs.txt

命令将输出ffmpeg支持的所有编解码器：音频，视频，字幕的编解码。本命令输出内容太多，以下将只展现前十几行。

输出信息分为3个部分：

第一列是编解码器功能描述，D表示支持解码，E表示支持编码，V表示是视频编解码器，A表示是音频编解码器。S表示字幕编解码器，I表示编码器只产生I帧，只进行帧内编码，而不进行帧间编码，L表示编码方式是有损压缩，S表示编码方式是无损压缩。

第二列是编解码器名称

第三列是编解码的简单描述

注意：在音视频领域内，音频编码和视频编码所采用的技术基本上来说完全不同。因此一个编解码器只会针对音频或者视频，不可能既含有音频编码算法又包含视频编码算法。

```shell
Codecs:
 D..... = Decoding supported
 .E.... = Encoding supported
 ..V... = Video codec
 ..A... = Audio codec
 ..S... = Subtitle codec
 ...I.. = Intra frame-only codec
 ....L. = Lossy compression
 .....S = Lossless compression
 -------
 D.VI.S 012v                 Uncompressed 4:2:2 10-bit
 D.V.L. 4xm                  4X Movie
 D.VI.S 8bps                 QuickTime 8BPS video
 .EVIL. a64_multi            Multicolor charset for Commodore 64 (encoders: a64multi )
 .EVIL. a64_multi5           Multicolor charset for Commodore 64, extended with 5th color (colram) (encoders: a64multi5 )
 D.V..S aasc                 Autodesk RLE
 D.VIL. aic                  Apple Intermediate Codec
 DEVI.S alias_pix            Alias/Wavefront PIX image
 DEVIL. amv                  AMV Video
 D.V.L. anm                  Deluxe Paint Animation
 D.V.L. ansi                 ASCII/ANSI art
 DEV..S apng                 APNG (Animated Portable Network Graphics) image
 D.V.L. arbc                 Gryphon's Anim Compressor
 DEVIL. asv1                 ASUS V1
 DEVIL. asv2                 ASUS V2
 D.VIL. aura                 Auravision AURA
```



#### 3.2.9 -decoders
- func : show available decoders

- example：ffprobe -decoders > decoders.txt

命令将输出ffmpeg支持的所有解码器：音频，视频，字幕的解码器。本命令输出内容太多，以下将只展现前十几行。

输出信息分为3个部分：

第一列是解码器功能描述，V表示是视频解码器，A表示是音频解码器。S表示字幕解码器，F表示解码器采用帧层面的多线程解码技术，S表示解码器采用片层多线程解码技术，X表示解码器是实验性质的，B和D目前还不清楚具体指代什么，留待后续。

第二列是编解码器名称

第三列是编解码的简单描述

```shell
Decoders:
 V..... = Video
 A..... = Audio
 S..... = Subtitle
 .F.... = Frame-level multithreading
 ..S... = Slice-level multithreading
 ...X.. = Codec is experimental
 ....B. = Supports draw_horiz_band
 .....D = Supports direct rendering method 1
 ------
 V....D 012v                 Uncompressed 4:2:2 10-bit
 V....D 4xm                  4X Movie
 V....D 8bps                 QuickTime 8BPS video
 V....D aasc                 Autodesk RLE
 VF...D aic                  Apple Intermediate Codec
 V....D alias_pix            Alias/Wavefront PIX image
 V....D amv                  AMV Video
 V....D anm                  Deluxe Paint Animation
 V....D ansi                 ASCII/ANSI art
 VF...D apng                 APNG (Animated Portable Network Graphics) image
 V....D arbc                 Gryphon's Anim Compressor
 V....D asv1                 ASUS V1
```



 .....D = Supports direct rendering method 1

 V....D 012v                 Uncompressed 4:2:2 10-bit
 V....D 4xm                  4X Movie
 V....D 8bps                 QuickTime 8BPS video
 V....D aasc                 Autodesk RLE
 VF...D aic                  Apple Intermediate Codec
 V....D alias_pix            Alias/Wavefront PIX image
 V....D amv                  AMV Video
 V....D anm                  Deluxe Paint Animation
 V....D ansi                 ASCII/ANSI art
 VF...D apng                 APNG (Animated Portable Network Graphics) image
 V....D arbc                 Gryphon's Anim Compressor
 V....D asv1                 ASUS V1

#### 3.2.10  -encoders
- func: show available encoders 

- example：ffprobe -encoders > encoders.txt

命令将输出ffmpeg支持的所有编码器。 

```shell
Encoders:
 V..... = Video
 A..... = Audio
 S..... = Subtitle
 .F.... = Frame-level multithreading
 ..S... = Slice-level multithreading
 ...X.. = Codec is experimental
 ....B. = Supports draw_horiz_band
 .....D = Supports direct rendering method 1
 ------
 V..... a64multi             Multicolor charset for Commodore 64 (codec a64_multi)
 V..... a64multi5            Multicolor charset for Commodore 64, extended with 5th color (colram) (codec a64_multi5)
 V..... alias_pix            Alias/Wavefront PIX image
 V..... amv                  AMV Video
 V..... apng                 APNG (Animated Portable Network Graphics) image
 V..... asv1                 ASUS V1
 V..... asv2                 ASUS V2
 V..X.. libaom-av1           libaom AV1 (codec av1)
 V..... avrp                 Avid 1:1 10-bit RGB Packer
```



#### 3.2.11  -bsfs             
- func : show available bit stream filters

- example：ffprobe -bsfs

命令输出所有支持的比特流滤镜，这个是干什么用的呢？ 使用ffmpeg官网的解释：

“A bitstream filter operates on the encoded stream data, and performs bitstream level modifications without performing decoding”

大意是：一个比特流滤镜操作的是编码后的流数据，可以在不解码的前提下进行比特流层面进行修改。具体这些比特流滤镜详细作用可以参见ffmpeg官方文档，地址为：[FFmpeg Bitstream Filters Documentation](https://www.ffmpeg.org/ffmpeg-bitstream-filters.html).

```shell
Bitstream filters:
aac_adtstoasc
av1_metadata
chomp
dump_extra
dca_core
eac3_core
extract_extradata
filter_units
h264_metadata
h264_mp4toannexb
h264_redundant_pps
hapqa_extract
hevc_metadata
hevc_mp4toannexb
imxdump
mjpeg2jpeg
mjpegadump
mp3decomp
mpeg2_metadata
mpeg4_unpack_bframes
mov2textsub
noise
null
prores_metadata
remove_extra
text2movsub
trace_headers
truehd_core
vp9_metadata
vp9_raw_reorder
vp9_superframe
vp9_superframe_split
```

  我们以第一个滤镜来解释比特流滤镜的作用，以下是官网对aac_adtsasc滤镜的描述，大意是当从AAC码流，比如原始的ADTS AAC码流或者是MPEG-TS容器中，转封装到MP4A-LATM，FLV, MOV/MP4这些格式或者是相关的3GP，M4A格式时，将用到aac_adtsasc滤镜。

```powershell
aac_adtstoasc:
 
Convert MPEG-2/4 AAC ADTS to an MPEG-4 Audio Specific Configuration bitstream.
 
This filter creates an MPEG-4 AudioSpecificConfig from an MPEG-2/4 ADTS header and removes the ADTS header.
 
This filter is required for example when copying an AAC stream from a raw ADTS AAC or an MPEG-TS container to MP4A-LATM, to an FLV file, or to MOV/MP4 files and related formats such as 3GP or M4A. Please note that it is auto-inserted for MP4A-LATM and MOV/MP4 and related formats.
```

另外也有网友提供的关于aac_adtstoasc滤镜的分析文章：[aac_adtstoasc bitstream filter](https://blog.csdn.net/liuyl2016/article/details/53080733)；

再有雷神这篇文章中也有提及bitstream filter的作用：[使用FFMPEG类库分离出多媒体文件中的H.264码流](https://blog.csdn.net/leixiaohua1020/article/details/11800877)

看完这些资料，我是大概明白了～

#### 3.2.12 -protocols       
- func : show available protocols

- example：ffprobe -protocols

这里支持的文件协议分为input和output，也就是支持解input中描述的协议，支持按照output中描述的这些协议发送数据。

茫茫多的协议中最常用的是rtmp，hls，http，rtp，tee

```powershell
Supported file protocols:
Input:
  async
  bluray
  cache
  concat
  crypto
  data
  ffrtmpcrypt
  ffrtmphttp
  file
  ftp
  gopher
  hls
  http
  httpproxy
  https
  mmsh
  mmst
  pipe
  rtmp
  rtmpe
  rtmps
  rtmpt
  rtmpte
  rtmpts
  rtp
  srtp
  subfile
  tcp
  tls
  udp
  udplite
  unix
Output:
  crypto
  ffrtmpcrypt
  ffrtmphttp
  file
  ftp
  gopher
  http
  httpproxy
  https
  icecast
  md5
  pipe
  prompeg
  rtmp
  rtmpe
  rtmps
  rtmpt
  rtmpte
  rtmpts
  rtp
  srtp
  tee
  tcp
  tls
  udp
  udplite
  unix
```

#### 3.2.13 -filters
- func : show available filters

- example：ffprobe -filters > filters.txt

显示libavfilter中支持的所有滤镜。至于滤镜可以做什么用，将会在介绍ffmpeg命令行工具的时候详细介绍。

```SHELL
Filters:
  T.. = Timeline support
  .S. = Slice threading
  ..C = Command support
  A = Audio input/output
  V = Video input/output
  N = Dynamic number and/or type of input/output
  | = Source or sink filter
 ... abench            A->A       Benchmark part of a filtergraph.
 ... acompressor       A->A       Audio compressor.
 ... acontrast         A->A       Simple audio dynamic range compression/expansion filter.
 ... acopy             A->A       Copy the input audio unchanged to the output.
 ... acue              A->A       Delay filtering to match a cue.
 ... acrossfade        AA->A      Cross fade two input audio streams.
 ... acrossover        A->N       Split audio into per-bands streams.
 ... acrusher          A->A       Reduce audio bit resolution.
 .S. adeclick          A->A       Remove impulsive noise from input audio.
 .S. adeclip           A->A       Remove clipping from input audio.
...
```



#### 3.2.14 -pix_fmts         
- func : show available pixel formats

- example：ffprobe -pix_fmts > pix_fmts.txt

命令输出ffmpeg支持的所有像素格式，即编码前或者解码后的数据的格式。一般有yuv格式和rgb格式。

其中yuv420p是最长用的格式，因为h.264解码后就是这种格式的数据。

输出信息分为4个部分：

第一列是像素格式的属性：I表示支持该格式作为输入，O表示支持输出该格式，H表示支持硬件加速，P调色板格式和B比特流格式目前不知道是用在什么地方。

第二列是像素格式名称

第三列是像素格式包含了多少个组成部分，比如yuv420p就包含了亮度分量y和两个色度分量u和v，因此为3；rgb24包含了r红，g绿，蓝b三原色，因此也为3；rgba在红绿蓝光的三原色的基础上，加上了alpha通道，因此为4。

第四列是平均一个像素点需要多少位来表示。对于yuv420p，以4*4的像素矩阵举例有16个像素点，那么亮度分量y有16个点，每个点y分量占8bit，因此总共有128bit表示y分量；对于yuv420p的色度分量因为经过降采样，u，v分量在水平和垂直方向都是y分量的1/2，那么u和v分别都只有4个点，每个点占8bit，因此共有32bit表示u分量，32bit表示v分量。总体来说，16个像素点一共使用了128+32+32=192bit，分配到16个像素点，那么每个像素点得12bit，正如命令输出的最后一列所示。

注意：yuv420p中的p指代y，u，v三个组分如何存储的，一并在后续的音频采样数据格式中解释。

```shell
Pixel formats:
I.... = Supported Input  format for conversion
.O... = Supported Output format for conversion
..H.. = Hardware accelerated format
...P. = Paletted format
....B = Bitstream format

FLAGS NAME            NB_COMPONENTS BITS_PER_PIXEL

IO... yuv420p                3            12
IO... yuyv422                3            16
IO... rgb24                  3            24
IO... bgr24                  3            24
IO... yuv422p                3            16
IO... yuv444p                3            24
IO... yuv410p                3             9
IO... yuv411p                3            12
IO... gray                   1             8
IO..B monow                  1             1
IO..B monob                  1             1
I..P. pal8                   1             8
IO... yuvj420p               3            12
...
```



#### 3.2.15 -layouts         

- func : show standard channel layouts

- example：ffprobe -layouts

命令列出了所有支持的音频声道布局，最常见的就是mono单声道，stereo立体双声道，5.1声道，7.1声道

```shell
Individual channels:
NAME           DESCRIPTION
FL             front left
FR             front right
FC             front center
LFE            low frequency
BL             back left
BR             back right
FLC            front left-of-center
FRC            front right-of-center
BC             back center
SL             side left
SR             side right
TC             top center
TFL            top front left
TFC            top front center
TFR            top front right
TBL            top back left
TBC            top back center
TBR            top back right
DL             downmix left
DR             downmix right
WL             wide left
WR             wide right
SDL            surround direct left
SDR            surround direct right
LFE2           low frequency 2

Standard channel layouts:
NAME           DECOMPOSITION
mono           FC
stereo         FL+FR
2.1            FL+FR+LFE
3.0            FL+FR+FC
3.0(back)      FL+FR+BC
4.0            FL+FR+FC+BC
quad           FL+FR+BL+BR
quad(side)     FL+FR+SL+SR
3.1            FL+FR+FC+LFE
5.0            FL+FR+FC+BL+BR
5.0(side)      FL+FR+FC+SL+SR
4.1            FL+FR+FC+LFE+BC
5.1            FL+FR+FC+LFE+BL+BR
5.1(side)      FL+FR+FC+LFE+SL+SR
6.0            FL+FR+FC+BC+SL+SR
6.0(front)     FL+FR+FLC+FRC+SL+SR
hexagonal      FL+FR+FC+BL+BR+BC
6.1            FL+FR+FC+LFE+BC+SL+SR
6.1(back)      FL+FR+FC+LFE+BL+BR+BC
6.1(front)     FL+FR+LFE+FLC+FRC+SL+SR
7.0            FL+FR+FC+BL+BR+SL+SR
7.0(front)     FL+FR+FC+FLC+FRC+SL+SR
7.1            FL+FR+FC+LFE+BL+BR+SL+SR
7.1(wide)      FL+FR+FC+LFE+BL+BR+FLC+FRC
7.1(wide-side) FL+FR+FC+LFE+FLC+FRC+SL+SR
octagonal      FL+FR+FC+BL+BR+BC+SL+SR
hexadecagonal  FL+FR+FC+BL+BR+BC+SL+SR+TFL+TFC+TFR+TBL+TBC+TBR+WL+WR
downmix        DL+DR
```



#### 3.2.16 -sample_fmts       
- func : show available audio sample formats

- example：ffprobe -sample_fmts

该命令输出了ffmpeg中支持的音频采样数据格式，分为两部分：

第一列：音频采样数据格式名称，u表示无符号整数，s表示有符号整数，flt表示单精度浮点数，dbl表示双精度浮点数，而后面的数字表示的采样深度，与第二列意思相同，p指的是数据存储方式位planner，相对于packet打包方式来说的，这两种方式在于存在多个成分时，比如双声道数据有两个声道，两个声道的数据在planner的存储方式就是先存储第一个声道的数据，然后再存储第二个声道的数据；packet打包方式是两个声道的数据交错存放，先放一部分第一个声道数据，然后放一部分第二个声道数据，再放一部分第一个声道数据...如此反复直到存储完成。

第二列：采样深度，即一个音频采样点用多少bit表示。

注意：视频数据同样也存在这两种数据存放方式，也以pix_fmt的名称也以p为结尾来区分，带p为planner存储方式，各组分按序先后存放，不带p表示数据交错存放。

```shell
name   depth
u8        8 
s16      16 
s32      32 
flt      32 
dbl      64 
u8p       8 
s16p     16 
s32p     32 
fltp     32 
dblp     64 
s64      64 
s64p     64 
```



#### 3.2.17 -colors
- func : show available color names

- example：ffprobe -colors > colors.txt

枚举了ffmpeg支持的颜色名称以及对应的rgb值。

```shell
name                             #RRGGBB
AliceBlue                        #f0f8ff
AntiqueWhite                     #faebd7
Aqua                             #00ffff
Aquamarine                       #7fffd4
Azure                            #f0ffff
Beige                            #f5f5dc
Bisque                           #ffe4c4
Black                            #000000
BlanchedAlmond                   #ffebcd
Blue                             #0000ff
BlueViolet                       #8a2be2
Brown                            #a52a2a
...
```



#### 3.2.18 -hide_banner
- func :  Suppress printing banner.  All FFmpeg tools will normally show a copyright notice, build options and library versions. This option can be used to suppress printing this information.

- example：   ffprobe -hide_banner -i 1.mp4 

输出将隐藏banner信息。

#### 3.2.19 -cpuflags flags (global)
- func ： Allows setting and clearing cpu flags. This option is intended for testing. Do not use it unless you know what you’re doing.

- example：

![1564643072819](E:\project\docs2\my\ffmpeg\ffmpeg.ffprobe.assets\1564643072819.png)

#### 3.2.20 -report
- func : Dump full command line and console output to a file named program-YYYYMMDD-HHMMSS.log in the current directory. This file can be useful for bug reports. It also implies -loglevel debug.

Setting the environment variable FFREPORT to any value has the same effect. If the value is a ’:’-separated key=value sequence, these options will affect the report; option values must be escaped if they contain special characters or the options delimiter ’:’ (see the “Quoting and escaping” section in the ffmpeg-utils manual).

The following options are recognized:

file :    set the file name to use for the report; %p is expanded to the name of the program, %t is expanded to a timestamp, %% is expanded to a plain %

level:    set the log verbosity level using a numerical value (see -loglevel).

- example:  ffprobe -hide_banner 1.mp4 -report  完整的输出在运行目录下的ffprobe-20190306-105233.log的文件中，如下：整个过程就是ffprobe探测文件的过程，在阅读完ffprobe的源码基础上回过头来讲report每行输出进行注释。

```shell
ffprobe started on 2019-03-06 at 10:52:33
Report written to "ffprobe-20190306-105233.log"
Command line:
ffprobe -hide_banner 1.mp4 -report
[NULL @ 0000000000465140] Opening '1.mp4' for reading
[file @ 0000000000465a40] Setting default whitelist 'file,crypto'
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] Format mov,mp4,m4a,3gp,3g2,mj2 probed with size=2048 and score=100
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] ISO: File Type Major Brand: isom
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] Unknown dref type 0x206c7275 size 12
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] Processing st: 0, edit list 0 - media time: 2048, duration: 64512
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 0 ctts: 2048, ctts_index: 0, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 1024 ctts: 5120, ctts_index: 1, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 2048 ctts: 2048, ctts_index: 2, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 3072 ctts: 0, ctts_index: 3, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 4096 ctts: 1024, ctts_index: 4, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 5120 ctts: 5120, ctts_index: 5, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 6144 ctts: 2048, ctts_index: 6, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 7168 ctts: 0, ctts_index: 7, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 8192 ctts: 1024, ctts_index: 8, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 9216 ctts: 5120, ctts_index: 9, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 10240 ctts: 2048, ctts_index: 10, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 11264 ctts: 0, ctts_index: 11, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 12288 ctts: 1024, ctts_index: 12, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 13312 ctts: 5120, ctts_index: 13, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 14336 ctts: 2048, ctts_index: 14, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 15360 ctts: 0, ctts_index: 15, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 16384 ctts: 1024, ctts_index: 16, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 17408 ctts: 5120, ctts_index: 17, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 18432 ctts: 2048, ctts_index: 18, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 19456 ctts: 0, ctts_index: 19, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 20480 ctts: 1024, ctts_index: 20, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 21504 ctts: 5120, ctts_index: 21, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 22528 ctts: 2048, ctts_index: 22, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 23552 ctts: 0, ctts_index: 23, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 24576 ctts: 1024, ctts_index: 24, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 25600 ctts: 5120, ctts_index: 25, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 26624 ctts: 2048, ctts_index: 26, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 27648 ctts: 0, ctts_index: 27, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 28672 ctts: 1024, ctts_index: 28, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 29696 ctts: 5120, ctts_index: 29, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 30720 ctts: 2048, ctts_index: 30, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 31744 ctts: 0, ctts_index: 31, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 32768 ctts: 1024, ctts_index: 32, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 33792 ctts: 5120, ctts_index: 33, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 34816 ctts: 2048, ctts_index: 34, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 35840 ctts: 0, ctts_index: 35, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 36864 ctts: 1024, ctts_index: 36, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 37888 ctts: 5120, ctts_index: 37, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 38912 ctts: 2048, ctts_index: 38, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 39936 ctts: 0, ctts_index: 39, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 40960 ctts: 1024, ctts_index: 40, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 41984 ctts: 5120, ctts_index: 41, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 43008 ctts: 2048, ctts_index: 42, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 44032 ctts: 0, ctts_index: 43, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 45056 ctts: 1024, ctts_index: 44, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 46080 ctts: 5120, ctts_index: 45, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 47104 ctts: 2048, ctts_index: 46, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 48128 ctts: 0, ctts_index: 47, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 49152 ctts: 1024, ctts_index: 48, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 50176 ctts: 5120, ctts_index: 49, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 51200 ctts: 2048, ctts_index: 50, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 52224 ctts: 0, ctts_index: 51, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 53248 ctts: 1024, ctts_index: 52, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 54272 ctts: 5120, ctts_index: 53, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 55296 ctts: 2048, ctts_index: 54, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 56320 ctts: 0, ctts_index: 55, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 57344 ctts: 1024, ctts_index: 56, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 58368 ctts: 5120, ctts_index: 57, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 59392 ctts: 2048, ctts_index: 58, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 60416 ctts: 0, ctts_index: 59, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 61440 ctts: 1024, ctts_index: 60, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 62464 ctts: 3072, ctts_index: 61, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] stts: 63488 ctts: 1024, ctts_index: 62, ctts_count: 63
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] Offset DTS by 2048 to make first pts zero.
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] Setting codecpar->delay to 2 for stream st: 0
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] Unknown dref type 0x206c7275 size 12
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] Processing st: 1, edit list 0 - media time: -1, duration: 220280
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] Processing st: 1, edit list 1 - media time: 0, duration: 10275
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] Before avformat_find_stream_info() pos: 61972 bytes read:34968 seeks:1 nb_streams:2
[h264 @ 0000000000477b40] nal_unit_type: 7(SPS), nal_ref_idc: 3
[h264 @ 0000000000477b40] nal_unit_type: 8(PPS), nal_ref_idc: 3
[h264 @ 0000000000477b40] nal_unit_type: 6(SEI), nal_ref_idc: 0
[h264 @ 0000000000477b40] nal_unit_type: 5(IDR), nal_ref_idc: 3
[h264 @ 0000000000477b40] Format yuv420p chosen by get_format().
[h264 @ 0000000000477b40] Reinit context to 1280x720, pix_fmt: yuv420p
[h264 @ 0000000000477b40] no picture 
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] max_analyze_duration 5000000 reached at 5000000 microseconds st:0
[mov,mp4,m4a,3gp,3g2,mj2 @ 0000000000465140] After avformat_find_stream_info() pos: 53744 bytes read:96892 seeks:2 frames:60
Input #0, mov,mp4,m4a,3gp,3g2,mj2, from '1.mp4':
  Metadata:
    major_brand     : isom
    minor_version   : 512
    compatible_brands: isomiso2avc1mp41
    encoder         : Lavf58.17.101
  Duration: 00:00:05.25, start: 0.000000, bitrate: 94 kb/s
    Stream #0:0(und), 60, 1/12288: Video: h264 (High) (avc1 / 0x31637661), yuv420p, 1280x720, 84 kb/s, 12 fps, 12 tbr, 12288 tbn, 24 tbc (default)
    Metadata:
      handler_name    : VideoHandler
    Stream #0:1(und), 0, 1/44100: Audio: aac (mp4a / 0x6134706D), 44100 Hz, stereo, fltp, 156 kb/s (default)
    Metadata:
      handler_name    : SoundHandler
[h264 @ 000000000046bf80] nal_unit_type: 7(SPS), nal_ref_idc: 3
[h264 @ 000000000046bf80] nal_unit_type: 8(PPS), nal_ref_idc: 3
[AVIOContext @ 000000000046ecc0] Statistics: 96892 bytes read, 2 seeks
```



#### 3.2.21 -loglevel [flags+]loglevel | -v [flags+]loglevel
- func： Set logging level and flags used by the library.

The optional flags prefix can consist of the following values:

‘repeat’    Indicates that repeated log output should not be compressed to the first line and the "Last message repeated n times" line will be omitted.

‘level’      Indicates that log output should add a [level] prefix to each message line. This can be used as an alternative to log coloring, e.g. when dumping the log to file.  Flags can also be used alone by adding a ’+’/’-’ prefix to set/reset a single flag without affecting other flags or changing loglevel. When setting both flags and loglevel, a ’+’ separator is expected between the last flags value and before loglevel.

loglevel is a string or a number containing one of the following values:

‘quiet, -8’    Show nothing at all; be silent.

‘panic, 0’     Only show fatal errors which could lead the process to crash, such as an assertion failure. This is not currently used for anything.

‘fatal, 8’      Only show fatal errors. These are errors after which the process absolutely cannot continue.

‘error, 16’    Show all errors, including ones which can be recovered from.

‘warning, 24’     Show all warnings and errors. Any message related to possibly incorrect or unexpected events will be shown.

‘info, 32’    Show informative messages during processing. This is in addition to warnings and errors. This is the default value.

‘verbose, 40’    Same as info, except more verbose.

‘debug, 48’    Show everything, including debugging information.

‘trace, 56’   

- example:  ffmpeg -loglevel repeat+level+verbose -i 1.mp4 2.mp4 -report

输出了文件1.mp4转封装到2.mp4过程中的所有操作信息。日志内容大约有100+。可以作为分析使用。



#### 3.2.21 -sources device[,opt1=val1[,opt2=val2]...]
- func ： Show autodetected sources of the input device. Some devices may provide system-dependent source names that cannot be autodetected. The returned list cannot be assumed to be always complete.

- example:  当前对这个不是太理解，需要看完源码才知道~

![1564643131755](E:\project\docs2\my\ffmpeg\ffmpeg.ffprobe.assets\1564643131755.png)

#### 3.2.22 -sinks device[,opt1=val1[,opt2=val2]...]
- func ：Show autodetected sinks of the output device. Some devices may provide system-dependent sink names that cannot be autodetected. The returned list cannot be assumed to be always complete.

- example:  当前对这个不是太理解，需要看完源码才知道~![1564643142468](E:\project\docs2\my\ffmpeg\ffmpeg.ffprobe.assets\1564643142468.png)

### 3.3 主要选项 Main Options

---

#### 3.3.1 -sections         
- func：print sections structure and section information, and exit

- example: ffprobe -sections > sections.txt        ffprobe命令执行结果将以容易解析的格式输出，即以一个或多个section的方式展现，并受print_format参数影响。Sections 可以嵌套section。在媒体文件容器中或者流中的元数据Tag中存储数据将被识别并被打印出书在相关的FORMAT，STERAM，PROGRAM_STREAM section中。

```Shell
Sections:
W.. = Section is a wrapper (contains other sections, no local entries)
.A. = Section contains an array of elements of the same type
..V = Section may contain a variable number of fields with variable keys

FLAGS NAME/UNIQUE_NAME

W..   root
.A.      chapters
...          chapter
..V              tags/chapter_tags
...      format
..V          tags/format_tags
.A.      frames
...          frame
..V              tags/frame_tags
.A.              side_data_list/frame_side_data_list
...                  side_data
.A.              logs
...                  log
...          subtitle
.A.      programs
...          program
..V              tags/program_tags
.A.              streams/program_streams
...                  stream/program_stream
...                      disposition/program_stream_disposition
..V                      tags/program_stream_tags
.A.      streams
...          stream
...              disposition/stream_disposition
..V              tags/stream_tags
.A.              side_data_list/stream_side_data_list
...                  side_data
.A.      packets
...          packet
..V              tags/packet_tags
.A.              side_data_list/packet_side_data_list
...                  side_data
...      error
...      program_version
.A.      library_versions
...          library_version
.A.      pixel_formats
...          pixel_format
...              flags/pixel_format_flags
.A.              components/pixel_format_components
...                  component
```



#### 3.3.2  -show_format 
- func:  Show information about the container format of the input multimedia stream.  All the container format information is printed within a section with name "FORMAT".

- example: ffprobe -i 1.mp4 -show_format -hide_banner > show_format.txt

该命令显示一个mp4文件的封装格式。输出内容以及注释如下

```shell
[FORMAT]
filename=1.mp4       //文件名
nb_streams=2         //含有流的个数
nb_programs=0        //含有节目个数
format_name=mov,mp4,m4a,3gp,3g2,mj2   //文件格式，由于这几个格式近乎相同，ffmpeg也无法进一步区分，因此将所有可能的格式一起输出
format_long_name=QuickTime / MOV      //格式长名字
start_time=0.000000                   //播放开始时间
duration=55.960000                    //播放时长
size=2089331                          //文件大小
bit_rate=298689                       //平均码率
probe_score=100                       //ffmpeg尝试解析文件时，会先探测文件格式，先设置一个阈值，按照某个格式探测，探测得分score低于某个阈值，表示不是这个格式；得分越高表示是这个格式的可能性越高；最终取得分最高的那个格式。
TAG:major_brand=isom                  //表明该文件格式是基于iso base media file基础上发展来的格式
TAG:minor_version=512                 //与major_brand一起决定了该文件遵循何种specification
TAG:compatible_brands=isomiso2avc1mp41 //兼容的规范
[/FORMAT]
```



#### 3.3.3 -show_streams
- func：Show information about each media stream contained in the input multimedia stream. Each media stream information is printed within a dedicated section with name "STREAM".

- example: ffprobe -i 1.mp4 -show_streams -print_format  json > show_treams.txt

根据4.1中的命令输出，我们知道该文件中有2个流，那么这两个流具体都是什么呢？该命令将提供1.mp4文件中具体的流信息，输出内容以及注释如下。另，该命令加入了PART 3中的-print_format json的参数，那么内容将以json格式展示出来

```json
{
    "streams": [
        {
            "index": 0,             //流所在的索引区域，第0个索引区
            "codec_name": "h264",   //编码名，h264
            "codec_long_name": "H.264 / AVC / MPEG-4 AVC / MPEG-4 part 10", //编码全名
            "profile": "Main",      //档次Main（h264有3个档次Baseline，Main，Extended ）
            "codec_type": "video",  //编码器类型：视频 
            "codec_time_base": "1/50", //编码的时间戳计算基础单位，这儿是场率的倒数(由于帧率是25，一帧为上下场，因此场率为50)
            "codec_tag_string": "avc1",//编码标签数据
            "codec_tag": "0x31637661", //编码标签
            "width": 640,    //视频分辨率之宽
            "height": 360,   //视频分辨率之高
            "coded_width": 640,  //与width一样
            "coded_height": 368, //与height一样，但是为啥取值不一样需要后续研究下，此处先记着
            "has_b_frames": 2,              //IP帧或PP帧之间B帧的数量
            "sample_aspect_ratio": "1:1",   //采样宽高比
            "display_aspect_ratio": "16:9", //显示宽高比
            "pix_fmt": "yuv420p",           //像素格式
            "level": 30,                    //编码的level 
            "chroma_location": "left",      //指示了chroma采样的位置在frame buffer中的位置
            "refs": 1,                      //视频参考帧
            "is_avc": "true",               //是否是avc。MP4的视频H264封装有2种格式：h264和avc1，2种格式的区别：AVC1 描述:H.264 bitstream without start codes.一般通过ffmpeg转码生成的视频，是不带起始码0×00000001的；H264 描述:H.264 bitstream with start codes.一般对于一下HDVD等电影的压制格式，是带有起始码0×00000001的。
            "nal_length_size": "4",         //nal长度bit数
            "r_frame_rate": "25/1",         //实际帧率
            "avg_frame_rate": "25/1",       //平均帧率
            "time_base": "1/12800",         //编码时间基，用于计算timestamp
            "start_pts": 1024,              //开始播放时间pts，start_time/time_base
            "start_time": "0.080000",       //开始时间
            "duration_ts": 716288,          //时长duration/time_base
            "duration": "55.960000",        //时长，单位s
            "bit_rate": "261435",           //码率
            "bits_per_raw_sample": "8",     //原始采样样本的位深
            "nb_frames": "1399",            //共多少个帧
            "disposition": {                //附加信息
                "default": 1,
                "dub": 0,
                "original": 0,
                "comment": 0,
                "lyrics": 0,
                "karaoke": 0,
                "forced": 0,
                "hearing_impaired": 0,
                "visual_impaired": 0,
                "clean_effects": 0,
                "attached_pic": 0,
                "timed_thumbnails": 0
            },
            "tags": {                    //附加信息
                "language": "und",
                "handler_name": "VideoHandler"
            }
        },
        {
            "index": 1,          //流所在索引区，第1个索引
            "codec_name": "aac", //编码名，aac
            "codec_long_name": "AAC (Advanced Audio Coding)", //编码全名
            "profile": "HE-AAC",           //编码档次
            "codec_type": "audio",         //编码类型：音频编码
            "codec_time_base": "1/44100",  //编码的时间戳计算基础单位，采样率的倒数
            "codec_tag_string": "mp4a",    //编码标签数据
            "codec_tag": "0x6134706d",     //编码标签
            "sample_fmt": "fltp",          //采样格式 fltp：单精度浮点，planner
            "sample_rate": "44100",        //采样率
            "channels": 2,                 //2个通道
            "channel_layout": "stereo",    //通道布局：stereo双声道立体声
            "bits_per_sample": 0,          //一个采样点所占bit数
            "r_frame_rate": "0/0",         //实际码率
            "avg_frame_rate": "0/0",       //平均码率
            "time_base": "1/44100",        //时间基，用来计算timestamp
            "start_pts": 0,                //开始时间 start_time/time_base
            "start_time": "0.000000",      //开始时间 单位s
            "duration_ts": 2467840,        //时长 duration/time_base
            "duration": "55.960091",       //时长 单位s
            "bit_rate": "31991",           //码率
            "max_bit_rate": "32000",       //最大码率
            "nb_frames": "1205",           //帧数
            "disposition": {               //附加信息
                "default": 1,
                "dub": 0,
                "original": 0,
                "comment": 0,
                "lyrics": 0,
                "karaoke": 0,
                "forced": 0,
                "hearing_impaired": 0,
                "visual_impaired": 0,
                "clean_effects": 0,
                "attached_pic": 0,
                "timed_thumbnails": 0
            },
            "tags": {                     //附加信息
                "language": "eng",        //语言
                "handler_name": "SoundHandler" 
            }
        }
    ]
}
```



#### 3.3.4 -select_streams stream_specifier           
- func：Select only the streams specified by stream_specifier. This option affects only the options related to streams (e.g. show_streams, show_packets, etc.).

- example : ffprobe  -i 1.mp4 -show_streams -select_streams a -print_format ini > select_streams.txt

命令解释：-select_streams一般配合-show_streams使用，-show_streams罗列出媒体文件中所有流，而-select_streams可以在这些流中选择显示其中的部分，-select_streams后接v：视频，a：音频，s：字幕。示例中显示音频流

注意：-print_format ini 将使输出以ini格式呈现。注意与4.2中的json格式区别。

另：-select_streams还可以配合后续的-show_packets,  -show_frames使用。

```shell
# ffprobe output
 
[streams.stream.0]
index=1
codec_name=aac
codec_long_name=AAC (Advanced Audio Coding)
profile=HE-AAC
codec_type=audio
codec_time_base=1/44100
codec_tag_string=mp4a
codec_tag=0x6134706d
sample_fmt=fltp
sample_rate=44100
channels=2
channel_layout=stereo
bits_per_sample=0
id=N/A
r_frame_rate=0/0
avg_frame_rate=0/0
time_base=1/44100
start_pts=0
start_time=0.000000
duration_ts=2467840
duration=55.960091
bit_rate=31991
max_bit_rate=32000
bits_per_raw_sample=N/A
nb_frames=1205
nb_read_frames=N/A
nb_read_packets=N/A
 
[streams.stream.0.disposition]
default=1
dub=0
original=0
comment=0
lyrics=0
karaoke=0
forced=0
hearing_impaired=0
visual_impaired=0
clean_effects=0
attached_pic=0
timed_thumbnails=0
 
[streams.stream.0.tags]
language=eng
handler_name=SoundHandler
```



#### 3.3.5 -show_packets
- func：show packets info    

- example :  ffprobe -i 1.mp4  -show_packets > show_packets.txt

命令将显示1.mp4文件中所有的包信息，由于一个媒体文件包太多，因此只截取了前3个包的数据给以展示，并给出一些简要分析：

   1. 音频视频包交错存储：基本上是一个视频包一个音频包交错存储，但是可能会有连续两个视频包的情况出现。第一个包为视频包，起始位置(相对文件的偏移位置)pos为36805，大小为8468，第二个包为音频包，起始位置为45273=36805+8468。依次类推；

   2. 包时长：每个包，不管是音频还是视频包，时长均为0.04s左右；

   3. 包大小：音频包大小比视频包要小很多。

```shell
[PACKET]
codec_type=video                 //包类型，视频包
stream_index=0                   //流索引
pts=1024                         //播放时间戳 pts_time/time_base->0.08000/(1/12800),其中12800这个参数time_base见-show_streams的输出结果
pts_time=0.080000                //播放开始时间 0.080000，单位s
dts=0                            //解码时间戳
dts_time=0.000000                //解码时间 单位s
duration=512                     //持续时间 duration_time/time_base
duration_time=0.040000           //持续时间
convergence_duration=N/A         //与duration字段含义相同，但被弃用（见AVPacket结构体）
convergence_duration_time=N/A    //与上一致
size=8468                        //包的大小，字节数
pos=36805                        //包在文件中的偏移位置，十进制，转换成十六进制应该是0x8fc5
flags=K_                         //？？？？
[/PACKET]
[PACKET]
codec_type=audio                 //以下参数请参考视频包
stream_index=1                   
pts=0                            
pts_time=0.000000
dts=0
dts_time=0.000000
duration=2048
duration_time=0.046440
convergence_duration=N/A
convergence_duration_time=N/A
size=224
pos=45273
flags=K_
[/PACKET]
[PACKET]
codec_type=video
stream_index=0
pts=1536
pts_time=0.120000
dts=512
dts_time=0.040000
duration=512
duration_time=0.040000
convergence_duration=N/A
convergence_duration_time=N/A
size=5019
pos=45497
flags=__
[/PACKET]
```



#### 3.3.6 -show_data         
- func： Show payload data, as a hexadecimal and ASCII dump. Coupled with -show_packets, it will dump the packets’ data. Coupled with -show_streams, it will dump the codec extradata. The dump is printed as the "data" field. It may contain newlines.

- example : ffprobe -i 1.mp4 -show_data

执行上述命令将得不到mp4文件的data信息，此命令需要配合-show_packets来执行

ffprobe -i 1.mp4 -show_packets -show_data > show_packets_data.txt

我们可以看到，基于-show_packets的基础上，在PACKET这个section中加入了data这个TAG，若用UltrlEditor以二进制方式打开1.MP4文件，我们会发现文件偏移位置36805->36805+8468显示的数据与data这个TAG显示的数据是一样的。当然36805是十进制的，转换成十六进制地址为8FC5，如下图红圈开始位置。

![1564643345222](E:\project\docs2\my\ffmpeg\ffmpeg.ffprobe.assets\1564643345222.png)

```shell
[PACKET]
codec_type=video
stream_index=0
pts=1024
pts_time=0.080000
dts=0
dts_time=0.000000
duration=512
duration_time=0.040000
convergence_duration=N/A
convergence_duration_time=N/A
size=8468
pos=36805
flags=K_
data=
00000000: 0000 0049 0605 45dc 45e9 bde6 d948 b796  ...I..E.E....H..
00000010: 2cd8 20d9 23ee ef20 5456 2e53 4f48 552e  ,. .#.. TV.SOHU.
00000020: 434f 4d20 2d20 482e 3236 342f 4d50 4547  COM - H.264/MPEG
...此处省略很多行
00002100: 46fa 8fef ace9 da6d ec9b cc94 a26b 8759  F......m.....k.Y
00002110: 3cb1 2cc1                                <.,.
[/PACKET]
```



#### 3.3.7 -show_data_hash algorithm

- func：Show a hash of payload data, for packets with -show_packets and for codec extradata with -show_streams.

- example : ffprobe -i 1.mp4 -show_packets -show_data -show_data_hash md5> show_packets_data.txt

该命令将输出packet中data数据的hash码，支持的hash算法至少有md5和sha256，其他的算法没有试验，若不知道啥是md5或者是sha256，建议去查一下，这是常用的数据校验和加密算法，其中sha256在比特币中有使用的哦。输出内容将如下所示：

```shell
[PACKET]
codec_type=video
stream_index=0
pts=1024
pts_time=0.080000
dts=0
dts_time=0.000000
duration=512
duration_time=0.040000
convergence_duration=N/A
convergence_duration_time=N/A
size=8468
pos=36805
flags=K_
data=
00000000: 0000 0049 0605 45dc 45e9 bde6 d948 b796  ...I..E.E....H..
00000010: 2cd8 20d9 23ee ef20 5456 2e53 4f48 552e  ,. .#.. TV.SOHU.
00000020: 434f 4d20 2d20 482e 3236 342f 4d50 4547  COM - H.264/MPEG
...此处省略很多行
00002100: 46fa 8fef ace9 da6d ec9b cc94 a26b 8759  F......m.....k.Y
00002110: 3cb1 2cc1                                <.,.
data_hash=MD5:9c7c7a11a881f704f70581284e32253a                //data的md5值
[/PACKET]
```



#### 3.3.8 -count_frames && -count_packets        
- func：Count the number of frames per stream and report it in the corresponding stream section. &&  Count the number of packets per stream and report it in the corresponding stream section.

- example : 若单独运行ffprobe -i 1.mp4 -count_frames 或者ffprobe -i 1.mp4 -count_packets，将看不到输出的数据。这个两个命令可以配合-show_streams命令来查看，得到的数据将在STREAM这个section的nb_read_frames和nb_read_packets中体现出来。 ffprobe -i 1.mp4 -show_streams  && ffprobe -i 1.mp4 -show_streams -count_frames -count_packets输出对比如下：

注意：packets的数量和frames的数量是一致的，也就是说一个包对应一帧数据。

```shell
ffprobe -i 1.mp4 -show_streams -count_frames -count_packets
注意：将[STREAM]中其他TAG全都去除了
[STREAM]
nb_frames=1399
nb_read_frames=1399
nb_read_packets=1399
[/STREAM]
[STREAM]
nb_frames=1205
nb_read_frames=1205
nb_read_packets=1205
[/STREAM]

ffprobe -i 1.mp4 -show_streams
注意：将[STREAM]中其他TAG全都去除了
[STREAM]
nb_frames=1399
nb_read_frames=N/A
nb_read_packets=N/A
[/STREAM]
[STREAM]
nb_frames=1205
nb_read_frames=N/A
nb_read_packets=N/A
[/STREAM]
```



#### 3.3.9 -show_frames       
- func： Show information about each frame and subtitle contained in the input multimedia stream. The information for each single frame is printed within a dedicated section with name "FRAME" or "SUBTITLE".

- example : ffprobe -i 1.mp4 -show_frames

frame与packets是一一对应关系，虽然section [FRAME]中将比section [PACKET]多出几个字段，输出内容将只注释多出的这几个

```shell
[FRAME]
media_type=audio
stream_index=1
key_frame=1                 // 是否关键帧
pkt_pts=2048
pkt_pts_time=0.046440
pkt_dts=2048
pkt_dts_time=0.046440
best_effort_timestamp=2048    //packet->frame之后以这个变量来完成后续计算，而不使用packet中的时间戳了
best_effort_timestamp_time=0.046440
pkt_duration=2048
pkt_duration_time=0.046440
pkt_pos=50516
pkt_size=186
sample_fmt=fltp            //采样格式
nb_samples=2048            //frame中采样个数
channels=2                 //通道数
channel_layout=stereo      //通道布局
[/FRAME]
[FRAME]
media_type=video
stream_index=0
key_frame=1                 //是否为关键帧
pkt_pts=1024
pkt_pts_time=0.080000
pkt_dts=1024
pkt_dts_time=0.080000
best_effort_timestamp=1024     //与上同
best_effort_timestamp_time=0.080000
pkt_duration=512
pkt_duration_time=0.040000
pkt_pos=36805
pkt_size=8468
width=640
height=360
pix_fmt=yuv420p              //像素格式
sample_aspect_ratio=1:1      //采样从横比
pict_type=I                  //图像类型-I帧
coded_picture_number=0       //编码图片序号
display_picture_number=0     //显示图片序号
interlaced_frame=0           //是否是隔行扫描帧
top_field_first=0            //是否顶场在前
repeat_pict=0                //？？？？？
color_range=unknown          //色彩范围
color_space=unknown          //色彩空间
color_primaries=unknown      //主色彩
color_transfer=unknown       //颜色转换
chroma_location=left         //frame buffer中色彩的位置
[/FRAME]
```



关于ffprobe的命令参数解析先告一段落。以下这些命令参数用的比较少，可以参阅ffmpeg官方文档：[ffprobe Documentation](http://www.ffmpeg.org/ffprobe-all.html#Description)

当遇到需求或者了解了什么是programs chapter这些内容再回过头来完成Main Options中这些命令的解析。

### 3.4 多媒体文件的一般格式
一般而言，多媒体容器文件格式由三部分组成：文件头部分，索引部分，多媒体数据部分。

​                          ![1564643410688](E:\project\docs2\my\ffmpeg\ffmpeg.ffprobe.assets\1564643410688.png)                                            

- 文件头：包含了文件类型信息，表征文件遵循哪个规范

- 索引：由于多媒体数据通常会被分成若干块，各块数据之间也可能不是连续存储的，因此需要索引部分建立多媒体数据的存储位置索引，用来记录相应数据块的存储位置在文件中的偏移量；由于各数据块大小可能不一样，还需要在索引部分建立各多媒体数据块的尺寸大小索引，记录相应数据块的尺寸大小；此外还有音视频同步索引等等。一般播放多媒体文件时，会将索引一次性的读入内存中，然后在播放器中根据操作(快进，快退，seek)通过索引来获取所需的数据。

  ​					![1564643430619](E:\project\docs2\my\ffmpeg\ffmpeg.ffprobe.assets\1564643430619.png)                                    

- 多媒体数据部分：这个部分就是存储了经过编码压缩的音频，视频，内嵌字幕，文本数据以及其他数据的地方

