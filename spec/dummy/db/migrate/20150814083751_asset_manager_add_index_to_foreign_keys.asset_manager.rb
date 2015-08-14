# This migration comes from asset_manager (originally 20130417082644)
class AssetManagerAddIndexToForeignKeys < ActiveRecord::Migration
  def change
    add_index :asset_manager_asset_associations, [:owner_id, :owner_type], name: 'index_asset_associations_on_owner_id_and_owner_type'
  end
end
