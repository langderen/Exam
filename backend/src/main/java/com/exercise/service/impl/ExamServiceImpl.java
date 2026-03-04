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
import com.exercise.service.AsyncExamScoringService;
import com.exercise.service.ExamService;
import com.exercise.vo.ExamResultVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
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
    
    @Autowired
    private AsyncExamScoringService asyncExamScoringService;
    
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
        
        ExamRecord examRecord = new ExamRecord();
        examRecord.setUserId(dto.getUserId());
        examRecord.setBookId(dto.getBookId());
        examRecord.setExamName(dto.getExamName());
        examRecord.setTotalCount(totalCount);
        examRecord.setCorrectCount(0);
        examRecord.setScore(BigDecimal.ZERO);
        examRecord.setStartTime(LocalDateTime.now());
        examRecord.setStatus(0);
        examRecordMapper.insert(examRecord);
        
        List<ExamQuestion> examQuestions = new ArrayList<>();
        for (int i = 0; i < questionRecords.size(); i++) {
            SubmitExamDTO.QuestionRecordDTO recordDTO = questionRecords.get(i);
            
            ExamQuestion eq = new ExamQuestion();
            eq.setExamId(examRecord.getId());
            eq.setQuestionId(recordDTO.getQuestionId());
            eq.setQuestionSeq(i + 1);
            eq.setUserAnswer(recordDTO.getAnswer());
            eq.setIsCorrect(0);
            eq.setIsAnswered(1);
            examQuestions.add(eq);
        }
        
        if (!examQuestions.isEmpty()) {
            examQuestionMapper.insertBatch(examQuestions);
        }
        
        asyncExamScoringService.scoreExamAsync(examRecord.getId(), dto);
        
        ExamResultVO vo = new ExamResultVO();
        vo.setExamId(examRecord.getId());
        vo.setTotalCount(totalCount);
        vo.setCorrectCount(0);
        vo.setScore(BigDecimal.ZERO);
        vo.setScoringStatus("scoring");
        return vo;
    }
    
    @Override
    public List<ExamQuestion> getExamQuestions(Long examId) {
        return examQuestionMapper.selectByExamId(examId);
    }
    
    @Override
    public ExamResultVO getExamResult(Long examId) {
        return asyncExamScoringService.getExamResult(examId);
    }
    
    @Override
    public List<ExamRecord> getUserExamRecords(Long userId) {
        return examRecordMapper.selectByUserId(userId);
    }
}
