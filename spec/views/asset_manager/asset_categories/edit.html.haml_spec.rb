require 'spec_helper'

describe 'asset_categories/edit' do
  before(:each) do
    @asset_category = assign(:asset_category, stub_model(AssetCategory))
  end

  it 'renders the edit asset_category form' do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select 'form', action: asset_categories_path(@asset_category), method: 'post' do
    end
  end
end
