require_dependency File.join(AssetManager::Engine.root, 'app', 'models', 'asset_manager', 'asset_instance.rb')

AssetManager::AssetInstance.class_eval do
  def self.instance_contexts
    []
  end
end
