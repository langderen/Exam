package com.exercise.vo;

import lombok.Data;
import java.math.BigDecimal;
import java.util.List;

@Data
public class ExamResultVO {
    private Long examId;
    private Integer totalCount;
    private Integer correctCount;
    private BigDecimal score;
    private List<QuestionResultVO> questions;
    
    @Data
    public static class QuestionResultVO {
        private Long questionId;
        private String content;
        private String options;
        private String correctAnswer;
        private String userAnswer;
        private Integer isCorrect;
        private String analysis;
    }
}
