require 'spec_helper'

describe ReviewsController do
  render_views
  it_should_behave_like "a guarded resource controller", :presenter, :maintainer, :except => [:destroy]


  context "when logged in" do
    login_as :presenter

    let(:session_for_review) { FactoryGirl.create(:session_with_presenter) }

    def valid_attributes
      FactoryGirl.attributes_for(:review).merge :session_id => session_for_review.id
    end

    let(:review) { FactoryGirl.create :review, :session => session_for_review }

    alias_method :create_review, :review

    describe "GET index" do
      it "assigns all reviews as @reviews" do
        create_review
        get :index, {}
        assigns(:reviews).should eq([review])
      end
    end

    describe "GET show" do
      it "assigns the requested review session as @session" do
        get :show, {:id => review.to_param}
        assigns(:session).should eq(review.session)
      end
    end

    describe "GET new" do
      it "assigns a new review as @review" do
        session = FactoryGirl.create :session_with_presenter
        get :new, {:session_id => session.id}
        assigns(:review).should be_a_new(Review)
        assigns(:review).presenter.should == current_presenter
        assigns(:session).should == session
      end
    end

    describe "GET edit" do
      it "assigns the requested review as @edit_review" do
        review.update_attribute :presenter, current_presenter
        get :edit, {:id => review.to_param}
        assigns(:edit_review).should eq(review)
        assigns(:session).should eq(review.session)
      end
    end

    describe "POST create" do
      describe "post preview" do
        it "assigns the requested NEW review as @new_review" do
          post :create, {:review => valid_attributes, :commit => 'Preview'}
          assigns(:new_review).should be_a_new(Review)
          assigns(:new_review).presenter.should == current_presenter
          assigns(:session).should eq(review.session)
        end
      end

      describe "with valid params" do
        def do_post
          post :create, {:review => valid_attributes}
        end
        it "creates a new Review" do
          expect {
            do_post
          }.to change(Review, :count).by(1)
        end

        it "current_presenter is newly created review owner" do
          do_post
          Review.last.presenter.should == current_presenter
        end

        it "redirects to the review's session page" do
          do_post
          response.should redirect_to(Review.last.session)
        end

        it "sends a message to the sessions presenters" do
          # we can safely assume that an_instance_of_review is the only review in the database
          Postman.should_receive(:notify_review_creation).with(a_persisted_value)
          do_post
        end
      end

      describe "with invalid params" do
        before do
          # Trigger the behavior that occurs when invalid params are submitted
          Review.any_instance.stub(:save).and_return(false)
          post :create, {:review => valid_attributes}
        end
        it "assigns a newly created but unsaved review as @new_review" do
          assigns(:new_review).should be_a_new(Review)
        end

        it "re-renders the 'new' template" do
          response.should render_template("sessions/show")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested review" do
          create_review 
          Review.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, {:id => review.to_param, :review => {'these' => 'params'}}
        end

        it "assigns the requested review as @edit_review" do
          put :update, {:id => review.to_param, :review => valid_attributes}
          assigns(:edit_review).should eq(review)
          assigns(:session).should eq(review.session)
        end

        it "redirects to the review session" do
          put :update, {:id => review.to_param, :review => valid_attributes}
          response.should redirect_to(review.session)
        end

        it "preview assigns the requested review as @edit_review" do
          put :update, {:id => review.to_param, :review => valid_attributes, :commit => 'Preview'}
          assigns(:edit_review).should eq(review)
          assigns(:session).should eq(review.session)
        end
      end

      describe "with invalid params" do
        before do
          # Trigger the behavior that occurs when invalid params are submitted
          Review.any_instance.stub(:save).and_return(false)
          put :update, {:id => review.to_param, :review => {}}
        end
        it "assigns the review as @edit_review" do
          assigns(:edit_review).should eq(review)
        end

        it "re-renders the 'edit' template" do
          response.should render_template("sessions/show")
        end
      end
    end

  end

end
