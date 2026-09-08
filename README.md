# SRTC Swift SDK

实时音视频通信 SDK，支持 iOS 13+ 与 macOS 10.15+。

本仓库只包含分发清单，SDK 以预编译 XCFramework 形式提供。

## 集成

在 `Package.swift` 中添加依赖：

```swift
dependencies: [
    .package(url: "https://github.com/seastart/srtc-swift-sdk.git", from: "1.3.3"),
]
```

在 target 中引用：

```swift
.product(name: "SRTC", package: "srtc-swift-sdk")
```

Xcode 图形界面：**File → Add Package Dependencies…**，填入本仓库地址。

WebRTC 依赖会自动解析，无需另行声明。

## 快速开始

```swift
import SRTC

let srtc = SRTCEngine()

// token 由你的业务后端签发，客户端不参与签名
let channel = try await srtc.joinChannel(token: token)
```

完整文档见 [docs.stmlink.com](https://docs.stmlink.com)。

## iOS 全屏屏幕共享（可选）

iOS 默认的屏幕共享是**应用内采集**，只能采到 App 自己的画面。要采整个系统屏幕，需要额外集成
一个 Broadcast Upload Extension，用本包的 `SRTCBroadcastKit` 产品：

1. Xcode **File → New → Target → Broadcast Upload Extension**，取消勾选 “Include UI Extension”。
2. 给扩展 target 加依赖 `SRTCBroadcastKit`，把模板生成的 `SampleHandler` 改成：

   ```swift
   import SRTCBroadcastKit

   class SampleHandler: SRTCBroadcastSampleHandler {}
   ```

3. App 与扩展加同一个 App Group（需在开发者后台注册），并在**扩展**的 Info.plist 写：

   ```xml
   <key>SRTCAppGroupIdentifier</key>
   <string>group.your.app.group</string>
   ```

4. 业务侧创建轨道时选全屏采集，并用 `SRTCBroadcastPicker` 让用户发起广播：

   ```swift
   let track = srtc.createLocalScreenTrack(
       preset: .h720p,
       mode: .broadcast(appGroup: "group.your.app.group")
   )
   try await track.startCapture()          // 只是开始监听，此时还没有画面
   try await channel.publishLocalTrack(track)
   ```

⚠️ 两条容易踩的：

- **`SRTCBroadcastKit` 只加到扩展 target**，不要同时加到 App target（App 侧的 `SRTC` 里已含
  同一份代码，一个进程里出现两份会让日志配置这类单例变成两个实例）。扩展 target 也**不要**
  依赖 `SRTC`——扩展进程内存上限 50MB，链上 WebRTC 很容易被系统杀掉。
- 全屏采集依赖真实签名与 App Group，**模拟器跑不通，必须真机**。扩展进程的日志不在 Xcode
  控制台，用 Console.app 按 subsystem `com.srtc.broadcast` 过滤。

## 版本

当前版本 **1.3.3**（`SRTCBroadcastKit` **1.0.4**，与本包同 tag 发布，
两者始终配套，不需要也不应该单独指定版本）。

| 平台 | 最低版本 |
| --- | --- |
| iOS | 13.0 |
| macOS | 10.15 |
| Xcode | 15.0 |

屏幕共享需要 macOS 12.3+。
