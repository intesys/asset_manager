module AssetManager
  class AssetInstance < ActiveRecord::Base
    attr_accessible :file, :instance_context, :asset_id

    belongs_to :asset, class_name: 'AssetManager::Asset', foreign_key: 'asset_id'

    after_destroy do
      if asset.asset_instances.empty?
        asset.file_type = nil
        asset.save
      end
    end

    def is_all?
      instance_context.to_sym == self.class.instance_context_all.to_sym
    end

    def self.instance_contexts
      [:it, :en]
    end

    def self.instance_context_all
      :all
    end

    def self.instance_contexts_with_all
      [self.instance_context_all] | self.instance_contexts
    end
  end
end
