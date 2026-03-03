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
              <el-icon size="32"><User /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.userCount }}</div>
              <div class="stat-label">用户总数</div>
            </div>
          </el-card>
        </el-col>
        <el-col :span="6">
          <el-card shadow="hover" class="stat-card">
            <div class="stat-icon" style="background: #67c23a;">
              <el-icon size="32"><Document /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.bookCount }}</div>
              <div class="stat-label">习题册总数</div>
            </div>
          </el-card>
        </el-col>
        <el-col :span="6">
          <el-card shadow="hover" class="stat-card">
            <div class="stat-icon" style="background: #e6a23c;">
              <el-icon size="32"><TrendCharts /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.examCount }}</div>
              <div class="stat-label">考试次数</div>
            </div>
          </el-card>
        </el-col>
        <el-col :span="6">
          <el-card shadow="hover" class="stat-card">
            <div class="stat-icon" style="background: #f56c6c;">
              <el-icon size="32"><Trophy /></el-icon>
            </div>
            <div class="stat-info">
              <div class="stat-value">{{ stats.avgScore }}分</div>
              <div class="stat-label">平均得分</div>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>
    
    <div class="books-section">
      <div class="section-header">
        <h3>推荐习题册</h3>
        <el-button type="primary" text @click="$router.push('/books')">查看全部</el-button>
      </div>
      <el-row :gutter="20">
        <el-col :span="8" v-for="book in books" :key="book.id">
          <el-card shadow="hover" class="book-card">
            <div class="book-header">
              <h4>{{ book.bookName }}</h4>
              <div class="book-tags">
                <el-tag v-if="book.tag" type="info" size="small">{{ book.tag }}</el-tag>
                <el-tag v-if="book.price && book.price > 0" type="warning" size="small">
                  ¥{{ book.price }}
                </el-tag>
                <el-tag v-else type="success" size="small">免费</el-tag>
              </div>
            </div>
            <p class="book-desc">{{ book.bookDesc }}</p>
            <div class="book-stats">
              <span><el-icon><Document /></el-icon> {{ book.totalCount || 0 }}题</span>
              <span><el-icon><User /></el-icon> {{ book.creatorName || '未知' }}</span>
            </div>
            <div class="book-footer">
              <el-button 
                v-if="!book.price || book.price === 0 || book.purchased" 
                type="primary" 
                size="default"
                @click="goToExercise(book)"
              >
                开始刷题
              </el-button>
              <el-button 
                v-else 
                type="warning" 
                size="default"
                @click="handlePurchase(book)"
              >
                购买
              </el-button>
            </div>
          </el-card>
        </el-col>
      </el-row>
    </div>
    
    <el-dialog v-model="purchaseDialogVisible" title="购买习题册" width="400px">
      <div class="purchase-info" v-if="selectedBook">
        <p><strong>习题册名称：</strong>{{ selectedBook.bookName }}</p>
        <p><strong>价格：</strong>¥{{ selectedBook.price }}</p>
      </div>
      <template #footer>
        <el-button @click="purchaseDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="confirmPurchase" :loading="purchasing">确认购买</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { getBookListWithPurchase, getBookDetail, purchaseBook } from '@/api/book'
import { getCollectionList } from '@/api/collection'
import { getUserExamRecords } from '@/api/exam'
import { useUserStore } from '@/store/user'
import { ElMessage } from 'element-plus'

const router = useRouter()
const userStore = useUserStore()

const stats = ref({
  userCount: 0,
  bookCount: 0,
  examCount: 0,
  avgScore: 0
})

const books = ref([])
const purchaseDialogVisible = ref(false)
const selectedBook = ref(null)
const purchasing = ref(false)

onMounted(async () => {
  await loadData()
})

const loadData = async () => {
  try {
    let totalQuestions = 0
    let totalDone = 0
    let totalExams = 0
    let totalScore = 0
    
    const res = await getBookListWithPurchase({ userId: userStore.userInfo.id })
    books.value = res.data
    stats.value.bookCount = res.data.length
    
    for (const book of books.value) {
      const detail = await getBookDetail(book.id, userStore.userInfo.id)
      book.totalCount = detail.data.totalCount || 0
      book.doneCount = detail.data.doneCount || 0
      book.correctRate = detail.data.correctRate || 0
      
      totalQuestions += (detail.data.totalCount || 0)
      totalDone += (detail.data.doneCount || 0)
    }
    
    stats.value.questionCount = totalQuestions
    stats.value.doneCount = totalDone
    
    const collectionRes = await getCollectionList({
      userId: userStore.userInfo.id,
      pageNum: 1,
      pageSize: 1
    })
    stats.value.collectionCount = collectionRes.data.total || 0
    
    const examRes = await getUserExamRecords(userStore.userInfo.id)
    if (examRes.data && examRes.data.length > 0) {
      stats.value.examCount = examRes.data.length
      const scores = examRes.data.map(exam => exam.score || 0).filter(score => score > 0)
      totalScore = scores.reduce((sum, score) => sum + score, 0)
      stats.value.avgScore = scores.length > 0 ? (totalScore / scores.length).toFixed(1) : 0
    }
    
    stats.value.userCount = 100
  } catch (error) {
    console.error(error)
  }
}

const goToExercise = (book) => {
  if (book.price && book.price > 0 && !book.purchased) {
    handlePurchase(book)
    return
  }
  router.push(`/exercise/${book.id}`)
}

const handlePurchase = (book) => {
  selectedBook.value = book
  purchaseDialogVisible.value = true
}

const confirmPurchase = async () => {
  if (!selectedBook.value) return
  
  try {
    purchasing.value = true
    await purchaseBook({
      bookId: selectedBook.value.id,
      userId: userStore.userInfo.id
    })
    ElMessage.success('购买成功')
    purchaseDialogVisible.value = false
    selectedBook.value.purchased = true
  } catch (error) {
    ElMessage.error(error.response?.data?.message || '购买失败')
  } finally {
    purchasing.value = false
  }
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
  
  .book-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 10px;
    
    h4 {
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
    margin-bottom: 15px;
  }
  
  .book-stats {
    display: flex;
    gap: 15px;
    color: #999;
    font-size: 12px;
    margin-bottom: 15px;
    
    span {
      display: flex;
      align-items: center;
      gap: 4px;
    }
  }
  
  .book-footer {
    display: flex;
    justify-content: space-between;
    align-items: center;
    
    span {
      color: #999;
      font-size: 12px;
    }
    
    .book-actions {
      display: flex;
      gap: 8px;
    }
  }
}

.purchase-info {
  p {
    margin: 10px 0;
    font-size: 14px;
  }
}
</style>
