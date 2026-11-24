# 资料出处

来源：《macOS 原生应用设计规范》2026 年 10 月深度研究版。沿用原章节号及〔Apple〕〔建议〕〔条件〕标记。版本专属行为与 API 按目标 SDK 和当前 Apple 官方文档核对，第三方观察用于辅助判断。

### 10.7 资料依据（Apple 官方）

| 编号 | 资料名称 | 完整 URL |
|---|---|---|
| A1 | Designing for macOS — HIG | https://developer.apple.com/design/human-interface-guidelines/designing-for-macos/ |
| A2 | Design principles — HIG | https://developer.apple.com/design/human-interface-guidelines/design-principles/ |
| A3 | Typography — HIG（含 macOS 完整文本样式表） | https://developer.apple.com/cn/design/human-interface-guidelines/typography |
| A4 | Modernize your AppKit app — WWDC26（macOS 27） | https://developer.apple.com/videos/play/wwdc2026/289/ |
| A5 | Build an AppKit app with the new design — WWDC25 | https://developer.apple.com/videos/play/wwdc2025/310/ |
| A6 | Windows — HIG | https://developer.apple.com/design/human-interface-guidelines/windows/ |
| A7 | Materials — HIG | https://developer.apple.com/design/human-interface-guidelines/materials/ |
| A8 | Scroll views — HIG（2026 更新） | https://developer.apple.com/design/human-interface-guidelines/scroll-views/ |
| A9 | Windows — HIG（窗口结构和状态） | https://developer.apple.com/design/human-interface-guidelines/windows/ |
| A10 | Sidebars — HIG（2026 更新） | https://developer.apple.com/design/human-interface-guidelines/sidebars/ |
| A11 | Split views — HIG | https://developer.apple.com/design/human-interface-guidelines/split-views/ |
| A12 | Layout — HIG | https://developer.apple.com/design/human-interface-guidelines/layout/ |
| A13 | Toolbars — HIG | https://developer.apple.com/design/human-interface-guidelines/toolbars/ |
| A14 | Lists and tables — HIG | https://developer.apple.com/design/human-interface-guidelines/lists-and-tables/ |
| A15 | Accessibility — HIG | https://developer.apple.com/design/human-interface-guidelines/accessibility/ |
| A16 | Buttons — HIG | https://developer.apple.com/design/human-interface-guidelines/buttons/ |
| A17 | Toggles — HIG | https://developer.apple.com/design/human-interface-guidelines/toggles/ |
| A18 | Segmented controls — HIG | https://developer.apple.com/design/human-interface-guidelines/segmented-controls/ |
| A19 | Sheets — HIG（2026 更新） | https://developer.apple.com/design/human-interface-guidelines/sheets/ |
| A20 | Popovers — HIG | https://developer.apple.com/design/human-interface-guidelines/popovers/ |
| A21 | Alerts — HIG | https://developer.apple.com/design/human-interface-guidelines/alerts/ |
| A22 | Settings — HIG | https://developer.apple.com/design/human-interface-guidelines/settings/ |
| A23 | Form — SwiftUI Documentation | https://developer.apple.com/documentation/swiftui/form |
| A24 | Progress indicators — HIG | https://developer.apple.com/design/human-interface-guidelines/progress-indicators/ |
| A25 | Context menus — HIG | https://developer.apple.com/design/human-interface-guidelines/context-menus/ |
| A26 | Menus — HIG（2026 菜单图标更新） | https://developer.apple.com/design/human-interface-guidelines/menus/ |
| A27 | Keyboards — HIG | https://developer.apple.com/design/human-interface-guidelines/keyboards/ |
| A28 | Search fields — HIG | https://developer.apple.com/design/human-interface-guidelines/search-fields/ |
| A29 | Design intuitive search experiences — WWDC26 | https://developer.apple.com/videos/play/wwdc2026/292/ |
| A30 | Context menus — HIG（右键菜单规则） | https://developer.apple.com/design/human-interface-guidelines/context-menus/ |
| A31 | App icons — HIG（2026 更新） | https://developer.apple.com/design/human-interface-guidelines/app-icons/ |
| A32 | Color — HIG | https://developer.apple.com/design/human-interface-guidelines/color/ |
| A33 | Materials — HIG（Liquid Glass 与内容层） | https://developer.apple.com/design/human-interface-guidelines/materials/ |
| A34 | Platforms State of the Union — WWDC26 | https://developer.apple.com/videos/play/wwdc2026/102/ |
| A35 | Motion — HIG | https://developer.apple.com/design/human-interface-guidelines/motion/ |
| A36 | Pointing devices — HIG | https://developer.apple.com/design/human-interface-guidelines/pointing-devices/ |
| A37 | Drag and drop — HIG | https://developer.apple.com/design/human-interface-guidelines/drag-and-drop/ |

### 10.8 资料依据（第三方专业研究与解读）

| 编号 | 资料 | 采用的主要观点 | 完整 URL |
|---|---|---|---|
| T1 | Nielsen Norman Group：Tooltip Guidelines | 任务必要信息常显，Tooltip 仅补充，支持键盘焦点 | https://www.nngroup.com/articles/tooltip-guidelines/ |
| T2 | Nielsen Norman Group：Icon Usability | 图标歧义高，重要导航应配常显文字标签 | https://www.nngroup.com/articles/icon-usability/ |
| T3 | Ars Technica：macOS 27 Golden Gate Review | 2026 版标题栏边界、透明度、菜单图标的实机观察 | https://arstechnica.com/gadgets/2026/09/macos-27-golden-gate-the-ars-technica-review/ |
| T4 | Nielsen Norman Group：Menu Design Checklist | 桌面导航要可见，不宜全部折叠为汉堡菜单 | https://www.nngroup.com/articles/menu-design/ |
| T5 | University of Michigan Library Design System：Typography | 阅读宽度、行长、扫描性方面的参考 | https://design-system.lib.umich.edu/visual-elements/typography/ |
| T6 | Nielsen Norman Group：Progressive Disclosure | 频繁功能常显、复杂选项渐进展示 | https://www.nngroup.com/articles/progressive-disclosure/ |
| T7 | MacRumors：All the Liquid Glass Changes in macOS Golden Gate | 透明度/对比度与新系统表现的第三方观察 | https://www.macrumors.com/2026/06/09/macos-golden-gate-liquid-glass/ |

**文档界限：** 本规范中的系统正文字号、内建文字等级、平台组件行为、菜单规则、图标资源尺寸、当前 macOS 27 视觉变更均依据 Apple 资料。侧边栏初始宽度、窗口初始尺寸、自绘控件高度、间距 token、圆角和自定义动画时长属于统一视觉体系的推荐值；涉及用户系统设置的区域优先使用系统动态值。

### 视觉精修版资料

《macOS 原生应用设计规范 · 视觉精修版》，资料检索日期 2026-11-24。以下是其所列出处，设计数值和工作区配方为规范建议，应用前结合目标平台和实际内容判断。

| 编号 | 资料 | 用途 |
| --- | --- | --- |
| V01 | Apple HIG：Typography — https://developer.apple.com/design/human-interface-guidelines/typography | 系统字体与文字角色 |
| V02 | Apple Fonts — https://developer.apple.com/fonts/ | 系统字体、字重和等宽字体 |
| V03 | Apple HIG：SF Symbols — https://developer.apple.com/design/human-interface-guidelines/sf-symbols | 符号字重、渲染及使用边界 |
| V04 | Apple：Creating custom SF Symbols — https://developer.apple.com/documentation/technologyoverviews/creating-custom-sf-symbols | 自定义符号的模板与基线 |
| V05 | Figma：Create a reusable icon grid — https://help.figma.com/hc/en-us/articles/18770195788951-Create-a-reusable-icon-grid | 自制图标网格 |
| V06 | IBM：UI icons usage — https://www.ibm.com/design/language/iconography/ui-icons/usage/ | 图标视觉重量与留白 |
| V07 | Apple HIG：App icons — https://developer.apple.com/design/human-interface-guidelines/app-icons | App 图标与系统外观 |
| V08 | Apple WWDC25：Get to know the new design system — https://developer.apple.com/videos/play/wwdc2025/356/ | 形状、同心关系与光学对齐 |
| V09 | Apple：CALayer contentsScale — https://developer.apple.com/documentation/quartzcore/calayer/contentsscale | 点与像素倍率 |
| V10 | Apple：NSView backingAlignedRect — https://developer.apple.com/documentation/appkit/nsview/backingalignedrect(_:options:) | 对齐 backing store |
| V11 | W3C：Contrast Minimum — https://www.w3.org/WAI/WCAG22/Understanding/contrast-minimum.html | 文字对比参考 |
| V12 | W3C：Non-text Contrast — https://www.w3.org/WAI/WCAG22/Understanding/non-text-contrast.html | 组件和图形对比参考 |
| V13 | Apple HIG：Focus and selection — https://developer.apple.com/design/human-interface-guidelines/focus-and-selection/ | 焦点与选择 |
| V14 | Apple：Reduce Transparency — https://developer.apple.com/documentation/swiftui/environmentvalues/accessibilityreducetransparency | 减少透明度 |
| V15 | Apple HIG：Materials — https://developer.apple.com/design/human-interface-guidelines/materials | 平台材质 |
| V16 | NNGroup：Data Tables — https://www.nngroup.com/articles/data-tables/ | 数据表查找与比较 |
| V17 | Apple HIG：Charting data — https://developer.apple.com/design/human-interface-guidelines/charting-data | 图表与数据关系 |
| V18 | Apple HIG：Gestures — https://developer.apple.com/design/human-interface-guidelines/gestures | 输入设备与手势 |
