require 'spec_helper'

describe PresentersController do
  it_should_behave_like "a guarded resource controller", :maintainer, :presenter, :except => [:export]

  context "when logged in" do
    login_as :presenter
    let(:presenter) { FactoryGirl.create :presenter }
    describe "email " do
      it "is not possible when logged in as presenter " do
        orig_email = presenter.email
        put :update, {:id => presenter.to_param, :presenter => { :email => "new_email@company.com"} }
        Presenter.find(presenter.to_param).email.should == orig_email
      end
    end
    describe "role " do
      it "is possible when logged in as presenter " do

        put :update, {:id => presenter.to_param, :presenter => { :role => Account::Maintainer } }
        Presenter.find(presenter.to_param).role.should == Account::Presenter
      end
    end
  end

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

    describe "GET dashboard" do
      it "assigns the current presenter as @presenter" do
        current_account.presenter = presenter
        get :dashboard
        assigns(:presenter).should eq(current_presenter)
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

      describe "email " do
        it "is possible when logged in as maintainer " do
          put :update, {:id => presenter.to_param, :presenter => { :email => "new_email@company.com"} }
          Presenter.find(presenter.to_param).email.should == "new_email@company.com"
        end
      end
      describe "role " do
        it "is possible when logged in as maintainer " do
          put :update, {:id => presenter.to_param, :presenter => { :role => Account::Maintainer} }
          Presenter.find(presenter.to_param).role.should == Account::Maintainer
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

    describe "GET export" do

      def login_with_basic_authentication
        account = Account.new
        account.email = "mail@example.com"
        account.save
        account.confirm_with_password :password => 'secret', :password_confirmation => 'secret'
        request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials("mail@example.com", "secret")
      end

      render_views
      it "returns a text with pairs of presenter names and emails" do

        jane = Presenter.new
        jane.name = "Jane Presenter"
        jane.email =  "jane@agileconsultancy.com"
        jane.save

        john = Presenter.new
        john.name = "John Doe"
        john.email = "johnny@company.com"
        john.save

        login_with_basic_authentication
        get :export

        output = response.body.split $/
        output.length.should == 2
        output[0].should == "Jane Presenter <jane@agileconsultancy.com>"
        output[1].should == "John Doe <johnny@company.com>"
      end
    end
  end

end
