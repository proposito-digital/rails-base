require "rails_helper"

RSpec.xdescribe Admin::DogsController, type: :routing do
  describe "routing" do

    it "routes to #index" do
      expect(:get => "/admin/dogs").to route_to("admin/dogs#index")
    end

    it "routes to #new" do
      expect(:get => "/admin/dogs/new").to route_to("admin/dogs#new")
    end

    it "routes to #show" do
      expect(:get => "/admin/dogs/1").to route_to("admin/dogs#show", :id => "1")
    end

    it "routes to #edit" do
      expect(:get => "/admin/dogs/1/edit").to route_to("admin/dogs#edit", :id => "1")
    end

    it "routes to #create" do
      expect(:post => "/admin/dogs").to route_to("admin/dogs#create")
    end

    it "routes to #update" do
      expect(:put => "/admin/dogs/1").to route_to("admin/dogs#update", :id => "1")
    end

    it "routes to #destroy" do
      expect(:delete => "/admin/dogs/1").to route_to("admin/dogs#destroy", :id => "1")
    end

  end
end
