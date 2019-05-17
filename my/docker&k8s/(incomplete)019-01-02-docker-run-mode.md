# docker run的两种模式-Detached vs Foreground模式

## detached
命令：`docker run -d `

- 进程退出，容器也会退出进入stop状态
- 无法与--rm，也即容器stop无法自动清理
- 重新附着一个detached容器，使用docker attach

## Foreground

命令：

`-a=[]`: Attach to stdout/stdin/stderror

`-t`: allocate a tty

`-i`: Keep STDIN open even if not attached

`--sig-proxy=true`:  Proxy all received signals to the process (non-TTY mode only)

`docker run -a stdin -a stdout -i -t ubuntu /bin/bash`

- 可以附着控制台到进程的标准输入输出错误？不是使用交互是怎样的？
- 可以以交互模式运行 `-it`
- foreground模式下不会自动执行进程？
- 进程已停止，`exit/Ctrl+c` 容器则进入stop状态，而`Ctrl+p+q`容器不会进入stop状态
- 进程后台运行中，`exit/Ctrl+c` 退出容器，容器回继续保持running
- 进程在前台运行中？