- 数组

- 指针

- 结构体，变量

  ```c
  typedef struct StreamContext {
      AVCodecContext *dec_ctx;
      AVCodecContext *enc_ctx;
  } StreamContext;
  static StreamContext *stream_ctx;
  
  
  sizeof(*stream_ctx)//?
  sizeof(StreamContext)//?
  ```

  

