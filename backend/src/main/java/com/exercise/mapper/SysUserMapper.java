package com.exercise.mapper;

import com.exercise.entity.SysUser;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import java.util.List;

@Mapper
public interface SysUserMapper {
    SysUser selectByUsername(@Param("username") String username);
    
    SysUser selectById(@Param("id") Long id);
    
    int insert(SysUser user);
    
    int update(SysUser user);
    
    int updateInfo(SysUser user);
    
    int updatePassword(@Param("id") Long id, @Param("password") String password);
    
    List<SysUser> selectList(@Param("role") String role);
    
    int updateStatus(@Param("id") Long id, @Param("status") Integer status);
    
    int deleteById(@Param("id") Long id);
}
