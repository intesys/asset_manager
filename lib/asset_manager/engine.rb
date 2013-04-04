module AssetManager
  class Engine < ::Rails::Engine
    isolate_namespace AssetManager
    config.generators.template_engine :haml
    config.generators.integration_tool :rspec
    config.generators.test_framework :rspec
    config.generators.fixture_replacement :factory_girl, :dir => 'spec/factories'
    config.generators.orm :active_record
    config.generators.stylesheets true
    config.generators.form_builder :formtastic

    # Per includere gli helper dell'engine
    initializer 'asset_manager.action_controller' do |app|
      ActiveSupport.on_load :action_view do
        include AssetManager::AssetsHelper
        include AssetManager::AssetInstancesHelper
      end
    end
  end
end
