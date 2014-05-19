# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :asset_manager_asset_category, class: 'AssetCategory' do
    title 'MyString'
  end
end
