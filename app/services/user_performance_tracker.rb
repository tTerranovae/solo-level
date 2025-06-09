class UserPerformanceTracker
  def initialize(user)
    @user = user
  end

  def track_question_performance(question, correct, time_taken)
    performance = {
      correct: correct,
      time_taken: time_taken,
      difficulty_level: question.difficulty_level,
      question_type: question.question_type,
      timestamp: Time.current
    }

    # Store performance in user's metadata
    current_performance = @user.metadata['question_performance'] || []
    current_performance << performance
    @user.metadata['question_performance'] = current_performance.last(100) # Keep last 100 attempts
    @user.save
  end

  def calculate_recommended_difficulty
    return 'beginner' if recent_attempts.empty?

    success_rate = calculate_success_rate
    average_time = calculate_average_time
    current_level = @user.level

    case
    when success_rate >= 0.8 && average_time < 30
      increase_difficulty(current_level)
    when success_rate < 0.4 || average_time > 120
      decrease_difficulty(current_level)
    else
      current_difficulty_level
    end
  end

  def calculate_success_rate
    return 0.0 if recent_attempts.empty?

    correct_attempts = recent_attempts.count { |attempt| attempt['correct'] }
    (correct_attempts.to_f / recent_attempts.size).round(2)
  end

  def calculate_average_time
    return 0 if recent_attempts.empty?

    times = recent_attempts.map { |attempt| attempt['time_taken'] }
    (times.sum.to_f / times.size).round(2)
  end

  def recommended_question_types
    return ['multiple_choice'] if recent_attempts.empty?

    # Group attempts by question type and calculate success rate for each
    type_performance = {}
    recent_attempts.group_by { |attempt| attempt['question_type'] }.each do |type, attempts|
      correct_count = attempts.count { |attempt| attempt['correct'] }
      success_rate = correct_count.to_f / attempts.size
      type_performance[type] = success_rate
    end

    # Select types with success rate >= 0.6
    successful_types = type_performance.select { |_, rate| rate >= 0.6 }.keys
    successful_types.any? ? successful_types : ['multiple_choice']
  end

  private

  def recent_attempts
    @recent_attempts ||= (@user.metadata['question_performance'] || []).last(20)
  end

  def current_difficulty_level
    case @user.level
    when 1..2 then 'beginner'
    when 3..4 then 'intermediate'
    when 5..6 then 'advanced'
    when 7..8 then 'expert'
    else 'master'
    end
  end

  def increase_difficulty(current_level)
    case current_difficulty_level
    when 'beginner' then 'intermediate'
    when 'intermediate' then 'advanced'
    when 'advanced' then 'expert'
    when 'expert' then 'master'
    else 'master'
    end
  end

  def decrease_difficulty(current_level)
    case current_difficulty_level
    when 'master' then 'expert'
    when 'expert' then 'advanced'
    when 'advanced' then 'intermediate'
    when 'intermediate' then 'beginner'
    else 'beginner'
    end
  end
end 