package com.exercise.mapper;

import com.exercise.entity.ExerciseBook;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.math.BigDecimal;
import java.util.List;

@Mapper
public interface ExerciseBookMapper {
    List<ExerciseBook> selectList(@Param("bookName") String bookName);
    
    List<ExerciseBook> selectListWithPurchase(@Param("bookName") String bookName, @Param("userId") Long userId);
    
    ExerciseBook selectDetailById(@Param("id") Long id, @Param("userId") Long userId);
    
    ExerciseBook selectById(@Param("id") Long id);
    
    ExerciseBook selectByIdWithPurchase(@Param("id") Long id, @Param("userId") Long userId);
    
    int insert(ExerciseBook book);
    
    int update(ExerciseBook book);
    
    int deleteById(@Param("id") Long id);
    
    List<ExerciseBook> selectByCreatorId(@Param("creatorId") Long creatorId);
    
    int updateStatus(@Param("id") Long id, @Param("status") Integer status);
    
    int updatePrice(@Param("id") Long id, @Param("price") BigDecimal price);
    
    List<ExerciseBook> selectAll();
}
