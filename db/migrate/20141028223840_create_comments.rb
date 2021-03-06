class CreateComments < ActiveRecord::Migration
  def change
    create_table :comments do |t|
      t.references :user, index: true
      t.references :source, index: true
      t.string :text

      t.timestamps
    end
  end
end
