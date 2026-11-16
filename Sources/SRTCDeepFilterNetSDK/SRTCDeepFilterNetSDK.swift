// 这是一个中转 target，本身不含实现。
//
// SPM 的 binaryTarget 不能声明 dependencies，而降噪插件运行时要链接 SRTC.framework。
// 套这一层之后，接入方只依赖 SRTCDeepFilterNet 产品也能拿到 SRTC 与 WebRTC。
//
// 业务代码请 `import SRTCDeepFilterNet`（预编译的插件本体），不需要 import 本模块。
