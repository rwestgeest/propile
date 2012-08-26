require 'spec_helper'
require 'csv'

describe VotesController do
  render_views
  it_should_behave_like "a guarded resource controller", :presenter, :maintainer

  context "when logged in as maintainer" do
    login_as :maintainer
    let(:session_for_vote) { FactoryGirl.create(:session_with_presenter) }

    def valid_attributes
      FactoryGirl.attributes_for(:vote).merge :session_id => session_for_vote.id
    end

    let(:vote) { FactoryGirl.create :vote, :session => session_for_vote }
    alias_method :create_vote, :vote
  
    describe "GET index" do
      it "assigns all votes as @votes" do
        create_vote
        get :index, {}
        assigns(:votes).should eq([vote])
      end
    end

    describe "GET csv" do
      it "exports all votes in csv format" do
        create_vote 
        get :csv
        response.should be_success
        CSV.parse(@response.body).size.should be 2
      end
    end


    describe "GET show" do
      it "assigns the requested vote as @vote" do
        get :show, {:id => vote.to_param}
        assigns(:vote).should eq(vote)
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested vote" do
          create_vote 
          # Assuming there are no other votes in the database, this
          # specifies that the Vote created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Vote.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, {:id => vote.to_param, :vote => {'these' => 'params'}}
        end

        it "assigns the requested vote as @vote" do
          put :update, {:id => vote.to_param, :vote => valid_attributes}
          assigns(:vote).should eq(vote)
        end

        it "redirects to the 'edit' template because update is never supposed to do anything"  do
          put :update, {:id => vote.to_param, :vote => valid_attributes}
          response.should render_template("edit")
        end
      end

      describe "with invalid params" do
        before do
          # Trigger the behavior that occurs when invalid params are submitted
          Vote.any_instance.stub(:save).and_return(false)
          put :update, {:id => vote.to_param, :vote => {}}
        end
        it "assigns the vote as @vote" do
          assigns(:vote).should eq(vote)
        end

        it "re-renders the 'edit' template" do
          response.should render_template("edit")
        end
      end
    end


  end
  context "when logged in as presenter" do
    login_as :presenter
    let(:session_for_vote) { FactoryGirl.create(:session_with_presenter) }

    def valid_attributes
      FactoryGirl.attributes_for(:vote).merge :session_id => session_for_vote.id
    end

    let(:vote) { FactoryGirl.create :vote, :session => session_for_vote }
    alias_method :create_vote, :vote

    describe "GET new" do
      it "assigns a new vote as @vote" do
        session = FactoryGirl.create :session_with_presenter
        get :new, {:session_id => session.id}
        assigns(:vote).should be_a_new(Vote)
        assigns(:vote).presenter.should == current_presenter
      end
    end

    describe "GET edit" do
      it "assigns the requested vote as @vote" do
        vote.update_attribute :presenter, current_presenter
        get :edit, {:id => vote.to_param}
        assigns(:vote).should eq(vote)
      end
    end

    describe "POST create" do
      describe "with valid params" do
        def do_post
          session = FactoryGirl.create :session_with_presenter
          post :create, {:vote => valid_attributes, :session_id => session_for_vote.id}
        end
        it "creates a new Vote" do
          expect {
            do_post
          }.to change(Vote, :count).by(1)
        end

        it "current_presenter is newly created votes' owner" do
          do_post
          Vote.last.presenter.should == current_presenter
        end

        it "redirects to the voted session" do
          do_post
          response.should redirect_to session_url  :id => session_for_vote.id
        end
      end

      describe "with invalid params" do
        before do
          # Trigger the behavior that occurs when invalid params are submitted
          Vote.any_instance.stub(:save).and_return(false)
          post :create, {:vote => valid_attributes, :session_id => session_for_vote.id}
        end
        it "assigns a newly created but unsaved vote as @vote" do
          assigns(:vote).should be_a_new(Vote)
        end

        it "re-renders the 'new' template" do
          response.should render_template("new")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested vote" do
        create_vote
        request.env["HTTP_REFERER"] = session_url  :id => session_for_vote.id
        expect {
          delete :destroy, {:id => vote.to_param}
        }.to change(Vote, :count).by(-1)
      end

      it "redirects to the votes list"  do
        request.env["HTTP_REFERER"] = session_url  :id => session_for_vote.id
        delete :destroy, {:id => vote.to_param}
        response.should redirect_to session_url  :id => session_for_vote.id
      end
    end
  end

end
