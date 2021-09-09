class CreateLeaves < ActiveRecord::Migration[6.1]
  def change
    create_table :leaves do |t|
      t.date :effective_date
      t.string :furcate_identifier
      t.integer :person_content_id
      t.text :ancestry

      t.datetime :created_at, null: false

      t.index :furcate_identifier
      t.index :effective_date
      t.index :ancestry
    end
  end
end
