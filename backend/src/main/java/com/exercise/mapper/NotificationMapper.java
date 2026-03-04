package com.exercise.mapper;

import com.exercise.entity.Notification;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface NotificationMapper {
    void insert(Notification notification);
    
    void update(Notification notification);
    
    Notification selectById(Long id);
    
    List<Notification> selectByUserId(@Param("userId") Long userId);
    
    List<Notification> selectUnreadByUserId(@Param("userId") Long userId);
    
    int countUnreadByUserId(@Param("userId") Long userId);
    
    void markAsRead(@Param("id") Long id);
    
    void markAllAsRead(@Param("userId") Long userId);
    
    void deleteById(Long id);
}
