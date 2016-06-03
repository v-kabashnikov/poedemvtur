class CreateEmailTemplates < ActiveRecord::Migration
  def up
    create_table :email_templates do |t|
      t.string :title
      t.string :slug
      t.string :subject
      t.text :content

      t.timestamps null: false
    end

    EmailTemplate.create(
      title: 'Создан новый заказ',
      slug: 'create_order',
      subject: 'Создан новый заказ'
    )
  end

  def down
  	drop_table :email_templates
  end
end
