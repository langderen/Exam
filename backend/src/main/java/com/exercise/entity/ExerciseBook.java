package com.exercise.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import java.time.LocalDateTime;

@Data
public class ExerciseBook {
    private Long id;
    private String bookName;
    private String bookDesc;
    private Long typeId;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;
    private Integer status;
    private Long creatorId;
    private Integer isPublic;
    
    private Integer totalCount;
    private Integer doneCount;
    private Integer correctCount;
    private Double correctRate;
    
    private String creatorName;
}
