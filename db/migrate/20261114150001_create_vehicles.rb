class CreateVehicles < ActiveRecord::Migration[8.1]
  def change
    create_table :vehicles do |t|
      t.string :brand, null: false
      t.string :model, null: false
      t.string :slug, null: false
      t.integer :year_from
      t.integer :year_to
      t.string :vehicle_class
      t.string :tariffs, default: "", null: false
      t.string :region
      t.text :note
      t.string :source
      t.date :verified_on
      t.string :seo_title
      t.string :seo_description
      t.string :h1
      t.string :robots_meta, default: "index,follow"
      t.boolean :published, default: false, null: false
      t.boolean :is_indexable, default: false, null: false
      t.integer :position, default: 0, null: false

      t.timestamps
    end

    add_index :vehicles, :slug, unique: true
    add_index :vehicles, :published
    add_index :vehicles, :is_indexable
    add_index :vehicles, [ :brand, :model ]
  end
end
