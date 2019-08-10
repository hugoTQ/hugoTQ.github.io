```java
thumbnailPara.setTime(12);
//设置截图的长边，范围(380,3840)。截图的短边按照该尺寸与原始视频像素等比缩放计算
thumbnailPara.setMaxLength(480);
//设置纵横比(min = 0, max = 1)
thumbnailPara.setAspectRatio(0);
//设置截图格式，0表示默认，1表示JPG格式。
thumbnailPara.setFormat(1);
```

