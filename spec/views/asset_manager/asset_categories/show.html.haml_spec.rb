require 'spec_helper'

describe 'asset_categories/show' do
  before(:each) do
    @asset_category = assign(:asset_category, stub_model(AssetCategory))
  end

  it 'renders attributes in <p>' do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
