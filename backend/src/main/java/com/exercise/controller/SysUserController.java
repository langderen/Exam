package com.exercise.controller;

import cn.dev33.satoken.annotation.SaCheckLogin;
import com.exercise.common.Result;
import com.exercise.dto.LoginDTO;
import com.exercise.dto.RegisterDTO;
import com.exercise.dto.ResetPasswordDTO;
import com.exercise.dto.SendCodeDTO;
import com.exercise.entity.SysUser;
import com.exercise.service.SysUserService;
import com.exercise.vo.LoginVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.*;

import java.util.List;
import java.util.Map;

@RestController
@RequestMapping("/user")
public class SysUserController {
    
    @Autowired
    private SysUserService sysUserService;
    
    @PostMapping("/login")
    public Result<LoginVO> login(@RequestBody LoginDTO dto) {
        try {
            LoginVO vo = sysUserService.login(dto.getUsername(), dto.getPassword());
            return Result.success(vo);
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }
    
    @PostMapping("/register")
    public Result<Void> register(@RequestBody RegisterDTO dto) {
        try {
            SysUser user = new SysUser();
            user.setUsername(dto.getUsername());
            user.setEmail(dto.getEmail());
            user.setPassword(dto.getPassword());
            sysUserService.register(user, dto.getCode());
            return Result.success();
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }
    
    @PostMapping("/sendVerifyCode")
    public Result<Void> sendVerifyCode(@RequestBody SendCodeDTO dto) {
        try {
            sysUserService.sendVerifyCode(dto.getEmail(), dto.getType());
            return Result.success();
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }
    
    @PostMapping("/resetPassword")
    public Result<Void> resetPassword(@RequestBody ResetPasswordDTO dto) {
        try {
            sysUserService.resetPassword(dto.getEmail(), dto.getCode(), dto.getNewPassword());
            return Result.success();
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }
    
    @GetMapping("/info/{id}")
    @SaCheckLogin
    public Result<SysUser> getInfo(@PathVariable Long id) {
        SysUser user = sysUserService.getById(id);
        if (user != null) {
            user.setPassword(null);
        }
        return Result.success(user);
    }
    
    @PutMapping("/info")
    @SaCheckLogin
    public Result<Void> updateInfo(@RequestBody SysUser user) {
        try {
            sysUserService.updateInfo(user);
            return Result.success();
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }
    
    @PutMapping("/password")
    @SaCheckLogin
    public Result<Void> updatePassword(@RequestBody Map<String, Object> params) {
        try {
            Long userId = Long.parseLong(params.get("userId").toString());
            String oldPassword = params.get("oldPassword").toString();
            String newPassword = params.get("newPassword").toString();
            sysUserService.updatePassword(userId, oldPassword, newPassword);
            return Result.success();
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }
    
    @GetMapping("/list")
    @SaCheckLogin
    public Result<List<SysUser>> listUsers(@RequestParam(required = false) String role) {
        List<SysUser> users = sysUserService.listUsers(role);
        users.forEach(u -> u.setPassword(null));
        return Result.success(users);
    }
    
    @DeleteMapping("/{id}")
    @SaCheckLogin
    public Result<Void> deleteUser(@PathVariable Long id) {
        try {
            sysUserService.deleteUser(id);
            return Result.success();
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }
}
