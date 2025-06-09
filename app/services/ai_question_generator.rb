class AiQuestionGenerator
  def initialize(topic, difficulty_level: "beginner", question_type: "multiple_choice")
    @topic = topic
    @difficulty_level = difficulty_level
    @question_type = question_type
  end

  def generate
    prompt = build_prompt
    response = client.chat(
      parameters: {
        model: "gpt-4",
        messages: [
          { role: "system", content: system_prompt },
          { role: "user", content: prompt }
        ],
        temperature: 0.7
      }
    )

    parse_response(response.dig("choices", 0, "message", "content"))
  rescue StandardError => e
    Rails.logger.error("AI Question Generation Error: #{e.message}")
    nil
  end

  private

  def client
    @client ||= OpenAI::Client.new
  end

  def system_prompt
    <<~PROMPT
      You are an expert programming quiz generator. Generate questions that are:
      - Clear and unambiguous
      - Appropriate for the specified difficulty level
      - Focused on practical knowledge
      - Include detailed explanations

      Format your response as a JSON object with the following structure:
      {
        "question": "The question text",
        "options": ["Option 1", "Option 2", "Option 3", "Option 4"],
        "correct_answer": "The correct option",
        "explanation": "Detailed explanation of the answer",
        "metadata": {
          "concepts": ["concept1", "concept2"],
          "prerequisites": ["prerequisite1", "prerequisite2"]
        }
      }
    PROMPT
  end

  def build_prompt
    <<~PROMPT
      Generate a #{@difficulty_level} level #{@question_type} question about #{@topic.name}.

      Topic description: #{@topic.description}

      For #{@difficulty_level} level, focus on:
      #{difficulty_guidelines}

      For #{@question_type} type, ensure:
      #{question_type_guidelines}
    PROMPT
  end

  def difficulty_guidelines
    case @difficulty_level
    when "beginner"
      "- Basic concepts and syntax\n- Simple problem-solving\n- Common use cases"
    when "intermediate"
      "- More complex concepts\n- Multiple concepts combined\n- Edge cases"
    when "advanced"
      "- Advanced language features\n- Performance considerations\n- Best practices"
    when "expert"
      "- Complex scenarios\n- Optimization techniques\n- Design patterns"
    when "master"
      "- Cutting-edge features\n- Advanced architecture\n- System design"
    end
  end

  def question_type_guidelines
    case @question_type
    when "multiple_choice"
      "- 4 distinct options\n- One clearly correct answer\n- Plausible distractors"
    when "debugging"
      "- Code snippet with bugs\n- Multiple issues to identify\n- Clear error patterns"
    when "project_based"
      "- Real-world scenario\n- Multiple steps to solve\n- Practical implementation"
    end
  end

  def parse_response(content)
    return nil unless content.present?

    JSON.parse(content)
  rescue JSON::ParserError => e
    Rails.logger.error("Failed to parse AI response: #{e.message}")
    nil
  end
end
