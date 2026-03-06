package com.exercise.service.impl;

import cn.dev33.satoken.stp.StpUtil;
import cn.hutool.crypto.digest.DigestUtil;
import com.exercise.entity.SysUser;
import com.exercise.mapper.SysUserMapper;
import com.exercise.service.SysUserService;
import com.exercise.vo.LoginVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.data.redis.core.RedisTemplate;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.stereotype.Service;

import java.time.LocalDateTime;
import java.util.List;
import java.util.Random;
import java.util.concurrent.TimeUnit;

@Service
public class SysUserServiceImpl implements SysUserService {
    
    @Autowired
    private SysUserMapper sysUserMapper;
    
    @Autowired
    private JavaMailSender mailSender;
    
    @Autowired
    private RedisTemplate<String, String> redisTemplate;
    
    @Value("${spring.mail.username}")
    private String fromEmail;
    
    private static final String VERIFY_CODE_PREFIX = "verify_code:";
    private static final long VERIFY_CODE_EXPIRE_MINUTES = 5;
    
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
        
        StpUtil.login(user.getId());
        String token = StpUtil.getTokenValue();
        
        LoginVO vo = new LoginVO();
        vo.setId(user.getId());
        vo.setUsername(user.getUsername());
        vo.setRole(user.getRole());
        vo.setToken(token);
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
    public void register(SysUser user, String code) {
        SysUser existUser = sysUserMapper.selectByUsername(user.getUsername());
        if (existUser != null) {
            throw new RuntimeException("用户名已存在");
        }
        
        if (user.getEmail() != null && !user.getEmail().isEmpty()) {
            SysUser emailUser = sysUserMapper.selectByEmail(user.getEmail());
            if (emailUser != null) {
                throw new RuntimeException("该邮箱已被注册");
            }
            
            if (code != null && !code.isEmpty()) {
                String redisKey = VERIFY_CODE_PREFIX + "register:" + user.getEmail();
                String savedCode = redisTemplate.opsForValue().get(redisKey);
                
                if (savedCode == null) {
                    throw new RuntimeException("请先获取验证码");
                }
                
                if (!savedCode.equals(code)) {
                    throw new RuntimeException("验证码错误");
                }
                
                redisTemplate.delete(redisKey);
            } else {
                throw new RuntimeException("请输入验证码");
            }
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
    
    @Override
    public void sendVerifyCode(String email, String type) {
        if ("register".equals(type)) {
            SysUser existUser = sysUserMapper.selectByEmail(email);
            if (existUser != null) {
                throw new RuntimeException("该邮箱已被注册");
            }
        } else {
            SysUser user = sysUserMapper.selectByEmail(email);
            if (user == null) {
                throw new RuntimeException("该邮箱未注册");
            }
        }
        
        String code = generateVerifyCode();
        
        String redisKey = VERIFY_CODE_PREFIX + type + ":" + email;
        redisTemplate.opsForValue().set(redisKey, code, VERIFY_CODE_EXPIRE_MINUTES, TimeUnit.MINUTES);
        
        sendEmail(email, code, type);
    }
    
    @Override
    public void resetPassword(String email, String code, String newPassword) {
        SysUser user = sysUserMapper.selectByEmail(email);
        if (user == null) {
            throw new RuntimeException("该邮箱未注册");
        }
        
        String redisKey = VERIFY_CODE_PREFIX + "forgot:" + email;
        String savedCode = redisTemplate.opsForValue().get(redisKey);
        
        if (savedCode == null) {
            throw new RuntimeException("请先获取验证码");
        }
        
        if (!savedCode.equals(code)) {
            throw new RuntimeException("验证码错误");
        }
        
        sysUserMapper.updatePassword(user.getId(), DigestUtil.md5Hex(newPassword));
        redisTemplate.delete(redisKey);
    }
    
    private String generateVerifyCode() {
        Random random = new Random();
        int code = 100000 + random.nextInt(900000);
        return String.valueOf(code);
    }
    
    private void sendEmail(String toEmail, String code, String type) {
        try {
            jakarta.mail.internet.MimeMessage mimeMessage = mailSender.createMimeMessage();
            MimeMessageHelper helper = new MimeMessageHelper(mimeMessage, true, "UTF-8");
            helper.setFrom(fromEmail);
            helper.setTo(toEmail);
            
            String subject = "";
            String title = "";
            if ("register".equals(type)) {
                subject = "习题册刷题系统 - 注册验证码";
                title = "注册验证";
            } else {
                subject = "习题册刷题系统 - 密码重置验证码";
                title = "密码重置";
            }
            
            String htmlContent = "<!DOCTYPE html>" +
                "<html>" +
                "<head>" +
                "<meta charset='UTF-8'>" +
                "<meta name='viewport' content='width=device-width, initial-scale=1.0'>" +
                "</head>" +
                "<body style='margin: 0; padding: 0; font-family: -apple-system, BlinkMacSystemFont, 'Segoe UI', 'Roboto', 'Helvetica Neue', Arial, sans-serif; background-color: #f5f5f5;'>" +
                "<table width='100%' cellpadding='0' cellspacing='0' style='background-color: #f5f5f5; padding: 40px 0;'>" +
                "<tr>" +
                "<td align='center'>" +
                "<table width='600' cellpadding='0' cellspacing='0' style='background-color: #ffffff; border-radius: 12px; box-shadow: 0 4px 20px rgba(0,0,0,0.08);'>" +
                "<tr>" +
                "<td style='background: linear-gradient(135deg, #667eea 0%, #764ba2 100%); padding: 30px; border-radius: 12px 12px 0 0;'>" +
                "<h1 style='color: #ffffff; margin: 0; font-size: 24px; text-align: center;'>习题册刷题系统</h1>" +
                "</td>" +
                "</tr>" +
                "<tr>" +
                "<td style='padding: 40px 30px;'>" +
                "<h2 style='color: #333333; margin: 0 0 20px 0; font-size: 20px; font-weight: 600;'>" + title + "</h2>" +
                "<p style='color: #666666; margin: 0 0 30px 0; font-size: 14px; line-height: 1.6;'>您好，</p>" +
                "<p style='color: #666666; margin: 0 0 30px 0; font-size: 14px; line-height: 1.6;'>您正在进行" + title + "操作，您的验证码如下：</p>" +
                "<div style='background-color: #f8f9ff; border: 2px dashed #667eea; border-radius: 8px; padding: 20px; text-align: center; margin: 30px 0;'>" +
                "<span style='font-size: 32px; font-weight: bold; color: #667eea; letter-spacing: 8px;'>" + code + "</span>" +
                "</div>" +
                "<p style='color: #999999; margin: 0 0 10px 0; font-size: 12px; line-height: 1.6;'>验证码有效期为 <strong>5分钟</strong>，请尽快完成验证。</p>" +
                "<p style='color: #ff4d4f; margin: 0; font-size: 12px; line-height: 1.6;'>请勿将验证码泄露给他人，如非本人操作，请忽略此邮件。</p>" +
                "</td>" +
                "</tr>" +
                "<tr>" +
                "<td style='background-color: #fafafa; padding: 20px 30px; border-radius: 0 0 12px 12px; text-align: center;'>" +
                "<p style='color: #999999; margin: 0; font-size: 12px;'>© 2026 习题册刷题系统</p>" +
                "</td>" +
                "</tr>" +
                "</table>" +
                "</td>" +
                "</tr>" +
                "</table>" +
                "</body>" +
                "</html>";
            
            helper.setSubject(subject);
            helper.setText(htmlContent, true);
            mailSender.send(mimeMessage);
        } catch (Exception e) {
            throw new RuntimeException("邮件发送失败，请检查邮箱配置: " + e.getMessage());
        }
    }
}
