class AddAttachmentAvatarToSources < ActiveRecord::Migration
  def self.up
    change_table :sources do |t|
      t.attachment :avatar
    end
  end

  def self.down
    remove_attachment :sources, :avatar
  end
end
