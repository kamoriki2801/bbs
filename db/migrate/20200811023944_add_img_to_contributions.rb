class AddImgToContributions < ActiveRecord::Migration[5.2]
  def change
    add_column :contributions, :img, :string
  end
end
