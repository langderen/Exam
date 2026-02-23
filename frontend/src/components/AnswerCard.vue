<template>
  <div class="answer-card" :class="mode">
    <div v-if="total === 0" class="empty-tip">暂无题目</div>
    <div v-else class="answer-card-content">
      <div class="answer-card-items" :class="{ 'scrollable': total > 20 }">
        <div
          v-for="seq in total"
          :key="seq"
          class="answer-card-item"
          :class="getItemClass(seq)"
          :title="`第 ${seq} 题`"
          @click="handleJump(seq)"
        >
          {{ seq }}
        </div>
      </div>
    </div>
  </div>
</template>

<script setup>
const props = defineProps({
  mode: {
    type: String,
    default: 'practice',
    validator: (value) => ['practice', 'exam'].includes(value)
  },
  total: {
    type: Number,
    default: 0
  },
  statusList: {
    type: Array,
    default: () => []
  },
  currentSeq: {
    type: Number,
    default: 0
  }
})

const emit = defineEmits(['jump'])

const getItemClass = (seq) => {
  const classes = []
  
  const status = props.statusList.find(s => s.questionSeq === seq || s.question_seq === seq)
  
  if (seq === props.currentSeq) {
    classes.push('current')
  }
  
  if (!status) {
    classes.push('unanswered')
  } else if (status.isAnswered === 1 || status.is_answered === 1) {
    if (props.mode === 'exam') {
      classes.push('answered')
    } else {
      if (status.isCorrect === 1 || status.is_correct === 1) {
        classes.push('correct')
      } else if (status.isCorrect === 0 || status.is_correct === 0) {
        classes.push('wrong')
      } else {
        classes.push('answered')
      }
    }
  } else {
    classes.push('unanswered')
  }
  
  return classes
}

const handleJump = (seq) => {
  emit('jump', seq)
}
</script>

<style scoped lang="scss">
.answer-card {
  background: #fff;
  border-radius: 8px;
  padding: 16px;
  
  &.practice {
    .answer-card-items {
      display: flex;
      flex-wrap: wrap;
      gap: 8px;
      
      &.scrollable {
        max-height: 200px;
        overflow-y: auto;
      }
    }
  }
  
  &.exam {
    .answer-card-items {
      display: flex;
      flex-wrap: wrap;
      gap: 8px;
      
      &.scrollable {
        max-height: 400px;
        overflow-y: auto;
      }
    }
  }
}

.empty-tip {
  text-align: center;
  color: #999;
  padding: 20px;
}

.answer-card-item {
  width: 36px;
  height: 36px;
  display: flex;
  align-items: center;
  justify-content: center;
  border-radius: 4px;
  font-size: 14px;
  font-weight: 500;
  cursor: pointer;
  transition: all 0.3s;
  user-select: none;
  
  &:hover {
    transform: scale(1.1);
  }
  
  &.unanswered {
    background: #e4e7ed;
    color: #606266;
  }
  
  &.answered {
    background: #409eff;
    color: #fff;
  }
  
  &.correct {
    background: #67c23a;
    color: #fff;
  }
  
  &.wrong {
    background: #f56c6c;
    color: #fff;
  }
  
  &.current {
    border: 2px solid #e6a23c;
    box-shadow: 0 0 8px rgba(230, 162, 60, 0.5);
  }
}
</style>
