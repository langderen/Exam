import request from '@/utils/request'

export function getErrorList(params) {
  return request.get('/error/list', { params })
}

export function deleteError(recordId) {
  return request.delete(`/error/delete/${recordId}`)
}
