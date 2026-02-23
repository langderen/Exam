package com.exercise.controller;

import com.exercise.common.Result;
import com.exercise.dto.LoginDTO;
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
    public Result<Void> register(@RequestBody SysUser user) {
        try {
            sysUserService.register(user);
            return Result.success();
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }
    
    @GetMapping("/info/{id}")
    public Result<SysUser> getInfo(@PathVariable Long id) {
        SysUser user = sysUserService.getById(id);
        if (user != null) {
            user.setPassword(null);
        }
        return Result.success(user);
    }
    
    @PutMapping("/info")
    public Result<Void> updateInfo(@RequestBody SysUser user) {
        try {
            sysUserService.updateInfo(user);
            return Result.success();
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }
    
    @PutMapping("/password")
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
    public Result<List<SysUser>> listUsers(@RequestParam(required = false) String role) {
        List<SysUser> users = sysUserService.listUsers(role);
        users.forEach(u -> u.setPassword(null));
        return Result.success(users);
    }
    
    @DeleteMapping("/{id}")
    public Result<Void> deleteUser(@PathVariable Long id) {
        try {
            sysUserService.deleteUser(id);
            return Result.success();
        } catch (Exception e) {
            return Result.error(e.getMessage());
        }
    }
}
