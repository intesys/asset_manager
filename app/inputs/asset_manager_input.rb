class AssetManagerInput
  include Formtastic::Inputs::Base

  def to_html
    no_items_label = I18n.t('not_available', scope: [object.class.i18n_scope, object.class.name.demodulize.tableize, :show], default: 'N/A')

    input_wrapping do
      result = label_html
      result << template.content_tag(:div, class: 'asset_manager_container') do
        template.controller.view_context.am_select_link(object, method) <<
        template.content_tag(:div, id: "dinamyc_assets_#{method}", no_items_label: no_items_label) do
          cr = object.send(method)
          unless cr.blank?
            if cr.kind_of?(Array)
              template.controller.view_context.render(partial: '/admin/asset_manager/assets/assets', locals: { collection: cr })
            else
              template.controller.view_context.render(partial: '/admin/asset_manager/assets/asset', locals: { resource: cr })
            end
          else
            no_items_label
          end
        end
      end
      result
    end
  end
end
