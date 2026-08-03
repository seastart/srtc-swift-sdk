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
        // WebRTC。SRTC 的 public API 上出现了 LKRTCVideoRotation / LKRTCMediaStreamTrack，
        // 所以这个依赖必须暴露给使用方，不能藏起来。
        .package(url: "https://github.com/livekit/webrtc-xcframework.git", exact: "144.7559.10"),
    ],
    targets: [
        // 预编译的 SDK 本体。`import SRTC` 导入的就是它。
        .binaryTarget(
            name: "SRTC",
            url: "https://repo.open.seastart.cn/repository/vcs-releases/rtc-swift-sdk-1.0.0.zip",
            checksum: "8082daa6ff2e2581d49e2c898dfb3c192bbf6ea20b154800c8e28b6e6ef85520"
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
