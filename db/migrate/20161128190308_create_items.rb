class CreateItems < ActiveRecord::Migration[7.0]
  validates_uniqueness_of :item_id # , scope: :user_id
  # validates :item_id, uniqueness: { scope: :user_id }

  def change
    create_table :items do |t|
      t.string :title
      t.text :description
      t.decimal :width
      t.decimal :height
      t.integer :lister_id
      t.string :email
      t.string :img_loc
      t.text :img_sml_loc

      t.timestamps null: false
    end
  end
end
