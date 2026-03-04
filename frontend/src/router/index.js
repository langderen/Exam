import { createRouter, createWebHistory } from 'vue-router'
import { useUserStore } from '@/store/user'

const routes = [
  {
    path: '/login',
    name: 'Login',
    component: () => import('@/views/Login.vue'),
    meta: { title: '登录' }
  },
  {
    path: '/',
    name: 'Layout',
    component: () => import('@/views/Layout.vue'),
    redirect: '/home',
    children: [
      {
        path: 'home',
        name: 'Home',
        component: () => import('@/views/Home.vue'),
        meta: { title: '首页' }
      },
      {
        path: 'books',
        name: 'Books',
        component: () => import('@/views/Books.vue'),
        meta: { title: '我的习题册' }
      },
      {
        path: 'exercise/:bookId',
        name: 'Exercise',
        component: () => import('@/views/Exercise.vue'),
        meta: { title: '刷题' }
      },
      {
        path: 'exam/:bookId',
        name: 'Exam',
        component: () => import('@/views/Exam.vue'),
        meta: { title: '考试' }
      },
      {
        path: 'error',
        name: 'ErrorBook',
        component: () => import('@/views/ErrorBook.vue'),
        meta: { title: '错题本' }
      },
      {
        path: 'collection',
        name: 'Collection',
        component: () => import('@/views/Collection.vue'),
        meta: { title: '收藏夹' }
      },
      {
        path: 'profile',
        name: 'Profile',
        component: () => import('@/views/Profile.vue'),
        meta: { title: '个人中心' }
      },
      {
        path: 'exam-result/:examId',
        name: 'ExamResult',
        component: () => import('@/views/ExamResult.vue'),
        meta: { title: '考试详情' }
      },
      {
        path: 'book-manage/:bookId',
        name: 'BookManage',
        component: () => import('@/views/BookManage.vue'),
        meta: { title: '习题册管理' }
      }
    ]
  }
]

const router = createRouter({
  history: createWebHistory(),
  routes
})

router.beforeEach((to, from, next) => {
  document.title = to.meta.title ? `${to.meta.title} - 习题册刷题系统` : '习题册刷题系统'
  const userStore = useUserStore()
  if (to.path !== '/login' && !userStore.userInfo) {
    next('/login')
  } else {
    next()
  }
})

export default router
