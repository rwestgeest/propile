require "spec_helper"

describe ArchivedPresentersController do
  describe "routing" do

    it "routes to #index" do
      get("/archived_presenters").should route_to("archived_presenters#index")
    end

    it "routes to #new" do
      get("/archived_presenters/new").should route_to("archived_presenters#new")
    end

    it "routes to #show" do
      get("/archived_presenters/1").should route_to("archived_presenters#show", :id => "1")
    end

    it "routes to #edit" do
      get("/archived_presenters/1/edit").should route_to("archived_presenters#edit", :id => "1")
    end

    it "routes to #create" do
      post("/archived_presenters").should route_to("archived_presenters#create")
    end

    it "routes to #update" do
      put("/archived_presenters/1").should route_to("archived_presenters#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/archived_presenters/1").should_not be_routable
    end

  end
end
