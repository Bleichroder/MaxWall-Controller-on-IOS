# MaxWall-Controller-on-IOS
An app made for DLP Display wall software MaxWall which is written by swift 2.0 and base on websocket
***
<br>
## MaxWall
  一款windows下的拼接屏软件，可以实现图片视频上墙，流媒体摄像头抓取及上墙，第三方应用上墙及控制，远程控制等功能，为S3显卡定制

### MaxWall on iOS
  MaxWall控制端s和服务器端通信是通过websock进行k链接和数据传输，本程序根据官方websocket接口文档实现了部分windows控制端的功能，软件由swift2.0完成
  
### Starscream (https://github.com/daltoniam/Starscream)
  websocket的链接建立通过Starscream实现，具体使用方法请参考链接
  
### SwiftJSON (https://github.com/SwiftyJSON/SwiftyJSON)
  JSON字符串的处理选择了SwiftJSON，这个库给出的方法使用简单而且易于上手，具体使用方法请参考链接
