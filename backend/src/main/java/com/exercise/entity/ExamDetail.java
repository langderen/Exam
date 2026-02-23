package com.exercise.entity;

import lombok.Data;

@Data
public class ExamDetail {
    private Long id;
    private Long examId;
    private Long questionId;
    private String userAnswer;
    private Integer isCorrect;
}
