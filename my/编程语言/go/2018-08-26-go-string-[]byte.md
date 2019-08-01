# Golang 中 []byte和string
## string与[]byte
	- string底层指向常量，每次改变值都要重新分配内存，另外还有gc回收开销
	- []byte是也个slice，改变值不需要重新分配内存
	- []bytew不能直接进行字符串对比，因此不能用作map的key
	- 字符处理、大量字符串处理，尽量使用[]byte，性能比较好
string->[]byte：

[]byte->string：

## bytes.buffer

>A Buffer is a variable-sized buffer of bytes with Read and Write methods.
 The zero value for Buffer is an empty buffer ready to use.

```GO
type Buffer struct {
	buf      []byte // contents are the bytes buf[off : len(buf)]
	off      int    // read at &buf[off], write at &buf[len(buf)]
	lastRead readOp // last read operation, so that Unread* can work correctly.
	// memory to hold first slice; helps small buffers avoid allocation.
	bootstrap [64]byte
}
```

 1.底层是[]byte, off记录当前read位置
 2.实现了io.ReadWriter接口，另外还实现了ByteWriter，ByteReader，StringWriter,RuneReaderWriter都是Read和Writer的变种。
```GO 
type ReadWriter interface {
	Reader
	Writer
}
 
type Reader interface {
	Read(p []byte) (n int, err error)
}

type Writer interface {
	Write(p []byte) (n int, err error)
}
 
``` 