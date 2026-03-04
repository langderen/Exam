<template>
  <div class="exam-result">
    <el-card v-loading="loading">
      <template #header>
        <div class="header">
          <el-button @click="$router.back()" :icon="ArrowLeft">返回</el-button>
          <h2>考试详情</h2>
        </div>
      </template>
      
      <div class="result-info" v-if="result">
        <div class="score-section">
          <div class="score">{{ result.score }}分</div>
          <div class="stats">
            <p>总题数: {{ result.totalCount }}</p>
            <p>正确数: {{ result.correctCount }}</p>
            <p>正确率: {{ result.totalCount > 0 ? (result.correctCount / result.totalCount * 100).toFixed(1) : 0 }}%</p>
          </div>
        </div>
        
        <div class="detail-section" v-if="result.scoringStatus === 'completed'">
          <h3>答题详情</h3>
          <el-card v-for="(q, index) in result.questions" :key="q.questionId" class="detail-card">
            <div class="detail-header">
              <span class="question-num">第 {{ index + 1 }} 题</span>
              <el-tag :type="q.isCorrect ? 'success' : 'danger'">
                {{ q.isCorrect ? '正确' : '错误' }}
              </el-tag>
              <el-tag v-if="q.aiScoring === 1" type="warning" style="margin-left: 5px;">
                AI评分: {{ q.aiScore }}分
              </el-tag>
            </div>
            <p class="question-content">{{ q.content }}</p>
            <div class="options" v-if="q.options">
              <div v-for="opt in parseOptions(q.options)" :key="opt" class="option-item">
                <span :class="{
                  'correct-answer': getOptionKey(opt) === q.correctAnswer,
                  'user-answer': getOptionKey(opt) === q.userAnswer && getOptionKey(opt) !== q.correctAnswer
                }">
                  {{ opt }}
                </span>
              </div>
            </div>
            <div class="answer-compare">
              <p><strong>正确答案:</strong> {{ q.correctAnswer }}</p>
              <p><strong>您的答案:</strong> {{ q.userAnswer || '未作答' }}</p>
            </div>
            <div class="analysis" v-if="q.analysis">
              <p><strong>解析:</strong> {{ q.analysis }}</p>
            </div>
            <div class="ai-comment" v-if="q.aiScoring === 1 && q.aiComment">
              <el-collapse>
                <el-collapse-item title="AI评分详情" name="ai">
                  <div class="ai-comment-content">{{ q.aiComment }}</div>
                </el-collapse-item>
              </el-collapse>
            </div>
          </el-card>
        </div>
        
        <div class="scoring-pending" v-else>
          <el-icon class="is-loading" :size="48"><Loading /></el-icon>
          <p>正在判卷中，请稍候...</p>
          <el-button type="primary" @click="loadResult">刷新</el-button>
        </div>
      </div>
    </el-card>
  </div>
</template>

<script setup>
import { ref, onMounted } from 'vue'
import { useRoute, useRouter } from 'vue-router'
import { ArrowLeft, Loading } from '@element-plus/icons-vue'
import { getExamResult } from '@/api/exam'

const route = useRoute()
const router = useRouter()
const result = ref(null)
const loading = ref(false)

onMounted(async () => {
  await loadResult()
})

const loadResult = async () => {
  loading.value = true
  try {
    const res = await getExamResult(route.params.examId)
    result.value = res.data
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

const getOptionKey = (opt) => {
  const match = opt.match(/^([A-Z])\./)
  return match ? match[1] : opt
}
</script>

<style scoped lang="scss">
.exam-result {
  .header {
    display: flex;
    align-items: center;
    gap: 15px;
    
    h2 {
      margin: 0;
      font-size: 18px;
    }
  }
  
  .result-info {
    .score-section {
      text-align: center;
      padding: 30px;
      background: #f5f7fa;
      border-radius: 8px;
      margin-bottom: 30px;
      
      .score {
        font-size: 48px;
        font-weight: bold;
        color: #409eff;
        margin-bottom: 15px;
      }
      
      .stats p {
        color: #666;
        margin: 5px 0;
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
        font-size: 15px;
        line-height: 1.6;
        color: #333;
        margin-bottom: 15px;
      }
      
      .options {
        margin-bottom: 15px;
        
        .option-item {
          margin-bottom: 8px;
          
          .correct-answer {
            color: #67c23a;
            font-weight: bold;
          }
          
          .user-answer {
            color: #f56c6c;
          }
        }
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
      
      .ai-comment {
        margin-top: 10px;
        
        .ai-comment-content {
          white-space: pre-wrap;
          line-height: 1.6;
          color: #666;
        }
      }
    }
    
    .scoring-pending {
      text-align: center;
      padding: 50px;
      
      .el-icon {
        color: #409eff;
        margin-bottom: 15px;
      }
      
      p {
        color: #666;
        margin-bottom: 20px;
      }
    }
  }
}
</style>
