import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["question", "progressBar", "prevButton", "nextButton", "submitButton"]

  connect() {
    this.currentIndex = 0
    this.totalQuestions = this.questionTargets.length
    this.updateNavigation()
    this.updateProgressBar()
  }

  nextQuestion() {
    if (this.currentIndex < this.totalQuestions - 1) {
      this.questionTargets[this.currentIndex].classList.add('hidden')
      this.currentIndex++
      this.questionTargets[this.currentIndex].classList.remove('hidden')
      this.updateNavigation()
      this.updateProgressBar()
    }
  }

  previousQuestion() {
    if (this.currentIndex > 0) {
      this.questionTargets[this.currentIndex].classList.add('hidden')
      this.currentIndex--
      this.questionTargets[this.currentIndex].classList.remove('hidden')
      this.updateNavigation()
      this.updateProgressBar()
    }
  }

  selectOption(event) {
    const questionContainer = event.target.closest('.question-container')
    const selectedOption = event.target.value
    const questionId = event.target.name.replace('question_', '')
    
    // Store the selected answer
    questionContainer.dataset.selectedAnswer = selectedOption
  }

  updateNavigation() {
    // Update Previous button
    this.prevButtonTarget.disabled = this.currentIndex === 0

    // Update Next/Submit buttons
    if (this.currentIndex === this.totalQuestions - 1) {
      this.nextButtonTarget.classList.add('hidden')
      this.submitButtonTarget.classList.remove('hidden')
    } else {
      this.nextButtonTarget.classList.remove('hidden')
      this.submitButtonTarget.classList.add('hidden')
    }
  }

  updateProgressBar() {
    const progress = ((this.currentIndex + 1) / this.totalQuestions) * 100
    this.progressBarTarget.style.width = `${progress}%`
  }
} 