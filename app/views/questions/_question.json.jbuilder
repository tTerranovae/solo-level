json.extract! question, :id, :text, :qtype, :options, :correct_answer, :explanation, :topic_id, :created_at, :updated_at
json.url question_url(question, format: :json)
