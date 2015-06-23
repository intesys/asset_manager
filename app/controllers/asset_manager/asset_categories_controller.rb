require_dependency 'asset_manager/application_controller'

module AssetManager
  class AssetCategoriesController < ApplicationController
    def index
      @search = AssetManager::AssetCategory.search(params[:search])
      @asset_categories = @search.result.send(Kaminari.config.page_method_name, params[Kaminari.config.param_name]).per(50).order('id DESC')
      @total_records = @search.result.count
    end

    def show
      @asset_category = AssetCategory.find(params[:id])
    end

    def new
      @asset_category = AssetCategory.new
      @asset_category = build_translations(@asset_category)
    end

    def edit
      @asset_category = AssetCategory.find(params[:id])
      @asset_category = build_translations(@asset_category)
    end

    def create
      @asset_category = AssetCategory.new(resource_params)
      if @asset_category.save
        redirect_to edit_asset_category_url(@asset_category), flash: { success: t('asset_manager.asset_categories.controller.asset_category_successfully_create') }
      else
        render action: 'new'
      end
    end

    def update
      @asset_category = AssetCategory.find(params[:id])
      if @asset_category.update_attributes(resource_params)
        redirect_to edit_asset_category_url(@asset_category), flash: { success: t('asset_manager.asset_categories.controller.asset_category_successfully_update') }
      else
        render action: 'edit'
      end
    end

    def destroy
      @asset_category = AssetCategory.find(params[:id])
      @asset_category.destroy
      redirect_to asset_categories_url
    end

    private

    def build_translations(asset_category)
      asset_category.translations_for_locales(I18n.available_locales)
      asset_category
    end

    def resource_params
      params.require(:asset_category).permit(:id, translations_attributes: [:id, :title, :locale])
    end
  end
end
