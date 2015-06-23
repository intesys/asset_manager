module AssetManager
  class AssetInstance < ActiveRecord::Base
    # attr_accessible :file, :instance_context, :asset_id

    # validates :asset_id, presence: true
    validates :instance_context, presence: true
    validates :file, presence: true
    validates_uniqueness_of :asset_id, scope: [:instance_context]

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
      [instance_context_all] | instance_contexts
    end
  end
end
