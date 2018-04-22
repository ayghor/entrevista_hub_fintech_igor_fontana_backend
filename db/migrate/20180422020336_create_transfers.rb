class CreateTransfers < ActiveRecord::Migration[5.2]
  def change
    create_table :transfers do |t|
      t.boolean     :is_child,      index: true,                          null: false
      t.boolean     :is_reversal,   index: true,                          null: false
      t.references  :reverse,       foreign_key: {to_table: :transfers}
      t.string      :code
      t.references  :from,          foreign_key: {to_table: :accounts},   null: false
      t.references  :to,            foreign_key: {to_table: :accounts},   null: false
      t.decimal     :amount,        precision: 8, scale: 2,               null: false

      t.index %i(is_reversal code), unique: true

      t.timestamps
    end
  end
end
