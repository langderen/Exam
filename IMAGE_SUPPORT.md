# 题目图片支持功能说明

## 数据库更新

执行以下SQL脚本来添加图片字段：

```sql
-- 添加题目图片支持
USE exercise_system;

-- 添加题目图片字段
ALTER TABLE question ADD COLUMN IF NOT EXISTS content_image VARCHAR(500) DEFAULT NULL COMMENT '题目图片URL' AFTER content;
ALTER TABLE question ADD COLUMN IF NOT EXISTS options_image VARCHAR(500) DEFAULT NULL COMMENT '选项图片URL' AFTER options;

SELECT '=== 题目图片支持添加完成 ===' as info;
```

## 后端修改

### 1. 实体类修改
- `Question.java` - 添加了 `contentImage` 和 `optionsImage` 字段

### 2. Mapper修改
- `QuestionMapper.xml` - 更新了resultMap、insert和update语句

### 3. 新增控制器
- `UploadController.java` - 图片上传接口
- `WebConfig.java` - 静态资源配置

## 前端修改

### BookManage.vue
- 添加了题目图片上传功能
- 添加了选项图片上传功能
- 添加了图片预览和删除功能

## 使用说明

1. **上传目录配置**
   - 默认上传目录：`D:/uploads`
   - 可在 `application.yml` 中配置 `upload.path`

2. **图片访问**
   - 上传后的图片URL格式：`http://localhost:8080/images/yyyyMMdd/uuid.jpg`

3. **限制**
   - 只能上传图片文件
   - 图片大小不能超过5MB

4. **功能**
   - 题目内容可以配图
   - 选项可以配图（单选、多选题型）
   - 支持图片预览和删除
