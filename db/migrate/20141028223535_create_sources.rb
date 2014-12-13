class CreateSources< ActiveRecord::Migration
  def change
    create_table :sources do |t|
      t.references :user, index: true
      t.string :title
      t.string :url
      t.text :description
      t.integer :price
      t.string :time_required
      t.integer :difficulty

      t.timestamps
    end
  end
end
