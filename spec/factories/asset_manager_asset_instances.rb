# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :asset_manager_asset_instance, class: 'AssetInstance' do
    # asset FactoryGirl.create(:asset_manager_asset)
    instance_context :all
    instance_content :file
  end
end
