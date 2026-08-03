# SRTC Swift SDK

实时音视频通信 SDK，支持 iOS 13+ 与 macOS 10.15+。

本仓库只包含分发清单，SDK 以预编译 XCFramework 形式提供。

## 集成

在 `Package.swift` 中添加依赖：

```swift
dependencies: [
    .package(url: "https://github.com/seastart/srtc-swift-sdk.git", from: "1.1.0"),
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

## 版本

当前版本 **1.1.0**。

| 平台 | 最低版本 |
| --- | --- |
| iOS | 13.0 |
| macOS | 10.15 |
| Xcode | 15.0 |

屏幕共享需要 macOS 12.3+。
