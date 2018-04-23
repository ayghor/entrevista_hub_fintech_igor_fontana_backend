class RenameTransfersIsChildToIsAporte < ActiveRecord::Migration[5.2]
  def change
    rename_column :transfers, :is_child, :is_aporte
    rename_index :transfers, "index_transfers_on_is_child", "index_transfers_on_is_aporte"
  end
end
