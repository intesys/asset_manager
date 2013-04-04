module AssetManager
  class AssetAssociation < ActiveRecord::Base
    attr_accessible :context, :owner_id, :owner_type, :asset_id, :position

    belongs_to :asset, class_name: "AssetManager::Asset"
    belongs_to :owner, polymorphic: true

    validates :asset_id, presence: true
    validates :owner_id, presence: true
    validates :owner_type, presence: true
    validates :context, presence: true

    default_scope order: "position"

  end
end
