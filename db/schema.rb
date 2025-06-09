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

ActiveRecord::Schema[8.0].define(version: 2025_06_09_115629) do
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

  create_table "questions", force: :cascade do |t|
    t.text "text"
    t.string "qtype"
    t.string "correct_answer"
    t.text "explanation"
    t.bigint "topic_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.jsonb "options"
    t.index ["topic_id"], name: "index_questions_on_topic_id"
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
  end

  add_foreign_key "progresses", "topics"
  add_foreign_key "progresses", "users"
  add_foreign_key "questions", "topics"
  add_foreign_key "quiz_attempts", "topics"
  add_foreign_key "quiz_attempts", "users"
end
