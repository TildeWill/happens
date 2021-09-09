class CreatePersonContents < ActiveRecord::Migration[6.1]
  def change
    create_table :person_contents do |t|
      t.string :first_name
      t.string :last_name
      t.string :title
      t.integer :manager_id, null: true

      t.timestamps
    end
  end
end
