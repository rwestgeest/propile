require 'spec_helper'

describe ArchivedPresentersController do
  #it_should_behave_like "a guarded resource controller", :maintainer, :presenter

  context "when logged in" do
    login_as :maintainer
    def valid_attributes
      FactoryGirl.attributes_for :archived_presenter
    end

    let(:archived_presenter) { FactoryGirl.create :archived_presenter }
    def create_archived_presenter
      archived_presenter
    end

    describe "GET index" do
      it "assigns all archived_presenters as @archived_presenters" do
        create_archived_presenter
        get :index, {}
        assigns(:archived_presenters).should eq([archived_presenter])
      end
    end

    describe "GET show" do
      it "assigns the requested archived_presenter as @archived_presenter" do
        get :show, {:id => archived_presenter.to_param}
        assigns(:archived_presenter).should eq(archived_presenter)
      end
    end

    describe "GET new" do
      it "assigns a new archived_presenter as @archived_presenter" do
        get :new, {}
        assigns(:archived_presenter).should be_a_new(ArchivedPresenter)
      end
    end

    describe "GET edit" do
      it "assigns the requested archived_presenter as @archived_presenter" do
        get :edit, {:id => archived_presenter.to_param}
        assigns(:archived_presenter).should eq(archived_presenter)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        it "creates a new ArchivedPresenter" do
          expect {
            post :create, {:archived_presenter => valid_attributes}
          }.to change(ArchivedPresenter, :count).by(1)
        end

        it "assigns a newly created archived_presenter as @archived_presenter" do
          post :create, {:archived_presenter => valid_attributes}
          assigns(:archived_presenter).should be_a(ArchivedPresenter)
          assigns(:archived_presenter).should be_persisted
        end

        it "redirects to the created archived_presenter" do
          post :create, {:archived_presenter => valid_attributes}
          response.should redirect_to(ArchivedPresenter.last)
        end
      end

      describe "with invalid params" , :broken => true do
        before do
          # Trigger the behavior that occurs when invalid params are submitted
          ArchivedPresenter.any_instance.stub(:save).and_return(false)
        end

        it "assigns a newly created but unsaved archived_presenter as @archived_presenter" do
          post :create, {:archived_presenter => {}}
          assigns(:archived_presenter).should be_a_new(ArchivedPresenter)
        end

        it "re-renders the 'new' template" do
          post :create, {:archived_presenter => {}}
          response.should render_template("new")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested archived_presenter" do
          create_archived_presenter
          # Assuming there are no other archived_presenters in the database, this
          # specifies that the ArchivedPresenter created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          ArchivedPresenter.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, {:id => archived_presenter.to_param, :archived_presenter => {'these' => 'params'}}
        end

        it "assigns the requested archived_presenter as @archived_presenter" do
          put :update, {:id => archived_presenter.to_param, :archived_presenter => valid_attributes}
          assigns(:archived_presenter).should eq(archived_presenter)
        end

        it "redirects to the archived_presenter" do
          put :update, {:id => archived_presenter.to_param, :archived_presenter => valid_attributes}
          response.should redirect_to(archived_presenter)
        end
      end

      describe "with invalid params" , :broken => true do
        before do 
          # Trigger the behavior that occurs when invalid params are submitted
          ArchivedPresenter.any_instance.stub(:save).and_return(false)
        end

        it "assigns the archived_presenter as @archived_presenter" do
          put :update, {:id => archived_presenter.to_param, :archived_presenter => {}}
          assigns(:archived_presenter).should eq(archived_presenter)
        end

        it "re-renders the 'edit' template" do
          put :update, {:id => archived_presenter.to_param, :archived_presenter => {}}
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" , :broken => true do
      it "destroys the requested archived_presenter" do
        create_rchived_presenter
        expect {
          delete :destroy, {:id => archived_presenter.to_param}
        }.to change(ArchivedPresenter, :count).by(-1)
      end

      it "redirects to the archived_presenters list" do
        delete :destroy, {:id => archived_presenter.to_param}
        response.should redirect_to(archived_presenters_url)
      end
    end

  end
end
