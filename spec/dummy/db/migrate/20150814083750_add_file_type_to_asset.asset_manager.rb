# This migration comes from asset_manager (originally 20121102141009)
class AddFileTypeToAsset < ActiveRecord::Migration
  def change
    add_column :asset_manager_assets, :file_type, :string
  end
end
