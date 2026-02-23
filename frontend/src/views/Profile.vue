<template>
  <div class="profile-container">
    <el-tabs v-model="activeTab">
      <el-tab-pane label="个人信息" name="info">
        <el-card class="info-card">
          <el-form :model="userInfo" label-width="100px" :rules="rules" ref="infoFormRef">
            <el-form-item label="用户名">
              <el-input v-model="userInfo.username" disabled />
            </el-form-item>
            <el-form-item label="昵称" prop="nickname">
              <el-input v-model="userInfo.nickname" />
            </el-form-item>
            <el-form-item label="邮箱" prop="email">
              <el-input v-model="userInfo.email" />
            </el-form-item>
            <el-form-item label="手机号" prop="phone">
              <el-input v-model="userInfo.phone" />
            </el-form-item>
            <el-form-item label="角色">
              <el-tag :type="userInfo.role === 'admin' ? 'danger' : 'primary'">
                {{ userInfo.role === 'admin' ? '管理员' : '普通用户' }}
              </el-tag>
            </el-form-item>
            <el-form-item label="注册时间">
              <span>{{ userInfo.createTime }}</span>
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="saveInfo" :loading="saving">保存修改</el-button>
            </el-form-item>
          </el-form>
        </el-card>
      </el-tab-pane>
      
      <el-tab-pane label="修改密码" name="password">
        <el-card class="info-card">
          <el-form :model="passwordForm" label-width="100px" :rules="passwordRules" ref="passwordFormRef">
            <el-form-item label="原密码" prop="oldPassword">
              <el-input v-model="passwordForm.oldPassword" type="password" show-password />
            </el-form-item>
            <el-form-item label="新密码" prop="newPassword">
              <el-input v-model="passwordForm.newPassword" type="password" show-password />
            </el-form-item>
            <el-form-item label="确认密码" prop="confirmPassword">
              <el-input v-model="passwordForm.confirmPassword" type="password" show-password />
            </el-form-item>
            <el-form-item>
              <el-button type="primary" @click="changePassword" :loading="changingPassword">修改密码</el-button>
            </el-form-item>
          </el-form>
        </el-card>
      </el-tab-pane>
      
      <el-tab-pane label="我的习题册" name="books">
        <el-card>
          <div class="book-header">
            <el-button type="primary" @click="showCreateDialog">创建习题册</el-button>
          </div>
          
          <el-table :data="myBooks" style="width: 100%">
            <el-table-column prop="bookName" label="习题册名称" />
            <el-table-column prop="bookDesc" label="描述" show-overflow-tooltip />
            <el-table-column prop="createTime" label="创建时间" width="180" />
            <el-table-column prop="status" label="状态" width="100">
              <template #default="{ row }">
                <el-tag :type="row.status === 1 ? 'success' : 'danger'">
                  {{ row.status === 1 ? '启用' : '禁用' }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="isPublic" label="公开状态" width="100">
              <template #default="{ row }">
                <el-tag :type="row.isPublic === 1 ? 'success' : 'info'">
                  {{ row.isPublic === 1 ? '公开' : '私有' }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="200">
              <template #default="{ row }">
                <el-button type="primary" link @click="goBookManage(row)">管理题目</el-button>
                <el-button 
                  type="warning" 
                  link 
                  @click="toggleBookStatus(row)"
                >
                  {{ row.status === 1 ? '禁用' : '启用' }}
                </el-button>
                <el-button type="danger" link @click="removeBook(row)">删除</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-tab-pane>
      
      <el-tab-pane label="考试记录" name="exams">
        <el-card>
          <el-table :data="examRecords" style="width: 100%" v-loading="loadingExams">
            <el-table-column prop="bookName" label="习题册名称" />
            <el-table-column prop="examName" label="考试名称" />
            <el-table-column prop="totalCount" label="总题数" width="100" />
            <el-table-column prop="correctCount" label="正确数" width="100" />
            <el-table-column prop="score" label="得分" width="100">
              <template #default="{ row }">
                <el-tag :type="getScoreTag(row.score)">{{ row.score }}分</el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="createTime" label="考试时间" width="180" />
          </el-table>
        </el-card>
      </el-tab-pane>
      
      <el-tab-pane label="用户管理" name="users" v-if="userInfo.role === 'admin'">
        <el-card>
          <el-table :data="users" style="width: 100%">
            <el-table-column prop="username" label="用户名" />
            <el-table-column prop="nickname" label="昵称" />
            <el-table-column prop="email" label="邮箱" />
            <el-table-column prop="phone" label="手机号" />
            <el-table-column prop="role" label="角色" width="100">
              <template #default="{ row }">
                <el-tag :type="row.role === 'admin' ? 'danger' : 'primary'">
                  {{ row.role === 'admin' ? '管理员' : '普通用户' }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="createTime" label="注册时间" width="180" />
            <el-table-column label="操作" width="150">
              <template #default="{ row }">
                <el-button 
                  v-if="row.id !== userInfo.id"
                  type="danger" 
                  link 
                  @click="removeUser(row)"
                >
                  删除
                </el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-tab-pane>
      
      <el-tab-pane label="习题册管理" name="allbooks" v-if="userInfo.role === 'admin'">
        <el-card>
          <el-table :data="allBooks" style="width: 100%">
            <el-table-column prop="bookName" label="习题册名称" />
            <el-table-column prop="bookDesc" label="描述" show-overflow-tooltip />
            <el-table-column prop="creatorName" label="创建者" width="120" />
            <el-table-column prop="createTime" label="创建时间" width="180" />
            <el-table-column prop="status" label="状态" width="100">
              <template #default="{ row }">
                <el-tag :type="row.status === 1 ? 'success' : 'danger'">
                  {{ row.status === 1 ? '启用' : '禁用' }}
                </el-tag>
              </template>
            </el-table-column>
            <el-table-column label="操作" width="150">
              <template #default="{ row }">
                <el-button 
                  type="warning" 
                  link 
                  @click="toggleAllBookStatus(row)"
                >
                  {{ row.status === 1 ? '禁用' : '启用' }}
                </el-button>
                <el-button type="danger" link @click="removeAllBook(row)">删除</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-tab-pane>
    </el-tabs>
    
    <el-dialog v-model="bookDialogVisible" title="创建习题册" width="500px">
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
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getUserInfo, updateUserInfo, updatePassword, getUserList, deleteUser } from '@/api/user'
import { getMyBooks, createBook, updateBookStatus, deleteBook, getAllBooks } from '@/api/book'
import { getUserExamRecords } from '@/api/exam'
import { useUserStore } from '@/store/user'

const router = useRouter()
const userStore = useUserStore()
const activeTab = ref('info')
const saving = ref(false)
const changingPassword = ref(false)
const savingBook = ref(false)
const bookDialogVisible = ref(false)
const isEdit = ref(false)

const infoFormRef = ref(null)
const passwordFormRef = ref(null)
const bookFormRef = ref(null)

const userInfo = reactive({
  id: null,
  username: '',
  nickname: '',
  email: '',
  phone: '',
  role: '',
  createTime: ''
})

const passwordForm = reactive({
  oldPassword: '',
  newPassword: '',
  confirmPassword: ''
})

const bookForm = reactive({
  id: null,
  bookName: '',
  bookDesc: '',
  isPublic: 1,
  creatorId: null
})

const myBooks = ref([])
const users = ref([])
const allBooks = ref([])
const examRecords = ref([])
const loadingExams = ref(false)

const rules = {
  nickname: [{ required: true, message: '请输入昵称', trigger: 'blur' }],
  email: [{ type: 'email', message: '请输入正确的邮箱地址', trigger: 'blur' }]
}

const passwordRules = {
  oldPassword: [{ required: true, message: '请输入原密码', trigger: 'blur' }],
  newPassword: [{ required: true, min: 6, message: '密码至少6位', trigger: 'blur' }],
  confirmPassword: [
    { required: true, message: '请确认密码', trigger: 'blur' },
    {
      validator: (rule, value, callback) => {
        if (value !== passwordForm.newPassword) {
          callback(new Error('两次密码不一致'))
        } else {
          callback()
        }
      },
      trigger: 'blur'
    }
  ]
}

const bookRules = {
  bookName: [{ required: true, message: '请输入习题册名称', trigger: 'blur' }]
}

const loadUserInfo = async () => {
  try {
    const res = await getUserInfo(userStore.userInfo.id)
    Object.assign(userInfo, res.data)
  } catch (error) {
    console.error(error)
  }
}

const saveInfo = async () => {
  try {
    await infoFormRef.value.validate()
    saving.value = true
    await updateUserInfo({
      id: userInfo.id,
      nickname: userInfo.nickname,
      email: userInfo.email,
      phone: userInfo.phone
    })
    userStore.userInfo.nickname = userInfo.nickname
    ElMessage.success('保存成功')
  } catch (error) {
    if (error !== false) {
      ElMessage.error('保存失败')
    }
  } finally {
    saving.value = false
  }
}

const changePassword = async () => {
  try {
    await passwordFormRef.value.validate()
    changingPassword.value = true
    await updatePassword({
      userId: userInfo.id,
      oldPassword: passwordForm.oldPassword,
      newPassword: passwordForm.newPassword
    })
    ElMessage.success('密码修改成功')
    passwordForm.oldPassword = ''
    passwordForm.newPassword = ''
    passwordForm.confirmPassword = ''
  } catch (error) {
    if (error !== false) {
      ElMessage.error(error.response?.data?.message || '密码修改失败')
    }
  } finally {
    changingPassword.value = false
  }
}

const loadMyBooks = async () => {
  try {
    const res = await getMyBooks(userStore.userInfo.id)
    myBooks.value = res.data
  } catch (error) {
    console.error(error)
  }
}

const showCreateDialog = () => {
  isEdit.value = false
  bookForm.id = null
  bookForm.bookName = ''
  bookForm.bookDesc = ''
  bookForm.isPublic = 1
  bookForm.creatorId = userStore.userInfo.id
  bookDialogVisible.value = true
}

const saveBook = async () => {
  try {
    await bookFormRef.value.validate()
    savingBook.value = true
    await createBook(bookForm)
    ElMessage.success('创建成功')
    bookDialogVisible.value = false
    loadMyBooks()
  } catch (error) {
    if (error !== false) {
      ElMessage.error('操作失败')
    }
  } finally {
    savingBook.value = false
  }
}

const toggleBookStatus = async (row) => {
  try {
    const newStatus = row.status === 1 ? 0 : 1
    await updateBookStatus(row.id, newStatus)
    row.status = newStatus
    ElMessage.success('操作成功')
  } catch (error) {
    ElMessage.error('操作失败')
  }
}

const removeBook = async (row) => {
  try {
    await ElMessageBox.confirm('确定要删除该习题册吗？删除后无法恢复！', '提示', {
      type: 'warning'
    })
    await deleteBook(row.id)
    ElMessage.success('删除成功')
    loadMyBooks()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
    }
  }
}

const goBookManage = (row) => {
  router.push(`/book-manage/${row.id}`)
}

const loadUsers = async () => {
  try {
    const res = await getUserList()
    users.value = res.data
  } catch (error) {
    console.error(error)
  }
}

const removeUser = async (row) => {
  try {
    await ElMessageBox.confirm('确定要删除该用户吗？', '提示', {
      type: 'warning'
    })
    await deleteUser(row.id)
    ElMessage.success('删除成功')
    loadUsers()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
    }
  }
}

const loadAllBooks = async () => {
  try {
    const res = await getAllBooks()
    allBooks.value = res.data
  } catch (error) {
    console.error(error)
  }
}

const loadExamRecords = async () => {
  loadingExams.value = true
  try {
    const res = await getUserExamRecords(userStore.userInfo.id)
    examRecords.value = res.data
  } catch (error) {
    console.error(error)
  } finally {
    loadingExams.value = false
  }
}

const getScoreTag = (score) => {
  if (score >= 90) return 'success'
  if (score >= 80) return ''
  if (score >= 60) return 'warning'
  return 'danger'
}

const toggleAllBookStatus = async (row) => {
  try {
    const newStatus = row.status === 1 ? 0 : 1
    await updateBookStatus(row.id, newStatus)
    row.status = newStatus
    ElMessage.success('操作成功')
  } catch (error) {
    ElMessage.error('操作失败')
  }
}

const removeAllBook = async (row) => {
  try {
    await ElMessageBox.confirm('确定要删除该习题册吗？删除后无法恢复！', '提示', {
      type: 'warning'
    })
    await deleteBook(row.id)
    ElMessage.success('删除成功')
    loadAllBooks()
  } catch (error) {
    if (error !== 'cancel') {
      ElMessage.error('删除失败')
    }
  }
}

onMounted(() => {
  loadUserInfo().then(() => {
    if (userInfo.role === 'admin') {
      loadUsers()
      loadAllBooks()
    }
  })
  loadMyBooks()
  loadExamRecords()
})
</script>

<style scoped lang="scss">
.profile-container {
  max-width: 1000px;
  margin: 0 auto;
  padding: 20px;
}

.info-card {
  max-width: 500px;
}

.book-header {
  margin-bottom: 20px;
  display: flex;
  justify-content: flex-end;
}
</style>
