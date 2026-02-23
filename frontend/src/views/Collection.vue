<template>
  <div class="collection-container">
    <div class="page-container">
      <div class="header-section">
        <h2>收藏夹</h2>
      </div>
      
      <div class="filter-section">
        <el-select v-model="filter.bookId" placeholder="选择习题册" clearable @change="loadCollections" style="width: 200px;">
          <el-option v-for="book in books" :key="book.id" :label="book.bookName" :value="book.id" />
        </el-select>
        <el-select v-model="filter.typeId" placeholder="选择题型" clearable @change="loadCollections" style="width: 150px;">
          <el-option v-for="type in types" :key="type.id" :label="type.typeName" :value="type.id" />
        </el-select>
      </div>
      
      <div class="collection-list" v-loading="loading">
        <el-empty v-if="collectionList.length === 0" description="暂无收藏" />
        
        <el-card v-for="col in collectionList" :key="col.id" class="collection-card">
          <div class="collection-header">
            <div class="collection-info">
              <el-tag :type="getTypeTag(col.question?.typeId)">{{ col.question?.typeName }}</el-tag>
              <span class="book-name">{{ col.question?.bookName }}</span>
            </div>
            <div class="collection-actions">
              <el-button type="primary" size="small" @click="goToExercise(col)">去刷题</el-button>
              <el-button type="warning" size="small" @click="removeCollection(col)">取消收藏</el-button>
            </div>
          </div>
          <div class="collection-content">
            <p>{{ col.question?.content }}</p>
          </div>
          <div class="collection-meta">
            <span>收藏时间: {{ col.createTime }}</span>
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
          @size-change="loadCollections"
          @current-change="loadCollections"
        />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getCollectionList, removeCollection as removeCollectionApi } from '@/api/collection'
import { getBookList } from '@/api/book'
import { getTypeList } from '@/api/type'
import { useUserStore } from '@/store/user'

const router = useRouter()
const userStore = useUserStore()

const loading = ref(false)
const collectionList = ref([])
const total = ref(0)
const pageNum = ref(1)
const pageSize = ref(10)

const books = ref([])
const types = ref([])
const filter = ref({
  bookId: null,
  typeId: null
})

onMounted(async () => {
  await Promise.all([
    loadBooks(),
    loadTypes(),
    loadCollections()
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

const loadCollections = async () => {
  loading.value = true
  try {
    const res = await getCollectionList({
      userId: userStore.userInfo.id,
      bookId: filter.value.bookId,
      typeId: filter.value.typeId,
      pageNum: pageNum.value,
      pageSize: pageSize.value
    })
    collectionList.value = res.data.list
    total.value = res.data.total
  } catch (error) {
    console.error(error)
  } finally {
    loading.value = false
  }
}

const getTypeTag = (typeId) => {
  const map = { 1: '', 2: 'success', 3: 'warning', 4: 'info' }
  return map[typeId] || ''
}

const goToExercise = (col) => {
  router.push(`/exercise/${col.question?.bookId}`)
}

const removeCollection = async (col) => {
  try {
    await ElMessageBox.confirm('确定要取消收藏吗？', '提示', { type: 'warning' })
    await removeCollectionApi(col.questionId, userStore.userInfo.id)
    ElMessage.success('已取消收藏')
    loadCollections()
  } catch (error) {
    if (error !== 'cancel') {
      console.error(error)
    }
  }
}
</script>

<style scoped lang="scss">
.collection-container {
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

.collection-list {
  min-height: 300px;
}

.collection-card {
  margin-bottom: 15px;
  
  .collection-header {
    display: flex;
    justify-content: space-between;
    align-items: center;
    margin-bottom: 12px;
    
    .collection-info {
      display: flex;
      align-items: center;
      gap: 10px;
      
      .book-name {
        color: #666;
        font-size: 14px;
      }
    }
    
    .collection-actions {
      display: flex;
      gap: 10px;
    }
  }
  
  .collection-content {
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
  
  .collection-meta {
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
</style>
