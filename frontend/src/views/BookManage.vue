<template>
  <div class="book-manage-container">
    <el-card class="header-card">
      <div class="book-header">
        <div class="book-info">
          <h2>{{ book?.bookName }}</h2>
          <p>{{ book?.bookDesc }}</p>
        </div>
        <div class="actions">
          <el-button type="primary" @click="showAddDialog">添加题目</el-button>
          <el-button type="success" @click="showAiGenerateDialog">AI出题</el-button>
          <el-button @click="showBatchDialog">批量导入</el-button>
          <el-button @click="goBack">返回</el-button>
        </div>
      </div>
    </el-card>
    
    <el-card class="table-card">
      <el-table :data="questions" style="width: 100%" v-loading="loading">
        <el-table-column type="index" label="序号" width="60" />
        <el-table-column prop="typeName" label="题型" width="100">
          <template #default="{ row }">
            <el-tag :type="getTypeTag(row.typeId)">{{ row.typeName }}</el-tag>
          </template>
        </el-table-column>
        <el-table-column prop="content" label="题目内容" show-overflow-tooltip />
        <el-table-column prop="answer" label="答案" width="100" show-overflow-tooltip />
        <el-table-column prop="difficulty" label="难度" width="80">
          <template #default="{ row }">
            <el-tag :type="getDifficultyTag(row.difficulty)">
              {{ getDifficultyText(row.difficulty) }}
            </el-tag>
          </template>
        </el-table-column>
        <el-table-column label="操作" width="150">
          <template #default="{ row }">
            <el-button type="primary" link @click="editQuestion(row)">编辑</el-button>
            <el-button type="danger" link @click="removeQuestion(row)">删除</el-button>
          </template>
        </el-table-column>
      </el-table>
    </el-card>
    
    <el-dialog v-model="questionDialogVisible" :title="isEdit ? '编辑题目' : '添加题目'" width="600px">
      <el-form :model="questionForm" label-width="80px" :rules="questionRules" ref="questionFormRef">
        <el-form-item label="题型" prop="typeId">
          <el-select v-model="questionForm.typeId" placeholder="请选择题型" @change="handleTypeChange">
            <el-option v-for="type in questionTypes" :key="type.id" :label="type.typeName" :value="type.id" />
          </el-select>
        </el-form-item>
        <el-form-item label="题目内容" prop="content">
          <el-input v-model="questionForm.content" type="textarea" :rows="3" placeholder="请输入题目内容" />
        </el-form-item>
        <el-form-item label="题目图片">
          <el-upload
            class="image-uploader"
            :show-file-list="false"
            :before-upload="handleContentImageUpload"
          >
            <img v-if="questionForm.contentImage" :src="questionForm.contentImage" class="image-preview" />
            <el-icon v-else class="image-uploader-icon"><Plus /></el-icon>
          </el-upload>
          <el-button v-if="questionForm.contentImage" type="danger" link @click="questionForm.contentImage = ''">删除图片</el-button>
        </el-form-item>
        <el-form-item label="选项" prop="options" v-if="questionForm.typeId !== 4 && questionForm.typeId !== 3">
          <div class="options-editor">
            <div v-for="(opt, index) in optionList" :key="index" class="option-row">
              <el-input v-model="optionList[index]" :placeholder="`选项${String.fromCharCode(65 + index)}`" />
              <el-button v-if="optionList.length > 2" type="danger" link @click="removeOption(index)">删除</el-button>
            </div>
            <el-button type="primary" link @click="addOption" v-if="optionList.length < 6">添加选项</el-button>
          </div>
        </el-form-item>
        <el-form-item label="选项图片" v-if="questionForm.typeId !== 4 && questionForm.typeId !== 3">
          <el-upload
            class="image-uploader"
            :show-file-list="false"
            :before-upload="handleOptionsImageUpload"
          >
            <img v-if="questionForm.optionsImage" :src="questionForm.optionsImage" class="image-preview" />
            <el-icon v-else class="image-uploader-icon"><Plus /></el-icon>
          </el-upload>
          <el-button v-if="questionForm.optionsImage" type="danger" link @click="questionForm.optionsImage = ''">删除图片</el-button>
        </el-form-item>
        <el-form-item label="答案" prop="answer">
          <el-input 
            v-if="questionForm.typeId === 4" 
            v-model="questionForm.answer" 
            type="textarea" 
            :rows="2" 
            placeholder="请输入答案" 
          />
          <el-select v-else-if="questionForm.typeId === 1" v-model="questionForm.answer" placeholder="请选择正确答案">
            <el-option v-for="(opt, index) in optionList" :key="index" :label="String.fromCharCode(65 + index)" :value="String.fromCharCode(65 + index)" />
          </el-select>
          <el-checkbox-group v-else-if="questionForm.typeId === 2" v-model="multiAnswer">
            <el-checkbox v-for="(opt, index) in optionList" :key="index" :label="String.fromCharCode(65 + index)" />
          </el-checkbox-group>
          <el-radio-group v-else-if="questionForm.typeId === 3" v-model="questionForm.answer">
            <el-radio label="正确">正确</el-radio>
            <el-radio label="错误">错误</el-radio>
          </el-radio-group>
        </el-form-item>
        <el-form-item label="解析">
          <el-input v-model="questionForm.analysis" type="textarea" :rows="2" placeholder="请输入解析" />
        </el-form-item>
        <el-form-item label="难度">
          <el-select v-model="questionForm.difficulty" placeholder="请选择难度">
            <el-option label="简单" :value="1" />
            <el-option label="中等" :value="2" />
            <el-option label="困难" :value="3" />
          </el-select>
        </el-form-item>
        <el-form-item label="答题要点" v-if="questionForm.typeId === 4">
          <el-input v-model="questionForm.keyPoints" type="textarea" :rows="2" placeholder="请输入答题要点（用于AI评分）" />
        </el-form-item>
        <el-form-item label="AI评分" v-if="questionForm.typeId === 4">
          <el-switch v-model="questionForm.aiScoring" :active-value="1" :inactive-value="0" />
          <span style="margin-left: 10px; color: #909399; font-size: 12px;">启用后，考试时将使用AI对简答题进行评分</span>
        </el-form-item>
        <el-form-item label="题目附件">
          <div class="attachment-section">
            <el-upload
              class="file-uploader"
              :show-file-list="false"
              :before-upload="handleAttachmentUpload"
            >
              <el-button type="primary">上传附件</el-button>
            </el-upload>
            <div v-if="questionForm.attachment" class="attachment-info">
              <el-link :href="questionForm.attachment" target="_blank" type="primary">
                {{ questionForm.attachmentName || '查看附件' }}
              </el-link>
              <el-button type="danger" link @click="clearAttachment">删除附件</el-button>
            </div>
          </div>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="questionDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="saveQuestion" :loading="saving">确定</el-button>
      </template>
    </el-dialog>
    
    <el-dialog v-model="batchDialogVisible" title="批量导入题目" width="700px">
      <el-alert type="info" :closable="false" style="margin-bottom: 20px;">
        <template #title>
          <div>导入格式说明：</div>
        </template>
        <div>1. 每行一道题目，使用 " | " 分隔各字段</div>
        <div>2. 格式：题型 | 题目内容 | 选项(用分号分隔) | 答案 | 解析 | 难度</div>
        <div>3. 题型：单选/多选/判断/简答</div>
        <div>4. 示例：单选 | Java中哪个关键字用于定义类？ | A.class;B.struct;C.define;D.type | A | Java使用class关键字定义类 | 1</div>
      </el-alert>
      <el-input
        v-model="batchContent"
        type="textarea"
        :rows="10"
        placeholder="请按格式输入题目内容"
      />
      <template #footer>
        <el-button @click="batchDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="importBatch" :loading="importing">导入</el-button>
      </template>
    </el-dialog>
    
    <el-dialog v-model="aiGenerateDialogVisible" title="AI智能出题" width="700px">
      <el-form :model="aiGenerateForm" label-width="100px">
        <el-form-item label="题型">
          <el-select v-model="aiGenerateForm.typeId" placeholder="请选择题型">
            <el-option
              v-for="type in questionTypes"
              :key="type.id"
              :label="type.typeName"
              :value="type.id"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="题目数量">
          <el-input-number v-model="aiGenerateForm.count" :min="1" :max="10" />
        </el-form-item>
        <el-form-item label="材料">
          <el-input
            v-model="aiGenerateForm.material"
            type="textarea"
            :rows="4"
            placeholder="请输入题目材料（可选）"
          />
        </el-form-item>
        <el-form-item label="要求">
          <el-input
            v-model="aiGenerateForm.requirements"
            type="textarea"
            :rows="3"
            placeholder="请输入出题要求，例如：涵盖知识点A、B、C"
          />
        </el-form-item>
        <el-form-item v-if="aiGenerateForm.typeId === 4">
          <el-alert type="info" :closable="false">
            <template #title>
              简答题将自动生成答题要点并启用AI评分功能
            </template>
          </el-alert>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="aiGenerateDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="handleAiGenerate" :loading="aiGenerating">生成</el-button>
      </template>
    </el-dialog>
    
    <el-dialog v-model="bookDialogVisible" title="编辑习题册" width="500px">
      <el-form :model="bookForm" label-width="100px" :rules="bookRules" ref="bookFormRef">
        <el-form-item label="习题册名称" prop="bookName">
          <el-input v-model="bookForm.bookName" />
        </el-form-item>
        <el-form-item label="描述" prop="bookDesc">
          <el-input v-model="bookForm.bookDesc" type="textarea" :rows="3" />
        </el-form-item>
        <el-form-item label="是否公开">
          <el-switch v-model="bookForm.isPublic" :active-value="1" :inactive-value="0" />
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="bookDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="saveBook" :loading="savingBook">确定</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { Plus, MagicStick } from '@element-plus/icons-vue'
import { getBookDetail, updateBook } from '@/api/book'
import { getQuestionList, createQuestion, updateQuestion, deleteQuestion, batchCreateQuestions } from '@/api/question'
import { getQuestionTypes } from '@/api/questionType'
import { generateQuestions, judgeAnswer } from '@/api/ai'
import { uploadImage, uploadFile } from '@/api/upload'

const route = useRoute()
const router = useRouter()

const bookId = route.params.bookId
const book = ref(null)
const questions = ref([])
const questionTypes = ref([])
const loading = ref(false)
const saving = ref(false)
const importing = ref(false)
const savingBook = ref(false)
const questionDialogVisible = ref(false)
const batchDialogVisible = ref(false)
const aiGenerateDialogVisible = ref(false)
const aiGenerating = ref(false)
const aiJudging = ref(false)
const aiGenerateForm = ref({
  typeId: null,
  count: 5,
  material: '',
  requirements: ''
})
const bookDialogVisible = ref(false)
const isEdit = ref(false)
const questionFormRef = ref(null)
const bookFormRef = ref(null)

const optionList = ref(['', '', ''])
const multiAnswer = ref([])

const questionForm = reactive({
  id: null,
  bookId: bookId,
  typeId: 1,
  content: '',
  contentImage: '',
  options: '',
  optionsImage: '',
  answer: '',
  analysis: '',
  difficulty: 1,
  attachment: '',
  attachmentName: '',
  keyPoints: '',
  aiScoring: 0
})

const batchContent = ref('')

const bookForm = reactive({
  id: null,
  bookName: '',
  bookDesc: '',
  isPublic: 1
})

const bookRules = {
  bookName: [{ required: true, message: '请输入习题册名称', trigger: 'blur' }]
}

const questionRules = {
  typeId: [{ required: true, message: '请选择题型', trigger: 'change' }],
  content: [{ required: true, message: '请输入题目内容', trigger: 'blur' }],
  answer: [{ required: true, message: '请输入答案', trigger: 'blur' }]
}

const getTypeTag = (typeId) => {
  const map = { 1: '', 2: 'success', 3: 'warning', 4: 'info' }
  return map[typeId] || ''
}

const getDifficultyTag = (difficulty) => {
  const map = { 1: 'success', 2: 'warning', 3: 'danger' }
  return map[difficulty] || 'success'
}

const getDifficultyText = (difficulty) => {
  const map = { 1: '简单', 2: '中等', 3: '困难' }
  return map[difficulty] || '简单'
}

const loadBook = async () => {
  try {
    const res = await getBookDetail(bookId, 0)
    book.value = res.data
  } catch (error) {
    console.error(error)
  }
}

const loadQuestions = async () => {
  loading.value = true
  try {
    const res = await getQuestionList(bookId)
    questions.value = res.data
  } catch (error) {
    console.error(error)
  } finally {
    loading.value = false
  }
}

const loadQuestionTypes = async () => {
  try {
    const res = await getQuestionTypes()
    questionTypes.value = res.data
  } catch (error) {
    console.error(error)
  }
}

const handleTypeChange = (typeId) => {
  if (typeId === 3) {
    questionForm.answer = ''
    optionList.value = []
  } else if (typeId === 4) {
    questionForm.answer = ''
    optionList.value = []
  } else {
    optionList.value = ['', '', '', '']
    questionForm.answer = ''
    multiAnswer.value = []
  }
}

const addOption = () => {
  if (optionList.value.length < 6) {
    optionList.value.push('')
  }
}

const removeOption = (index) => {
  optionList.value.splice(index, 1)
}

const showAddDialog = () => {
  isEdit.value = false
  questionForm.id = null
  questionForm.typeId = 1
  questionForm.content = ''
  questionForm.contentImage = ''
  questionForm.options = ''
  questionForm.optionsImage = ''
  questionForm.answer = ''
  questionForm.analysis = ''
  questionForm.difficulty = 1
  questionForm.attachment = ''
  questionForm.attachmentName = ''
  optionList.value = ['', '', '', '']
  multiAnswer.value = []
  questionDialogVisible.value = true
}

const editQuestion = (row) => {
  isEdit.value = true
  questionForm.id = row.id
  questionForm.typeId = row.typeId
  questionForm.content = row.content
  questionForm.contentImage = row.contentImage || ''
  questionForm.answer = row.answer
  questionForm.analysis = row.analysis
  questionForm.difficulty = row.difficulty
  questionForm.optionsImage = row.optionsImage || ''
  questionForm.attachment = row.attachment || ''
  questionForm.attachmentName = row.attachmentName || ''
  questionForm.keyPoints = row.keyPoints || ''
  questionForm.aiScoring = row.aiScoring || 0
  
  if (row.typeId === 3) {
    optionList.value = []
  } else if (row.typeId === 4) {
    optionList.value = []
  } else {
    try {
      const opts = JSON.parse(row.options || '[]')
      optionList.value = opts.map(o => o.replace(/^[A-Z]\./, ''))
      if (row.typeId === 2) {
        multiAnswer.value = row.answer.split('')
      }
    } catch (e) {
      optionList.value = ['', '', '', '']
    }
  }
  
  questionDialogVisible.value = true
}

const saveQuestion = async () => {
  try {
    await questionFormRef.value.validate()
    saving.value = true
    
    let options = ''
    let answer = questionForm.answer
    
    if (questionForm.typeId !== 3 && questionForm.typeId !== 4) {
      const formattedOpts = optionList.value.map((opt, index) => 
        `${String.fromCharCode(65 + index)}.${opt}`
      )
      options = JSON.stringify(formattedOpts)
      
      if (questionForm.typeId === 2) {
        answer = multiAnswer.value.sort().join('')
      }
    }
    
    const data = {
      ...questionForm,
      options,
      answer
    }
    
    if (isEdit.value) {
      await updateQuestion(data)
      ElMessage.success('修改成功')
    } else {
      await createQuestion(data)
      ElMessage.success('添加成功')
    }
    
    questionDialogVisible.value = false
    loadQuestions()
  } catch (error) {
    if (error !== false) {
      ElMessage.error('操作失败')
    }
  } finally {
    saving.value = false
  }
}

const removeQuestion = async (row) => {
  try {
    await ElMessageBox.confirm('确定要删除该题目吗？', '提示', { type: 'warning' })
    await deleteQuestion(row.id)
    ElMessage.success('删除成功')
    loadQuestions()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
    }
  }
}

const showBatchDialog = () => {
  batchContent.value = ''
  batchDialogVisible.value = true
}

const showAiGenerateDialog = () => {
  aiGenerateForm.value = {
    typeId: null,
    count: 5,
    material: '',
    requirements: ''
  }
  aiGenerateDialogVisible.value = true
}

const handleAiGenerate = async () => {
  if (!aiGenerateForm.value.typeId) {
    ElMessage.warning('请选择题型')
    return
  }
  
  const selectedType = questionTypes.value.find(t => t.id === aiGenerateForm.value.typeId)
  
  aiGenerating.value = true
  try {
    const res = await generateQuestions({
      typeId: aiGenerateForm.value.typeId,
      typeName: selectedType?.typeName,
      count: aiGenerateForm.value.count,
      material: aiGenerateForm.value.material,
      requirements: aiGenerateForm.value.requirements
    })
    
    const questionsData = JSON.parse(res.data)
    
    for (const q of questionsData) {
      const options = Array.isArray(q.options) ? JSON.stringify(q.options) : q.options
      const questionData = {
        bookId: bookId,
        typeId: aiGenerateForm.value.typeId,
        content: q.content,
        options: options,
        answer: q.answer,
        analysis: q.analysis,
        difficulty: q.difficulty || 1
      }
      
      if (aiGenerateForm.value.typeId === 4) {
        questionData.keyPoints = q.keyPoints || ''
        questionData.aiScoring = q.aiScoring || 1
      }
      
      await createQuestion(questionData)
    }
    
    ElMessage.success(`成功生成${questionsData.length}道题目`)
    aiGenerateDialogVisible.value = false
    loadQuestions()
  } catch (error) {
    ElMessage.error('AI生成失败')
  } finally {
    aiGenerating.value = false
  }
}

const handleAiJudge = async () => {
  if (!questionForm.content || !questionForm.answer || !questionForm.keyPoints) {
    ElMessage.warning('请填写题目内容、答案和答题要点')
    return
  }
  
  aiJudging.value = true
  try {
    const res = await judgeAnswer({
      question: questionForm.content,
      correctAnswer: questionForm.answer,
      keyPoints: questionForm.keyPoints,
      userAnswer: questionForm.answer
    })
    
    ElMessageBox.alert(res.data, 'AI评分结果', {
      confirmButtonText: '确定',
      dangerouslyUseHTMLString: true
    })
  } catch (error) {
    ElMessage.error('AI评分失败')
  } finally {
    aiJudging.value = false
  }
}

const importBatch = async () => {
  if (!batchContent.value.trim()) {
    ElMessage.warning('请输入题目内容')
    return
  }
  
  importing.value = true
  try {
    const lines = batchContent.value.trim().split('\n')
    const questions = []
    
    for (const line of lines) {
      const parts = line.split('|').map(p => p.trim())
      if (parts.length < 4) continue
      
      const typeMap = { '单选': 1, '多选': 2, '判断': 3, '简答': 4 }
      const typeId = typeMap[parts[0]] || 1
      
      let options = ''
      if (typeId !== 3 && typeId !== 4 && parts[2]) {
        const opts = parts[2].split(';')
        options = JSON.stringify(opts.map((o, i) => `${String.fromCharCode(65 + i)}.${o}`))
      }
      
      questions.push({
        bookId: parseInt(bookId),
        typeId,
        content: parts[1],
        options,
        answer: parts[3],
        analysis: parts[4] || '',
        difficulty: parseInt(parts[5]) || 1
      })
    }
    
    if (questions.length === 0) {
      ElMessage.warning('没有有效的题目数据')
      return
    }
    
    await batchCreateQuestions(questions)
    ElMessage.success(`成功导入 ${questions.length} 道题目`)
    batchDialogVisible.value = false
    loadQuestions()
  } catch (error) {
    ElMessage.error('导入失败')
  } finally {
    importing.value = false
  }
}

const showEditBookDialog = () => {
  bookForm.id = book.value.id
  bookForm.bookName = book.value.bookName
  bookForm.bookDesc = book.value.bookDesc
  bookForm.isPublic = book.value.isPublic
  bookDialogVisible.value = true
}

const saveBook = async () => {
  try {
    await bookFormRef.value.validate()
    savingBook.value = true
    await updateBook({
      id: bookForm.id,
      bookName: bookForm.bookName,
      bookDesc: bookForm.bookDesc,
      isPublic: bookForm.isPublic
    })
    ElMessage.success('保存成功')
    bookDialogVisible.value = false
    loadBook()
  } catch (error) {
    if (error !== false) {
      ElMessage.error('保存失败')
    }
  } finally {
    savingBook.value = false
  }
}

const handleContentImageUpload = async (rawFile) => {
  const isImage = rawFile.type.startsWith('image/')
  const isLt5M = rawFile.size / 1024 / 1024 < 5

  if (!isImage) {
    ElMessage.error('只能上传图片文件!')
    return false
  }
  if (!isLt5M) {
    ElMessage.error('图片大小不能超过 5MB!')
    return false
  }
  
  try {
    const res = await uploadImage(rawFile)
    questionForm.contentImage = res.data
    ElMessage.success('上传成功')
  } catch (error) {
    ElMessage.error('上传失败')
  }
  return false
}

const handleOptionsImageUpload = async (rawFile) => {
  const isImage = rawFile.type.startsWith('image/')
  const isLt5M = rawFile.size / 1024 / 1024 < 5

  if (!isImage) {
    ElMessage.error('只能上传图片文件!')
    return false
  }
  if (!isLt5M) {
    ElMessage.error('图片大小不能超过 5MB!')
    return false
  }
  
  try {
    const res = await uploadImage(rawFile)
    questionForm.optionsImage = res.data
    ElMessage.success('上传成功')
  } catch (error) {
    ElMessage.error('上传失败')
  }
  return false
}

const handleAttachmentUpload = async (rawFile) => {
  const isLt10M = rawFile.size / 1024 / 1024 < 10
  if (!isLt10M) {
    ElMessage.error('文件大小不能超过 10MB!')
    return false
  }
  
  try {
    const res = await uploadFile(rawFile)
    questionForm.attachment = res.data.url
    questionForm.attachmentName = res.data.name
    ElMessage.success('上传成功')
  } catch (error) {
    ElMessage.error('上传失败')
  }
  return false
}

const clearAttachment = () => {
  questionForm.attachment = ''
  questionForm.attachmentName = ''
}

const goBack = () => {
  router.back()
}

onMounted(() => {
  loadBook()
  loadQuestions()
  loadQuestionTypes()
})
</script>

<style scoped lang="scss">
.book-manage-container {
  max-width: 1200px;
  margin: 0 auto;
}

.header-card {
  margin-bottom: 20px;
}

.book-header {
  display: flex;
  justify-content: space-between;
  align-items: center;
  
  .book-info {
    h2 {
      margin: 0 0 5px 0;
      color: #333;
    }
    
    p {
      margin: 0;
      color: #666;
      font-size: 14px;
    }
  }
  
  .actions {
    display: flex;
    gap: 10px;
  }
}

.options-editor {
  .option-row {
    display: flex;
    gap: 10px;
    margin-bottom: 10px;
    
    .el-input {
      flex: 1;
    }
  }
}

.image-uploader {
  .el-upload {
    border: 1px dashed #d9d9d9;
    border-radius: 6px;
    cursor: pointer;
    position: relative;
    overflow: hidden;
    transition: all 0.3s;
    
    &:hover {
      border-color: #409EFF;
    }
  }
}

.image-uploader-icon {
  font-size: 28px;
  color: #8c939d;
  width: 148px;
  height: 148px;
  text-align: center;
  line-height: 148px;
}

.image-preview {
  width: 148px;
  height: 148px;
  display: block;
  object-fit: cover;
}

.attachment-section {
  display: flex;
  flex-direction: column;
  gap: 10px;
  
  .attachment-info {
    display: flex;
    align-items: center;
    gap: 10px;
  }
}
</style>
