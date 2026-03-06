<template>
  <div class="profile-container">
    <el-tabs v-model="activeTab">
      <el-tab-pane label="个人信息" name="info">
        <el-card class="info-card">
          <el-form :model="userInfo" label-width="100px" :rules="rules" ref="infoFormRef">
            <el-form-item label="用户名">
              <el-input v-model="userInfo.username" disabled />
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
      
      <el-tab-pane label="我的钱包" name="wallet">
        <el-card>
          <div class="wallet-section">
            <div class="balance-card">
              <div class="balance-info">
                <span class="label">账户余额</span>
                <span class="amount">¥{{ wallet?.balance || '0.00' }}</span>
              </div>
              <el-button type="primary" @click="showRechargeDialog">充值</el-button>
            </div>
            
            <div class="transaction-section">
              <h4>交易记录</h4>
              <el-table :data="transactions" style="width: 100%">
                <el-table-column prop="type" label="类型" width="120">
                  <template #default="{ row }">
                    <el-tag :type="row.type === 'recharge' ? 'success' : 'warning'">
                      {{ row.type === 'recharge' ? '充值' : '消费' }}
                    </el-tag>
                  </template>
                </el-table-column>
                <el-table-column prop="amount" label="金额" width="150">
                  <template #default="{ row }">
                    <span :class="row.type === 'recharge' ? 'text-success' : 'text-danger'">
                      {{ row.type === 'recharge' ? '+' : '' }}{{ row.amount }}
                    </span>
                  </template>
                </el-table-column>
                <el-table-column prop="balanceAfter" label="余额" width="150">
                  <template #default="{ row }">
                    ¥{{ row.balanceAfter }}
                  </template>
                </el-table-column>
                <el-table-column prop="description" label="描述" />
                <el-table-column prop="createTime" label="时间" width="180" />
              </el-table>
            </div>
          </div>
        </el-card>
      </el-tab-pane>
      
      <el-tab-pane label="我的习题册" name="books">
        <el-card>
          <div class="book-header">
            <el-button type="primary" @click="showCreateDialog">创建习题册</el-button>
          </div>
          
          <h4 class="section-title">我创建的习题册</h4>
          <el-table :data="myBooks" style="width: 100%">
            <el-table-column prop="bookName" label="习题册名称" />
            <el-table-column prop="tag" label="标签" width="100">
              <template #default="{ row }">
                <el-tag v-if="row.tag" type="info" size="small">{{ row.tag }}</el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="bookDesc" label="描述" show-overflow-tooltip />
            <el-table-column prop="price" label="价格" width="100">
              <template #default="{ row }">
                <el-tag :type="row.price && row.price > 0 ? 'warning' : 'success'">
                  {{ row.price && row.price > 0 ? '¥' + row.price : '免费' }}
                </el-tag>
              </template>
            </el-table-column>
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
            <el-table-column label="操作" width="100">
              <template #default="{ row }">
                <el-button type="primary" link @click="handleEditBook(row)">编辑</el-button>
              </template>
            </el-table-column>
          </el-table>
          
          <h4 class="section-title" style="margin-top: 30px;">我购买的习题册</h4>
          <el-table :data="purchasedBooks" style="width: 100%">
            <el-table-column prop="bookName" label="习题册名称" />
            <el-table-column prop="bookDesc" label="描述" show-overflow-tooltip />
            <el-table-column prop="price" label="购买价格" width="100">
              <template #default="{ row }">
                <el-tag type="warning">¥{{ row.price }}</el-tag>
              </template>
            </el-table-column>
            <el-table-column prop="purchaseTime" label="购买时间" width="180" />
            <el-table-column label="操作" width="150">
              <template #default="{ row }">
                <el-button type="primary" link @click="goToExercise(row)">开始刷题</el-button>
              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-tab-pane>
      
      <el-tab-pane label="考试记录" name="exams">
        <el-card>
          <el-table :data="examRecords" style="width: 100%" v-loading="loadingExams">
            <el-table-column prop="id" label="考试编号" width="100" />
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
            <el-table-column label="操作" width="150">
              <template #default="{ row }">
                <el-button type="primary" link @click="viewExamDetail(row)">详情</el-button>

              </template>
            </el-table-column>
          </el-table>
        </el-card>
      </el-tab-pane>
      
      <el-tab-pane label="用户管理" name="users" v-if="userInfo.role === 'admin'">
        <el-card>
          <el-table :data="users" style="width: 100%">
            <el-table-column prop="username" label="用户名" />
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
    
    <el-dialog v-model="bookDialogVisible" :title="isEdit ? '编辑习题册' : '创建习题册'" width="500px">
      <el-form :model="bookForm" label-width="100px" :rules="bookRules" ref="bookFormRef">
        <el-form-item label="习题册名称" prop="bookName">
          <el-input v-model="bookForm.bookName" />
        </el-form-item>
        <el-form-item label="描述" prop="bookDesc">
          <el-input v-model="bookForm.bookDesc" type="textarea" :rows="3" />
        </el-form-item>
        <el-form-item label="标签">
          <el-select 
            v-model="bookForm.tag" 
            placeholder="选择或输入标签" 
            filterable 
            allow-create
            default-first-option
            style="width: 100%"
          >
            <el-option
              v-for="tag in predefinedTags"
              :key="tag"
              :label="tag"
              :value="tag"
            />
          </el-select>
        </el-form-item>
        <el-form-item label="价格">
          <el-input-number 
            v-model="bookForm.price" 
            :min="0" 
            :precision="2" 
            :step="1"
            style="width: 200px;"
          />
          <span style="margin-left: 10px; color: #999;">元（0表示免费）</span>
        </el-form-item>
        <el-form-item label="是否公开">
          <el-switch v-model="bookForm.isPublic" :active-value="1" :inactive-value="0" />
        </el-form-item>
        <el-form-item v-if="isEdit" label="状态">
          <el-tooltip :content="bookForm.status === 1 ? '启用' : '禁用'" placement="top">
            <el-switch 
              v-model="bookForm.status" 
              :active-value="1" 
              :inactive-value="0"
              @change="toggleBookStatus(bookForm)"
            />
          </el-tooltip>
        </el-form-item>
      </el-form>
      <template #footer>
        <div class="dialog-footer">
          <el-button v-if="isEdit" type="primary" @click="goBookManage(bookForm)">管理题目</el-button>
          <el-button v-if="isEdit" type="danger" @click="removeBook(bookForm)">删除</el-button>          
          <el-button @click="bookDialogVisible = false">取消</el-button>
          <el-button type="primary" @click="saveBook" :loading="savingBook">确定</el-button>

        </div>
      </template>
    </el-dialog>
    
    <el-dialog v-model="rechargeDialogVisible" title="充值" width="400px">
      <el-form :model="rechargeForm" label-width="80px" ref="rechargeFormRef">
        <el-form-item label="当前余额">
          <span style="font-size: 18px; color: #409eff; font-weight: bold;">¥{{ wallet?.balance || '0.00' }}</span>
        </el-form-item>
        <el-form-item label="充值金额" prop="amount">
          <el-input-number 
            v-model="rechargeForm.amount" 
            :min="1" 
            :precision="2" 
            :step="10"
            style="width: 200px;"
          />
          <span style="margin-left: 10px; color: #999;">元</span>
        </el-form-item>
        <el-form-item label="快捷金额">
          <el-button-group>
            <el-button @click="rechargeForm.amount = 10">10元</el-button>
            <el-button @click="rechargeForm.amount = 50">50元</el-button>
            <el-button @click="rechargeForm.amount = 100">100元</el-button>
            <el-button @click="rechargeForm.amount = 200">200元</el-button>
          </el-button-group>
        </el-form-item>
      </el-form>
      <template #footer>
        <el-button @click="rechargeDialogVisible = false">取消</el-button>
        <el-button type="primary" @click="confirmRecharge" :loading="recharging">确认充值</el-button>
      </template>
    </el-dialog>
  </div>
</template>

<script setup>
import { ref, reactive, onMounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage, ElMessageBox } from 'element-plus'
import { getUserInfo, updateUserInfo, updatePassword, getUserList, deleteUser } from '@/api/user'
import { getMyBooks, createBook, updateBook, updateBookStatus, deleteBook, getAllBooks, updateBookPrice, getMyPurchases } from '@/api/book'
import { getUserExamRecords } from '@/api/exam'
import { getWallet, recharge as rechargeApi, getTransactions } from '@/api/wallet'
import { useUserStore } from '@/store/user'
import { predefinedTags } from '@/constants/tags'

const router = useRouter()
const userStore = useUserStore()
const activeTab = ref('info')
const saving = ref(false)
const changingPassword = ref(false)
const savingBook = ref(false)
const bookDialogVisible = ref(false)
const isEdit = ref(false)
const rechargeDialogVisible = ref(false)
const recharging = ref(false)

const infoFormRef = ref(null)
const passwordFormRef = ref(null)
const bookFormRef = ref(null)
const rechargeFormRef = ref(null)

const userInfo = reactive({
  id: null,
  username: '',
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
  tag: '',
  isPublic: 1,
  price: 0,
  creatorId: null
})

const myBooks = ref([])
const purchasedBooks = ref([])
const users = ref([])
const allBooks = ref([])
const examRecords = ref([])
const loadingExams = ref(false)
const wallet = ref(null)
const transactions = ref([])

const rechargeForm = reactive({
  amount: 10
})

const rules = {
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
    userInfo.email = userInfo.email || ''
    userInfo.phone = userInfo.phone || ''
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
      email: userInfo.email,
      phone: userInfo.phone
    })
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
    
    const purchasedRes = await getMyPurchases(userStore.userInfo.id)
    purchasedBooks.value = purchasedRes.data
  } catch (error) {
    console.error(error)
  }
}

const showCreateDialog = () => {
  isEdit.value = false
  bookForm.id = null
  bookForm.bookName = ''
  bookForm.bookDesc = ''
  bookForm.tag = ''
  bookForm.isPublic = 1
  bookForm.price = 0
  bookForm.creatorId = userStore.userInfo.id
  bookForm.status = 1
  bookDialogVisible.value = true
}

const handleEditBook = (row) => {
  isEdit.value = true
  bookForm.id = row.id
  bookForm.bookName = row.bookName
  bookForm.bookDesc = row.bookDesc
  bookForm.tag = row.tag
  bookForm.isPublic = row.isPublic
  bookForm.price = row.price
  bookForm.creatorId = row.creatorId
  bookForm.status = row.status
  bookDialogVisible.value = true
}

const saveBook = async () => {
  try {
    await bookFormRef.value.validate()
    savingBook.value = true
    
    if (isEdit.value) {
      await updateBook(bookForm)
      ElMessage.success('更新成功')
    } else {
      await createBook(bookForm)
      ElMessage.success('创建成功')
    }
    
    bookDialogVisible.value = false
    loadMyBooks()
  } catch (error) {
    console.error('保存习题册失败:', error)
    if (error !== false) {
      ElMessage.error(error.response?.data?.message || error.message || '操作失败')
    }
  } finally {
    savingBook.value = false
  }
}

const toggleBookStatus = async (row) => {
  try {
    await updateBookStatus(row.id, row.status)
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

const goToExercise = (row) => {
  router.push(`/exercise/${row.bookId}`)
}

const viewExamDetail = (row) => {
  router.push(`/exam-result/${row.id}`)
}

const retakeExam = (row) => {
  router.push(`/exam/${row.bookId}`)
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
  loadWallet()
})

const loadWallet = async () => {
  try {
    const res = await getWallet(userStore.userInfo.id)
    wallet.value = res.data
    
    const transRes = await getTransactions(userStore.userInfo.id)
    transactions.value = transRes.data
  } catch (error) {
    console.error(error)
  }
}

const showRechargeDialog = () => {
  rechargeForm.amount = 10
  rechargeDialogVisible.value = true
}

const confirmRecharge = async () => {
  if (!rechargeForm.amount || rechargeForm.amount <= 0) {
    ElMessage.warning('请输入有效的充值金额')
    return
  }
  
  try {
    recharging.value = true
    await rechargeApi({
      userId: userStore.userInfo.id,
      amount: rechargeForm.amount
    })
    ElMessage.success('充值成功')
    rechargeDialogVisible.value = false
    await loadWallet()
  } catch (error) {
    ElMessage.error(error.response?.data?.message || '充值失败')
  } finally {
    recharging.value = false
  }
}
</script>

<style scoped lang="scss">
.profile-container {
  max-width: 1000px;
  margin: 0 auto;
  padding: 20px;
  
  @media (max-width: 768px) {
    padding: 10px;
  }
}

.info-card {
  max-width: 500px;
  
  @media (max-width: 768px) {
    max-width: 100%;
  }
}

.book-header {
  margin-bottom: 20px;
  display: flex;
  justify-content: flex-end;
  
  @media (max-width: 768px) {
    margin-bottom: 15px;
  }
}

.section-title {
  margin-bottom: 15px;
  padding-bottom: 10px;
  border-bottom: 1px solid #eee;
  color: #333;
  font-size: 16px;
  
  @media (max-width: 768px) {
    font-size: 15px;
  }
}

.wallet-section {
  .balance-card {
    display: flex;
    justify-content: space-between;
    align-items: center;
    padding: 20px;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border-radius: 12px;
    margin-bottom: 20px;
    
    @media (max-width: 768px) {
      flex-direction: column;
      gap: 15px;
      padding: 15px;
      text-align: center;
    }
    
    .balance-info {
      display: flex;
      flex-direction: column;
      
      .label {
        color: rgba(255, 255, 255, 0.8);
        font-size: 14px;
        margin-bottom: 8px;
      }
      
      .amount {
        color: #fff;
        font-size: 32px;
        font-weight: bold;
        
        @media (max-width: 768px) {
          font-size: 28px;
        }
      }
    }
  }
  
  .transaction-section {
    h4 {
      margin-bottom: 15px;
      font-size: 16px;
      color: #333;
      
      @media (max-width: 768px) {
        font-size: 15px;
      }
    }
  }
  
  .text-success {
    color: #67c23a;
    font-weight: bold;
  }
  
  .text-danger {
    color: #f56c6c;
    font-weight: bold;
  }
}
</style>
