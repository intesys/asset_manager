require 'spec_helper'

describe 'asset_categories/new' do
  before(:each) do
    assign(:asset_category, stub_model(AssetCategory).as_new_record)
  end

  it 'renders new asset_category form' do
    render

    # Run the generator again with the --webrat flag if you want to use webrat matchers
    assert_select 'form', action: asset_categories_path, method: 'post' do
    end
  end
end
