package com.exercise.service;

import com.exercise.entity.SysUser;
import com.exercise.vo.LoginVO;

import java.util.List;

public interface SysUserService {
    LoginVO login(String username, String password);
    
    SysUser getById(Long id);
    
    SysUser getByUsername(String username);
    
    void register(SysUser user);
    
    void updateInfo(SysUser user);
    
    void updatePassword(Long userId, String oldPassword, String newPassword);
    
    List<SysUser> listUsers(String role);
    
    void updateStatus(Long id, Integer status);
    
    void deleteUser(Long id);
}
