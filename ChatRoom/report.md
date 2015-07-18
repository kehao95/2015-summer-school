# 第五次实验
柯豪 2013013295


## 项目内容
使用firebase实现在线聊天室


实验要求
- 让用户进入聊天室的时候输入自己的昵称昵称不允许冲突,若冲突则提示用户重新输入昵称
  - 使用事件监听姓名输入框的blur（失去焦点）如果用户没有输入用户名或者用户名不合法，则强制焦点定位在姓名输入框。要求用户完成姓名输入。
  - 使用firebase push set接口
- 用户能够发送信息
  - 使用firebase push 发送信息到 messages reference。
  - 发送前会再一次检查用户名合法性。
- 对于用户发出的信息,其他用户能够接收到
  - 使用firebase on child_added 事件监听messageRef 当有新的消息加入的时候写入消息窗口。
  - （如果消息发送人是自己则改变样式靠右显示）
- 能够显示聊天室中所有用户的列表
  - 使用了firebase on ‘value’事件监听userlist 维持一个变量储存所有在线的用户名
  - 每当有变动则刷新右侧用户列表。
  - 使用firebse Disconnect().remove()方法保证断开链接的时候可以删除此用户。

说明
- 本项目javascript方面使用的是CoffeeScript编译而来注释仅在ChatRoom.coffee文件中。
- 本项目使用的第三方资源：
  - jquery
  - firebases
  - UI基于firebase chat demo 二次开发
