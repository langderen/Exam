import request from '@/utils/request'

export function getWallet(userId) {
  return request.get('/wallet/info', { params: { userId } })
}

export function recharge(data) {
  return request.post('/wallet/recharge', data)
}

export function getTransactions(userId) {
  return request.get('/wallet/transactions', { params: { userId } })
}

export function checkBalance(userId, amount) {
  return request.get('/wallet/checkBalance', { params: { userId, amount } })
}
