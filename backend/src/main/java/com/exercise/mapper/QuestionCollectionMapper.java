package com.exercise.mapper;

import com.exercise.entity.QuestionCollection;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface QuestionCollectionMapper {
    int insert(QuestionCollection collection);
    
    int deleteByUserAndQuestion(@Param("userId") Long userId, @Param("questionId") Long questionId);
    
    List<QuestionCollection> selectByUserId(@Param("userId") Long userId, @Param("bookId") Long bookId, @Param("typeId") Long typeId);
    
    int countByUserId(@Param("userId") Long userId, @Param("bookId") Long bookId, @Param("typeId") Long typeId);
    
    QuestionCollection selectByUserAndQuestion(@Param("userId") Long userId, @Param("questionId") Long questionId);
}
