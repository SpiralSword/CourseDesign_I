# ACSS 智学共享系统

ACSS（Academic Course Sharing Space）是一个基于 SSM 技术栈实现的课程学习社区系统，面向校内课程场景，整合了课程讨论、资料共享、AI 助教、积分激励与后台治理等能力。

当前项目以传统 Java Web 方式组织，使用 `Spring + SpringMVC + MyBatis + JSP` 实现，适合课程设计、毕业设计、SSM 综合实训等场景。

## 1. 项目简介

本项目围绕“课程学习闭环”设计，核心目标是：

- 提供课程社区，支持围绕课程主题发帖、回复、点赞、检索
- 提供资源共享，支持上传学习资料、积分下载、评论互动
- 提供 AI 助教，对接大模型接口做课程答疑
- 提供用户成长体系，通过发帖、上传、下载、签到形成积分流转
- 提供管理员治理能力，对用户和内容进行后台管理

## 2. 功能模块

### 2.1 用户与基础能力

- 用户注册、登录、退出
- 密码使用 MD5 存储与校验
- 头像上传
- 个人中心查看我的资源、我的帖子、AI 历史记录
- 每日签到加积分

### 2.2 课程社区

- 帖子发布
- 帖子列表分页
- 课程名 / 标题 / 内容关键字搜索
- 帖子详情查看
- 回复帖子
- 帖子点赞 / 取消点赞
- 发帖人或管理员可删除帖子

### 2.3 资源共享

- 资源上传
- 文件 UUID 重命名存储
- 资源列表分页
- 按课程名 / 标题 / 描述搜索
- 资源详情查看
- 资源评论
- 积分校验后下载
- 上传者或管理员可删除资源

### 2.4 AI 助教

- AI 问答页面
- 调用外部大模型接口
- 保存用户提问历史
- 面向 Java / SSM / 数据库等课程答疑场景

### 2.5 后台治理

- 用户列表查看
- 冻结 / 启用用户
- 管理员删除资源
- 管理员删除帖子

## 3. 技术栈

### 后端

- Java 8
- Spring 5.3.x
- SpringMVC 5.3.x
- MyBatis 3.5.x
- MyBatis-Spring 2.0.x
- Druid 数据源
- MySQL 8
- OkHttp 4.x
- Fastjson
- PageHelper
- Lombok

### 前端

- JSP
- JSTL
- Bootstrap 5
- 原生 JavaScript / Fetch

### 构建与部署

- Maven
- WAR 包部署
- Tomcat 9+

## 4. 项目结构

```text
acss-system/
├── pom.xml
├── README.md
├── sql/
│   └── acss_db.sql
├── src/
│   └── main/
│       ├── java/com/study/ai/
│       │   ├── controller/        # 控制层
│       │   ├── service/           # 业务接口
│       │   ├── service/impl/      # 业务实现
│       │   ├── mapper/            # MyBatis Mapper 接口
│       │   ├── pojo/entity/       # 实体类
│       │   ├── interceptor/       # 拦截器
│       │   ├── exception/         # 全局异常处理
│       │   └── util/              # 工具类
│       ├── resources/
│       │   ├── mapper/            # MyBatis XML
│       │   ├── spring/            # Spring 配置
│       │   ├── db.properties      # 数据库配置
│       │   ├── ai-config.properties
│       │   └── log4j2.xml
│       └── webapp/
│           ├── static/            # 静态资源
│           ├── uploads/           # 上传目录（运行时生成/映射）
│           └── WEB-INF/
│               ├── views/         # JSP 页面
│               └── web.xml
```

## 5. 核心页面与入口

### 页面入口

- 首页：`/index`
- 登录页：`/user/loginPage`
- 注册页：`/user/registerPage`
- 个人中心：`/user/profile`
- 资源列表：`/resource/list`
- 资源上传：`/resource/upload`
- 帖子列表：`/post/list`
- 发布帖子：`/post/publish`
- AI 页面：`/ai/chatPage`
- 后台用户管理：`/admin/users`

### 主要控制器

- `UserController`：注册、登录、头像、个人中心
- `CheckInController`：签到
- `PostController`：课程社区
- `ResourceController`：资源上传、详情、评论、下载
- `AIController`：AI 问答
- `AdminController`：后台治理
- `IndexController`：首页聚合展示

## 6. 数据库设计

当前项目数据库脚本位于：

- `sql/acss_db.sql`

主要表：

- `user`：用户表
- `resource`：资源表
- `comment`：资源评论表
- `post`：帖子表
- `post_reply`：帖子回复表
- `post_like`：帖子点赞记录表
- `ai_chat_log`：AI 聊天记录表
- `check_in_log`：签到记录表

### 重点字段说明

#### `resource`

- `course_name`：课程名
- `category`：资源分类
- `file_path`：服务器端重命名后的实际文件名
- `points`：下载所需积分

#### `post`

- `course_name`：课程名
- `like_count`：点赞数
- `reply_count`：回复数

#### `post_like`

- 使用 `(post_id, user_id)` 唯一索引约束，防止重复点赞

## 7. 本地启动前准备

### 7.1 环境要求

- JDK 8
- Maven 3.6+
- MySQL 8.x
- Tomcat 9.x

### 7.2 初始化数据库

1. 在 MySQL 中创建并导入数据库脚本
2. 执行：

```sql
SOURCE /你的项目路径/sql/acss_db.sql;
```

或者直接复制 `sql/acss_db.sql` 中的 SQL 执行。

### 7.3 修改数据库配置

编辑：

- `src/main/resources/db.properties`

根据本地环境修改：

```properties
jdbc.url=jdbc:mysql://127.0.0.1:3306/acss_db?useUnicode=true&characterEncoding=UTF-8&serverTimezone=Asia/Shanghai&useSSL=false&allowPublicKeyRetrieval=true
jdbc.username=你的用户名
jdbc.password=你的密码
```

### 7.4 修改 AI 配置

编辑：

- `src/main/resources/ai-config.properties`

至少填写：

```properties
ai.api.url=https://api.deepseek.com/chat/completions
ai.api.model=deepseek-chat
ai.api.key=你的API密钥
```

如果不配置 `ai.api.key`，系统不会崩溃，但 AI 页面会返回“未配置密钥”的提示。

## 8. 启动方式

### 方式一：IDEA 直接部署到 Tomcat

1. 用 IDEA 打开项目
2. 确认 Maven 依赖已下载完成
3. 配置本地 Tomcat
4. 以 WAR exploded 或普通 Web 项目方式部署
5. 启动后访问：

```text
http://localhost:8080/acss-system/
```

### 方式二：打包 WAR 后部署

```bash
mvn clean package
```

将生成的 `acss-system.war` 部署到 Tomcat 的 `webapps` 目录。

## 9. 默认管理员

数据库初始化脚本中通常可插入默认管理员账号，常见约定如下：

- 用户名：`admin`
- 密码：`123456`

注意：

- 当前代码使用 MD5 校验密码
- 如果你手动插入管理员数据，请保证数据库中的密码是 MD5 后的值

例如：

```sql
INSERT INTO user(username, password, nickname, email, avatar, role, points, status)
VALUES ('admin', MD5('123456'), '系统管理员', 'admin@acss.local', '/static/images/default-avatar.svg', '1', 1000, 0);
```

## 10. 权限与拦截规则

### 公开可访问

- 首页
- 登录 / 注册
- 资源列表 / 资源详情
- 帖子列表 / 帖子详情
- 静态资源

### 登录后访问

- 发布帖子
- 上传资源
- AI 聊天
- 个人中心
- 发表评论 / 回复 / 点赞 / 下载 / 签到

### 管理员访问

- `/admin/**`

管理员判断规则：

- `role = '1'` 视为管理员

## 11. 上传与文件存储说明

### 头像上传

- 存储目录映射：`/uploads/avatar/`

### 资源上传

- 存储目录映射：`/uploads/`
- 采用 UUID 重命名，避免文件名冲突

### 大小限制

在 `spring-mvc.xml` 中配置了：

- 单次上传总大小：50MB

## 12. 代码实现说明

### 业务分层

项目已经按 SSM 思路进行职责拆分：

- Controller：接收请求、封装响应、页面跳转
- Service：业务逻辑
- Mapper：数据库访问
- XML Mapper：SQL 映射

### 当前较核心的服务类

- `UserServiceImpl`
- `PostServiceImpl`
- `ResourceServiceImpl`
- `AIServiceImpl`

### 工具类

- `MD5Utils`：密码 MD5 处理
- `FileStorageUtils`：上传文件落盘、命名、删除、大小格式化

## 13. 已实现的安全与约束

- 登录拦截
- 管理员拦截
- 密码 MD5 校验
- 资源下载积分校验
- 下载链路加入会话态校验，避免直接绕过下载检查
- 帖子点赞唯一约束
- 敏感词简单过滤与替换

## 14. 已知限制

当前项目适合教学、课程设计和中小规模演示，仍存在一些可继续优化的点：

- 密码仅使用 MD5，不适合生产环境
- AI 接口未做更完整的异常分类与限流
- 敏感词过滤仍为简单实现
- 上传文件未做更细粒度的白名单校验
- 页面为 JSP + Bootstrap，前后端未完全分离

## 15. 后续可扩展方向

- 引入 BCrypt 替换 MD5
- 增加资源收藏、帖子收藏
- 增加课程分类表，替代纯字符串课程名
- 增加管理员审核流
- 增加 AI 上下文对话与提示词配置后台
- 增加单元测试与集成测试
- 引入 Redis 做热门内容缓存

## 16. 适用场景

本项目适用于：

- Java Web 课程设计
- SSM 综合实训项目
- 校园学习资源共享系统
- AI + 教学辅助类课程项目

## 17. 许可证
MIT License
