require 'spec_helper'


describe ProgramEntriesController do
  it_should_behave_like "a guarded resource controller", :maintainer

  context "when logged in" do
    login_as :maintainer
  
    def valid_attributes
      FactoryGirl.attributes_for(:program_entry).merge :program_id => program
    end
    
    let(:program_entry) { FactoryGirl.create :program_entry }
    let(:program) { program_entry.program }
    def create_program_entry
      program_entry
    end
  
    describe "GET index" do
      it "assigns all program_entries as @program_entries" do
        create_program_entry
        get :index, {}
        assigns(:program_entries).should eq([program_entry])
      end
    end
  
    describe "GET show" do
      it "assigns the requested program_entry as @program_entry" do
        get :show, {:id => program_entry.to_param}
        assigns(:program_entry).should eq(program_entry)
      end
    end
  
    describe "GET new" do
      it "assigns a new program_entry as @program_entry" do
        program = FactoryGirl.create :program
        get :new, {:program_id => program.id}
        assigns(:program_entry).should be_a_new(ProgramEntry)
      end
    end
  
    describe "GET edit" do
      it "assigns the requested program_entry as @program_entry" do
        get :edit, {:id => program_entry.to_param}
        assigns(:program_entry).should eq(program_entry)
      end
    end
  
    describe "POST create" do
      let(:program) { FactoryGirl.create :program }
      def valid_creation_attributes
        @valid_creation_attributes ||= FactoryGirl.attributes_for(:program_entry).merge :program_id => program
        #@valid_creation_attributes ||= FactoryGirl.attributes_for(:program_entry)
      end
      def do_post
        post :create, {:program_entry => valid_creation_attributes}
      end
      describe "with valid params" do
        it "creates a new ProgramEntry" do
          expect {
            do_post
          }.to change(ProgramEntry, :count).by(1)
        end
  
        it "assigns a newly created program_entry as @program_entry" do
          do_post
          assigns(:program_entry).should be_a(ProgramEntry)
          assigns(:program_entry).should be_persisted
        end
  
        it "redirects to the edit of the program" do
          do_post
          response.should redirect_to( :controller => 'programs', :action => 'edit', :id => ProgramEntry.last.program.id )
        end
      end
  
      describe "with invalid params" do
        before do
          # Trigger the behavior that occurs when invalid params are submitted
          ProgramEntry.any_instance.stub(:save).and_return(false)
          do_post
        end

        it "assigns a newly created but unsaved program_entry as @program_entry" do
          assigns(:program_entry).should be_a_new(ProgramEntry)
        end
  
        it "re-renders the 'new' template" do
          response.should render_template("new")
        end
      end
    end
  
    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested program_entry" do
          program_entry = ProgramEntry.create! valid_attributes
          # Assuming there are no other program_entries in the database, this
          # specifies that the ProgramEntry created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          ProgramEntry.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, {:id => program_entry.to_param, :program_entry => {'these' => 'params'}}
        end
  
        it "assigns the requested program_entry as @program_entry" do
          put :update, {:id => program_entry.to_param, :program_entry => valid_attributes}
          assigns(:program_entry).should eq(program_entry)
        end
  
        it "redirects to the program_entry" do
          put :update, {:id => program_entry.to_param, :program_entry => valid_attributes}
          response.should redirect_to( :controller => 'programs', :action => 'edit' )
        end
      end
  
      describe "with invalid params" do
        it "assigns the program_entry as @program_entry" do
          program_entry = ProgramEntry.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          ProgramEntry.any_instance.stub(:save).and_return(false)
          put :update, {:id => program_entry.to_param, :program_entry => {}}
          assigns(:program_entry).should eq(program_entry)
        end
  
        it "re-renders the 'edit' template" do
          program_entry = ProgramEntry.create! valid_attributes
          # Trigger the behavior that occurs when invalid params are submitted
          ProgramEntry.any_instance.stub(:save).and_return(false)
          put :update, {:id => program_entry.to_param, :program_entry => {}}
          response.should render_template("edit")
        end
      end
    end
  
    describe "DELETE destroy" do
      it "destroys the requested program_entry" do
        program_entry = ProgramEntry.create! valid_attributes
        expect {
          delete :destroy, {:id => program_entry.to_param}
        }.to change(ProgramEntry, :count).by(-1)
      end
  
      it "redirects to the program_entries list" do
        program_entry = ProgramEntry.create! valid_attributes
        delete :destroy, {:id => program_entry.to_param}
        response.should redirect_to(program_entries_url)
      end
    end
  
  end
end
