package com.exercise.service.impl;

import com.exercise.dto.GenerateExamDTO;
import com.exercise.dto.SubmitAnswerDTO;
import com.exercise.dto.SubmitExamDTO;
import com.exercise.entity.ExamDetail;
import com.exercise.entity.ExamRecord;
import com.exercise.entity.Question;
import com.exercise.entity.QuestionRecord;
import com.exercise.mapper.ExamDetailMapper;
import com.exercise.mapper.ExamRecordMapper;
import com.exercise.mapper.QuestionMapper;
import com.exercise.mapper.QuestionRecordMapper;
import com.exercise.service.QuestionService;
import com.exercise.vo.ExamResultVO;
import com.exercise.vo.SubmitResultVO;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import java.math.BigDecimal;
import java.math.RoundingMode;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

@Service
public class QuestionServiceImpl implements QuestionService {
    
    @Autowired
    private QuestionMapper questionMapper;
    
    @Autowired
    private QuestionRecordMapper questionRecordMapper;
    
    @Autowired
    private ExamRecordMapper examRecordMapper;
    
    @Autowired
    private ExamDetailMapper examDetailMapper;
    
    @Override
    public Question getSequence(Long bookId, Integer pageNum, Integer pageSize) {
        int offset = (pageNum - 1) * pageSize;
        return questionMapper.selectSequence(bookId, offset);
    }
    
    @Override
    public Question getRandom(Long bookId, Long userId) {
        Question question = questionMapper.selectRandom(bookId, userId);
        if (question == null) {
            question = questionMapper.selectSequence(bookId, 0);
        }
        return question;
    }
    
    @Override
    public Question jumpToQuestion(Long bookId, Integer seq) {
        int offset = seq - 1;
        return questionMapper.selectBySeq(bookId, offset);
    }
    
    @Override
    @Transactional
    public SubmitResultVO submitAnswer(SubmitAnswerDTO dto) {
        Question question = questionMapper.selectById(dto.getQuestionId());
        if (question == null) {
            throw new RuntimeException("题目不存在");
        }
        boolean isCorrect = question.getAnswer().equalsIgnoreCase(dto.getAnswer());
        
        int questionSeq = questionMapper.countByBookId(question.getBookId());
        List<Question> allQuestions = questionMapper.selectByBookId(question.getBookId());
        int seq = 0;
        for (int i = 0; i < allQuestions.size(); i++) {
            if (allQuestions.get(i).getId().equals(question.getId())) {
                seq = i + 1;
                break;
            }
        }
        
        QuestionRecord record = new QuestionRecord();
        record.setUserId(dto.getUserId());
        record.setQuestionId(dto.getQuestionId());
        record.setBookId(question.getBookId());
        record.setQuestionSeq(seq);
        record.setAnswer(dto.getAnswer());
        record.setIsCorrect(isCorrect ? 1 : 0);
        record.setIsAnswered(1);
        questionRecordMapper.insert(record);
        
        SubmitResultVO vo = new SubmitResultVO();
        vo.setIsCorrect(isCorrect ? 1 : 0);
        vo.setAnswer(question.getAnswer());
        vo.setAnalysis(question.getAnalysis());
        return vo;
    }
    
    @Override
    public List<Question> generateExam(GenerateExamDTO dto) {
        Integer count = dto.getCount();
        if (count == null || count <= 0) {
            count = 20;
        }
        return questionMapper.selectRandomByTypes(dto.getBookId(), dto.getTypeIds(), count);
    }
    
    @Override
    @Transactional
    public ExamResultVO submitExam(SubmitExamDTO dto) {
        int totalCount = dto.getQuestionRecords().size();
        int correctCount = 0;
        List<ExamResultVO.QuestionResultVO> questionResults = new ArrayList<>();
        
        ExamRecord examRecord = new ExamRecord();
        examRecord.setUserId(dto.getUserId());
        examRecord.setTotalCount(totalCount);
        examRecordMapper.insert(examRecord);
        
        List<ExamDetail> examDetails = new ArrayList<>();
        
        for (SubmitExamDTO.QuestionRecordDTO recordDTO : dto.getQuestionRecords()) {
            Question question = questionMapper.selectById(recordDTO.getQuestionId());
            if (question == null) continue;
            
            boolean isCorrect = question.getAnswer().equalsIgnoreCase(recordDTO.getAnswer());
            if (isCorrect) {
                correctCount++;
            }
            
            ExamDetail detail = new ExamDetail();
            detail.setExamId(examRecord.getId());
            detail.setQuestionId(recordDTO.getQuestionId());
            detail.setUserAnswer(recordDTO.getAnswer());
            detail.setIsCorrect(isCorrect ? 1 : 0);
            examDetails.add(detail);
            
            QuestionRecord record = new QuestionRecord();
            record.setUserId(dto.getUserId());
            record.setQuestionId(recordDTO.getQuestionId());
            record.setBookId(question.getBookId());
            record.setAnswer(recordDTO.getAnswer());
            record.setIsCorrect(isCorrect ? 1 : 0);
            questionRecordMapper.insert(record);
            
            ExamResultVO.QuestionResultVO qr = new ExamResultVO.QuestionResultVO();
            qr.setQuestionId(question.getId());
            qr.setContent(question.getContent());
            qr.setOptions(question.getOptions());
            qr.setCorrectAnswer(question.getAnswer());
            qr.setUserAnswer(recordDTO.getAnswer());
            qr.setIsCorrect(isCorrect ? 1 : 0);
            qr.setAnalysis(question.getAnalysis());
            questionResults.add(qr);
        }
        
        if (!examDetails.isEmpty()) {
            examDetailMapper.insertBatch(examDetails);
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
        
        ExamResultVO vo = new ExamResultVO();
        vo.setExamId(examRecord.getId());
        vo.setTotalCount(totalCount);
        vo.setCorrectCount(correctCount);
        vo.setScore(score);
        vo.setQuestions(questionResults);
        return vo;
    }
    
    @Override
    public Question getById(Long id) {
        return questionMapper.selectById(id);
    }
    
    @Override
    public int countByBookId(Long bookId) {
        return questionMapper.countByBookId(bookId);
    }
    
    @Override
    public Map<String, Object> getAnswerStatus(Long userId, Long bookId) {
        int totalCount = questionMapper.countByBookId(bookId);
        List<QuestionRecord> records = questionRecordMapper.selectAnswerStatusByBook(userId, bookId);
        
        Map<String, Object> result = new HashMap<>();
        result.put("totalCount", totalCount);
        result.put("statusList", records);
        return result;
    }
    
    @Override
    public QuestionRecord getUserQuestionRecord(Long userId, Long questionId) {
        return questionRecordMapper.selectByUserAndQuestion(userId, questionId);
    }
    
    @Override
    public List<Question> listByBookId(Long bookId) {
        return questionMapper.selectListByBookId(bookId);
    }
    
    @Override
    public void createQuestion(Question question) {
        questionMapper.insert(question);
    }
    
    @Override
    public void updateQuestion(Question question) {
        questionMapper.update(question);
    }
    
    @Override
    public void deleteQuestion(Long id) {
        questionMapper.deleteById(id);
    }
    
    @Override
    @Transactional
    public void batchCreate(List<Question> questions) {
        for (Question question : questions) {
            questionMapper.insert(question);
        }
    }
}
