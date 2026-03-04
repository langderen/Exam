package com.exercise.service.impl;

import com.exercise.dto.SubmitExamDTO;
import com.exercise.entity.ExamQuestion;
import com.exercise.entity.ExamRecord;
import com.exercise.entity.Question;
import com.exercise.mapper.ExamQuestionMapper;
import com.exercise.mapper.ExamRecordMapper;
import com.exercise.mapper.QuestionMapper;
import com.exercise.service.AIService;
import com.exercise.service.AsyncExamScoringService;
import com.exercise.service.NotificationService;
import com.exercise.vo.ExamResultVO;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Async;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.regex.Matcher;
import java.util.regex.Pattern;

@Service
public class AsyncExamScoringServiceImpl implements AsyncExamScoringService {
    
    private static final Logger logger = LoggerFactory.getLogger(AsyncExamScoringServiceImpl.class);
    
    @Autowired
    private ExamRecordMapper examRecordMapper;
    
    @Autowired
    private ExamQuestionMapper examQuestionMapper;
    
    @Autowired
    private QuestionMapper questionMapper;
    
    @Autowired
    private AIService aiService;
    
    @Autowired
    private NotificationService notificationService;
    
    @Override
    @Async
    @Transactional
    public void scoreExamAsync(Long examRecordId, SubmitExamDTO dto) {
        logger.info("开始异步判卷，考试记录ID: {}", examRecordId);
        
        try {
            List<SubmitExamDTO.QuestionRecordDTO> questionRecords = dto.getQuestionRecords();
            int totalCount = questionRecords.size();
            int correctCount = 0;
            double totalAiScore = 0;
            int aiScoredCount = 0;
            
            for (int i = 0; i < questionRecords.size(); i++) {
                SubmitExamDTO.QuestionRecordDTO recordDTO = questionRecords.get(i);
                Question question = questionMapper.selectById(recordDTO.getQuestionId());
                if (question == null) continue;
                
                boolean isCorrect = false;
                int aiScore = 0;
                String aiComment = null;
                
                if (question.getTypeId() == 4 && question.getAiScoring() != null && question.getAiScoring() == 1) {
                    logger.info("对简答题进行AI评分，题目ID: {}", question.getId());
                    
                    Map<String, Object> params = new HashMap<>();
                    params.put("question", question.getContent());
                    params.put("correctAnswer", question.getAnswer());
                    params.put("keyPoints", question.getKeyPoints());
                    params.put("userAnswer", recordDTO.getAnswer());
                    
                    try {
                        String aiResult = aiService.judgeAnswer(params);
                        aiScore = extractAiScore(aiResult);
                        aiComment = aiResult;
                        totalAiScore += aiScore;
                        aiScoredCount++;
                        isCorrect = aiScore >= 60;
                        
                        logger.info("AI评分完成，题目ID: {}, 得分: {}", question.getId(), aiScore);
                    } catch (Exception e) {
                        logger.error("AI评分失败，题目ID: {}, 错误: {}", question.getId(), e.getMessage());
                        aiScore = 0;
                        aiComment = "AI评分失败: " + e.getMessage();
                        isCorrect = false;
                    }
                    
                    examQuestionMapper.updateAiScore(examRecordId, question.getId(), isCorrect ? 1 : 0, aiScore, aiComment);
                } else {
                    isCorrect = question.getAnswer().equalsIgnoreCase(recordDTO.getAnswer());
                    examQuestionMapper.updateCorrect(examRecordId, question.getId(), isCorrect ? 1 : 0);
                }
                
                if (isCorrect) {
                    correctCount++;
                }
            }
            
            BigDecimal score = BigDecimal.ZERO;
            if (totalCount > 0) {
                if (aiScoredCount > 0) {
                    double normalScore = (correctCount - aiScoredCount) * 100.0 / totalCount;
                    double aiAvgScore = totalAiScore / aiScoredCount;
                    score = new BigDecimal(normalScore + aiAvgScore * aiScoredCount / totalCount)
                            .setScale(2, RoundingMode.HALF_UP);
                } else {
                    score = new BigDecimal(correctCount)
                            .multiply(new BigDecimal(100))
                            .divide(new BigDecimal(totalCount), 2, RoundingMode.HALF_UP);
                }
            }
            
            examRecordMapper.updateStatus(examRecordId, 1, correctCount, score);
            
            logger.info("判卷完成，考试记录ID: {}, 得分: {}", examRecordId, score);
            
            notificationService.sendNotification(
                dto.getUserId(),
                "考试判卷完成",
                "您的考试【" + dto.getExamName() + "】已完成判卷，得分：" + score + "分",
                "exam",
                examRecordId
            );
            
        } catch (Exception e) {
            logger.error("异步判卷失败，考试记录ID: {}, 错误: {}", examRecordId, e.getMessage(), e);
            
            notificationService.sendNotification(
                dto.getUserId(),
                "考试判卷失败",
                "您的考试【" + dto.getExamName() + "】判卷过程中出现错误，请联系管理员",
                "system",
                examRecordId
            );
        }
    }
    
    @Override
    public ExamResultVO getExamResult(Long examRecordId) {
        ExamRecord record = examRecordMapper.selectById(examRecordId);
        if (record == null) {
            return null;
        }
        
        List<ExamQuestion> examQuestions = examQuestionMapper.selectByExamId(examRecordId);
        
        ExamResultVO vo = new ExamResultVO();
        vo.setExamId(record.getId());
        vo.setTotalCount(record.getTotalCount());
        vo.setCorrectCount(record.getCorrectCount());
        vo.setScore(record.getScore());
        
        if (record.getStatus() == 0) {
            vo.setScoringStatus("scoring");
            return vo;
        }
        
        List<ExamResultVO.QuestionResultVO> questionResults = new java.util.ArrayList<>();
        for (ExamQuestion eq : examQuestions) {
            Question question = questionMapper.selectById(eq.getQuestionId());
            if (question == null) continue;
            
            ExamResultVO.QuestionResultVO qr = new ExamResultVO.QuestionResultVO();
            qr.setQuestionId(question.getId());
            qr.setContent(question.getContent());
            qr.setOptions(question.getOptions());
            qr.setCorrectAnswer(question.getAnswer());
            qr.setUserAnswer(eq.getUserAnswer());
            qr.setIsCorrect(eq.getIsCorrect());
            qr.setAnalysis(question.getAnalysis());
            qr.setAiScoring(question.getAiScoring());
            qr.setAiScore(eq.getAiScore());
            qr.setAiComment(eq.getAiComment());
            questionResults.add(qr);
        }
        
        vo.setQuestions(questionResults);
        vo.setScoringStatus("completed");
        return vo;
    }
    
    private int extractAiScore(String aiResult) {
        if (aiResult == null || aiResult.isEmpty()) {
            return 0;
        }
        Pattern pattern = Pattern.compile("(\\d+)\\s*分");
        Matcher matcher = pattern.matcher(aiResult);
        if (matcher.find()) {
            try {
                return Integer.parseInt(matcher.group(1));
            } catch (NumberFormatException e) {
                return 0;
            }
        }
        pattern = Pattern.compile("得分[：:]\\s*(\\d+)");
        matcher = pattern.matcher(aiResult);
        if (matcher.find()) {
            try {
                return Integer.parseInt(matcher.group(1));
            } catch (NumberFormatException e) {
                return 0;
            }
        }
        pattern = Pattern.compile("(\\d+)/100");
        matcher = pattern.matcher(aiResult);
        if (matcher.find()) {
            try {
                return Integer.parseInt(matcher.group(1));
            } catch (NumberFormatException e) {
                return 0;
            }
        }
        return 0;
    }
}
