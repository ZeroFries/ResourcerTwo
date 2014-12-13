class CreateSourceCategories < ActiveRecord::Migration
  def change
    create_table :source_categories do |t|
      t.references :source, index: true
      t.references :category, index: true

      t.timestamps
    end
  end
end
