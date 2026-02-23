import request from '@/utils/request'

export function addCollection(data) {
  return request.post('/collection/add', data)
}

export function removeCollection(questionId, userId) {
  return request.delete(`/collection/remove/${questionId}`, { params: { userId } })
}

export function getCollectionList(params) {
  return request.get('/collection/list', { params })
}
