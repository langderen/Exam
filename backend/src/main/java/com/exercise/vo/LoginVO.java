package com.exercise.vo;

import lombok.Data;

@Data
public class LoginVO {
    private Long id;
    private String username;
    private String role;
    private String token;
}
