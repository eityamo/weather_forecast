class CreateActresses < ActiveRecord::Migration[5.2]
  def change
    create_table :actresses do |t|
      t.string :name, null: false
      t.string :cup, null: false
      t.string :prefecture, null: false
      t.string :image, null: false
      t.string :digital, null: false
      t.references :prefecture, foreign_key: true

      t.timestamps
    end
  end
end
