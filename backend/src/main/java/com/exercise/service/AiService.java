package com.exercise.service;

import java.util.Map;

public interface AIService {
    String chat(String prompt);
    
    String generateAnalysis(Map<String, Object> question);
    
    String generateQuestions(Map<String, Object> params);
    
    String judgeAnswer(Map<String, Object> params);
}
