import request from '@/utils/request'

export function getNotifications(userId) {
  return request.get(`/notification/list/${userId}`)
}

export function getUnreadNotifications(userId) {
  return request.get(`/notification/unread/${userId}`)
}

export function getUnreadCount(userId) {
  return request.get(`/notification/count/${userId}`)
}

export function markAsRead(id) {
  return request.put(`/notification/read/${id}`)
}

export function markAllAsRead(userId) {
  return request.put(`/notification/readAll/${userId}`)
}
