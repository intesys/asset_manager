require "spec_helper"

describe AssetCategoriesController do
  describe "routing" do

    it "routes to #index" do
      get("/asset_categories").should route_to("asset_categories#index")
    end

    it "routes to #new" do
      get("/asset_categories/new").should route_to("asset_categories#new")
    end

    it "routes to #show" do
      get("/asset_categories/1").should route_to("asset_categories#show", :id => "1")
    end

    it "routes to #edit" do
      get("/asset_categories/1/edit").should route_to("asset_categories#edit", :id => "1")
    end

    it "routes to #create" do
      post("/asset_categories").should route_to("asset_categories#create")
    end

    it "routes to #update" do
      put("/asset_categories/1").should route_to("asset_categories#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/asset_categories/1").should route_to("asset_categories#destroy", :id => "1")
    end

  end
end
