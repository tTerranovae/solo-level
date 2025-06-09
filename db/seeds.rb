# This file should ensure the existence of records required to run the application in every environment (production,
# development, test). The code here should be idempotent so that it can be executed at any point in every environment.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Example:
#
#   ["Action", "Comedy", "Drama", "Horror"].each do |genre_name|
#     MovieGenre.find_or_create_by!(name: genre_name)
#   end

# Clear existing data
Topic.destroy_all
Question.destroy_all

# Create Topics
python_topic = Topic.create!(name: 'Python Basics', description: 'Learn the fundamentals of Python programming', order: 1)
se_topic = Topic.create!(name: 'Software Engineering', description: 'Master software engineering principles, design patterns, and best practices.', order: 2)

# Create Questions for Python
python_questions = [
  {
    text: 'What is the output of print(2 ** 3)?',
    qtype: 'multiple_choice',
    options: ['6', '8', '5', '7'],
    correct_answer: '8',
    explanation: '2 ** 3 means 2 raised to the power of 3, which equals 8.'
  },
  {
    text: 'Which of the following is a mutable data type in Python?',
    qtype: 'multiple_choice',
    options: ['tuple', 'list', 'string', 'int'],
    correct_answer: 'list',
    explanation: 'Lists are mutable, meaning you can change their contents after creation.'
  },
  {
    text: 'What does the len() function do in Python?',
    qtype: 'multiple_choice',
    options: ['Returns the length of an object', 'Returns the largest item in an iterable', 'Returns the smallest item in an iterable', 'Returns the sum of all items in an iterable'],
    correct_answer: 'Returns the length of an object',
    explanation: 'The len() function returns the number of items in an object.'
  },
  {
    text: 'What is the correct way to create a variable in Python?',
    qtype: 'multiple_choice',
    options: ['var x = 5', 'x = 5', 'let x = 5', 'const x = 5'],
    correct_answer: 'x = 5',
    explanation: 'In Python, variables are created using the assignment operator (=) without any special keywords.'
  },
  {
    text: 'Which of the following is a valid Python list?',
    qtype: 'multiple_choice',
    options: ['[1, 2, 3]', '(1, 2, 3)', '{1, 2, 3}', '<1, 2, 3>'],
    correct_answer: '[1, 2, 3]',
    explanation: 'Python lists are created using square brackets [] and can contain any type of data.'
  }
]

python_questions.each do |q|
  Question.create!(q.merge(topic: python_topic))
end

# Create Questions for Software Engineering
se_questions = [
  {
    text: 'What is the Singleton design pattern?',
    qtype: 'multiple_choice',
    options: ['A pattern that ensures a class has only one instance', 'A pattern that creates a family of related objects', 'A pattern that defines a one-to-many dependency between objects', 'A pattern that encapsulates a request as an object'],
    correct_answer: 'A pattern that ensures a class has only one instance',
    explanation: 'The Singleton pattern restricts the instantiation of a class to one object.'
  },
  {
    text: 'Which of the following is NOT a principle of SOLID?',
    qtype: 'multiple_choice',
    options: ['Single Responsibility Principle', 'Open/Closed Principle', 'Liskov Substitution Principle', 'Global State Principle'],
    correct_answer: 'Global State Principle',
    explanation: 'SOLID principles include Single Responsibility, Open/Closed, Liskov Substitution, Interface Segregation, and Dependency Inversion.'
  },
  {
    text: 'What is the purpose of unit testing?',
    qtype: 'multiple_choice',
    options: ['To test the entire application at once', 'To test individual components in isolation', 'To test the database schema', 'To test the user interface'],
    correct_answer: 'To test individual components in isolation',
    explanation: 'Unit testing focuses on testing individual units or components of the software in isolation.'
  }
]

se_questions.each do |q|
  Question.create!(q.merge(topic: se_topic))
end

puts 'Seeded topics and questions successfully!'
