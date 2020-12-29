class AddTags < ActiveRecord::Migration[5.2]
  def change
    add_column :contributions, :tag ,:string
  end
end
