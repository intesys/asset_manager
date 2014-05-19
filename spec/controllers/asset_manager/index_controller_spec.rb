require 'spec_helper'

describe AssetManager::IndexController do

  describe "GET 'index'" do
    it 'returns http success' do
      get 'index'
      response.should be_success
    end
  end

end
