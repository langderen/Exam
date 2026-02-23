package com.exercise.vo;

import lombok.Data;

@Data
public class SubmitResultVO {
    private Integer isCorrect;
    private String answer;
    private String analysis;
}
