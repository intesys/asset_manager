require 'spec_helper'

describe AssetManager::AssetInstance do
  it { should validate_presence_of(:asset_id) }
  it { should validate_presence_of(:instance_context) }
  it { should validate_presence_of(:file) }
end
