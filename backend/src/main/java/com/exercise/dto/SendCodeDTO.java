package com.exercise.dto;

import lombok.Data;

@Data
public class SendCodeDTO {
    private String email;
    private String type;
}
