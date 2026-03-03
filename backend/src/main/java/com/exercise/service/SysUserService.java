package com.exercise.service;

import com.exercise.entity.SysUser;
import com.exercise.vo.LoginVO;

import java.util.List;

public interface SysUserService {
    LoginVO login(String username, String password);
    
    SysUser getById(Long id);
    
    SysUser getByUsername(String username);
    
    void register(SysUser user, String code);
    
    void updateInfo(SysUser user);
    
    void updatePassword(Long userId, String oldPassword, String newPassword);
    
    List<SysUser> listUsers(String role);
    
    void deleteUser(Long id);
    
    void sendVerifyCode(String email, String type);
    
    void resetPassword(String email, String code, String newPassword);
}
