package com.exercise.mapper;

import com.exercise.entity.Question;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface QuestionMapper {
    List<Question> selectByBookId(@Param("bookId") Long bookId);
    
    Question selectById(@Param("id") Long id);
    
    Question selectBySeq(@Param("bookId") Long bookId, @Param("offset") Integer offset);
    
    Question selectSequence(@Param("bookId") Long bookId, @Param("offset") Integer offset);
    
    Question selectRandom(@Param("bookId") Long bookId, @Param("userId") Long userId);
    
    List<Question> selectRandomByTypes(@Param("bookId") Long bookId, @Param("typeIds") List<Long> typeIds, @Param("count") Integer count);
    
    int countByBookId(@Param("bookId") Long bookId);
    
    int insert(Question question);
    
    int update(Question question);
    
    int deleteById(@Param("id") Long id);
    
    List<Question> selectListByBookId(@Param("bookId") Long bookId);
}
