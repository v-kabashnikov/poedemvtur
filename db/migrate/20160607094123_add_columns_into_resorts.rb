class AddColumnsIntoResorts < ActiveRecord::Migration
  def change
    add_column :resorts, :seasonality, :boolean
  end
end
