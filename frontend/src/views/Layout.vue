<template>
  <div class="layout-container">
    <el-container>
      <el-header class="header">
        <div class="logo">刷题8</div>
        
        <el-menu mode="horizontal" :default-active="activeMenu" class="nav-menu" router v-show="!isMobile">
          <el-menu-item index="/home">首页</el-menu-item>
          <el-menu-item index="/books">习题册</el-menu-item>
          <el-menu-item index="/error">错题本</el-menu-item>
          <el-menu-item index="/collection">收藏夹</el-menu-item>
        </el-menu>
        
        <div class="user-info" v-show="!isMobile">
          <el-badge :value="unreadCount" :hidden="unreadCount === 0" class="notification-badge">
            <el-button :icon="Bell" circle @click="showNotifications" />
          </el-badge>
          <el-dropdown>
            <span class="user-dropdown">
              {{ userStore.userInfo?.username }}
              <el-icon><ArrowDown /></el-icon>
            </span>
            <template #dropdown>
              <el-dropdown-menu>
                <el-dropdown-item @click="goProfile">个人中心</el-dropdown-item>
                <el-dropdown-item divided @click="handleLogout">退出登录</el-dropdown-item>
              </el-dropdown-menu>
            </template>
          </el-dropdown>
        </div>
        
        <el-button class="hamburger-btn" :icon="Menu" circle @click="toggleMobileMenu" v-show="isMobile" />
      </el-header>
      
      <el-drawer v-model="mobileMenuVisible" direction="rtl" size="280px" class="mobile-menu-drawer">
        <div class="mobile-user-info" v-if="userStore.userInfo">
          <div class="mobile-user-name">{{ userStore.userInfo.username }}</div>
          <el-badge :value="unreadCount" :hidden="unreadCount === 0" class="mobile-notification-badge">
            <el-button :icon="Bell" circle @click="showNotifications" />
          </el-badge>
        </div>
        <el-menu :default-active="activeMenu" router @select="closeMobileMenu">
          <el-menu-item index="/home">首页</el-menu-item>
          <el-menu-item index="/books">习题册</el-menu-item>
          <el-menu-item index="/error">错题本</el-menu-item>
          <el-menu-item index="/collection">收藏夹</el-menu-item>
          <el-menu-item index="/profile">个人中心</el-menu-item>
          <el-menu-item divided @click="handleLogout">退出登录</el-menu-item>
        </el-menu>
      </el-drawer>
      
      <el-main class="main">
        <router-view />
        <footer class="footer">
          <div class="footer-content">
            <span>© 2026 刷题8 - 高效备考刷题平台</span>

          </div>
        </footer>
      </el-main>
    </el-container>
    
    <el-drawer v-model="notificationDrawer" title="消息通知" size="400px">
      <div class="notification-list">
        <div class="notification-actions">
          <el-button type="primary" link @click="markAllRead" :disabled="unreadCount === 0">
            全部已读
          </el-button>
        </div>
        <div v-for="notification in notifications" :key="notification.id" class="notification-item" :class="{ unread: notification.isRead === 0 }">
          <div class="notification-title">{{ notification.title }}</div>
          <div class="notification-content">{{ notification.content }}</div>
          <div class="notification-time">{{ notification.createTime }}</div>
          <div class="notification-actions" v-if="notification.type === 'exam' && notification.relatedId">
            <el-button type="primary" size="small" @click="viewExamResult(notification.relatedId)">
              查看详情
            </el-button>
          </div>
        </div>
        <el-empty v-if="notifications.length === 0" description="暂无消息" />
      </div>
    </el-drawer>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, onUnmounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useUserStore } from '@/store/user'
import { ArrowDown, Bell, Menu } from '@element-plus/icons-vue'
import { getNotifications, getUnreadCount, markAllAsRead, markAsRead } from '@/api/notification'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()

const activeMenu = computed(() => route.path)
const notificationDrawer = ref(false)
const notifications = ref([])
const unreadCount = ref(0)
const isMobile = ref(false)
const mobileMenuVisible = ref(false)

const checkMobile = () => {
  isMobile.value = window.innerWidth < 768
}

onMounted(async () => {
  await loadUnreadCount()
  checkMobile()
  window.addEventListener('resize', checkMobile)
})

onUnmounted(() => {
  window.removeEventListener('resize', checkMobile)
})

const toggleMobileMenu = () => {
  mobileMenuVisible.value = !mobileMenuVisible.value
}

const closeMobileMenu = () => {
  mobileMenuVisible.value = false
}

const loadUnreadCount = async () => {
  try {
    const res = await getUnreadCount(userStore.userInfo.id)
    unreadCount.value = res.data
  } catch (error) {
    console.error(error)
  }
}

const showNotifications = async () => {
  notificationDrawer.value = true
  await loadNotifications()
}

const loadNotifications = async () => {
  try {
    const res = await getNotifications(userStore.userInfo.id)
    notifications.value = res.data
  } catch (error) {
    console.error(error)
  }
}

const markAllRead = async () => {
  try {
    await markAllAsRead(userStore.userInfo.id)
    unreadCount.value = 0
    notifications.value.forEach(n => n.isRead = 1)
  } catch (error) {
    console.error(error)
  }
}

const viewExamResult = async (examId) => {
  const notification = notifications.value.find(n => n.relatedId === examId)
  if (notification && notification.isRead === 0) {
    await markAsRead(notification.id)
    unreadCount.value = Math.max(0, unreadCount.value - 1)
  }
  notificationDrawer.value = false
  router.push(`/exam-result/${examId}`)
}

const goProfile = () => {
  router.push('/profile')
}

const handleLogout = () => {
  userStore.logout()
  router.push('/login')
}
</script>

<style scoped lang="scss">
.layout-container {
  height: 100vh;
  
  .el-container {
    height: 100%;
  }
}

.header {
  display: flex;
  align-items: center;
  background: #fff;
  box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
  padding: 0 20px;
  z-index: 100;

  @media (max-width: 768px) {
    padding: 0 10px;
    flex-wrap: wrap;
    height: auto !important;
    min-height: 60px;
    padding: 10px;
  }
}

.logo {
  font-size: 20px;
  font-weight: bold;
  color: #409eff;
  margin-right: 40px;
  text-shadow: 2px 2px 4px rgba(0, 0, 0, 0.1);
  
  @media (max-width: 768px) {
    font-size: 18px;
    margin-right: 10px;
  }
}

.nav-menu {
  flex: 1;
  border-bottom: none;
  
  @media (max-width: 768px) {
    order: 3;
    width: 100%;
    margin-top: 10px;
    
    .el-menu-item {
      padding: 0 10px;
      font-size: 13px;
    }
  }
}

.hamburger-btn {
  margin-left: auto;
  
  @media (min-width: 769px) {
    display: none;
  }
}

.mobile-menu-drawer {
  :deep(.el-drawer__body) {
    padding: 0;
  }
  
  .mobile-user-info {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 20px;
    background: linear-gradient(135deg, #409eff 0%, #66b1ff 100%);
    color: #fff;
    
    .mobile-user-name {
      font-size: 18px;
      font-weight: 600;
    }
    
    .mobile-notification-badge {
      .el-button {
        background: rgba(255, 255, 255, 0.2);
        border-color: transparent;
        color: #fff;
        
        &:hover {
          background: rgba(255, 255, 255, 0.3);
        }
      }
      
      :deep(.el-badge__content) {
        border: none;
      }
    }
  }
  
  .el-menu {
    border-right: none;
  }
}

.user-info {
  display: flex;
  align-items: center;
  gap: 10px;
  
  @media (max-width: 768px) {
    gap: 5px;
  }
}

.user-dropdown {
  display: flex;
  align-items: center;
  gap: 5px;
  cursor: pointer;
  color: #666;
  
  &:hover {
    color: #409eff;
  }
}

.main {
  background: #f5f7fa;
  padding: 20px;
  overflow-y: auto;
  min-height: calc(100vh - 60px);
  
  @media (max-width: 768px) {
    padding: 10px;
  }
}

.footer {

  padding: 15px 20px;
  border-radius: 16px;
  margin: 20px 10px;

  
  .footer-content {
    display: flex;
    justify-content: center;
    align-items: center;
    
    a {
      color: #999;
      text-decoration: none;
      
      &:hover {
        color: #409eff;
      }
    }
    
    .divider {
      margin: 0 10px;
      color: #ddd;
    }
  }
}

.notification-badge {
  margin-right: 10px;
}

.notification-list {
  .notification-actions {
    text-align: right;
    margin-bottom: 15px;
  }
  
  .notification-item {
    padding: 15px;
    border-bottom: 1px solid #eee;
    
    &.unread {
      background: #f0f9ff;
    }
    
    .notification-title {
      font-weight: bold;
      margin-bottom: 8px;
      color: #333;
    }
    
    .notification-content {
      color: #666;
      font-size: 14px;
      line-height: 1.5;
      margin-bottom: 8px;
    }
    
    .notification-time {
      color: #999;
      font-size: 12px;
      margin-bottom: 8px;
    }
    
    .notification-actions {
      text-align: left;
      margin-bottom: 0;
    }
  }
}
</style>
