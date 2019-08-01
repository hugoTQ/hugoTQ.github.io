- 数组

- 指针

- 结构体（[字节对齐](https://blog.csdn.net/lanzhihui_10086/article/details/44353381)，这个好像只以32位为例哦，64位呢？）

- 变量

  ```c
  typedef struct StreamContext {
      AVCodecContext *dec_ctx;
      AVCodecContext *enc_ctx;
  } StreamContext;
  static StreamContext *stream_ctx;
  
  
  sizeof(*stream_ctx)//?
  sizeof(StreamContext)//?
  ```

  

