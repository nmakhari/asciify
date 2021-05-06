class CreateJoinTableTagsUploads < ActiveRecord::Migration[5.2]
  def change
    create_table :tags_uploads, :id => false do |t|
      t.integer :tag_id
      t.integer :upload_id
    end
    add_index(:tags_uploads, [:tag_id, :upload_id])
  end
end
