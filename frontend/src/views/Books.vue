<template>
  <div class="books-container">
    <div class="header-section">
      <h2>习题册列表</h2>
      <div class="header-controls">
        <el-radio-group v-model="filterType" size="default" @change="loadBooks">
          <el-radio-button label="all">全部</el-radio-button>
          <el-radio-button label="free">免费</el-radio-button>
          <el-radio-button label="paid">付费</el-radio-button>
        </el-radio-group>
        <el-select 
          v-model="selectedTag" 
          placeholder="选择或输入标签" 
          filterable 
          allow-create
          default-first-option
          clearable
          style="width: 150px;"
          @change="loadBooks"
          @clear="loadBooks"
        >
          <el-option label="全部标签" value="" />
          <el-option
            v-for="tag in predefinedTags"
            :key="tag"
            :label="tag"
            :value="tag"
          />
          <el-option
            v-for="tag in tagList"
            :key="tag"
            :label="tag"
            :value="tag"
          />
        </el-select>
        <el-input v-model="searchName" placeholder="搜索习题册" style="width: 200px;" clearable @clear="loadBooks" @keyup.enter="loadBooks">
          <template #append>
            <el-button icon="Search" @click="loadBooks" />
          </template>
        </el-input>
      </div>
    </div>
    
    <el-row :gutter="20" class="book-list" v-loading="loading">
      <el-col :xs="24" :sm="12" :md="8" :lg="6" v-for="book in books" :key="book.id">
        <el-card shadow="hover" class="book-card">
          <div class="book-header">
            <h4>{{ book.bookName }}</h4>
            <div class="book-tags">
              <el-tag v-if="book.tag" type="info" size="small">{{ book.tag }}</el-tag>
              <el-tag v-if="book.price && book.price > 0" type="warning" size="small">
                ¥{{ book.price }}
              </el-tag>
              <el-tag v-else type="success" size="small">免费</el-tag>
              <el-tag v-if="book.purchased" type="success" size="small">已购买</el-tag>
            </div>
          </div>
          <p class="book-desc">{{ book.bookDesc }}</p>
          <div class="book-stats">
            <span><el-icon><Document /></el-icon> {{ book.totalCount || 0 }}题</span>
            <span><el-icon><User /></el-icon> {{ book.creatorName || '未知' }}</span>
          </div>
          <div class="book-footer">
            <template v-if="!book.price || book.price === 0 || book.purchased">
              <el-button type="primary" size="default" @click="goToExercise(book)">顺序刷题</el-button>
              <el-button type="success" size="default" @click="goToRandom(book)">随机刷题</el-button>
              <el-button type="warning" size="default" @click="goToExam(book)">模拟考试</el-button>
            </template>
            <template v-else>
              <el-button type="warning" size="default" @click="handlePurchase(book)">购买习题册</el-button>
            </template>
          </div>
        </el-card>
      </el-col>
    </el-row>
    
    <div class="pagination-container" v-if="total > 0">
      <el-pagination
        v-model:current-page="currentPage"
        v-model:page-size="pageSize"
        :page-sizes="[8, 16, 24, 32]"
        :total="total"
        layout="total, sizes, prev, pager, next, jumper"
        @size-change="handleSizeChange"
        @current-change="handlePageChange"
      />
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
import { Document, User } from '@element-plus/icons-vue'
import { getBookListWithPurchasePaged, getBookDetail, purchaseBook } from '@/api/book'
import { useUserStore } from '@/store/user'
import { ElMessage } from 'element-plus'
import { predefinedTags } from '@/constants/tags'

const router = useRouter()
const userStore = useUserStore()

const searchName = ref('')
const filterType = ref('all')
const selectedTag = ref('')
const tagList = ref([])
const books = ref([])
const purchaseDialogVisible = ref(false)
const selectedBook = ref(null)
const purchasing = ref(false)
const loading = ref(false)
const currentPage = ref(1)
const pageSize = ref(8)
const total = ref(0)

onMounted(() => {
  loadBooks()
})

const loadBooks = async () => {
  try {
    loading.value = true
    const res = await getBookListWithPurchasePaged({ 
      bookName: searchName.value,
      userId: userStore.userInfo.id,
      page: currentPage.value,
      pageSize: pageSize.value
    })
    let bookList = res.data.list || []
    total.value = res.data.total || 0
    
    if (filterType.value === 'free') {
      bookList = bookList.filter(book => !book.price || book.price === 0)
    } else if (filterType.value === 'paid') {
      bookList = bookList.filter(book => book.price && book.price > 0)
    }
    
    if (selectedTag.value) {
      bookList = bookList.filter(book => book.tag === selectedTag.value)
    }
    
    books.value = bookList
    
    const tags = new Set()
    for (const book of books.value) {
      if (book.tag) {
        tags.add(book.tag)
      }
      const detail = await getBookDetail(book.id, userStore.userInfo.id)
      book.totalCount = detail.data.totalCount || 0
      book.doneCount = detail.data.doneCount || 0
      book.correctRate = detail.data.correctRate || 0
    }
    tagList.value = Array.from(tags)
  } catch (error) {
    console.error(error)
  } finally {
    loading.value = false
  }
}

const handleSizeChange = (val) => {
  pageSize.value = val
  currentPage.value = 1
  loadBooks()
}

const handlePageChange = (val) => {
  currentPage.value = val
  loadBooks()
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
.books-container {
  padding: 20px;
  max-width: 100%;
  overflow-x: hidden;
}

.header-section {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 24px;
  padding: 20px;
  background: #fff;
  border-radius: 8px;
  box-shadow: 0 2px 12px rgba(0, 0, 0, 0.08);
  
  h2 {
    font-size: 20px;
    color: #333;
    margin: 0;
  }
  
  .header-controls {
    display: flex;
    align-items: center;
    gap: 15px;
  }
  
  @media (max-width: 768px) {
    flex-direction: column;
    align-items: stretch;
    gap: 15px;
    
    h2 {
      font-size: 18px;
    }
    
    .header-controls {
      flex-direction: column;
      width: 100%;
      gap: 10px;
      
      .el-radio-group {
        width: 100%;
        display: flex;
        
        .el-radio-button {
          flex: 1;
        }
      }
      
      .el-input {
        width: 100% !important;
      }
    }
  }
}

.book-list {
  .el-col {
    margin-bottom: 20px;
  }
}

.book-card {
  height: 100%;
  transition: transform 0.3s, box-shadow 0.3s;
  
  &:hover {
    transform: translateY(-4px);
    box-shadow: 0 8px 24px rgba(0, 0, 0, 0.12);
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
    
    .book-tags {
      display: flex;
      gap: 6px;
      flex-shrink: 0;
      flex-wrap: wrap;
    }
    
    @media (max-width: 768px) {
      flex-direction: column;
      gap: 8px;
      align-items: flex-start;
      
      h4 {
        font-size: 15px;
      }
      
      .book-tags {
        width: 100%;
        justify-content: flex-start;
      }
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
    gap: 8px;
    justify-content: center;
    
    .el-button {
      flex: 1;
      font-size: 13px;
      padding: 8px 12px;
      max-width: 120px;
    }
    
    @media (max-width: 768px) {
      flex-direction: column;
      gap: 10px;
      align-items: center;
      
      .el-button {
        width: 100%;
        max-width: 100%;
        font-size: 14px;
        padding: 10px;
      }
    }
  }
}

.purchase-info {
  p {
    margin: 12px 0;
    font-size: 14px;
    color: #666;
  }
}

.pagination-container {
  display: flex;
  justify-content: center;
  margin-top: 20px;
  padding: 20px;
  background: #fff;
  border-radius: 8px;
}
</style>
