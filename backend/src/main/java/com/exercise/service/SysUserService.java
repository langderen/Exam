package com.exercise.service;

import com.exercise.entity.SysUser;
import com.exercise.vo.LoginVO;

public interface SysUserService {
    LoginVO login(String username, String password);
    
    SysUser getById(Long id);
    
    SysUser getByUsername(String username);
}
