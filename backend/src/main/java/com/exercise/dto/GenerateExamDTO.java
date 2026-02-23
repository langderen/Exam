package com.exercise.dto;

import lombok.Data;
import java.util.List;

@Data
public class GenerateExamDTO {
    private Long userId;
    private Long bookId;
    private List<Long> typeIds;
    private Integer count;
}
