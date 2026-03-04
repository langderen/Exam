package com.exercise.controller;

import com.exercise.common.Result;
import com.exercise.entity.Notification;
import com.exercise.service.NotificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;
import java.util.List;

@RestController
@RequestMapping("/notification")
public class NotificationController {
    
    @Autowired
    private NotificationService notificationService;
    
    @GetMapping("/list/{userId}")
    public Result<List<Notification>> list(@PathVariable Long userId) {
        List<Notification> notifications = notificationService.getByUserId(userId);
        return Result.success(notifications);
    }
    
    @GetMapping("/unread/{userId}")
    public Result<List<Notification>> unreadList(@PathVariable Long userId) {
        List<Notification> notifications = notificationService.getUnreadByUserId(userId);
        return Result.success(notifications);
    }
    
    @GetMapping("/count/{userId}")
    public Result<Integer> unreadCount(@PathVariable Long userId) {
        int count = notificationService.countUnreadByUserId(userId);
        return Result.success(count);
    }
    
    @PutMapping("/read/{id}")
    public Result<Void> markAsRead(@PathVariable Long id) {
        notificationService.markAsRead(id);
        return Result.success();
    }
    
    @PutMapping("/readAll/{userId}")
    public Result<Void> markAllAsRead(@PathVariable Long userId) {
        notificationService.markAllAsRead(userId);
        return Result.success();
    }
}
