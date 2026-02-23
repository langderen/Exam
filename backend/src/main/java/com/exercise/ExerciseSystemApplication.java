package com.exercise;

import org.mybatis.spring.annotation.MapperScan;
import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;

@SpringBootApplication
@MapperScan("com.exercise.mapper")
public class ExerciseSystemApplication {
    public static void main(String[] args) {
        SpringApplication.run(ExerciseSystemApplication.class, args);
    }
}
