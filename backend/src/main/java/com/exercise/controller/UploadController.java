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
}
