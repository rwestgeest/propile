require 'spec_helper'
require 'csv'
require 'rexml/document'

describe SessionsController do
  it_should_behave_like "a guarded resource controller", :presenter, :maintainer,
    :except => [:new, :create, :rss]

  def login_with_basic_authentication
    account = Account.new
    account.email = "mail@example.com"
    account.save
    account.confirm_with_password :password => 'secret', :password_confirmation => 'secret'
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials("mail@example.com", "secret")
  end

  def login_with_wrong_basic_authentication
    account = Account.new
    account.email = "mail@example.com"
    account.save
    account.confirm_with_password :password => 'secret', :password_confirmation => 'secret'
    request.env['HTTP_AUTHORIZATION'] = ActionController::HttpAuthentication::Basic.encode_credentials("mail@example.com", "secretje")
  end

  describe "GET all activity rss" do
    render_views

    let(:session1) { FactoryGirl.create :session_with_presenter }
    let(:session2) { FactoryGirl.create :session_with_presenter }

    it "doesn't give access without authentication" do
      get :activity_rss,:format => :xml
      response.code.should == "401"
    end

    it "returns all sessions" do

      session1.save
      session2.save
      login_with_basic_authentication
      get :activity_rss,:format => :xml

      #      puts
      #      puts "-------------"
      #      puts response.body
      #      puts "-------------"

      assigns(:sessions).should have(2).items
      assigns(:last_update).to_s.should == session2.updated_at.to_s
      doc = REXML::Document.new response.body
      doc.elements['rss/channel/title'][0].should == "Propile: All updates"
      titles = []
      doc.elements.each("rss/channel/item") do |element|
        titles <<  element.elements["title"][0]
      end
      titles.should include(session1.title)
      titles.should include(session2.title)
    end
    
    let(:session) { FactoryGirl.create :session_with_presenter }
  end

  describe "GET rss" do
    render_views
    
    let(:session) { FactoryGirl.create :session_with_presenter }

  
    it "doesn't give access without authentication" do
      parameters = {:id => session.to_param,:format => :xml}
      get(:rss,parameters,nil)
      response.code.should == "401"
    end

    it "doesn't give access with incorrect authentication" do
      parameters = {:id => session.to_param,:format => :xml}
      login_with_wrong_basic_authentication
      get(:rss,parameters,nil)
      response.code.should == "401"
    end

    it "returns a basic RSS for a session " do

      parameters = {:id => session.to_param,:format => :xml}
      login_with_basic_authentication
      get(:rss,parameters,nil)
        
      #      puts
      #      puts "-------------"
      #      puts response.body
      #      puts "-------------"

      assigns(:this_session).should == session
      assigns(:last_update).to_s.should == session.updated_at.to_s
      doc = REXML::Document.new response.body
      doc.elements['rss/channel/title'][0].should == "Propile: #{session.title} updates"
      doc.elements.each("rss/channel/item") do |element|
        element.elements["title"][0].should == session.title
        element.elements["link"][0].should == ('http://test.host/sessions/' + session.id.to_s)
      end
    end
 

    it "returns a full RSS for a session with reviews and comment " do
      reviewer = Presenter.new :name => "Jane Presenter" , :email => "jane@company.com"
      review1 = Review.new :score => "3" , :things_i_like => "something" , :things_to_improve => "some ideas"
      review1.presenter = reviewer
      session.reviews << review1

      review2 = Review.new :score => "10" , :things_i_like => "Everything!"
      review2.presenter = reviewer
      session.reviews << review2

      comment = review1.comments.create :body => "Thank you for the review"
      comment.presenter = session.first_presenter
      comment.save

      session.updated_at = 5.days.ago
      review1.updated_at = 3.days.ago

      session.save

      login_with_basic_authentication
       
      get :rss,:id => session.to_param,:format => :xml
      #      puts
      #      puts "-------------"
      #      puts response.body
      #      puts "-------------"

      assigns(:this_session).should == session

      assigns(:last_update).to_s.should == comment.updated_at.to_s
      doc = REXML::Document.new response.body
      doc.elements['rss/channel/title'][0].should == "Propile: #{session.title} updates"
      
      items = REXML::XPath.match(doc,"//item")
      
      items.length.should == 4
      
      items[0].elements["title"][0].should == session.title
      items[0].elements["link"][0].should == ('http://test.host/sessions/' + session.id.to_s)

      items[1].elements["title"][0].should == "#{session.title} - Review by #{reviewer.name}"
      items[1].elements["link"][0].should == ('http://test.host/reviews/' + review1.id.to_s)

   
    end
  end
   
  describe "GET new" do
    # it "assigns a new session as @session" do
    #   get :new, {}
    #   assigns(:session).should be_a_new(Session)
    # end
    context "when submit_session is active" do
      it "assigns a new session as @session" do
        FactoryGirl.create :propile_config, :name => "submit_session_active", :value => "true"
        get :new, {}
        assigns(:session).should be_a_new(Session)
      end
    end
    context "when submit_session is not active" do
      it "raises an exception" do
        get :new, {}
        response.should redirect_to(new_account_session_path)
      end
      context "but when logged in as maintainer" do
        login_as :maintainer
        it "renders new" do
          get :new, {}
          response.should render_template('new')
        end
      end
    end
  end

  describe "GET thanks" do
    let(:session) { FactoryGirl.create :session_with_presenter }
    it "assigns the session @session" do
      get :thanks, :id => session.to_param
      assigns(:session).should == session
    end
  end

  describe "POST create" do
    let(:first_presenter_email) { "first_presenter@example.com" }
    let(:second_presenter_email) { "second_presenter@example.com" }

    def valid_creation_attributes
      @valid_creation_attributes ||= FactoryGirl.attributes_for(:session).merge :first_presenter_email => first_presenter_email, :second_presenter_email => second_presenter_email
    end

    describe "with valid params" do
      def do_post
        post :create, {:session => valid_creation_attributes}
      end
      it "creates a new Session" do
        expect {
          do_post
        }.to change(Session, :count).by(1)
      end

      it "assigns a newly created session as @session" do
        do_post
        assigns(:session).should be_a(Session)
        assigns(:session).should be_persisted
      end

      it "redirects to the thank you" do
        do_post
        response.should redirect_to(thanks_session_path(Session.last))
      end

      describe "notifications" do
        it "sends a confirmation mail to the presenters" do
          Postman.should_receive(:deliver).with(:session_submit, an_instance_of(Presenter), an_instance_of(Session)).twice
          do_post
        end
        it "sends a confirmation mail to one presenter if only one has been submitted" do
          Postman.should_receive(:deliver).with(:session_submit, an_instance_of(Presenter), an_instance_of(Session)).once
          post :create, {:session => valid_creation_attributes.merge(:second_presenter_email => '')}
        end
      end
    end

    describe "with invalid params" do
      def do_post
        post :create, {:session => {}, :presenters => []}
      end
      it "assigns a newly created but unsaved session as @session" do
        # Trigger the behavior that occurs when invalid params are submitted
        Session.any_instance.stub(:save).and_return(false)
        do_post
        assigns(:session).should be_a_new(Session)
      end

      it "re-renders the 'new' template" do
        # Trigger the behavior that occurs when invalid params are submitted
        Session.any_instance.stub(:save).and_return(false)
        do_post
        response.should render_template("new")
      end
    end
    describe "when captcha fails" do
      before do
        Captcha.stub(:verified?).with(controller) { false }
        post :create, {:session => valid_creation_attributes}
      end

      it "renders new view" do
        response.should be_success
        response.should render_template(:new)
      end

      it "sets the flash message to the exception result" do
        flash[:alert].should == I18n.t('sessions.captcha_error')
      end

      it "assigns the session with the filled in values" do
        assigns(:session).should be_a_new(Session)
        valid_creation_attributes.each do |key, value|
          assigns(:session).send(key).should == value
        end
      end
    end
  end

  context "when logged in" do
    login_as :presenter
    def valid_attributes
      FactoryGirl.attributes_for(:session_with_presenter)
    end

    describe "GET csv" do
      it "exports all sessions in csv format" do
        session = FactoryGirl.create :session_with_presenter
        get :csv
        response.should be_success
        CSV.parse(@response.body).size.should be 2
      end
    end

    describe "GET index" do
      it "assigns all sessions as @sessions" do
        session = FactoryGirl.create :session_with_presenter
        get :index, {}
        response.should be_success
        response.should render_template('index')
        assigns(:sessions).should eq([session])
      end

      it "assigns all sessions as @sessions ordered by number of reviews and then creation-date" do
        session_with_1_review = FactoryGirl.create :session_with_presenter
        r1 = FactoryGirl.create :review, :session => session_with_1_review
        session_with_1_review.reviews << r1
        session_with_1_review.reviews.count.should eq(1)
        session_with_1_review.created_at = "2012/06/13"
        session_with_1_review.save

        session_with_1_review_earlier = FactoryGirl.create :session_with_presenter
        r2 = FactoryGirl.create :review, :session => session_with_1_review_earlier
        session_with_1_review_earlier.reviews << r2
        session_with_1_review_earlier.reviews.count.should eq(1)
        session_with_1_review_earlier.created_at = "2012/06/10"
        session_with_1_review_earlier.save

        session_without_reviews = FactoryGirl.create :session_with_presenter
        session_without_reviews.reviews.count.should eq(0)
        session_without_reviews.created_at = "2012/06/20"
        session_without_reviews.save

        get :index, {}

        response.should be_success
        response.should render_template('index')
        #assigns(:sessions).should eq([session_without_reviews, session_with_1_review])
        assigns(:sessions).should eq([session_without_reviews, session_with_1_review_earlier, session_with_1_review])
      end

    end

    describe "GET show" do
      it "assigns the requested session as @session" do
        session = FactoryGirl.create :session_with_presenter
        get :show, {:id => session.to_param}
        assigns(:session).should eq(session)
      end
    end

    describe "GET program_board_card" do
      it "assigns the requested session as @session" do
        session = FactoryGirl.create :session_with_presenter
        get :show, {:id => session.to_param}
        assigns(:session).should eq(session)
      end
    end

    describe "GET edit" do
      it "assigns the requested session as @session" do
        session = FactoryGirl.create :session_with_presenter
        session.update_attribute :first_presenter_email, current_account.email # my session
        get :edit, {:id => session.to_param}
        assigns(:session).should eq(session)
      end
    end

    describe "PUT update" do
      describe "with valid params" do
        it "updates the requested session" do
          session = FactoryGirl.create :session_with_presenter
          # Assuming there are no other sessions in the database, this
          # specifies that the Session created on the previous line
          # receives the :update_attributes message with whatever params are
          # submitted in the request.
          Session.any_instance.should_receive(:update_attributes).with({'these' => 'params'})
          put :update, {:id => session.to_param, :session => {'these' => 'params'}}
        end

        it "assigns the requested session as @session" do
          session = FactoryGirl.create :session_with_presenter
          put :update, {:id => session.to_param, :session => valid_attributes}
          assigns(:session).should eq(session)
        end

        it "redirects to the session" do
          session = FactoryGirl.create :session_with_presenter
          put :update, {:id => session.to_param, :session => valid_attributes}
          response.should redirect_to(session)
        end
      end

      describe "with invalid params" do
        it "assigns the session as @session" do
          session = FactoryGirl.create :session_with_presenter
          # Trigger the behavior that occurs when invalid params are submitted
          Session.any_instance.stub(:save).and_return(false)
          put :update, {:id => session.to_param, :session => {}}
          assigns(:session).should eq(session)
        end

        it "re-renders the 'edit' template" do
          session = FactoryGirl.create :session_with_presenter
          # Trigger the behavior that occurs when invalid params are submitted
          Session.any_instance.stub(:save).and_return(false)
          put :update, {:id => session.to_param, :session => {}}
          response.should render_template("edit")
        end
      end
    end

    describe "DELETE destroy" do
      it "destroys the requested session" do
        session = FactoryGirl.create :session_with_presenter
        expect {
          delete :destroy, {:id => session.to_param}
        }.to change(Session, :count).by(-1)
      end

      it "redirects to the sessions list" do
        session = FactoryGirl.create :session_with_presenter
        delete :destroy, {:id => session.to_param}
        response.should redirect_to(sessions_url)
      end
    end
  end
end
