# url特殊字符编码导致访问失败

## 现象

客户端使用c语言curl库访问`http://mpc8.inhuawei.com:8080/notifications/v2?appId=xcode&cluster=cte&notifications=[{"namespaceName":"application","notificationId":"-1"}]`，返回400。

服务端抛异常：

`java.lang.IllegalArgumentException: Invalid character found in the request target. The valid characters are defined in RFC 7230 and RFC 3986`

http://mpc8.inhuawei.com:8080/notifications/v2?appId=xcode&cluster=cte&notifications=[{"namespaceName":"application","notificationId":"-1"}]
http://mpc8.inhuawei.com:8080/notifications/v2?appId=xcode&cluster=cte&notifications=%5B%7B%22namespaceName%22%3A%22application%22%2C%22notificationId%22%3A%22-1%22%7D%5D

## 关于url编码

[关于URL编码](https://blog.csdn.net/tennysonsky/article/details/54176624)

[URL原理、URL编码、URL特殊字符](https://blog.csdn.net/freeking101/article/details/68922983)

> 这是因为网络标准[RFC 1738](http://www.ietf.org/rfc/rfc1738.txt)做了硬性规定：
>
> "...Only alphanumerics [0-9a-zA-Z], the special characters "$-_.+!*'()," [not including the quotes - ed], and reserved characters used for their reserved purposes may be used unencoded within a URL."
> "只有字母和数字[0-9a-zA-Z]、一些特殊符号"$-_.+!*'(),"[不包括双引号]、以及某些保留字，才可以不经过编码直接用于URL。"

简言之，不同的操作系统、不同的浏览器、不同的网页字符集，将导致完全不同的编码结果。但代码里使用Unicode编码再转为url编码（看了下还是没看懂Unicode怎么转出url编码）。

## C代码



## GO代码

```go
import "net/url"
func QueryEscape(s string) string;
```