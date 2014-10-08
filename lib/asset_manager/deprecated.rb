module AssetManager
  module Deprecated

    module AssetsHelper
      def asset_manager_select_link(resource, field, save = false)
        Rails.logger.warn ActiveSupport::Deprecation.warn("#{__callee__} is deprecated - use am_select instead.")
        am_select_link(resource, field, save: save)
      end

      def am_icon_url(type, size = 16, frontend = true)
        Rails.logger.warn ActiveSupport::Deprecation.warn("#{__callee__} is deprecated - use am_ico_path instead.")
        am_ico_path(type, size: size)
      end

      def render_attachments(assets, title = t('.downloads', default: 'Downloads'), size = nil, categorized = true)
        Rails.logger.warn ActiveSupport::Deprecation.warn("#{__callee__} is deprecated - use am_render instead.")
        nil
      end

      def categorized_asset_group(assets, size = nil)
        Rails.logger.warn ActiveSupport::Deprecation.warn("#{__callee__} is deprecated - use am_render instead.")
        nil
      end

      def asset_group(assets, size = nil)
        Rails.logger.warn ActiveSupport::Deprecation.warn("#{__callee__} is deprecated - use am_render instead.")
        nil
      end

      def assets(collection, version = nil, options = {}, container_class = '', linked = false)
        Rails.logger.warn ActiveSupport::Deprecation.warn("#{__callee__} is deprecated - use am_render instead.")
        nil
      end

      def asset(resource, version = nil, options = {}, container_asset_class = '', linked = false)
        Rails.logger.warn ActiveSupport::Deprecation.warn("#{__callee__} is deprecated - use am_render instead.")
        nil
      end

      def clippy(text, bgcolor = '#FFFFFF')
        Rails.logger.warn ActiveSupport::Deprecation.warn("#{__callee__} is deprecated - use am_clippy instead.")
        am_clippy(text, bg_color: bgcolor)
      end

      def asset_url(resource, version = nil)
        Rails.logger.warn ActiveSupport::Deprecation.warn("#{__callee__} is deprecated - use am_asset_url instead.")
        am_asset_url(resource, version: version)
      end
    end

    module AssetInstancesHelper
      def asset_instance(resource, version = nil, options = {}, linked = false)
        Rails.logger.warn ActiveSupport::Deprecation.warn("#{__callee__} is deprecated.")
        nil
      end

      def asset_instance_url(resource, options = {})
        Rails.logger.warn ActiveSupport::Deprecation.warn("#{__callee__} is deprecated - use am_asset_instance_url instead.")
        am_asset_instance_url(resource, options)
      end

      def display_instance_context(resource)
        Rails.logger.warn ActiveSupport::Deprecation.warn("#{__callee__} is deprecated - use am_display_instance_context instead.")
        am_display_instance_context(resource)
      end
    end

  end
end
