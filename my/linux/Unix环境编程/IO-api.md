## 1. fwrite与fprintf什么区别？

fwrite是以二进制写入，变量内存大小与与写入大小相同（int i=1写入4字节），以文本打开则为乱码（x01，x00，x00，x00 转化为ASC码则为乱码）

fprintf是格式化为ASC码后写入，变量内存大小与写入大小一般不等，每个字符用1个字节（int i=1，写入1字节，int i=10000写入5字节），以文本代开正常显示字符

## 2. fopen的a+与a什么区别？

 相同：若文件不存在则创建，以追加方式写入，最终保存文件都为read write

 不同：以a+ fopen后的句柄不能可写可读，以a fopen后的句柄只能写不能读

## 3. fread，fwrite与 read write区别？

## 4. flush 什么用？





