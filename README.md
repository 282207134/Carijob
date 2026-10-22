# Carijob · Flutter 求职应用

基于 Pixso「Carijob - UI Kit」实现的 Flutter 应用。包含职位发现、搜索筛选、职位详情、简历选择、本地模拟投递、进度追踪与个人资料编辑。沿用设计稿的英文界面；本说明文档使用中文。

**这是可运行的本地演示版本。** 当前没有招聘后端：登录不验证真实账号，投递不会发送给企业，Google OAuth、邮件、短信、多因素认证和系统推送未接入。页面内已标明相应演示行为。

## 交付文件

已提供 [Flutter 源码压缩包](dist/carijob-source.zip)、[Android 手机安装包（ARM64）](dist/apk/carijob-arm64-v8a.apk) 和 [浏览器构建包](dist/carijob-web.zip)。其他 Android 架构见 [交付目录](dist/README.md)。安装包使用调试签名，供体验使用；源码包不包含这些二进制交付文件。

本次已通过静态分析、59 项自动检查、Android 模拟器完整流程和 Android / Web 发布构建。共准备 53 张页面状态截图及 11 张模拟器运行截图，详见 [验证记录](docs/VALIDATION.md)。

## 主要界面

以下图片来自实际 Flutter 页面渲染，原始 Pixso 参考图单独保存在 [docs/design](docs/design/)。

| 首页 | 职位探索 | 职位详情 |
| :---: | :---: | :---: |
| ![首页](docs/screenshots/home.png) | ![职位探索](docs/screenshots/explore.png) | ![职位详情](docs/screenshots/details.png) |

| 投递表单 | 我的投递 | 个人中心 |
| :---: | :---: | :---: |
| ![投递表单](docs/screenshots/apply.png) | ![我的投递](docs/screenshots/my-jobs.png) | ![个人中心](docs/screenshots/profile.png) |

完整截图、引导页、认证、空状态、筛选弹层、资料编辑以及申请阶段见 [全部页面截图](docs/SCREENSHOTS.md)。

## 已实现功能

- 四个主导航：Home、Explore、My Job、Profile，切换时保留页面状态。
- 四步引导；登录、注册、职位偏好、经验、技能选择；表单校验；本地演示密码重置（验证码 123456）。
- 关键词搜索职位、公司、行业；职位类型、地区、行业分类与发布时间组合过滤；Job / Company 结果切换和空状态。
- 推荐职位横向浏览、职位完整介绍、公司其他机会、通知列表、收藏及收藏空状态。
- 原生文件选择器选择 PDF / DOC / DOCX 简历，限制 5MB；可使用明确标注的演示简历。投递保存职位、联系信息、简历文件名和求职信。
- 防止重复投递；Active / Rejected 分类；Submitted、Test、Interview、Offer 进度和拒绝状态；演示面试安排。
- 个人完整资料、基本信息、工作经历、教育、技能和偏好编辑；设置项、FAQ 折叠、关于与退出确认。
- 本地持久化：重新启动后保留资料、收藏、投递、偏好及演示登录状态。退出后保留本机资料。

## 项目结构与架构

```text
Carijob/
├─ lib/
│  ├─ main.dart                  # 初始化本地数据、系统栏样式、应用入口
│  ├─ app.dart                   # MaterialApp、命名路由、窄屏适配
│  ├─ core/
│  │  ├─ app_state.dart          # ChangeNotifier 状态、本地持久化、AppScope
│  │  └─ theme.dart              # 颜色、字体、输入框和按钮主题
│  ├─ data/
│  │  ├─ models.dart             # Job、JobFilter、Application
│  │  └─ job_repository.dart     # 演示职位库及组合查询
│  ├─ features/
│  │  ├─ shell.dart              # 四个主导航与顶部栏
│  │  ├─ auth.dart               # 引导、认证与偏好选择
│  │  ├─ discovery.dart          # 首页、探索、搜索、筛选、通知
│  │  ├─ jobs.dart               # 职位详情、投递、成功页、进度
│  │  └─ profile.dart            # 资料、编辑、设置与帮助
│  └─ shared/widgets.dart        # 页面骨架、职位卡、表单、标签等
├─ assets/
│  ├─ fonts/                     # Archivo 字体及 OFL 许可
│  └─ images/                    # 从 Pixso 导出的图形、头像、公司标志
├─ test/
│  ├─ app_cases.dart              # 查询、持久化与关键交互测试
│  └─ screenshots_test.dart      # 页面截图与布局回归检查
├─ integration_test/             # Android 实机环境流程测试
├─ test_driver/                  # 保存模拟器测试截图
├─ docs/
│  ├─ ARCHITECTURE.md            # 架构、数据、路由和后续扩展说明
│  ├─ SCREENSHOTS.md             # 全部页面截图索引
│  ├─ VALIDATION.md              # 验证环境、执行命令与结果
│  ├─ design/                   # Pixso 原设计参考截图
│  └─ screenshots/              # Flutter 渲染截图与 Android 运行截图
├─ android/                     # Android 工程
├─ ios/                         # iOS 工程
└─ web/                         # 浏览器预览工程
```

使用轻量分层结构：页面读取 AppScope 中的 AppState，用户操作更新状态，ChangeNotifier 通知相关界面刷新，SharedPreferences 保存本地 JSON。职位查询集中在 JobRepository；页面复用同一套卡片、表单与主题。仅保留两个业务插件，避免引入不必要的路由和状态管理框架。

更详细的数据流和替换后端的位置见 [架构说明](docs/ARCHITECTURE.md)。

## 运行

开发环境：Flutter 3.47.7 / Dart 3.13.5。

```sh
flutter pub get
flutter run
```

Android 模拟器：

```sh
flutter emulators
flutter emulators --launch carijob_test
flutter devices
flutter run -d <设备 ID>
```

浏览器预览：

```sh
flutter run -d chrome
```

首次进入四步引导，点击 Skip 可到登录页；使用 Explore Demo 直接体验。登录表单也可输入任意格式正确的邮箱与至少 6 位密码进入本地演示。密码不保存。注册会记录本机展示姓名与邮箱。

iOS 工程已生成，需要在 macOS / Xcode 中构建与签名；本次 Windows 环境未执行 iOS 构建。

## 检查与截图

```sh
flutter analyze
flutter test
flutter test test/screenshots_test.dart --update-goldens
flutter drive --driver=test_driver/integration_test.dart --target=integration_test/app_flow_test.dart -d <Android 设备 ID>
flutter build apk --release --split-per-abi
flutter build web --release
```

截图测试以 375 × 812 的逻辑尺寸加载实际 Archivo 与 Material 图标字体，并等待所有本地图片解码后截取 Flutter 页面。长页面另有滚动后的补充截图。Android 流程测试使用模拟器真实运行和交互，并将截图保存到 docs/screenshots/android/。

## 设计与交付说明

参考来源：当前 Pixso 文件「Carijob - UI Kit」的「🎨 UI Design」页面。选择 v1 引导和首页为主要视觉方向，合并重复的 UI 变体为复用页面；长设计稿对应应用内滚动内容。保留浅蓝、浅绿、灰粉色卡片与黑色胶囊按钮，使用原稿 Archivo 字体和可导出的原始素材。

部分不可直接复用的图标用 Material Icons 表达；占位 Lorem ipsum 替换为有意义的求职引导文案。稿中的 2023 年面试日期保留为明确标注的样例。页面有完整交互，但不会伪造真实企业响应或外部服务的成功结果。

代码整理已移除 Flutter 计数器示例、未使用的图标依赖与开发用弹层预览页面，合并重复表单和卡片，统一格式化。构建目录和本机配置不纳入源码。原始设计素材和品牌标志的授权沿用设计提供方要求；Archivo 字体许可见 assets/fonts/OFL.txt。
