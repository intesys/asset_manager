module SimpleForm
  module Inputs

    class AssetManagerInput < SimpleForm::Inputs::Base
      def input
        template.content_tag(:div, class: 'asset_manager_container') do
          template.concat select_link
          template.concat dynamic_preview
        end
      end

      def select_link
        template.controller.view_context.am_select_link(object, attribute_name)
      end

      def dynamic_preview
        no_items_label = I18n.t('not_available', scope: [object.class.i18n_scope, object.class.name.demodulize.tableize, :show], default: 'N/A')
        template.content_tag(:div, id: "dinamyc_assets_#{attribute_name}", no_items_label: no_items_label) do
          cr = object.send(attribute_name)
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
    end

  end
end
