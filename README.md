# 习题册刷题系统

基于 SpringBoot + Vue3 + ElementPlus + MyBatis 开发的习题册刷题系统，支持刷题、考试、错题本、收藏等功能。

## 一、技术栈

### 后端
- SpringBoot 3.2.0
- MyBatis 3.0.3
- MySQL 8.x
- Lombok
- Hutool 工具库

### 前端
- Vue 3.4
- Vite 5.0
- Element Plus 2.4
- Pinia 状态管理
- Vue Router 4
- Axios

## 二、环境要求

- JDK 17+
- Maven 3.6+
- Node.js 18+
- MySQL 8.0+

## 三、项目结构

```
Exam/
├── database/                 # 数据库脚本
│   └── init.sql             # 初始化SQL
├── backend/                  # 后端项目
│   ├── pom.xml
│   └── src/
│       └── main/
│           ├── java/com/exercise/
│           │   ├── controller/   # 控制器
│           │   ├── service/      # 服务层
│           │   ├── mapper/       # Mapper接口
│           │   ├── entity/       # 实体类
│           │   ├── dto/          # 数据传输对象
│           │   ├── vo/           # 视图对象
│           │   ├── common/       # 公共类
│           │   ├── config/       # 配置类
│           │   └── exception/    # 异常处理
│           └── resources/
│               ├── application.yml
│               └── mapper/       # MyBatis XML
└── frontend/                 # 前端项目
    ├── package.json
    ├── vite.config.js
    └── src/
        ├── api/              # API接口
        ├── store/            # 状态管理
        ├── router/           # 路由配置
        ├── views/            # 页面组件
        ├── styles/           # 样式文件
        └── utils/            # 工具类
```

## 四、快速开始

### 1. 初始化数据库

```bash
# 登录MySQL
mysql -u root -p

# 执行初始化脚本
source database/init.sql
```

或者手动执行 `database/init.sql` 文件中的SQL语句。

### 2. 启动后端

```bash
cd backend

# 修改数据库配置（如需要）
# 编辑 src/main/resources/application.yml
# 修改 spring.datasource.username 和 password

# 编译打包
mvn clean package -DskipTests

# 运行
java -jar target/exercise-system-1.0.0.jar

# 或者直接运行（开发模式）
mvn spring-boot:run
```

后端服务将在 `http://localhost:8080` 启动。

### 3. 启动前端

```bash
cd frontend

# 安装依赖
npm install

# 开发模式运行
npm run dev

# 生产环境打包
npm run build
```

前端服务将在 `http://localhost:3000` 启动。

### 4. 访问系统

打开浏览器访问 `http://localhost:3000`

## 五、测试账号

| 用户名 | 密码 | 说明 |
|--------|------|------|
| admin | 123456 | 管理员账号 |
| test | 123456 | 测试用户 |

## 六、核心功能

### 1. 刷题功能
- 顺序刷题：按题目ID顺序依次作答
- 随机刷题：随机抽取未做过的题目
- 支持单选、多选、判断、简答四种题型
- 提交后显示正确答案和解析
- 记住刷题进度

### 2. 考试功能
- 自定义题型和题目数量
- 批量作答
- 自动评分
- 查看答题详情和解析

### 3. 错题本
- 自动记录错题
- 支持按习题册、题型筛选
- 查看错题详情
- 移除错题记录

### 4. 收藏功能
- 收藏题目
- 取消收藏
- 按条件筛选收藏

## 七、API接口

### 用户模块
- `POST /api/user/login` - 用户登录
- `GET /api/user/info/{id}` - 获取用户信息

### 习题册模块
- `GET /api/book/list` - 获取习题册列表
- `GET /api/book/detail/{bookId}` - 获取习题册详情

### 题目模块
- `GET /api/question/sequence/{bookId}` - 顺序刷题
- `GET /api/question/random/{bookId}` - 随机刷题
- `POST /api/question/submit` - 提交作答
- `GET /api/question/detail/{id}` - 获取题目详情

### 考试模块
- `POST /api/exam/generate` - 生成试卷
- `POST /api/exam/submit` - 提交考试

### 错题模块
- `GET /api/error/list` - 获取错题列表
- `DELETE /api/error/delete/{recordId}` - 删除错题记录

### 收藏模块
- `POST /api/collection/add` - 添加收藏
- `DELETE /api/collection/remove/{questionId}` - 取消收藏
- `GET /api/collection/list` - 获取收藏列表

### 题型模块
- `GET /api/type/list` - 获取题型列表

## 八、部署说明

### 后端部署

```bash
# 打包
cd backend
mvn clean package -DskipTests

# 运行
java -jar target/exercise-system-1.0.0.jar --spring.profiles.active=prod
```

### 前端部署

```bash
# 打包
cd frontend
npm run build

# 将 dist 目录部署到 Nginx
# Nginx 配置示例：
# server {
#     listen 80;
#     server_name your-domain.com;
#     
#     location / {
#         root /path/to/dist;
#         try_files $uri $uri/ /index.html;
#     }
#     
#     location /api {
#         proxy_pass http://localhost:8080;
#     }
# }
```

## 九、数据库表结构

| 表名 | 说明 |
|------|------|
| sys_user | 用户表 |
| exercise_book | 习题册表 |
| question | 题目表 |
| question_record | 做题记录表 |
| collection | 收藏表 |
| question_type | 题型分类表 |
| exam_record | 考试记录表 |
| exam_detail | 考试详情表 |

## 十、常见问题

### 1. 后端启动失败
- 检查数据库连接配置是否正确
- 确保MySQL服务已启动
- 检查JDK版本是否为17+

### 2. 前端启动失败
- 检查Node.js版本是否为18+
- 删除 `node_modules` 目录后重新执行 `npm install`

### 3. 跨域问题
- 后端已配置CORS，允许所有来源访问
- 如需修改，编辑 `CorsConfig.java` 文件

## 十一、开发说明

- 后端遵循RESTful接口规范
- 所有接口返回统一JSON格式：`{code: 200, msg: "成功", data: {...}}`
- 前端使用Composition API开发
- 状态管理使用Pinia
