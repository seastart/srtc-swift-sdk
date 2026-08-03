// 这是一个中转 target，本身不含实现。
//
// 它存在的唯一理由：SPM 的 binaryTarget 不能声明 dependencies，而 SRTC 需要 WebRTC。
// 套这一层之后，接入方只要依赖 SRTC 产品就会自动拿到 WebRTC，不必自己再写一遍。
//
// 业务代码请 `import SRTC`（预编译的 SDK 本体），不需要 import 本模块。
