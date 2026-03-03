package com.exercise.dto;

import lombok.Data;

@Data
public class RegisterDTO {
    private String username;
    private String email;
    private String code;
    private String password;
}
