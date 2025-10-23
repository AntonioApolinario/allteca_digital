class CreateAuthors < ActiveRecord::Migration[7.2]
  def change
    create_table :authors do |t|
      t.string :type
      t.string :name
      t.date :birth_date
      t.string :city

      t.timestamps
    end
  end
end
