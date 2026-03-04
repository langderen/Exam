package com.exercise.service;

import com.exercise.entity.Notification;
import java.util.List;

public interface NotificationService {
    void sendNotification(Long userId, String title, String content, String type, Long relatedId);
    
    Notification getById(Long id);
    
    List<Notification> getByUserId(Long userId);
    
    List<Notification> getUnreadByUserId(Long userId);
    
    int countUnreadByUserId(Long userId);
    
    void markAsRead(Long id);
    
    void markAllAsRead(Long userId);
}
