# 习题册刷题系统

基于 SpringBoot + Vue3 + ElementPlus + MyBatis + Redis 开发的习题册刷题系统，支持刷题、考试、错题本、收藏、钱包购买等功能。

## 一、技术栈

### 后端
- SpringBoot 3.2.0
- MyBatis 3.0.3
- MySQL 8.x
- Redis 7.x
- Lombok
- Hutool 工具库
- Jakarta Mail（邮件发送）

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
- Redis 7.0+

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

### 2. 安装和启动 Redis

#### Windows 系统

```bash
# 下载 Redis for Windows
# 访问：https://github.com/microsoftarchive/redis/releases
# 或使用 WSL2 安装 Linux 版本 Redis

# 解压后启动
cd Redis-x64-3.0.504
redis-server.exe redis.windows.conf

# 测试连接
redis-cli.exe ping
# 返回 PONG 表示启动成功
```

#### Linux 系统

```bash
# Ubuntu/Debian
sudo apt update
sudo apt install redis-server

# CentOS/RHEL
sudo yum install redis

# 启动 Redis
sudo systemctl start redis
sudo systemctl enable redis

# 测试连接
redis-cli ping
```

#### macOS 系统

```bash
# 使用 Homebrew 安装
brew install redis

# 启动 Redis
brew services start redis

# 测试连接
redis-cli ping
```

#### Docker 部署（推荐）

```bash
# 拉取 Redis 镜像
docker pull redis:7-alpine

# 启动 Redis 容器
docker run -d \
  --name redis \
  -p 6379:6379 \
  -v redis-data:/data \
  redis:7-alpine \
  redis-server --appendonly yes

# 测试连接
docker exec -it redis redis-cli ping
```

### 3. 配置后端

```bash
cd backend

# 编辑配置文件
# src/main/resources/application.yml

# 修改数据库配置
spring:
  datasource:
    url: jdbc:mysql://localhost:3306/exercise_system?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai&allowPublicKeyRetrieval=true
    username: root
    password: your_password

# 修改 Redis 配置
spring:
  data:
    redis:
      host: localhost
      port: 6379
      password: your_redis_password  # 如果设置了密码
      database: 0

# 修改邮件配置（用于注册和找回密码）
spring:
  mail:
    host: smtp.qq.com
    port: 587
    username: your_email@qq.com
    password: your_email_password
```

### 4. 启动后端

```bash
cd backend

# 编译打包
mvn clean package -DskipTests

# 运行
java -jar target/exercise-system-1.0.0.jar

# 或者直接运行（开发模式）
mvn spring-boot:run
```

后端服务将在 `http://localhost:8080` 启动。

### 5. 启动前端

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

### 6. 访问系统

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

### 5. 钱包功能
- 余额充值
- 购买习题册
- 交易记录查询

### 6. 用户功能
- 用户注册（邮箱验证）
- 找回密码（邮箱验证）
- 个人信息管理

## 七、API接口

### 用户模块
- `POST /api/user/login` - 用户登录
- `POST /api/user/register` - 用户注册
- `POST /api/user/sendCode` - 发送验证码
- `POST /api/user/resetPassword` - 重置密码
- `GET /api/user/info/{id}` - 获取用户信息
- `PUT /api/user/update` - 更新用户信息
- `PUT /api/user/password` - 修改密码

### 习题册模块
- `GET /api/book/list` - 获取习题册列表
- `GET /api/book/listWithPurchase` - 获取习题册列表（含购买状态）
- `GET /api/book/detail/{bookId}` - 获取习题册详情
- `POST /api/book/create` - 创建习题册
- `PUT /api/book/update` - 更新习题册
- `DELETE /api/book/{id}` - 删除习题册
- `PUT /api/book/status/{id}` - 更新习题册状态
- `PUT /api/book/price/{id}` - 设置习题册价格

### 题目模块
- `GET /api/question/sequence/{bookId}` - 顺序刷题
- `GET /api/question/random/{bookId}` - 随机刷题
- `POST /api/question/submit` - 提交作答
- `GET /api/question/detail/{id}` - 获取题目详情

### 考试模块
- `POST /api/exam/generate` - 生成试卷
- `POST /api/exam/submit` - 提交考试
- `GET /api/exam/records/{userId}` - 获取考试记录

### 错题模块
- `GET /api/error/list` - 获取错题列表
- `DELETE /api/error/delete/{recordId}` - 删除错题记录

### 收藏模块
- `POST /api/collection/add` - 添加收藏
- `DELETE /api/collection/remove/{questionId}` - 取消收藏
- `GET /api/collection/list` - 获取收藏列表

### 题型模块
- `GET /api/type/list` - 获取题型列表

### 钱包模块
- `GET /api/wallet/info/{userId}` - 获取钱包信息
- `POST /api/wallet/recharge` - 钱包充值
- `GET /api/wallet/transactions/{userId}` - 获取交易记录

### 购买模块
- `POST /api/purchase/buy` - 购买习题册
- `GET /api/purchase/check` - 检查购买状态
- `GET /api/purchase/my` - 获取我的购买记录

## 八、部署说明

### 8.1 Redis 部署

#### Windows 部署

**方式一：使用 WSL2（推荐）**

```bash
# 在 WSL2 中安装 Redis
sudo apt update
sudo apt install redis-server

# 启动 Redis
sudo service redis-server start

# 设置开机自启
sudo systemctl enable redis-server

# 配置 Redis
sudo nano /etc/redis/redis.conf

# 修改以下配置
# bind 127.0.0.1 -> bind 0.0.0.0  # 允许外部访问
# requirepass your_password  # 设置密码

# 重启 Redis
sudo service redis-server restart
```

**方式二：使用 Docker Desktop**

```bash
# 拉取 Redis 镜像
docker pull redis:7-alpine

# 启动 Redis 容器
docker run -d \
  --name redis \
  -p 6379:6379 \
  -v redis-data:/data \
  --restart unless-stopped \
  redis:7-alpine \
  redis-server --appendonly yes --requirepass your_password

# 查看日志
docker logs redis

# 进入 Redis 容器
docker exec -it redis redis-cli
```

#### Linux 部署

**Ubuntu/Debian**

```bash
# 安装 Redis
sudo apt update
sudo apt install redis-server

# 启动 Redis
sudo systemctl start redis
sudo systemctl enable redis

# 配置 Redis
sudo nano /etc/redis/redis.conf

# 修改配置
# bind 127.0.0.1 -> bind 0.0.0.0
# requirepass your_password

# 重启 Redis
sudo systemctl restart redis

# 测试连接
redis-cli -a your_password ping
```

**CentOS/RHEL**

```bash
# 安装 Redis
sudo yum install epel-release
sudo yum install redis

# 启动 Redis
sudo systemctl start redis
sudo systemctl enable redis

# 配置 Redis
sudo nano /etc/redis.conf

# 修改配置
# bind 127.0.0.1 -> bind 0.0.0.0
# requirepass your_password

# 重启 Redis
sudo systemctl restart redis
```

#### macOS 部署

```bash
# 使用 Homebrew 安装
brew install redis

# 启动 Redis
brew services start redis

# 配置 Redis
brew edit redis

# 修改配置
# bind 127.0.0.1 -> bind 0.0.0.0
# requirepass your_password

# 重启 Redis
brew services restart redis
```

#### Docker 部署（跨平台推荐）

```bash
# 创建 Docker Compose 文件
cat > docker-compose.yml << EOF
version: '3.8'
services:
  redis:
    image: redis:7-alpine
    container_name: redis
    ports:
      - "6379:6379"
    volumes:
      - redis-data:/data
    command: redis-server --appendonly yes --requirepass your_password
    restart: unless-stopped

volumes:
  redis-data:
EOF

# 启动 Redis
docker-compose up -d

# 查看状态
docker-compose ps

# 查看日志
docker-compose logs redis

# 停止 Redis
docker-compose down
```

#### Redis 配置说明

```yaml
# application.yml 配置示例
spring:
  data:
    redis:
      host: localhost          # Redis 服务器地址
      port: 6379             # Redis 端口
      password: your_password  # Redis 密码（如果设置了）
      database: 0             # Redis 数据库索引
      timeout: 5000           # 连接超时时间（毫秒）
      lettuce:
        pool:
          max-active: 8        # 连接池最大连接数
          max-wait: -1       # 连接池最大阻塞等待时间
          max-idle: 8        # 连接池中的最大空闲连接
          min-idle: 0         # 连接池中的最小空闲连接
```

### 8.2 后端部署

#### 开发环境部署

```bash
cd backend

# 修改配置文件
# src/main/resources/application.yml

# 编译打包
mvn clean package -DskipTests

# 运行
java -jar target/exercise-system-1.0.0.jar

# 或使用 Maven 插件运行
mvn spring-boot:run
```

#### 生产环境部署

**方式一：JAR 包部署**

```bash
# 打包
cd backend
mvn clean package -DskipTests

# 创建生产环境配置文件
cat > src/main/resources/application-prod.yml << EOF
server:
  port: 8080

spring:
  profiles:
    active: prod
  datasource:
    url: jdbc:mysql://your-mysql-host:3306/exercise_system?useUnicode=true&characterEncoding=utf8&useSSL=false&serverTimezone=Asia/Shanghai
    username: your_username
    password: your_password
  data:
    redis:
      host: your-redis-host
      port: 6379
      password: your_redis_password

logging:
  level:
    com.exercise: info
EOF

# 运行
java -jar target/exercise-system-1.0.0.jar --spring.profiles.active=prod
```

**方式二：Docker 部署**

```bash
# 创建 Dockerfile
cat > backend/Dockerfile << EOF
FROM openjdk:17-jdk-slim
WORKDIR /app
COPY target/exercise-system-1.0.0.jar app.jar
EXPOSE 8080
ENTRYPOINT ["java", "-jar", "app.jar"]
EOF

# 构建镜像
cd backend
docker build -t exercise-system:1.0.0 .

# 运行容器
docker run -d \
  --name exercise-backend \
  -p 8080:8080 \
  -e SPRING_PROFILES_ACTIVE=prod \
  -e SPRING_DATASOURCE_URL=jdbc:mysql://mysql:3306/exercise_system \
  -e SPRING_DATASOURCE_USERNAME=root \
  -e SPRING_DATASOURCE_PASSWORD=your_password \
  -e SPRING_DATA_REDIS_HOST=redis \
  -e SPRING_DATA_REDIS_PORT=6379 \
  exercise-system:1.0.0
```

**方式三：Docker Compose 部署（完整环境）**

```bash
# 创建 docker-compose.yml
cat > docker-compose.yml << EOF
version: '3.8'

services:
  mysql:
    image: mysql:8.0
    container_name: mysql
    environment:
      MYSQL_ROOT_PASSWORD: your_password
      MYSQL_DATABASE: exercise_system
    ports:
      - "3306:3306"
    volumes:
      - mysql-data:/var/lib/mysql
      - ./database/init.sql:/docker-entrypoint-initdb.d/init.sql
    restart: unless-stopped

  redis:
    image: redis:7-alpine
    container_name: redis
    ports:
      - "6379:6379"
    volumes:
      - redis-data:/data
    command: redis-server --appendonly yes
    restart: unless-stopped

  backend:
    build: ./backend
    container_name: backend
    ports:
      - "8080:8080"
    depends_on:
      - mysql
      - redis
    environment:
      SPRING_PROFILES_ACTIVE: prod
      SPRING_DATASOURCE_URL: jdbc:mysql://mysql:3306/exercise_system
      SPRING_DATASOURCE_USERNAME: root
      SPRING_DATASOURCE_PASSWORD: your_password
      SPRING_DATA_REDIS_HOST: redis
      SPRING_DATA_REDIS_PORT: 6379
    restart: unless-stopped

  frontend:
    build: ./frontend
    container_name: frontend
    ports:
      - "80:80"
    depends_on:
      - backend
    restart: unless-stopped

volumes:
  mysql-data:
  redis-data:
EOF

# 启动所有服务
docker-compose up -d

# 查看日志
docker-compose logs -f backend

# 停止所有服务
docker-compose down
```

### 8.3 前端部署

#### 开发环境部署

```bash
cd frontend

# 安装依赖
npm install

# 开发模式运行
npm run dev
```

#### 生产环境部署

**方式一：Nginx 部署**

```bash
# 打包
cd frontend
npm run build

# 将 dist 目录复制到服务器
scp -r dist/* user@server:/var/www/exercise-system/

# 配置 Nginx
sudo nano /etc/nginx/sites-available/exercise-system

# 添加以下配置
server {
    listen 80;
    server_name your-domain.com;
    
    root /var/www/exercise-system;
    index index.html;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    location /api {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
    
    # 启用 gzip 压缩
    gzip on;
    gzip_types text/plain text/css application/json application/javascript text/xml application/xml application/xml+rss text/javascript;
}

# 启用站点
sudo ln -s /etc/nginx/sites-available/exercise-system /etc/nginx/sites-enabled/

# 测试配置
sudo nginx -t

# 重启 Nginx
sudo systemctl restart nginx
```

**方式二：Docker 部署**

```bash
# 创建 Dockerfile
cat > frontend/Dockerfile << EOF
# 构建阶段
FROM node:18-alpine as builder
WORKDIR /app
COPY package*.json ./
RUN npm install
COPY . .
RUN npm run build

# 运行阶段
FROM nginx:alpine
COPY --from=builder /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]
EOF

# 创建 Nginx 配置
cat > frontend/nginx.conf << EOF
server {
    listen 80;
    server_name localhost;
    
    root /usr/share/nginx/html;
    index index.html;
    
    location / {
        try_files \$uri \$uri/ /index.html;
    }
    
    location /api {
        proxy_pass http://backend:8080;
        proxy_set_header Host \$host;
        proxy_set_header X-Real-IP \$remote_addr;
        proxy_set_header X-Forwarded-For \$proxy_add_x_forwarded_for;
    }
}
EOF

# 构建镜像
cd frontend
docker build -t exercise-frontend:1.0.0 .

# 运行容器
docker run -d \
  --name exercise-frontend \
  -p 80:80 \
  exercise-frontend:1.0.0
```

**方式三：Vercel 部署（推荐）**

```bash
# 安装 Vercel CLI
npm i -g vercel

# 登录 Vercel
vercel login

# 部署
cd frontend
vercel

# 生产环境部署
vercel --prod
```

**方式四：Netlify 部署**

```bash
# 安装 Netlify CLI
npm i -g netlify-cli

# 登录 Netlify
netlify login

# 部署
cd frontend
netlify deploy --prod --dir=dist
```

### 8.4 云服务器部署（阿里云/腾讯云）

#### 购买云服务器
- 推荐配置：2核4G，带宽5Mbps
- 操作系统：Ubuntu 20.04 LTS 或 CentOS 7.9
- 安全组开放端口：80、443、22、3306、6379

#### 环境安装

```bash
# 更新系统
sudo apt update && sudo apt upgrade -y

# 安装 Java 17
sudo apt install openjdk-17-jdk -y
java -version

# 安装 Maven
sudo apt install maven -y
mvn -version

# 安装 Node.js 18
curl -fsSL https://deb.nodesource.com/setup_18.x | sudo -E bash -
sudo apt install nodejs -y
node -v
npm -v

# 安装 MySQL 8
sudo apt install mysql-server -y
sudo mysql_secure_installation

# 安装 Redis
sudo apt install redis-server -y
sudo systemctl start redis
sudo systemctl enable redis

# 安装 Nginx
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
```

#### 部署应用

```bash
# 克隆项目
git clone your-repo-url
cd Exam

# 配置数据库
mysql -u root -p < database/init.sql

# 配置后端
cd backend
nano src/main/resources/application.yml
# 修改数据库和 Redis 配置

# 打包后端
mvn clean package -DskipTests

# 运行后端
nohup java -jar target/exercise-system-1.0.0.jar > backend.log 2>&1 &

# 配置前端
cd ../frontend
npm install
npm run build

# 部署前端
sudo cp -r dist/* /var/www/exercise-system/
sudo nano /etc/nginx/sites-available/exercise-system
# 添加 Nginx 配置（参考上文）

# 重启 Nginx
sudo systemctl restart nginx
```

#### 使用 PM2 管理进程

```bash
# 安装 PM2
npm install -g pm2

# 启动后端
pm2 start target/exercise-system-1.0.0.jar --name exercise-backend

# 查看状态
pm2 status

# 查看日志
pm2 logs exercise-backend

# 设置开机自启
pm2 startup
pm2 save
```

### 8.5 HTTPS 配置（SSL 证书）

#### 使用 Let's Encrypt 免费证书

```bash
# 安装 Certbot
sudo apt install certbot python3-certbot-nginx -y

# 获取证书
sudo certbot --nginx -d your-domain.com

# 自动续期
sudo certbot renew --dry-run
```

#### Nginx HTTPS 配置

```nginx
server {
    listen 443 ssl http2;
    server_name your-domain.com;
    
    ssl_certificate /etc/letsencrypt/live/your-domain.com/fullchain.pem;
    ssl_certificate_key /etc/letsencrypt/live/your-domain.com/privkey.pem;
    
    ssl_protocols TLSv1.2 TLSv1.3;
    ssl_ciphers HIGH:!aNULL:!MD5;
    
    root /var/www/exercise-system;
    index index.html;
    
    location / {
        try_files $uri $uri/ /index.html;
    }
    
    location /api {
        proxy_pass http://localhost:8080;
        proxy_set_header Host $host;
        proxy_set_header X-Real-IP $remote_addr;
        proxy_set_header X-Forwarded-For $proxy_add_x_forwarded_for;
        proxy_set_header X-Forwarded-Proto $scheme;
    }
}

server {
    listen 80;
    server_name your-domain.com;
    return 301 https://$server_name$request_uri;
}
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
| wallet | 钱包表 |
| book_purchase | 习题册购买记录表 |
| wallet_transaction | 钱包交易记录表 |

## 十、常见问题

### 1. 后端启动失败
- 检查数据库连接配置是否正确
- 确保MySQL服务已启动
- 检查Redis服务是否启动
- 检查JDK版本是否为17+

### 2. 前端启动失败
- 检查Node.js版本是否为18+
- 删除 `node_modules` 目录后重新执行 `npm install`
- 检查端口是否被占用

### 3. Redis 连接失败
- 检查 Redis 服务是否启动：`redis-cli ping`
- 检查 Redis 配置是否正确
- 检查防火墙是否开放 6379 端口
- 检查 Redis 密码是否正确

### 4. 邮件发送失败
- 检查邮件服务器配置是否正确
- 检查邮箱是否开启 SMTP 服务
- 检查授权码是否正确
- 检查网络连接是否正常

### 5. 跨域问题
- 后端已配置CORS，允许所有来源访问
- 如需修改，编辑 `CorsConfig.java` 文件
- 生产环境建议使用 Nginx 反向代理

### 6. 部署后无法访问
- 检查防火墙是否开放相应端口
- 检查云服务器安全组配置
- 检查 Nginx 配置是否正确
- 查看应用日志排查错误

## 十一、开发说明

- 后端遵循RESTful接口规范
- 所有接口返回统一JSON格式：`{code: 200, msg: "成功", data: {...}}`
- 前端使用Composition API开发
- 状态管理使用Pinia
- Redis 用于存储验证码和缓存数据
- 邮件服务用于用户注册和找回密码

## 十二、性能优化建议

### 后端优化
- 启用 Redis 缓存减少数据库查询
- 使用连接池优化数据库连接
- 启用 MyBatis 二级缓存
- 使用异步处理邮件发送

### 前端优化
- 使用路由懒加载
- 启用 gzip 压缩
- 使用 CDN 加速静态资源
- 图片懒加载和压缩

### 服务器优化
- 配置 Nginx 负载均衡
- 启用 HTTP/2
- 使用 CDN 加速
- 配置 Redis 持久化

## 十三、安全建议

- 修改默认数据库密码
- 配置 Redis 密码认证
- 使用 HTTPS 加密传输
- 定期备份数据库
- 限制 API 访问频率
- 使用 JWT Token 认证
- 配置防火墙规则
- 定期更新依赖包

## 十四、维护建议

- 定期检查日志文件
- 监控服务器资源使用情况
- 定期备份数据库和 Redis 数据
- 定期更新系统和依赖包
- 配置日志轮转避免日志文件过大
- 使用监控工具（如 Prometheus + Grafana）
