import request from '@/utils/request'

export function generateExam(data) {
  return request.post('/exam/generate', data)
}

export function jumpToExamQuestion(examId, seq) {
  return request.get(`/exam/question/jump/${examId}/${seq}`)
}

export function saveExamAnswer(data) {
  return request.post('/exam/saveAnswer', data)
}

export function submitExam(data) {
  return request.post('/exam/submit', data)
}

export function getExamQuestions(examId) {
  return request.get(`/exam/questions/${examId}`)
}
