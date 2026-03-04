package com.exercise.service.impl;

import com.exercise.entity.Notification;
import com.exercise.mapper.NotificationMapper;
import com.exercise.service.NotificationService;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import java.util.List;

@Service
public class NotificationServiceImpl implements NotificationService {
    
    @Autowired
    private NotificationMapper notificationMapper;
    
    @Override
    public void sendNotification(Long userId, String title, String content, String type, Long relatedId) {
        Notification notification = new Notification();
        notification.setUserId(userId);
        notification.setTitle(title);
        notification.setContent(content);
        notification.setType(type);
        notification.setRelatedId(relatedId);
        notification.setIsRead(0);
        notificationMapper.insert(notification);
    }
    
    @Override
    public Notification getById(Long id) {
        return notificationMapper.selectById(id);
    }
    
    @Override
    public List<Notification> getByUserId(Long userId) {
        return notificationMapper.selectByUserId(userId);
    }
    
    @Override
    public List<Notification> getUnreadByUserId(Long userId) {
        return notificationMapper.selectUnreadByUserId(userId);
    }
    
    @Override
    public int countUnreadByUserId(Long userId) {
        return notificationMapper.countUnreadByUserId(userId);
    }
    
    @Override
    public void markAsRead(Long id) {
        notificationMapper.markAsRead(id);
    }
    
    @Override
    public void markAllAsRead(Long userId) {
        notificationMapper.markAllAsRead(userId);
    }
}
