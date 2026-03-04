import request from '@/utils/request'

export function getBookList(params) {
  return request.get('/book/list', { params })
}

export function getBookListWithPurchase(params) {
  return request.get('/book/listWithPurchase', { params })
}

export function getBookListWithPurchasePaged(params) {
  return request.get('/book/listWithPurchasePaged', { params })
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

export function purchaseBook(data) {
  return request.post('/purchase/buy', data)
}

export function checkPurchased(bookId, userId) {
  return request.get('/purchase/check', { params: { bookId, userId } })
}

export function getMyPurchases(userId) {
  return request.get('/purchase/my', { params: { userId } })
}

export function updateBookPrice(id, price) {
  return request.put(`/book/price/${id}`, null, { params: { price } })
}
