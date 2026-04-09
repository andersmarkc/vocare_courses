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

ActiveRecord::Schema[8.1].define(version: 2026_04_09_110528) do
  # These are extensions that must be enabled in order to support this database
  enable_extension "pg_catalog.plpgsql"

  create_table "active_storage_attachments", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.datetime "created_at", null: false
    t.string "name", null: false
    t.bigint "record_id", null: false
    t.string "record_type", null: false
    t.index ["blob_id"], name: "index_active_storage_attachments_on_blob_id"
    t.index ["record_type", "record_id", "name", "blob_id"], name: "index_active_storage_attachments_uniqueness", unique: true
  end

  create_table "active_storage_blobs", force: :cascade do |t|
    t.bigint "byte_size", null: false
    t.string "checksum"
    t.string "content_type"
    t.datetime "created_at", null: false
    t.string "filename", null: false
    t.string "key", null: false
    t.text "metadata"
    t.string "service_name", null: false
    t.index ["key"], name: "index_active_storage_blobs_on_key", unique: true
  end

  create_table "active_storage_variant_records", force: :cascade do |t|
    t.bigint "blob_id", null: false
    t.string "variation_digest", null: false
    t.index ["blob_id", "variation_digest"], name: "index_active_storage_variant_records_uniqueness", unique: true
  end

  create_table "admin_users", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.string "email", default: "", null: false
    t.string "encrypted_password", default: "", null: false
    t.string "name"
    t.datetime "remember_created_at"
    t.datetime "reset_password_sent_at"
    t.string "reset_password_token"
    t.datetime "updated_at", null: false
    t.index ["email"], name: "index_admin_users_on_email", unique: true
    t.index ["reset_password_token"], name: "index_admin_users_on_reset_password_token", unique: true
  end

  create_table "courses", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "position", default: 0, null: false
    t.boolean "published", default: false, null: false
    t.string "slug", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["slug"], name: "index_courses_on_slug", unique: true
  end

  create_table "customers", force: :cascade do |t|
    t.string "company"
    t.datetime "created_at", null: false
    t.string "email"
    t.string "locale", default: "da", null: false
    t.string "name", null: false
    t.string "phone"
    t.datetime "updated_at", null: false
  end

  create_table "lesson_progresses", force: :cascade do |t|
    t.boolean "completed", default: false, null: false
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.bigint "customer_id", null: false
    t.integer "last_position_seconds", default: 0, null: false
    t.bigint "lesson_id", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id", "lesson_id"], name: "index_lesson_progresses_on_customer_id_and_lesson_id", unique: true
    t.index ["customer_id"], name: "index_lesson_progresses_on_customer_id"
    t.index ["lesson_id"], name: "index_lesson_progresses_on_lesson_id"
  end

  create_table "lessons", force: :cascade do |t|
    t.text "body"
    t.string "content_type", null: false
    t.datetime "created_at", null: false
    t.integer "duration_seconds"
    t.integer "position", null: false
    t.bigint "section_id", null: false
    t.string "slug", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.string "video_url"
    t.index ["section_id", "position"], name: "index_lessons_on_section_id_and_position", unique: true
    t.index ["section_id"], name: "index_lessons_on_section_id"
  end

  create_table "quiz_answers", force: :cascade do |t|
    t.text "ai_evaluation"
    t.integer "ai_score"
    t.datetime "created_at", null: false
    t.datetime "evaluated_at"
    t.boolean "passed", default: false, null: false
    t.bigint "quiz_attempt_id", null: false
    t.bigint "quiz_question_id", null: false
    t.text "student_answer", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_attempt_id", "quiz_question_id"], name: "index_quiz_answers_on_quiz_attempt_id_and_quiz_question_id", unique: true
    t.index ["quiz_attempt_id"], name: "index_quiz_answers_on_quiz_attempt_id"
    t.index ["quiz_question_id"], name: "index_quiz_answers_on_quiz_question_id"
  end

  create_table "quiz_attempts", force: :cascade do |t|
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.bigint "customer_id", null: false
    t.boolean "passed", default: false, null: false
    t.bigint "quiz_id", null: false
    t.integer "score"
    t.datetime "started_at", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id"], name: "index_quiz_attempts_on_customer_id"
    t.index ["quiz_id", "customer_id"], name: "index_quiz_attempts_on_quiz_id_and_customer_id"
    t.index ["quiz_id"], name: "index_quiz_attempts_on_quiz_id"
  end

  create_table "quiz_questions", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "expected_answer", null: false
    t.integer "points", default: 1, null: false
    t.integer "position", null: false
    t.text "question_text", null: false
    t.bigint "quiz_id", null: false
    t.datetime "updated_at", null: false
    t.index ["quiz_id"], name: "index_quiz_questions_on_quiz_id"
  end

  create_table "quizzes", force: :cascade do |t|
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "passing_score", default: 70, null: false
    t.bigint "quizzable_id", null: false
    t.string "quizzable_type", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["quizzable_type", "quizzable_id"], name: "index_quizzes_on_quizzable"
    t.index ["quizzable_type", "quizzable_id"], name: "index_quizzes_on_quizzable_type_and_quizzable_id", unique: true
  end

  create_table "section_progresses", force: :cascade do |t|
    t.boolean "completed", default: false, null: false
    t.datetime "completed_at"
    t.datetime "created_at", null: false
    t.bigint "customer_id", null: false
    t.bigint "section_id", null: false
    t.datetime "updated_at", null: false
    t.index ["customer_id", "section_id"], name: "index_section_progresses_on_customer_id_and_section_id", unique: true
    t.index ["customer_id"], name: "index_section_progresses_on_customer_id"
    t.index ["section_id"], name: "index_section_progresses_on_section_id"
  end

  create_table "sections", force: :cascade do |t|
    t.bigint "course_id", null: false
    t.datetime "created_at", null: false
    t.text "description"
    t.integer "position", null: false
    t.string "slug", null: false
    t.string "title", null: false
    t.datetime "updated_at", null: false
    t.index ["course_id", "position"], name: "index_sections_on_course_id_and_position", unique: true
    t.index ["course_id", "slug"], name: "index_sections_on_course_id_and_slug", unique: true
    t.index ["course_id"], name: "index_sections_on_course_id"
  end

  create_table "tokens", force: :cascade do |t|
    t.datetime "activated_at"
    t.string "code", null: false
    t.datetime "created_at", null: false
    t.bigint "created_by_id", null: false
    t.bigint "customer_id"
    t.datetime "expires_at"
    t.string "label"
    t.datetime "revoked_at"
    t.datetime "updated_at", null: false
    t.index ["code"], name: "index_tokens_on_code", unique: true
    t.index ["customer_id"], name: "index_tokens_on_customer_id"
  end

  add_foreign_key "active_storage_attachments", "active_storage_blobs", column: "blob_id"
  add_foreign_key "active_storage_variant_records", "active_storage_blobs", column: "blob_id"
  add_foreign_key "lesson_progresses", "customers"
  add_foreign_key "lesson_progresses", "lessons"
  add_foreign_key "lessons", "sections"
  add_foreign_key "quiz_answers", "quiz_attempts"
  add_foreign_key "quiz_answers", "quiz_questions"
  add_foreign_key "quiz_attempts", "customers"
  add_foreign_key "quiz_attempts", "quizzes"
  add_foreign_key "quiz_questions", "quizzes"
  add_foreign_key "section_progresses", "customers"
  add_foreign_key "section_progresses", "sections"
  add_foreign_key "sections", "courses"
  add_foreign_key "tokens", "admin_users", column: "created_by_id"
  add_foreign_key "tokens", "customers"
end
