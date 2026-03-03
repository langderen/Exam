import request from '@/utils/request'

export function login(data) {
  return request.post('/user/login', data)
}

export function register(data) {
  return request.post('/user/register', data)
}

export function sendVerifyCode(data) {
  return request.post('/user/sendVerifyCode', data)
}

export function resetPasswordByEmail(data) {
  return request.post('/user/resetPassword', data)
}

export function getUserInfo(id) {
  return request.get(`/user/info/${id}`)
}

export function updateUserInfo(data) {
  return request.put('/user/info', data)
}

export function updatePassword(data) {
  return request.put('/user/password', data)
}

export function getUserList(role) {
  return request.get('/user/list', { params: { role } })
}

export function updateUserStatus(id, status) {
  return request.put(`/user/status/${id}`, null, { params: { status } })
}

export function deleteUser(id) {
  return request.delete(`/user/${id}`)
}
