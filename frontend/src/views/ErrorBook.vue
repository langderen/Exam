<template>
  <div class="error-container">
    <div class="page-container">
      <div class="header-section">
        <h2>错题本</h2>
      </div>
      
      <div class="filter-section">
        <el-select v-model="filter.bookId" placeholder="选择习题册" clearable @change="loadErrors" style="width: 200px;">
          <el-option v-for="book in books" :key="book.id" :label="book.bookName" :value="book.id" />
        </el-select>
        <el-select v-model="filter.typeId" placeholder="选择题型" clearable @change="loadErrors" style="width: 150px;">
          <el-option v-for="type in types" :key="type.id" :label="type.typeName" :value="type.id" />
        </el-select>
      </div>
      
      <div class="error-list" v-loading="loading">
        <el-empty v-if="errorList.length === 0" description="暂无错题" />
        
        <el-card v-for="record in errorList" :key="record.id" class="error-card">
          <div class="error-header">
            <div class="error-info">
              <el-tag :type="getTypeTag(record.question?.typeId)">{{ record.question?.typeName }}</el-tag>
              <span class="book-name">{{ record.question?.bookName }}</span>
            </div>
            <div class="error-actions">
              <el-button type="primary" size="small" @click="showDetail(record)">查看详情</el-button>
              <el-button type="danger" size="small" @click="removeError(record)">移除</el-button>
            </div>
          </div>
          <div class="error-content">
            <p>{{ record.question?.content }}</p>
          </div>
          <div class="error-meta">
            <span>作答时间: {{ record.doTime }}</span>
            <span>您的答案: {{ record.answer }}</span>
          </div>
        </el-card>
      </div>
      
      <div class="pagination-section" v-if="total > 0">
        <el-pagination 
          v-model:current-page="pageNum" 
          v-model:page-size="pageSize"
          :total="total"
          :page-sizes="[10, 20, 50]"
          layout="total, sizes, prev, pager, next"
          @size-change="loadErrors"
          @current-change="loadErrors"
        />
      </div>
    </div>
    
    <el-dialog v-model="detailVisible" title="题目详情" width="600px">
      <div class="detail-content" v-if="currentRecord">
        <p class="question-text">{{ currentRecord.question?.content }}</p>
        <div class="options" v-if="currentRecord.question?.options">
          <p v-for="opt in parseOptions(currentRecord.question?.options)" :key="opt" class="option">{{ opt }}</p>
        </div>
        <div class="answer-section">
          <p><strong>正确答案:</strong> {{ currentRecord.question?.answer }}</p>
          <p><strong>您的答案:</strong> {{ currentRecord.answer }}</p>
        </div>
        <div class="analysis" v-if="currentRecord.question?.analysis">
          <p><strong>解析:</strong></p>
          <p>{{ currentRecord.question?.analysis }}</p>
        </div>
      </div>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getErrorList, deleteError } from '@/api/error'
import { getBookList } from '@/api/book'
import { getTypeList } from '@/api/type'
import { useUserStore } from '@/store/user'

const userStore = useUserStore()

const loading = ref(false)
const errorList = ref([])
const total = ref(0)
const pageNum = ref(1)
const pageSize = ref(10)

const books = ref([])
const types = ref([])
const filter = ref({
  bookId: null,
  typeId: null
})

const detailVisible = ref(false)
const currentRecord = ref(null)

onMounted(async () => {
  await Promise.all([
    loadBooks(),
    loadTypes(),
    loadErrors()
  ])
})

const loadBooks = async () => {
  const res = await getBookList({})
  books.value = res.data
}

const loadTypes = async () => {
  const res = await getTypeList()
  types.value = res.data
}

const loadErrors = async () => {
  loading.value = true
  try {
    const res = await getErrorList({
      userId: userStore.userInfo.id,
      bookId: filter.value.bookId,
      typeId: filter.value.typeId,
      pageNum: pageNum.value,
      pageSize: pageSize.value
    })
    errorList.value = res.data.list
    total.value = res.data.total
  } catch (error) {
    console.error(error)
  } finally {
    loading.value = false
  }
}

const parseOptions = (options) => {
  try {
    return JSON.parse(options)
  } catch {
    return []
  }
}

const getTypeTag = (typeId) => {
  const map = { 1: '', 2: 'success', 3: 'warning', 4: 'info' }
  return map[typeId] || ''
}

const showDetail = (record) => {
  currentRecord.value = record
  detailVisible.value = true
}

const removeError = async (record) => {
  try {
    await ElMessageBox.confirm('确定要移除这条错题记录吗？', '提示', { type: 'warning' })
    await deleteError(record.id)
    ElMessage.success('移除成功')
    loadErrors()
  } catch (error) {
    if (error !== 'cancel') {
      console.error(error)
    }
  }
}
</script>

<style scoped lang="scss">
.error-container {
  .page-container {
    background: #fff;
    border-radius: 8px;
    padding: 20px;
  }
}

.header-section {
  margin-bottom: 20px;
  
  h2 {
    font-size: 20px;
    color: #333;
  }
}

.filter-section {
  display: flex;
  gap: 15px;
  margin-bottom: 20px;
}

.error-list {
  min-height: 300px;
}

.error-card {
  margin-bottom: 15px;
  
  .error-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 12px;
    
    .error-info {
      display: flex;
      align-items: center;
      gap: 10px;
      
      .book-name {
        color: #666;
        font-size: 14px;
      }
    }
    
    .error-actions {
      display: flex;
      gap: 10px;
    }
  }
  
  .error-content {
    padding: 12px;
    background: #f5f7fa;
    border-radius: 4px;
    margin-bottom: 12px;
    
    p {
      color: #333;
      line-height: 1.6;
      margin: 0;
    }
  }
  
  .error-meta {
    display: flex;
    gap: 20px;
    
    span {
      color: #999;
      font-size: 12px;
    }
  }
}

.pagination-section {
  display: flex;
  justify-content: center;
  margin-top: 20px;
}

.detail-content {
  .question-text {
    font-size: 16px;
    line-height: 1.6;
    color: #333;
    margin-bottom: 15px;
  }
  
  .options {
    margin-bottom: 15px;
    
    .option {
      padding: 8px 12px;
      background: #f5f7fa;
      border-radius: 4px;
      margin-bottom: 8px;
      color: #666;
    }
  }
  
  .answer-section {
    padding: 12px;
    background: #ecf5ff;
    border-radius: 4px;
    margin-bottom: 15px;
    
    p {
      margin: 5px 0;
      color: #333;
    }
  }
  
  .analysis {
    padding: 12px;
    background: #fdf6ec;
    border-radius: 4px;
    
    p {
      margin: 5px 0;
      color: #666;
      line-height: 1.6;
    }
  }
}
</style>
