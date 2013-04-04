# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :asset_manager_asset_association, :class => 'AssetAssociation' do
    owner_type "MyString"
    owner_id 1
    asset nil
    context "MyString"
  end
end
