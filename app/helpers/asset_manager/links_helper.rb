module AssetManager
  module LinksHelper

    def show_resource_link(resource)
      link_to(t('.show', default: 'Show'), url_for(resource))
    end

    def edit_resource_link(resource)
      link_to(t('.edit', default: 'Edit'), url_for(resource) + '/edit')
    end

    def delete_resource_link(resource)
      link_to(t('.delete', default: 'Delete'), url_for(resource), confirm: t('.delete_confirmation', default: "Are you sure?"), method: :delete)
    end

  end
end
