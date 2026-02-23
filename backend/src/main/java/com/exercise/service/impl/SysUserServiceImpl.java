package com.exercise.service.impl;

import cn.hutool.crypto.digest.DigestUtil;
import com.exercise.entity.SysUser;
import com.exercise.mapper.SysUserMapper;
import com.exercise.service.SysUserService;
import com.exercise.vo.LoginVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

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
}
