# 验证记录

日期：2026-10-22（Asia/Tokyo）。

## 环境

- Windows 11，Flutter 3.47.7 stable，Dart 3.13.5。
- 独立 Android 模拟器 carijob_test，Android 15 / API 35，x86_64，1080 × 2400。
- Android SDK 36、Java 21；发布 APK 采用模板的调试签名供安装体验。

## 自动检查

| 检查 | 命令 | 结果 |
| --- | --- | --- |
| 静态分析 | flutter analyze | 通过，无问题 |
| 业务、交互与截图回归 | flutter test | 59 项通过 |
| 全页面截图生成 | flutter test test/screenshots_test.dart --update-goldens | 53 张页面 / 状态截图 |
| Android 完整流程 | flutter drive --driver=test_driver/integration_test.dart --target=integration_test/app_flow_test.dart -d emulator-5556 | 通过，11 张模拟器运行截图 |
| Android 发布构建 | flutter build apk --release --split-per-abi | arm64-v8a、armeabi-v7a、x86_64 三个 APK 构建成功 |
| 浏览器发布构建 | flutter build web --release | 构建成功，Wasm dry run 通过 |
| 发布安装启动 | adb install 安装 x86_64 release APK 并启动 | 安装与首屏显示正常 |
| 文档和素材引用 | 检查本地 Markdown 图片及文件链接 | 通过，无失效引用 |

截图和交互检查采用统一入口 test/screenshots_test.dart；业务用例在 app_cases.dart 中注册。所有用例在同一个 Flutter 测试进程中执行，避免桌面环境多个图像测试进程的字体和图片缓存时序干扰。图片预加载发生在真实页面挂载之前。

## 业务检查内容

- 关键词、类型、地区、行业、时间条件同时作用，无结果处理正确。
- 资料、收藏、投递序列化后可读取；重复投递只有一条记录。
- 投递记录保留联系信息、简历名称和求职信；密码不写入本地数据。
- 无效登录输入显示错误；有效的演示输入进入主页。
- 未选择简历不能提交；演示简历选择后生成投递成功和记录。
- 收藏空列表的 Browse jobs 能跳转探索页。
- 页面截图检查布局异常，覆盖滚动长页、所有申请阶段与模态弹层。

## 模拟器流程

登录演示 → 首页 → Explore → 搜索 → 筛选 Part-Time → Twitter 职位 → 收藏 → 投递表单 → 使用演示简历 → 投递成功 → My Job 记录 → Profile → 完整资料 → 编辑姓名 → 保存 → 重新读取本地资料、收藏与投递。

原模拟器空间不足，因此创建独立测试模拟器；没有清除原模拟器中的应用或数据。测试模拟器名称保留在运行说明中，设备 ID 可能随启动顺序变化。

## 视觉复查

已检查全部 53 张 Flutter 截图的分组预览及 Android 运行截图，核对字体、图标、原始设计素材、卡片、导航、长页内容和表单。发现并修正推荐卡片高度、截图图片加载时序和收藏空状态跳转问题。文档中的主要界面图使用实际 Flutter 截图，原始 Pixso 导出图保存在独立目录。

## 已知边界

- 这是本地 UI 与交互演示，未连接真实招聘、认证、Google OAuth、邮件、短信、MFA 或推送服务。
- 仅保存简历文件名；原生文件选择与扩展名 / 大小检查已实现，完整流程测试使用演示简历选项，未自动操作系统文件选择器。
- 语言列表保存偏好，尚未提供各语种翻译。
- iOS 只交付平台工程，未在 macOS / Xcode 中构建、签名或运行。
- Web 构建存在 Flutter 对内置 Cupertino 字体引用的非阻断提示；本应用显式图标使用 MaterialIcons，相关字体已内置。
- APK 使用调试签名，正式上架需要配置发布签名及服务端环境。
