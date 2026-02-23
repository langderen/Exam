import request from '@/utils/request'

export function getQuestionTypes() {
  return request.get('/type/list')
}
