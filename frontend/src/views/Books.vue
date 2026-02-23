<template>
  <div class="books-container">
    <div class="page-container">
      <div class="header-section">
        <h2>我的习题册</h2>
        <el-input v-model="searchName" placeholder="搜索习题册" style="width: 200px;" clearable @clear="loadBooks" @keyup.enter="loadBooks">
          <template #append>
            <el-button icon="Search" @click="loadBooks" />
          </template>
        </el-input>
      </div>
      
      <el-row :gutter="20" class="book-list">
        <el-col :span="8" v-for="book in books" :key="book.id">
          <el-card shadow="hover" class="book-card">
            <div class="book-header">
              <h3>{{ book.bookName }}</h3>
              <el-tag :type="book.status === 1 ? 'success' : 'info'" size="small">
                {{ book.status === 1 ? '启用' : '禁用' }}
              </el-tag>
            </div>
            <p class="book-desc">{{ book.bookDesc }}</p>
            <div class="book-stats">
              <span>题目: {{ book.totalCount || 0 }}</span>
              <span>已做: {{ book.doneCount || 0 }}</span>
              <span>正确率: {{ book.correctRate || 0 }}%</span>
            </div>
            <div class="book-actions">
              <el-button type="primary" @click="goToExercise(book)">顺序刷题</el-button>
              <el-button type="success" @click="goToRandom(book)">随机刷题</el-button>
              <el-button type="warning" @click="goToExam(book)">开始考试</el-button>
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
import { useUserStore } from '@/store/user'

const router = useRouter()
const userStore = useUserStore()

const searchName = ref('')
const books = ref([])

onMounted(() => {
  loadBooks()
})

const loadBooks = async () => {
  try {
    const res = await getBookList({ bookName: searchName.value })
    books.value = res.data
    
    for (const book of books.value) {
      const detail = await getBookDetail(book.id, userStore.userInfo.id)
      book.totalCount = detail.data.totalCount || 0
      book.doneCount = detail.data.doneCount || 0
      book.correctRate = detail.data.correctRate || 0
    }
  } catch (error) {
    console.error(error)
  }
}

const goToExercise = (book) => {
  router.push(`/exercise/${book.id}`)
}

const goToRandom = (book) => {
  router.push({ path: `/exercise/${book.id}`, query: { mode: 'random' } })
}

const goToExam = (book) => {
  router.push(`/exam/${book.id}`)
}
</script>

<style scoped lang="scss">
.books-container {
  .page-container {
    background: #fff;
    border-radius: 8px;
    padding: 20px;
  }
}

.header-section {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  
  h2 {
    font-size: 20px;
    color: #333;
  }
}

.book-list {
  .el-col {
    margin-bottom: 20px;
  }
}

.book-card {
  .book-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 12px;
    
    h3 {
      font-size: 16px;
      color: #333;
      margin: 0;
    }
  }
  
  .book-desc {
    color: #666;
    font-size: 14px;
    line-height: 1.5;
    height: 42px;
    overflow: hidden;
    margin-bottom: 12px;
  }
  
  .book-stats {
    display: flex;
    gap: 15px;
    margin-bottom: 15px;
    padding: 10px;
    background: #f5f7fa;
    border-radius: 4px;
    
    span {
      font-size: 12px;
      color: #666;
    }
  }
  
  .book-actions {
    display: flex;
    gap: 10px;
    
    .el-button {
      flex: 1;
    }
  }
}
</style>
