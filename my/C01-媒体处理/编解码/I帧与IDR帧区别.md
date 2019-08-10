## I帧与IDR帧区别

> IDR帧的作用是立刻刷新,使错误不致传播,从IDR帧开始,重新算一个新的序列开始编码。而I帧不具有随机访问的能力，这个功能是由IDR承担。IDR会导致DPB（DecodedPictureBuffer参考帧列表——这是关键所在）清空，而I不会。

- I帧与GOP关系？一个GOP里只能有一个I帧？GOP第一帧必须是I帧？
  很多资料都说两个I帧之间为一个GOP其实是不正确的，准确地说应该是两个IDR之间为一个GOP（但是在open-GOP中第一帧可能不是IDR？存疑），由此可以看出一个GOP中可以有多个I帧。
  在open-GOP的结构中需要明确区分I帧与IDR帧，而在close-GOP中可以视为相同。

GOP举例：
I B P P B  是一个open-GOP，因为最后一帧是一个B帧

I B B B P 是一个close-GOP，最后一个帧是P帧

IDR B B P 是一个close-GOP，IDR刷新了参考值列表，不会参考前面的GOP

- 在x264中open-GOP默认关闭

