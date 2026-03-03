<template>
  <div class="login-container">
    <div class="login-content">
      <div class="rick-wrapper">
        <div class="rick" :class="{ 'shake-head': isShakingHead }">
          <div class="backhairs"></div>
          <div class="hairs"></div>
          <div class="body">
            <div class="belt"></div>
            <div class="pants"></div>
            <div class="shirtLeft"></div>
            <div class="shirtRight"></div>
            <div class="leftArm" :class="{ 'cover-eyes': isPasswordFocused }"></div>
            <div class="rightArm" :class="{ 'cover-eyes': isPasswordFocused }"></div>
            <div class="shoes">
              <div class="leftShoe"></div>
              <div class="rightShoe"></div>
            </div>
          </div>
          <div class="head">
            <div class="eyes" :class="{ 'closed': isPasswordFocused }">
              <div class="left-eye">
                <div class="eyelid" ref="leftEyelid"></div>
                <div class="pupil" ref="leftPupil"></div>
              </div>
              <div class="right-eye">
                <div class="eyelid" ref="rightEyelid"></div>
                <div class="pupil" ref="rightPupil"></div>
              </div>
              
              <div class="closed-eyes" v-if="isPasswordFocused">
                <div class="closed-line left"></div>
                <div class="closed-line right"></div>
              </div>
            </div>
            <div class="mouth">
              <div class="olip">
                <div class="lip"></div>
                <div class="dribble"></div>
                <div class="dribble2"></div>
              </div>
            </div>
          </div>
        </div>
      </div>
      
      <div class="login-box">
        <h2 class="title">{{ currentTitle }}</h2>
        
        <el-form :model="form" :rules="rules" ref="formRef" class="login-form" v-if="currentMode === 'login'">
          <el-form-item prop="username">
            <el-input 
              v-model="form.username" 
              placeholder="请输入用户名" 
              prefix-icon="User" 
              size="large" 
              @focus="handleUsernameFocus"
              @blur="handleUsernameBlur"
            />
          </el-form-item>
          <el-form-item prop="password">
            <el-input 
              v-model="form.password" 
              type="password" 
              placeholder="请输入密码" 
              prefix-icon="Lock" 
              size="large" 
              show-password 
              @keyup.enter="handleLogin"
              @focus="handlePasswordFocus"
              @blur="handlePasswordBlur"
            />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" size="large" :loading="loading" @click="handleLogin" class="login-btn">登录</el-button>
          </el-form-item>
        </el-form>

        <el-form :model="registerForm" :rules="registerRules" ref="registerFormRef" class="login-form" v-else-if="currentMode === 'register'">
          <el-form-item prop="username">
            <el-input 
              v-model="registerForm.username" 
              placeholder="请输入用户名" 
              prefix-icon="User" 
              size="large" 
            />
          </el-form-item>
          <el-form-item prop="email">
            <el-input 
              v-model="registerForm.email" 
              placeholder="请输入邮箱" 
              prefix-icon="Message" 
              size="large" 
            />
          </el-form-item>
          <el-form-item prop="code">
            <div class="code-input-wrapper">
              <el-input 
                v-model="registerForm.code" 
                placeholder="请输入验证码" 
                prefix-icon="Key" 
                size="large" 
              />
              <el-button 
                type="primary" 
                size="large" 
                :disabled="registerCodeCountdown > 0"
                @click="sendRegisterCode"
                class="code-btn"
              >
                {{ registerCodeCountdown > 0 ? `${registerCodeCountdown}s` : '获取验证码' }}
              </el-button>
            </div>
          </el-form-item>
          <el-form-item prop="password">
            <el-input 
              v-model="registerForm.password" 
              type="password" 
              placeholder="请输入密码" 
              prefix-icon="Lock" 
              size="large" 
              show-password
            />
          </el-form-item>
          <el-form-item prop="confirmPassword">
            <el-input 
              v-model="registerForm.confirmPassword" 
              type="password" 
              placeholder="请确认密码" 
              prefix-icon="Lock" 
              size="large" 
              show-password
              @keyup.enter="handleRegister"
            />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" size="large" :loading="loading" @click="handleRegister" class="login-btn">注册</el-button>
          </el-form-item>
        </el-form>

        <el-form :model="forgotForm" :rules="forgotRules" ref="forgotFormRef" class="login-form" v-else-if="currentMode === 'forgot'">
          <el-form-item prop="email">
            <el-input 
              v-model="forgotForm.email" 
              placeholder="请输入注册邮箱" 
              prefix-icon="Message" 
              size="large" 
            />
          </el-form-item>
          <el-form-item prop="code">
            <div class="code-input-wrapper">
              <el-input 
                v-model="forgotForm.code" 
                placeholder="请输入验证码" 
                prefix-icon="Key" 
                size="large" 
                @keyup.enter="handleVerifyCode"
              />
              <el-button 
                type="primary" 
                size="large" 
                :disabled="codeCountdown > 0"
                @click="sendCode"
                class="code-btn"
              >
                {{ codeCountdown > 0 ? `${codeCountdown}s` : '获取验证码' }}
              </el-button>
            </div>
          </el-form-item>
          <el-form-item prop="newPassword">
            <el-input 
              v-model="forgotForm.newPassword" 
              type="password" 
              placeholder="请输入新密码" 
              prefix-icon="Lock" 
              size="large" 
              show-password
              @keyup.enter="handleResetPassword"
            />
          </el-form-item>
          <el-form-item>
            <el-button type="primary" size="large" :loading="loading" @click="handleResetPassword" class="login-btn">重置密码</el-button>
          </el-form-item>
        </el-form>

        <div class="mode-switch">
          <template v-if="currentMode === 'login'">
            <span class="switch-text">还没有账号？</span>
            <el-button type="primary" link @click="switchMode('register')">立即注册</el-button>
            <span class="divider">|</span>
            <el-button type="primary" link @click="switchMode('forgot')">忘记密码？</el-button>
          </template>
          <template v-else-if="currentMode === 'register'">
            <span class="switch-text">已有账号？</span>
            <el-button type="primary" link @click="switchMode('login')">立即登录</el-button>
          </template>
          <template v-else>
            <span class="switch-text">想起密码？</span>
            <el-button type="primary" link @click="switchMode('login')">立即登录</el-button>
            <span class="divider">|</span>
            <el-button type="primary" link @click="switchMode('register')">立即注册</el-button>
          </template>
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
import { ref, reactive, computed, onMounted, onUnmounted } from 'vue'
import { useRouter } from 'vue-router'
import { ElMessage } from 'element-plus'
import { useUserStore } from '@/store/user'
import { register, sendVerifyCode, resetPasswordByEmail } from '@/api/user'

const router = useRouter()
const userStore = useUserStore()
const formRef = ref(null)
const registerFormRef = ref(null)
const forgotFormRef = ref(null)
const loading = ref(false)
const isPasswordFocused = ref(false)
const isShakingHead = ref(false)
const rightPupil = ref(null)
const leftPupil = ref(null)
const leftEyelid = ref(null)
const rightEyelid = ref(null)
const currentMode = ref('login')
const codeCountdown = ref(0)
const registerCodeCountdown = ref(0)

const currentTitle = computed(() => {
  switch (currentMode.value) {
    case 'register': return '用户注册'
    case 'forgot': return '忘记密码'
    default: return '习题册刷题系统'
  }
})

const form = reactive({
  username: '',
  password: ''
})

const registerForm = reactive({
  username: '',
  email: '',
  code: '',
  password: '',
  confirmPassword: ''
})

const forgotForm = reactive({
  email: '',
  code: '',
  newPassword: ''
})

const validateConfirmPassword = (rule, value, callback) => {
  if (value !== registerForm.password) {
    callback(new Error('两次输入的密码不一致'))
  } else {
    callback()
  }
}

const rules = {
  username: [{ required: true, message: '请输入用户名', trigger: 'blur' }],
  password: [{ required: true, message: '请输入密码', trigger: 'blur' }]
}

const registerRules = {
  username: [
    { required: true, message: '请输入用户名', trigger: 'blur' },
    { min: 3, max: 20, message: '用户名长度在 3 到 20 个字符', trigger: 'blur' }
  ],
  email: [
    { required: true, message: '请输入邮箱', trigger: 'blur' },
    { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }
  ],
  code: [{ required: true, message: '请输入验证码', trigger: 'blur' }],
  password: [
    { required: true, message: '请输入密码', trigger: 'blur' },
    { min: 6, message: '密码长度不能少于 6 位', trigger: 'blur' }
  ],
  confirmPassword: [
    { required: true, message: '请确认密码', trigger: 'blur' },
    { validator: validateConfirmPassword, trigger: 'blur' }
  ]
}

const forgotRules = {
  email: [
    { required: true, message: '请输入邮箱', trigger: 'blur' },
    { type: 'email', message: '请输入正确的邮箱格式', trigger: 'blur' }
  ],
  code: [{ required: true, message: '请输入验证码', trigger: 'blur' }],
  newPassword: [
    { required: true, message: '请输入新密码', trigger: 'blur' },
    { min: 6, message: '密码长度不能少于 6 位', trigger: 'blur' }
  ]
}

const switchMode = (mode) => {
  currentMode.value = mode
  resetForms()
}

const resetForms = () => {
  if (formRef.value) formRef.value.resetFields()
  if (registerFormRef.value) registerFormRef.value.resetFields()
  if (forgotFormRef.value) forgotFormRef.value.resetFields()
}

const handleUsernameFocus = () => {
  isPasswordFocused.value = false
}

const handleUsernameBlur = () => {
  
}

const handlePasswordFocus = () => {
  isPasswordFocused.value = true
}

const handlePasswordBlur = () => {
  isPasswordFocused.value = false
}

const handleMouseMove = (event) => {
  if (isPasswordFocused.value) return
  
  const eyes = document.querySelectorAll('.left-eye, .right-eye')
  
  eyes.forEach((eye) => {
    const pupil = eye.querySelector('.pupil')
    const eyelid = eye.querySelector('.eyelid')
    if (!pupil || !eyelid) return
    
    const rect = eye.getBoundingClientRect()
    const eyeCenterX = rect.left + rect.width / 2
    const eyeCenterY = rect.top + rect.height / 2
    
    const deltaX = event.clientX - eyeCenterX
    const deltaY = event.clientY - eyeCenterY
    
    const angle = Math.atan2(deltaY, deltaX)
    const distance = Math.min(Math.sqrt(deltaX * deltaX + deltaY * deltaY), 25)
    
    const pupilX = Math.cos(angle) * distance
    const pupilY = Math.sin(angle) * distance
    
    pupil.style.transform = `translate(calc(-50% + ${pupilX}px), calc(-50% + ${pupilY}px))`
    
    if (pupilY < 0) {
      const eyelidOffset = Math.min(Math.abs(pupilY), 20)
      eyelid.style.transform = `translateY(-${eyelidOffset}px)`
    } else {
      eyelid.style.transform = 'translateY(0)'
    }
  })
}

onMounted(() => {
  document.addEventListener('mousemove', handleMouseMove)
})

onUnmounted(() => {
  document.removeEventListener('mousemove', handleMouseMove)
})

const handleLogin = async () => {
  const valid = await formRef.value.validate().catch(() => false)
  if (!valid) return
  
  loading.value = true
  try {
    await userStore.login(form.username, form.password)
    ElMessage.success('登录成功')
    router.push('/home')
  } catch (error) {
    console.error(error)
    isShakingHead.value = true
    setTimeout(() => {
      isShakingHead.value = false
    }, 600)
  } finally {
    loading.value = false
  }
}

const handleRegister = async () => {
  const valid = await registerFormRef.value.validate().catch(() => false)
  if (!valid) return
  
  loading.value = true
  try {
    await register({
      username: registerForm.username,
      email: registerForm.email,
      code: registerForm.code,
      password: registerForm.password
    })
    ElMessage.success('注册成功，请登录')
    switchMode('login')
  } catch (error) {
    console.error(error)
    ElMessage.error(error.message || '注册失败')
  } finally {
    loading.value = false
  }
}

const sendCode = async () => {
  const valid = await forgotFormRef.value.validateField('email').catch(() => false)
  if (!valid) return
  
  try {
    await sendVerifyCode({ email: forgotForm.email, type: 'forgot' })
    ElMessage.success('验证码已发送到您的邮箱')
    codeCountdown.value = 60
    const timer = setInterval(() => {
      codeCountdown.value--
      if (codeCountdown.value <= 0) {
        clearInterval(timer)
      }
    }, 1000)
  } catch (error) {
    console.error(error)
    ElMessage.error(error.message || '发送验证码失败')
  }
}

const sendRegisterCode = async () => {
  const valid = await registerFormRef.value.validateField('email').catch(() => false)
  if (!valid) return
  
  try {
    await sendVerifyCode({ email: registerForm.email, type: 'register' })
    ElMessage.success('验证码已发送到您的邮箱')
    registerCodeCountdown.value = 60
    const timer = setInterval(() => {
      registerCodeCountdown.value--
      if (registerCodeCountdown.value <= 0) {
        clearInterval(timer)
      }
    }, 1000)
  } catch (error) {
    console.error(error)
    ElMessage.error(error.message || '发送验证码失败')
  }
}

const handleVerifyCode = () => {
  
}

const handleResetPassword = async () => {
  const valid = await forgotFormRef.value.validate().catch(() => false)
  if (!valid) return
  
  loading.value = true
  try {
    await resetPasswordByEmail({
      email: forgotForm.email,
      code: forgotForm.code,
      newPassword: forgotForm.newPassword
    })
    ElMessage.success('密码重置成功，请使用新密码登录')
    switchMode('login')
  } catch (error) {
    console.error(error)
    ElMessage.error(error.message || '密码重置失败')
  } finally {
    loading.value = false
  }
}

</script>

<style scoped lang="scss">
.login-container {
  min-height: 100vh;
  display: flex;
  justify-content: center;
  align-items: center;
  background-color: #aa8eff;
  padding: 20px;
}

.login-content {
  display: flex;
  align-items: center;
  gap: 40px;
  background: rgba(255, 255, 255, 0.95);
  padding: 40px 60px;
  border-radius: 20px;
  box-shadow: 0 20px 60px rgba(0, 0, 0, 0.3);
  max-width: 1100px;
  width: 100%;
}

.rick-wrapper {
  flex-shrink: 0;
  width: 200px;
  height: 300px;
  display: flex;
  align-items: center;
  justify-content: center;
}

@keyframes shakeHead {
  0%, 100% { transform: scale(0.5) rotate(0deg); }
  10% { transform: scale(0.5) rotate(-8deg); }
  20% { transform: scale(0.5) rotate(8deg); }
  30% { transform: scale(0.5) rotate(-8deg); }
  40% { transform: scale(0.5) rotate(8deg); }
  50% { transform: scale(0.5) rotate(-6deg); }
  60% { transform: scale(0.5) rotate(6deg); }
  70% { transform: scale(0.5) rotate(-4deg); }
  80% { transform: scale(0.5) rotate(4deg); }
  90% { transform: scale(0.5) rotate(-2deg); }
}

.rick {
  position: relative;
  width: 400px;
  height: 600px;
  transform: scale(0.5);
  transform-origin: center center;
  
  &.shake-head {
    animation: shakeHead 0.6s ease-in-out;
  }
  
  .head {
    position: absolute;
    left: 50%;
    transform: translateX(-50%);
    top: 115px;
    width: 10rem;
    height: 280px;
    background-color: #DDD8D0;
    border-radius: 200px;
    border-width: 2px;
    border-color: #333f42;
    border-style: solid;
    z-index: 0;
    
    &:after {
      content: '';
      position: absolute;
      background: #bae0f0;
      height: 10px;
      width: 100px;
      top: 45px;
      left: 30px;
      border: solid 2px #333f42;
      border-radius: 100px;
    }
    
    &:before {
      content: '';
      position: absolute;
      height: 40px;
      width: 25px;
      background: #ddd8d0;
      border: solid 2px #333f42;
      border-bottom-right-radius: 50px;
      border-top-right-radius: 50px;
      border-left: 0;
      right: -20px;
      top: 150px;
    }
    
    .eyes {
      position: absolute;
      top: 25%;
      left: 0px;
      width: 100%;
      height: 80px;
      display: flex;
      justify-content: center;
      gap: 0;
      
      &.closed {
        .right-eye, .left-eye {
          opacity: 0;
        }
      }
      
      .right-eye, .left-eye {
        position: relative;
        box-sizing: border-box;
        width: 80px;
        height: 80px;
        border-radius: 50%;
        border: 2px solid #333f42;
        background-color: #fff;
        overflow: hidden;
        
        .eyelid {
          position: absolute;
          box-sizing: border-box;
          width: 76px;
          height: 40px;
          background: #ddd8d0;
          border-top-left-radius: 50px;
          border-top-right-radius: 50px;
          border-bottom: solid 2px #333f42;
          top: 0;
          left: 0;
          z-index: 1;
          transition: transform 0.08s ease-out;
        }
        
        .pupil {
          position: absolute;
          box-sizing: border-box;
          width: 6px;
          height: 6px;
          background: #333f42;
          border-radius: 50%;
          z-index: 2;
          left: 50%;
          top: 60%;
          transform: translate(-50%, -50%);
          transition: transform 0.08s ease-out;
        }
      }
      
      .closed-eyes {
        position: absolute;
        top: 0;
        left: 0;
        width: 100%;
        height: 100%;
        z-index: 10;
        
        .closed-line {
          position: absolute;
          width: 76px;
          height: 3px;
          background: #333f42;
          top: 38px;
          border-radius: 3px;
          
          &.left {
            left: 2px;
          }
          
          &.right {
            left: 82px;
          }
        }
      }
    }
    
    .mouth {
      position: absolute;
      left: 0;
      right: 0;
      margin: 0 auto;
      height: 20px;
      width: 80%;
      border: 2px solid #333f42;
      border-radius: 50px;
      bottom: 50px;
      
      &:before {
        content: '';
        position: absolute;
        width: 80%;
        height: 30px;
        top: -5px;
        left: 50%;
        transform: translateX(-50%);
        background-color: #DDD8D0;
      }
      
      .olip {
        position: relative;
        height: 40px;
        width: 80px;
        overflow: hidden;
        top: 5px;
        left: 20%;
        
        .lip {
          position: absolute;
          left: -60px;
          width: 200px;
          height: 100px;
          border-top-left-radius: 50%;
          border-top-right-radius: 50%;
          border-bottom: 0;
          border: solid 2px #333f42;
          z-index: 99;
        }
        
        .dribble {
          position: absolute;
          background: #d2edc9;
          width: 30px;
          height: 18px;
          border: solid 2px #333f42;
          top: 0px;
          left: 30px;
          border-top-left-radius: 1px;
          border-top-right-radius: 8px;
          border-bottom-left-radius: 5px;
          border-bottom-right-radius: 10px;
        }
        
        .dribble2 {
          position: absolute;
          background: #d2edc9;
          width: 7.5px;
          height: 15px;
          border: solid 2px #333f42;
          top: 19px;
          left: 30px;
          border-bottom-left-radius: 5px;
          border-bottom-right-radius: 10px;
          border-top: 0;
        }
      }
    }
  }
  
  .hairs, .backhairs {
    position: absolute;
    left: 50%;
    transform: translateX(-50%);
    top: 94px;
    width: 230px;
    height: 230px;
    background-color: #b1daee;
    
    &:before {
      content: '';
      position: absolute;
      left: 0;
      right: 0;
      width: 100%;
      height: 100%;
      transform: rotate(-60deg);
      background-color: #b1daee;
    }
    
    &:after {
      content: '';
      position: absolute;
      left: 0;
      right: 0;
      width: 100%;
      height: 100%;
      transform: rotate(-120deg);
      background-color: #b1daee;
    }
  }
  
  .backhairs {
    width: 233px;
    height: 233px;
    border: 3px solid #333f42;
    top: 90px;
    
    &:before, &:after {
      border: 3px solid #333f42;
      width: 233px;
      height: 233px;
    }
  }
  
  .body {
    width: 100px;
    height: 200px;
    background-color: #98D5D7;
    position: absolute;
    top: 385px;
    left: 50%;
    transform: translateX(-50%);
    z-index: 60;
    
    .shirtLeft {
      width: 50px;
      height: 250px;
      position: absolute;
      left: -30px;
      background-color: #fff;
      border-top-left-radius: 50px;
      border-bottom-right-radius: 50px;
      border: 2px solid #333f42;
      
      &:before {
        position: absolute;
        content: '';
        border-bottom-left-radius: 100%;
        border-left: 3px solid #666;
        top: 25px;
        right: 0;
        position: absolute;
        background-color: white;
        width: 10px;
        height: 40px;
      }
    }
    
    .shirtRight {
      width: 50px;
      height: 250px;
      position: absolute;
      right: -30px;
      background-color: #fff;
      border-top-right-radius: 50px;
      border-bottom-left-radius: 50px;
      border: 2px solid #333f42;
      
      &:before {
        position: absolute;
        content: '';
        border-bottom-right-radius: 100%;
        border-right: 3px solid #666;
        top: 25px;
        left: 0;
        position: absolute;
        background-color: white;
        width: 10px;
        height: 40px;
      }
    }
    
    .leftArm {
      width: 25px;
      height: 180px;
      position: absolute;
      top: 15px;
      left: -40px;
      background-color: #fff;
      border-top-left-radius: 50px;
      box-shadow: 0px 1px 0px 3px #333f42;
      transform-origin: 13px -35px;
      transition: transform 0.3s ease-in-out;
      z-index: 100;
      
      &.cover-eyes {
        transform: rotate(-170deg) translateX(-15px) translateY(-95px);
      }
      
      &:after {
        position: absolute;
        content: '';
        bottom: -25px;
        left: -5px;
        width: 30px;
        height: 30px;
        border-radius: 50%;
        border: 2px solid #333f42;
        background-color: #DDD8D0;
      }
    }
    
    .rightArm {
      width: 25px;
      height: 180px;
      position: absolute;
      top: 15px;
      right: -40px;
      background-color: #fff;
      border-top-right-radius: 50px;
      box-shadow: 1px -1px 0px 3px #333f42;
      transform-origin: 13px -35px;;
      transition: transform 0.3s ease-in-out;
      z-index: 100;
      
      &.cover-eyes {
        transform: rotate(170deg) translateX(15px) translateY(-95px);
      }
      
      &:after {
        position: absolute;
        content: '';
        bottom: -25px;
        right: -5px;
        width: 30px;
        height: 30px;
        border-radius: 50%;
        border: 2px solid #333f42;
        background-color: #DDD8D0;
      }
    }
    
    .belt {
      position: absolute;
      width: 100px;
      height: 20px;
      background-color: #352909;
      bottom: 0px;
      
      &:after {
        position: absolute;
        content: '';
        width: 20px;
        height: 20px;
        background-color: #FDD62F;
        left: 50%;
        transform: translateX(-50%);
      }
    }
    
    .pants {
      width: 100px;
      height: 40px;
      background-color: #7d6234;
      position: absolute;
      bottom: -40px;
      box-shadow: -20px 8px 0 4px #333f42, 20px 6px 0 4px #333f42;
      
      &:after {
        position: absolute;
        content: '';
        width: 40px;
        height: 100px;
        background-color: #7d6234;
        left: 0;
        bottom: -100px;
      }
      
      &:before {
        position: absolute;
        content: '';
        width: 40px;
        height: 100px;
        background-color: #7d6234;
        right: 0;
        bottom: -100px;
      }
    }
    
    .shoes {
      width: 190px;
      height: 80px;
      position: absolute;
      bottom: -200px;
      left: -45px;
      text-align: center;
      
      .leftShoe {
        position: relative;
        display: inline-block;
        margin-right: 7px;
        width: 80px;
        height: 40px;
        background-color: #444444;
        border-top-left-radius: 100%;
        border-top-right-radius: 10%;
        border-bottom-left-radius: 20%;
        border-bottom-right-radius: 10%;
        
        &:after {
          position: absolute;
          content: '';
          width: 40px;
          height: 15px;
          top: -12px;
          right: 0;
          background-color: #fff;
        }
        
        &:before {
          position: absolute;
          content: '';
          width: 80px;
          height: 3px;
          bottom: 0;
          left: 0;
          background-color: wheat;
        }
      }
      
      .rightShoe {
        position: relative;
        display: inline-block;
        width: 80px;
        height: 40px;
        margin-left: 7px;
        background-color: #444444;
        border-top-right-radius: 100%;
        border-top-left-radius: 10%;
        border-bottom-right-radius: 20%;
        border-bottom-left-radius: 10%;
        
        &:after {
          position: absolute;
          content: '';
          width: 40px;
          height: 15px;
          top: -12px;
          left: 0;
          background-color: #fff;
        }
        
        &:before {
          position: absolute;
          content: '';
          width: 80px;
          height: 3px;
          bottom: 0;
          left: 0;
          background-color: wheat;
        }
      }
    }
  }
}

.login-box {
  flex: 1;
  min-width: 300px;
}

.title {
  text-align: center;
  color: #333;
  margin-bottom: 30px;
  font-size: 28px;
  font-weight: bold;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  -webkit-background-clip: text;
  -webkit-text-fill-color: transparent;
  background-clip: text;
}

.login-form {
  .el-form-item {
    margin-bottom: 24px;
    
    :deep(.el-input__wrapper) {
      border-radius: 8px;
      box-shadow: 0 2px 8px rgba(0, 0, 0, 0.1);
      transition: all 0.3s ease;
      
      &:hover {
        box-shadow: 0 4px 12px rgba(102, 126, 234, 0.2);
      }
      
      &.is-focus {
        box-shadow: 0 4px 12px rgba(102, 126, 234, 0.3);
      }
    }
  }
}

.login-btn {
  width: 100%;
  height: 48px;
  font-size: 16px;
  font-weight: bold;
  border-radius: 8px;
  background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
  border: none;
  
  &:hover {
    transform: translateY(-2px);
    box-shadow: 0 6px 20px rgba(102, 126, 234, 0.4);
  }
}

.mode-switch {
  text-align: center;
  margin-top: 20px;
  
  .switch-text {
    color: #666;
    font-size: 14px;
  }
  
  .divider {
    margin: 0 10px;
    color: #ccc;
  }
  
  .el-button {
    font-size: 14px;
  }
}

.code-input-wrapper {
  display: flex;
  gap: 10px;
  
  .el-input {
    flex: 1;
  }
  
  .code-btn {
    flex-shrink: 0;
    min-width: 100px;
    background: linear-gradient(135deg, #667eea 0%, #764ba2 100%);
    border: none;
    
    &:disabled {
      background: #ccc;
    }
  }
}

@media (max-width: 900px) {
  .login-content {
    flex-direction: column;
    padding: 40px 20px;
    gap: 20px;
  }
  
  .rick-wrapper {
    width: 150px;
    height: 220px;
  }
  
  .rick {
    transform: scale(0.35);
  }
}
</style>
