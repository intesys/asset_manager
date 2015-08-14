# This migration comes from asset_manager (originally 20120919130657)
class AssetManagerInit < ActiveRecord::Migration
  def up
    create_table :asset_manager_asset_categories do |t|
      t.timestamps
    end
    AssetManager::AssetCategory.create_translation_table!(title: :string)

    create_table :asset_manager_assets do |t|
      t.references :asset_category
      t.boolean :public
      t.timestamps
    end
    add_index :asset_manager_assets, :asset_category_id
    AssetManager::Asset.create_translation_table!(title: :string, description: :text)

    create_table :asset_manager_asset_associations do |t|
      t.string :owner_type
      t.integer :owner_id
      t.references :asset
      t.string :context
      t.integer :position
      t.timestamps
    end
    add_index :asset_manager_asset_associations, :asset_id

    create_table :asset_manager_asset_instances do |t|
      t.references :asset
      t.string :file
      t.string :instance_context
      t.timestamps
    end
    add_index :asset_manager_asset_instances, :asset_id
    add_index :asset_manager_asset_instances, :instance_context
  end

  def down
    drop_table :asset_manager_asset_categories
    drop_table :asset_manager_assets
    drop_table :asset_manager_asset_associations
    drop_table :asset_manager_asset_instances
    AssetManager::AssetCategory.drop_translation_table!
    AssetManager::Asset.drop_translation_table!
  end
end
