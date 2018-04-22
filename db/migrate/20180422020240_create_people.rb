class CreatePeople < ActiveRecord::Migration[5.2]
  def change
    create_table :people do |t|
      t.boolean   :is_juridica,   index: true,              null: false
      t.string    :cpf_cnpj,      index: {unique: true},    null: false
      t.string    :name,                                    null: false
      t.string    :fantasy_name
      t.date      :born_at

      t.timestamps
    end
  end
end
