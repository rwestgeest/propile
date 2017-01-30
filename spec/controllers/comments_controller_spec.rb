require 'spec_helper'

describe CommentsController do
  render_views
  it_should_behave_like "a guarded resource controller", :presenter, :maintainer, :except => [:destroy]

  context "when logged in" do
    login_as :presenter

    let(:review_for_comment) { FactoryGirl.create(:review) }

    def valid_attributes
      FactoryGirl.attributes_for(:comment).merge :review_id => review_for_comment.id
    end

    let(:comment) { FactoryGirl.create :comment, :review => review_for_comment }

    alias_method :create_comment, :comment

    describe "GET index" do
      it "assigns all comments as @comments" do
        create_comment
        get :index, {}
        assigns(:comments).should eq([comment])
      end
    end

    describe "GET show" do
      it "assigns the requested comment's session as @session" do
        get :show, {:id => comment.to_param}
        assigns(:session).should eq(comment.review.session)
      end
    end

    describe "GET new" do
      it "assigns a new comment as @comment" do
        review = FactoryGirl.create :review
        get :new, {:review_id => review.id}
        assigns(:new_comment).should be_a_new(Comment)
        assigns(:new_comment).presenter.should == current_presenter
        assigns(:review).should == review
        assigns(:session).should == review.session
      end
    end

    describe "GET edit" do
      it "assigns the requested comment as @edit_comment" do
        comment.update_attribute :presenter, current_presenter
        get :edit, {:id => comment.to_param}
        assigns(:edit_comment).should eq(comment)
        assigns(:session).should == comment.review.session
      end
    end

    describe "POST create" do
      describe "post preview" do
        it "assigns the requested NEW comment as @new_comment" do
          post :create, {:comment => valid_attributes, :commit => 'Preview'}
          assigns(:new_comment).should be_a_new(Comment)
          assigns(:new_comment).presenter.should == current_presenter
          assigns(:session).should eq(comment.review.session)
        end
      end
      describe "with valid params" do
        it "creates a new Comment" do
          expect {
            post :create, {:comment => valid_attributes}
          }.to change(Comment, :count).by(1)
        end

        it "current_presenter is newly created comment owner" do
          post :create, {:comment => valid_attributes}
          Comment.last.presenter.should == current_presenter
        end

        it "redirects to the created comment session" do
          post :create, {:comment => valid_attributes}
          response.should redirect_to(Comment.last.review.session)
        end

        it "sends a message to the sessions presenters" do
          # we can safely assume that an_instance_of_review is the only review in the database
          Postman.should_receive(:notify_comment_creation).with(a_persisted_value) 
          post :create, {:comment => valid_attributes}
        end
      end

      describe "with invalid params" do
        before do
          # Trigger the behavior that occurs when invalid params are submitted
          Comment.any_instance.stub(:save).and_return(false)
          post :create, {:comment => valid_attributes}
        end

        it "assigns a newly created but unsaved comment as @new_comment" do
          assigns(:new_comment).should be_a_new(Comment)
        end

        it "re-renders the 'new' template" do
          response.should render_template("sessions/show")
        end
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested comment" do
          Comment.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, {:id => comment.to_param, :comment => {'these' => 'params'}}
        end

        it "assigns the requested comment as @edit_comment" do
          put :update, {:id => comment.to_param, :comment => valid_attributes}
          assigns(:edit_comment).should eq(comment)
          assigns(:session).should == comment.review.session
        end

        it "redirects the comment session" do
          put :update, {:id => comment.to_param, :comment => valid_attributes}
          response.should redirect_to(comment.review.session)
        end

        it "preview assigns the requested comment as @edit_comment" do
          put :update, {:id => comment.to_param, :comment => valid_attributes, :commit => 'Preview'}
          assigns(:edit_comment).should eq(comment)
          assigns(:session).should eq(comment.review.session)
        end
      end

      describe "with invalid params" do
        it "assigns the comment as @edit_comment" do
          # Trigger the behavior that occurs when invalid params are submitted
          Comment.any_instance.stub(:save).and_return(false)
          put :update, {:id => comment.to_param, :comment => {}}
          assigns(:edit_comment).should eq(comment)
        end

        it "re-renders the 'edit' template" do
          # Trigger the behavior that occurs when invalid params are submitted
          Comment.any_instance.stub(:save).and_return(false)
          put :update, {:id => comment.to_param, :comment => {}}
          response.should render_template("sessions/show")
        end
      end
    end

  end

end
