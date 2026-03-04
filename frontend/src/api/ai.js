import request from '@/utils/request'

export function aiChat(prompt) {
  return request.post('/ai/chat', { prompt })
}

export function generateAnalysis(question) {
  return request.post('/ai/analysis', question)
}

export function generateQuestions(params) {
  return request.post('/ai/generate', params)
}

export function judgeAnswer(params) {
  return request.post('/ai/judge', params)
}
