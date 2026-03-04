package com.exercise.controller;

import com.exercise.common.Result;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.multipart.MultipartFile;
import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;
import java.util.HashMap;
import java.util.Map;
import java.util.UUID;

@RestController
@RequestMapping("/upload")
@CrossOrigin(origins = "*", maxAge = 3600)
public class UploadController {
    
    @Value("${upload.path:D:/uploads}")
    private String uploadPath;
    
    @Value("${server.port:8080}")
    private String serverPort;
    
    @PostMapping("/image")
    public Result<String> uploadImage(@RequestParam("file") MultipartFile file) {
        try {
            if (file.isEmpty()) {
                return Result.error("文件不能为空");
            }
            
            String contentType = file.getContentType();
            if (contentType == null || !contentType.startsWith("image/")) {
                return Result.error("只能上传图片文件");
            }
            
            String originalFilename = file.getOriginalFilename();
            String extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            
            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
            String datePath = sdf.format(new Date());
            
            String fileName = UUID.randomUUID().toString() + extension;
            String relativePath = "/images/" + datePath + "/" + fileName;
            String fullPath = uploadPath + relativePath;
            
            File destFile = new File(fullPath);
            destFile.getParentFile().mkdirs();
            
            file.transferTo(destFile);
            
            String imageUrl = "http://localhost:" + serverPort + relativePath;
            
            return Result.success(imageUrl);
        } catch (IOException e) {
            e.printStackTrace();
            return Result.error("上传失败：" + e.getMessage());
        }
    }

    @PostMapping("/file")
    public Result<Map<String, String>> uploadFile(@RequestParam("file") MultipartFile file) {
        try {
            if (file.isEmpty()) {
                return Result.error("文件不能为空");
            }
            
            String originalFilename = file.getOriginalFilename();
            if (originalFilename == null || originalFilename.isEmpty()) {
                return Result.error("文件名无效");
            }
            
            String extension = "";
            if (originalFilename.contains(".")) {
                extension = originalFilename.substring(originalFilename.lastIndexOf("."));
            }
            
            SimpleDateFormat sdf = new SimpleDateFormat("yyyyMMdd");
            String datePath = sdf.format(new Date());
            
            String fileName = UUID.randomUUID().toString() + extension;
            String relativePath = "/api/files/" + datePath + "/" + fileName;
            String fullPath = uploadPath + relativePath;
            
            File destFile = new File(fullPath);
            destFile.getParentFile().mkdirs();
            
            file.transferTo(destFile);
            
            String fileUrl = "http://localhost:" + serverPort + relativePath;
            
            Map<String, String> result = new HashMap<>();
            result.put("url", fileUrl);
            result.put("name", originalFilename);
            
            return Result.success(result);
        } catch (IOException e) {
            e.printStackTrace();
            return Result.error("上传失败：" + e.getMessage());
        }
    }
}
