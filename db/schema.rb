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

ActiveRecord::Schema.define(version: 2018_04_23_121405) do

  create_table "accounts", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.boolean "is_child", null: false
    t.boolean "is_blocked", default: false, null: false
    t.boolean "is_canceled", default: false, null: false
    t.bigint "root_id"
    t.bigint "parent_id"
    t.bigint "owner_id", null: false
    t.string "name", null: false
    t.decimal "amount", precision: 8, scale: 2, default: "0.0", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["is_blocked"], name: "index_accounts_on_is_blocked"
    t.index ["is_canceled"], name: "index_accounts_on_is_canceled"
    t.index ["is_child"], name: "index_accounts_on_is_child"
    t.index ["name"], name: "index_accounts_on_name", unique: true
    t.index ["owner_id"], name: "index_accounts_on_owner_id"
    t.index ["parent_id"], name: "index_accounts_on_parent_id"
    t.index ["root_id"], name: "index_accounts_on_root_id"
  end

  create_table "people", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.boolean "is_juridica", null: false
    t.string "cpf_cnpj", null: false
    t.string "name", null: false
    t.string "fantasy_name"
    t.date "born_at"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["cpf_cnpj"], name: "index_people_on_cpf_cnpj", unique: true
    t.index ["is_juridica"], name: "index_people_on_is_juridica"
  end

  create_table "transfers", options: "ENGINE=InnoDB DEFAULT CHARSET=utf8", force: :cascade do |t|
    t.boolean "is_aporte", null: false
    t.boolean "is_reversal", null: false
    t.bigint "reverse_id"
    t.string "code"
    t.bigint "from_id", null: false
    t.bigint "to_id", null: false
    t.decimal "amount", precision: 8, scale: 2, null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["from_id"], name: "index_transfers_on_from_id"
    t.index ["is_aporte"], name: "index_transfers_on_is_aporte"
    t.index ["is_reversal", "code"], name: "index_transfers_on_is_reversal_and_code", unique: true
    t.index ["is_reversal"], name: "index_transfers_on_is_reversal"
    t.index ["reverse_id"], name: "index_transfers_on_reverse_id"
    t.index ["to_id"], name: "index_transfers_on_to_id"
  end

  add_foreign_key "accounts", "accounts", column: "parent_id"
  add_foreign_key "accounts", "accounts", column: "root_id"
  add_foreign_key "accounts", "people", column: "owner_id"
  add_foreign_key "transfers", "accounts", column: "from_id"
  add_foreign_key "transfers", "accounts", column: "to_id"
  add_foreign_key "transfers", "transfers", column: "reverse_id"
end
