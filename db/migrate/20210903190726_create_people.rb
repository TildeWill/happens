class CreatePeople < ActiveRecord::Migration[6.1]
  def change
    create_table :people do |t|
      t.string :first_name
      t.string :last_name
      t.string :title
      t.integer :manager_id

      t.date :effective_on
      t.string :version_identifier
      t.string :ancestry

      t.timestamps

      t.index :ancestry
      t.index :version_identifier
      t.index :effective_on
    end
  end
end
