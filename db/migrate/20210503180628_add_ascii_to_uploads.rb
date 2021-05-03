class AddAsciiToUploads < ActiveRecord::Migration[5.2]
  def change
    add_column :uploads, :ascii, :text
  end
end
