<template>
  <div class="layout-container">
    <el-container>
      <el-header class="header">
        <div class="logo">习题册刷题系统</div>
        <el-menu mode="horizontal" :default-active="activeMenu" class="nav-menu" router>
          <el-menu-item index="/home">首页</el-menu-item>
          <el-menu-item index="/books">我的习题册</el-menu-item>
          <el-menu-item index="/error">错题本</el-menu-item>
          <el-menu-item index="/collection">收藏夹</el-menu-item>
        </el-menu>
        <div class="user-info">
          <span>{{ userStore.userInfo?.nickname || userStore.userInfo?.username }}</span>
          <el-button type="text" @click="handleLogout">退出</el-button>
        </div>
      </el-header>
      <el-main class="main">
        <router-view />
      </el-main>
    </el-container>
  </div>
</template>

<script setup>
import { computed } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { useUserStore } from '@/store/user'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()

const activeMenu = computed(() => route.path)

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
}

.logo {
  font-size: 20px;
  font-weight: bold;
  color: #409eff;
  margin-right: 40px;
}

.nav-menu {
  flex: 1;
  border-bottom: none;
}

.user-info {
  display: flex;
  align-items: center;
  gap: 10px;
  
  span {
    color: #666;
  }
}

.main {
  background: #f5f7fa;
  padding: 20px;
  overflow-y: auto;
}
</style>
