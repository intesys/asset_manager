# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :asset_manager_asset_instance, :class => 'AssetInstance' do
    asset nil
  end
end
