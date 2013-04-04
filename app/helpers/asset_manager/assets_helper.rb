module AssetManager
  module AssetsHelper

    def asset_manager_select_link(resource, field)
      href = asset_manager.select_assets_path(owner: resource.class.name, id: resource.id, field: field)
      content_tag(:a, href: href, class: "asset_manager_iframe", title: "Asset Manager", data: { href: href }) { t('select', scope: [resource.class.i18n_scope, resource.class.name.demodulize.tableize, :show], default: "Select") }
    end

    def am_icon_url(type, size = 16, frontend = true)
      type = (type.nil? ? "" : type)
      size = (size.nil? ? 16 : size)
      file_name = type + '.png'
      file_path = ['file_icons', (frontend ? 'frontend' : 'backend'), (size.to_s + 'x' + size.to_s), file_name].join('/')
      if Rails.application.assets.find_asset(file_path).nil?
        file_path.gsub!(file_name, 'default.png')
      end
      image_path(file_path)
    end

    def render_attachments(assets, title = t('.downloads', default: 'Downloads'), size = nil, categorized = true)
      unless assets.empty?
        content_tag(:div, { class: 'render_attachments' }) do
          content_tag(:h3) { title } + (categorized ? categorized_asset_group(assets, size) : asset_group(assets, size))
        end
      end
    end

    def categorized_asset_group(assets, size = nil)
      result = content_tag(:div, { class: 'categorized_asset_group' }) do
        items = []
        asset_categories_assets(assets).each do |asset_category_id, assets|
          items.push(content_tag(:h3) { AssetManager::AssetCategory.find(asset_category_id).title rescue t('.other') } + asset_group(assets, size))
        end
        safe_join items, ''
      end
      raw(result)
    end

    def asset_group(assets, size = nil)
      content_tag(:div, { class: 'asset_group' }) do
        render(partial: 'asset_manager/assets/assets_group_by_instance_context', locals: { collection: assets, size: size })
      end
    end

    def assets(collection, version = nil, options = {}, container_class = '', linked = false)
      unless collection.empty?
        result = content_tag(:div, { class: container_class }) do
          content_tag(:ul) do
            items = []
            collection.each do |resource|
              items.push(content_tag(:li) { asset(resource, version, options, '', linked) } )
            end
            safe_join items, ''
          end
        end
        raw(result)
      end
    end

    def asset(resource, version = nil, options = {}, container_asset_class = '', linked = false)
      unless resource.nil?
        ais = resource.asset_instances rescue nil
        if (ais && ais.count == 1)
          ai = ais.first
          unless container_asset_class.blank?
            content_tag(:div, { class: container_asset_class }) do
              asset_instance(ai, version, options, linked)
            end
          else
            asset_instance(ai, version, options, linked)
          end
        end
      end
    end

    def asset_url(resource, version = nil)
      unless resource.nil?
        ais = resource.asset_instances rescue nil
        if (ais && ais.count == 1)
          asset_instance_url(ais.first, version)
        end
      end
    end

    def asset_instance(resource, version = nil, options = {}, linked = false)
      unless resource.nil?
        if linked
          link_to asset_instance_url(resource), options.merge({ title: resource.asset.alt }) do
            image_tag asset_instance_url(resource, version), { alt: resource.asset.alt }
          end
        else
          image_tag asset_instance_url(resource, version), options.merge({ alt: resource.asset.alt })
        end
      end
    end

  private

    def asset_categories_assets(assets)
      items = {}
      assets.each do |asset|
        asset_category = asset.asset_category_id
        items[asset_category] = [] unless items.include?(asset_category)
        items[asset_category].push(asset)
      end
      items
    end

  end
end
