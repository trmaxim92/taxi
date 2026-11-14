class CreateTariffs < ActiveRecord::Migration[8.1]
  def change
    create_table :tariffs do |t|
      t.string :name, null: false
      t.string :value, null: false
      t.string :value_type, null: false, default: "percent"
      t.text :description
      t.integer :position, null: false, default: 0
      t.boolean :active, null: false, default: true

      t.timestamps
    end

    add_index :tariffs, :active
    add_index :tariffs, :position
  end
end
