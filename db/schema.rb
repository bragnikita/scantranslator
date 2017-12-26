# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema.define(version: 20171210080730) do

  create_table "common_groups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name"
    t.bigint "parent_id"
    t.index ["parent_id"], name: "index_common_groups_on_parent_id"
  end

  create_table "common_image_links", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "target_id", null: false
    t.bigint "group_id"
    t.index ["group_id"], name: "index_common_image_links_on_group_id"
    t.index ["target_id"], name: "index_common_image_links_on_target_id"
  end

  create_table "common_images", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "file"
    t.integer "storage", default: 0
    t.boolean "is_using", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "ext_images", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "image"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "folder_id"
    t.index ["folder_id"], name: "index_ext_images_on_folder_id"
  end

  create_table "folders", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.text "description_text"
    t.string "path", null: false
    t.bigint "parent_id"
    t.index ["parent_id"], name: "index_folders_on_parent_id"
  end

  create_table "post_images", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "image"
    t.bigint "user_id"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["user_id"], name: "index_post_images_on_user_id"
  end

  create_table "posts", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "title"
    t.timestamp "publish_date"
    t.integer "status", default: 0
    t.text "content"
    t.string "timestamps"
    t.bigint "owner_id"
    t.index ["owner_id"], name: "index_posts_on_owner_id"
  end

  create_table "scanlet_groups", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.bigint "project_id", null: false
    t.string "name", null: false
    t.integer "index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["project_id"], name: "index_scanlet_groups_on_project_id"
  end

  create_table "scanlet_projects", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", null: false
    t.text "description"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "cover_id"
    t.index ["cover_id"], name: "index_scanlet_projects_on_cover_id"
  end

  create_table "scanlet_scans", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "image", null: false
    t.string "size"
  end

  create_table "scanlet_translations", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.text "translation"
    t.integer "index"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.bigint "scan_id"
    t.bigint "group_id"
    t.index ["group_id"], name: "index_scanlet_translations_on_group_id"
    t.index ["scan_id"], name: "index_scanlet_translations_on_scan_id"
  end

  create_table "taggings", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.integer "tag_id"
    t.string "taggable_type"
    t.integer "taggable_id"
    t.string "tagger_type"
    t.integer "tagger_id"
    t.string "context", limit: 128
    t.datetime "created_at"
    t.index ["context"], name: "index_taggings_on_context"
    t.index ["tag_id", "taggable_id", "taggable_type", "context", "tagger_id", "tagger_type"], name: "taggings_idx", unique: true
    t.index ["tag_id"], name: "index_taggings_on_tag_id"
    t.index ["taggable_id", "taggable_type", "context"], name: "index_taggings_on_taggable_id_and_taggable_type_and_context"
    t.index ["taggable_id", "taggable_type", "tagger_id", "context"], name: "taggings_idy"
    t.index ["taggable_id"], name: "index_taggings_on_taggable_id"
    t.index ["taggable_type"], name: "index_taggings_on_taggable_type"
    t.index ["tagger_id", "tagger_type"], name: "index_taggings_on_tagger_id_and_tagger_type"
    t.index ["tagger_id"], name: "index_taggings_on_tagger_id"
  end

  create_table "tags", id: :integer, force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "name", collation: "utf8_bin"
    t.integer "taggings_count", default: 0
    t.index ["name"], name: "index_tags_on_name", unique: true
  end

  create_table "users", force: :cascade, options: "ENGINE=InnoDB DEFAULT CHARSET=utf8" do |t|
    t.string "login", limit: 50, null: false
    t.string "password", limit: 50, null: false
    t.string "email", limit: 100
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  add_foreign_key "common_groups", "common_groups", column: "parent_id"
  add_foreign_key "common_image_links", "common_groups", column: "group_id"
  add_foreign_key "common_image_links", "common_images", column: "target_id"
  add_foreign_key "ext_images", "folders"
  add_foreign_key "folders", "folders", column: "parent_id"
  add_foreign_key "post_images", "users"
  add_foreign_key "posts", "users", column: "owner_id"
  add_foreign_key "scanlet_projects", "common_image_links", column: "cover_id"
  add_foreign_key "scanlet_translations", "scanlet_groups", column: "group_id"
  add_foreign_key "scanlet_translations", "scanlet_scans", column: "scan_id"
end
