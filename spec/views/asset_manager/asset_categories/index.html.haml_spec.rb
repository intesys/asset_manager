require 'spec_helper'

describe "asset_categories/index" do
  before(:each) do
    assign(:asset_categories, [
      stub_model(AssetCategory),
      stub_model(AssetCategory)
    ])
  end

  it "renders a list of asset_categories" do
    render
    # Run the generator again with the --webrat flag if you want to use webrat matchers
  end
end
