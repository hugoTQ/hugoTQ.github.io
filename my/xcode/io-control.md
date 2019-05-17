- 停止io_read

   1. read 异常

      置io error->待io cotrol check error -> io control 置stop->io read 判断stop做清理 ：关闭所有邮箱句柄，FILECLOSE标记，若错误码非INVALID则设置read result为SUCCESS

   2. read end

   3. 3.io control控制

- 停止io write异常
  	1.write 异常
  	2.write over
  	3.io control控制

