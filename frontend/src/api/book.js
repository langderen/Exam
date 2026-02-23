import request from '@/utils/request'

export function getBookList(params) {
  return request.get('/book/list', { params })
}

export function getBookDetail(bookId, userId) {
  return request.get(`/book/detail/${bookId}`, { params: { userId } })
}
