require 'spec_helper'

describe PropileConfigsController do
  it_should_behave_like "a guarded resource controller", :maintainer

  context "when logged in" do
    login_as :maintainer

    def valid_attributes
      FactoryGirl.attributes_for :propile_config
    end
  
    let(:propile_config) { FactoryGirl.create :propile_config }
    def create_propile_config
      propile_config
    end

    describe "GET index" do
      it "assigns all propile_configs as @propile_configs" do
        create_propile_config
        get :index, {}
        assigns(:propile_configs).should eq([propile_config])
      end
      it "assigns all presenters @presenters" do
        presenter = FactoryGirl.create :presenter
        get :index, {}
        assigns(:presenters).should eq([presenter])
      end
      context "assigns review_statistics" do
        it "when no reviews" do
          presenter = FactoryGirl.create :presenter
          get :index, {}
          assigns(:review_statistics).total_number_of_reviews.should == 0
        end
        it "when a review exists " do
          review = FactoryGirl.create :review
          get :index, {}
          assigns(:review_statistics).total_number_of_reviews.should == 1
        end
      end
    end

    describe "GET show" do
      it "assigns the requested propile_config as @propile_config" do
        get :show, {:id => propile_config.to_param}
        assigns(:propile_config).should eq(propile_config)
      end
    end

    describe "GET new" do
      it "assigns a new propile_config as @propile_config" do
        get :new, {}
        assigns(:propile_config).should be_a_new(PropileConfig)
      end
    end
  
    describe "GET edit" do
      it "assigns the requested propile_config as @propile_config" do
        get :edit, {:id => propile_config.to_param}
        assigns(:propile_config).should eq(propile_config)
      end
    end
  
    describe "POST create" do
      describe "with valid params" do
        it "creates a new PropileConfig" do
          expect {
            post :create, {:propile_config => valid_attributes}
          }.to change(PropileConfig, :count).by(1)
        end
  
        it "assigns a newly created propile_config as @propile_config" do
          post :create, {:propile_config => valid_attributes}
          assigns(:propile_config).should be_a(PropileConfig)
          assigns(:propile_config).should be_persisted
        end
  
        it "redirects to the created propile_config" do
          post :create, {:propile_config => valid_attributes}
          response.should redirect_to(PropileConfig.last)
        end
      end
  
      describe "with invalid params" do
        before do
          # Trigger the behavior that occurs when invalid params are submitted
          PropileConfig.any_instance.stub(:save).and_return(false)
        end

        it "assigns a newly created but unsaved propile_config as @propile_config" do
          post :create, {:propile_config => {}}
          assigns(:propile_config).should be_a_new(PropileConfig)
        end

        it "re-renders the 'new' template" do
          post :create, {:propile_config => {}}
          response.should render_template("new")
        end
      end
    end
  
    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested propile_config" do
          create_propile_config
          # Assuming there are no other propile_configs in the database, this
          # specifies that the Presenter created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          PropileConfig.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, {:id => propile_config.to_param, :propile_config => {'these' => 'params'}}
        end
  
        it "assigns the requested propile_config as @propile_config" do
          put :update, {:id => propile_config.to_param, :propile_config => valid_attributes}
          assigns(:propile_config).should eq(propile_config)
        end
  
        it "redirects to the propile_config" do
          put :update, {:id => propile_config.to_param, :propile_config => valid_attributes}
          response.should redirect_to(propile_config)
        end
      end
  
      describe "with invalid params" do
        before do 
          # Trigger the behavior that occurs when invalid params are submitted
          PropileConfig.any_instance.stub(:save).and_return(false)
        end
        it "assigns the propile_config as @propile_config" do
          put :update, {:id => propile_config.to_param, :propile_config => {}}
          assigns(:propile_config).should eq(propile_config)
        end
  
        it "re-renders the 'edit' template" do
          put :update, {:id => propile_config.to_param, :propile_config => {}}
          response.should render_template("edit")
        end
      end
    end
  
    describe "DELETE destroy" do
      it "destroys the requested propile_config" do
        create_propile_config
        expect {
          delete :destroy, {:id => propile_config.to_param}
        }.to change(PropileConfig, :count).by(-1)
      end
  
      it "redirects to the propile_configs list" do
        delete :destroy, {:id => propile_config.to_param}
        response.should redirect_to(propile_configs_url)
      end
    end
  
  end
end
