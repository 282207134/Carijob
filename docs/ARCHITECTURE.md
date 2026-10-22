# 架构与实现说明

## 分层与责任

项目采用 feature 分组的轻量结构，业务范围适合 Flutter 原生 ChangeNotifier 与 Navigator，无需额外状态管理或路由依赖。

| 层 | 文件 | 责任 |
| --- | --- | --- |
| 启动 | lib/main.dart | 等待本地状态恢复，设置系统栏，启动应用 |
| 应用 | lib/app.dart | 应用主题、路由参数解析、初始页面、最大 600 逻辑像素宽度 |
| 状态 | lib/core/app_state.dart | 可观察状态、业务变更、本地 JSON 序列化、状态注入 |
| 数据 | lib/data/models.dart | 职位、申请记录、组合筛选值对象 |
| 仓库 | lib/data/job_repository.dart | 演示数据与搜索条件组合 |
| 功能 | lib/features/ | 按认证、发现、投递、资料划分 UI 与局部表单状态 |
| 复用 UI | lib/shared/widgets.dart | PageFrame、Panel、JobCard、Pill、Tabs、表单输入、空状态 |
| 主题 | lib/core/theme.dart | Archivo、主色、文本色、边线和统一控件样式 |

数据流：

```text
用户操作
  ├─ 搜索词、筛选 → JobRepository.search → 结果列表 / 空状态
  └─ 收藏、投递、资料编辑 → AppState
                              ├─ notifyListeners → AppScope → 相关页面刷新
                              └─ SharedPreferences → 本机 JSON
启动 → AppState.load → 还原状态 → MaterialApp 初始路由
```

搜索输入、筛选弹层选项、表单控制器等短期状态留在对应 StatefulWidget；跨页面的数据才进入 AppState。四个主导航用 IndexedStack 保留位置与界面状态。表单控制器统一在 dispose 中释放。

## 数据模型

### Job

职位 id、名称、公司、地区、类型、薪资、行业、工作方式和演示发布时间。id 是收藏与投递关联的稳定键。职位库包含 9 条样例数据。

### JobFilter

支持类型（All / Full-Time / Part-Time / Freelance / Internship）、地区、行业分类、发布时间与排序方式。搜索匹配职位名称、公司、行业，采用不区分大小写的包含匹配，多个条件按 AND 合并。United States 映射到样例地区中的 USA。

Most Recent 按样例 age 升序；Most Relevant 保持仓库顺序作为无服务端相关性模型时的稳定回退。没有声称接入推荐算法。

### Application

保存 jobId、阶段、申请时间、拒绝标记，以及用户投递时填写的邮箱、电话、简历文件名与求职信。新投递进入 Submitted；重复 jobId 不再添加。样例包含 Submitted / Test / Interview 和 Rejected，Offer 也有独立呈现。

本次只保存简历名称，不复制简历内容，也不请求远程上传。演示简历是明确标注的占位选择，不代表生成或提交了一份真实 PDF。

## 本地持久化

使用 SharedPreferences 中的 carijob.v1 键存储 JSON，内容包括：

- 演示登录状态、资料及工作/教育字段；
- 技能、求职偏好、收藏职位 id；
- 投递记录及提交信息；
- 语言和通知/安全偏好。

读取时容错处理格式损坏的数据；旧投递记录缺少新增联系字段时使用空字符串。初始演示投递时间相对当前设备日期生成。退出仅结束演示登录状态，保留本机资料。没有保存密码、OAuth token 或简历二进制内容。

SharedPreferences 用于这个本地 UI 演示；真实账号授权和服务端投递必须另接生产服务。

## 路由

MaterialApp 通过 onGenerateRoute 构造页面，普通详情接收 Job，申请详情接收 Application，搜索接收 String 或 SearchRequest。普通后退使用系统 Navigator；完成登录、退出和投递成功后清理不必要的历史路径。

| 路由 | 内容 |
| --- | --- |
| /splash | 品牌启动展示，可点击进入引导 |
| /onboarding、/onboarding/2…4 | v1 四步引导 |
| /sign-in、/sign-up | 本地演示登录与注册 |
| /forgot-password、/verify、/reset-password | 演示找回流程 |
| /categories、/experience、/skills | 注册偏好向导；edit 参数用于独立保存 |
| /home、/explore、/my-jobs、/profile | 四个主导航入口 |
| /rejected | 默认进入拒绝分类 |
| /results、/empty-results | 职位 / 公司搜索及无结果状态 |
| /recommended、/saved | 推荐与收藏列表 |
| /notifications | 本地通知列表 |
| /details | 可滚动的完整职位详情 |
| /opportunities | 某公司的其他职位 |
| /apply、/apply-full | 简洁 / 完整资料投递表单 |
| /success | 本地模拟投递成功 |
| /application-details | 根据申请对象呈现进度 |
| /complete-profile | 资料完善任务入口 |
| /full-profile | 完整个人资料 |
| /edit-profile、/identity | 基本信息表单 |
| /edit-experience、/work-experience | 经历综合编辑 / 工作经历编辑 |
| /education、/personal-skills | 教育与技能 |
| /language、/security、/about、/faq | 偏好、安全样例、说明与帮助 |

筛选和退出确认使用真正的模态底部弹层。没有单独的假预览路由，截图测试通过点击实际按钮打开弹层。

## 视觉与适配

- Archivo 字体内置，离线可用；颜色与圆角由主题统一管理。
- 原始头像、公司标志、分类插图、首页图形和引导图片从 Pixso 导出。
- 主背景 #F5F8FA，浅蓝 #C2D3F0，浅绿 #B2DDA8，灰粉 #DFD2CD，主文字 #191E24。
- SafeArea 避让系统区域；表单和长内容使用滚动容器；核心 375 × 812 布局有截图回归检查。
- 宽屏保持居中，最大宽度 600，相关 MediaQuery 宽度同步限制。
- 设计中的 Home v1/v2、引导 v1/v2 和长/短详情属于视觉变体。实现选择 v1 引导与首页，详情通过滚动承载，申请进度通过一个参数化页面表达。
- 长期样例数据、无后端的设置及第三方登录在 UI 中明确标注，避免误认成线上操作。

## 文件选择与平台

使用 file_selector 原生文件选择器，接受 PDF、DOC、DOCX；检查扩展名和最大 5MB 文件大小。取消选择不改变现有值，文件选择异常会显示提示。Android、iOS、Web 已生成平台工程；iOS 未在 Windows 上构建。

Android release 构建沿用 Flutter 工程的调试签名，仅用于安装体验，正式发布需配置应用 id、正式签名和服务端环境。

## 接入真实服务的位置

1. 将 JobRepository 的静态目录与查询替换为 API，保留 Job / JobFilter 接口；补充分页、加载态、网络错误和重试。
2. 在认证功能接入真实登录、注册、邮件验证码及 Google OAuth；演示表单不能当作身份认证。
3. 将 AppState.apply 改为服务端创建申请，简历通过文件流上传；以后端返回的申请 id 和阶段为准。
4. 将收藏和个人资料从本机同步到用户账户，完善失败恢复与多设备一致性。
5. 语言选项当前只保存偏好，尚未提供翻译资源；通知开关不等于请求系统通知权限，安全开关也不执行真实 MFA 注册。
6. 建立推送和招聘状态更新通道；不能用固定样例时间模拟真实面试提醒。

## 精简结果

删除初始计数器页面与对应测试；去掉未用的 cupertino_icons；复用认证/选择流程、资料表单、职位卡及进度组件；统一字体和配色；截图专用预览不进入生产页面；测试与文档独立放置。没有生成额外的冗余状态/服务/控制器层。
