module AssetManager
  class Engine < ::Rails::Engine
    isolate_namespace AssetManager
    config.generators.template_engine :haml
    config.generators.integration_tool :rspec
    config.generators.test_framework :rspec
    config.generators.fixture_replacement :factory_girl, dir: 'spec/factories'
    config.generators.orm :active_record
    config.generators.stylesheets true
    config.generators.form_builder :formtastic

    # We include the engine's helpers
    initializer 'asset_manager.action_controller' do |app|
      ActiveSupport.on_load :action_view do
        include AssetManager::AssetsHelper
        include AssetManager::AssetInstancesHelper
      end
      ActiveSupport.on_load :active_record do
        Formtastic::Inputs.autoload(:AssetManagerInput, 'formtastic/inputs/asset_manager_input')
        SimpleForm::Inputs.autoload(:AssetManagerInput, 'simple_form/inputs/asset_manager_input')
      end
    end

    if Rails.version > '3.1'
      initializer 'Asset Manager precompile hook' do |app|
        app.config.assets.precompile += [
          'asset_manager.css',
          'asset_manager.js',
        ]
      end
    end
  end
end
