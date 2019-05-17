# ffmpeg 重要的结构体与函数

## 重要的结构体及关系
FFMPEG中结构体很多。最关键的结构体可以分成以下几类：

- 解协议（http,rtsp,rtmp,mms）

AVIOContext，URLProtocol，URLContext主要存储视音频使用的协议的类型以及状态。URLProtocol存储输入视音频使用的封装格式。每种协议都对应一个URLProtocol结构。（注意：FFMPEG中文件也被当做一种协议“file”）

- 解封装（flv,avi,rmvb,mp4）

AVFormatContext主要存储视音频封装格式中包含的信息；AVInputFormat存储输入视音频使用的封装格式。每种视音频封装格式都对应一个AVInputFormat 结构。

- 解码（h264,mpeg2,aac,mp3）

每个AVStream存储一个视频/音频流的相关数据；每个AVStream对应一个AVCodecContext，存储该视频/音频流使用解码方式的相关数据；每个AVCodecContext中对应一个AVCodec，包含该视频/音频对应的解码器。每种解码器都对应一个AVCodec结构。

- 存数据

视频的话，每个结构一般是存一帧；音频可能有好几帧

解码前数据：AVPacket

解码后数据：AVFrame

他们之间的对应关系如下所示：

![image-20190105174734799](/Users/htq/Library/Application Support/typora-user-images/image-20190105174734799.png)

### AVFrame

uint8_t *data[AV_NUM_DATA_POINTERS]：解码后原始数据（对视频来说是YUV，RGB，对音频来说是PCM）

int linesize[AV_NUM_DATA_POINTERS]：data中“一行”数据的大小。注意：未必等于图像的宽，一般大于图像的宽。

int width, height：视频帧宽和高（1920x1080,1280x720...）

int nb_samples：音频的一个AVFrame中可能包含多个音频帧，在此标记包含了几个

int format：解码后原始数据类型（YUV420，YUV422，RGB24...）

int key_frame：是否是关键帧

enum AVPictureType pict_type：帧类型（I,B,P...）

AVRational sample_aspect_ratio：宽高比（16:9，4:3...）

int64_t pts：显示时间戳

int coded_picture_number：编码帧序号

int display_picture_number：显示帧序号

int8_t *qscale_table：QP表

uint8_t *mbskip_table：跳过宏块表

int16_t (*motion_val[2])[2]：运动矢量表

uint32_t *mb_type：宏块类型表

short *dct_coeff：DCT系数，这个没有提取过

int8_t *ref_index[2]：运动估计参考帧列表（貌似H.264这种比较新的标准才会涉及到多参考帧）

int interlaced_frame：是否是隔行扫描

uint8_t motion_subsample_log2：一个宏块中的运动矢量采样个数，取log的

### AVFormatContext
### AVCodecContext
### AVIOContext
### AVCodec
### AVStream
### AVPacket



##  函数介绍

### avcodec_init()

```c
void avcodec_init(void);
// 初始化libavcodec,一般最先调用该函数
// 引入头文件： #include "libavcodec/avcodec.h"
// 实现在: \ffmpeg\libavcodec\utils.c
// 该函数必须在调用libavcodec里的其它函数前调用,一般在程序启动或模块初始化时调用,如果你调用了多次也无所谓,因为后面的调用不会做任何事情.从函数的实现里你可以发现,代码中对多次调用进行了控制.
// 该函数是非线程安全的
```

### av_register_all()

```c
void av_register_all(void);
// 初始化 libavformat和注册所有的muxers、demuxers和protocols，
// 一般在调用avcodec_init后调用该方法
// 引入头文件：#include "libavformat/avformat.h"
// 实现在:\ffmpeg\libavformat\allformats.c
// 其中会调用avcodec_register_all()注册多种音视频格式的编解码器,并注册各种文件的编解复用器
// 当然，你也可以不调用该函数，而通过选择调用特定的方法来提供支持
```

### avformat_alloc_context()

```c
AVFormatContext *avformat_alloc_context(void);
// 分配一个AVFormatContext结构
// 引入头文件：#include "libavformat/avformat.h"
// 实现在:\ffmpeg\libavformat\options.c
// 其中负责申请一个AVFormatContext结构的内存,并进行简单初始化
// avformat_free_context()可以用来释放该结构里的所有东西以及该结构本身
// 也是就说使用 avformat_alloc_context()分配的结构,需要使用avformat_free_context()来释放
// 有些版本中函数名可能为: av_alloc_format_context();
```

### avformat_free_context()
```c
void avformat_free_context(AVFormatContext *s);
// 释放一个AVFormatContext结构
// 引入头文件：#include "libavformat/avformat.h"
// 实现在:\ffmpeg\libavformat\utils.c
// 使用 avformat_alloc_context()分配的结构,采用该函数进行释放,除释放AVFormatContext结构本身内存之外,AVFormatContext中指针所指向的内存也会一并释放
// 有些版本中函数名猜测可能为: av_free_format_context();
```

### av_close_input_file()
```c
void av_close_input_file(AVFormatContext *s);
// 关闭使用avformat_close_input()打开的输入文件容器,但并不关系它的codecs
// 引入头文件：#include "libavformat/avformat.h"
// 使用av_open_input_file 打开的文件容器,可以使用该函数关闭
// 使用 av_close_input_file 关闭后,就不再需要使用avformat_free_context 进行释放了
```

### av_find_stream_info()
```c
int av_find_stream_info(AVFormatContext *ic);
// 通过读取媒体文件的中的包来获取媒体文件中的流信息,对于没有头信息的文件如(mpeg)是非常有用的,
// 该函数通常重算类似mpeg-2帧模式的真实帧率,该函数并未改变逻辑文件的position.
// 引入头文件：#include "libavformat/avformat.h"
// 也就是把媒体文件中的音视频流等信息读出来,保存在容器中,以便解码时使用
// 返回>=0时成功,否则失败
```

### avcodec_find_decoder()

```c
AVCodec *avcodec_find_decoder(enum CodecID id);
// 通过code ID查找一个已经注册的音视频解码器
// 引入 #include "libavcodec/avcodec.h"
// 实现在: \ffmpeg\libavcodec\utils.c
// 查找解码器之前,必须先调用av_register_all注册所有支持的解码器
// 查找成功返回解码器指针,否则返回NULL
// 音视频解码器保存在一个链表中,查找过程中,函数从头到尾遍历链表,通过比较解码器的ID来查找
```

### avcodec_find_decoder_by_name()

```c
AVCodec *avcodec_find_decoder_by_name(constchar *name);
// 通过一个指定的名称查找一个已经注册的音视频解码器
// 引入 #include "libavcodec/avcodec.h"
// 实现在: \ffmpeg\libavcodec\utils.c
// 查找解码器之前,必须先调用av_register_all注册所有支持的解码器
// 查找成功返回解码器指针,否则返回NULL
// 音视频解码器保存在一个链表中,查找过程中,函数从头到尾遍历链表,通过比较解码器的name来查找
```

### avcodec_find_encoder()

```c
AVCodec *avcodec_find_encoder(enum CodecID id);
// 通过code ID查找一个已经注册的音视频编码器
// 引入 #include "libavcodec/avcodec.h"
// 实现在: \ffmpeg\libavcodec\utils.c
// 查找编码器之前,必须先调用av_register_all注册所有支持的编码器
// 查找成功返回编码器指针,否则返回NULL
// 音视频编码器保存在一个链表中,查找过程中,函数从头到尾遍历链表,通过比较编码器的ID来查找
```


### avcodec_find_encoder_by_name()
```c
AVCodec *avcodec_find_encoder_by_name(constchar *name);
// 通过一个指定的名称查找一个已经注册的音视频编码器
// 引入 #include "libavcodec/avcodec.h"
// 实现在: \ffmpeg\libavcodec\utils.c
// 查找编码器之前,必须先调用av_register_all注册所有支持的编码器
// 查找成功返回编码器指针,否则返回NULL
// 音视频编码器保存在一个链表中,查找过程中,函数从头到尾遍历链表,通过比较编码器的名称来查找
```

### avcodec_open()
```c
int avcodec_open(AVCodecContext *avctx, AVCodec *codec);
// 使用给定的AVCodec初始化AVCodecContext
// 引入#include "libavcodec/avcodec.h"
// 方法: avcodec_find_decoder_by_name(), avcodec_find_encoder_by_name(), avcodec_find_decoder() and avcodec_find_encoder() 提供了快速获取一个codec的途径
// 该方法在编码和解码时都会用到
// 返回0时成功,打开作为输出时,参数设置不对的话,调用会失败
```

### av_guess_format()
```c
AVOutputFormat *av_guess_format(constchar *short_name, constchar *filename, constcha *mime_type);
// 返回一个已经注册的最合适的输出格式
// 引入#include "libavformat/avformat.h"
// 可以通过 const char *short_name 获取,如"mpeg"
// 也可以通过 const char *filename 获取,如"E:\a.mp4"
```

### av_new_stream()
```c
AVStream *av_new_stream(AVFormatContext *s, int id);
// 为媒体文件添加一个流,一般为作为输出的媒体文件容器添加音视频流
// 引入 #include "libavformat/avformat.h"
// 再打开源文件时用户一般不需要直接调用该方法
```

### dump_format()
```c
attribute_deprecated void dump_format(AVFormatContext *ic,  int index, constchar *url, int is_output);
// 该函数的作用就是检查下初始化过程中设置的参数是否符合规范
// 有些版本中为 av_dump_format
```

### av_set_parameters()
```c
attribute_deprecated int av_set_parameters(AVFormatContext *s, AVFormatParameters *ap);
// 设置初始化参数
// 不赞成跳过该方法,直接调用 avformat_write_header/av_write_header
```

### av_write_header()
```c
attribute_deprecated int av_write_header(AVFormatContext *s);
// 把流头信息写入到媒体文件中
// 返回0成功
```

### av_init_packet()
```c
void av_init_packet(AVPacket *pkt);
// 使用默认值初始化AVPacket
// 定义AVPacket对象后,请使用av_init_packet进行初始化
```

### av_free_packet()
```c
void av_free_packet(AVPacket *pkt);
// 释放AVPacket对象
```

### av_read_frame()
```c
int av_read_frame(AVFormatContext *s, AVPacket *pkt);
// 从输入源文件容器中读取一个AVPacket数据包
// 该函数读出的包并不每次都是有效的,对于读出的包我们都应该进行相应的解码(视频解码/音频解码),
// 在返回值>=0时,循环调用该函数进行读取,循环调用之前请调用av_free_packet函数清理AVPacket
```

### avcodec_decode_video2()
```c
int avcodec_decode_video2(AVCodecContext *avctx, AVFrame *picture,
                        int *got_picture_ptr,
                         AVPacket *avpkt);
// 解码视频流AVPacket
// 使用av_read_frame读取媒体流后需要进行判断,如果为视频流则调用该函数解码
// 返回结果<0时失败,此时程序应该退出检查原因
// 返回>=0时正常,假设 读取包为:AVPacket vPacket 返回值为 int vLen; 每次解码正常时,对vPacket做
// 如下处理:
//   vPacket.size -= vLen;
//   vPacket.data += vLen;
// 如果 vPacket.size==0,则继续读下一流包,否则继续调度该方法进行解码,直到vPacket.size==0
// 返回 got_picture_ptr > 0 时,表示解码到了AVFrame *picture,其后可以对picture进程处理
```

### avcodec_decode_audio3()
```c
int avcodec_decode_audio3(AVCodecContext *avctx, int16_t *samples,
                         int *frame_size_ptr,
                         AVPacket *avpkt);
// 解码音频流AVPacket
// 使用av_read_frame读取媒体流后需要进行判断,如果为音频流则调用该函数解码
// 返回结果<0时失败,此时程序应该退出检查原因
// 返回>=0时正常,假设 读取包为:AVPacket vPacket 返回值为 int vLen; 每次解码正常时,对vPacket做
// 如下处理:
//   vPacket.size -= vLen;
//   vPacket.data += vLen;
// 如果 vPacket.size==0,则继续读下一流包,否则继续调度该方法进行解码,直到vPacket.size==0
```