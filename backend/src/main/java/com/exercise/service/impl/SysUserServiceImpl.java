package com.exercise.service.impl;

import cn.hutool.crypto.digest.DigestUtil;
import com.exercise.entity.SysUser;
import com.exercise.mapper.SysUserMapper;
import com.exercise.service.SysUserService;
import com.exercise.vo.LoginVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;

@Service
public class SysUserServiceImpl implements SysUserService {
    
    @Autowired
    private SysUserMapper sysUserMapper;
    
    @Override
    public LoginVO login(String username, String password) {
        SysUser user = sysUserMapper.selectByUsername(username);
        if (user == null) {
            throw new RuntimeException("用户不存在");
        }
        String md5Password = DigestUtil.md5Hex(password);
        if (!md5Password.equals(user.getPassword())) {
            throw new RuntimeException("密码错误");
        }
        LoginVO vo = new LoginVO();
        vo.setId(user.getId());
        vo.setUsername(user.getUsername());
        vo.setNickname(user.getNickname());
        vo.setRole(user.getRole());
        vo.setToken("token_" + user.getId() + "_" + System.currentTimeMillis());
        return vo;
    }
    
    @Override
    public SysUser getById(Long id) {
        return sysUserMapper.selectById(id);
    }
    
    @Override
    public SysUser getByUsername(String username) {
        return sysUserMapper.selectByUsername(username);
    }
    
    @Override
    public void register(SysUser user) {
        SysUser existUser = sysUserMapper.selectByUsername(user.getUsername());
        if (existUser != null) {
            throw new RuntimeException("用户名已存在");
        }
        user.setPassword(DigestUtil.md5Hex(user.getPassword()));
        user.setRole("user");
        user.setCreateTime(LocalDateTime.now());
        sysUserMapper.insert(user);
    }
    
    @Override
    public void updateInfo(SysUser user) {
        user.setUpdateTime(LocalDateTime.now());
        sysUserMapper.updateInfo(user);
    }
    
    @Override
    public void updatePassword(Long userId, String oldPassword, String newPassword) {
        SysUser user = sysUserMapper.selectById(userId);
        if (user == null) {
            throw new RuntimeException("用户不存在");
        }
        String md5OldPassword = DigestUtil.md5Hex(oldPassword);
        if (!md5OldPassword.equals(user.getPassword())) {
            throw new RuntimeException("原密码错误");
        }
        sysUserMapper.updatePassword(userId, DigestUtil.md5Hex(newPassword));
    }
    
    @Override
    public List<SysUser> listUsers(String role) {
        return sysUserMapper.selectList(role);
    }
    
    @Override
    public void deleteUser(Long id) {
        sysUserMapper.deleteById(id);
    }
}
