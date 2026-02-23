import request from '@/utils/request'

export function getSequence(bookId, pageNum = 1, pageSize = 1) {
  return request.get(`/question/sequence/${bookId}`, { params: { pageNum, pageSize } })
}

export function getRandom(bookId, userId) {
  return request.get(`/question/random/${bookId}`, { params: { userId } })
}

export function jumpToQuestion(bookId, seq) {
  return request.get(`/question/jump/${bookId}/${seq}`)
}

export function getAnswerStatus(userId, bookId) {
  return request.get(`/question/answerStatus/${userId}/${bookId}`)
}

export function submitAnswer(data) {
  return request.post('/question/submit', data)
}

export function getQuestionDetail(id, userId) {
  return request.get(`/question/detail/${id}`, { params: { userId } })
}
