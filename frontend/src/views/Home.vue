<template>
  <div class="home-container">
    <div class="welcome-section">
      <h1>欢迎使用习题册刷题系统</h1>
      <p>高效刷题，轻松备考</p>
    </div>
    
    <div class="stats-section">
      <el-row :gutter="20">
        <el-col :span="6">
          <el-card shadow="hover" class="stat-card">
            <div class="stat-icon" style="background: #409eff;">
              <el-icon size="32"><Document /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.bookCount }}</div>
              <div class="stat-label">习题册</div>
            </div>
          </el-card>
        </el-col>
        <el-col :span="6">
          <el-card shadow="hover" class="stat-card">
            <div class="stat-icon" style="background: #67c23a;">
              <el-icon size="32"><EditPen /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.questionCount }}</div>
              <div class="stat-label">题目总数</div>
            </div>
          </el-card>
        </el-col>
        <el-col :span="6">
          <el-card shadow="hover" class="stat-card">
            <div class="stat-icon" style="background: #e6a23c;">
              <el-icon size="32"><Finished /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.doneCount }}</div>
              <div class="stat-label">已做题目</div>
            </div>
          </el-card>
        </el-col>
        <el-col :span="6">
          <el-card shadow="hover" class="stat-card">
            <div class="stat-icon" style="background: #f56c6c;">
              <el-icon size="32"><Star /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.collectionCount }}</div>
              <div class="stat-label">收藏题目</div>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>
    
    <div class="books-section">
      <div class="section-header">
        <h3>热门习题册</h3>
        <el-button type="primary" text @click="$router.push('/books')">查看全部</el-button>
      </div>
      <el-row :gutter="20">
        <el-col :span="8" v-for="book in books" :key="book.id">
          <el-card shadow="hover" class="book-card" @click="goToExercise(book)">
            <h4>{{ book.bookName }}</h4>
            <p class="book-desc">{{ book.bookDesc }}</p>
            <div class="book-footer">
              <span>题目数: {{ book.totalCount || 0 }}</span>
              <el-button type="primary" size="small">开始刷题</el-button>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { getBookList, getBookDetail } from '@/api/book'
import { getCollectionList } from '@/api/collection'
import { useUserStore } from '@/store/user'

const router = useRouter()
const userStore = useUserStore()

const stats = ref({
  bookCount: 0,
  questionCount: 0,
  doneCount: 0,
  collectionCount: 0
})

const books = ref([])

onMounted(async () => {
  await loadData()
})

const loadData = async () => {
  try {
   
    let totalQuestions = 0
    let totalDone = 0
    
    const res = await getBookList()
    books.value = res.data
    stats.value.bookCount = res.data.length
    for (const book of books.value) {
      const detail = await getBookDetail(book.id, userStore.userInfo.id)
      book.totalCount = detail.data.totalCount || 0
      book.doneCount = detail.data.doneCount || 0
      book.correctRate = detail.data.correctRate || 0
    }
    
    stats.value.questionCount = totalQuestions
    stats.value.doneCount = totalDone
    
    const collectionRes = await getCollectionList({
      userId: userStore.userInfo.id,
      pageNum: 1,
      pageSize: 1
    })
    stats.value.collectionCount = collectionRes.data.total || 0
  } catch (error) {
    console.error(error)
  }
}

const goToExercise = (book) => {
  router.push(`/exercise/${book.id}`)
}
</script>

<style scoped lang="scss">
.home-container {
  max-width: 1200px;
  margin: 0 auto;
}

.welcome-section {
  text-align: center;
  padding: 40px 0;
  
  h1 {
    font-size: 32px;
    color: #333;
    margin-bottom: 10px;
  }
  
  p {
    color: #666;
    font-size: 16px;
  }
}

.stats-section {
  margin-bottom: 30px;
}

.stat-card {
  display: flex;
  align-items: center;
  padding: 20px;
  
  :deep(.el-card__body) {
    display: flex;
    align-items: center;
    width: 100%;
    padding: 20px;
  }
}

.stat-icon {
  width: 64px;
  height: 64px;
  border-radius: 12px;
  display: flex;
  justify-content: center;
  align-items: center;
  color: #fff;
  margin-right: 16px;
}

.stat-info {
  .stat-value {
    font-size: 28px;
    font-weight: bold;
    color: #333;
  }
  
  .stat-label {
    font-size: 14px;
    color: #999;
    margin-top: 4px;
  }
}

.books-section {
  .section-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 20px;
    
    h3 {
      font-size: 18px;
      color: #333;
    }
  }
}

.book-card {
  cursor: pointer;
  transition: all 0.3s;
  
  &:hover {
    transform: translateY(-4px);
  }
  
  h4 {
    font-size: 16px;
    color: #333;
    margin-bottom: 10px;
  }
  
  .book-desc {
    color: #666;
    font-size: 14px;
    line-height: 1.5;
    height: 42px;
    overflow: hidden;
    margin-bottom: 15px;
  }
  
  .book-footer {
    display: flex;
    justify-content: space-between;
    align-items: center;
    
    span {
      color: #999;
      font-size: 12px;
    }
  }
}
</style>
