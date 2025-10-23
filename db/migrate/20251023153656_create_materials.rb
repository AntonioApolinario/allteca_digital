class CreateMaterials < ActiveRecord::Migration[7.2]
  def change
    create_table :materials do |t|
      t.string :type
      t.string :title
      t.text :description
      t.string :status
      t.references :user, null: false, foreign_key: true
      t.references :author, null: false, foreign_key: true
      t.string :isbn
      t.integer :page_count
      t.string :doi
      t.integer :duration_minutes

      t.timestamps
    end
  end
end
