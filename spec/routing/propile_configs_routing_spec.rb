require "spec_helper"

describe PropileConfigsController do
  describe "routing" do

    it "routes to #index" do
      get("/propile_configs").should route_to("propile_configs#index")
    end

    it "routes to #new" do
      get("/propile_configs/new").should route_to("propile_configs#new")
    end

    it "routes to #show" do
      get("/propile_configs/1").should route_to("propile_configs#show", :id => "1")
    end

    it "routes to #edit" do
      get("/propile_configs/1/edit").should route_to("propile_configs#edit", :id => "1")
    end

    it "routes to #create" do
      post("/propile_configs").should route_to("propile_configs#create")
    end

    it "routes to #update" do
      put("/propile_configs/1").should route_to("propile_configs#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/propile_configs/1").should_not be_routable
    end

  end
end
