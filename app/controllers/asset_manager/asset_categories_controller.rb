require_dependency "asset_manager/application_controller"

module AssetManager
  class AssetCategoriesController < ApplicationController

    # GET /asset_categories
    # GET /asset_categories.json
    def index
      @asset_categories = AssetCategory.send(Kaminari.config.page_method_name, params[Kaminari.config.param_name]).per(50).order("id DESC")

      respond_to do |format|
        format.html # index.html.erb
        format.json { render json: @asset_categories }
      end
    end

    # GET /asset_categories/1
    # GET /asset_categories/1.json
    def show
      @asset_category = AssetCategory.find(params[:id])

      respond_to do |format|
        format.html # show.html.erb
        format.json { render json: @asset_category }
      end
    end

    # GET /asset_categories/new
    # GET /asset_categories/new.json
    def new
      @asset_category = AssetCategory.new
      @asset_category = build_translations(@asset_category)

      respond_to do |format|
        format.html # new.html.erb
        format.json { render json: @asset_category }
      end
    end

    # GET /asset_categories/1/edit
    def edit
      @asset_category = AssetCategory.find(params[:id])
      @asset_category = build_translations(@asset_category)
    end

    # POST /asset_categories
    # POST /asset_categories.json
    def create
      @asset_category = AssetCategory.new(params[:asset_category])

      respond_to do |format|
        if @asset_category.save
          format.html { redirect_to @asset_category, flash: { success: t('asset_manager.asset_categories.controller.asset_category_successfully_create') } }
          format.json { render json: @asset_category, status: :created, location: @asset_category }
        else
          format.html { render action: "new" }
          format.json { render json: @asset_category.errors, status: :unprocessable_entity }
        end
      end
    end

    # PUT /asset_categories/1
    # PUT /asset_categories/1.json
    def update
      @asset_category = AssetCategory.find(params[:id])

      respond_to do |format|
        if @asset_category.update_attributes(params[:asset_category])
          format.html { redirect_to @asset_category, flash: { success: t('asset_manager.asset_categories.controller.asset_category_successfully_update') } }
          format.json { head :no_content }
        else
          format.html { render action: "edit" }
          format.json { render json: @asset_category.errors, status: :unprocessable_entity }
        end
      end
    end

    # DELETE /asset_categories/1
    # DELETE /asset_categories/1.json
    def destroy
      @asset_category = AssetCategory.find(params[:id])
      @asset_category.destroy

      respond_to do |format|
        format.html { redirect_to asset_categories_url }
        format.json { head :no_content }
      end
    end

    private

    def build_translations(asset_category)
      asset_category.translations_for_locales(I18n.available_locales)
      asset_category
    end

  end
end
