import { defineStore } from 'pinia'
import { ref } from 'vue'

export const useExerciseStore = defineStore('exercise', () => {
  const currentBook = ref(null)
  const currentQuestion = ref(null)
  const currentIndex = ref(1)
  const mode = ref('sequence')
  const progress = ref({})

  const setBook = (book) => {
    currentBook.value = book
  }

  const setQuestion = (question) => {
    currentQuestion.value = question
  }

  const setIndex = (index) => {
    currentIndex.value = index
  }

  const setMode = (m) => {
    mode.value = m
  }

  const saveProgress = (bookId, index) => {
    progress.value[bookId] = index
    localStorage.setItem('exerciseProgress', JSON.stringify(progress.value))
  }

  const getProgress = (bookId) => {
    const saved = JSON.parse(localStorage.getItem('exerciseProgress') || '{}')
    return saved[bookId] || 1
  }

  return {
    currentBook,
    currentQuestion,
    currentIndex,
    mode,
    progress,
    setBook,
    setQuestion,
    setIndex,
    setMode,
    saveProgress,
    getProgress
  }
})
