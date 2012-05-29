require 'spec_helper'

describe PresentersController do
  it_should_behave_like "a guarded resource controller", :maintainer 

  context "when logged in" do
    login_as :maintainer
    def valid_attributes
      FactoryGirl.attributes_for :presenter
    end

    let(:presenter) { FactoryGirl.create :presenter }
    def create_presenter
      presenter
    end

    describe "GET index" do
      it "assigns all presenters as @presenters" do
        create_presenter
        get :index, {}
        assigns(:presenters).should eq([presenter])
      end
    end

    describe "GET show" do
      it "assigns the requested presenter as @presenter" do
        get :show, {:id => presenter.to_param}
        assigns(:presenter).should eq(presenter)
      end
    end

    describe "GET new" do
      it "assigns a new presenter as @presenter" do
        get :new, {}
        assigns(:presenter).should be_a_new(Presenter)
      end
    end

    describe "GET edit" do
      it "assigns the requested presenter as @presenter" do
        get :edit, {:id => presenter.to_param}
        assigns(:presenter).should eq(presenter)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new Presenter" do
          expect {
            post :create, {:presenter => valid_attributes}
          }.to change(Presenter, :count).by(1)
        end

        it "assigns a newly created presenter as @presenter" do
          post :create, {:presenter => valid_attributes}
          assigns(:presenter).should be_a(Presenter)
          assigns(:presenter).should be_persisted
        end

        it "redirects to the created presenter" do
          post :create, {:presenter => valid_attributes}
          response.should redirect_to(Presenter.last)
        end
      end

      describe "with invalid params" do
        before do
          # Trigger the behavior that occurs when invalid params are submitted
          Presenter.any_instance.stub(:save).and_return(false)
        end

        it "assigns a newly created but unsaved presenter as @presenter" do
          post :create, {:presenter => {}}
          assigns(:presenter).should be_a_new(Presenter)
        end

        it "re-renders the 'new' template" do
          post :create, {:presenter => {}}
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested presenter" do
          create_presenter
          # Assuming there are no other presenters in the database, this
          # specifies that the Presenter created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Presenter.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, {:id => presenter.to_param, :presenter => {'these' => 'params'}}
        end

        it "assigns the requested presenter as @presenter" do
          put :update, {:id => presenter.to_param, :presenter => valid_attributes}
          assigns(:presenter).should eq(presenter)
        end

        it "redirects to the presenter" do
          put :update, {:id => presenter.to_param, :presenter => valid_attributes}
          response.should redirect_to(presenter)
        end
      end

      describe "with invalid params" do
        before do 
          # Trigger the behavior that occurs when invalid params are submitted
          Presenter.any_instance.stub(:save).and_return(false)
        end

        it "assigns the presenter as @presenter" do
          put :update, {:id => presenter.to_param, :presenter => {}}
          assigns(:presenter).should eq(presenter)
        end

        it "re-renders the 'edit' template" do
          put :update, {:id => presenter.to_param, :presenter => {}}
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested presenter" do
        create_presenter
        expect {
          delete :destroy, {:id => presenter.to_param}
        }.to change(Presenter, :count).by(-1)
      end

      it "redirects to the presenters list" do
        delete :destroy, {:id => presenter.to_param}
        response.should redirect_to(presenters_url)
      end
    end
  end

end
