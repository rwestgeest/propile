require "spec_helper"

describe PresentersController do
  describe "routing" do

    it "routes to #index" do
      get("/presenters").should route_to("presenters#index")
    end

    it "routes to #new" do
      get("/presenters/new").should route_to("presenters#new")
    end

    it "routes to #show" do
      get("/presenters/1").should route_to("presenters#show", :id => "1")
    end

    it "routes to #edit" do
      get("/presenters/1/edit").should route_to("presenters#edit", :id => "1")
    end

    it "routes to #create" do
      post("/presenters").should route_to("presenters#create")
    end

    it "routes to #update" do
      put("/presenters/1").should route_to("presenters#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/presenters/1").should route_to("presenters#destroy", :id => "1")
    end

  end
end
