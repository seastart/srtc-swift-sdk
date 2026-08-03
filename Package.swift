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
            url: "https://repo.open.seastart.cn/repository/vcs-releases/rtc-swift-sdk-1.1.0.zip",
            checksum: "ff785c6779ec60f70983a52c9eda39ace20709b045ff902febcd1d49c9546541"
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
    ]
)
