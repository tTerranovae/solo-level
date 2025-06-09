class GenerateQuestionsJob < ApplicationJob
  queue_as :default

  def perform(topic_id, count: 5)
    topic = Topic.find(topic_id)
    generator = AiQuestionGenerator.new(topic)

    count.times do
      question_data = generator.generate
      next unless question_data

      Question.create!(
        topic: topic,
        question: question_data['question'],
        options: question_data['options'],
        correct_answer: question_data['correct_answer'],
        explanation: question_data['explanation'],
        difficulty_level: topic.difficulty_level,
        question_type: topic.question_type,
        metadata: question_data['metadata']
      )
    end
  rescue StandardError => e
    Rails.logger.error("Failed to generate questions: #{e.message}")
    raise e
  end
end 