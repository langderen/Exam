import request from '@/utils/request'

export function login(data) {
  return request.post('/user/login', data)
}

export function getUserInfo(id) {
  return request.get(`/user/info/${id}`)
}
