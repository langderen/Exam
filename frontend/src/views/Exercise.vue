<template>
  <div class="exercise-container">
    <div class="exercise-header">
      <div class="book-info">
        <h2>{{ book?.bookName }}</h2>
        <span class="progress">第 {{ currentIndex }} / {{ totalCount }} 题</span>
      </div>
      <div class="mode-switch">
        <el-radio-group v-model="mode" @change="handleModeChange">
          <el-radio-button value="sequence">顺序刷题</el-radio-button>
          <el-radio-button value="random">随机刷题</el-radio-button>
        </el-radio-group>
      </div>
    </div>
    
    <div class="exercise-content" v-if="question">
      <div class="question-section">
        <el-card class="question-card">
          <div class="question-header">
            <el-tag :type="getTypeTag(question.typeId)">{{ question.typeName }}</el-tag>
            <el-tag :type="getDifficultyTag(question.difficulty)" class="ml-10">
            {{ getDifficultyText(question.difficulty) }}
          </el-tag>
          <el-button 
            :icon="isCollected ? 'StarFilled' : 'Star'" 
            :type="isCollected ? 'warning' : 'default'"
            circle 
            @click="toggleCollection"
            class="collection-btn"
          />
        </div>
        
        <div class="question-content">
          <p>{{ question.content }}</p>
        </div>
        
        <div class="question-options">
          <template v-if="question.typeId === 1 || question.typeId === 3">
            <el-radio-group v-model="userAnswer" :disabled="submitted">
              <el-radio 
                v-for="(opt, index) in parsedOptions" 
                :key="index" 
                :value="getOptionKey(opt)"
                class="option-item"
              >
                {{ opt }}
              </el-radio>
            </el-radio-group>
          </template>
          
          <template v-else-if="question.typeId === 2">
            <el-checkbox-group v-model="userAnswers" :disabled="submitted">
              <el-checkbox 
                v-for="(opt, index) in parsedOptions" 
                :key="index" 
                :value="getOptionKey(opt)"
                class="option-item"
              >
                {{ opt }}
              </el-checkbox>
            </el-checkbox-group>
          </template>
          
          <template v-else-if="question.typeId === 4">
            <el-input 
              v-model="userAnswer" 
              type="textarea" 
              :rows="4" 
              placeholder="请输入答案"
              :disabled="submitted"
            />
          </template>
        </div>
        
        <div class="result-section" v-if="submitted">
          <el-alert 
            :title="isCorrect ? '回答正确！' : '回答错误'" 
            :type="isCorrect ? 'success' : 'error'"
            show-icon
            class="result-alert"
          />
          <div class="answer-info">
            <p><strong>正确答案：</strong>{{ question.answer }}</p>
            <p><strong>您的答案：</strong>{{ formatUserAnswer() }}</p>
          </div>
          <div class="analysis" v-if="question.analysis">
            <p><strong>解析：</strong></p>
            <p>{{ question.analysis }}</p>
          </div>
        </div>
        
        <div class="question-actions">
          <el-button @click="prevQuestion" :disabled="currentIndex <= 1 || mode === 'random'">上一题</el-button>
          <el-button 
            v-if="!submitted" 
            type="primary" 
            @click="submitAnswer"
            :loading="submitting"
          >
            提交答案
          </el-button>
          <el-button 
            v-else 
            type="success" 
            @click="nextQuestion"
          >
            下一题
          </el-button>
          <el-button 
            v-if="!submitted"
            @click="nextQuestion"
            :disabled="currentIndex >= totalCount"
          >
            下一题
          </el-button>
        </div>
      </el-card>
      </div>
      
      <div class="answer-card-sidebar">
        <AnswerCard
          mode="exam"
          :total="totalCount"
          :status-list="answerStatusList"
          :current-seq="currentIndex"
          @jump="jumpToQuestion"
        />
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { getBookDetail } from '@/api/book'
import { getSequence, getRandom, submitAnswer as submitAnswerApi, getQuestionDetail, jumpToQuestion as jumpToQuestionApi, getAnswerStatus } from '@/api/question'
import { addCollection, removeCollection } from '@/api/collection'
import { useUserStore } from '@/store/user'
import { useExerciseStore } from '@/store/exercise'
import AnswerCard from '@/components/AnswerCard.vue'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()
const exerciseStore = useExerciseStore()

const book = ref(null)
const question = ref(null)
const totalCount = ref(0)
const currentIndex = ref(1)
const mode = ref('sequence')
const userAnswer = ref('')
const userAnswers = ref([])
const submitted = ref(false)
const submitting = ref(false)
const isCorrect = ref(false)
const isCollected = ref(false)
const answerStatusList = ref([])

const parsedOptions = computed(() => {
  if (!question.value) return []
  if (question.value.typeId === 3) {
    return ['A. 正确', 'B. 错误']
  }
  if (!question.value.options) return []
  try {
    return JSON.parse(question.value.options)
  } catch {
    return []
  }
})

onMounted(async () => {
  const bookId = route.params.bookId
  mode.value = route.query.mode || 'sequence'
  
  const bookRes = await getBookDetail(bookId, userStore.userInfo.id)
  book.value = bookRes.data
  totalCount.value = bookRes.data.totalCount || 0
  
  currentIndex.value = exerciseStore.getProgress(bookId)
  
  await loadAnswerStatus()
  await loadQuestion()
})

const loadAnswerStatus = async () => {
  try {
    const bookId = route.params.bookId
    const res = await getAnswerStatus(userStore.userInfo.id, bookId)
    answerStatusList.value = res.data.statusList || []
  } catch (error) {
    console.error(error)
  }
}

const loadQuestion = async () => {
  submitted.value = false
  userAnswer.value = ''
  userAnswers.value = []
  isCorrect.value = false
  
  const bookId = route.params.bookId
  
  try {
    let res
    if (mode.value === 'random') {
      res = await getRandom(bookId, userStore.userInfo.id)
    } else {
      res = await getSequence(bookId, currentIndex.value, 1)
    }
    
    if (res.data) {
      question.value = res.data
      const colRes = await getQuestionDetail(res.data.id, userStore.userInfo.id)
      isCollected.value = colRes.data?.isCollected === 1
    }
  } catch (error) {
    console.error(error)
  }
}

const getOptionKey = (opt) => {
  const match = opt.match(/^([A-Z])\./)
  return match ? match[1] : opt
}

const getTypeTag = (typeId) => {
  const map = { 1: '', 2: 'success', 3: 'warning', 4: 'info' }
  return map[typeId] || ''
}

const getDifficultyTag = (difficulty) => {
  const map = { 1: 'success', 2: 'warning', 3: 'danger' }
  return map[difficulty] || ''
}

const getDifficultyText = (difficulty) => {
  const map = { 1: '简单', 2: '中等', 3: '困难' }
  return map[difficulty] || ''
}

const formatUserAnswer = () => {
  if (question.value?.typeId === 2) {
    return userAnswers.value.sort().join('')
  }
  return userAnswer.value || '未作答'
}

const submitAnswer = async () => {
  let answer
  if (question.value.typeId === 2) {
    answer = userAnswers.value.sort().join('')
  } else if (question.value.typeId === 3) {
    if (userAnswer.value === 'A') {
      answer = '正确'
    } else if (userAnswer.value === 'B') {
      answer = '错误'
    } else {
      answer = userAnswer.value
    }
  } else {
    answer = userAnswer.value
  }
  
  if (!answer) {
    ElMessage.warning('请先作答')
    return
  }
  
  submitting.value = true
  try {
    const res = await submitAnswerApi({
      userId: userStore.userInfo.id,
      questionId: question.value.id,
      answer
    })
    
    submitted.value = true
    isCorrect.value = res.data.isCorrect === 1
    
    await loadAnswerStatus()
  } catch (error) {
    console.error(error)
  } finally {
    submitting.value = false
  }
}

const jumpToQuestion = async (seq) => {
  try {
    currentIndex.value = seq
    exerciseStore.saveProgress(route.params.bookId, seq)
    submitted.value = false
    userAnswer.value = ''
    userAnswers.value = []
    isCorrect.value = false
    await loadQuestion()
  } catch (error) {
    console.error('jumpToQuestion error:', error)
    console.error(error)
  }
}

const prevQuestion = () => {
  if (currentIndex.value > 1) {
    currentIndex.value--
    exerciseStore.saveProgress(route.params.bookId, currentIndex.value)
    loadQuestion()
  }
}

const nextQuestion = () => {
  if (currentIndex.value < totalCount.value) {
    currentIndex.value++
    exerciseStore.saveProgress(route.params.bookId, currentIndex.value)
    loadQuestion()
  } else if (mode.value === 'random') {
    loadQuestion()
  } else {
    ElMessage.success('已完成所有题目！')
  }
}

const handleModeChange = () => {
  if (mode.value === 'random') {
    loadQuestion()
  } else {
    loadQuestion()
  }
}

const toggleCollection = async () => {
  try {
    if (isCollected.value) {
      await removeCollection(question.value.id, userStore.userInfo.id)
      isCollected.value = false
      ElMessage.success('已取消收藏')
    } else {
      await addCollection({
        userId: userStore.userInfo.id,
        questionId: question.value.id
      })
      isCollected.value = true
      ElMessage.success('收藏成功')
    }
  } catch (error) {
    console.error(error)
  }
}
</script>

<style scoped lang="scss">
.exercise-container {
  max-width: 900px;
  margin: 0 auto;
}

.exercise-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  margin-bottom: 20px;
  padding: 15px 20px;
  background: #fff;
  border-radius: 8px;
  
  .book-info {
    h2 {
      font-size: 18px;
      color: #333;
      margin: 0 0 5px 0;
    }
    
    .progress {
      color: #666;
      font-size: 14px;
    }
  }
}

.exercise-content {
  display: flex;
  gap: 20px;
}

.question-section {
  flex: 1;
}

.answer-card-sidebar {
  width: 200px;
  position: sticky;
  top: 20px;
  align-self: flex-start;
}

.question-card {
  .question-header {
    display: flex;
    align-items: center;
    margin-bottom: 20px;
    
    .collection-btn {
      margin-left: auto;
    }
  }
  
  .question-content {
    font-size: 16px;
    line-height: 1.8;
    color: #333;
    margin-bottom: 25px;
    padding: 15px;
    background: #f5f7fa;
    border-radius: 8px;
  }
  
  .question-options {
    .option-item {
      display: block;
      margin-bottom: 12px;
      padding: 12px 15px;
      background: #fff;
      border: 1px solid #dcdfe6;
      border-radius: 4px;
      transition: all 0.3s;
      
      &:hover {
        border-color: #409eff;
        background: #ecf5ff;
      }
    }
  }
  
  .result-section {
    margin-top: 25px;
    padding-top: 20px;
    border-top: 1px solid #eee;
    
    .result-alert {
      margin-bottom: 15px;
    }
    
    .answer-info {
      padding: 15px;
      background: #f5f7fa;
      border-radius: 4px;
      margin-bottom: 15px;
      
      p {
        margin: 8px 0;
        color: #333;
      }
    }
    
    .analysis {
      padding: 15px;
      background: #fdf6ec;
      border-radius: 4px;
      
      p {
        margin: 8px 0;
        color: #666;
        line-height: 1.6;
      }
    }
  }
  
  .question-actions {
    display: flex;
    justify-content: center;
    gap: 15px;
    margin-top: 25px;
    padding-top: 20px;
    border-top: 1px solid #eee;
  }
}
</style>
