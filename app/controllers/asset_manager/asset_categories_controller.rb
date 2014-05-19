require_dependency 'asset_manager/application_controller'

module AssetManager
  class AssetCategoriesController < ApplicationController
    def index
      @search = AssetManager::AssetCategory.metasearch(params[:search])
      @asset_categories = @search.relation.send(Kaminari.config.page_method_name, params[Kaminari.config.param_name]).per(50).order('id DESC')
      @total_records = @search.relation.count
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
      @asset_category = AssetCategory.new(params[:asset_category])
      if @asset_category.save
        redirect_to edit_asset_category_url(@asset_category), flash: { success: t('asset_manager.asset_categories.controller.asset_category_successfully_create') }
      else
        render action: 'new'
      end
    end

    def update
      @asset_category = AssetCategory.find(params[:id])
      if @asset_category.update_attributes(params[:asset_category])
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
  end
end
