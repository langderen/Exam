package com.exercise.service.impl;

import com.exercise.dto.GenerateExamDTO;
import com.exercise.dto.SaveAnswerDTO;
import com.exercise.dto.SubmitExamDTO;
import com.exercise.entity.ExamQuestion;
import com.exercise.entity.ExamRecord;
import com.exercise.entity.Question;
import com.exercise.mapper.ExamQuestionMapper;
import com.exercise.mapper.ExamRecordMapper;
import com.exercise.mapper.QuestionMapper;
import com.exercise.service.ExamService;
import com.exercise.vo.ExamResultVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class ExamServiceImpl implements ExamService {
    
    @Autowired
    private ExamRecordMapper examRecordMapper;
    
    @Autowired
    private ExamQuestionMapper examQuestionMapper;
    
    @Autowired
    private QuestionMapper questionMapper;
    
    @Override
    @Transactional
    public Map<String, Object> generateExam(GenerateExamDTO dto) {
        Integer count = dto.getCount();
        if (count == null || count <= 0) {
            count = 20;
        }
        
        List<Question> questions = questionMapper.selectRandomByTypes(dto.getBookId(), dto.getTypeIds(), count);
        
        Map<String, Object> result = new HashMap<>();
        result.put("examId", null);
        result.put("questions", questions);
        result.put("examQuestions", new ArrayList<>());
        return result;
    }
    
    @Override
    public Question jumpToQuestion(Long examId, Integer seq) {
        ExamQuestion examQuestion = examQuestionMapper.selectByExamId(examId).stream()
                .filter(eq -> eq.getQuestionSeq().equals(seq))
                .findFirst()
                .orElse(null);
        
        if (examQuestion == null) {
            return null;
        }
        
        return questionMapper.selectById(examQuestion.getQuestionId());
    }
    
    @Override
    @Transactional
    public Map<String, Object> saveAnswer(SaveAnswerDTO dto) {
        return new HashMap<>();
    }
    
    @Override
    @Transactional
    public ExamResultVO submitExam(SubmitExamDTO dto) {
        List<SubmitExamDTO.QuestionRecordDTO> questionRecords = dto.getQuestionRecords();
        int totalCount = questionRecords.size();
        int correctCount = 0;
        
        ExamRecord examRecord = new ExamRecord();
        examRecord.setUserId(dto.getUserId());
        examRecord.setBookId(dto.getBookId());
        examRecord.setExamName(dto.getExamName());
        examRecord.setTotalCount(totalCount);
        examRecord.setCorrectCount(0);
        examRecord.setScore(BigDecimal.ZERO);
        examRecord.setStartTime(LocalDateTime.now());
        examRecord.setEndTime(LocalDateTime.now());
        examRecord.setStatus(1);
        examRecordMapper.insert(examRecord);
        
        List<ExamQuestion> examQuestions = new ArrayList<>();
        for (int i = 0; i < questionRecords.size(); i++) {
            SubmitExamDTO.QuestionRecordDTO recordDTO = questionRecords.get(i);
            Question question = questionMapper.selectById(recordDTO.getQuestionId());
            if (question == null) continue;
            
            boolean isCorrect = question.getAnswer().equalsIgnoreCase(recordDTO.getAnswer());
            if (isCorrect) {
                correctCount++;
            }
            
            ExamQuestion eq = new ExamQuestion();
            eq.setExamId(examRecord.getId());
            eq.setQuestionId(question.getId());
            eq.setQuestionSeq(i + 1);
            eq.setUserAnswer(recordDTO.getAnswer());
            eq.setIsCorrect(isCorrect ? 1 : 0);
            eq.setIsAnswered(1);
            examQuestions.add(eq);
        }
        
        if (!examQuestions.isEmpty()) {
            examQuestionMapper.insertBatch(examQuestions);
        }
        
        BigDecimal score = BigDecimal.ZERO;
        if (totalCount > 0) {
            score = new BigDecimal(correctCount)
                    .multiply(new BigDecimal(100))
                    .divide(new BigDecimal(totalCount), 2, RoundingMode.HALF_UP);
        }
        
        examRecord.setCorrectCount(correctCount);
        examRecord.setScore(score);
        examRecordMapper.update(examRecord);
        
        List<ExamResultVO.QuestionResultVO> questionResults = new ArrayList<>();
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
            questionResults.add(qr);
        }
        
        ExamResultVO vo = new ExamResultVO();
        vo.setExamId(examRecord.getId());
        vo.setTotalCount(totalCount);
        vo.setCorrectCount(correctCount);
        vo.setScore(score);
        vo.setQuestions(questionResults);
        return vo;
    }
    
    @Override
    public List<ExamQuestion> getExamQuestions(Long examId) {
        return examQuestionMapper.selectByExamId(examId);
    }
    
    @Override
    public List<ExamRecord> getUserExamRecords(Long userId) {
        return examRecordMapper.selectByUserId(userId);
    }
}
