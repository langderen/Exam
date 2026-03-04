package com.exercise.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import java.time.LocalDateTime;

@Data
public class ExamQuestion {
    private Long id;
    private Long examId;
    private Long questionId;
    private Integer questionSeq;
    private String userAnswer;
    private Integer isCorrect;
    private Integer isAnswered;
    private Integer aiScore;
    private String aiComment;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;
}
