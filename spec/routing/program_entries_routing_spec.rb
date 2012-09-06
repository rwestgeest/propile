require "spec_helper"

describe ProgramEntriesController do
  describe "routing" do

    it "routes to #index" do
      get("/program_entries").should route_to("program_entries#index")
    end

    it "routes to #new" do
      get("/program_entries/new").should route_to("program_entries#new")
    end

    it "routes to #show" do
      get("/program_entries/1").should route_to("program_entries#show", :id => "1")
    end

    it "routes to #edit" do
      get("/program_entries/1/edit").should route_to("program_entries#edit", :id => "1")
    end

    it "routes to #create" do
      post("/program_entries").should route_to("program_entries#create")
    end

    it "routes to #update" do
      put("/program_entries/1").should route_to("program_entries#update", :id => "1")
    end

    it "routes to #destroy" do
      delete("/program_entries/1").should route_to("program_entries#destroy", :id => "1")
    end

  end
end
