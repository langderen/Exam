package com.exercise.mapper;

import com.exercise.entity.SysUser;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.math.BigDecimal;
import java.util.List;

@Mapper
public interface SysUserMapper {
    SysUser selectByUsername(@Param("username") String username);
    
    SysUser selectById(@Param("id") Long id);
    
    SysUser selectByEmail(@Param("email") String email);
    
    int insert(SysUser user);
    
    int update(SysUser user);
    
    int updateInfo(SysUser user);
    
    int updatePassword(@Param("id") Long id, @Param("password") String password);
    
    int updateBalance(@Param("id") Long id, @Param("amount") BigDecimal amount);
    
    List<SysUser> selectList(@Param("role") String role);
    
    int deleteById(@Param("id") Long id);
}
