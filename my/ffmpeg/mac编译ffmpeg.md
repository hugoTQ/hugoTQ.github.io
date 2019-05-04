## 安装brew

```shell
ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
```

## 使用brew安装依赖库

```shell
$ brew install automake fdk-aac git libtool libvorbis libvpx opus sdl shtool yasm texi2html theora wget x264 xvid lame libass
```

如果有的库始终安装不成功，那么你可以尝试先升级更新下 brew：

```shell
$ brew update
```

brew update可能会报错，原因大多是本地的 brew 仓库（通常在 /usr/local/ 目录下）发生了冲突，这时候需要执行下 git 命令处理下冲突再更新 brew，命令如下：

```shell
$ cd $(brew --prefix)
$ git reset --hard HEAD
$ brew update
```

## 编译FFmpeg

```shell
// 下载 FFmpeg 源码：
$ git clone http://source.ffmpeg.org/git/ffmpeg.git ffmpeg
// 编译：
$ cd ffmpeg
$ ./configure  --prefix=/usr/local --enable-gpl --enable-nonfree --enable-libass --enable-libfdk-aac --enable-libfreetype --enable-libmp3lame --enable-libopus --enable-libtheora --enable-libvorbis --enable-libvpx --enable-libx264 --enable-libxvid --extra-ldflags=-L/usr/local/lib
$ make && make install
```

插一句，由于我一开始没有使用brew install 安装上面的一堆依赖，所以缺多依赖，例如：

1. `libmp3lame not found`, google下载源码通过

   ```shell
   curl -O -L https://downloads.sourceforge.net/project/lame/lame/3.100/lame-3.100.tar.gz
   ./configure && make && make install，
   
   但是最新版lame-3.100 编译错误。。lame-3.99才成功
   ```

2. `ERROR: opus not found using pkg-config`

   ```shell
   $ curl -O -L https://archive.mozilla.org/pub/opus/opus-1.3.tar.gz
   tar xzvf opus-1.3.tar.gz
   $ cd opus-1.3
   $ ./configure --prefix="$HOME/ffmpeg_build" --disable-shared
   $ make && make install
   $ export PKG_CONFIG_PATH=/usr/local/lib/pkgconfig:$PKG_CONFIG_PATH
   and then try again
   ```

[FFmpeg官网](https://trac.ffmpeg.org/wiki/CompilationGuide)已经提供详细的编译方法，提供了一个一个依赖库安装的方法，也有docker镜像 编译FFmpeg，其中也提供mac的编译方法非常简单。

## 测试

编译完成不报错的话，接下来你就可以试试拿一个视频来播着试试了，在 FFmpeg 目录下执行下面的命令让 FFmpeg 播放一个视频：

```shell
$ ffplay http://devimages.apple.com.edgekey.net/streaming/examples/bipbop_16x9/gear5/prog_index.m3u8
```



