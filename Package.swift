// swift-tools-version: 5.9
//
// SRTC Swift SDK —— 二进制分发清单
//
// 本文件由构建脚本自动生成，请勿手工编辑版本号与 checksum。

import PackageDescription

let package = Package(
    name: "srtc-swift-sdk",
    platforms: [
        .iOS(.v13),
        .macOS(.v10_15),
    ],
    products: [
        .library(
            name: "SRTC",
            targets: ["SRTCSDK"]
        ),
        // iOS 屏幕共享（全屏采集）的扩展侧库。
        //
        // ⚠️ 只加到 Broadcast Upload Extension 的 target 上，**不要**加到 App target：
        // App 侧的 SRTC 里已经静态含有同一份代码，一个进程里出现两份同名类型会让
        // 日志配置这类单例变成两个实例，dyld 还可能报 class implemented in both。
        // 扩展进程有 50MB 内存上限，所以它也绝不能反过来去链 SRTC。
        .library(
            name: "SRTCBroadcastKit",
            targets: ["SRTCBroadcastKit"]
        ),
    ],
    dependencies: [
        // WebRTC。公开 API 已不暴露任何底层 WebRTC 类型，但 SRTC 在运行时动态链接
        // LiveKitWebRTC.framework，所以依赖仍需声明。由下面的中转 target 自动传递给
        // 接入方 —— 接入方不必在自己的 Package.swift 里重复写这一条。
        .package(url: "https://github.com/livekit/webrtc-xcframework.git", exact: "144.7559.10"),
    ],
    targets: [
        // 预编译的 SDK 本体。`import SRTC` 导入的就是它。
        .binaryTarget(
            name: "SRTC",
            url: "https://repo.open.seastart.cn/repository/vcs-releases/rtc-swift-sdk-1.3.3.zip",
            checksum: "77422c6301a8ca529f396393ad7bbf9c1536523985f37681c9b02677d0bb5712"
        ),
        // 中转 target。binaryTarget 自己不能声明 dependencies，所以套一层普通 target
        // 把 WebRTC 依赖传递给使用方 —— 否则每个接入方都得自己再写一遍 WebRTC 依赖。
        .target(
            name: "SRTCSDK",
            dependencies: [
                "SRTC",
                .product(name: "LiveKitWebRTC", package: "webrtc-xcframework"),
            ],
            path: "Sources/SRTCSDK"
        ),
        // 屏幕共享扩展侧。不依赖 WebRTC，所以直接暴露 binaryTarget，不需要中转 target。
        // 与 SRTC 同 tag 发布，两侧线传协议因此始终匹配。
        .binaryTarget(
            name: "SRTCBroadcastKit",
            url: "https://repo.open.seastart.cn/repository/vcs-releases/rtc-swift-broadcastkit-1.0.4.zip",
            checksum: "5840a26a34525abb90271c74d56dfe03c3a2db3a838eadb4dcc7b19ab681d627"
        ),
    ]
)
