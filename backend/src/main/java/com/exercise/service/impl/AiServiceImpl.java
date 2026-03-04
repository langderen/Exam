package com.exercise.service.impl;

import com.exercise.service.AIService;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Service;
import org.springframework.web.client.RestTemplate;
import org.springframework.http.*;
import java.util.*;

@Service
public class AIServiceImpl implements AIService {
    
    private static final Logger logger = LoggerFactory.getLogger(AIServiceImpl.class);
    
    @Value("${ai.api.url:}")
    private String apiUrl;
    
    @Value("${ai.api.key:}")
    private String apiKey;
    
    @Value("${ai.api.model:}")
    private String model;
    
    private final RestTemplate restTemplate = new RestTemplate();
    
    @Override
    public String chat(String prompt) {
        if (apiUrl == null || apiUrl.isEmpty()) {
            logger.warn("API URL为空，使用模拟响应");
            return getMockResponse(prompt);
        }

        try {
            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.APPLICATION_JSON);
            if (apiKey != null && !apiKey.isEmpty()) {
                headers.setBearerAuth(apiKey);
            }
            logger.debug("ai服务调用请求头: {}", headers);
            
            Map<String, Object> body = new HashMap<>();
            body.put("model", model);
            body.put("messages", new ArrayList<>(List.of(
                Map.of("role", "user", "content", prompt)
            )));
            body.put("stream", false);
            logger.debug("请求体: {}", body);
            
            HttpEntity<Map<String, Object>> entity = new HttpEntity<>(body, headers);
            ResponseEntity<Map> response = restTemplate.exchange(
                apiUrl, HttpMethod.POST, entity, Map.class
            );
            
            logger.info("响应状态: {}", response.getStatusCode());
            
            if (response.getBody() != null) {
                Map<String, Object> message = (Map<String, Object>) response.getBody().get("message");
                if (message != null) {
                    String content = (String) message.get("content");
                    logger.info("AI返回内容: {}", content);
                    logger.info("========== AI服务调用结束 ==========");
                    return content;
                }
            }
        } catch (Exception e) {
            logger.error("AI服务调用异常: {}", e.getMessage());
            logger.error("异常详情:", e);
            return "AI服务出错: " + e.getMessage();
        }
        logger.warn("AI服务返回空结果");
        logger.info("========== AI服务调用结束 ==========");
        return "AI服务暂时不可用";
    }
    
    @Override
    public String generateAnalysis(Map<String, Object> question) {
        StringBuilder prompt = new StringBuilder();
        prompt.append("请为以下题目生成详细的解题分析。\n\n");
        
        if (question.containsKey("content")) {
            prompt.append("题目：").append(question.get("content")).append("\n");
        }
        if (question.containsKey("options")) {
            prompt.append("选项：").append(question.get("options")).append("\n");
        }
        if (question.containsKey("answer")) {
            prompt.append("答案：").append(question.get("answer")).append("\n");
        }
        if (question.containsKey("typeName")) {
            prompt.append("题型：").append(question.get("typeName")).append("\n");
        }
        
        prompt.append("\n请生成简单的解析：");
        
        return chat(prompt.toString());
    }
    
    @Override
    public String generateQuestions(Map<String, Object> params) {
        StringBuilder prompt = new StringBuilder();
        prompt.append("请根据以下要求生成试题。\n\n");
        
        if (params.containsKey("material")) {
            prompt.append("材料：").append(params.get("material")).append("\n");
        }
        if (params.containsKey("requirements")) {
            prompt.append("要求：").append(params.get("requirements")).append("\n");
        }
        if (params.containsKey("count")) {
            prompt.append("数量：").append(params.get("count")).append("道题\n");
        }
        if (params.containsKey("typeName")) {
            prompt.append("题型：").append(params.get("typeName")).append("\n");
        }
        if (params.containsKey("difficulty")) {
            prompt.append("难度：").append(params.get("difficulty")).append("\n");
        }
        
        String typeName = (String) params.get("typeName");
        prompt.append("\n请按以下JSON格式输出（只需JSON，不要其他内容）：\n");
        
        if ("单选题".equals(typeName)) {
            prompt.append("[{\"content\":\"题目内容\",\"options\":[\"A.选项1\",\"B.选项2\",\"C.选项3\",\"D.选项4\"],\"answer\":\"A\",\"analysis\":\"解析\",\"difficulty\":1}]");
            prompt.append("\n注意：answer只能是单个字母（A/B/C/D）");
        } else if ("多选题".equals(typeName)) {
            prompt.append("[{\"content\":\"题目内容\",\"options\":[\"A.选项1\",\"B.选项2\",\"C.选项3\",\"D.选项4\"],\"answer\":\"ABC\",\"analysis\":\"解析\",\"difficulty\":1}]");
            prompt.append("\n注意：answer是多个字母组合（如ABC、ABD等）");
        } else if ("判断题".equals(typeName)) {
            prompt.append("[{\"content\":\"题目内容\",\"answer\":\"正确\",\"analysis\":\"解析\",\"difficulty\":1}]");
            prompt.append("\n注意：answer只能是'正确'或'错误'");
        } else if ("简答题".equals(typeName)) {
            prompt.append("[{\"content\":\"题目内容\",\"answer\":\"标准答案内容\",\"keyPoints\":\"答题要点1；答题要点2；答题要点3\",\"analysis\":\"解析\",\"difficulty\":1,\"aiScoring\":1}]");
            prompt.append("\n注意：answer是完整的标准答案，keyPoints是答题要点（用分号分隔），aiScoring固定为1");
        } else {
            prompt.append("[{\"content\":\"题目内容\",\"options\":[\"A.选项1\",\"B.选项2\",\"C.选项3\",\"D.选项4\"],\"answer\":\"A\",\"analysis\":\"解析\",\"difficulty\":1}]");
        }
        
        return chat(prompt.toString());
    }
    
    @Override
    public String judgeAnswer(Map<String, Object> params) {
        StringBuilder prompt = new StringBuilder();
        prompt.append("请作为AI老师，对用户的简答题答案进行评分和点评。\n\n");
        
        if (params.containsKey("question")) {
            prompt.append("题目：").append(params.get("question")).append("\n");
        }
        if (params.containsKey("correctAnswer")) {
            prompt.append("正确答案：").append(params.get("correctAnswer")).append("\n");
        }
        if (params.containsKey("keyPoints")) {
            prompt.append("答题要点：").append(params.get("keyPoints")).append("\n");
        }
        if (params.containsKey("userAnswer")) {
            prompt.append("用户答案：").append(params.get("userAnswer")).append("\n");
        }
        
        prompt.append("\n请按以下格式输出评分结果：\n");
        prompt.append("得分：XX分（0-100的整数）\n\n");
        prompt.append("评价：\n");
        prompt.append("1. 答案完整度分析\n");
        prompt.append("2. 关键要点覆盖情况\n");
        prompt.append("3. 改进建议\n");
        
        return chat(prompt.toString());
    }
    
    private String getMockResponse(String prompt) {
        if (prompt.contains("解题分析") || prompt.contains("分析")) {
            return "【AI解析】\n\n" +
                   "本题考察了相关知识点的理解和应用。\n\n" +
                   "解题思路：\n" +
                   "1. 首先理解题目的关键信息\n" +
                   "2. 根据所学知识进行分析\n" +
                   "3. 结合选项进行排除和选择\n\n" +
                   "建议：多做类似题目加深理解。";
        }
        
        if (prompt.contains("生成试题")) {
            return "[{\"content\":\"这是一道示例题目\",\"options\":\"A.选项1|B.选项2|C.选项3|D.选项4\",\"answer\":\"A\",\"analysis\":\"本题考察...\"}]";
        }
        
        if (prompt.contains("评分") || prompt.contains("判题")) {
            return "【AI评分结果】\n\n" +
                   "答案完整度：85分\n\n" +
                   "要点覆盖：基本覆盖了主要答题要点\n\n" +
                   "改进建议：\n" +
                   "1. 可以进一步详细说明解题步骤\n" +
                   "2. 建议增加实例说明\n\n" +
                   "最终得分：85分\n\n" +
                   "总体表现不错，继续保持！";
        }
        
        return "AI服务模拟响应。请配置AI API密钥以使用真实AI功能。";
    }
}
