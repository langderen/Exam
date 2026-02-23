import request from '@/utils/request'

export function getBookList(params) {
  return request.get('/book/list', { params })
}

export function getBookDetail(bookId, userId) {
  return request.get(`/book/detail/${bookId}`, { params: { userId } })
}

export function getMyBooks(userId) {
  return request.get('/book/my', { params: { userId } })
}

export function createBook(data) {
  return request.post('/book/create', data)
}

export function updateBook(data) {
  return request.put('/book/update', data)
}

export function updateBookStatus(id, status) {
  return request.put(`/book/status/${id}`, null, { params: { status } })
}

export function deleteBook(id) {
  return request.delete(`/book/${id}`)
}

export function getAllBooks() {
  return request.get('/book/all')
}
