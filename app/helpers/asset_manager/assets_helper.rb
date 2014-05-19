module AssetManager
  module AssetsHelper
    include AssetManager::Deprecated::AssetsHelper

    def am_render(resource, field, options = {})
      send("am_render_#{resource.class.am_field_option(field, :mode)}", resource.send(field), options)
    end

    def am_render_image(asset, options = {})
      unless asset.nil?
        ais = asset.asset_instances rescue nil
        if ais && ais.count == 1
          am_asset_instance_image(ais.first, options)
        end
      end
    end

    def am_render_images(assets, options = {})
      unless assets.empty?
        result = content_tag(:ul) do
          items = []
          assets.each do |asset|
            items.push(
              content_tag(:li) { am_render_image(asset, options) }
            )
          end
          safe_join items, ''
        end
        raw(result)
      end
    end

    def am_render_file(asset, options = {})
      unless asset.nil?
        options.assert_valid_keys(:ico_size)
        render(partial: 'asset_manager/assets/asset_group_by_instance_context', locals: { resource: asset, ico_size: options[:ico_size] })
      end
    end

    def am_render_files(assets, options = {})
      unless assets.empty?
        options.assert_valid_keys(:ico_size, :categorized)
        options.reverse_merge!(categorized: false)
        (options[:categorized] ?
          am_categorized_assets_group(assets, ico_size: options[:ico_size]) :
          am_assets_group(assets, ico_size: options[:ico_size])
        )
      end
    end

    # Others
    def am_select_link(resource, field, save = false)
      href = asset_manager.select_assets_path(owner: resource.class.name, id: resource.id, field: field, save: save)
      title = "Asset Manager - #{resource.class.name} - #{field}"
      content_tag(:a, href: href, class: 'asset_manager_iframe', title: title, data: { href: href }) {
        t('select', scope: [resource.class.i18n_scope, resource.class.name.demodulize.tableize, :show], default: 'Select')
      }
    end

    def am_ico_path(type, options = {})
      options.assert_valid_keys(:size)
      options.delete_if { |k, v| v.nil? }.reverse_merge!(size: 16)
      size = options[:size]
      file_name = type.to_s + '.png'
      file_path = ['asset_manager', 'file_icons', (size.to_s + 'x' + size.to_s), file_name].join('/')
      if Rails.application.assets.find_asset(file_path).nil?
        file_path.gsub!(file_name, 'default.png')
      end
      image_path(file_path)
    end

    def am_clippy(text, options = {})
      options.assert_valid_keys(:bg_color)
      options.reverse_merge!(bg_color: '#FFFFFF')
      html = <<-EOF
        <object classid="clsid:d27cdb6e-ae6d-11cf-96b8-444553540000"
                width="110"
                height="14"
                id="clippy" >
        <param name="movie" value="/assets/clippy.swf"/>
        <param name="allowScriptAccess" value="always" />
        <param name="quality" value="high" />
        <param name="scale" value="noscale" />
        <param NAME="FlashVars" value="text=#{text}">
        <param name="bgcolor" value="#{options[:bg_color]}">
        <embed src="/assets/clippy.swf"
               width="110"
               height="14"
               name="clippy"
               quality="high"
               allowScriptAccess="always"
               type="application/x-shockwave-flash"
               pluginspage="http://www.macromedia.com/go/getflashplayer"
               FlashVars="text=#{text}"
               bgcolor="#{options[:bg_color]}"
        />
        </object>
      EOF
    end

    def am_asset_url(resource, options = {})
      ais = resource.asset_instances rescue nil
      if ais && ais.count == 1
        am_asset_instance_url(ais.first, options)
      end
    end

    private

    def categories_assets(assets)
      items = {}
      assets.each do |asset|
        asset_category = asset.asset_category_id
        items[asset_category] = [] unless items.include?(asset_category)
        items[asset_category].push(asset)
      end
      items
    end

    def am_categorized_assets_group(assets, options = {})
      result = content_tag(:div, class: 'categorized_assets_group') do
        items = []
        categories_assets(assets).each do |asset_category_id, assets|
          items.push(
            content_tag(:h3) { AssetManager::AssetCategory.find(asset_category_id).title rescue t('.other') } +
            am_assets_group(assets, options)
          )
        end
        safe_join items, ''
      end
      raw(result)
    end

    def am_assets_group(assets, options = {})
      options.assert_valid_keys(:ico_size)
      content_tag(:div, class: 'assets_group') do
        items = []
        assets.each do |asset|
          items.push(am_render_file(asset, options))
        end
        safe_join items, ''
      end
    end
  end
end
