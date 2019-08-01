# 关于malloc,calloc,realloc区

```c
   void *malloc(size_t size);
   void *calloc(size_t nmemb, size_t size);
   void *realloc(void *ptr, size_t size);
```
- malloc和realloc不会清零内存，calloc会清零内存

- calloc是n*size 适合申请数组空间，当然非数组也适合，即nmemb传入1

- realloc适合内存缩小和扩大，一般使用方式`p = (int *) realloc(p, sizeof(int) *15);` 

  - 无论缩小和扩大，不保证p地址不变，相反p指向地址一般发生会改变，（疑问缩小也改变吗？）

  - 无论缩小和扩大，原内容不会改变

  - 若缩小，丢弃部分已释放（free）

  - 可以传入空指针，相当于malloc

    - `int* p = (int *)realloc (0,sizeof(int) * 10)` 等于 

      `int* p = (int *)malloc(sizeof(int) * 10);`