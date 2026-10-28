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
