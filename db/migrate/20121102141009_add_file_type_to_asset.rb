class AddFileTypeToAsset < ActiveRecord::Migration
  def change
    add_column :asset_manager_assets, :file_type, :string
  end
end
