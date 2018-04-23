class InvertTransfersIsAporte < ActiveRecord::Migration[5.2]
  class Transfer < ActiveRecord::Base
  end

  def up
    Transfer.update_all('is_aporte = !is_aporte')
  end

  def down
    Transfer.update_all('is_aporte = !is_aporte')
  end
end
