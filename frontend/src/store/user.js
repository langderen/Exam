import { defineStore } from 'pinia'
import { ref } from 'vue'
import { login as loginApi } from '@/api/user'

export const useUserStore = defineStore('user', () => {
  const userInfo = ref(JSON.parse(localStorage.getItem('userInfo') || 'null'))
  const token = ref(localStorage.getItem('token') || '')

  const login = async (username, password) => {
    const res = await loginApi({ username, password })
    userInfo.value = {
      id: res.data.id,
      username: res.data.username,
      nickname: res.data.nickname,
      role: res.data.role
    }
    token.value = res.data.token
    localStorage.setItem('userInfo', JSON.stringify(userInfo.value))
    localStorage.setItem('token', res.data.token)
    return res
  }

  const logout = () => {
    userInfo.value = null
    token.value = ''
    localStorage.removeItem('userInfo')
    localStorage.removeItem('token')
  }

  return {
    userInfo,
    token,
    login,
    logout
  }
})
