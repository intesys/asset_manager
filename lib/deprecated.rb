module AssetManager
  module Deprecated
    module AssetsHelper
      def asset_manager_select_link(resource, field, save = false)
        ActiveSupport::Deprecation.warn('asset_manager_select_link will be deprecated; use am_select_link')
        am_select_link(resource, field, save)
      end

      def am_icon_url(type, size = 16, frontend = true)
        ActiveSupport::Deprecation.warn('am_icon_url will be deprecated; use am_ico_path')
        am_ico_path(type, size: size)
      end

      def render_attachments(assets, title = t('.downloads', default: 'Downloads'), size = nil, categorized = true)
        ActiveSupport::Deprecation.warn('render_attachments will be deprecated; use am_render')
      end

      def categorized_asset_group(assets, size = nil)
        ActiveSupport::Deprecation.warn('categorized_asset_group will be deprecated; use am_render')
      end

      def asset_group(assets, size = nil)
        ActiveSupport::Deprecation.warn('asset_group will be deprecated; use am_render')
      end

      def assets(collection, version = nil, options = {}, container_class = '', linked = false)
        ActiveSupport::Deprecation.warn('assets will be deprecated; use am_render')
      end

      def asset(resource, version = nil, options = {}, container_asset_class = '', linked = false)
        ActiveSupport::Deprecation.warn('asset will be deprecated; use am_render')
      end

      def clippy(text, bgcolor = '#FFFFFF')
        ActiveSupport::Deprecation.warn('clippy will be deprecated; use am_clippy')
        am_clippy(text, bg_color: bgcolor)
      end

      def asset_url(resource, version = nil)
        ActiveSupport::Deprecation.warn('asset_url will be deprecated; use am_asset_url')
        am_asset_url(resource, version: version)
      end
    end

    module AssetInstancesHelper
      def asset_instance(resource, version = nil, options = {}, linked = false)
        ActiveSupport::Deprecation.warn('asset_instance will be deprecated')
      end

      def asset_instance_url(resource, options = {})
        ActiveSupport::Deprecation.warn('asset_instance_url will be deprecated; use am_asset_instance_url')
        am_asset_instance_url(resource, options)
      end

      def display_instance_context(resource)
        ActiveSupport::Deprecation.warn('display_instance_context will be deprecated; use am_display_instance_context')
        am_display_instance_context(resource)
      end
    end
  end
end
