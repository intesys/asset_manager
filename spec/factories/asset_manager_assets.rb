# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :asset_manager_asset, class: 'Asset' do
    title 'MyString'
    description 'MyText'
  end
end
