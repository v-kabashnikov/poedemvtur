class Hz < ActiveRecord::Migration
  def change
  	create_table :question_categories do |t|
  	  t.string :category
      t.timestamps null: false
    end
     add_reference :questions, :question_category, index: true
  end
end
