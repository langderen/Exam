package com.exercise.dto;

import lombok.Data;
import java.util.List;

@Data
public class SubmitExamDTO {
    private Long userId;
    private Long examId;
    private List<QuestionRecordDTO> questionRecords;
    
    @Data
    public static class QuestionRecordDTO {
        private Long questionId;
        private String answer;
    }
}
