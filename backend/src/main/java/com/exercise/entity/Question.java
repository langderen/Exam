package com.exercise.entity;

import com.fasterxml.jackson.annotation.JsonFormat;
import lombok.Data;
import java.time.LocalDateTime;

@Data
public class Question {
    private Long id;
    private Long bookId;
    private Long typeId;
    private String content;
    private String options;
    private String answer;
    private String analysis;
    private Integer difficulty;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;
    
    private String typeName;
    private String bookName;
    private Integer isCollected;
    private Integer errorCount;
}
