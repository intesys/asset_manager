module AssetManager
  module AssetInstancesHelper
    include AssetManager::Deprecated::AssetInstancesHelper

    def am_asset_instance_image(resource, options = {})
      options.assert_valid_keys(:version, :linked, :link_options, :image_options)
      options.reverse_merge!(linked: false, link_options: {}, image_options: {})
      img_src = am_asset_instance_url(resource, version: options[:version])
      img_options = options[:image_options].merge(alt: resource.asset.alt)
      link_href = am_asset_instance_url(resource, version: options[:link_options][:version])
      link_options = options[:link_options].except(:version).merge(title: resource.asset.alt)
      link_to_if options[:linked], image_tag(img_src, img_options), link_href, link_options
    end

    def am_asset_instance_url(resource, options = {})
      options.assert_valid_keys(:version, :download, :force_frontend)
      options.reverse_merge!(version: nil, download: false, force_frontend: false)
      if resource.asset.public
        unless options[:version].nil?
          resource.file.url(options[:version])
        else
          resource.file.url
        end
      else
        if options[:force_frontend] || !in_admin_controller?
          if options[:download]
            asset_manager.download_asset_path(resource.asset, context: resource.instance_context)
          else
            asset_manager.render_asset_path(resource.asset, context: resource.instance_context, version: options[:version])
          end
        else
          if options[:download]
            asset_manager.admin_download_asset_path(resource.asset, context: resource.instance_context)
          else
            asset_manager.admin_render_asset_path(resource.asset, context: resource.instance_context, version: options[:version])
          end
        end
      end
    end

    def am_display_instance_context(resource)
      if resource.is_all?
        display_instance_context_all
      else
        resource.instance_context
      end
    end

    private

    def display_instance_context_all
      raw('&#8659')
    end

    def in_admin_controller?
      controller.class.name =~ /(AssetManager|Admin)::/
    end
  end
end
