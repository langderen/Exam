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
    private String contentImage;
    private String options;
    private String optionsImage;
    private String answer;
    private String analysis;
    private Integer difficulty;
    private String attachment;
    private String attachmentName;
    private Integer aiScoring;
    private String keyPoints;
    @JsonFormat(pattern = "yyyy-MM-dd HH:mm:ss")
    private LocalDateTime createTime;
    
    private String typeName;
    private String bookName;
    private Integer isCollected;
    private Integer errorCount;
}
