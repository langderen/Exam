package com.exercise.dto;

import lombok.Data;

@Data
public class SubmitAnswerDTO {
    private Long userId;
    private Long questionId;
    private String answer;
    private String answerAttachment;
    private String answerAttachmentName;
}
