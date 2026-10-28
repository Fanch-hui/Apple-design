# 动迹

使用 SwiftUI 构建的运动记录 App 界面原型，最低支持 iOS 17。

- 今日：活动概览、每日目标、七日运动与最近记录。
- 记录：搜索、类型筛选、运动详情及手动添加。
- 趋势：七日/三十日统计、运动偏好与活动分布。
- 计时：选择运动、开始、暂停、继续、保存。
- 设置：每日运动目标和系统/浅色/深色外观。

初始运动和心率示意曲线为示例数据。新增运动保存在本次 App 运行的内存中；外观偏好保存在本机。计时页面仅记录经过时长，距离和能量可在手动添加时填写。

## 运行

打开 `Motion.xcodeproj`，选择 `Motion` scheme 和 iPhone 模拟器，然后运行。

工程配置由 `project.yml` 维护。修改源文件或配置后可运行 `xcodegen generate` 更新工程。

命令行构建：

```sh
xcodebuild -project Motion.xcodeproj -scheme Motion -sdk iphonesimulator -configuration Debug -derivedDataPath /tmp/motion-build CODE_SIGNING_ALLOWED=NO build
```

布局和交互由用户在模拟器中人工体验。
