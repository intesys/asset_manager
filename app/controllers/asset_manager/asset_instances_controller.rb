require_dependency 'asset_manager/application_controller'

module AssetManager
  class AssetInstancesController < ApplicationController
    def show
      asset_instance = AssetManager::AssetPrivateInstance.find_by_asset_id_and_instance_context(params[:id], params[:context])
      path = (params[:version].present? ? asset_instance.file.url(params[:version]) : asset_instance.file.url)
      disposition = params[:download] ? :attachment : :inline
      send_file path, disposition: disposition
    end

    alias_method :admin_show, :show

    private

    def store_location
      if request.fullpath != '/users/sign_in' && request.fullpath != '/users/sign_up' && !request.xhr? # don't store ajax calls
        Thread.current[:previous_url] = request.fullpath
      end
    end
  end
end
