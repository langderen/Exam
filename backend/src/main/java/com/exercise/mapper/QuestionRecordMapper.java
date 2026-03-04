package com.exercise.mapper;

import com.exercise.entity.QuestionRecord;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;
import java.util.List;

@Mapper
public interface QuestionRecordMapper {
    int insert(QuestionRecord record);
    
    int update(QuestionRecord record);
    
    QuestionRecord selectById(@Param("id") Long id);
    
    List<QuestionRecord> selectErrorList(@Param("userId") Long userId, @Param("bookId") Long bookId, @Param("typeId") Long typeId);
    
    int countErrors(@Param("userId") Long userId, @Param("bookId") Long bookId, @Param("typeId") Long typeId);
    
    int countDoneByBook(@Param("userId") Long userId, @Param("bookId") Long bookId);
    
    int countCorrectByBook(@Param("userId") Long userId, @Param("bookId") Long bookId);
    
    int deleteById(@Param("id") Long id);
    
    int deleteByUserAndBook(@Param("userId") Long userId, @Param("bookId") Long bookId);
    
    QuestionRecord selectByUserAndQuestion(@Param("userId") Long userId, @Param("questionId") Long questionId);
    
    List<QuestionRecord> selectAnswerStatusByBook(@Param("userId") Long userId, @Param("bookId") Long bookId);
    
    List<QuestionRecord> selectHighErrorQuestions(@Param("userId") Long userId, @Param("limit") Integer limit);
    
    List<QuestionRecord> selectRecentRecords(@Param("userId") Long userId, @Param("limit") Integer limit);
}
