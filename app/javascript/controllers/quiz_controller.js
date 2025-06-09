import { Controller } from "@hotwired/stimulus"

export default class extends Controller {
  static targets = ["question", "progressBar", "submitButton"]

  connect() {
    this.startTimes = {}
    this.endTimes = {}
    this.initializeQuestionTiming()
  }

  initializeQuestionTiming() {
    this.questionTargets.forEach(question => {
      const questionId = question.dataset.questionId
      this.startTimes[questionId] = Date.now()
    })
  }

  selectOption(event) {
    const questionContainer = event.target.closest('.question-container')
    const questionId = questionContainer.dataset.questionId
    this.endTimes[questionId] = Date.now()
    
    // Enable the next/submit button
    const nextButton = questionContainer.querySelector('.next-button, .submit-button')
    if (nextButton) {
      nextButton.disabled = false
    }
  }

  nextQuestion(event) {
    event.preventDefault()
    const currentQuestion = event.target.closest('.question-container')
    const nextQuestion = currentQuestion.nextElementSibling
    
    if (nextQuestion) {
      currentQuestion.classList.add('hidden')
      nextQuestion.classList.remove('hidden')
      this.updateProgressBar()
    }
  }

  previousQuestion(event) {
    event.preventDefault()
    const currentQuestion = event.target.closest('.question-container')
    const previousQuestion = currentQuestion.previousElementSibling
    
    if (previousQuestion) {
      currentQuestion.classList.add('hidden')
      previousQuestion.classList.remove('hidden')
      this.updateProgressBar()
    }
  }

  updateProgressBar() {
    const totalQuestions = this.questionTargets.length
    const answeredQuestions = this.questionTargets.filter(q => 
      q.querySelector('input[type="radio"]:checked')
    ).length
    
    const progress = (answeredQuestions / totalQuestions) * 100
    this.progressBarTarget.style.width = `${progress}%`
  }

  async submitQuiz(event) {
    event.preventDefault()
    const form = event.target
    const formData = new FormData(form)
    
    // Add timing data for all questions
    this.questionTargets.forEach(question => {
      const questionId = question.dataset.questionId
      if (!this.endTimes[questionId]) {
        this.endTimes[questionId] = Date.now()
      }
      // Convert milliseconds to seconds before sending
      const startTime = this.startTimes[questionId] || Date.now()
      const endTime = this.endTimes[questionId]
      const timeSpent = Math.round((endTime - startTime) / 1000) // Convert to seconds
      formData.append(`start_times[${questionId}]`, startTime)
      formData.append(`end_times[${questionId}]`, endTime)
      formData.append(`time_spent[${questionId}]`, timeSpent)
    })
    
    try {
      const response = await fetch(form.action, {
        method: 'POST',
        body: formData,
        headers: {
          'X-CSRF-Token': document.querySelector('meta[name="csrf-token"]').content,
          'Accept': 'application/json'
        },
        credentials: 'same-origin'
      })
      
      const data = await response.json()
      
      if (data.success) {
        // Show results directly
        const resultsContainer = document.createElement('div')
        resultsContainer.className = 'quiz-results'
        resultsContainer.innerHTML = `
          <div class="quiz-container">
            <div class="quiz-header">
              <h1 class="quiz-title">Quiz Results</h1>
            </div>
            <div class="results-content">
              <div class="score-display">
                <div class="score-number">
                  ${data.results.score} / ${data.results.total_questions}
                </div>
                <div class="score-percentage">
                  ${Math.round((data.results.score / data.results.total_questions) * 100)}% Score
                </div>
              </div>
              <div class="results-details">
                <div class="result-item">
                  <span class="result-label">Topic:</span>
                  <span class="result-value">${data.results.topic_name}</span>
                </div>
                <div class="result-item">
                  <span class="result-label">Your Level:</span>
                  <span class="result-value">${data.results.user_level}</span>
                </div>
              </div>
              <div class="results-actions">
                <a href="/quizzes" class="action-button primary">Try Another Quiz</a>
                <a href="/progress/${data.results.topic_id}" class="action-button secondary">View Progress</a>
              </div>
            </div>
          </div>
        `
        
        // Replace the quiz form with results
        form.parentElement.replaceWith(resultsContainer)
      } else {
        throw new Error(data.error || 'Failed to submit quiz')
      }
    } catch (error) {
      console.error('Error submitting quiz:', error)
      alert('An error occurred while submitting the quiz. Please try again.')
    }
  }
} 