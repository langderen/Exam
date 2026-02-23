package com.exercise.dto;

import lombok.Data;

@Data
public class SaveAnswerDTO {
    private Long examId;
    private Long questionId;
    private Integer questionSeq;
    private String userAnswer;
}
