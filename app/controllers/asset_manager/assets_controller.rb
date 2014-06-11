require_dependency 'asset_manager/application_controller'

module AssetManager
  class AssetsController < ApplicationController
    before_filter :load_public, only: [:index, :new]

    def index
      @search = AssetManager::Asset.metasearch(params[:search])
      @assets = @search.relation.send(Kaminari.config.page_method_name, params[Kaminari.config.param_name]).per(50).order('id DESC')
      @total_records = @search.relation.count
    end

    def show
      @asset = Asset.find(params[:id])
    end

    def new
      @asset = Asset.new(public: @public)
      @asset = build_translations(@asset)
      @asset = build_asset_instances(@asset)
    end

    def edit
      @asset = Asset.find(params[:id])
      @asset = build_translations(@asset)
      @asset = build_asset_instances(@asset)
    end

    def create
      @asset = Asset.new(params[:asset])
      if @asset.save
        redirect_to edit_asset_url(@asset), flash: { success: t('asset_manager.assets.controller.asset_successfully_create') }
      else
        @asset = build_translations(@asset)
        @asset = build_asset_instances(@asset)
        render action: 'new'
      end
    end

    def update
      @asset = Asset.find(params[:id])
      if @asset.update_attributes(params[:asset])
        redirect_to edit_asset_url(@asset), flash: { success: t('asset_manager.assets.controller.asset_successfully_update') }
      else
        @asset = build_translations(@asset)
        @asset = build_asset_instances(@asset)
        render action: 'edit'
      end
    end

    def destroy
      @asset = Asset.find(params[:id])
      @asset.destroy
      redirect_to assets_url
    end

    def preview
      @assets = Asset.find_ordered(params[:ids])
      render partial: '/admin/asset_manager/assets/assets', locals: { collection: @assets }
    end

    def select
      @owner = params[:owner]
      @id = params[:id]
      @field = params[:field]
      @save = params[:save]

      owner_class = @owner.constantize
      fail ActiveRecord::RecordNotFound.new('Invalid Field') unless owner_class.am_has_field?(@field)

      @multiple = owner_class.am_files_fields.include?(@field.to_sym)
      @max = owner_class.am_field_option(@field, :max)
      @type = owner_class.am_field_option(@field, :type)
      @accepted = owner_class.am_field_option(@field, :accepted)

      # Recupero gli asset della risorsa, tramite ids passati come parametro o quelli associati direttamente ad essa
      ids = params[:ids]
      if ids
        @resource_assets = ((ids.length == 1 && ids[0] == 'no') ? [] : Asset.find_ordered(ids))
      else
        @resource_assets = (@id ? Array(owner_class.find(@id).send(@field)) : [])
      end
      ids = @resource_assets.map(&:id)
      # Search
      params[:search][:asset_category_id_in].reject!(&:blank?) rescue nil
      params[:search][:file_type_in].reject!(&:blank?) rescue nil
      @search = AssetManager::Asset.metasearch(params[:search])
      @assets = @search.relation
      @assets = @assets.not_ids(ids).public(@type).accepted(@accepted).send(Kaminari.config.page_method_name, params[Kaminari.config.param_name]).per(36).order(AssetManager::Asset.table_name + '.id DESC')
      @assets = @assets.tagged_with(params[:tags], any: true) unless params[:tags].nil?

      render layout: 'asset_manager/simple'
    end

    def quick_upload
      if params[:asset][:translations_attributes]['0'][:title].blank?
        tilte_by_filename = File.basename(params[:asset]["asset_#{params[:asset][:public] == 'true' ? 'public' : 'private'}_instances_attributes".to_sym]['0'][:file].original_filename, '.*').titleize
        params[:asset][:translations_attributes]['0'][:title] = tilte_by_filename
      end
      @asset = Asset.create(params[:asset])
    end

    private

    def load_public
      @public = params[:public] == 'false' ? false : true
    end

    def build_asset_instances(asset)
      if asset.asset_instances.empty?
        asset.asset_instances.build(instance_context: AssetManager::AssetInstance.instance_context_all)
      end
      asset
    end

    def build_translations(asset)
      asset.translations_for_locales(I18n.available_locales)
      asset
    end
  end
end
