import request from '@/utils/request'

export function getErrorList(params) {
  return request.get('/error/list', { params })
}

export function deleteError(recordId) {
  return request.delete(`/error/delete/${recordId}`)
}

export function getHighErrorQuestions(userId, limit = 10) {
  return request.get('/error/high-error', { params: { userId, limit } })
}

export function getRecentRecords(userId, limit = 10) {
  return request.get('/error/recent', { params: { userId, limit } })
}
