class CreateItems < ActiveRecord::Migration[5.0]
  def change
    create_table :items do |t|
      t.references :user, foreign_key: true
      t.string :url
      t.string :name
      t.integer :price
      t.string :image_url

      t.timestamps
    end
  end
end
