module AssetManager
  module LinksHelper
    def show_resource_link(resource)
      link_to url_for(resource), title: t('show', default: 'Show') do
        content_tag(:i, class: 'icon-eye-open') { '' }
      end
    end

    def edit_resource_link(resource)
      link_to url_for(resource) + '/edit', title: t('edit', default: 'Edit') do
        content_tag(:i, class: 'icon-pencil') { '' }
      end
    end

    def delete_resource_link(resource)
      link_to url_for(resource), title: t('delete', default: 'Delete'), method: :delete, data: { confirm: t('.delete_confirmation', default: 'Are you sure?') } do
        content_tag(:i, class: 'icon-remove') { '' }
      end
    end
  end
end
