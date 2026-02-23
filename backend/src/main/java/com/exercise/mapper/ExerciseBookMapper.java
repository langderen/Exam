package com.exercise.mapper;

import com.exercise.entity.ExerciseBook;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface ExerciseBookMapper {
    List<ExerciseBook> selectList(@Param("bookName") String bookName);
    
    ExerciseBook selectDetailById(@Param("id") Long id, @Param("userId") Long userId);
    
    ExerciseBook selectById(@Param("id") Long id);
    
    int insert(ExerciseBook book);
    
    int update(ExerciseBook book);
    
    int deleteById(@Param("id") Long id);
    
    List<ExerciseBook> selectByCreatorId(@Param("creatorId") Long creatorId);
    
    int updateStatus(@Param("id") Long id, @Param("status") Integer status);
    
    List<ExerciseBook> selectAll();
}
