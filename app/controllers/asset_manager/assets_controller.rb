require_dependency "asset_manager/application_controller"

module AssetManager
  class AssetsController < ApplicationController

    before_filter :load_public, only: [:index, :new]

    # GET /assets
    # GET /assets.json
    def index
      @search = AssetManager::Asset.metasearch(params[:search])
      @assets = @search.relation.send(Kaminari.config.page_method_name, params[Kaminari.config.param_name]).per(50).order("id DESC")

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @assets }
      end
    end

    # GET /assets/1
    # GET /assets/1.json
    def show
      @asset = Asset.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @asset }
      end
    end

    # GET /assets/new
    # GET /assets/new.json
    def new
      @asset = Asset.new(public: @public)
      @asset = build_translations(@asset)
      @asset = build_asset_instances(@asset)

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @asset }
      end
    end

    # GET /assets/1/edit
    def edit
      @asset = Asset.find(params[:id])
      @asset = build_translations(@asset)
      @asset = build_asset_instances(@asset)
    end

    # POST /assets
    # POST /assets.json
    def create
      @asset = Asset.new(params[:asset])

      respond_to do |format|
        if @asset.save
          format.html { redirect_to @asset, flash: { success: t('asset_manager.assets.controller.asset_successfully_create') } }
          format.json { render json: @asset, status: :created, location: @asset }
        else
          @asset = build_translations(@asset)
          @asset = build_asset_instances(@asset)
          format.html { render action: "new" }
          format.json { render json: @asset.errors, status: :unprocessable_entity }
        end
      end
    end

    # PUT /assets/1
    # PUT /assets/1.json
    def update
      @asset = Asset.find(params[:id])

      respond_to do |format|
        if @asset.update_attributes(params[:asset])
          format.html { redirect_to @asset, flash: { success: t('asset_manager.assets.controller.asset_successfully_update') } }
          format.json { head :no_content }
        else
          @asset = build_translations(@asset)
          @asset = build_asset_instances(@asset)
          format.html { render action: "edit" }
          format.json { render json: @asset.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /assets/1
    # DELETE /assets/1.json
    def destroy
      @asset = Asset.find(params[:id])
      @asset.destroy

      respond_to do |format|
        format.html { redirect_to assets_url }
        format.json { head :no_content }
      end
    end

    # GET /assets/preview
    def preview
      @assets = Asset.find_ordered(params[:ids])

      respond_to do |format|
        format.html { render partial: "/admin/asset_manager/assets/assets", locals: { collection: @assets } }
        format.json { render json: @asset }
      end
    end

    def select
      @owner           = params[:owner]
      @id              = params[:id]
      @field           = params[:field]
      asset_categories = params[:asset_categories]
      tags             = params[:tags]

      unless owner_class(@owner).has_field?(@field)
        raise ActiveRecord::RecordNotFound.new("Invalid Field")
      end

      @multiple = owner_class(@owner).files_fields.include?(@field.to_sym) ? true : false
      @max = owner_class(@owner).get_option(@field, :max)
      @type = owner_class(@owner).get_option(@field, :type)
      @accepted = owner_class(@owner).get_option(@field, :accepted)

      # Recupero gli asset della risorsa, tramite ids passati come parametro
      # o quelli associati direttamente ad essa
      if (ids = params[:ids])
        @resource_assets = ((ids.length == 1 && ids[0] == 'no') ? [] : Asset.find_ordered(ids))
        ids = []
      else
        @resource_assets = resource_assets_by_field(@owner, @id, @field, @multiple)
        ids = @resource_assets.map(&:id)
      end

      @assets = Asset.not_ids(ids).public(@type).accepted(@accepted).send(Kaminari.config.page_method_name, params[Kaminari.config.param_name]).per(36)
      @assets = @assets.tagged_with(tags, any: true) unless tags.nil?
      @assets = @assets.categoried_with(asset_categories) unless asset_categories.nil?
      @asset_categories = AssetCategory.sorted
      @tags = ActsAsTaggableOn::Tag.order(:name)
      render layout: 'asset_manager/simple'
    end

  private

    def load_public
      @public = params[:public] == 'false' ? false : true
    end

    def owner_class(owner)
      owner.constantize
    end

    def resource_assets_by_field(owner, id, field, multiple)
      if multiple
        items = owner_class(owner).find(id).try(field.to_sym) rescue []
      else
        item = owner_class(owner).find(id).try(field.to_sym) rescue nil
        items = (item.nil? ? [] : [item])
      end
    end

    def build_asset_instances(asset)
      AssetInstance.instance_contexts_with_all.each do |ic|
        unless asset.has_this_instance_context?(ic)
          asset.asset_instances.build(instance_context: ic)
        end
      end
      asset
    end

    def build_translations(asset)
      asset.translations_for_locales(I18n.available_locales)
      asset
    end

  end
end
