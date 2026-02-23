package com.exercise.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import java.time.LocalDateTime;

@Data
public class QuestionRecord {
    private Long id;
    private Long userId;
    private Long questionId;
    private Long bookId;
    private Integer questionSeq;
    private String answer;
    private Integer isCorrect;
    private Integer isAnswered;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime doTime;
    
    private Question question;
}
