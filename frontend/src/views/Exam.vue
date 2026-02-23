<template>
  <div class="exam-container">
    <div class="exam-header" v-if="!examStarted">
      <h2>{{ book?.bookName }} - 考试模式</h2>
    </div>
    
    <div class="config-section" v-if="!examStarted">
      <el-card>
        <h3>考试配置</h3>
        <el-form :model="examConfig" label-width="100px">
          <el-form-item label="选择题型">
            <el-checkbox-group v-model="examConfig.typeIds">
              <el-checkbox v-for="type in types" :key="type.id" :value="type.id">
                {{ type.typeName }}
              </el-checkbox>
            </el-checkbox-group>
          </el-form-item>
          <el-form-item label="题目数量">
            <el-input-number v-model="examConfig.count" :min="1" :max="50" />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" size="large" @click="startExam" :loading="loading">
              生成试卷
            </el-button>
          </el-form-item>
        </el-form>
      </el-card>
    </div>
    
    <div class="exam-section" v-if="examStarted && !examSubmitted">
      <div class="exam-info">
        <span>共 {{ questions.length }} 题</span>
        <span>已答 {{ answeredCount }} 题</span>
        <el-button type="primary" @click="submitExam" :loading="submitting">提交试卷</el-button>
      </div>
      
      <div class="exam-content">
        <div class="questions-list">
          <el-card v-for="(q, index) in questions" :key="q.id" class="question-card">
            <div class="question-header">
              <span class="question-num">第 {{ index + 1 }} 题</span>
              <el-tag :type="getTypeTag(q.typeId)">{{ q.typeName }}</el-tag>
            </div>
            <p class="question-content">{{ q.content }}</p>
            
            <template v-if="q.typeId === 1 || q.typeId === 3">
              <el-radio-group v-model="answers[q.id]" @change="saveCurrentAnswer(q.id)">
                <el-radio 
                  v-for="opt in parseOptions(q.options, q.typeId)" 
                  :key="opt" 
                  :value="getOptionKey(opt)"
                  class="option-item"
                >
                  {{ opt }}
                </el-radio>
              </el-radio-group>
            </template>
            
            <template v-else-if="q.typeId === 2">
              <el-checkbox-group v-model="multiAnswers[q.id]" @change="saveCurrentAnswer(q.id)">
                <el-checkbox 
                  v-for="opt in parseOptions(q.options, q.typeId)" 
                  :key="opt" 
                  :value="getOptionKey(opt)"
                  class="option-item"
                >
                  {{ opt }}
                </el-checkbox>
              </el-checkbox-group>
            </template>
            
            <template v-else-if="q.typeId === 4">
              <el-input v-model="answers[q.id]" type="textarea" :rows="3" placeholder="请输入答案" @blur="saveCurrentAnswer(q.id)" />
            </template>
          </el-card>
        </div>
        
        <div class="answer-card-sidebar">
          <AnswerCard
            mode="exam"
            :total="questions.length"
            :status-list="answerStatusList"
            :current-seq="currentSeq"
            @jump="jumpToQuestion"
          />
        </div>
      </div>
    </div>
    
    <div class="result-section" v-if="examSubmitted">
      <el-card class="result-card">
        <h2>考试结果</h2>
        <div class="score-info">
          <div class="score">{{ examResult.score }}分</div>
          <div class="stats">
            <p>总题数: {{ examResult.totalCount }}</p>
            <p>正确数: {{ examResult.correctCount }}</p>
            <p>正确率: {{ examResult.totalCount > 0 ? (examResult.correctCount / examResult.totalCount * 100).toFixed(1) : 0 }}%</p>
          </div>
        </div>
        <el-button type="primary" @click="resetExam">重新考试</el-button>
        <el-button @click="$router.push('/books')">返回习题册</el-button>
      </el-card>
      
      <div class="detail-section">
        <h3>答题详情</h3>
        <el-card v-for="(q, index) in examResult.questions" :key="q.questionId" class="detail-card">
          <div class="detail-header">
            <span class="question-num">第 {{ index + 1 }} 题</span>
            <el-tag :type="q.isCorrect ? 'success' : 'danger'">
              {{ q.isCorrect ? '正确' : '错误' }}
            </el-tag>
          </div>
          <p class="question-content">{{ q.content }}</p>
          <div class="answer-compare">
            <p><strong>正确答案:</strong> {{ q.correctAnswer }}</p>
            <p><strong>您的答案:</strong> {{ q.userAnswer || '未作答' }}</p>
          </div>
          <div class="analysis" v-if="q.analysis">
            <p><strong>解析:</strong> {{ q.analysis }}</p>
          </div>
        </el-card>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, computed, onMounted, watch } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getBookDetail } from '@/api/book'
import { generateExam, submitExam as submitExamApi, jumpToExamQuestion, saveExamAnswer, getExamQuestions } from '@/api/exam'
import { getTypeList } from '@/api/type'
import { useUserStore } from '@/store/user'
import AnswerCard from '@/components/AnswerCard.vue'

const route = useRoute()
const router = useRouter()
const userStore = useUserStore()

const book = ref(null)
const types = ref([])
const loading = ref(false)
const submitting = ref(false)
const examStarted = ref(false)
const examSubmitted = ref(false)
const examId = ref(null)
const currentSeq = ref(1)
const answerStatusList = ref([])

const examConfig = ref({
  typeIds: [],
  count: 20
})

const questions = ref([])
const answers = ref({})
const multiAnswers = ref({})
const examResult = ref({})

const answeredCount = computed(() => {
  let count = 0
  questions.value.forEach(q => {
    if (q.typeId === 2) {
      if (multiAnswers.value[q.id]?.length > 0) count++
    } else {
      if (answers.value[q.id]) count++
    }
  })
  return count
})

onMounted(async () => {
  const bookId = route.params.bookId
  const bookRes = await getBookDetail(bookId, userStore.userInfo.id)
  book.value = bookRes.data
  
  const typeRes = await getTypeList()
  types.value = typeRes.data
  examConfig.value.typeIds = typeRes.data.map(t => t.id)
})

const parseOptions = (options, typeId) => {
  if (typeId === 3) {
    return ['A. 正确', 'B. 错误']
  }
  try {
    return JSON.parse(options)
  } catch {
    return []
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

const startExam = async () => {
  if (examConfig.value.typeIds.length === 0) {
    ElMessage.warning('请至少选择一种题型')
    return
  }
  
  loading.value = true
  try {
    const res = await generateExam({
      userId: userStore.userInfo.id,
      bookId: route.params.bookId,
      typeIds: examConfig.value.typeIds,
      count: examConfig.value.count
    })
    
    examId.value = res.data.examId
    questions.value = res.data.questions
    answerStatusList.value = res.data.examQuestions
    answers.value = {}
    multiAnswers.value = {}
    currentSeq.value = 1
    examStarted.value = true
  } catch (error) {
    console.error(error)
  } finally {
    loading.value = false
  }
}

const submitExam = async () => {
  const unanswered = questions.value.filter(q => {
    if (q.typeId === 2) {
      return !multiAnswers.value[q.id]?.length
    }
    return !answers.value[q.id]
  })
  
  if (unanswered.length > 0) {
    try {
      await ElMessageBox.confirm(`还有 ${unanswered.length} 题未作答，确定提交吗？`, '提示', {
        type: 'warning'
      })
    } catch {
      return
    }
  }
  
  const questionRecords = questions.value.map(q => {
    let answer
    if (q.typeId === 2) {
      answer = (multiAnswers.value[q.id] || []).sort().join('')
    } else if (q.typeId === 3) {
      const val = answers.value[q.id]
      if (val === 'A') {
        answer = '正确'
      } else if (val === 'B') {
        answer = '错误'
      } else {
        answer = val || ''
      }
    } else {
      answer = answers.value[q.id] || ''
    }
    return {
      questionId: q.id,
      answer
    }
  })
  
  submitting.value = true
  try {
    const res = await submitExamApi({
      examId: examId.value,
      userId: userStore.userInfo.id,
      questionRecords
    })
    
    examResult.value = res.data
    examSubmitted.value = true
    
    await loadExamQuestions()
  } catch (error) {
    console.error(error)
  } finally {
    submitting.value = false
  }
}

const saveCurrentAnswer = async (questionId) => {
  if (!examId.value) return
  
  try {
    const question = questions.value.find(q => q.id === questionId)
    if (!question) return
    
    let answer
    if (question.typeId === 2) {
      answer = (multiAnswers.value[questionId] || []).sort().join('')
    } else if (question.typeId === 3) {
      const val = answers.value[questionId]
      if (val === 'A') {
        answer = '正确'
      } else if (val === 'B') {
        answer = '错误'
      } else {
        answer = val || ''
      }
    } else {
      answer = answers.value[questionId] || ''
    }
    
    if (!answer) return
    
    const examQuestion = answerStatusList.value.find(eq => eq.questionId === questionId)
    if (!examQuestion) return
    
    await saveExamAnswer({
      examId: examId.value,
      questionId: questionId,
      questionSeq: examQuestion.questionSeq,
      userAnswer: answer
    })
    
    await loadExamQuestions()
  } catch (error) {
    console.error(error)
  }
}

const jumpToQuestion = async (seq) => {
  if (!examId.value) return
  
  try {
    const res = await jumpToExamQuestion(examId.value, seq)
    if (res.data) {
      currentSeq.value = seq
    }
  } catch (error) {
    console.error(error)
  }
}

const loadExamQuestions = async () => {
  if (!examId.value) return
  
  try {
    const res = await getExamQuestions(examId.value)
    answerStatusList.value = res.data || []
  } catch (error) {
    console.error(error)
  }
}

const resetExam = () => {
  examStarted.value = false
  examSubmitted.value = false
  examId.value = null
  currentSeq.value = 1
  questions.value = []
  answers.value = {}
  multiAnswers.value = {}
  answerStatusList.value = []
  examResult.value = {}
}

watch(() => questions.value, () => {
  if (questions.value.length > 0) {
    const firstQuestion = questions.value[0]
    const examQuestion = answerStatusList.value.find(eq => eq.questionId === firstQuestion.id)
    if (examQuestion) {
      currentSeq.value = examQuestion.questionSeq
    }
  }
}, { immediate: true })
</script>

<style scoped lang="scss">
.exam-container {
  max-width: 900px;
  margin: 0 auto;
}

.exam-header {
  margin-bottom: 20px;
  
  h2 {
    font-size: 20px;
    color: #333;
  }
}

.config-section {
  h3 {
    margin-bottom: 20px;
    color: #333;
  }
}

.exam-section {
  .exam-info {
    display: flex;
    align-items: center;
    gap: 20px;
    margin-bottom: 20px;
    padding: 15px 20px;
    background: #fff;
    border-radius: 8px;
    
    span {
      color: #666;
    }
    
    .el-button {
      margin-left: auto;
    }
  }
  
  .exam-content {
    display: flex;
    gap: 20px;
  }
  
  .questions-list {
    flex: 1;
  }
  
  .answer-card-sidebar {
    width: 200px;
    position: sticky;
    top: 20px;
    align-self: flex-start;
  }
}

.question-card {
  margin-bottom: 20px;
  
  .question-header {
    display: flex;
    align-items: center;
    gap: 10px;
    margin-bottom: 15px;
    
    .question-num {
      font-weight: bold;
      color: #409eff;
    }
  }
  
  .question-content {
    font-size: 15px;
    line-height: 1.6;
    color: #333;
    margin-bottom: 15px;
  }
  
  .option-item {
    display: block;
    margin-bottom: 10px;
  }
}

.result-section {
  .result-card {
    text-align: center;
    margin-bottom: 30px;
    
    h2 {
      margin-bottom: 20px;
    }
    
    .score-info {
      margin-bottom: 20px;
      
      .score {
        font-size: 48px;
        font-weight: bold;
        color: #409eff;
        margin-bottom: 10px;
      }
      
      .stats p {
        color: #666;
        margin: 5px 0;
      }
    }
  }
  
  .detail-section {
    h3 {
      margin-bottom: 20px;
      color: #333;
    }
  }
  
  .detail-card {
    margin-bottom: 15px;
    
    .detail-header {
      display: flex;
      align-items: center;
      gap: 10px;
      margin-bottom: 10px;
      
      .question-num {
        font-weight: bold;
        color: #409eff;
      }
    }
    
    .question-content {
      margin-bottom: 10px;
      color: #333;
    }
    
    .answer-compare {
      padding: 10px;
      background: #f5f7fa;
      border-radius: 4px;
      margin-bottom: 10px;
      
      p {
        margin: 5px 0;
        color: #666;
      }
    }
    
    .analysis {
      padding: 10px;
      background: #fdf6ec;
      border-radius: 4px;
      
      p {
        margin: 5px 0;
        color: #666;
      }
    }
  }
}
</style>
