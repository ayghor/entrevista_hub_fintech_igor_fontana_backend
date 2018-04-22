class CreateAccounts < ActiveRecord::Migration[5.2]
  def change
    create_table :accounts do |t|
      t.boolean     :is_child,        index: true,                          null: false
      t.boolean     :is_blocked,      index: true,                          null: false,  default: false
      t.boolean     :is_canceled,     index: true,                          null: false,  default: false
      t.references  :root,            foreign_key: {to_table: :accounts}
      t.references  :parent,          foreign_key: {to_table: :accounts}
      t.references  :owner,           foreign_key: {to_table: :people},     null: false
      t.string      :name,            index: {unique: true},                null: false
      t.decimal     :amount,          precision: 8, scale: 2,               null: false,  default: 0

      t.timestamps
    end
  end
end
