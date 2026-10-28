# 余音

使用 SwiftUI 和 AppKit 构建的原生 macOS 音乐播放器 UI 原型，最低支持 macOS 14。

包括精选首页、专辑资料库、可排序多选歌曲表、两份歌单、专辑详情、正在播放、待播清单和独立设置窗口。提供播放状态、切歌、进度、音量、收藏、搜索和深浅色外观交互。

歌曲、艺人和封面为本地原创示例。播放控件用于界面体验；本版本不输出音频、不连接音乐服务。

## 运行

打开 `Resonance.xcodeproj` 并运行 `Resonance` scheme。

```sh
xcodegen generate
xcodebuild -project Resonance.xcodeproj -scheme Resonance -configuration Debug -derivedDataPath /tmp/resonance-build CODE_SIGNING_ALLOWED=NO build
```

设置通过 App 菜单或 ⌘, 打开；空格切换播放，⌘← / ⌘→ 切歌，⌘[ / ⌘] 返回或前进。

Debug 版可通过 `RESONANCE_PREVIEW_PAGE` 选择 `listen`、`albums`、`songs`、`evening`、`focus`、`album`、`playing`、`queue`、`settings`；`RESONANCE_PREVIEW_APPEARANCE` 可设置为 `light` 或 `dark`。
