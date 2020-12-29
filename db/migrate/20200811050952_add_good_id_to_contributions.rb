class AddGoodIdToContributions < ActiveRecord::Migration[5.2]
  def change
    add_column :contributions, :good, :integer, default: 0
  end
end