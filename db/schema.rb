# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_06_09_172727) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "progresses", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "topic_id", null: false
    t.integer "score"
    t.datetime "last_attempt"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["topic_id"], name: "index_progresses_on_topic_id"
    t.index ["user_id"], name: "index_progresses_on_user_id"
  end

  create_table "question_attempts", force: :cascade do |t|
    t.bigint "quiz_attempt_id", null: false
    t.bigint "question_id", null: false
    t.string "user_answer"
    t.boolean "is_correct"
    t.integer "time_spent"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["question_id"], name: "index_question_attempts_on_question_id"
    t.index ["quiz_attempt_id"], name: "index_question_attempts_on_quiz_attempt_id"
  end

  create_table "questions", force: :cascade do |t|
    t.text "text"
    t.string "qtype"
    t.string "correct_answer"
    t.text "explanation"
    t.bigint "topic_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "options"
    t.integer "difficulty_level", default: 1, null: false
    t.string "question_type", default: "multiple_choice", null: false
    t.jsonb "metadata", default: {}, null: false
    t.index ["difficulty_level"], name: "index_questions_on_difficulty_level"
    t.index ["metadata"], name: "index_questions_on_metadata", using: :gin
    t.index ["question_type"], name: "index_questions_on_question_type"
    t.index ["topic_id"], name: "index_questions_on_topic_id"
    t.check_constraint "difficulty_level >= 1 AND difficulty_level <= 5", name: "check_difficulty_level"
    t.check_constraint "question_type::text = ANY (ARRAY['multiple_choice'::character varying, 'debugging'::character varying, 'project_based'::character varying]::text[])", name: "check_question_type"
  end

  create_table "quiz_attempts", force: :cascade do |t|
    t.bigint "user_id", null: false
    t.bigint "topic_id", null: false
    t.integer "score"
    t.integer "total_questions"
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["topic_id"], name: "index_quiz_attempts_on_topic_id"
    t.index ["user_id"], name: "index_quiz_attempts_on_user_id"
  end

  create_table "topics", force: :cascade do |t|
    t.string "name"
    t.text "description"
    t.integer "order"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "questions_count", default: 0, null: false
  end

  create_table "users", force: :cascade do |t|
    t.string "email"
    t.string "name"
    t.integer "level"
    t.integer "xp"
    t.string "badges"
    t.string "provider"
    t.string "uid"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "streak"
    t.jsonb "metadata", default: {}, null: false
    t.string "password_digest", null: false
    t.index ["metadata"], name: "index_users_on_metadata", using: :gin
  end

  add_foreign_key "progresses", "topics"
  add_foreign_key "progresses", "users"
  add_foreign_key "question_attempts", "questions"
  add_foreign_key "question_attempts", "quiz_attempts"
  add_foreign_key "questions", "topics"
  add_foreign_key "quiz_attempts", "topics"
  add_foreign_key "quiz_attempts", "users"
end
