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

    initializer 'asset_manager' do |app|
      app.config.assets.precompile += ['asset_manager.css', 'asset_manager.js',
                                       'fancybox_sprite.png', 'fancybox_loading.gif', 'blank.gif', 'fancybox_overlay.png',
                                       'fancybox_sprite@2x.png', 'fancybox_loading@2x.gif', 'fancybox_buttons.png',
                                       'bootstrap/glyphicons-halflings.png', 'bootstrap/glyphicons-halflings-white.png',
                                       'asset_manager/chosen-rails/chosen-sprite.png', 'asset_manager/chosen-rails/chosen-sprite@2x.png']

      # We include the engine's helpers
      ActiveSupport.on_load :action_view do
        include AssetManager::AssetsHelper
        include AssetManager::AssetInstancesHelper
      end

      # Formtastic input type
      Formtastic::Inputs.autoload(:AssetManagerInput, 'formtastic/inputs/asset_manager_input') if defined?(Formtastic)

      # SimpleForm input type
      SimpleForm::Inputs.autoload(:AssetManagerInput, 'simple_form/inputs/asset_manager_input') if defined?(SimpleForm)
    end

  end
end
